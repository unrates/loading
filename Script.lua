local UserInputService, CurrentCamera, n1, n2, u13, n3, u15, u16, u17, v18, v25, u29, u31, u32, u61, u62, t3, t4, v68, v78, u113, u117, n8, u123, u124, u125, v142, u144, u145, u146, u147, u148, u149, u150, u151, u152, u168, u169, u170, u171, u172, u173, u174, v179, u180, u181, u182, u183, u184, u185, u194, u195, id, u197, u198, u201, u202, u203, u204, u205, u206, u207, u208, v227, v234, v241, u254, u255, u256, u257, u258, u259, u260, u261, u262, u263, u264, u270, u271, u272, u273, u274, u275, u276, u277, u278, u279, u280, u281, u282, u283, u284, v292, v293, t32, u305

do
	local u9, u10, u98, u103, u153
	local Players = game:GetService("Players")
	local Workspace, RunService, LocalPlayer, u99, u100, u101, u102, u104, u105, u106, u107, v122, u126, u127, u128, u158, u159, u160, u161, u162, u163, u164, u165, t25, v216, uDim2, t26

	do
		local u95, u96, u97, v112, u212, u213, u214

		do
			local Lighting, v21, TextLabel

			do
				local ReplicatedStorage = game:GetService("ReplicatedStorage")

				Workspace = game:GetService("Workspace")
				UserInputService = game:GetService("UserInputService")
				RunService = game:GetService("RunService")
				Lighting = game:GetService("Lighting")
				LocalPlayer = Players.LocalPlayer
				CurrentCamera = Workspace.CurrentCamera
				u9 = false
				u10 = false
				n1 = 200
				n2 = 200
				u13 = false
				n3 = 70
				u15 = false
				u16 = false
				u17 = true
				v18 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
				v18:SetTheme("Crimson")

				do
					local _ = v18
				end

				do
					local u20 = UserInputService

					function v21(p1)
						local u370 = nil
						local p2Position = nil
						local Position = nil
						local InputBegan = p1.InputBegan
						local u374 = p1

						InputBegan:Connect(function(p2)
							if p2.UserInputType == Enum.UserInputType.MouseButton1 or p2.UserInputType == Enum.UserInputType.Touch then
								u370 = true
								p2Position = p2.Position
								Position = u374.Position
							end
						end)

						local InputChanged = p1.InputChanged
						local u376 = p1

						InputChanged:Connect(function(p3)
							if u370 then
								if p3.UserInputType == Enum.UserInputType.MouseMovement or p3.UserInputType == Enum.UserInputType.Touch then
									local v852 = p3.Position - p2Position

									u376.Position = UDim2.new(Position.X.Scale, Position.X.Offset + v852.X, Position.Y.Scale, Position.Y.Offset + v852.Y)
								end

								return
							end
						end)
						u20.InputEnded:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
								u370 = false
							end
						end)
					end
				end

				do
					local u22 = UserInputService
					local u23 = v18
					local u24 = v21

					function v25(p4, p5, p6, p7, p8, p9, p10)
						local v384 = "RuzSlider_" .. p4:gsub("%s+", "_")
						local v385 = game.CoreGui:FindFirstChild(v384)

						if not v385 then
							local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

							ScreenGui.Name = v384
							ScreenGui.ResetOnSpawn = false
							ScreenGui.DisplayOrder = 55
							ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

							local Frame = Instance.new("Frame", ScreenGui)

							Frame.Size = UDim2.new(0, 300, 0, 175)
							Frame.Position = UDim2.new(0.5, -150, 0.35, 0)
							Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
							Frame.BackgroundTransparency = 0.08
							Frame.BorderSizePixel = 0
							Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

							local UIStroke = Instance.new("UIStroke", Frame)

							UIStroke.Color = Color3.fromRGB(220, 38, 38)
							UIStroke.Thickness = 1.5
							UIStroke.Transparency = 0.15

							local TextLabel2 = Instance.new("TextLabel", Frame)

							TextLabel2.Size = UDim2.new(1, -44, 0, 36)
							TextLabel2.Position = UDim2.new(0, 12, 0, 0)
							TextLabel2.BackgroundTransparency = 1
							TextLabel2.Text = "RuzHub  —  " .. p4
							TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
							TextLabel2.Font = Enum.Font.GothamBold
							TextLabel2.TextSize = 14
							TextLabel2.TextXAlignment = Enum.TextXAlignment.Left

							local TextButton = Instance.new("TextButton", Frame)

							TextButton.Size = UDim2.new(0, 28, 0, 28)
							TextButton.Position = UDim2.new(1, -34, 0, 4)
							TextButton.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
							TextButton.Text = "X"
							TextButton.TextColor3 = Color3.new(1, 1, 1)
							TextButton.Font = Enum.Font.GothamBold
							TextButton.TextSize = 13
							Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 6)

							local MouseButton1Click = TextButton.MouseButton1Click
							local u392 = ScreenGui

							MouseButton1Click:Connect(function()
								u392:Destroy()
							end)

							local u393 = p7
							local TextLabel3 = Instance.new("TextLabel", Frame)

							TextLabel3.Size = UDim2.new(1, 0, 0, 22)
							TextLabel3.Position = UDim2.new(0, 0, 0, 38)
							TextLabel3.BackgroundTransparency = 1

							TextLabel3.Text = p4 .. ":  " .. tostring(p7)
							TextLabel3.TextColor3 = Color3.fromRGB(210, 210, 210)
							TextLabel3.Font = Enum.Font.Gotham
							TextLabel3.TextSize = 13

							local Frame2 = Instance.new("Frame", Frame)

							Frame2.Size = UDim2.new(1, -30, 0, 10)
							Frame2.Position = UDim2.new(0, 15, 0, 72)
							Frame2.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
							Frame2.BorderSizePixel = 0
							Instance.new("UICorner", Frame2).CornerRadius = UDim.new(1, 0)

							local v397 = (p7 - p5) / (p6 - p5)
							local Frame3 = Instance.new("Frame", Frame2)

							Frame3.Size = UDim2.new(v397, 0, 1, 0)
							Frame3.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
							Frame3.BorderSizePixel = 0
							Instance.new("UICorner", Frame3).CornerRadius = UDim.new(1, 0)

							local TextButton2 = Instance.new("TextButton", Frame2)

							TextButton2.Size = UDim2.new(0, 26, 0, 26)
							TextButton2.Position = UDim2.new(v397, -13, 0.5, -13)
							TextButton2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							TextButton2.Text = ""
							TextButton2.AutoButtonColor = false
							TextButton2.BorderSizePixel = 0
							Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(1, 0)

							local u400 = Frame2
							local u401 = p5
							local u402 = p6
							local u403 = p8
							local u404 = Frame3
							local u405 = TextButton2
							local u406 = TextLabel3
							local u407 = p4

							local function v408(p11)
								local v855 = (p11 - u400.AbsolutePosition.X) / u400.AbsoluteSize.X
								local v856 = math.clamp(v855, 0, 1)
								local v857 = u401 + v856 * (u402 - u401)

								u393 = math.round(v857)

								if u403 and u403 > 0 then
									local v858 = u393 / u403

									u393 = math.round(v858) * u403
								end

								local v859 = (u393 - u401) / (u402 - u401)

								u404.Size = UDim2.new(v859, 0, 1, 0)
								u405.Position = UDim2.new(v859, -13, 0.5, -13)

								u406.Text = u407 .. ":  " .. tostring(u393)
							end

							local u409 = false

							TextButton2.InputBegan:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
									u409 = true
								end
							end)

							local InputBegan = Frame2.InputBegan
							local u411 = v408

							InputBegan:Connect(function(p12)
								if p12.UserInputType == Enum.UserInputType.MouseButton1 or p12.UserInputType == Enum.UserInputType.Touch then
									u409 = true
									u411(p12.Position.X)
								end
							end)

							local InputChanged = u22.InputChanged
							local u413 = v408

							InputChanged:Connect(function(p13)
								if u409 then
									if p13.UserInputType == Enum.UserInputType.MouseMovement or p13.UserInputType == Enum.UserInputType.Touch then
										u413(p13.Position.X)
									end

									return
								end
							end)
							u22.InputEnded:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
									u409 = false
								end
							end)

							local Frame4 = Instance.new("Frame", Frame)

							Frame4.Size = UDim2.new(1, -20, 0, 36)
							Frame4.Position = UDim2.new(0, 10, 0, 126)
							Frame4.BackgroundTransparency = 1

							local TextButton3 = Instance.new("TextButton", Frame4)

							TextButton3.Size = UDim2.new(0.48, 0, 1, 0)
							TextButton3.BackgroundColor3 = Color3.fromRGB(20, 160, 20)
							TextButton3.Text = "Apply"
							TextButton3.TextColor3 = Color3.new(1, 1, 1)
							TextButton3.Font = Enum.Font.GothamBold
							TextButton3.TextSize = 13
							Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 6)

							local MouseButton1Click2 = TextButton3.MouseButton1Click
							local u417 = p9
							local u418 = p4

							MouseButton1Click2:Connect(function()
								u417(u393)

								local v867 = u418 .. " set to " .. u393

								u23:Notify({
									Title = "RuzHub",
									Content = tostring(v867),
									Duration = 3,
									Icon = "bell",
								})
							end)

							local TextButton4 = Instance.new("TextButton", Frame4)

							TextButton4.Size = UDim2.new(0.48, 0, 1, 0)
							TextButton4.Position = UDim2.new(0.52, 0, 0, 0)
							TextButton4.BackgroundColor3 = Color3.fromRGB(160, 20, 20)
							TextButton4.Text = "Reset"
							TextButton4.TextColor3 = Color3.new(1, 1, 1)
							TextButton4.Font = Enum.Font.GothamBold
							TextButton4.TextSize = 13
							Instance.new("UICorner", TextButton4).CornerRadius = UDim.new(0, 6)

							local MouseButton1Click3 = TextButton4.MouseButton1Click
							local u421 = p10
							local u422 = ScreenGui

							MouseButton1Click3:Connect(function()
								u421()
								u422:Destroy()
							end)
							u24(Frame)

							return
						end

						v385:Destroy()
					end
				end

				do
					local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

					ScreenGui.Name = "RuzLGStar"
					ScreenGui.ResetOnSpawn = false
					ScreenGui.DisplayOrder = 40
					TextLabel = Instance.new("TextLabel", ScreenGui)
				end

				TextLabel.Size = UDim2.new(0, 28, 0, 28)
				TextLabel.Position = UDim2.new(1, -34, 0, 4)
				TextLabel.BackgroundTransparency = 1
				TextLabel.Text = "★"
				TextLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
				TextLabel.Font = Enum.Font.GothamBold
				TextLabel.TextSize = 22
				TextLabel.Visible = false

				do
					local t2, n4, u82
					local Part = Instance.new("Part")

					Part.Name = "RuzPredictionPart"
					Part.Size = Vector3.new(0.5, 0.5, 0.5)
					Part.Anchored = true
					Part.CanCollide = false
					Part.Transparency = 1
					Part.Parent = Workspace
					u29 = nil

					do
						local v35

						do
							local u30 = Workspace

							u31 = nil
							u32 = nil

							local color3 = Color3.fromRGB(255, 215, 0)

							local function u34(p14)
								if u29 then
									u29:Destroy()
									u29 = nil
								end

								local Part2 = Instance.new("Part")

								Part2.Name = "RuzGunMarker"
								Part2.Size = Vector3.new(1.5, 0.15, 1.5)
								Part2.Anchored = true
								Part2.CanCollide = false
								Part2.CastShadow = false
								Part2.Material = Enum.Material.Neon
								Part2.Color = Color3.fromRGB(50, 255, 80)
								Part2.Transparency = 0.25
								Part2.CFrame = CFrame.new(p14)
								Part2.Parent = u30

								local spawn = task.spawn
								local u426 = Part2

								spawn(function()
									while u426 and u426.Parent do
										for i = 0, 1, 0.05 do
											if not u426 or not u426.Parent then
												break
											end
											local v870 = i * 3.141592653589793

											u426.Transparency = 0.25 + 0.5 * math.sin(v870)
											task.wait(0.03)
										end
									end
								end)
								u29 = Part2
							end

							function v35(p15)
								if u17 then
									if u31 then
										u31:Destroy()
										u31 = nil
									end

									if u32 then
										u32:Destroy()
										u32 = nil
									end

									local Highlight = Instance.new("Highlight")

									Highlight.Adornee = p15
									Highlight.FillColor = color3
									Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
									Highlight.FillTransparency = 0.35
									Highlight.OutlineTransparency = 0
									Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
									Highlight.Parent = p15
									u31 = Highlight

									local v429 = p15:FindFirstChild("Handle")
										or (p15:IsA("Model") and p15.PrimaryPart or p15:FindFirstChildWhichIsA("BasePart"))
										or p15:IsA("BasePart") and p15

									if not v429 then
										if p15:IsA("Model") then
											u34(p15:GetModelCFrame().Position + Vector3.new(0, 0.1, 0))
										end

										return
									end

									u34(v429.Position + Vector3.new(0, 0.1, 0))

									local BillboardGui = Instance.new("BillboardGui")

									BillboardGui.Adornee = v429
									BillboardGui.Size = UDim2.new(0, 130, 0, 36)
									BillboardGui.StudsOffset = Vector3.new(0, 4, 0)
									BillboardGui.AlwaysOnTop = true
									BillboardGui.MaxDistance = 300
									BillboardGui.Parent = v429

									local Frame = Instance.new("Frame", BillboardGui)

									Frame.Size = UDim2.new(1, 0, 1, 0)
									Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
									Frame.BackgroundTransparency = 0.4
									Frame.BorderSizePixel = 0
									Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

									local UIStroke = Instance.new("UIStroke", Frame)

									UIStroke.Color = color3
									UIStroke.Thickness = 1.5
									UIStroke.Transparency = 0.1

									local TextLabel4 = Instance.new("TextLabel", Frame)

									TextLabel4.Size = UDim2.new(1, 0, 1, 0)
									TextLabel4.BackgroundTransparency = 1
									TextLabel4.Text = "GUN ON MAP"
									TextLabel4.TextColor3 = color3
									TextLabel4.Font = Enum.Font.GothamBlack
									TextLabel4.TextSize = 13
									TextLabel4.TextStrokeTransparency = 0.4
									TextLabel4.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
									u32 = BillboardGui

									return
								end
							end
						end

						do
							local _ = Workspace
							local _ = v35
							local _ = v18
						end

						do
							local u42

							do
								local t1 = {}
								local u40 = v35
								local u41 = v18

								function u42(p16)
									if not t1[p16] then
										t1[p16] = true
										p16.ChildAdded:Connect(function(child)
											if child.Name == "GunDrop" then
												task.wait(0.1)

												if u17 then
													u40(child)
												end

												u41:Notify({
													Title = "XenaScript",
													Content = tostring("Gun dropped on the map!"),
													Duration = 3,
													Icon = "bell",
												})
											end

											if child:IsA("Model") or child:IsA("Folder") then
												u42(child)
											end
										end)
										p16.ChildRemoved:Connect(function(child)
											if child.Name == "GunDrop" then
												if u31 then
													u31:Destroy()
													u31 = nil
												end

												if u32 then
													u32:Destroy()
													u32 = nil
												end

												if u29 then
													u29:Destroy()
													u29 = nil
												end
											end
										end)

										for _, child in ipairs(p16:GetChildren()) do
											if child:IsA("Model") or child:IsA("Folder") then
												u42(child)
											end
										end

										return
									end
								end
							end

							u42(Workspace)

							local ChildAdded = Workspace.ChildAdded
							local u44 = u42
							local u45 = v35
							local u46 = v18

							ChildAdded:Connect(function(p17)
								if p17:IsA("Model") or p17:IsA("Folder") then
									u44(p17)
								end

								if p17.Name == "GunDrop" then
									task.wait(0.1)

									if u17 then
										u45(p17)
									end

									u46:Notify({
										Title = "RuzHub",
										Content = tostring("Gun dropped on the map!"),
										Duration = 3,
										Icon = "bell",
									})
								end
							end)
						end

						do
							local spawn = task.spawn
							local u48 = Workspace
							local u49 = v35
							local u50 = v18

							spawn(function()
								task.wait(1.5)

								local GunDrop = u48:FindFirstChild("GunDrop", true)

								if GunDrop then
									if u17 then
										u49(GunDrop)
									end

									u50:Notify({
										Title = "RuzHub",
										Content = tostring("Gun dropped on the map!"),
										Duration = 3,
										Icon = "bell",
									})
								end
							end)
						end

						do
							local u51 = Workspace
							local u52 = v35
							local u53 = v18

							for _, player in ipairs(Players:GetPlayers()) do
								if player ~= LocalPlayer then
									task.spawn(function(p18)
										local u441 = p18

										if p18.Character then
											local Character = p18.Character

											if Character then
												local Humanoid = Character:WaitForChild("Humanoid", 5)

												if Humanoid then
													local Died = Humanoid.Died
													local u445 = p18
													local u446 = Character

													Died:Connect(function()
														if u445.Backpack:FindFirstChild("Gun") or u446:FindFirstChild("Gun") then
															task.delay(0.8, function()
																local GunDrop = u51:FindFirstChild("GunDrop", true)

																if GunDrop then
																	if u17 then
																		u52(GunDrop)
																	end

																	u53:Notify({
																		Title = "RuzHub",
																		Content = tostring("Gun dropped on the map!"),
																		Duration = 3,
																		Icon = "bell",
																	})
																end
															end)
														end
													end)
												end
											end
										end

										p18.CharacterAdded:Connect(function(character)
											if character then
												local Humanoid = character:WaitForChild("Humanoid", 5)

												if Humanoid then
													local Died = Humanoid.Died
													local u876 = character

													Died:Connect(function()
														if u441.Backpack:FindFirstChild("Gun") or u876:FindFirstChild("Gun") then
															task.delay(0.8, function()
																local GunDrop = u51:FindFirstChild("GunDrop", true)

																if GunDrop then
																	if u17 then
																		u52(GunDrop)
																	end

																	u53:Notify({
																		Title = "RuzHub",
																		Content = tostring("Gun dropped on the map!"),
																		Duration = 3,
																		Icon = "bell",
																	})
																end
															end)
														end
													end)

													return
												end

												return
											end
										end)
									end, player)
								end
							end
						end

						local PlayerAdded = Players.PlayerAdded
						local u57 = LocalPlayer
						local u58 = Workspace
						local u59 = v35
						local u60 = v18

						PlayerAdded:Connect(function(p19)
							if p19 ~= u57 then
								local u448 = p19

								if p19.Character then
									local Character = p19.Character

									if Character then
										local Humanoid = Character:WaitForChild("Humanoid", 5)

										if Humanoid then
											local Died = Humanoid.Died
											local u452 = p19
											local u453 = Character

											Died:Connect(function()
												if u452.Backpack:FindFirstChild("Gun") or u453:FindFirstChild("Gun") then
													task.delay(0.8, function()
														local GunDrop = u58:FindFirstChild("GunDrop", true)

														if GunDrop then
															if u17 then
																u59(GunDrop)
															end

															u60:Notify({
																Title = "RuzHub",
																Content = tostring("Gun dropped on the map!"),
																Duration = 3,
																Icon = "bell",
															})
														end
													end)
												end
											end)
										end
									end
								end

								p19.CharacterAdded:Connect(function(character)
									if character then
										local Humanoid = character:WaitForChild("Humanoid", 5)

										if Humanoid then
											local Died = Humanoid.Died
											local u880 = character

											Died:Connect(function()
												if u448.Backpack:FindFirstChild("Gun") or u880:FindFirstChild("Gun") then
													task.delay(0.8, function()
														local GunDrop = u58:FindFirstChild("GunDrop", true)

														if GunDrop then
															if u17 then
																u59(GunDrop)
															end

															u60:Notify({
																Title = "RuzHub",
																Content = tostring("Gun dropped on the map!"),
																Duration = 3,
																Icon = "bell",
															})
														end
													end)
												end
											end)

											return
										end

										return
									end
								end)
							end
						end)
						u61 = false
						u62 = nil
						t2 = {}
						n4 = 0
						t3 = {
							Murderer = true,
							Sheriff = true,
							Hero = true,
							Innocent = true,
							Self = true,
						}
						t4 = {
							Murderer = Color3.fromRGB(255, 40, 40),
							Sheriff = Color3.fromRGB(40, 130, 255),
							Hero = Color3.fromRGB(255, 215, 0),
							Innocent = Color3.fromRGB(0, 220, 0),
						}

						local u67 = Players

						function v68()
							for _, player in ipairs(u67:GetPlayers()) do
								if player.Character then
									local RuzHub_ESP = player.Character:FindFirstChild("RuzHub_ESP")

									if RuzHub_ESP then
										RuzHub_ESP:Destroy()
									end
								end
							end

							t2 = {}
							n4 = 0
						end
					end

					do
						local u69 = ReplicatedStorage
						local u70 = v18
						local u71 = RunService
						local u72 = Players

						local function u73(p20)
							local s1 = "Innocent"
							local v456 = t2[p20.Name]

							if v456 then
								local v457 = v456.Role or (v456.role or (v456.Team or ""))
								local v458 = tostring(v457):lower()

								if v458:find("murd") then
									return "Murderer"
								end

								if v458:find("sheriff") or v458:find("gun") then
									return "Sheriff"
								end

								if v458:find("hero") then
									s1 = "Hero"
								end
							end

							return s1
						end

						local u74 = t3
						local u75 = LocalPlayer

						local function u76(p21, p22)
							local v461 = p21:FindFirstChild("RuzHub_ESP") or Instance.new("Highlight")

							v461.Name = "RuzHub_ESP"
							v461.Parent = p21
							v461.FillColor = p22
							v461.FillTransparency = 0.7
							v461.OutlineColor = Color3.fromRGB(255, 255, 255)
							v461.OutlineTransparency = 0.15
							v461.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						end

						local u77 = t4

						function v78()
							local GetCurrentPlayerData = u69:FindFirstChild("GetCurrentPlayerData", true)

							if GetCurrentPlayerData and GetCurrentPlayerData:IsA("RemoteFunction") then
								if u62 then
									u62:Disconnect()
									u62 = nil
								end

								local Heartbeat = u71.Heartbeat
								local u469 = GetCurrentPlayerData

								u62 = Heartbeat:Connect(function()
									if u61 then
										if tick() - n4 > 0.5 then
											local ok, result = pcall(function()
												return u469:InvokeServer()
											end)

											if ok and type(result) == "table" then
												t2 = result
											end

											n4 = tick()
										end

										for _, player in ipairs(u72:GetPlayers()) do
											if player.Character then
												local v885 = u73(player)
												local v886 = u74[v885]

												if player == u75 and not u74.Self then
													v886 = false
												end

												if not v886 then
													local RuzHub_ESP = player.Character:FindFirstChild("RuzHub_ESP")

													if RuzHub_ESP then
														RuzHub_ESP:Destroy()
													end
												else
													u76(player.Character, u77[v885])
												end
											end
										end

										return
									end
								end)

								return
							end

							u70:Notify({
								Title = "RuzHub",
								Content = tostring("ESP remote not found!"),
								Duration = 3,
								Icon = "bell",
							})
							u61 = false
						end
					end

					do
						local _ = v68
						local _ = v78
						local _ = v68

						u82 = nil

						local u83 = LocalPlayer
						local u84 = Players
						local RenderStepped = RunService.RenderStepped

						local function u86()
							local Character = u83.Character
							local v474 = Character and Character:FindFirstChild("HumanoidRootPart")

							if v474 then
								local v476 = u83.Backpack:FindFirstChild("Knife") or u83.Character and u83.Character:FindFirstChild("Knife")
								local v478 = u83.Backpack:FindFirstChild("Gun") or u83.Character and u83.Character:FindFirstChild("Gun")
								local v479 = nil
								local n5 = 1e999

								for _, player in ipairs(u84:GetPlayers()) do
									if player ~= u83 and player.Character then
										local Character2 = player.Character
										local Humanoid = Character2:FindFirstChildOfClass("Humanoid")

										if Humanoid and Humanoid.Health > 0 then
											local HumanoidRootPart = Character2:FindFirstChild("HumanoidRootPart")

											if HumanoidRootPart then
												local v486 = player.Backpack:FindFirstChild("Knife")
													or player.Character and player.Character:FindFirstChild("Knife")
												local v487 = player.Backpack:FindFirstChild("Gun")
													or player.Character and player.Character:FindFirstChild("Gun")
												local Magnitude = (HumanoidRootPart.Position - v474.Position).Magnitude
												local v489 = false

												if not v476 then
													if not v478 then
														if v486 then
															v489 = true
															Magnitude = Magnitude - 1000
														end

														if v487 then
															v489 = true
														end
													elseif v487 or v486 then
														v489 = true
													end
												elseif v486 then
													v489 = true
												end

												if v489 and Magnitude < n5 then
													n5 = Magnitude
													v479 = Character2
												end
											end
										end
									end
								end

								if not v479 then
									for _, player in ipairs(u84:GetPlayers()) do
										if player ~= u83 and player.Character then
											local Character3 = player.Character
											local Humanoid = Character3:FindFirstChildOfClass("Humanoid")
											local HumanoidRootPart = Character3:FindFirstChild("HumanoidRootPart")

											if Humanoid and Humanoid.Health > 0 and HumanoidRootPart then
												local Magnitude = (HumanoidRootPart.Position - v474.Position).Magnitude

												if Magnitude < n5 then
													n5 = Magnitude
													v479 = Character3
												end
											end
										end
									end
								end

								return v479
							end

							return nil
						end

						local u87 = LocalPlayer
						local u88 = Part

						RenderStepped:Connect(function()
							local v496 = u86()

							u82 = v496

							if v496 then
								local Character = u87.Character
								local v498 = Character and Character:FindFirstChild("HumanoidRootPart")

								if v498 then
									local v499 = v496:FindFirstChild("UpperTorso") or (v496:FindFirstChild("Torso") or v496:FindFirstChild("HumanoidRootPart"))
									local Humanoid = v496:FindFirstChildOfClass("Humanoid")

									if v499 then
										local Position = v499.Position
										local v502 = (Position - v498.Position).Magnitude / 250

										if u13 then
											local ok, result = pcall(function()
												return u87:GetNetworkPing()
											end)

											if ok and result then
												v502 = v502 + result * 0.5
											end
										end

										local AssemblyLinearVelocity = v499.AssemblyLinearVelocity

										if Humanoid then
											local State = Humanoid:GetState()

											if State == Enum.HumanoidStateType.Freefall or State == Enum.HumanoidStateType.Jumping then
												AssemblyLinearVelocity =
													Vector3.new(AssemblyLinearVelocity.X, AssemblyLinearVelocity.Y * 0.35, AssemblyLinearVelocity.Z)
											end
										end

										u88.CFrame = CFrame.new(Position + AssemblyLinearVelocity * v502)

										return
									end

									return
								end

								return
							end
						end)
					end

					local u89 = LocalPlayer
					local u90 = v18
					local u91 = Part
					local u92 = LocalPlayer
					local u93 = v18
					local u94 = Players

					u95 = LocalPlayer

					function u96()
						local Character = u92.Character

						if Character then
							local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

							if HumanoidRootPart then
								local v519 = u92.Backpack:FindFirstChild("Knife") or Character:FindFirstChild("Knife")

								if v519 then
									if Character ~= v519.Parent then
										Character.Humanoid:EquipTool(v519)
										task.wait(0)
									end

									local v520 = u82

									if not u82 then
										local n6 = 1e999

										for _, player in ipairs(u94:GetPlayers()) do
											if player ~= u92 and player.Character then
												local HumanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
												local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")

												if HumanoidRootPart2 and Humanoid and Humanoid.Health > 0 then
													local Magnitude = (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude

													if Magnitude < n6 then
														n6 = Magnitude
														v520 = player.Character
													end
												end
											end
										end
									end

									if v520 then
										local HumanoidRootPart3 = v520:FindFirstChild("HumanoidRootPart")

										if HumanoidRootPart3 then
											local v528 = v520:FindFirstChild("UpperTorso") or (v520:FindFirstChild("Torso") or HumanoidRootPart3)
											local AssemblyLinearVelocity = HumanoidRootPart3.AssemblyLinearVelocity
											local Magnitude = (v528.Position - HumanoidRootPart.Position).Magnitude
											local n7 = 0

											if u13 then
												local ok, result = pcall(function()
													return u92:GetNetworkPing()
												end)

												n7 = ok and result or 0
											end

											local v534 = v528.Position
												+ Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z) * (Magnitude / 65 + n7 * 0.5)
											local _pcall = pcall
											local u536 = v519
											local u537 = HumanoidRootPart
											local u538 = v534

											pcall(function()
												local KnifeThrown = u536:WaitForChild("Events"):WaitForChild("KnifeThrown")
												local cFrame = CFrame.new(u537.Position, u538)
												local v895 = (function(...)
													local t5 = { ... }

													t5.n = select("#", ...)

													return t5
												end)(CFrame.new(u538))

												KnifeThrown:FireServer(cFrame, unpack(v895, 1, v895.n))
											end)

											return
										end

										return
									end

									u93:Notify({
										Title = "RuzHub",
										Content = tostring("No target found!"),
										Duration = 3,
										Icon = "bell",
									})

									return
								end

								u93:Notify({
									Title = "RuzHub",
									Content = tostring("No knife in inventory!"),
									Duration = 3,
									Icon = "bell",
								})

								return
							end

							return
						end
					end
					function u97()
						local Character = u89.Character

						if Character then
							local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

							if HumanoidRootPart then
								local v509 = u89.Backpack:FindFirstChild("Gun") or Character:FindFirstChild("Gun")

								if v509 then
									if u82 then
										if Character ~= v509.Parent then
											Character.Humanoid:EquipTool(v509)
											task.wait(0)
										end

										local CFramePosition = u91.CFrame.Position
										local v511 = HumanoidRootPart.Position + Vector3.new(0, 1, 0)
										local cFrame = CFrame.new(v511, CFramePosition)
										local _pcall = pcall
										local u514 = v509
										local u515 = cFrame
										local u516 = CFramePosition

										pcall(function()
											local Shoot = u514:WaitForChild("Shoot")
											local v890 = (function(...)
												local t6 = { ... }

												t6.n = select("#", ...)

												return t6
											end)(CFrame.new(u516))

											Shoot:FireServer(u515, unpack(v890, 1, v890.n))
										end)

										return
									end

									u90:Notify({
										Title = "RuzHub",
										Content = tostring("No target found."),
										Duration = 3,
										Icon = "bell",
									})

									return
								end

								u90:Notify({
									Title = "RuzHub",
									Content = tostring("No gun in inventory!"),
									Duration = 3,
									Icon = "bell",
								})

								return
							end

							return
						end
					end
				end

				u98 = false
				u99 = LocalPlayer
				u100 = UserInputService
				u101 = CurrentCamera
				u102 = RunService
				u103 = false
				u104 = LocalPlayer
				u105 = UserInputService
				u106 = CurrentCamera
				u107 = RunService

				local spawn = task.spawn
				local u109 = ReplicatedStorage

				spawn(function()
					while true do
						task.wait(2)
						pcall(function()
							u109.Remotes.Extras.ReplicateToy:InvokeServer("FakeBomb")
							u109.Remotes.Extras.ReplicateToy:InvokeServer("GoldBomb")
						end)
					end
				end)

				local u110 = LocalPlayer
				local u111 = v18

				function v112(p23, p24)
					local Character = u110.Character

					if Character then
						local v609 = u110.Backpack:FindFirstChild(p23) or Character:FindFirstChild(p23)

						if v609 then
							local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

							if HumanoidRootPart then
								if Character ~= v609.Parent then
									Character.Humanoid:EquipTool(v609)
									task.wait()
								end

								local _pcall = pcall
								local u612 = v609
								local u613 = HumanoidRootPart

								pcall(function()
									u612.Remote:FireServer(CFrame.new(u613.Position + u613.CFrame.LookVector * 1.5 + Vector3.new(0, -3, 0)), 50)
								end)
								Character.Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
								HumanoidRootPart.AssemblyLinearVelocity =
									Vector3.new(HumanoidRootPart.AssemblyLinearVelocity.X, 62, HumanoidRootPart.AssemblyLinearVelocity.Z)

								if not p24 then
									task.spawn(function()
										u10 = true
										task.wait(21)
										u10 = false
									end)

									return
								end

								task.spawn(function()
									u9 = true
									task.wait(4)
									u9 = false
								end)

								return
							end

							return
						end

						local v614 = "No " .. p23 .. " found!"

						u111:Notify({
							Title = "RuzHub",
							Content = tostring(v614),
							Duration = 3,
							Icon = "bell",
						})

						return
					end
				end

				u113 = false
				local u114 = nil

				local u115 = RunService

				local function v116(p25)
					local Humanoid = p25:WaitForChild("Humanoid")

					if u114 then
						u114:Disconnect()
					end

					local RenderStepped = u115.RenderStepped
					local u618 = Humanoid

					u114 = RenderStepped:Connect(function()
						if u113 then
							local State = u618:GetState()

							u618.WalkSpeed = (State == Enum.HumanoidStateType.Jumping or State == Enum.HumanoidStateType.Freefall)
									and (u618.MoveDirection.Magnitude > 0 and n2)
								or 16

							return
						end

						u618.WalkSpeed = 16
					end)
				end

				LocalPlayer.CharacterAdded:Connect(v116)

				if LocalPlayer.Character then
					task.spawn(v116, LocalPlayer.Character)
				end

				u117 = false
				local u118 = nil
				n8 = 0.5

				local u120 = RunService
				local u121 = CurrentCamera

				function v122(p26)
					u117 = p26

					if not p26 then
						if u118 then
							u118:Disconnect()
							u118 = nil
						end

						return
					end

					if u118 then
						u118:Disconnect()
					end

					u118 = u120.RenderStepped:Connect(function()
						u121.CFrame = u121.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, n8, 0, 0, 0, 1)
					end)
				end
			end

			u123 = v25
			u124 = v122
			u125 = v18
			u126 = Workspace
			u127 = v18
			u128 = LocalPlayer

			do
				local t7 = {}
				local t8 = {
					name = "Red",
					id = "98490421374360",
					color = Color3.fromRGB(200, 50, 50),
				}
				local t9 = {
					name = "Pink",
					id = "95000769820905",
					color = Color3.fromRGB(220, 100, 180),
				}
				local t10 = {
					name = "Pink 2",
					id = "82988835868087",
					color = Color3.fromRGB(200, 80, 160),
				}
				local t11 = {
					name = "Green",
					id = "5036205687",
					color = Color3.fromRGB(50, 180, 80),
				}
				local t12 = {
					name = "Black",
					id = "80807192441609",
					color = Color3.fromRGB(30, 30, 30),
				}
				local t13 = {
					name = "Cosmic",
					id = "77816282467771",
					color = Color3.fromRGB(80, 40, 160),
				}
				local t14 = {
					name = "Yellow",
					id = "2669948520",
					color = Color3.fromRGB(220, 190, 40),
				}

				t7[1] = t8
				t7[2] = t9
				t7[3] = t10
				t7[4] = t11
				t7[5] = t12
				t7[6] = t13
				t7[7] = t14
				local u137 = nil
				local u138 = false

				local u139 = Lighting;

				(function()
					local Sky = u139:FindFirstChildOfClass("Sky")

					if Sky then
						u137 = {
							SkyboxBk = Sky.SkyboxBk,
							SkyboxDn = Sky.SkyboxDn,
							SkyboxFt = Sky.SkyboxFt,
							SkyboxLf = Sky.SkyboxLf,
							SkyboxRt = Sky.SkyboxRt,
							SkyboxUp = Sky.SkyboxUp,
						}
					end
				end)()

				local u140 = Lighting
				local u141 = v18

				function v142()
					for _, child in pairs(u140:GetChildren()) do
						if child:IsA("Sky") or child:IsA("Atmosphere") or child:IsA("Clouds") then
							child:Destroy()
						end
					end

					if u137 then
						local Sky = Instance.new("Sky", u140)

						for k, v in pairs(u137) do
							Sky[k] = v
						end
					end

					u138 = false
					u141:Notify({
						Title = "RuzHub",
						Content = tostring("Skybox restored to default."),
						Duration = 3,
						Icon = "bell",
					})
				end

				local u143 = Lighting

				function u144(p27)
					for _, child in pairs(u143:GetChildren()) do
						if child:IsA("Sky") or child:IsA("Atmosphere") or child:IsA("Clouds") then
							child:Destroy()
						end
					end

					local Sky = Instance.new("Sky", u143)

					Sky.Name = "RuzHub_CustomSky"

					local v638 = "rbxassetid://" .. tostring(p27)

					Sky.SkyboxBk = v638
					Sky.SkyboxDn = v638
					Sky.SkyboxFt = v638
					Sky.SkyboxLf = v638
					Sky.SkyboxRt = v638
					Sky.SkyboxUp = v638
					Sky.SunTextureId = ""
					Sky.MoonTextureId = ""
					Sky.SunAngularSize = 0
					Sky.StarCount = 0
					u143.ClockTime = 14
					u143.Brightness = 2
					u143.GlobalShadows = false
					u143.FogEnd = 999999
					u138 = true
				end

				u145 = v18
				u146 = v142
				u147 = t7
				u148 = v21
				u149 = false
				u150 = nil
				u151 = RunService
				u152 = LocalPlayer
				getgenv().RuzOldPos = nil
				getgenv().RuzFPDH = Workspace.FallenPartsDestroyHeight
				u153 = false

				local u154 = LocalPlayer
				local u155 = v18
				local u156 = Workspace

				local function v157(p28)
					if not u153 then
						local Character = u154.Character

						if Character then
							local Humanoid = Character:FindFirstChildOfClass("Humanoid")

							if Humanoid then
								local RootPart = Humanoid.RootPart

								if RootPart then
									local Character4 = p28.Character

									if Character4 then
										local Humanoid2 = Character4:FindFirstChildOfClass("Humanoid")
										local v676 = Humanoid2 and Humanoid2.RootPart
										local Head = Character4:FindFirstChild("Head")
										local Accessory = Character4:FindFirstChildOfClass("Accessory")
										local v679 = Accessory and Accessory:FindFirstChild("Handle")

										if RootPart.Velocity.Magnitude < 50 then
											getgenv().RuzOldPos = RootPart.CFrame
										end

										if not Humanoid2 or not Humanoid2.Sit then
											local v680 = Head or (v679 or Humanoid2)

											if v680 then
												u156.CurrentCamera.CameraSubject = v680
											end

											if Character4:FindFirstChildWhichIsA("BasePart") then
												local u681 = RootPart
												local u682 = Character
												local u683 = RootPart
												local u684 = Humanoid2

												local function u685(p29, p30, p31)
													u681.CFrame = CFrame.new(p29.Position) * p30 * p31

													local _pcall = pcall
													local u914 = p29
													local u915 = p30
													local u916 = p31

													pcall(function()
														u682:SetPrimaryPartCFrame(CFrame.new(u914.Position) * u915 * u916)
													end)
													u681.Velocity = Vector3.new(90000000, 900000000, 90000000)
													u681.RotVelocity = Vector3.new(900000000, 900000000, 900000000)
												end

												u153 = true
												u156.FallenPartsDestroyHeight = (0 / 0)

												local BodyVelocity = Instance.new("BodyVelocity")

												BodyVelocity.Velocity = Vector3.new(0, 0, 0)
												BodyVelocity.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)
												BodyVelocity.Parent = RootPart
												Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

												local v687 = v676 or (Head or v679)

												if not v687 then
													local v688 = p28.Name .. " — no valid fling part."

													u155:Notify({
														Title = "RuzHub",
														Content = tostring(v688),
														Duration = 3,
														Icon = "bell",
													})
												else
													(function(p32)
														local v918 = tick() + 2.5
														local n9 = 0

														while u683 and u684 do
															local Magnitude = p32.Velocity.Magnitude

															if not (Magnitude < 40) then
																local MoveDirection = u684.MoveDirection
																local WalkSpeed = u684.WalkSpeed

																u685(
																	p32,
																	CFrame.new(MoveDirection.X * WalkSpeed * 0.12, 3, MoveDirection.Z * WalkSpeed * 0.12),
																	CFrame.Angles(1.5707963267948966, 0, 0)
																)
																u683.Velocity = Vector3.new(900000000, 900000000, 900000000)
																task.wait()
																u685(
																	p32,
																	CFrame.new(-MoveDirection.X * WalkSpeed * 0.06, -3, -MoveDirection.Z * WalkSpeed * 0.06),
																	CFrame.Angles(0, 0, 0)
																)
																u683.Velocity = Vector3.new(900000000, 900000000, 900000000)
																task.wait()
																u685(
																	p32,
																	CFrame.new(MoveDirection.X * WalkSpeed * 0.18, 3, MoveDirection.Z * WalkSpeed * 0.18),
																	CFrame.Angles(1.5707963267948966, 0, 0)
																)
																u683.Velocity = Vector3.new(900000000, 900000000, 900000000)
																task.wait()
																u685(
																	p32,
																	CFrame.new(-MoveDirection.X * WalkSpeed * 0.06, -3, -MoveDirection.Z * WalkSpeed * 0.06),
																	CFrame.Angles(0, 0, 0)
																)
																u683.Velocity = Vector3.new(900000000, 900000000, 900000000)
																task.wait()
															else
																n9 = n9 + 100
																u685(
																	p32,
																	CFrame.new(0, 1.5, 0) + u684.MoveDirection * Magnitude / 1.25,
																	CFrame.Angles(math.rad(n9), 0, 0)
																)
																task.wait()
																u685(
																	p32,
																	CFrame.new(0, -1.5, 0) + u684.MoveDirection * Magnitude / 1.25,
																	CFrame.Angles(math.rad(n9), 0, 0)
																)
																task.wait()
																u685(
																	p32,
																	CFrame.new(0, 1.5, 0) + u684.MoveDirection * Magnitude / 1.25,
																	CFrame.Angles(math.rad(n9), 0, 0)
																)
																task.wait()
																u685(
																	p32,
																	CFrame.new(0, -1.5, 0) + u684.MoveDirection * Magnitude / 1.25,
																	CFrame.Angles(math.rad(n9), 0, 0)
																)
																task.wait()
																u685(p32, CFrame.new(0, 1.5, 0), CFrame.Angles(math.rad(n9), 0, 0))
																task.wait()
																u685(p32, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(n9), 0, 0))
																task.wait()
															end

															if v918 < tick() then
																return
															end
														end
													end)(v687)
												end

												BodyVelocity:Destroy()
												Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
												u156.CurrentCamera.CameraSubject = Humanoid

												if getgenv().RuzOldPos then
													local n10 = 0

													repeat
														n10 = n10 + 1
														RootPart.CFrame = getgenv().RuzOldPos * CFrame.new(0, 0.5, 0)

														local _pcall = pcall
														local u691 = Character

														pcall(function()
															u691:SetPrimaryPartCFrame(getgenv().RuzOldPos * CFrame.new(0, 0.5, 0))
														end)
														Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

														for _, child in ipairs(Character:GetChildren()) do
															if child:IsA("BasePart") then
																child.Velocity = Vector3.new()
																child.RotVelocity = Vector3.new()
															end
														end

														task.wait()
													until n10 > 30 or (RootPart.Position - getgenv().RuzOldPos.p).Magnitude < 25

													u156.FallenPartsDestroyHeight = getgenv().RuzFPDH
													u155:Notify({
														Title = "RuzHub",
														Content = tostring("Returned to previous position."),
														Duration = 3,
														Icon = "bell",
													})
												end

												u153 = false

												return
											end

											return
										end

										local v694 = p28.Name .. " is sitting, skipped."

										u155:Notify({
											Title = "RuzHub",
											Content = tostring(v694),
											Duration = 3,
											Icon = "bell",
										})

										return
									end

									return
								end

								return
							end

							return
						end

						return
					end
				end

				u158 = v18
				u159 = Players
				u160 = LocalPlayer
				u161 = v157
				u162 = v18
				u163 = Players
				u164 = LocalPlayer
				u165 = v157
			end

			local t15 = {
				GlobalShadows = Lighting.GlobalShadows,
				Brightness = Lighting.Brightness,
				Ambient = Lighting.Ambient,
				OutdoorAmbient = Lighting.OutdoorAmbient,
			}
			local t16 = {}
			u168 = nil
			u169 = Lighting
			u170 = t15
			u171 = Workspace

			function u172(p33)
				if p33:IsA("BasePart") then
					if not t16[p33] then
						t16[p33] = {
							Material = p33.Material,
							CastShadow = p33.CastShadow,
						}
					end

					p33.Material = Enum.Material.SmoothPlastic
					p33.CastShadow = false
				end

				if p33:IsA("Decal") or p33:IsA("Texture") then
					if not t16[p33] then
						t16[p33] = {
							Transparency = p33.Transparency,
						}
					end

					p33.Transparency = 1
				end
			end

			u173 = TextLabel
			u174 = v18

			local u175 = Lighting
			local u176 = t15
			local u177 = TextLabel
			local u178 = v18

			function v179()
				u15 = false
				pcall(function()
					settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
				end)
				u175.GlobalShadows = u176.GlobalShadows
				u175.Brightness = u176.Brightness
				u175.Ambient = u176.Ambient
				u175.OutdoorAmbient = u176.OutdoorAmbient

				if u168 then
					u168:Disconnect()
					u168 = nil
				end

				for k, v in pairs(t16) do
					if k and k.Parent then
						local _pcall = pcall
						local u713 = v
						local u714 = k

						pcall(function()
							for k2, v2 in pairs(u713) do
								u714[k2] = v2
							end
						end)
					end
				end

				t16 = {}
				u177.Visible = false
				u178:Notify({
					Title = "RuzHub",
					Content = tostring("Low Graphics OFF"),
					Duration = 3,
					Icon = "bell",
				})
			end

			u180 = v179
			u181 = Lighting
			u182 = v18
			u183 = Lighting
			u184 = t15
			u185 = v18

			local t17 = {}
			local t18 = {
				name = "Neon Cyan",
				id = "11770890197",
			}
			local t19 = {
				name = "Electric Purple",
				id = "11770691141",
			}
			local t20 = {
				name = "Precision Dot",
				id = "10878218308",
			}
			local t21 = {
				name = "Aim Cross",
				id = "10891594349",
			}
			local t22 = {
				name = "Blue Spec",
				id = "11720475063",
			}
			local t23 = {
				name = "Circle Dot",
				id = "10831379335",
			}
			local t24 = {
				name = "Green Hit",
				id = "8375241602",
			}

			t17[1] = t18
			t17[2] = t19
			t17[3] = t20
			t17[4] = t21
			t17[5] = t22
			t17[6] = t23
			t17[7] = t24
			u194 = false
			u195 = false
			id = t17[1].id
			u197 = nil
			u198 = nil

			local u199 = RunService

			local function v200()
				if u198 then
					u198:Disconnect()
					u198 = nil
				end

				if not u195 or not u197 or not u197.Parent then
					if u197 then
						u197.Rotation = 0
					end

					return
				end

				u198 = u199.RenderStepped:Connect(function()
					if u197 and u197.Parent and u197.Visible then
						u197.Rotation = u197.Rotation + 4
					end
				end)
			end

			u201 = RunService
			u202 = UserInputService
			u203 = LocalPlayer
			u204 = v200
			u205 = v18
			u206 = v200
			u207 = t17
			u208 = v21

			local RuzHub_BtnLayer = game.CoreGui:FindFirstChild("RuzHub_BtnLayer")

			if RuzHub_BtnLayer then
				RuzHub_BtnLayer:Destroy()
			end

			local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

			ScreenGui.Name = "RuzHub_BtnLayer"
			ScreenGui.ResetOnSpawn = false
			ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			ScreenGui.DisplayOrder = 10
			t25 = {}
			u212 = UserInputService
			u213 = t25
			u214 = ScreenGui
		end

		local function u215(p34)
			local u754 = nil
			local p35Position = nil
			local Position = nil
			local InputBegan = p34.InputBegan
			local u758 = p34

			InputBegan:Connect(function(p35)
				if p35.UserInputType == Enum.UserInputType.MouseButton1 or p35.UserInputType == Enum.UserInputType.Touch then
					u754 = true
					p35Position = p35.Position
					Position = u758.Position
				end
			end)

			local InputChanged = p34.InputChanged
			local u760 = p34

			InputChanged:Connect(function(p36)
				if u754 then
					if p36.UserInputType == Enum.UserInputType.MouseMovement or p36.UserInputType == Enum.UserInputType.Touch then
						local v937 = p36.Position - p35Position

						u760.Position = UDim2.new(Position.X.Scale, Position.X.Offset + v937.X, Position.Y.Scale, Position.Y.Offset + v937.Y)
					end

					return
				end
			end)
			u212.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					u754 = false
				end
			end)
		end

		function v216(p37, p38, p39, p40, p41)
			if u213[p37] then
				u213[p37].btn:Destroy()
				u213[p37] = nil
			end

			local TextButton = Instance.new("TextButton", u214)

			TextButton.Name = "RuzBtn_" .. p37
			TextButton.Size = p39
			TextButton.Position = p38
			TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			TextButton.BackgroundTransparency = 0.6
			TextButton.Text = ""
			TextButton.AutoButtonColor = false
			TextButton.BorderSizePixel = 0
			Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, p39.Y.Offset * 0.2)

			local UIStroke = Instance.new("UIStroke", TextButton)

			UIStroke.Color = p40
			UIStroke.Thickness = 1.3
			UIStroke.Transparency = 0.5
			UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

			local TextLabel = Instance.new("TextLabel", TextButton)

			TextLabel.Name = "Lbl"
			TextLabel.Size = UDim2.new(1, 0, 1, 0)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = p41
			TextLabel.TextColor3 = p40
			TextLabel.Font = Enum.Font.GothamBold

			local v769 = p39.Y.Offset * 0.14

			TextLabel.TextSize = math.max(10, v769)
			TextLabel.TextYAlignment = Enum.TextYAlignment.Center
			TextLabel.TextXAlignment = Enum.TextXAlignment.Center
			u215(TextButton)
			u213[p37] = {
				btn = TextButton,
				stroke = UIStroke,
				lbl = TextLabel,
			}

			return u213[p37]
		end

		local u217 = RunService
		local uDim2_2 = UDim2.new(0, 88, 0, 88)

		uDim2 = UDim2.new(0, 56, 0, 56)
		t26 = {
			GoldBomb = UDim2.new(0.5, -210, 0.78, 0),
			NormalBomb = UDim2.new(0.5, -110, 0.78, 0),
			Shoot = UDim2.new(0.5, -10, 0.78, 0),
			ESP = UDim2.new(0.5, 90, 0.78, 16),
			Flick = UDim2.new(0.5, 154, 0.78, 16),
			Speed = UDim2.new(0.5, -278, 0.78, 16),
			Stretch = UDim2.new(0.5, -214, 0.78, 16),
			GrabGun = UDim2.new(0.5, 90, 0.68, 16),
			WallHop = UDim2.new(0.5, 154, 0.68, 16),
			FlingMurderer = UDim2.new(0.5, -278, 0.68, 16),
			FlingSheriff = UDim2.new(0.5, -214, 0.68, 16),
		}

		local u221 = t25
		local u222 = v216
		local u223 = t26
		local u224 = uDim2_2
		local u225 = v18
		local u226 = v112

		function v227(p42)
			if p42 then
				u222("GoldBomb", u223.GoldBomb, u224, Color3.fromRGB(255, 215, 0), "GOLD\nJUMP")
				u221.GoldBomb.btn.MouseButton1Click:Connect(function()
					if not u9 then
						u226("GoldBomb", true)

						return
					end

					u225:Notify({
						Title = "RuzHub",
						Content = tostring("Gold Bomb on cooldown."),
						Duration = 3,
						Icon = "bell",
					})
				end)

				return
			end

			if u221.GoldBomb then
				u221.GoldBomb.btn:Destroy()
				u221.GoldBomb = nil
			end
		end

		local u228 = t25
		local u229 = v216
		local u230 = t26
		local u231 = uDim2_2
		local u232 = v18
		local u233 = v112

		function v234(p43)
			if p43 then
				u229("NormalBomb", u230.NormalBomb, u231, Color3.fromRGB(0, 170, 255), "NORMAL\nJUMP")
				u228.NormalBomb.btn.MouseButton1Click:Connect(function()
					if not u10 then
						u233("FakeBomb", false)

						return
					end

					u232:Notify({
						Title = "RuzHub",
						Content = tostring("Normal Bomb on cooldown."),
						Duration = 3,
						Icon = "bell",
					})
				end)

				return
			end

			if u228.NormalBomb then
				u228.NormalBomb.btn:Destroy()
				u228.NormalBomb = nil
			end
		end

		local u235 = t25
		local u236 = v216
		local u237 = t26
		local u238 = uDim2_2

		local function u239(p44, p45)
			local YOffset = p44.btn.Size.Y.Offset
			local v773 = YOffset * 0.55
			local v774 = math.floor(v773)
			local ImageLabel = Instance.new("ImageLabel", p44.btn)

			ImageLabel.Name = "SpinImg"
			ImageLabel.Size = UDim2.new(0, v774, 0, v774)
			ImageLabel.Position = UDim2.new(0.5, -v774 / 2, 0.5, -v774 / 2)
			ImageLabel.BackgroundTransparency = 1
			ImageLabel.Image = "rbxassetid://" .. tostring(p45)
			p44.img = ImageLabel
			p44.lbl.Size = UDim2.new(1, 0, 0.28, 0)
			p44.lbl.Position = UDim2.new(0, 0, 0.72, 0)

			local lbl = p44.lbl
			local v777 = YOffset * 0.12

			lbl.TextSize = math.max(9, v777)

			local spawn = task.spawn
			local u779 = ImageLabel

			spawn(function()
				while u779 and u779.Parent do
					u779.Rotation = u779.Rotation + 4
					u217.RenderStepped:Wait()
				end
			end)

			return ImageLabel
		end
		local function u240()
			if u95.Character then
				if not u95.Backpack:FindFirstChild("Knife") and (not u95.Character or not u95.Character:FindFirstChild("Knife")) then
					u97()

					return
				end

				u96()

				return
			end
		end

		function v241(p46)
			if p46 then
				local v783 = u236("Shoot", u237.Shoot, u238, Color3.fromRGB(255, 255, 255), "SHOOT")

				u239(v783, 5159914132)
				v783.btn.MouseButton1Click:Connect(u240)

				return
			end

			if u235.Shoot then
				u235.Shoot.btn:Destroy()
				u235.Shoot = nil
			end
		end
	end

	local u242 = t25
	local u243 = v216
	local u244 = t26
	local u245 = uDim2
	local u246 = v78
	local u247 = v68
	local u248 = v18
	local u249 = t25
	local u250 = v216
	local u251 = t26
	local u252 = uDim2

	local function u253()
		if u98 then
			return
		end

		local Character = u99.Character

		if not Character then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return
		end

		u98 = true

		local g552

		if u100.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
			local HumanoidRootPartCFrame = HumanoidRootPart.CFrame
			local v543 = HumanoidRootPartCFrame * CFrame.Angles(0, 3.141592653589793, 0)

			for i = 1, 4 do
				HumanoidRootPart.CFrame = HumanoidRootPartCFrame:Lerp(v543, i / 4)
				u102.RenderStepped:Wait()
			end
		else
			local CFrame2 = u101.CFrame
			local LookVector = CFrame2.LookVector
			local vector3 = Vector3.new(-LookVector.X, LookVector.Y, -LookVector.Z)
			local cFrame = CFrame.lookAt(CFrame2.Position, CFrame2.Position + vector3)
			local n11 = 1
			local n12 = 5
			local n13 = 1

			g552 = nil

			if false then
				if true then
					g552 = true
				end
			elseif not (n11 <= n12) then
				g552 = true
			end

			if not g552 then
				if not g552 then
					repeat
						while true do
							u101.CFrame = CFrame2:Lerp(cFrame, n11 / 5)
							u102.RenderStepped:Wait()
							n11 = n11 + n13

							if n13 > 0 then
								break
							end

							if not (n12 <= n11) then
								g552 = true
							end

							if g552 then
								break
							end
						end

						if g552 then
							break
						end
					until not (n11 <= n12)
				end
			end
		end

		g552 = false
		task.wait(0.15)
		u98 = false
	end

	u254 = t25
	u255 = v216
	u256 = t26
	u257 = uDim2
	u258 = v18
	u259 = t25
	u260 = v216
	u261 = t26
	u262 = uDim2
	u263 = v122
	u264 = v18

	local u265 = t25
	local u266 = v216
	local u267 = t26
	local u268 = uDim2

	local function u269()
		local GunDrop = u126:FindFirstChild("GunDrop", true)

		if GunDrop then
			local Character = u128.Character
			local v624 = Character and Character:FindFirstChild("HumanoidRootPart")

			if v624 then
				local v626

				if not GunDrop:IsA("BasePart") then
					local v625 = GunDrop:FindFirstChild("Handle") or (GunDrop:FindFirstChildWhichIsA("BasePart") or GunDrop.PrimaryPart)

					v626 = v625 and v625.Position or GunDrop:GetModelCFrame().Position
				else
					v626 = GunDrop.Position
				end

				if v626 then
					local CFrame3 = v624.CFrame

					v624.CFrame = CFrame.new(v626 + Vector3.new(0, 2, 0))
					task.wait(0.2)
					v624.CFrame = CFrame3
					u127:Notify({
						Title = "RuzHub",
						Content = tostring("Teleported to gun!"),
						Duration = 3,
						Icon = "bell",
					})

					return
				end

				u127:Notify({
					Title = "RuzHub",
					Content = tostring("Gun position not found!"),
					Duration = 3,
					Icon = "bell",
				})

				return
			end

			return
		end

		u127:Notify({
			Title = "RuzHub",
			Content = tostring("No gun on map!"),
			Duration = 3,
			Icon = "bell",
		})
	end

	u270 = t25
	u271 = v216
	u272 = t26
	u273 = uDim2

	function u274()
		local v553 = nil
		local RenderStepped = nil
		local v555 = nil
		local v556 = nil

		if u103 then
			return
		end

		local Character = u104.Character

		if not Character then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return
		end

		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if not Humanoid then
			return
		end

		u103 = true

		local v560 = u105.MouseBehavior == Enum.MouseBehavior.LockCenter
		local _, v562, _ = HumanoidRootPart.CFrame:ToEulerAnglesYXZ()
		local CFrame4 = u106.CFrame
		local g603 = nil
		local g579

		if not v560 then
			local v565 = v562 - 1.5707963267948966

			for i = 1, 7 do
				local _ = i / 7
				local _ = RenderStepped ^ 2
				local cFrame = CFrame.new(HumanoidRootPart.Position)
				local fromEulerAnglesYXZ = CFrame.fromEulerAnglesYXZ

				v556 = v562 + (v565 - v562) * v553
				v555 = fromEulerAnglesYXZ(0, v556, 0)
				HumanoidRootPart.CFrame = cFrame * v555
				RenderStepped = u107.RenderStepped
				RenderStepped:Wait()
			end
		else
			local Unit = Vector3.new(CFrame4.LookVector.X, 0, CFrame4.LookVector.Z).Unit
			local new = Vector3.new
			local RightVectorX = CFrame4.RightVector.X
			local RightVectorZ = CFrame4.RightVector.Z
			local Unit2 = new(RightVectorX, 0, RightVectorZ).Unit
			local n14 = 1
			local n15 = 7
			local n16 = 1

			g579 = nil

			if false then
				if true then
					g579 = true
				end
			elseif not (n14 <= n15) then
				g579 = true
			end

			if not g579 then
				if not g579 then
					repeat
						while true do
							local _ = n14 / 7
							local _ = v555 ^ 2
							local lookAt = CFrame.lookAt
							local CFramePosition = u106.CFrame.Position

							v556 = u106.CFrame.Position + Unit:Lerp(Unit2, RightVectorZ).Unit
							u106.CFrame = lookAt(CFramePosition, v556)
							v555 = u107.RenderStepped
							v555:Wait()
							n14 = n14 + n16

							if n16 > 0 then
								break
							end

							if not (n15 <= n14) then
								g579 = true
							end

							if g579 then
								break
							end
						end

						if g579 then
							break
						end
					until not (n14 <= n15)
				end
			end
		end

		g579 = false

		local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity

		HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, 55, AssemblyLinearVelocity.Z)

		local _pcall = pcall
		local u587 = Humanoid

		pcall(function()
			u587:ChangeState(Enum.HumanoidStateType.Jumping)
		end)
		task.wait(0.12)

		if not v560 then
			local _, v589, _ = HumanoidRootPart.CFrame:ToEulerAnglesYXZ()

			for i = 1, 5 do
				local _ = i / 5
				local _ = v556 ^ 2

				HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position) * CFrame.fromEulerAnglesYXZ(0, v589 + (v562 - v589) * v555, 0)
				v556 = u107.RenderStepped
				v556:Wait()
			end
		else
			local Unit = Vector3.new(CFrame4.LookVector.X, 0, CFrame4.LookVector.Z).Unit
			local new = Vector3.new
			local LookVectorX = u106.CFrame.LookVector.X
			local CFrame5 = u106.CFrame
			local LookVectorZ = CFrame5.LookVector.Z
			local Unit3 = new(LookVectorX, 0, LookVectorZ).Unit
			local n17 = 1
			local n18 = 5
			local n19 = 1

			if false then
				if true then
					g603 = true
				end
			elseif not (n17 <= n18) then
				g603 = true
			end

			if not g603 then
				if not g603 then
					repeat
						while true do
							local _ = n17 / 5
							local _ = CFrame5 ^ 2

							u106.CFrame = CFrame.lookAt(u106.CFrame.Position, u106.CFrame.Position + Unit3:Lerp(Unit, LookVectorZ).Unit)
							CFrame5 = u107.RenderStepped
							CFrame5:Wait()
							n17 = n17 + n19

							if n19 > 0 then
								break
							end

							if not (n18 <= n17) then
								g603 = true
							end

							if g603 then
								break
							end
						end

						if g603 then
							break
						end
					until not (n17 <= n18)
				end
			end
		end

		g603 = false
		task.wait(0.1)
		u103 = false
	end

	u275 = t25
	u276 = v216
	u277 = t26
	u278 = uDim2

	function u279()
		if not u153 then
			for _, player in ipairs(u159:GetPlayers()) do
				if
					player ~= u160
					and player.Character
					and (player.Backpack:FindFirstChild("Knife") or player.Character and player.Character:FindFirstChild("Knife"))
				then
					local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")

					if Humanoid and Humanoid.Health > 0 then
						local v698 = "Flinging: " .. player.Name

						u158:Notify({
							Title = "RuzHub",
							Content = tostring(v698),
							Duration = 3,
							Icon = "bell",
						})
						task.spawn(u161, player)

						return
					end
				end
			end

			u158:Notify({
				Title = "RuzHub",
				Content = tostring("No knife player found!"),
				Duration = 3,
				Icon = "bell",
			})

			return
		end

		u158:Notify({
			Title = "RuzHub",
			Content = tostring("Fling in progress..."),
			Duration = 3,
			Icon = "bell",
		})
	end

	u280 = t25
	u281 = v216
	u282 = t26
	u283 = uDim2

	function u284()
		if not u153 then
			for _, player in ipairs(u163:GetPlayers()) do
				if
					player ~= u164
					and player.Character
					and (player.Backpack:FindFirstChild("Gun") or player.Character and player.Character:FindFirstChild("Gun"))
				then
					local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")

					if Humanoid and Humanoid.Health > 0 then
						local v702 = "Flinging: " .. player.Name

						u162:Notify({
							Title = "RuzHub",
							Content = tostring(v702),
							Duration = 3,
							Icon = "bell",
						})
						task.spawn(u165, player)

						return
					end
				end
			end

			u162:Notify({
				Title = "RuzHub",
				Content = tostring("No gun player found!"),
				Duration = 3,
				Icon = "bell",
			})

			return
		end

		u162:Notify({
			Title = "RuzHub",
			Content = tostring("Fling in progress..."),
			Duration = 3,
			Icon = "bell",
		})
	end

	local Heartbeat = RunService.Heartbeat
	local u286 = t25
	local u287 = LocalPlayer
	local u288 = UserInputService
	local u289 = Workspace
	local u290 = Players

	Heartbeat:Connect(function()
		if u286.GoldBomb then
			u286.GoldBomb.lbl.Text = u9 and "WAIT..." or "GOLD\nJUMP"
		end

		if u286.NormalBomb then
			u286.NormalBomb.lbl.Text = u10 and "WAIT..." or "NORMAL\nJUMP"
		end

		if u286.Shoot and u286.Shoot.img then
			local v793 = u287.Backpack:FindFirstChild("Knife") or u287.Character and u287.Character:FindFirstChild("Knife")

			u286.Shoot.img.Image = v793 and "rbxassetid://9695655416" or "rbxassetid://5159914132"
			u286.Shoot.lbl.Text = v793 and "THROW" or "SHOOT"
		end

		if u286.ESP then
			local v794 = u61 and Color3.fromRGB(50, 220, 80) or Color3.fromRGB(10, 140, 30)

			u286.ESP.lbl.Text = u61 and "ESP\nON" or "ESP\nOFF"
			u286.ESP.lbl.TextColor3 = v794
			u286.ESP.stroke.Color = v794
		end

		if u286.Flick then
			local v795 = u288.MouseBehavior == Enum.MouseBehavior.LockCenter
			local v796 = u98 and Color3.fromRGB(255, 120, 0) or (v795 and Color3.fromRGB(120, 200, 255) or Color3.fromRGB(180, 50, 255))

			u286.Flick.lbl.Text = u98 and "WAIT..." or "FLICK"
			u286.Flick.lbl.TextColor3 = v796
			u286.Flick.stroke.Color = v796
		end

		if u286.WallHop then
			local v797 = u288.MouseBehavior == Enum.MouseBehavior.LockCenter
			local v798 = u103 and Color3.fromRGB(255, 120, 0) or (v797 and Color3.fromRGB(0, 255, 220) or Color3.fromRGB(0, 210, 210))

			u286.WallHop.lbl.Text = u103 and "WAIT..." or "WALL\nHOP"
			u286.WallHop.lbl.TextColor3 = v798
			u286.WallHop.stroke.Color = v798
		end

		if u286.Speed then
			local v799 = u113 and Color3.fromRGB(0, 220, 200) or Color3.fromRGB(0, 140, 120)

			u286.Speed.lbl.Text = u113 and "SPEED\nON" or "SPEED"
			u286.Speed.lbl.TextColor3 = v799
			u286.Speed.stroke.Color = v799
		end

		if u286.Stretch then
			local v800 = u117 and Color3.fromRGB(255, 140, 30) or Color3.fromRGB(200, 80, 0)

			u286.Stretch.lbl.Text = u117 and "STRETCH\nON" or "STRETCH"
			u286.Stretch.lbl.TextColor3 = v800
			u286.Stretch.stroke.Color = v800
		end

		if u286.GrabGun then
			local GunDrop = u289:FindFirstChild("GunDrop", true)
			local v802 = GunDrop and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(200, 100, 0)

			u286.GrabGun.lbl.Text = GunDrop and "GRAB\nGUN" or "NO\nGUN"
			u286.GrabGun.lbl.TextColor3 = v802
			u286.GrabGun.stroke.Color = v802
		end

		if u286.FlingMurderer then
			local v803 = false

			for _, player in ipairs(u290:GetPlayers()) do
				if player ~= u287 and (player.Backpack:FindFirstChild("Knife") or player.Character and player.Character:FindFirstChild("Knife")) then
					v803 = true

					break
				end
			end

			local v806 = u153 and Color3.fromRGB(255, 180, 0) or (v803 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(200, 20, 20))

			u286.FlingMurderer.lbl.Text = u153 and "FLING..." or (v803 and "FLING\nMURD" or "NO\nMURD")
			u286.FlingMurderer.lbl.TextColor3 = v806
			u286.FlingMurderer.stroke.Color = v806
		end

		if u286.FlingSheriff then
			local v807 = false

			for _, player in ipairs(u290:GetPlayers()) do
				if player ~= u287 and (player.Backpack:FindFirstChild("Gun") or player.Character and player.Character:FindFirstChild("Gun")) then
					v807 = true

					break
				end
			end

			local v810 = u153 and Color3.fromRGB(255, 180, 0) or (v807 and Color3.fromRGB(40, 130, 255) or Color3.fromRGB(10, 80, 200))

			u286.FlingSheriff.lbl.Text = u153 and "FLING..." or (v807 and "FLING\nSHERIF" or "NO\nSHERIF")
			u286.FlingSheriff.lbl.TextColor3 = v810
			u286.FlingSheriff.stroke.Color = v810
		end
	end)
	v18:Popup({
		Title = "RuzHub Mmv And Mm2",
		Icon = "sparkles",
		Content = "v7.3 loaded!\nBombs and Shoot auto-loaded.\nOpen menu to configure everything.",
		Buttons = {
			{
				Title = "Start",
				Icon = "arrow-right",
				Variant = "Primary",
				Callback = function() end,
			},
		},
	})

	local v291 = v18:CreateWindow({
		Title = "RuzHub",
		Icon = "sparkles",
		Author = "Mmv And Mm2",
		Folder = "RuzHub",
		Size = UDim2.fromOffset(700, 550),
		Theme = "Crimson",
		Acrylic = false,
		HideSearchBar = false,
		OpenButton = {
			Title = "RuzHub",
			CornerRadius = UDim.new(1, 0),
			StrokeThickness = 2,
			Enabled = true,
			OnlyMobile = false,
			Color = ColorSequence.new(Color3.fromHex("#dc2626"), Color3.fromHex("#991b1b")),
		},
	}):Section({
		Title = "RuzHub",
		Opened = true,
	})

	v292 = v291:Tab({
		Title = "Main",
		Icon = "zap",
	})
	v293 = v291:Tab({
		Title = "ESP",
		Icon = "eye",
	})
	v292:Paragraph({
		Title = "Auto-Loaded Buttons",
		Content = "Gold Bomb, Normal Bomb and Shoot/Throw are enabled by default.",
	})

	local t27 = {
		Title = "Show Gold Bomb",
		Default = true,
	}
	local u295 = v227

	function t27.Callback(p47)
		u295(p47)
	end

	v292:Toggle(t27)

	local t28 = {
		Title = "Show Normal Bomb",
		Default = true,
	}
	local u297 = v234

	function t28.Callback(p48)
		u297(p48)
	end

	v292:Toggle(t28)

	local t29 = {
		Title = "Show Shoot/Throw",
		Default = true,
	}
	local u299 = v241

	function t29.Callback(p49)
		u299(p49)
	end

	v292:Toggle(t29)
	v292:Divider()
	v292:Paragraph({
		Title = "Optional Buttons",
		Content = "Toggle to add or remove from screen.",
	})

	local t30 = {
		Title = "Load ESP Toggle",
		Default = false,
	}

	local function u301(p50)
		if p50 then
			u243("ESP", u244.ESP, u245, Color3.fromRGB(10, 140, 30), "ESP\nOFF")
			u242.ESP.btn.MouseButton1Click:Connect(function()
				local v940 = not u61

				u61 = v940

				if not v940 then
					if u62 then
						u62:Disconnect()
						u62 = nil
					end

					task.delay(0.1, u247)
				else
					u246()
				end

				local v941 = u61 and "ESP ON" or "ESP OFF"

				u248:Notify({
					Title = "RuzHub",
					Content = tostring(v941),
					Duration = 3,
					Icon = "bell",
				})
			end)

			return
		end

		if u242.ESP then
			u242.ESP.btn:Destroy()
			u242.ESP = nil
		end
	end

	function t30.Callback(p51)
		u301(p51)
	end

	v292:Toggle(t30)

	local t31 = {
		Title = "Load Flick",
		Default = false,
	}

	local function u303(p52)
		if p52 then
			u250("Flick", u251.Flick, u252, Color3.fromRGB(180, 50, 255), "FLICK")
			u249.Flick.btn.MouseButton1Click:Connect(u253)

			return
		end

		if u249.Flick then
			u249.Flick.btn:Destroy()
			u249.Flick = nil
		end
	end

	function t31.Callback(p53)
		u303(p53)
	end

	v292:Toggle(t31)
	t32 = {
		Title = "Load Grab Gun",
		Default = false,
	}

	function u305(p54)
		if p54 then
			u266("GrabGun", u267.GrabGun, u268, Color3.fromRGB(200, 120, 0), "GRAB\nGUN")
			u265.GrabGun.btn.MouseButton1Click:Connect(u269)

			return
		end

		if u265.GrabGun then
			u265.GrabGun.btn:Destroy()
			u265.GrabGun = nil
		end
	end
