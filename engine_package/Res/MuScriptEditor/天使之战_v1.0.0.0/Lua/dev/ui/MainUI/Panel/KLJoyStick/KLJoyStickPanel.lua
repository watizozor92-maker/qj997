---@class KLJoyStickPanel:UIKmlLuaPanelBase
---@field view KLJoyStickPanelView
local KLJoyStickPanel = class(UIKmlLuaPanelBase)
local this = KLJoyStickPanel

local maxRandius = 70
local basePos = Vector3.zero
local direction = Vector2.zero
local tickModel = ETickModel.fixed
local operateTimer = 0
local interruptHookTime = 0
local isReleaseSkill = nil
local isFirst = true
local isReset = false
local initPos = Vector2.New(6, 13)

local Direction = {
    Up = enum(0),
    RightUp = enum(),
    Right = enum(),
    RightDown = enum(),
    Down = enum(),
    LeftDown = enum(),
    Left = enum(),
    LeftUp = enum(),
    Max = enum(),
}

local DirectionOffset = {
    [Direction.Up] = Vector2(-1, 1),
    [Direction.RightUp] = Vector2(0, 1),
    [Direction.Right] = Vector2(1, 1),
    [Direction.RightDown] = Vector2(1, 0),
    [Direction.Down] = Vector2(1, -1),
    [Direction.LeftDown] = Vector2(0, -1),
    [Direction.Left] = Vector2(-1, -1),
    [Direction.LeftUp] = Vector2(-1, 0),
    [Direction.Max] = Vector2(0, 0),
}

local DirectionOffset2D = {
    [Direction.Up] = Vector2(0, 1),
    [Direction.RightUp] = Vector2(1, 1),
    [Direction.Right] = Vector2(1, 0),
    [Direction.RightDown] = Vector2(1, -1),
    [Direction.Down] = Vector2(0, -1),
    [Direction.LeftDown] = Vector2(-1, -1),
    [Direction.Left] = Vector2(-1, 0),
    [Direction.LeftUp] = Vector2(-1, 1),
    [Direction.Max] = Vector2(0, 0),
}

---创建时调用一次
function this:Init()

end

---创建或者刷新界面数据时调用
function this:Refresh()
    tickModel = SL:GetMetaValue(EMetaVarGetKey.GET_ROCKER_TYPE)
    self:ResetStick()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnTouchEvent(self.view.JoyStickBg, self, self.OnTouchEvent)
    self.schedule = SL:Schedule(self.schedule, 0, 0, -1, function()
        return self:OnUpdate()
    end)

    SL:RegisterLUAEvent(Event.RoleSetting_JoystickSetChange, self.JoyStickModelChange, self)

end

function this:JoyStickModelChange()
    tickModel = SL:GetMetaValue(EMetaVarGetKey.GET_ROCKER_TYPE)
end

function this:OnUpdate()
    if SL:GetIsXtra() then
        if Xtra_UIToolsManager.IsEdiorOpen then
            return
        end
    end

    local key = UtilityLua.GetKeyWSAD()

    if key ~= 0 then
        operateTimer = Time.time
    end

    if key ~= 0 then
        direction:Set(0, 0)
        if bit.band(key, EGetKeyCodeWSAD.EKeyCodeW) ~= 0 then
            direction:AddXY(0, 1)
        elseif bit.band(key, EGetKeyCodeWSAD.EKeyCodeS) ~= 0 then
            direction:AddXY(0, -1)
        end
        if bit.band(key, EGetKeyCodeWSAD.EKeyCodeD) ~= 0 then
            direction:AddXY(1, 0)
        elseif bit.band(key, EGetKeyCodeWSAD.EKeyCodeA) ~= 0 then
            direction:AddXY(-1, 0)
        end
        local distance = Vector2.Magnitude(direction)
        local pos = direction * maxRandius

        GUI:setPosition(self.view.JoyStick, pos.x, pos.y)

        local dir =self:GetJoyStickNormalOffset(direction.x, direction.y)
        direction:Copy(dir)
        SL:SetMetaValue(EMetaVarSetKey.SET_IS_CAN_SCENE_TOUCH, false)
        GUI:setScale(self.view.JoyStickBg, 1)
        GUI:Image_setAlpha(self.view.JoyStickBgSmall, 0.8)
        GUI:Image_setAlpha(self.view.JoyStick, 0.8)
        self:MoveWithDirection()
        isReset = false
    end

    local keyUp = UtilityLua.GetKeyUpWSAD()
    if keyUp ~= 0 or not SL:GetIsInGame() then
        isReset = true
    end


    if isReset then
        self:ResetStick()
        isReset = false
    end
end

