local Framework = {
    Theme = {
        Colors = {
            Accent         = Color3.fromRGB(209, 13, 67), -- 152, 245, 253 / 228, 186, 197 / 77, 107, 111
            Active         = Color3.fromRGB(220, 210, 210),
            Inactive       = Color3.fromRGB(100, 95, 95),
            Window         = Color3.fromRGB(22, 22, 26),
            Middle         = Color3.fromRGB(16, 16, 18),
            Outline        = Color3.fromRGB(34, 33, 40), -- 18,16,17
            Outline2        = Color3.fromRGB(64, 63, 78),
            LineGradient = {
                { Time = 0, Color = "Accent" },
                { Time = 0.5, Color = Color3.fromRGB(22, 22, 26) },
                { Time = 1, Color = Color3.fromRGB(22, 22, 26) }
            },
        },
        Map = {},
    },
    Connections = {},
    Instances   = {},
    Services = setmetatable({}, {
        __index = function(self, service)
            local inst = game:GetService(service)
            local clone = cloneref(inst)
            rawset(self, service, clone)
            return clone
        end
    })
};

local Services = Framework.Services;
local Assets = require("./Assets");
Framework.TextObjects = {};
Framework.CurrentFont = Assets.Fonts.Elektr;
Framework.CurrentSize = 5;

-- Signals
do
    function Framework:Connect(signal: RBXScriptSignal, callback)
        local connection = signal:Connect(callback);
        table.insert(self.Connections, connection);
        return connection;
    end;
end;

-- Tweens
do
    function Framework:Tween(object, goal, duration, easingStyle, easingDirection, callback)
        local target = (typeof(object) == "table" and object._obj) or object; -- unwrap check sir
        local tweenInfo = TweenInfo.new(duration or 0.2, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.InOut);
        local tween = self.Services.TweenService:Create(target, tweenInfo, goal);
        if callback then
            tween.Completed:Connect(callback);
        end;
        tween:Play();
    end;

    function Framework:TweenTheme(wrapped, props, duration, easingStyle, easingDirection, callback)
        local goal = {}

        if not self.Theme.Map then
            self.Theme.Map = {}
        end

        if not self.Theme.Map[wrapped] then
            self.Theme.Map[wrapped] = { Instance = wrapped, Properties = {} }
        end

        for property, value in pairs(props) do
            if type(value) == "string" and self.Theme.Colors[value] then
                goal[property] = self.Theme.Colors[value]
                self.Theme.Map[wrapped].Properties[property] = value
            else
                goal[property] = value
            end
        end

        self:Tween(wrapped._obj, goal, duration, easingStyle, easingDirection, callback)
    end;
end;