end

function t32.Callback(p55)
	u305(p55)
end

v292:Toggle(t32)

local t33 = {
	Title = "Load Speed Glitch",
	Default = false,
}

local function u307(p56)
	if p56 then
		u255("Speed", u256.Speed, u257, Color3.fromRGB(0, 140, 120), "SPEED")
		u254.Speed.btn.MouseButton1Click:Connect(function()
			u113 = not u113

			local v942 = u113 and "Speed Glitch ON" or "Speed Glitch OFF"

			u258:Notify({
				Title = "RuzHub",
				Content = tostring(v942),
				Duration = 3,
				Icon = "bell",
			})
		end)

		return
	end

	if u254.Speed then
		u254.Speed.btn:Destroy()
		u254.Speed = nil
	end
end

function t33.Callback(p57)
	u307(p57)
end

v292:Toggle(t33)

local t34 = {
	Title = "Load Stretch",
	Default = false,
}

local function u309(p58)
	if p58 then
		u260("Stretch", u261.Stretch, u262, Color3.fromRGB(200, 80, 0), "STRETCH")
		u259.Stretch.btn.MouseButton1Click:Connect(function()
			u117 = not u117
			u263(u117)

			local v943 = u117 and "Stretch ON" or "Stretch OFF"

			u264:Notify({
				Title = "RuzHub",
				Content = tostring(v943),
				Duration = 3,
				Icon = "bell",
			})
		end)

		return
	end

	if u259.Stretch then
		u259.Stretch.btn:Destroy()
		u259.Stretch = nil
	end