---@param kmlCtrl UIKmlLuaControl
---@param eventType EUIEventName
function this:OnTouchEvent(kmlCtrl, eventType, args)

    if eventType == EUIEventName.OnBeginDrag then
        operateTimer = Time.time
    elseif eventType == EUIEventName.OnDrag then
        local basePos1 = args.pressEventCamera:WorldToScreenPoint(basePos)
        direction:Set(args.position.x - basePos1.x, args.position.y - basePos1.y)
        local distance = Vector2.Magnitude(direction)
        local radius = Mathf.Clamp(distance, 0, maxRandius)
        local pos = direction.normalized * radius
        GUI:setPosition(self.view.JoyStick, pos.x, pos.y)

        local dir =self:GetJoyStickNormalOffset(direction.x, direction.y)
        direction:Copy(dir)

        SL:SetMetaValue(EMetaVarSetKey.SET_IS_CAN_SCENE_TOUCH, false)
        GUI:setScale(self.view.JoyStickBg, 1)
        GUI:Image_setAlpha(self.view.JoyStickBgSmall, 0.8)
        GUI:Image_setAlpha(self.view.JoyStick, 0.8)
        self:MoveWithDirection()

    elseif eventType == EUIEventName.OnPointerDown then
        if tickModel == ETickModel.Move then
            local pointPos = nil
            if args.position.z == nil then
                local x, y, z = GUI:GetWorldPosition(self.view.JoyStickBg)
                pointPos = Vector3.New(args.position.x, args.position.y, z)
            else
                pointPos = Vector3.New(args.position.x, args.position.y, args.position.z)
            end

            local pos = args.pressEventCamera:ScreenToWorldPoint(pointPos)
            GUI:SetWorldPosition(self.view.JoyStickBg, pos.x, pos.y, pos.z)
        else
            GUI:setPosition(self.view.JoyStickBg, initPos.x, initPos.y)
        end

        local x, y, z = GUI:GetWorldPosition(self.view.JoyStickBg)
        basePos:Set(x, y, z)
        GUI:setScale(self.view.JoyStickBg, 1)
        GUI:Image_setAlpha(self.view.JoyStickBgSmall, 0.8)
        GUI:Image_setAlpha(self.view.JoyStick, 0.8)
        SL:SetMetaValue(EMetaVarSetKey.SET_IS_CAN_SCENE_TOUCH, false)
    elseif eventType == EUIEventName.OnPointerUp then
        self:ResetStick()
    end
end

function this:ResetStick(control, eventData)
    GUI:setPosition(self.view.JoyStickBg, initPos.x, initPos.y)
    GUI:setPosition(self.view.JoyStick, 0, 0)
    
    if SL:Is2D() then
        SL:ResetLineMove()
        SL:Me_StopMove(false, true)
    else
        SL:LineMoveTo(Dot2(0, 0), false, false)
    end
    GUI:setScale(self.view.JoyStickBg, 0.9)
    GUI:Image_setAlpha(self.view.JoyStickBgSmall, 0.5)
    GUI:Image_setAlpha(self.view.JoyStick, 0.5)
    SL:SetMetaValue(EMetaVarSetKey.SET_IS_CAN_SCENE_TOUCH, true)
    --EventManager.Dispatch(Event.StickMoveEvent, false)
    SL:onLUAEvent(Event.StickMoveEvent, false)
    SL:onLUAEvent(LUA_EVENT_JOYSTICK_MOVE, false)
end

---移动
function this:MoveWithDirection()
    if direction == Vector2Int.zero then return end

    ---暂停自动挂机

    if Time.time - operateTimer > interruptHookTime then
        SL:PauseOnHook(false, 2)
        operateTimer = Time.time
    else
        SL:onLUAEvent(Event.StickMoveEvent, true)
    end

    SL:ClearDelaySkill()
    SL:LineMoveTo(Dot2.New(direction.x, direction.y), false, false)
    SL:StopScriptAutoMove()
    if SL:GetMetaValue(EMetaVarGetKey.IS_FIND_PATH_SHOW_FOOT) then
        SL:onLUAEvent(Event.ShowPathFindFootSteps)
    end
    SL:onLUAEvent(LUA_EVENT_JOYSTICK_MOVE, true)

end

---获取方向偏移
function this:GetJoyStickNormalOffset(x, y)
    local angle = Mathf.Atan2(y, x) * Mathf.Rad2Deg
    if SL:GetMetaValue(EMetaVarGetKey.ENGINE_IS_LOCK_CAMERA) then
        angle = angle + 22.5
    else
        local yAngle = SL:GetMetaValue(EMetaVarGetKey.MAIN_CAMERA_Y_ORBIT_ANGLE_Y)
        angle = angle - yAngle - 22.5
    end

    angle = angle % 360
    local dof = SL:Is2D() and DirectionOffset2D or DirectionOffset
    if angle >= 0 and angle < 45 then
        return dof[Direction.Right]
    end
    if angle >= 45 and angle < 90 then
        return dof[Direction.RightUp]
    end
    if angle >= 90 and angle < 135 then
        return dof[Direction.Up]
    end
    if angle >= 135 and angle < 180 then
        return dof[Direction.LeftUp]
    end
    if angle >= 180 and angle < 225 then
        return dof[Direction.Left]
    end
    if angle >= 225 and angle < 270 then
        return dof[Direction.LeftDown]
    end
    if angle >= 270 and angle < 315 then
        return dof[Direction.Down]
    end

    return dof[Direction.RightDown]
end

function this:Close()
    if self.schedule then
        SL:UnSchedule(self.schedule)
        self.schedule = nil
    end
end

return this
