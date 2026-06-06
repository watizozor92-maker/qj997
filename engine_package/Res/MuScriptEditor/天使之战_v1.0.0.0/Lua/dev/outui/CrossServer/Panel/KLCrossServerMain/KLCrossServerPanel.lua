---@class  KLCrossServerPanel:UIKmlLuaPanelBase
---@field view  KLCrossServerPanelView
local  KLCrossServerPanel = class(UIKmlLuaPanelBase)
local this =  KLCrossServerPanel
---创建时调用一次
function this:Init()
    SL.HideMainPanel()
    GUI:DataListInitData(self.view.activity_panel_dl,function()
        return self:BtnDataListItemCountFunc()
    end,function(realIndex)
        return self:BtnDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:BtnDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:BtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.all_item = {}
    self.allActivity = {
        {id=1, name="神之国度", cfgid = 20001},
        {id=2, name="诸神降临", cfgid = 23001},
        {id=4, name="圣域秘境", cfgid = 21001},
    }
    local kundun_cfg = SL:GetConfig("cfg_system_switch", 228)
    if kundun_cfg and kundun_cfg.needLevel <= SL:GetMetaValue("LEVEL") and kundun_cfg.needDay <= SL:GetOpenServerDay() then
        table.insert(self.allActivity,{id=3, name="昆顿入侵", cfgid = 21009})
    end
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if self.args then
        --selectType 1神之国度
        if self.args.selectType == 1 then
            GUI:SetTogDefaultThis(self.view.type_1_toggle)
        end
        
    else
        GUI:SetTogDefaultThis(self.view.type_1_toggle)
    end
    GUI:DataListUpdateData(self.view.activity_panel_dl, true, function()
        SL:RefreshPanelALLRedStateKmlByCondition("checkGodDescentMonster")
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.type_1_toggle, self, self.GodCountrySelectClick)
    GUI:AddOnClickEvent(self.view.btn_close,self,self.CloseOnclick)
    GUI:AddOnClickEvent(self.view.desBtn,self,self.DesOnclick)
    --SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PRIVILEGE_BOSS_PANEL,self.RES_PRIVILEGE_BOSS_PANEL,self)
end

function this:CloseOnclick()
    GUI:UIPanel_Close("dev/outui/CrossServer/Panel/KLCrossServerMain/KLCrossServerPanel")
    GUI:UIPanel_Close("dev/outui/CrossServer/Panel/KLGodCountry/KLGodCountryPanel")
end

function this:GodCountrySelectClick(kmlCtrl, eventData, args)
    if args[1] then
        self:SelectActicity()
    end

end


function this:SelectActicity()
    if not self.select_id then
        self.select_id = self.allActivity[1].id
    end
    if self.show_ui then
        GUI:UIPanel_Close(self.show_ui)
    end
    if self.select_id == 1 then
        self:SelectGodCountryBoss()
    elseif self.select_id == 2 then
        self:SelectGodDescentPage()
    elseif self.select_id == 3 then
        self:SelectQuintonInvasionPage()
    elseif self.select_id == 4 then
        self:SelectSanctuaryPage()
    end
    
end

--神之国度
function this:SelectGodCountryBoss()
    self.show_ui = "dev/outui/CrossServer/Panel/KLGodCountry/KLGodCountryPanel"
    GUI:UIPanel_Open("dev/outui/CrossServer/Panel/KLGodCountry/KLGodCountryPanel")
end

--诸神降临
function this:SelectGodDescentPage()
    self.show_ui = "dev/outui/CrossServer/Item/KLGodDescent/KLGodDescentItem"
    GUI:UIPanel_Open(self.show_ui, self.view.root, self)
    SL:RefreshPanelALLRedStateKmlByCondition("checkGodDescentMonster")
end

--混顿入侵
function this:SelectQuintonInvasionPage()
    self.show_ui = "dev/outui/Activity/Panel/KLQuintonInvasion/KLQuintonInvasionPanel"
    GUI:UIPanel_Open(self.show_ui, self.view.root, self)
end

--圣域BOSS
function this:SelectSanctuaryPage()
    self.show_ui = "dev/outui/CrossServer/Panel/KLSanctuaryBossActivity/KLSanctuaryBossActivityPanel"
    GUI:UIPanel_Open(self.show_ui, self.view.root, self)
end


function this:BtnDataListItemCountFunc()
    return #self.allActivity
end

function this:BtnDataListItemGetFunc(realIndex)
    local index = realIndex + 1
    local data = self.allActivity[realIndex + 1]
    local item = GUI:UIPanel_Open("dev/outui/CrossServer/Item/KLUCrossServerMainBtnItem/KLUCrossServerMainBtnItem",self.view.activity_panel_dl,self,nil,true)
    self.all_item[index] = item
    item:RefreshItem(data,self.select_id,self)
    if self.select_id == data.id then
        self:Select(data.id,item)
    end
    GUI:SetID(item.view.root, "KLUCrossServerMainBtnItem_"..data.cfgid)
    return item.view.root
end

function this:BtnDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:BtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    local index = realIndex + 1
    local data = self.allActivity[realIndex + 1]
    self.all_item[index]:RefreshItem(data,self.select_id,self)
    if data.id == self.select_id then
        self.LevelBtn = self.all_item[index]
    end
end

function this:HideSelect()
    if self.LevelBtn then
        self.LevelBtn:HideItem()
    end
end

function this:Select(id,Btn)
    self.LevelBtn = Btn
    self.select_id = id
    self:SelectActicity()
end

function this:DesOnclick()
    GUI:UIPanel_Open("dev/outui/CrossServer/Panel/KLCrossServerIntroduce/KLCrossServerIntroducePanel")
end


function this:Close()
    SL.ShowMainPanel()
end


return this
