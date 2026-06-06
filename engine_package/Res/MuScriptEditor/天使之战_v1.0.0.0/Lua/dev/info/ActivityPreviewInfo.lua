---@class ActivityPreviewInfo @注释
---@field previewInfo {leftTime:number,id:number,open:boolean,cfg:cfg_activity_rule_column,isPreview:boolean}[]
---@field activityCfgs cfg_activity_rule_column[]
ActivityPreviewInfo = class()
local this = ActivityPreviewInfo

---初始透明度 (1.0为完全不透明)
local alpha = 1.0
---1表示增加透明度，-1表示减少透明度
local blinkDirection = -1
---每次变化的步长
local blinkStep = 0.02
---临时存储闪烁信息
local tempBlinkInfoList = {}
---持久储存闪烁信息
local blinkInfoList = {}
local dirtyInfo = false

function this:ctor()

end

function this:Init()
    self.previewInfo = {}
    self.activityCfgs = SL:GetConfigTable("cfg_activity_rule")
    local tempTable = {}
    if self.activityCfgs then
        for k, v in pairs(self.activityCfgs) do
            tempTable[v.id] = v
        end
    end
    self.activityCfgs = tempTable
    self:InitData()
    self:RegistMessages()
    if SL:HasConfig("cfg_global", 290003, "id") then
        blinkStep = tonumber(SL:GetConfig("cfg_global", 290003, "id").value) /10000
    end

end

function this:InitData()
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ACTIVITY_LIST, self.ResPreviewDataList, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ACTIVITY_CHANGE, self.ResPreviewDataChange, self)
end

---所有的活动信息
---@param message {leftTime:number,id:number,open:boolean}[]
function this:ResPreviewDataList(_, message)
    self.previewInfo = {}
    for k, v in pairs(message) do
        if self.activityCfgs[v.id] then
            v.cfg = self.activityCfgs[v.id]
            v.leftTime = tonumber(v.leftTime)
            v.isPreview = false
            if not v.open then
                v.isPreview = self:CheckActivityIsPreview(v)
            end
            table.insert(self.previewInfo, v)
        end
    end
    self:ActivityInfoSort()
    SL:onLUAEvent(LUA_EVENT_ACTIVITYPREVIEW_CHANGE)
end
---单个活动更新
---@param message {leftTime:number,id:number,open:boolean}
function this:ResPreviewDataChange(_, message)
    local isHave = false
    for k, v in pairs(self.previewInfo) do
        if v.id == message.id and self.activityCfgs[message.id] then
            message.leftTime = tonumber(message.leftTime)
            message.cfg = self.activityCfgs[message.id]
            message.isPreview = false
            if not v.open then
                v.isPreview = self:CheckActivityIsPreview(v)
            end
            self.previewInfo[k] = message
            isHave = true
            break
        end
    end
    if not isHave and self.activityCfgs[message.id] then
        message.leftTime = tonumber(message.leftTime)
        message.cfg = self.activityCfgs[message.id]
        message.isPreview = false
        if not message.open then
            message.isPreview = self:CheckActivityIsPreview(message)
        end
        table.insert(self.previewInfo, message)
    end
    self:ActivityInfoSort()
    SL:onLUAEvent(LUA_EVENT_ACTIVITYPREVIEW_CHANGE)
end

function this:ActivityInfoSort()
    table.sort(self.previewInfo, function(a, b)
        if a.open and not b.open then
            return true
        elseif not a.open and not b.open then
            if a.cfg and b.cfg and a.cfg.rank < b.cfg.rank then
                return true
            end
            return false
        end
        return false
    end)
end

---@param message {leftTime:number,id:number,open:boolean}
----@return boolean
function this:CheckActivityIsPreview(message)
    local previewTime = message.leftTime - message.cfg.specialOpen * 1000
    if Time.GetServerTime() > previewTime and Time.GetServerTime() < message.leftTime then
        return true
    end
    return false
end

----获取活动数据
----@return {leftTime:number,id:number,open:boolean,cfg:cfg_activity_rule_column,isPreview:boolean}
function this:GetActivityInfo(activityId)
    for k, v in pairs(self.previewInfo) do
        if v.id == activityId and self.activityCfgs[activityId] then
            return v
        end
    end
    return nil
end

---获取内置的活动数据
function this:GetInActivityInfo(activityId)
    local allActivity = SL:GetAllActivityData()
    for i, v in pairs(allActivity) do
        if v.cfgId == activityId then
            return v
        end
    end
    return nil
end

----添加一个闪烁
---@param text UIKmlLuaControl 闪烁的文本组件
---@param staTextColor Color 静态颜色
---@param grayColors Color 闪烁颜色
function this:AddBlink(text, staTextColor, grayColors,mask)
    tempBlinkInfoList[text] = {
        text = text,
        staTextColor = staTextColor,
        grayColor = grayColors,
        mask = mask,
    }
    dirtyInfo = true
    if self.stationaryBlinkSchedule == nil then
        self:StartBlink()
    end
end

---停止闪烁
function this:RemoveBlink(text)
    if tempBlinkInfoList[text] == nil then
        return
    end
    local v = tempBlinkInfoList[text]
    tempBlinkInfoList[text] = nil
    dirtyInfo = true
    GUI:setAlpha(v.text, 1)
    GUI:setColor(v.text, v.staTextColor)
    -- 没有闪烁就关掉定时器
    if table.count(tempBlinkInfoList) == 0 then
        table.clear(blinkInfoList)
        SL:UnSchedule(self.stationaryBlinkSchedule)
        self.stationaryBlinkSchedule = nil
    end
end

---开始闪烁
function this:StartBlink()
    self.stationaryBlinkSchedule = SL:Schedule(self.stationaryBlinkSchedule, 0.3, 0.02, -1, function()
        -- 更新透明度值
        alpha = alpha + (blinkDirection * blinkStep)

        -- 边界检查
        if alpha >= 1.0 then
            alpha = 1.0
            self:UpdateBlinkInfoList()
            for _, v in pairs(blinkInfoList) do
                if v.mask then
                    GUI:setVisible(v.mask, false)
                else
                    GUI:setColor(v.text, v.staTextColor)
                end
                
            end
            blinkDirection = -1  -- 开始变透明
        elseif alpha <= 0 then
            alpha = 0
            self:UpdateBlinkInfoList()
            for _, v in pairs(blinkInfoList) do
                if v.mask then
                    GUI:setVisible(v.mask, true)
                else
                    GUI:setColor(v.text, v.grayColor)
                end
            end
            blinkDirection = 1   -- 开始变不透明
            
        end
    end)
end

---更新闪烁信息
function this:UpdateBlinkInfoList()
    if dirtyInfo then
        table.clear(blinkInfoList)
        for i, v in pairs(tempBlinkInfoList) do
            blinkInfoList[i] = v
        end
    end
end

---移除所有的闪烁
function this:RemoveAllBlink()
    if self.stationaryBlinkSchedule then
        SL:UnSchedule(self.stationaryBlinkSchedule)
        self.stationaryBlinkSchedule = nil
        for _,v in pairs(blinkInfoList) do
            GUI:setAlpha(v.text, 1)
        end
        for _,v in pairs(blinkInfoList) do
            GUI:setColor(v.text, v.staTextColor)
        end
        table.clear(tempBlinkInfoList)
        table.clear(blinkInfoList)
    end
end

function this:Reset()
    self.previewInfo = {}
    self:RemoveAllBlink()
end