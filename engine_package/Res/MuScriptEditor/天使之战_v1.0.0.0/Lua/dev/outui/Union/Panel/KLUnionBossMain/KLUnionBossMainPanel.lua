---@class KLUnionBossMainPanel:UIKmlLuaPanelBase
---@field view KLUnionBossMainPanelView
local KLUnionBossMainPanel = class(UIKmlLuaPanelBase)
local this =KLUnionBossMainPanel
---创建时调用一次
function this:Init()
    GUI:OSAScrollView_Initialized(self.view.osa_boss,nil,self.BossItemUpdateGetFun,self)
    GUI:OSAScrollView_Initialized(self.view.osa_reward,nil,self.RewardItemUpdateGetFun,self)
    
    local activityPanel = GUI:GetUI("dev/outui/Union/Panel/KLUnionActivity/KLUnionActivityPanel")
    if activityPanel then
        GUI:setPositionX(self.view.root,-67)
    else
        GUI:setPositionX(self.view.root,0)
    end
end

---@param item UIKmlLuaControl
function this:BossItemUpdateGetFun(item,index)
    local data = self.bossInfoListData[index + 1]
    local textName = GUI:GetChildById(item,"text_name")
    local imgKillIcon = GUI:GetChildById(item,"img_icon_kill")
    local imgBossIcon = GUI:GetChildById(item,"img_icon_monster")
    local textLv = GUI:GetChildById(item,"text_lv")
    GUI:setVisible(imgKillIcon,index < self.killProgress)
    local monsterId = data.monster[1][1]
    ---@type cfg_monster_column
    local monster = SL:GetConfig("cfg_monster",monsterId)
    GUI:Text_setString(textName,monster.name)
    GUI:Image_loadTexture(imgBossIcon,monster.icon,"Atlas/Monster_icon.spriteatlas")
    GUI:Text_setString(textLv,tostring(monster.level) .. "级")
end

---@param item UIKmlLuaControl
function this:RewardItemUpdateGetFun(item,index)
    local data = self.rewardListData[index + 1]
    local ctrlItem = GUI:GetChildById(item,"item")
    local btnItem = GUI:GetChildById(item,"btn_item")
    GUI:Item_setItemId(ctrlItem,data[1])
    GUI:AddOnClickEvent(btnItem,self,self.BtnItemOnClick,data[1])
end

function this:BtnItemOnClick(_,itemId)
    SL:OpenTips(nil,itemId)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close,self,self.BtnCloseOnClick)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WAR_ALLIANCE_BOSS_PANEL,self.RES_WAR_ALLIANCE_BOSS_PANEL,self)
    GUI:AddOnClickEvent(self.view.btn_enter,self,self.BtnEnterOnClick)
end

function this:RES_WAR_ALLIANCE_BOSS_PANEL(_,message)
    local curId = message["1"]
    self.killProgress = message["5"]
    ---@type cfg_rep_column
    local repTbl = SL:GetConfig("cfg_rep",curId)
    ---@type cfg_repMonster_column
    local repMonster = SL:GetConfig("cfg_repMonster",repTbl.monster)
    ---@type cfg_repMonster_column[]
    self.bossInfoListData = {repMonster}
    while repMonster.nextID ~= 0 do
        local next = SL:GetConfig("cfg_repMonster",repMonster.nextID)
        table.insert(self.bossInfoListData,next)
        repMonster = next
    end
    GUI:OSAScrollView_RefreshList(self.view.osa_boss,#self.bossInfoListData)
    self.rewardListData = repTbl.UIreward
    GUI:OSAScrollView_RefreshList(self.view.osa_reward,#self.rewardListData)
    
    local isOpen = message["3"]
    GUI:setVisible(self.view.btn_enter,isOpen)
end

function this:BtnCloseOnClick()
    GUI:UIPanel_Close("dev/outui/Union/Panel/KLUnionBossMain/KLUnionBossMainPanel")
end

function this:BtnEnterOnClick()
    GUI:UIPanel_Close("dev/outui/Union/Panel/KLUnionBossMain/KLUnionBossMainPanel")
    GUI:UIPanel_Close("dev/outui/Union/Panel/KLUnionActivity/KLUnionActivityPanel")
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel")
    if InfoManager.unionBossInfo.inChallengeBoss then
        SL:TipMessage("您已经在战盟boss挑战中", 1, NoticeType.NoticeMid)
        return
    end
        
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ENTER_WAR_ALLIANCE)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL.HideMainPanel()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_WAR_ALLIANCE_PANEL_INFO)

    ---@type cfg_repGlobal_column
    local config = SL:GetConfig("cfg_repGlobal",14001001)
    local tipStr = string.format("前<color=#00ff00>%s</color>个通关的战盟将获得拍卖奖励",config.value)
    GUI:Text_setString(self.view.txt_pass_tip,tipStr)
end

function this:Close()
    local activityPanel = GUI:GetUI("dev/outui/Union/Panel/KLUnionActivity/KLUnionActivityPanel")
    if not activityPanel then
        SL.ShowMainPanel()
    end
end

return this