end

function t34.Callback(p59)
	u309(p59)
end

v292:Toggle(t34)
v292:Button({
	Title = "Stretch Resolution Slider",
	Description = "10% = very wide  /  100% = normal",
	Callback = function()
		local v620 = n8 * 100
		local v621 = math.round(v620)

		u123("Stretch Resolution", 10, 100, v621, 5, function(p60)
			n8 = p60 / 100

			if u117 then
				u124(true)
			end

			local v900 = "Stretch set to " .. p60 .. "%  (1.0 = normal)"

			u125:Notify({
				Title = "RuzHub",
				Content = tostring(v900),
				Duration = 3,
				Icon = "bell",
			})
		end, function()
			n8 = 0.5

			if u117 then
				u124(true)
			end

			u125:Notify({
				Title = "RuzHub",
				Content = tostring("Stretch reset to 50%"),
				Duration = 3,
				Icon = "bell",
			})
		end)
	end,
})

local t35 = {
	Title = "Load Fling Murderer",
	Default = false,
}

local function u311(p61)
	if p61 then
		u276("FlingMurderer", u277.FlingMurderer, u278, Color3.fromRGB(255, 50, 50), "FLING\nMURD")
		u275.FlingMurderer.btn.MouseButton1Click:Connect(u279)

		return
	end

	if u275.FlingMurderer then
		u275.FlingMurderer.btn:Destroy()
		u275.FlingMurderer = nil
	end
