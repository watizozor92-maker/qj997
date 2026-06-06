---@class KLRedFortTaskPanel:UIKmlLuaPanelBase
---@field view KLRedFortTaskPanelView
---@field joinCount number
---@field nextStateTime number
---@field nowState number
---@field alertAreaSize {v1:{},v2:{}}
---@field nowShrinkingState number
local KLRedFortTaskPanel = class(UIKmlLuaPanelBase)
local this = KLRedFortTaskPanel
---创建时调用一次
function this:Init()
    SL:KeepOpenPanel("KLRedFortTaskPanelKml", true)
end

function this:InitData(message)
    self:Refresh()
    self:RES_RED_FORTRESS_STATE_UPDATE(nil, message)
end
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.exitBtn, self, self.BtnCloseOnClick)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RED_FORTRESS_PREPARE_COUNT, self.RES_RED_FORTRESS_PREPARE_COUNT, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RED_FORTRESS_TASK_INFO, self.RES_RED_FORTRESS_TASK_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RED_FORTRESS_SHRINKING_STAGE, self.RES_RED_FORTRESS_SHRINKING_STAGE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_QUIT_DUPLICATE, self.RES_QUIT_DUPLICATE, self)
    SL:RegisterLUAEvent(LUA_EVENT_CHANGESCENE, self.LUA_EVENT_CHANGESCENE, self)
end
function this:LUA_EVENT_CHANGESCENE()
    if not SL:Out_IsInCopy() then
        GUI:UIPanel_Close("dev/outui/Activity/Panel/KLRedFortTask/KLRedFortTaskPanel")
    end
end


---赤色要塞阶段
function this:RES_RED_FORTRESS_STATE_UPDATE(_, message)
    if self.timer then
        --Timer.Stop(self.timer)
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    self.nowState = message["1"]
    self.nextStateTime = message["2"]
    self:RefreshTimeText()
    if message["1"] == ERedFortstage.Wait then
        GUI:SetActive(self.view.textSetout, true)
        GUI:SetActive(self.view.textJoin, true)
        GUI:SetActive(self.view.textSetoutTime, true)
        if self.joinCount and self.joinCount > 0 then
            GUI:Text_setString(self.view.textJoinCoun, tostring(self.joinCount))
        else
            GUI:Text_setString(self.view.textJoinCoun, "0")
        end
        SL:SetAllViewPlayerToMonster(true, InfoManager.redFortInfo.cfg_repRedfortress.transfiguration)
        SL:RefreshHead(SL:GetMetaValue(EMetaVarGetKey.UID))
        SL:SetMetaValue(EMetaVarSetKey.SET_PKMODE, EPKMode.Peace)
        SL:SetMetaValue(EMetaVarSetKey.SET_ISNOTCHANGEPKMODE, true)
        if not self.timer then
            self.timer = SL:StartLoopForever(1, self.RefreshTimeText, self) ---Timer.StartLoopForever(1, self.RefreshTimeText, self)
        end
    elseif message["1"] == ERedFortstage.Fight then
        SL:SetMetaValue(EMetaVarSetKey.SET_ISNOTCHANGEPKMODE, false)
        SL:SetMetaValue(EMetaVarSetKey.SET_PKMODE, EPKMode.AllAttack)
        SL:SetMetaValue(EMetaVarSetKey.SET_ISNOTCHANGEPKMODE, true)
        --战斗阶段显示裁剪过的地块并且增加阻挡点
        ---字段后端要用来生成怪物，这里写死偏移量
        local x1 = InfoManager.redFortInfo.cfg_repRedfortress.start[1] - 4
        local x2 = InfoManager.redFortInfo.cfg_repRedfortress.start[2] + 5
        local y1 = InfoManager.redFortInfo.cfg_repRedfortress.start[3] - 3
        local y2 = InfoManager.redFortInfo.cfg_repRedfortress.start[4] + 6
        local v1 = Vector2(x1, y1)
        local v2 = Vector2(x2, y2)
        ---裁切地块有偏移
        SL.MapMaskMgr:SetRect(v1, v2)
        --local str = "10000152 预警区域 左下：x-%s  y-%s，右上：x-%s y-%s"
        --logError(string.format(str, v1.x, v1.y, v2.x, v2.y))
        SL.MapMaskMgr:SetAlertRect(v1, v2)
        ---阻挡点
        --Scene.SetCustomResistanceData(Dot2(x1 - 1,y1 - 1), Dot2(x2 + 1,y2 + 1))
        SL:SetAllViewPlayerToMonster(true, InfoManager.redFortInfo.cfg_repRedfortress.transfiguration)
        SL:RefreshHead(SL:GetMetaValue(EMetaVarGetKey.UID))
        if not self.timer then
            self.timer =SL:StartLoopForever(1, self.RefreshTimeText, self) ---Timer.StartLoopForever(1, self.RefreshTimeText, self)
        end
    else

    end
