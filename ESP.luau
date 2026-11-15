--[[
    Radiance ESP
    Full player ESP system. Depends on Library (Flags + Framework).
    Usage:
        local Library = loadstring(...)()
        local ESP = loadstring(...)()
        ESP.Init(Library)
        -- Flags are driven by the menu; ESP.Update runs on Heartbeat automatically
        -- or call ESP.Start() after building your menu
]]

local ESP = {}

function ESP.Init(Library)
    local Framework = Library.Framework or Library
    local Services = Framework.Services
    local Flags = Library.Flags or getfenv(0)["Flags"] or {}
    local Assets = Library.Assets

    local Camera = workspace.CurrentCamera
    local Players = Services.Players
    local LocalPlayer = Players.LocalPlayer

    local udim2 = UDim2.new
    local vec2 = Vector2.new
    local clamp = math.clamp
    local floor = math.floor
    local rad = math.rad
    local tan = math.tan

    local playerESP = {
        objects = {},
    }

    function playerESP.GetBounds(character)
        if not character then return nil, nil, nil end
        local ok, cf, size = pcall(function()
            return character:GetBoundingBox()
        end)
        if ok and cf and size then
            return cf, size, cf.Position
        end
        local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character.PrimaryPart
        if hrp then
            return hrp.CFrame, Vector3.new(4, 5, 1), hrp.Position
        end
        return nil, nil, nil
    end

    function playerESP.create(player)
        if playerESP.objects[player] then return end
        if player == LocalPlayer then return end

        local drawings = {}
        local parent = (gethui and gethui()) or (cloneref and cloneref(Services.CoreGui)) or Services.CoreGui

        local screen = Instance.new("ScreenGui")
        screen.Name = "RadianceESP_" .. player.Name
        screen.IgnoreGuiInset = true
        screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screen.DisplayOrder = 50
        screen.Parent = parent

        -- Box
        drawings.box = Instance.new("Frame")
        drawings.box.BackgroundTransparency = 1
        drawings.box.BorderSizePixel = 0
        drawings.box.Visible = false
        drawings.box.Parent = screen

        drawings.boxgradient = Instance.new("UIGradient")
        drawings.boxgradient.Rotation = -90
        drawings.boxgradient.Parent = drawings.box

        drawings.boxstroke = Instance.new("UIStroke")
        drawings.boxstroke.Thickness = 1
        drawings.boxstroke.Parent = drawings.box

        drawings.strokegradient = Instance.new("UIGradient")
        drawings.strokegradient.Rotation = -90
        drawings.strokegradient.Parent = drawings.boxstroke

        drawings.boxglow = Instance.new("ImageLabel")
        drawings.boxglow.BackgroundTransparency = 1
        drawings.boxglow.Image = "rbxassetid://5028857084"
        drawings.boxglow.ScaleType = Enum.ScaleType.Slice
        drawings.boxglow.SliceCenter = Rect.new(24, 24, 276, 276)
        drawings.boxglow.Visible = false
        drawings.boxglow.Parent = drawings.box

        -- Healthbar
        drawings.behindhealthbar = Instance.new("Frame")
        drawings.behindhealthbar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        drawings.behindhealthbar.BorderSizePixel = 0
        drawings.behindhealthbar.Visible = false
        drawings.behindhealthbar.Parent = screen

        drawings.healthbar = Instance.new("Frame")
        drawings.healthbar.BorderSizePixel = 0
        drawings.healthbar.Visible = false
        drawings.healthbar.Parent = screen

        drawings.healthbargradient = Instance.new("UIGradient")
        drawings.healthbargradient.Parent = drawings.healthbar

        drawings.healthtext = Instance.new("TextLabel")
        drawings.healthtext.BackgroundTransparency = 1
        drawings.healthtext.TextStrokeTransparency = 0.5
        drawings.healthtext.Visible = false
        drawings.healthtext.Parent = screen

        -- Username / distance / held item / flags
        drawings.username = Instance.new("TextLabel")
        drawings.username.BackgroundTransparency = 1
        drawings.username.TextStrokeTransparency = 0.5
        drawings.username.Visible = false
        drawings.username.Parent = screen

        drawings.distance = Instance.new("TextLabel")
        drawings.distance.BackgroundTransparency = 1
        drawings.distance.TextStrokeTransparency = 0.5
        drawings.distance.Visible = false
        drawings.distance.Parent = screen

        drawings.helditem = Instance.new("TextLabel")
        drawings.helditem.BackgroundTransparency = 1
        drawings.helditem.TextStrokeTransparency = 0.5
        drawings.helditem.Visible = false
        drawings.helditem.Parent = screen

        drawings.helditemimage = Instance.new("ImageLabel")
        drawings.helditemimage.BackgroundTransparency = 1
        drawings.helditemimage.Visible = false
        drawings.helditemimage.Parent = screen

        drawings.flags = Instance.new("TextLabel")
        drawings.flags.BackgroundTransparency = 1
        drawings.flags.RichText = true
        drawings.flags.TextStrokeTransparency = 0.5
        drawings.flags.Visible = false
        drawings.flags.Parent = screen

        drawings.target = Instance.new("TextLabel")
        drawings.target.BackgroundTransparency = 1
        drawings.target.Text = "TARGET"
        drawings.target.TextStrokeTransparency = 0.5
        drawings.target.Visible = false
        drawings.target.Parent = screen

        -- Head circle
        drawings.headcircle = Instance.new("Frame")
        drawings.headcircle.BackgroundTransparency = 1
        drawings.headcircle.BorderSizePixel = 0
        drawings.headcircle.Visible = false
        drawings.headcircle.Parent = screen
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = drawings.headcircle
        drawings.circlecolor = Instance.new("UIStroke")
        drawings.circlecolor.Thickness = 1
        drawings.circlecolor.Parent = drawings.headcircle

        -- View direction
        drawings.viewdirection = Instance.new("Frame")
        drawings.viewdirection.BorderSizePixel = 0
        drawings.viewdirection.AnchorPoint = Vector2.new(0.5, 0.5)
        drawings.viewdirection.Visible = false
        drawings.viewdirection.Parent = screen
        drawings.viewdirectioncolor = Instance.new("UIStroke")
        drawings.viewdirectioncolor.Thickness = 1
        drawings.viewdirectioncolor.Parent = drawings.viewdirection

        -- Chams
        drawings.highlight = Instance.new("Highlight")
        drawings.highlight.Enabled = false
        drawings.highlight.Parent = screen

        local obj = {
            player = player,
            hum = nil,
            drawings = drawings,
            screen = screen,
            healthlerp = 1,
        }

        function obj:sethidden()
            for _, d in pairs(self.drawings) do
                if typeof(d) == "Instance" then
                    if d:IsA("Highlight") then
                        d.Enabled = false
                    else
                        d.Visible = false
                    end
                end
            end
        end

        function obj:destroy()
            if self.screen then self.screen:Destroy() end
            playerESP.objects[player] = nil
        end

        function obj:drawusername(x, y, distance)
            local f = Flags
            self.drawings.username.Visible = f["Draw Username"] == true
            self.drawings.username.Text = self.player.DisplayName ~= "" and self.player.DisplayName or self.player.Name
            self.drawings.username.TextColor3 = f["Username Color"] or Color3.new(1,1,1)
            self.drawings.username.Position = UDim2.new(0, x, 0, y)
            self.drawings.username.Size = UDim2.new(0, 200, 0, 16)
            self.drawings.username.TextXAlignment = Enum.TextXAlignment.Center
            self.drawings.username.TextYAlignment = Enum.TextYAlignment.Bottom
            if Framework.CurrentFont then self.drawings.username.FontFace = Framework.CurrentFont end
            if Framework.CurrentSize then self.drawings.username.TextSize = Framework.CurrentSize end
        end

        function obj:drawtarget(x, y)
            -- reserved for aimbot target indicator
            self.drawings.target.Visible = false
        end

        function obj:drawdistance(distance)
            local f = Flags
            self.drawings.distance.Visible = f["Draw Distance"] == true
            local unit = f["Render Units"] or "Studs"
            self.drawings.distance.Text = tostring(distance) .. " " .. tostring(unit):lower()
            self.drawings.distance.TextColor3 = f["Distance Color"] or Color3.new(1,1,1)
            if Framework.CurrentFont then self.drawings.distance.FontFace = Framework.CurrentFont end
            if Framework.CurrentSize then self.drawings.distance.TextSize = Framework.CurrentSize end
        end

        function obj:drawhelditem(x, y)
            local f = Flags
            local char = self.player.Character
            local tool = char and char:FindFirstChildOfClass("Tool")
            local name = tool and tool.Name or ""
            local brackets = f["Held Item Brackets"] or "[]"
            local left, right = "[", "]"
            if brackets == "()" then left, right = "(", ")" end
            if brackets == "Default" then left, right = "", "" end

            self.drawings.helditem.Visible = f["Draw HeldItem"] == true and name ~= ""
            self.drawings.helditem.Text = left .. name .. right
            self.drawings.helditem.TextColor3 = f["HeldItem Color"] or Color3.new(1,1,1)
            self.drawings.helditem.Position = UDim2.new(0, x, 0, y)
            self.drawings.helditem.Size = UDim2.new(0, 200, 0, 16)
            self.drawings.helditem.TextXAlignment = Enum.TextXAlignment.Center
            self.drawings.helditem.TextYAlignment = Enum.TextYAlignment.Bottom
            if Framework.CurrentFont then self.drawings.helditem.FontFace = Framework.CurrentFont end
            if Framework.CurrentSize then self.drawings.helditem.TextSize = Framework.CurrentSize end

            local imgOffset = -2
            if f["Draw HeldItem"] then imgOffset = 8 end
            self.drawings.helditemimage.Position = UDim2.new(0, x, 0, y + imgOffset)
            self.drawings.helditemimage.Size = UDim2.new(0, f["Image Size"] or 32, 0, f["Image Size"] or 32)
            self.drawings.helditemimage.ImageColor3 = f["HeldItem Image Color"] or Color3.new(1,1,1)
            self.drawings.helditemimage.Visible = f["HeldItem Image"] == true and name ~= ""

            local distOffset = f["Distance Offset"] or 16
            if f["Draw HeldItem"] and not f["HeldItem Image"] then
                self.drawings.distance.Position = UDim2.new(0, x, 0, y + distOffset - 4)
            elseif not f["Draw HeldItem"] and not f["HeldItem Image"] then
                self.drawings.distance.Position = UDim2.new(0, x, 0, y)
            else
                self.drawings.distance.Position = UDim2.new(0, x, 0, y + distOffset + imgOffset)
            end
            self.drawings.distance.Size = UDim2.new(0, 200, 0, 16)
            self.drawings.distance.TextXAlignment = Enum.TextXAlignment.Center
        end

        function obj:drawflags(box_x, box_y, box_w)
            local f = Flags
            local pos = f["Healthbar Position"] or "Left"
            local offsetX = (pos == "Right") and 13 or 4
            local t = {}
            -- placeholder flags; wire real state when game-specific data exists
            if f["Draw Flags"] then
                t[#t+1] = '<font color="#888888">Rel</font>'
                t[#t+1] = '<font color="#00B7FF">Scope</font>'
                t[#t+1] = '<font color="#FFFF00">Heal</font>'
                t[#t+1] = '<font color="#FF4040">Manip</font>'
                t[#t+1] = '<font color="#00FF00">Safe</font>'
            end
            local text = table.concat(t, '<font color="#FFFFFF">, </font>')
            self.drawings.flags.Visible = text ~= "" and f["Draw Flags"] == true
            self.drawings.flags.Text = text
            self.drawings.flags.Position = UDim2.new(0, box_x + box_w + offsetX, 0, box_y - 3)
            self.drawings.flags.Size = UDim2.new(0, 200, 0, 14)
            self.drawings.flags.TextXAlignment = Enum.TextXAlignment.Left
            self.drawings.flags.TextYAlignment = Enum.TextYAlignment.Top
            if Framework.CurrentFont then self.drawings.flags.FontFace = Framework.CurrentFont end
            if Framework.CurrentSize then self.drawings.flags.TextSize = Framework.CurrentSize end
        end

        function obj:drawbox(x, y, w, h)
            local f = Flags
            self.drawings.box.Position = UDim2.new(0, x, 0, y)
            self.drawings.box.Size = UDim2.new(0, w, 0, h)
            self.drawings.box.Visible = f["Draw Box"] == true
            self.drawings.box.BackgroundTransparency = f["Filled Box"] and (f["Filled Transparency"] or 70) / 100 or 1

            self.drawings.boxgradient.Enabled = f["Filled Box"] == true
            local ft = f["Filled Top Color"] or Color3.new(1,1,1)
            local fm = f["Filled Middle Color"] or Color3.new(1,1,1)
            local fb = f["Filled Bottom Color"] or Color3.new(1,1,1)
            self.drawings.boxgradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, fb),
                ColorSequenceKeypoint.new(0.5, fm),
                ColorSequenceKeypoint.new(1, ft)
            }

            self.drawings.boxstroke.Enabled = f["Draw Box"] == true
            local bt = f["Box Top Color"] or Color3.new(1,1,1)
            local bm = f["Box Middle Color"] or Color3.new(1,1,1)
            local bb = f["Box Bottom Color"] or Color3.new(1,1,1)
            self.drawings.strokegradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, bb),
                ColorSequenceKeypoint.new(0.5, bm),
                ColorSequenceKeypoint.new(1, bt)
            }

            if f["Rainbow Filled"] then
                local colors = {
                    Color3.fromRGB(255,179,186), Color3.fromRGB(255,223,186), Color3.fromRGB(255,255,186),
                    Color3.fromRGB(186,255,201), Color3.fromRGB(186,225,255), Color3.fromRGB(201,186,255)
                }
                if f["Box Animation"] then
                    local t = tick() * (f["Animation Speed"] or 2)
                    local fr = t % 6
                    local i = floor(fr) + 1
                    local nexti = i % 6 + 1
                    local blend = fr % 1
                    local rotated = {}
                    for idx = 1, 6 do
                        rotated[idx] = colors[((idx - 1 + i - 1) % 6) + 1]:Lerp(colors[((idx - 1 + nexti - 1) % 6) + 1], blend)
                    end
                    colors = rotated
                end
                self.drawings.boxgradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, colors[1]),
                    ColorSequenceKeypoint.new(0.2, colors[2]),
                    ColorSequenceKeypoint.new(0.4, colors[3]),
                    ColorSequenceKeypoint.new(0.6, colors[4]),
                    ColorSequenceKeypoint.new(0.8, colors[5]),
                    ColorSequenceKeypoint.new(1, colors[6])
                }
            end

            if f["Box Animation"] then
                local s = f["Animation Speed"] or 2
                local r = (tick()*60*s)%(720*2)
                if r > 720 then r = 720 - (r-720) end
                self.drawings.boxgradient.Rotation = r
                self.drawings.strokegradient.Rotation = r
            else
                self.drawings.boxgradient.Rotation = -90
                self.drawings.strokegradient.Rotation = -90
            end

            if f["Box Glow"] then
                self.drawings.boxglow.Visible = true
                self.drawings.boxglow.ImageColor3 = f["Box Glow Color"] or Color3.new(1,1,1)
                self.drawings.boxglow.ImageTransparency = f["Box Glow Transparency"] or 0.4
                local minW, maxW, minGlow, maxGlow = 6, 43, 7, 44
                local ratio = math.clamp((w - minW) / (maxW - minW), 0, 1)
                local s = minGlow + (maxGlow - minGlow) * ratio
                self.drawings.boxglow.Size = UDim2.new(1, s, 1, s)
            else
                self.drawings.boxglow.Visible = false
            end
        end

        function obj:drawhealthbar(box_height, box_x, box_y)
            local f = Flags
            local humanoid = self.hum
            local health = humanoid and humanoid.Health or 0
            local max_health = humanoid and humanoid.MaxHealth or 100
            local healthp = clamp(health / max_health, 0, 1)

            if not self.healthlerp then self.healthlerp = healthp end
            self.healthlerp = self.healthlerp + (healthp - self.healthlerp) * 0.1

            local bar_width = f["Healthbar Thickness"] or 2
            local filled_height = box_height * self.healthlerp
            local shift_x = bar_width > 2 and (bar_width - 2) or 0
            local box_width = (self.drawings.box and self.drawings.box.Size and self.drawings.box.Size.X.Offset) or 0
            local pos = f["Healthbar Position"] or "Left"
            local healthbar_x, healthbar_y, healthbar_w, healthbar_h

            if pos == "Right" then
                local bx = box_x + box_width + 5
                self.drawings.behindhealthbar.Position = UDim2.new(0, bx, 0, box_y)
                self.drawings.behindhealthbar.Size = UDim2.new(0, bar_width, 0, box_height)
                self.drawings.healthbar.Position = UDim2.new(0, bx, 0, box_y + (box_height - filled_height))
                self.drawings.healthbar.Size = UDim2.new(0, bar_width, 0, filled_height)
                healthbar_x, healthbar_y, healthbar_w, healthbar_h = bx, box_y + (box_height - filled_height), bar_width, filled_height
            elseif pos == "Bottom" then
                local by = box_y + box_height + 5
                self.drawings.behindhealthbar.Position = UDim2.new(0, box_x, 0, by)
                self.drawings.behindhealthbar.Size = UDim2.new(0, box_width, 0, bar_width)
                self.drawings.healthbar.Position = UDim2.new(0, box_x, 0, by)
                self.drawings.healthbar.Size = UDim2.new(0, box_width * self.healthlerp + 1, 0, bar_width)
                healthbar_x, healthbar_y, healthbar_w, healthbar_h = box_x + box_width * self.healthlerp / 2, by, box_width * self.healthlerp, bar_width
            elseif pos == "Top" then
                local by = box_y - bar_width - 5
                self.drawings.behindhealthbar.Position = UDim2.new(0, box_x, 0, by)
                self.drawings.behindhealthbar.Size = UDim2.new(0, box_width, 0, bar_width)
                self.drawings.healthbar.Position = UDim2.new(0, box_x, 0, by)
                self.drawings.healthbar.Size = UDim2.new(0, box_width * self.healthlerp + 1, 0, bar_width)
                healthbar_x, healthbar_y, healthbar_w, healthbar_h = box_x + box_width * self.healthlerp / 2, by, box_width * self.healthlerp, bar_width
            else
                local bx = box_x - 7 - shift_x
                self.drawings.behindhealthbar.Position = UDim2.new(0, bx, 0, box_y)
                self.drawings.behindhealthbar.Size = UDim2.new(0, bar_width, 0, box_height)
                self.drawings.healthbar.Position = UDim2.new(0, bx, 0, box_y + (box_height - filled_height))
                self.drawings.healthbar.Size = UDim2.new(0, bar_width, 0, filled_height)
                healthbar_x, healthbar_y, healthbar_w, healthbar_h = bx, box_y + (box_height - filled_height), bar_width, filled_height
            end

            self.drawings.behindhealthbar.Visible = f["Draw Healthbar"] == true
            self.drawings.healthbar.Visible = f["Draw Healthbar"] == true
            self.drawings.healthbargradient.Enabled = f["Draw Healthbar"] == true

            local health_color = Color3.new(1, 0, 0):lerp(Color3.new(0.7, 0.8, 0), self.healthlerp)
            health_color = health_color:lerp(Color3.new(0, 1, 0), math.clamp((self.healthlerp - 0.5) * 2, 0, 1))
            local health_offset = math.clamp((1 - self.healthlerp), 0, 1)

            if pos == "Top" or pos == "Bottom" then
                self.drawings.healthbargradient.Rotation = 0
                self.drawings.healthbargradient.Offset = Vector2.new(health_offset, 0)
            else
                self.drawings.healthbargradient.Rotation = -90
                self.drawings.healthbargradient.Offset = Vector2.new(0, -health_offset)
            end

            local htype = f["Healthbar Type"] or "Gradient"
            if htype == "Solid" then
                self.drawings.healthbargradient.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, health_color), ColorSequenceKeypoint.new(1, health_color) }
            elseif htype == "Rainbow" then
                local colors = {
                    Color3.fromRGB(255,179,186), Color3.fromRGB(255,223,186), Color3.fromRGB(255,255,186),
                    Color3.fromRGB(186,255,201), Color3.fromRGB(186,225,255), Color3.fromRGB(201,186,255)
                }
                if f["Healthbar Animation"] then
                    local t = tick() * (f["Healthbar Animation Speed"] or 2)
                    local fr = t % 6
                    local i = floor(fr) + 1
                    local nexti = i % 6 + 1
                    local blend = fr % 1
                    local rotated = {}
                    for idx = 1, 6 do
                        rotated[idx] = colors[((idx - 1 + i - 1) % 6) + 1]:Lerp(colors[((idx - 1 + nexti - 1) % 6) + 1], blend)
                    end
                    colors = rotated
                end
                self.drawings.healthbargradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, colors[1]), ColorSequenceKeypoint.new(0.2, colors[2]),
                    ColorSequenceKeypoint.new(0.4, colors[3]), ColorSequenceKeypoint.new(0.6, colors[4]),
                    ColorSequenceKeypoint.new(0.8, colors[5]), ColorSequenceKeypoint.new(1, colors[6])
                }
            else
                local hb = f["Healthbar Bottom Color"] or Color3.new(1,0,0)
                local hm = f["Healthbar Middle Color"] or Color3.new(1,1,0)
                local ht = f["Healthbar Top Color"] or Color3.new(0,1,0)
                if f["Healthbar Animation"] then
                    local t = tick() * (f["Healthbar Animation Speed"] or 2)
                    local colors = { hb, hm, ht }
                    local fr = t % 3
                    local i = floor(fr) + 1
                    local nexti = i % 3 + 1
                    local blend = fr % 1
                    local rotated = {}
                    for idx = 1, 3 do
                        rotated[idx] = colors[((idx - 1 + i - 1) % 3) + 1]:Lerp(colors[((idx - 1 + nexti - 1) % 3) + 1], blend)
                    end
                    self.drawings.healthbargradient.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, rotated[1]),
                        ColorSequenceKeypoint.new(0.5, rotated[2]),
                        ColorSequenceKeypoint.new(1, rotated[3])
                    }
                else
                    self.drawings.healthbargradient.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, hb),
                        ColorSequenceKeypoint.new(0.5, hm),
                        ColorSequenceKeypoint.new(1, ht)
                    }
                end
            end

            if self.drawings.healthtext then
                if health >= max_health then
                    self.drawings.healthtext.Visible = false
                else
                    self.drawings.healthtext.Visible = f["Draw Healthtext"] == true
                    self.drawings.healthtext.TextColor3 = f["HealthText Color"] or Color3.new(1,1,1)
                    self.drawings.healthtext.Text = tostring(floor(health))
                    if pos == "Right" then
                        self.drawings.healthtext.Position = UDim2.new(0, healthbar_x + healthbar_w, 0, healthbar_y)
                    elseif pos == "Left" then
                        self.drawings.healthtext.Position = UDim2.new(0, healthbar_x, 0, healthbar_y)
                    elseif pos == "Top" then
                        self.drawings.healthtext.Position = UDim2.new(0, healthbar_x + healthbar_w/2 - 10, 0, healthbar_y)
                    else
                        self.drawings.healthtext.Position = UDim2.new(0, healthbar_x + healthbar_w/2 - 10, 0, healthbar_y + healthbar_h)
                    end
                    self.drawings.healthtext.Size = UDim2.new(0, 40, 0, 14)
                    if Framework.CurrentFont then self.drawings.healthtext.FontFace = Framework.CurrentFont end
                    if Framework.CurrentSize then self.drawings.healthtext.TextSize = Framework.CurrentSize end
                    self.drawings.healthtext.TextXAlignment = Enum.TextXAlignment.Center
                    self.drawings.healthtext.TextYAlignment = Enum.TextYAlignment.Center
                end
            end
        end

        function obj:drawviewdirection()
            local f = Flags
            local char = self.player.Character
            if not char then self.drawings.viewdirection.Visible = false return end
            local head = char:FindFirstChild("Head")
            if not head or not head.CFrame then self.drawings.viewdirection.Visible = false return end

            local startpos = head.Position
            local endpos = startpos + head.CFrame.LookVector * (f["View Direction Length"] or 5)
            local s1, o1 = Camera:WorldToScreenPoint(startpos)
            local s2, o2 = Camera:WorldToScreenPoint(endpos)
            if not (o1 and o2) then self.drawings.viewdirection.Visible = false return end

            local a = Vector2.new(s1.X, s1.Y)
            local b = Vector2.new(s2.X, s2.Y)
            local off = b - a
            local mid = a + off/2
            self.drawings.viewdirection.Position = UDim2.fromOffset(mid.X, mid.Y)
            self.drawings.viewdirection.Size = UDim2.fromOffset(off.Magnitude, 1)
            self.drawings.viewdirection.Rotation = math.deg(math.atan2(off.Y, off.X))
            self.drawings.viewdirection.Visible = f["View Direction"] == true
            self.drawings.viewdirectioncolor.Color = f["View Direction Color"] or Color3.new(1,1,1)
            self.drawings.viewdirectioncolor.Enabled = true
        end

        function obj:drawheadcircle(box_w, box_h)
            local f = Flags
            if not self.drawings.headcircle then return end
            local char = self.player.Character
            if not char then self.drawings.headcircle.Visible = false return end
            local head = char:FindFirstChild("Head")
            if not head then self.drawings.headcircle.Visible = false return end
            local pos, on = Camera:WorldToScreenPoint(head.Position)
            if not on then self.drawings.headcircle.Visible = false return end
            if not box_w or not box_h then self.drawings.headcircle.Visible = false return end

            local s = math.min(box_w, box_h * 0.24)
            if s < 4 then s = 4 end
            self.drawings.headcircle.BackgroundColor3 = f["Filled Circle Color"] or Color3.new(1,1,1)
            self.drawings.headcircle.BackgroundTransparency = f["Filled Circle"] and (f["Circle Fill Transparency"] or 70) / 100 or 1
            self.drawings.headcircle.Size = UDim2.new(0, s, 0, s)
            self.drawings.circlecolor.Color = f["Head Dot Color"] or Color3.new(1,1,1)
            self.drawings.headcircle.Position = UDim2.new(0, pos.X - s/2, 0, pos.Y - s/2)
            self.drawings.circlecolor.Enabled = f["Head Dot"] == true
            self.drawings.headcircle.Visible = f["Head Dot"] == true
        end

        function obj:drawchams()
            local f = Flags
            self.drawings.highlight.Adornee = self.player.Character
            self.drawings.highlight.Enabled = f["Player Chams"] == true
            self.drawings.highlight.FillColor = f["Chams Color"] or Color3.new(1,1,1)
            self.drawings.highlight.OutlineColor = f["Chams Color2"] or Color3.new(1,1,1)
            self.drawings.highlight.FillTransparency = (f["Fill Transparency"] or 0) / 100
            self.drawings.highlight.OutlineTransparency = (f["Outline Transparency"] or 0) / 100
            if f["Chams Type"] == "Breathe" then
                local e = math.atan(math.sin(tick()*3))*2/math.pi
                self.drawings.highlight.FillTransparency = (f["Fill Transparency"] or 0) * e * 0.01
            end
            self.drawings.highlight.DepthMode = f["Visible Check"] and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
        end

        playerESP.objects[player] = obj
        return obj
    end

    function playerESP.remove(player)
        local obj = playerESP.objects[player]
        if obj then obj:destroy() end
    end

    function ESP.Update()
        local f = Flags
        if not f["Enable ESP"] then
            for _, obj in pairs(playerESP.objects) do
                obj:sethidden()
            end
            return
        end

        for player, obj in pairs(playerESP.objects) do
            local hum = obj.hum
            if not hum and player.Character then
                hum = player.Character:FindFirstChildOfClass("Humanoid")
                obj.hum = hum
            end
            if not hum or hum.Health <= 0 then
                obj:sethidden()
                continue
            end

            local cf, size, position = playerESP.GetBounds(player.Character)
            if not position then
                obj:sethidden()
                continue
            end

            local screenpos, onscreen = Camera:WorldToScreenPoint(position)
            if not onscreen then
                obj:sethidden()
                continue
            end

            local distance = (position - Camera.CFrame.Position).Magnitude
            if f["Render Units"] == "Meters" then
                distance = distance * 0.28
            elseif f["Render Units"] == "Feet" then
                distance = distance * 0.92
            end
            distance = math.round(distance)
            if distance >= (f["Render Distance"] or 500) then
                obj:sethidden()
                continue
            end

            local fov = Camera.FieldOfView
            local zoom = clamp(60 / fov, 1, 1.25)
            local height = tan(rad(fov * 0.5)) * 2 * screenpos.Z
            local scale = vec2(((Camera.ViewportSize.Y / height) * size.X) * zoom, ((Camera.ViewportSize.Y / height) * size.Y) * zoom)
            local box_x, box_y = screenpos.X - scale.X/2, screenpos.Y - scale.Y/2

            obj:drawbox(box_x, box_y, scale.X, scale.Y)
            obj:drawhealthbar(scale.Y, box_x, box_y)
            obj:drawusername(box_x + scale.X / 2, box_y - (f["Name Offset"] or 8), distance)
            obj:drawtarget(box_x + scale.X / 2, box_y - (f["Name Offset"] or 8))
            obj:drawhelditem(box_x + scale.X / 2, box_y + scale.Y + (f["Held Item Offset"] or 9))
            obj:drawdistance(distance)
            obj:drawheadcircle(scale.X, scale.Y)
            obj:drawflags(box_x, box_y, scale.X)
            obj:drawviewdirection()
            obj:drawchams()
        end
    end

    -- player lifecycle
    Players.PlayerAdded:Connect(function(player)
        if player then playerESP.create(player) end
    end)
    Players.PlayerRemoving:Connect(function(player)
        if player then playerESP.remove(player) end
    end)
    for _, p in ipairs(Players:GetPlayers()) do
        if p and p ~= LocalPlayer then playerESP.create(p) end
    end

    ESP._playerESP = playerESP
    ESP._Flags = Flags
    ESP._Framework = Framework
end

function ESP.Start(Library)
    if not ESP._playerESP then
        ESP.Init(Library)
    end
    local Framework = ESP._Framework or Library.Framework or Library
    local Services = Framework.Services
    Framework:Connect(Services.RunService.Heartbeat, function()
        ESP.Update()
    end)
end

return ESP