end

function t35.Callback(p62)
	u311(p62)
end

v292:Toggle(t35)

local t36 = {
	Title = "Load Fling Sheriff",
	Default = false,
}

local function u313(p63)
	if p63 then
		u281("FlingSheriff", u282.FlingSheriff, u283, Color3.fromRGB(40, 130, 255), "FLING\nSHERIF")
		u280.FlingSheriff.btn.MouseButton1Click:Connect(u284)

		return
	end

	if u280.FlingSheriff then
		u280.FlingSheriff.btn:Destroy()
		u280.FlingSheriff = nil
	end
end

function t36.Callback(p64)
	u313(p64)
end

v292:Toggle(t36)

local t37 = {
	Title = "Load Wall Hop",
	Default = false,
}

local function u315(p65)
	if p65 then
		u271("WallHop", u272.WallHop, u273, Color3.fromRGB(0, 210, 210), "WALL\nHOP")
		u270.WallHop.btn.MouseButton1Click:Connect(u274)

		return
	end

	if u270.WallHop then
		u270.WallHop.btn:Destroy()
		u270.WallHop = nil
	end
end

function t37.Callback(p66)
	u315(p66)
end

v292:Toggle(t37)
v292:Divider()
v292:Paragraph({
	Title = "Skybox",
	Content = "Click the button below to open the visual skybox picker.\nSelecting a preset applies it instantly.",
})
v292:Button({
	Title = "Open Skybox Picker",
	Description = "Color preview list — click to apply instantly",
	Callback = function()
		local RuzSkyboxPicker = game.CoreGui:FindFirstChild("RuzSkyboxPicker")

		if not RuzSkyboxPicker then
			local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

			ScreenGui.Name = "RuzSkyboxPicker"
			ScreenGui.ResetOnSpawn = false
			ScreenGui.DisplayOrder = 62

			local Frame = Instance.new("Frame", ScreenGui)

			Frame.Size = UDim2.new(0, 310, 0, 420)
			Frame.Position = UDim2.new(0.5, -155, 0.04, 0)
			Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
			Frame.BackgroundTransparency = 0.06
			Frame.BorderSizePixel = 0
			Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

			local UIStroke = Instance.new("UIStroke", Frame)

			UIStroke.Color = Color3.fromRGB(220, 38, 38)
			UIStroke.Thickness = 1.5

			local TextLabel = Instance.new("TextLabel", Frame)

			TextLabel.Size = UDim2.new(1, -44, 0, 38)
			TextLabel.Position = UDim2.new(0, 12, 0, 0)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = "RuzHub  —  Skybox Picker"
			TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.TextSize = 14
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			local TextButton = Instance.new("TextButton", Frame)

			TextButton.Size = UDim2.new(0, 28, 0, 28)
			TextButton.Position = UDim2.new(1, -34, 0, 5)
			TextButton.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
			TextButton.Text = "X"
			TextButton.TextColor3 = Color3.new(1, 1, 1)
			TextButton.Font = Enum.Font.GothamBold
			TextButton.TextSize = 13
			Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 6)

			local MouseButton1Click = TextButton.MouseButton1Click
			local u646 = ScreenGui

			MouseButton1Click:Connect(function()
				u646:Destroy()
			end)

			local TextBox = Instance.new("TextBox", Frame)

			TextBox.Size = UDim2.new(1, -20, 0, 34)
			TextBox.Position = UDim2.new(0, 10, 0, 44)
			TextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			TextBox.Text = ""
			TextBox.PlaceholderText = "Enter custom Skybox ID, press Enter..."
			TextBox.TextColor3 = Color3.new(1, 1, 1)
			TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
			TextBox.Font = Enum.Font.Gotham
			TextBox.TextSize = 13
			TextBox.ClearTextOnFocus = false
			Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)
			Instance.new("UIStroke", TextBox).Color = Color3.fromRGB(80, 80, 80)

			local FocusLost = TextBox.FocusLost
			local u649 = TextBox

			FocusLost:Connect(function(p67)
				if p67 and u649.Text ~= "" then
					u144(u649.Text)

					local v902 = "Custom skybox applied — ID: " .. u649.Text

					u145:Notify({
						Title = "RuzHub",
						Content = tostring(v902),
						Duration = 3,
						Icon = "bell",
					})
					u649.Text = ""
				end
			end)

			local TextButton5 = Instance.new("TextButton", Frame)

			TextButton5.Size = UDim2.new(1, -20, 0, 28)
			TextButton5.Position = UDim2.new(0, 10, 0, 84)
			TextButton5.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			TextButton5.Text = "Restore Default Sky"
			TextButton5.TextColor3 = Color3.fromRGB(200, 200, 200)
			TextButton5.Font = Enum.Font.GothamBold
			TextButton5.TextSize = 12
			Instance.new("UICorner", TextButton5).CornerRadius = UDim.new(0, 6)

			local MouseButton1Click4 = TextButton5.MouseButton1Click
			local u652 = ScreenGui

			MouseButton1Click4:Connect(function()
				u146()
				u652:Destroy()
			end)

			local Frame5 = Instance.new("Frame", Frame)

			Frame5.Size = UDim2.new(1, -20, 0, 1)
			Frame5.Position = UDim2.new(0, 10, 0, 118)
			Frame5.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			Frame5.BorderSizePixel = 0

			local ScrollingFrame = Instance.new("ScrollingFrame", Frame)

			ScrollingFrame.Size = UDim2.new(1, -14, 1, -126)
			ScrollingFrame.Position = UDim2.new(0, 7, 0, 124)
			ScrollingFrame.BackgroundTransparency = 1
			ScrollingFrame.BorderSizePixel = 0
			ScrollingFrame.ScrollBarThickness = 4
			ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #u147 * 56)

			local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)

			UIListLayout.Padding = UDim.new(0, 6)
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

			for i, v in ipairs(u147) do
				local TextButton6 = Instance.new("TextButton", ScrollingFrame)

				TextButton6.Size = UDim2.new(1, -8, 0, 48)
				TextButton6.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				TextButton6.Text = ""
				TextButton6.AutoButtonColor = false
				TextButton6.LayoutOrder = i
				Instance.new("UICorner", TextButton6).CornerRadius = UDim.new(0, 8)

				local UIStroke2 = Instance.new("UIStroke", TextButton6)

				UIStroke2.Color = v.color
				UIStroke2.Thickness = 1

				local Frame6 = Instance.new("Frame", TextButton6)

				Frame6.Size = UDim2.new(0, 34, 0, 34)
				Frame6.Position = UDim2.new(0, 8, 0.5, -17)
				Frame6.BackgroundColor3 = v.color
				Frame6.BorderSizePixel = 0
				Instance.new("UICorner", Frame6).CornerRadius = UDim.new(0, 6)

				local TextLabel5 = Instance.new("TextLabel", TextButton6)

				TextLabel5.Size = UDim2.new(1, -58, 0, 22)
				TextLabel5.Position = UDim2.new(0, 50, 0, 6)
				TextLabel5.BackgroundTransparency = 1
				TextLabel5.Text = v.name
				TextLabel5.TextColor3 = Color3.fromRGB(210, 210, 210)
				TextLabel5.Font = Enum.Font.GothamBold
				TextLabel5.TextSize = 14
				TextLabel5.TextXAlignment = Enum.TextXAlignment.Left

				local TextLabel6 = Instance.new("TextLabel", TextButton6)

				TextLabel6.Size = UDim2.new(1, -58, 0, 14)
				TextLabel6.Position = UDim2.new(0, 50, 1, -18)
				TextLabel6.BackgroundTransparency = 1
				TextLabel6.Text = "ID: " .. v.id
				TextLabel6.TextColor3 = Color3.fromRGB(100, 100, 100)
				TextLabel6.Font = Enum.Font.Gotham
				TextLabel6.TextSize = 10
				TextLabel6.TextXAlignment = Enum.TextXAlignment.Left

				local MouseButton1Click5 = TextButton6.MouseButton1Click
				local u664 = v
				local u665 = ScrollingFrame
				local u666 = UIStroke2
				local u667 = TextButton6
				local u668 = TextLabel5

				MouseButton1Click5:Connect(function()
					u144(u664.id)

					local v903 = "Skybox applied: " .. u664.name

					u145:Notify({
						Title = "RuzHub",
						Content = tostring(v903),
						Duration = 3,
						Icon = "bell",
					})

					for _, child in ipairs(u665:GetChildren()) do
						if child:IsA("TextButton") then
							local UIStroke3 = child:FindFirstChildOfClass("UIStroke")

							if UIStroke3 then
								UIStroke3.Thickness = 1
								UIStroke3.Color = Color3.fromRGB(80, 80, 80)
							end

							child.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
						end
					end

					u666.Thickness = 2
					u666.Color = Color3.fromRGB(220, 38, 38)
					u667.BackgroundColor3 = Color3.fromRGB(50, 15, 15)
					u668.TextColor3 = Color3.fromRGB(255, 80, 80)
				end)
			end

			u148(Frame)

			return
		end

		RuzSkyboxPicker:Destroy()
	end,
})

