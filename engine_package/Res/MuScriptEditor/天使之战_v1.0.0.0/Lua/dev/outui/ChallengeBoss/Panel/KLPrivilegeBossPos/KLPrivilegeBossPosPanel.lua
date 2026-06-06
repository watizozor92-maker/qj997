---@class KLPrivilegeBossPosPanel:UIKmlLuaPanelBase
---@field view KLPrivilegeBossPosPanelView
local KLPrivilegeBossPosPanel = class(UIKmlLuaPanelBase)
local this = KLPrivilegeBossPosPanel
---创建时调用一次
function this:Init()
    
    GUI:DataListInitData(self.view.boss_pos_dl,function()
        return self:GoldBossPosDataListItemCountFunc()
    end,function(realIndex)
        return self:GoldBossPosDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:GoldBossPosDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GoldBossPosDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.boss_Pos_all_item = {}

    
end

function this:InitData(data)
    local one_data = SL:GetConfig("cfg_rep",data.configId)
    self.mapId = data.configId
    self.is_close = false
    -- self.monsterInfo = data.monsterInfo
    self.show_pos = true
    self.monster1 = {}
    local monster_tab = SL:GetConfig('cfg_monster', one_data.monsterUI)
    --SL:LogTable(monster_tab,true)
    local tab = {monsterId = one_data.monsterUI,isDie = data.isDie,monsterName = monster_tab.name}
    --SL:LogTable(tab,true)
    table.insert(self.monster1,tab)
    GUI:DataListUpdateData(self.view.boss_pos_dl)
    self:DieEnd(data.isDie,one_data.save)
end



---创建或者刷新界面数据时调用
function this:Refresh()
    
end

function this:SetVisible(isVisible)
    GUI:setVisible(self.view.root,isVisible)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    -- GUI:SetToggleOnValueChange(self.view.boss_1_toggle, self, self.Boss1Click)
    -- GUI:SetToggleOnValueChange(self.view.boss_2_toggle, self, self.Boss2Click)
    -- GUI:SetToggleOnValueChange(self.view.boss_3_toggle, self, self.Boss3Click)
    GUI:AddOnClickEvent(self.view.exitBtn,self,self.Exit)
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_DIE, self.MonsterDie, self)   --怪物死亡
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_QUIT_DUPLICATE,self.RES_QUIT_SUCCESS,self)
end

function this:Exit()
    SL:CommonTipsMessage({ stringTblID=211, ui = self, sureBtnText = "确定", cancelBtnText = "取消",
    callback = self.ExitSure})
end

function this:ExitSure()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_QUIT_DUPLICATE)
end


function this:CloseOnclick()
    GUI:UIPanel_Close("dev/outui/ChallengeBoss/Panel/KLPrivilegeBossPos/KLPrivilegeBossPosPanel")
    SL.ShowMainPanel()
end


function this:MonsterDie(_id,message)
    -- SL:LogError("MonsterDie---------")
    -- SL:LogTable(message,true)
    if self.hateId and self.hateId~=0 and message == self.hateId then
        self:ShowPosView()
    end
end

function this:DieEnd(isDie,time)
    if isDie and isDie == 1 then
        local EndPanel = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Panel/KLPrivilegeBossEnd/KLPrivilegeBossEndPanel")
        EndPanel:InitData(time)
    else
        GUI:UIPanel_Close("dev/outui/ChallengeBoss/Panel/KLPrivilegeBossEnd/KLPrivilegeBossEndPanel")
    end
end


function this:GoldBossPosDataListItemCountFunc()
    return #self.monster1
end

function this:GoldBossPosDataListItemGetFunc(realIndex)
    local data = self.monster1[realIndex + 1]
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIPrivilegeBossPosItem/KLUIPrivilegeBossPosItem",self.view.boss_pos_dl,self,{},true)
    self.boss_Pos_all_item[item.view.root] = item
    return item.view.root
end

function this:GoldBossPosDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:GoldBossPosDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.monster1[realIndex + 1]
    self.boss_Pos_all_item[kmlcontrol]:RefreshItem(data,self.mapId,self)
    
end



function this:Close()
    self.is_close = true
end

function this:RES_QUIT_SUCCESS(id,message)
     ---@type cfg_rep_column
     local tbl = SL:GetConfig("cfg_rep",message,"id")
     if tbl.type == EActivityType.PrivilegeBoss then
        self.is_close = true
        InfoManager.copActivityInfo.hideTask = false
        self:CloseOnclick()
        SL:onLUAEvent(LUA_EVENT_SHOW_TASK)
     end
end


return this