end
---赤色要塞准备阶段人数
function this:RES_RED_FORTRESS_PREPARE_COUNT(_, message)
    GUI:SetActive(self.view.textJoin, true)
    if message and message > 0 then
        GUI:Text_setString(self.view.textJoinCoun, tostring(message))
    else
        GUI:Text_setString(self.view.textJoinCoun, "0")
    end
end

---赤色要塞任务面板信息
function this:RES_RED_FORTRESS_TASK_INFO(_, message)
    GUI:SetActive(self.view.textTarget, true)
    GUI:SetActive(self.view.textPlayer, true)
    GUI:SetActive(self.view.textRevive, true)
    GUI:SetActive(self.view.textFightTime, true)

    GUI:SetActive(self.view.textSetout, false)
    GUI:SetActive(self.view.textJoin, false)
    GUI:SetActive(self.view.textSetoutTime, false)

    GUI:Text_setString(self.view.textPlayerCount, tostring(message["1"]))
    GUI:Text_setString(self.view.textReviveCount, tostring(message["2"]))
    if message["2"] > 0 then
        GUI:Text_setTextColor(self.view.textReviveCount, EColor[EGradColor.green])
    else
        GUI:Text_setTextColor(self.view.textReviveCount, EColor[EGradColor.red])
    end

end
---赤色要塞缩圈数据
function this:RES_RED_FORTRESS_SHRINKING_STAGE(_, message)
    self.nowShrinkingState = message["1"]
    local v1, v2 = self:GetLeftAndRight(message)
    if self.alertAlphaTimer then
        ---Timer.Stop(self.alertAlphaTimer)
        SL:UnSchedule(self.alertAlphaTimer)
        self.alertAlphaTimer = nil
        if self.alertAreaSize[self.nowShrinkingState - 1] then
            local tempV1, tempV2 = self.alertAreaSize[self.nowShrinkingState - 1].v1, self.alertAreaSize[self.nowShrinkingState - 1].v2
            SL.MapMaskMgr:SetAlertRect(tempV1, tempV2)
            ---Scene.SetCustomResistanceData(Dot2(tempV1.x - 1,tempV1.y), Dot2(tempV2.x,tempV2.y))
            SL.Scene:SetCustomResistanceData(Dot2(tempV1.x - 1,tempV1.y), Dot2(tempV2.x,tempV2.y))
        end
        if self.nowShrinkingState == #InfoManager.redFortInfo.cfg_repRedfortress.warning then
            SL:onLUAEvent(LUA_EVENT_CHAT_RECEIVE_NOTICE, {
                message = "最终决战开始，扣除所有复活次数",
                channel = EChatChannelType.SYSTEM,
            })
        end
    end
    ---裁切地块有偏移
    SL.MapMaskMgr:SetRect(v1, v2)
   --local str = "10000152 安全区域 左下：x-%s  y-%s，右上：x-%s y-%s"
   --logError(string.format(str, v1.x, v1.y, v2.x, v2.y))
    self.alertTime = InfoManager.redFortInfo.cfg_repRedfortress.warning[self.nowShrinkingState]
    SL:onLUAEvent(LUA_EVENT_CHAT_RECEIVE_NOTICE, {
        message = "平台边缘即将塌陷，请马上远离",
        channel = EChatChannelType.SYSTEM,
    })
    SL:TipMessage( SL:GetConfig('cfg_string',252).text, self.alertTime, NoticeType.NoticeMid )--"平台边缘即将塌陷，请马上远离！",
    self.alertAlpha = 0.5
    self:SetAlertAlpha()
    if not self.alertAlphaTimer then
        self.alertAlphaTimer =SL:StartLoopForever(1, self.SetAlertAlpha, self) ---Timer.StartLoopForever(1, self.SetAlertAlpha, self)
    end
    table.insert(self.alertAreaSize, { v1 = v1, v2 = v2 })
end

function this:SetAlertAlpha()
    if self.alertTime <= 0 then
        if self.alertAlphaTimer then
            ---Timer.Stop(self.alertAlphaTimer)
            SL:UnSchedule(self.alertAlphaTimer)
            self.alertAlphaTimer = nil
        end
        if self.alertAreaSize[self.nowShrinkingState] then
            local tempV1 = self.alertAreaSize[self.nowShrinkingState].v1
            local tempV2 = self.alertAreaSize[self.nowShrinkingState].v2
            SL.MapMaskMgr:SetAlertRect(tempV1, tempV2)
            ---Scene.SetCustomResistanceData(Dot2(tempV1.x - 1,tempV1.y), Dot2(tempV2.x,tempV2.y))
            SL.Scene:SetCustomResistanceData(Dot2(tempV1.x - 1,tempV1.y), Dot2(tempV2.x,tempV2.y))
        end
        if self.nowShrinkingState == #InfoManager.redFortInfo.cfg_repRedfortress.warning then
            SL:onLUAEvent(LUA_EVENT_CHAT_RECEIVE_NOTICE, {
                message = "最终决战开始，扣除所有复活次数",
                channel = EChatChannelType.SYSTEM,
            })
        end
    end
    SL.MapMaskMgr:SetAlertAlpha(self.alertAlpha)
    self.alertTime = self.alertTime - 1
    if self.alertAlpha == 1 then
        self.alertAlpha = 0.5
    else
        self.alertAlpha = 1
    end