local t38 = {
	Title = "Restore Default Sky",
}
local u317 = v142

function t38.Callback()
	u317()
end

v292:Button(t38)
v292:Divider()
v292:Paragraph({
	Title = "Crosshair",
	Content = "Visible only when ShiftLock is active.\nSpin option is inside the picker.",
})

local t39 = {
	Title = "Enable Custom Crosshair",
	Description = "Visible only while ShiftLock is on",
	Default = false,
}

local function u319()
	local RuzCrosshairDisplay = game.CoreGui:FindFirstChild("RuzCrosshairDisplay")

	if RuzCrosshairDisplay then
		RuzCrosshairDisplay:Destroy()
	end

	if u198 then
		u198:Disconnect()
		u198 = nil
	end

	local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

	ScreenGui.Name = "RuzCrosshairDisplay"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.DisplayOrder = 25
	ScreenGui.IgnoreGuiInset = true
	u197 = Instance.new("ImageLabel", ScreenGui)
	u197.AnchorPoint = Vector2.new(0.5, 0.5)
	u197.Position = UDim2.new(0.5, 0, 0.5, 0)
	u197.Size = UDim2.new(0, 42, 0, 42)
	u197.BackgroundTransparency = 1
	u197.Image = "rbxassetid://" .. id
	u197.ZIndex = 10
	u197.Visible = false
	u201.RenderStepped:Connect(function()
		if u197 and u197.Parent then
			local v928 = u202.MouseBehavior == Enum.MouseBehavior.LockCenter
			local PlayerGui = u203:FindFirstChild("PlayerGui")

			if PlayerGui then
				local GameTopbar = PlayerGui:FindFirstChild("GameTopbar")

				if GameTopbar and GameTopbar:FindFirstChild("Crosshair") then
					GameTopbar.Crosshair.Visible = false
				end
			end

			local v931 = u194 and (v928 or false)

			u197.Visible = v931
			u202.MouseIconEnabled = not v931

			return
		end
	end)
	u204()