-- Instances
do
    function Framework:New(Class, Properties, Events, Conditions)
        local _Instance = type(Class) == "string" and Instance.new(Class) or Class

        if _Instance:IsA("GuiObject") then
            if _Instance:FindFirstChild("BorderSizePixel") ~= nil or _Instance.BorderSizePixel ~= nil then
                _Instance.BorderSizePixel = 0
            end
        end

        if _Instance:IsA("TextLabel") or _Instance:IsA("TextButton") or _Instance:IsA("TextBox") then
            _Instance.TextStrokeTransparency = 1
            _Instance.TextStrokeColor3 = Color3.new(0,0,0)

            table.insert(Framework.TextObjects, _Instance)

            _Instance.FontFace = Framework.CurrentFont
            _Instance.TextSize = Framework.CurrentSize
        end

        -- Apply properties
        for Property, Value in next, Properties do
            if Property == "Parent" and type(Value) == "table" and Value._obj then
                _Instance[Property] = Value._obj
            else
                _Instance[Property] = Value
            end
        end

        -- mouse
        if Events then
            local binds = {
                Enter = Instance.new("BindableEvent"),
                Leave = Instance.new("BindableEvent"),
                Press = Instance.new("BindableEvent"),
            }

            for name, bind in pairs(binds) do
                bind.Parent = _Instance
                bind.Name = name
            end

            local function checkConditions(tbl)
                if tbl == nil then return true end
                for _, func in pairs(tbl) do
                    if func() then return false end
                end
                return true
            end

            self.Connect(_Instance.MouseEnter, function()
                if checkConditions(Conditions) then binds.Enter:Fire() end
            end)
            self.Connect(_Instance.MouseLeave, function()
                if checkConditions(Conditions) then binds.Leave:Fire() end
            end)
            self.Connect(_Instance.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if checkConditions(Conditions) then binds.Press:Fire() end
                end
            end)
        end

        -- Wrapped instance with methods
        local wrapped = { _obj = _Instance, Theme = self.Theme }

        -- Define methods
        function wrapped:Self()
            return self
        end

        function wrapped:Apply(theme, tween)
            local props = self.Theme.Map[self].Properties
            for property, value in pairs(props) do
                if type(value) == "string" and type(theme[value]) == "table" then
                    local sequenceType = property == "Color" and ColorSequence or NumberSequence
                    local keypointType = property == "Color" and ColorSequenceKeypoint or NumberSequenceKeypoint
                    local keypoints = {}
                    for _, kp in ipairs(theme[value]) do
                        table.insert(keypoints, keypointType.new(kp.Time, theme[kp[property]] or kp[property]))
                    end
                    self[property] = sequenceType.new(keypoints)
                elseif tween then
                    self:Tween(self._obj, { [property] = type(value) == "string" and theme[value] or value })
                else
                    self[property] = type(value) == "string" and theme[value] or value
                end
            end
            return self
        end

        function wrapped:Add(props, tween)
            self.Theme.Map[self] = { Instance = self, Properties = props }
            self:Apply(self.Theme.Colors, tween)
            return self
        end

        function wrapped:Change(props, tween)
            if self.Theme.Map[self] then
                self.Theme.Map[self].Properties = props
                self:Apply(self.Theme.Colors, tween)
            end
            return self
        end

        local oldDestroy = _Instance.Destroy;
        function wrapped:Destroy()
            Framework.Theme.Map[self] = nil;
            oldDestroy(_Instance);
        end;

        setmetatable(wrapped, {
            __index = function(self, k)
                if rawget(wrapped, k) then
                    return rawget(wrapped, k)
                end
                local value = _Instance[k]
                if type(value) == "function" then
                    return function(_, ...) return value(_Instance, ...) end
                end
                return value
            end,

            __newindex = function(self, k, v)
                if k == "Parent" and type(v) == "table" and v._obj and typeof(v._obj) == "Instance" then
                    _Instance[k] = v._obj
                else
                    _Instance[k] = v
                end
            end,
        })

        -- Store raw instance
        if not self.Instances then
            self.Instances = {}
        end
        table.insert(self.Instances, _Instance)

        return wrapped;
    end;
    --
    function Framework:ApplyFontSettings()
        for i, obj in ipairs(self.TextObjects) do
            if obj and obj.Parent then
                obj.FontFace = self.CurrentFont
                obj.TextSize = self.CurrentSize
            else
                self.TextObjects[i] = nil
            end
        end
    end;
    --
    function Framework:SetFont(font)
        if font then
            self.CurrentFont = font
            self:ApplyFontSettings()
        end
    end;
    --
    function Framework:SetFontSize(size)
        if size then
            self.CurrentSize = size
            self:ApplyFontSettings()
        end
    end;
    --
    function Framework:UpdateAccent(new_color, transparency)
        transparency = transparency and math.clamp(transparency, 0, 1) or 0;
        self.Theme.Colors.Accent = transparency > 0 and new_color:Lerp(Color3.new(0, 0, 0), transparency) or new_color;

        local to_remove = {};
        for key, data in pairs(self.Theme.Map) do
            if not data.Instance or not data.Instance._obj or not data.Instance._obj.Parent then
                table.insert(to_remove, key);
            else
                for prop, val in pairs(data.Properties) do
                    if val == "Accent" then
                        local target = data.Instance._obj;
                        if typeof(target[prop]) == "ColorSequence" then
                            target[prop] = ColorSequence.new(self.Theme.Colors.Accent);
                        else
                            self:Tween(target, ({ [prop] = self.Theme.Colors.Accent }), 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
                        end;

                    elseif val == "LineGradient" then
                        local seq_data = self.Theme.Colors.LineGradient;
                        local keypoints = {};

                        for _, kp in ipairs(seq_data) do
                            local color = kp.Color;
                            if type(color) == "string" and self.Theme.Colors[color] then
                                color = self.Theme.Colors[color];
                            end;
                            table.insert(keypoints, ColorSequenceKeypoint.new(kp.Time, color));
                        end;

                        data.Instance._obj[prop] = ColorSequence.new(keypoints);
                    end;
                end;
            end;
        end;

        for _, key in ipairs(to_remove) do
            self.Theme.Map[key] = nil;
        end;
    end;
    --
    function Framework:UpdateWindow(new_color, transparency)
        transparency = transparency and math.clamp(transparency, 0, 1) or 0
        self.Theme.Colors.Window = transparency > 0 and new_color:Lerp(Color3.new(0,0,0), transparency) or new_color

        for key, data in pairs(self.Theme.Map) do
            if data.Properties then
                for prop, val in pairs(data.Properties) do
                    if val == "Window" then
                        local target = data.Instance._obj
                        if typeof(target[prop]) == "ColorSequence" then
                            target[prop] = ColorSequence.new(self.Theme.Colors.Window)
                        else
                            self:Tween(target, {[prop] = self.Theme.Colors.Window}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                        end
                    end
                end
            end
        end
    end;
    -- 
    function Framework:UpdateActive(new_color, transparency)
        transparency = transparency and math.clamp(transparency, 0, 1) or 0
        self.Theme.Colors.Active = transparency > 0 and new_color:Lerp(Color3.new(0,0,0), transparency) or new_color

        for key, data in pairs(self.Theme.Map) do
            if data.Properties then
                for prop, val in pairs(data.Properties) do
                    if val == "Active" then
                        local target = data.Instance._obj
                        if typeof(target[prop]) == "ColorSequence" then
                            target[prop] = ColorSequence.new(self.Theme.Colors.Active)
                        else
                            self:Tween(target, {[prop] = self.Theme.Colors.Active}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                        end
                    end
                end
            end
        end
    end;
    --
    function Framework:UpdateInactive(new_color, transparency)
        transparency = transparency and math.clamp(transparency, 0, 1) or 0
        self.Theme.Colors.Inactive = transparency > 0 and new_color:Lerp(Color3.new(0,0,0), transparency) or new_color

        for key, data in pairs(self.Theme.Map) do
            if data.Properties then
                for prop, val in pairs(data.Properties) do
                    if val == "Inactive" then
                        local target = data.Instance._obj
                        if typeof(target[prop]) == "ColorSequence" then
                            target[prop] = ColorSequence.new(self.Theme.Colors.Inactive)
                        else
                            self:Tween(target, {[prop] = self.Theme.Colors.Inactive}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                        end
                    end
                end
            end
        end
    end;
    --
    function Framework:UpdateMiddle(new_color, transparency)
        transparency = transparency and math.clamp(transparency, 0, 1) or 0
        self.Theme.Colors.Middle = transparency > 0 and new_color:Lerp(Color3.new(0,0,0), transparency) or new_color

        for key, data in pairs(self.Theme.Map) do
            if data.Properties then
                for prop, val in pairs(data.Properties) do
                    if val == "Middle" then
                        local target = data.Instance._obj
                        if typeof(target[prop]) == "ColorSequence" then
                            target[prop] = ColorSequence.new(self.Theme.Colors.Middle)
                        else
                            self:Tween(target, {[prop] = self.Theme.Colors.Middle}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                        end
                    end
                end
            end
        end
    end;
    --
    function Framework:UpdateOutline(new_color, transparency)
        transparency = transparency and math.clamp(transparency, 0, 1) or 0
        self.Theme.Colors.Outline = transparency > 0 and new_color:Lerp(Color3.new(0,0,0), transparency) or new_color

        for key, data in pairs(self.Theme.Map) do
            if data.Properties then
                for prop, val in pairs(data.Properties) do
                    if val == "Outline" then
                        local target = data.Instance._obj
                        if typeof(target[prop]) == "ColorSequence" then
                            target[prop] = ColorSequence.new(self.Theme.Colors.Outline)
                        else
                            self:Tween(target, {[prop] = self.Theme.Colors.Outline}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                        end
                    end
                end
            end
        end
    end;
    --
    function Framework:UpdateOutline2(new_color, transparency)
        transparency = transparency and math.clamp(transparency, 0, 1) or 0
        self.Theme.Colors.Outline2 = transparency > 0 and new_color:Lerp(Color3.new(0,0,0), transparency) or new_color

        for key, data in pairs(self.Theme.Map) do
            if data.Properties then
                for prop, val in pairs(data.Properties) do
                    if val == "Outline2" then
                        local target = data.Instance._obj
                        if typeof(target[prop]) == "ColorSequence" then
                            target[prop] = ColorSequence.new(self.Theme.Colors.Outline2)
                        else
                            self:Tween(target, {[prop] = self.Theme.Colors.Outline2}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                        end
                    end
                end
            end
        end
    end;
end;

-- FadeIn
do
    function Framework:FadeIn(Parent, BlinkDuration, PauseBefore)
        BlinkDuration = BlinkDuration or 0.3;
        PauseBefore = PauseBefore or 0.15;
        self._FadeTokens = self._FadeTokens or {};
        self._FadeTokens[Parent] = (self._FadeTokens[Parent] or 0) + 1;
        local MyToken = self._FadeTokens[Parent];
        self._OriginalTransparency = self._OriginalTransparency or {};

        for _, Obj in ipairs(Parent:GetDescendants()) do
            if not self._OriginalTransparency[Obj] then
                self._OriginalTransparency[Obj] = {
                    bg = (Obj:IsA("Frame") or Obj:IsA("TextButton") or Obj:IsA("TextBox")) and Obj.BackgroundTransparency or nil,
                    text = (Obj:IsA("TextLabel") or Obj:IsA("TextButton") or Obj:IsA("TextBox")) and Obj.TextTransparency or nil,
                    image = (Obj:IsA("ImageLabel") or Obj:IsA("ImageButton")) and Obj.ImageTransparency or nil,
                    stroke = Obj:IsA("UIStroke") and Obj.Transparency or nil
                };
            end;

            local BgVal, TextVal, ImageVal, StrokeVal = self._OriginalTransparency[Obj].bg, self._OriginalTransparency[Obj].text, self._OriginalTransparency[Obj].image, self._OriginalTransparency[Obj].stroke;
            local HasBg, HasText, HasImage, HasStroke = BgVal and type(BgVal) == "number" and BgVal < 1, TextVal and type(TextVal) == "number" and TextVal < 1, ImageVal and type(ImageVal) == "number" and ImageVal < 1, StrokeVal and type(StrokeVal) == "number" and StrokeVal < 1;

            if HasBg then Obj.BackgroundTransparency = 1; end;
            if HasText then Obj.TextTransparency = 1; end;
            if HasImage then Obj.ImageTransparency = 1; end;
            if HasStroke then Obj.Transparency = 1; end;

            if HasBg or HasText or HasImage or HasStroke then
                task.delay(PauseBefore, function()
                    if MyToken ~= self._FadeTokens[Parent] then return end;
                    local Goal = {};
                    if HasBg then Goal.BackgroundTransparency = 0; end;
                    if HasText then Goal.TextTransparency = 0; end;
                    if HasImage then Goal.ImageTransparency = 0; end;
                    if HasStroke then Goal.Transparency = 0; end;
                    self:Tween(Obj, Goal, BlinkDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
                        if MyToken == self._FadeTokens[Parent] then
                            if HasBg then Obj.BackgroundTransparency = BgVal; end;
                            if HasText then Obj.TextTransparency = TextVal; end;
                            if HasImage then Obj.ImageTransparency = ImageVal; end;
                            if HasStroke then Obj.Transparency = StrokeVal; end;
                        end;
                    end);
                end);
            end;
        end;
    end;
end;

-- Resizing
do
    function Framework:Resize(object, bg, cursor, defaultimage, resizeimage)
        local target, dragging;
        object.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true;
                if cursor and resizeimage then cursor.Image = resizeimage end;
            end;
        end);

        object.MouseEnter:Connect(function()
            if (not dragging and cursor and resizeimage) then
                cursor.Image = resizeimage;
            end;
        end);

        object.MouseLeave:Connect(function()
            if (not dragging and cursor and defaultimage) then
                cursor.Image = defaultimage;
            end;
        end);

        Services.UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false;
                if cursor and defaultimage then cursor.Image = defaultimage end;
            end;
        end);

        Services.UserInputService.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                local m = Services.UserInputService:GetMouseLocation();
                local inset = Services.GuiService:GetGuiInset();
                local x = math.clamp(m.X - inset.X - bg.AbsolutePosition.X, 550, 600);
                local y = math.clamp(m.Y - inset.Y - bg.AbsolutePosition.Y, 550, 800);
                target = UDim2.new(x / workspace.CurrentCamera.ViewportSize.X, 0, y / workspace.CurrentCamera.ViewportSize.Y, 0);
            end;
        end);

        Services.RunService:BindToRenderStep("resize" .. bg:GetDebugId(), Enum.RenderPriority.Input.Value, function(dt)
            if (target) then
                bg.Size = bg.Size:Lerp(target, math.clamp(25 * dt, 0, 1));
            end;
        end);
    end;
end;

-- Dragging
do
    function Framework:Drag(BG, grid, state)
        grid = grid;
        BG.Position = state.pos;

        local dragging, drag_start, start_pos;
        Framework:Connect(BG.InputBegan, function(i)
            if (i.UserInputType == Enum.UserInputType.MouseButton1) then
                dragging, drag_start, start_pos = true, Services.UserInputService:GetMouseLocation(), BG.Position;
            end;
        end);

        Framework:Connect(Services.UserInputService.InputEnded, function(i)
            if (i.UserInputType == Enum.UserInputType.MouseButton1) then 
                dragging = false; 
            end; 
        end);

        Framework:Connect(Services.UserInputService.InputChanged, function(i)
            if (dragging and i.UserInputType == Enum.UserInputType.MouseMovement) then
                local d = Services.UserInputService:GetMouseLocation() - drag_start;
                local snappedX = math.floor((start_pos.X.Offset + d.X) / grid + 0.5) * grid;
                local snappedY = math.floor((start_pos.Y.Offset + d.Y) / grid + 0.5) * grid;
                local ViewportSize = workspace.CurrentCamera.ViewportSize;
                state.target = UDim2.new(0.5, math.clamp(snappedX, -ViewportSize.X/2, ViewportSize.X/2 - BG.AbsoluteSize.X), 0.5, math.clamp(snappedY, -ViewportSize.Y/2, ViewportSize.Y/2 - BG.AbsoluteSize.Y));
            end;
        end);

        Services.RunService:BindToRenderStep("drag" .. BG:GetDebugId(), Enum.RenderPriority.Input.Value, function(dt)
            local alpha = dragging and 40 * dt or 10 * dt;
            state.pos = Framework:LerpUDim2(state.pos, state.target, math.clamp(alpha, 0, 1));
            BG.Position = state.pos;
        end);
    end;
end;

-- Lerp UDim2
do
    function Framework:LerpUDim2(a, b, t)
        return UDim2.new(
            a.X.Scale + (b.X.Scale - a.X.Scale) * t,
            a.X.Offset + (b.X.Offset - a.X.Offset) * t,
            a.Y.Scale + (b.Y.Scale - a.Y.Scale) * t,
            a.Y.Offset + (b.Y.Offset - a.Y.Offset) * t
        );
    end;
end;

-- Glow
do
    function Framework:Glow(Parent: Instance, Color: Color3): {Frame}
        local Thicknesses = {2, 3, 7, 5};
        local Frames: {Frame} = {};

        for i, Thickness in ipairs(Thicknesses) do
            local Frame = self:New("Frame", {
                Parent = Parent;
                Name = "Glow";
                Size = UDim2.new(1, 0, 1, 0);
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                ZIndex = (Parent.ZIndex or 1) - 1;
            });

            self:New("UICorner", {Parent = Frame; CornerRadius = UDim.new(0, 4)});
            self:New("UIStroke", {
                Parent = Frame;
                Color = Color;
                Thickness = Thickness;
                Transparency = 0.95;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
                LineJoinMode = Enum.LineJoinMode.Round;
            });

            Frames[i] = Frame;
        end;

        return Frames;
    end;
end;

-- Unload
do
   function Framework:Unload()
        for i = #self.Connections, 1, -1 do
            local connection = self.Connections[i];
            if connection.Connected then
                connection:Disconnect();
            end;
            self.Connections[i] = nil;
        end;

        for i = #self.Instances, 1, -1 do
            local instance = self.Instances[i];
            if instance and instance.Parent then
                instance:Destroy();
            end;
            self.Instances[i] = nil;
        end

        for k in pairs(self.Services) do
            self.Services[k] = nil;
        end

        self.Theme.Map = {};
    end;
end;

return Framework;