---@class KLSiegeMainPanel:UIKmlLuaPanelBase
---@field view KLSiegeMainPanelView
local KLSiegeMainPanel = class(UIKmlLuaPanelBase)
local this =KLSiegeMainPanel

function this:AsyncLoadUI()
end

---创建时调用一次
function this:Init()
    self.isOnClickGo = false

    ---前三名模型列表
    self.roleList =
    {
        [1] = self.view.role_mid,
        [2] = self.view.role_left,
        [3] = self.view.role_right,
    }
    ---前三名剪影列表
    self.roleSilhouetteList =
    {
        [1] = self.view.noPlayerBG1,
        [2] = self.view.noPlayerBG2,
        [3] = self.view.noPlayerBG3,
    }
    ---前三名名字列表
    self.roleNameList =
    {
        [1] = self.view.roleTitle1_Name,
        [2] = self.view.roleTitle2_Name,
        [3] = self.view.roleTitle3_Name,
    }
    ---前三名标题列表
    self.roleTitleList =
    {
        [1] = self.view.roleTitle1,
        [2] = self.view.roleTitle2,
        [3] = self.view.roleTitle3,
    }
    GUI:UIPanel_Close("dev/outui/Union/Panel/KLUnionActivity/KLUnionActivityPanel")
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel")
    SL:HideMainPanel()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close,self,self.BtnCloseClick)
    GUI:AddOnClickEvent(self.view.btn_go,self,self.BtnGoClick)
    GUI:AddOnClickEvent(self.view.btn_reward,self,self.BtnRewardClick)
    GUI:AddOnClickEvent(self.view.HelpButton,self,self.BtnRewardClick)

    SL:RegisterLUAEvent(LUA_EVENT_REQ_SIEGE_UNION_PLAYER_END, self.LUA_EVENT_REQ_SIEGE_UNION_PLAYER_END, self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLAND_SIEGE_MAIN_PANEL_CHANGE, self.LUA_EVENT_ROLAND_SIEGE_MAIN_PANEL_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLAND_SIEGE_STATE_INFO_CHANGE, self.LUA_EVENT_ROLAND_SIEGE_STATE_INFO_CHANGE , self)

end

---请求战盟：盟主副盟主玩家数据完成
function this:LUA_EVENT_REQ_SIEGE_UNION_PLAYER_END()
    for i = 1, 3 do
        if i == 1 then
            GUI:setVisible(self.roleTitleList[i],true)
            ---人物数据
            local data = InfoManager.loranSiegeInfo:GetTheFirstThreeRankData(i)
            GUI:setVisible(self.roleList[i],data)
            GUI:setVisible(self.roleSilhouetteList[i],not data)
            GUI:Text_setString(self.roleNameList[i],(data and data.role and data.role.name) and data.role.name or "" )
            if data then
                local model_list, equip_list = InfoManager.loranSiegeInfo:GetPlayerRoleInfo(data.role)
                GUI:SetPlayerRoleInfo(self.roleList[i], model_list, equip_list)
            end
        else
            --不显示副盟主
            GUI:setVisible(self.roleTitleList[i],false)
            GUI:setVisible(self.roleSilhouetteList[i],false)
            GUI:setVisible(self.roleList[i],false)
        end
    end
end

---攻城战面板信息变动
function this:LUA_EVENT_ROLAND_SIEGE_MAIN_PANEL_CHANGE()
    local unionName = InfoManager.loranSiegeInfo:GetOccupyUnionName()
    local isOpen = InfoManager.loranSiegeInfo:GetLoranIsOpen()
    local nextOpenTime = InfoManager.loranSiegeInfo:GetNextOpenTime()
    if unionName and unionName ~= "" then
        unionName = "占领战盟：<color=#00ff00>"..unionName.."</color>"
    end
    
    GUI:Text_setString(self.view.unionName,unionName)
    
    GUI:setVisible(self.view.OpenText,isOpen)
    GUI:setVisible(self.view.TimeText,not isOpen)
    GUI:setVisible(self.view.TimeTitle,not isOpen)
    if not isOpen then
        GUI:Text_setString(self.view.TimeText,Time.FormatTimeYMDHMS(nextOpenTime))
    end
end

function this:LUA_EVENT_ROLAND_SIEGE_STATE_INFO_CHANGE()
    if self.isOnClickGo then
        self:BtnCloseClick()
    end
end

---关闭界面
function this:BtnCloseClick()
    GUI:UIPanel_Close("dev/outui/LoranSiege/Panel/KLSiegeMain/KLSiegeMainPanel")
end

---打开奖励界面
function this:BtnRewardClick()
    self:BtnCloseClick()
    GUI:UIPanel_Open("dev/outui/LoranSiege/Panel/KLSiegeReward/KLSiegeRewardPanel")
end

---前往攻城
function this:BtnGoClick()
    local isOpen = InfoManager.loranSiegeInfo:GetLoranIsOpen()
    if SL:MeData_GetUnionId() == 0 then
        SL:TipMessage(SL:GetConfig("cfg_string",16002).text ,1, NoticeType.NoticeMid)
        return
    end
    if not isOpen then
        SL:TipMessage(SL:GetConfig("cfg_string",16001).text ,1, NoticeType.NoticeMid)
        return
    end
    self.isOnClickGo = true
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ENTER_DUPLICATE, EActivityType.LoranSiege)
    --self:BtnCloseClick()
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL.HideMainPanel()
    self:LUA_EVENT_REQ_SIEGE_UNION_PLAYER_END()
    self:LUA_EVENT_ROLAND_SIEGE_MAIN_PANEL_CHANGE()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ROLAND_SEIGE_GET_MAIN_PANEL)
end

function this:Close()
end

return this