end

local u320 = v18
local u321 = UserInputService

function t39.Callback(p68)
	u194 = p68

	if not p68 then
		local RuzCrosshairDisplay = game.CoreGui:FindFirstChild("RuzCrosshairDisplay")

		if RuzCrosshairDisplay then
			RuzCrosshairDisplay:Destroy()
			u197 = nil
		end

		if u198 then
			u198:Disconnect()
			u198 = nil
		end

		u321.MouseIconEnabled = true
		u320:Notify({
			Title = "RuzHub",
			Content = tostring("Crosshair OFF"),
			Duration = 3,
			Icon = "bell",
		})

		return
	end

	u319()
	u320:Notify({
		Title = "RuzHub",
		Content = tostring("Crosshair ON — enable ShiftLock to see it!"),
		Duration = 3,
		Icon = "bell",
	})
end

v292:Toggle(t39)
v292:Button({
	Title = "Open Cursor Picker",
	Description = "Visual grid with spin toggle — click to apply",
	Callback = function()
		local RuzCursorPicker = game.CoreGui:FindFirstChild("RuzCursorPicker")

		if not RuzCursorPicker then
			local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

			ScreenGui.Name = "RuzCursorPicker"
			ScreenGui.ResetOnSpawn = false
			ScreenGui.DisplayOrder = 60

			local Frame = Instance.new("Frame", ScreenGui)

			Frame.Size = UDim2.new(0, 300, 0, 460)
			Frame.Position = UDim2.new(0.5, -150, 0.04, 0)
			Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
			Frame.BackgroundTransparency = 0.06
			Frame.BorderSizePixel = 0
			Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

			local UIStroke = Instance.new("UIStroke", Frame)

			UIStroke.Color = Color3.fromRGB(220, 38, 38)
			UIStroke.Thickness = 1.5

			local TextLabel = Instance.new("TextLabel", Frame)

			TextLabel.Size = UDim2.new(1, -44, 0, 38)
			TextLabel.Position = UDim2.new(0, 12, 0, 0)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = "RuzHub  —  Cursor Picker"
			TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.TextSize = 14
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			local TextButton = Instance.new("TextButton", Frame)

			TextButton.Size = UDim2.new(0, 28, 0, 28)
			TextButton.Position = UDim2.new(1, -34, 0, 5)
			TextButton.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
			TextButton.Text = "X"
			TextButton.TextColor3 = Color3.new(1, 1, 1)
			TextButton.Font = Enum.Font.GothamBold
			TextButton.TextSize = 13
			Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 6)

			local MouseButton1Click = TextButton.MouseButton1Click
			local u729 = ScreenGui

			MouseButton1Click:Connect(function()
				u729:Destroy()
			end)

			local TextBox = Instance.new("TextBox", Frame)

			TextBox.Size = UDim2.new(1, -20, 0, 34)
			TextBox.Position = UDim2.new(0, 10, 0, 44)
			TextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			TextBox.Text = ""
			TextBox.PlaceholderText = "Enter custom Cursor ID, press Enter..."
			TextBox.TextColor3 = Color3.new(1, 1, 1)
			TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
			TextBox.Font = Enum.Font.Gotham
			TextBox.TextSize = 13
			TextBox.ClearTextOnFocus = false
			Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)
			Instance.new("UIStroke", TextBox).Color = Color3.fromRGB(80, 80, 80)

			local FocusLost = TextBox.FocusLost
			local u732 = TextBox

			FocusLost:Connect(function(p69)
				if p69 and u732.Text ~= "" then
					id = u732.Text

					if u194 and u197 then
						u197.Image = "rbxassetid://" .. u732.Text
					end

					u205:Notify({
						Title = "RuzHub",
						Content = tostring("Custom cursor applied — enable ShiftLock to see it!"),
						Duration = 3,
						Icon = "bell",
					})
					u732.Text = ""
				end
			end)

			local Frame7 = Instance.new("Frame", Frame)

			Frame7.Size = UDim2.new(1, -20, 0, 30)
			Frame7.Position = UDim2.new(0, 10, 0, 84)
			Frame7.BackgroundTransparency = 1

			local TextLabel7 = Instance.new("TextLabel", Frame7)

			TextLabel7.Size = UDim2.new(1, -64, 1, 0)
			TextLabel7.BackgroundTransparency = 1
			TextLabel7.Text = "Spin Crosshair"
			TextLabel7.TextColor3 = Color3.fromRGB(200, 200, 200)
			TextLabel7.Font = Enum.Font.GothamBold
			TextLabel7.TextSize = 13
			TextLabel7.TextXAlignment = Enum.TextXAlignment.Left

			local TextButton7 = Instance.new("TextButton", Frame7)

			TextButton7.Size = UDim2.new(0, 54, 0, 26)
			TextButton7.Position = UDim2.new(1, -54, 0.5, -13)
			TextButton7.BackgroundColor3 = u195 and Color3.fromRGB(30, 160, 30) or Color3.fromRGB(80, 20, 20)
			TextButton7.Text = u195 and "ON" or "OFF"
			TextButton7.TextColor3 = Color3.new(1, 1, 1)
			TextButton7.Font = Enum.Font.GothamBold
			TextButton7.TextSize = 12
			Instance.new("UICorner", TextButton7).CornerRadius = UDim.new(0, 8)

			local MouseButton1Click6 = TextButton7.MouseButton1Click
			local u737 = TextButton7

			MouseButton1Click6:Connect(function()
				u195 = not u195
				u737.BackgroundColor3 = u195 and Color3.fromRGB(30, 160, 30) or Color3.fromRGB(80, 20, 20)
				u737.Text = u195 and "ON" or "OFF"
				u206()

				local v933 = "Crosshair Spin: " .. (u195 and "ON" or "OFF")

				u205:Notify({
					Title = "RuzHub",
					Content = tostring(v933),
					Duration = 3,
					Icon = "bell",
				})
			end)

			local Frame8 = Instance.new("Frame", Frame)

			Frame8.Size = UDim2.new(1, -20, 0, 1)
			Frame8.Position = UDim2.new(0, 10, 0, 120)
			Frame8.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			Frame8.BorderSizePixel = 0

			local ScrollingFrame = Instance.new("ScrollingFrame", Frame)

			ScrollingFrame.Size = UDim2.new(1, -14, 1, -128)
			ScrollingFrame.Position = UDim2.new(0, 7, 0, 126)
			ScrollingFrame.BackgroundTransparency = 1
			ScrollingFrame.BorderSizePixel = 0
			ScrollingFrame.ScrollBarThickness = 4

			local new = UDim2.new
			local v741 = #u207 / 2

			ScrollingFrame.CanvasSize = new(0, 0, 0, math.ceil(v741) * 118 + 10)

			local UIGridLayout = Instance.new("UIGridLayout", ScrollingFrame)

			UIGridLayout.CellSize = UDim2.new(0, 128, 0, 110)
			UIGridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
			UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder

			for i, v in ipairs(u207) do
				local v745 = id == v.id
				local TextButton8 = Instance.new("TextButton", ScrollingFrame)

				TextButton8.Size = UDim2.new(0, 128, 0, 110)
				TextButton8.BackgroundColor3 = v745 and Color3.fromRGB(55, 15, 15) or Color3.fromRGB(20, 20, 20)
				TextButton8.Text = ""
				TextButton8.AutoButtonColor = false
				TextButton8.LayoutOrder = i
				Instance.new("UICorner", TextButton8).CornerRadius = UDim.new(0, 8)

				local UIStroke4 = Instance.new("UIStroke", TextButton8)

				UIStroke4.Color = v745 and Color3.fromRGB(220, 38, 38) or Color3.fromRGB(50, 50, 50)
				UIStroke4.Thickness = v745 and 1.8 or 1.2

				local ImageLabel = Instance.new("ImageLabel", TextButton8)

				ImageLabel.Size = UDim2.new(0, 58, 0, 58)
				ImageLabel.AnchorPoint = Vector2.new(0.5, 0)
				ImageLabel.Position = UDim2.new(0.5, 0, 0, 8)
				ImageLabel.BackgroundTransparency = 1
				ImageLabel.Image = "rbxassetid://" .. v.id

				local TextLabel8 = Instance.new("TextLabel", TextButton8)

				TextLabel8.Size = UDim2.new(1, -6, 0, 28)
				TextLabel8.Position = UDim2.new(0, 3, 1, -30)
				TextLabel8.BackgroundTransparency = 1
				TextLabel8.Text = v.name .. (v745 and " ✓" or "")
				TextLabel8.TextColor3 = v745 and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(200, 200, 200)
				TextLabel8.Font = Enum.Font.GothamBold
				TextLabel8.TextSize = 11
				TextLabel8.TextWrapped = true

				local MouseButton1Click7 = TextButton8.MouseButton1Click
				local u751 = v
				local u752 = ScreenGui

				MouseButton1Click7:Connect(function()
					id = u751.id

					if u194 and u197 then
						u197.Image = "rbxassetid://" .. u751.id
					end

					local v934 = "Cursor: " .. u751.name .. " — enable ShiftLock to see it!"

					u205:Notify({
						Title = "RuzHub",
						Content = tostring(v934),
						Duration = 3,
						Icon = "bell",
					})
					u752:Destroy()
				end)
			end

			u208(Frame)

			return
		end

		RuzCursorPicker:Destroy()
	end,
})
v292:Divider()
v292:Paragraph({
	Title = "Graphics",
	Content = "Low: removes textures, map looks flat, boosts FPS.\nHigh: Bloom, SunRays, enhanced lighting.",
})