end

---@param message {"1":number,"2":{"1":number,"2":number,"3":number,"4":number}}
---@return table {v1:{},v2:{}}
function this:GetLeftAndRight(message)
    local cut = 1
    for i = 1, message["1"] do
        cut = cut - InfoManager.redFortInfo.cfg_repRedfortress.mapCut[i][2] / 100
    end
 
    ---字段后端要用来生成怪物，这里写死偏移量
    local x1 = message["2"]["1"]
    local x2 = message["2"]["2"]
    local y1 = message["2"]["3"]
    local y2 = message["2"]["4"]
    ---裁切地块有偏移
    --local length = x2 - x1
    --local width = y2 - y1
    --length = length - length * cut
    --width = width - width * cut
    --local v1 = Vector2(math.floor(x1 + length / 2), math.floor(y1 + width / 2))
    --local v2 = Vector2(math.floor(x2 - length / 2), math.floor(y2 - width / 2))
    local v1 = Vector2(x1, y1)
    local v2 = Vector2(x2, y2)
    return v1, v2
end

---退出副本
function this:RES_QUIT_DUPLICATE(_, message)
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep", message, "id")
    if tbl.type == EActivityType.RedFort then
        GUI:UIPanel_Close("dev/outui/Activity/Panel/KLRedFortTask/KLRedFortTaskPanel")
    end
end

function this:BtnCloseOnClick()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_QUIT_DUPLICATE)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.alertAreaSize = {}
    self:RefreshUI()
    --self:ShowActivity(false)
end

function this:RefreshUI()
    ---先调用一次防止大退重进没数据
    InfoManager.redFortInfo:GetCfgByLevel()
    if InfoManager.redFortInfo:GET_RES_RED_FORTRESS_PREPARE_COUNT() then
        local message = InfoManager.redFortInfo:GET_RES_RED_FORTRESS_PREPARE_COUNT()
        self:RES_RED_FORTRESS_PREPARE_COUNT(nil,message)
    end
end

function this:HideAllText()
    GUI:SetActive(self.view.textSetout, false)
    GUI:SetActive(self.view.textTarget, false)
    GUI:SetActive(self.view.textPlayer, false)
    GUI:SetActive(self.view.textRevive, false)
    GUI:SetActive(self.view.textSetoutTime, false)
    GUI:SetActive(self.view.textFightTime, false)
end

function this:RefreshTimeText()
    local nextTime = self.nextStateTime - Time.GetServerTime()
    if nextTime < 0 then
        if self.timer then
            ---Timer.Stop(self.timer)
            SL:UnSchedule(self.timer)
            self.timer = nil
        end
        return
    end
    if self.nowState == ERedFortstage.Wait then
        GUI:Text_setString(self.view.textTime, Time.FormatTimeHMS(math.floor(nextTime)))
    else
        GUI:Text_setString(self.view.textFightTime, Time.FormatTimeHMS(math.floor(nextTime)))
    end
end

--[[function this:ShowActivity(isShow)
    ---@type KLActivityPreviewPanel
    local uiPanel = GUI:GetUI("dev/outui/Activity/Panel/KLActivityPreview/KLActivityPreviewPanel")
    if uiPanel then
        if not isShow then
            uiPanel:HideActivity()
        else
            uiPanel:ShowActivity()
        end
    end
end]]

function this:Close()
    if self.timer then
        ---Timer.Stop(self.timer)
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    if self.alertAlphaTimer then
        ---Timer.Stop(self.alertAlphaTimer)
        SL:UnSchedule(self.alertAlphaTimer)
        self.alertAlphaTimer = nil
    end
    InfoManager.copActivityInfo.hideTask = false
    ---@type KLUILeftUpPanel
    local panel = GUI:GetUI("dev/ui/MainUI/Panel/KLUILeftUp/KLUILeftUpPanel")
    if panel then
        panel:OnClickTaskToggle(nil, nil, { true })
        panel:SetTeamToogleEnabled(true)
    end
    SL:SetAllViewPlayerToMonster()
    if SL:MeData_Check() then
        SL:RefreshHead(SL:GetMetaValue(EMetaVarGetKey.UID))
    end
    SL.MapMaskMgr:DestroyEntity()
    SL:SetMetaValue(EMetaVarSetKey.SET_ISNOTCHANGEPKMODE, false)
    --self:ShowActivity(true)
end

return this