local t40 = {
	Title = "Low Graphics (FPS Boost)",
	Default = false,
}

local function u323()
	if u16 then
		u16 = false
		u169.Brightness = u170.Brightness
		u169.GlobalShadows = u170.GlobalShadows
		u169.Ambient = u170.Ambient
		u169.OutdoorAmbient = u170.OutdoorAmbient

		for _, child in pairs(u169:GetChildren()) do
			if child:IsA("BloomEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") then
				child:Destroy()
			end
		end
	end

	u15 = true
	pcall(function()
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	end)
	pcall(function()
		setfpscap(9999)
	end)
	u169.GlobalShadows = false
	u169.Brightness = 2

	for _, descendant in ipairs(u171:GetDescendants()) do
		local _pcall = pcall
		local u709 = descendant

		pcall(function()
			u172(u709)
		end)
	end

	if u168 then
		u168:Disconnect()
	end

	u168 = u171.DescendantAdded:Connect(function(descendant)
		task.wait(0.1)
		local u925 = descendant

		pcall(function()
			u172(u925)
		end)
	end)
	u173.Visible = true
	u174:Notify({
		Title = "RuzHub",
		Content = tostring("Low Graphics ON — FPS boost active"),
		Duration = 3,
		Icon = "bell",
	})
end

local u324 = v179

function t40.Callback(p70)
	if not p70 then
		u324()

		return
	end

	u323()
end

v292:Toggle(t40)

local t41 = {
	Title = "High Graphics (Beautiful)",
	Default = false,
}

local function u326()
	if u15 then
		u180()
	end

	u16 = true
	pcall(function()
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
	end)
	u181.GlobalShadows = true
	u181.Brightness = 3.5
	u181.Ambient = Color3.fromRGB(80, 80, 100)
	u181.OutdoorAmbient = Color3.fromRGB(100, 110, 130)

	local v715 = u181:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect", u181)

	v715.Intensity = 0.6
	v715.Size = 24
	v715.Threshold = 0.95

	local v716 = u181:FindFirstChildOfClass("SunRaysEffect") or Instance.new("SunRaysEffect", u181)

	v716.Intensity = 0.25
	v716.Spread = 1

	local v717 = u181:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", u181)

	v717.Saturation = 0.2
	v717.Contrast = 0.1
	v717.Brightness = 0.05
	u182:Notify({
		Title = "RuzHub",
		Content = tostring("High Graphics ON"),
		Duration = 3,
		Icon = "bell",
	})
end
local function u327()
	u16 = false
	pcall(function()
		settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
	end)
	u183.Brightness = u184.Brightness
	u183.GlobalShadows = u184.GlobalShadows
	u183.Ambient = u184.Ambient
	u183.OutdoorAmbient = u184.OutdoorAmbient

	for _, child in pairs(u183:GetChildren()) do
		if child:IsA("BloomEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") then
			child:Destroy()
		end
	end

	u185:Notify({
		Title = "RuzHub",
		Content = tostring("High Graphics OFF"),
		Duration = 3,
		Icon = "bell",
	})
end

function t41.Callback(p71)
	if not p71 then
		u327()

		return
	end

	u326()
end

v292:Toggle(t41)

local t42 = {
	Title = "FOV Slider",
	Description = "Mobile-friendly field of view selector",
}
local u329 = v25
local u330 = CurrentCamera
local u331 = v18

function t42.Callback()
	u329("Field of View", 30, 120, n3, 5, function(p72)
		n3 = p72
		u330.FieldOfView = p72
	end, function()
		n3 = 70
		u330.FieldOfView = 70
		u331:Notify({
			Title = "RuzHub",
			Content = tostring("FOV reset to 70"),
			Duration = 3,
			Icon = "bell",
		})
	end)
end

v292:Button(t42)
v292:Divider()
v292:Paragraph({
	Title = "Extra Scripts",
	Content = "Universal scripts and additional tools.",
})

local t43 = {
	Title = "Load Emotes GUI",
	Description = "7yd7 emote panel",
}
local u333 = v18

function t43.Callback()
	local ok, result = pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"))()
	end)
	local v828 = ok and "Emotes GUI loaded!" or "Error: " .. tostring(result)

	u333:Notify({
		Title = "RuzHub",
		Content = tostring(v828),
		Duration = 3,
		Icon = "bell",
	})
end

v292:Button(t43)

local t44 = {
	Title = "Load Infinite Yield",
	Description = "Admin script",
}
local u335 = v18

function t44.Callback()
	local ok, result = pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	end)
	local v831 = ok and "Infinite Yield loaded!" or "Error: " .. tostring(result)

	u335:Notify({
		Title = "RuzHub",
		Content = tostring(v831),
		Duration = 3,
		Icon = "bell",
	})
end

v292:Button(t44)
v292:Divider()

local t45 = {
	Title = "Anti-Fling",
	Description = "Limits velocity to prevent being launched",
	Default = false,
}

local function u337(p73)
	u149 = p73

	if not p73 then
		if u150 then
			u150:Disconnect()
			u150 = nil
		end

		return
	end

	if u150 then
		u150:Disconnect()
	end

	u150 = u151.Heartbeat:Connect(function()
		if u149 then
			local Character = u152.Character
			local v908 = Character and Character:FindFirstChild("HumanoidRootPart")

			if v908 then
				local AssemblyLinearVelocity = v908.AssemblyLinearVelocity

				if AssemblyLinearVelocity.Magnitude > n1 then
					v908.AssemblyLinearVelocity = AssemblyLinearVelocity.Unit * n1
				end
			end

			return
		end
	end)
end

local u338 = v18

function t45.Callback(p74)
	u337(p74)

	local v833 = p74 and "Anti-Fling ON" or "Anti-Fling OFF"

	u338:Notify({
		Title = "RuzHub",
		Content = tostring(v833),
		Duration = 3,
		Icon = "bell",
	})
end

v292:Toggle(t45)

local t46 = {
	Title = "Auto Ping Prediction",
	Description = "Adds ping offset to shoot and throw",
	Default = false,
}
local u340 = v18

function t46.Callback(p75)
	u13 = p75

	local v835 = p75 and "Ping Prediction ON" or "Ping Prediction OFF"

	u340:Notify({
		Title = "RuzHub",
		Content = tostring(v835),
		Duration = 3,
		Icon = "bell",
	})
end

v292:Toggle(t46)

local t47 = {
	Title = "Speed Glitch Slider",
	Description = "Mobile-friendly speed selector",
}
local u342 = v25
local u343 = v18

function t47.Callback()
	u342("Speed Glitch", 50, 600, n2, 10, function(p76)
		n2 = p76
	end, function()
		n2 = 200
		u343:Notify({
			Title = "RuzHub",
			Content = tostring("Speed reset to 200"),
			Duration = 3,
			Icon = "bell",
		})
	end)
end

v292:Button(t47)
v292:Dropdown({
	Title = "Velocity Cap (Anti-Fling)",
	Options = {
		"50",
		"100",
		"150",
		"200",
		"300",
		"500",
	},
	Default = "200",
	Callback = function(p77)
		n1 = tonumber(p77) or 200
	end,
})

local t48 = {
	Title = "Enable ESP",
	Default = false,
}
local u345 = v78
local u346 = v68
local u347 = v18

function t48.Callback(p78)
	u61 = p78

	if not p78 then
		if u62 then
			u62:Disconnect()
			u62 = nil
		end

		task.delay(0.1, u346)
	else
		u345()
	end

	local v838 = p78 and "ESP ON" or "ESP OFF"

	u347:Notify({
		Title = "RuzHub",
		Content = tostring(v838),
		Duration = 3,
		Icon = "bell",
	})
end

v293:Toggle(t48)
v293:Divider()

local t49 = {
	Title = "Show Murderer",
	Default = true,
}
local u349 = t3

function t49.Callback(p79)
	u349.Murderer = p79
end

v293:Toggle(t49)

local t50 = {
	Title = "Show Sheriff",
	Default = true,
}
local u351 = t3

function t50.Callback(p80)
	u351.Sheriff = p80
end

v293:Toggle(t50)

local t51 = {
	Title = "Show Hero",
	Default = true,
}
local u353 = t3

function t51.Callback(p81)
	u353.Hero = p81
end

v293:Toggle(t51)

local t52 = {
	Title = "Show Innocents",
	Default = true,
}
local u355 = t3

function t52.Callback(p82)
	u355.Innocent = p82
end

v293:Toggle(t52)

local t53 = {
	Title = "Show Self",
	Default = true,
}
local u357 = t3

function t53.Callback(p83)
	u357.Self = p83
end

v293:Toggle(t53)

local t54 = {
	Title = "Dropped Gun ESP",
	Description = "Highlight and label when a gun is on the map",
	Default = true,
}
local u359 = v18

function t54.Callback(p84)
	u17 = p84

	if not p84 then
		if u31 then
			u31:Destroy()
			u31 = nil
		end

		if u32 then
			u32:Destroy()
			u32 = nil
		end

		if u29 then
			u29:Destroy()
			u29 = nil
		end
	end

	local v845 = p84 and "Gun ESP ON" or "Gun ESP OFF"

	u359:Notify({
		Title = "RuzHub",
		Content = tostring(v845),
		Duration = 3,
		Icon = "bell",
	})
end

v293:Toggle(t54)
v293:Divider()

local t55 = {
	Title = "Murderer Color",
	Default = Color3.fromRGB(255, 40, 40),
}
local u361 = t4

function t55.Callback(p85)
	u361.Murderer = p85
end

v293:ColorPicker(t55)

local t56 = {
	Title = "Sheriff Color",
	Default = Color3.fromRGB(40, 130, 255),
}
local u363 = t4

function t56.Callback(p86)
	u363.Sheriff = p86
end

v293:ColorPicker(t56)

local t57 = {
	Title = "Hero Color",
	Default = Color3.fromRGB(255, 215, 0),
}
local u365 = t4

function t57.Callback(p87)
	u365.Hero = p87
end

v293:ColorPicker(t57)

local t58 = {
	Title = "Innocent Color",
	Default = Color3.fromRGB(0, 220, 0),
}
local u367 = t4

function t58.Callback(p88)
	u367.Innocent = p88
end

v293:ColorPicker(t58)
task.wait(0.4)
v227(true)
v234(true)
v241(true)
v18:Notify({
	Title = "RuzHub",
	Content = tostring("RuzHub v7.3 ready!"),
	Duration = 3,
	Icon = "bell",
})
print("[RuzHub] v7.3 loaded.")
