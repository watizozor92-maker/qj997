---@class KLUIChallengeBossSelectBtnItem:UIKmlLuaPanelBase
---@field view KLUIChallengeBossSelectBtnItemView
local KLUIChallengeBossSelectBtnItem = class(UIKmlLuaPanelBase)
local this = KLUIChallengeBossSelectBtnItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

function this:RefreshItem(data,select_gold_level,panel,type)
    ---@type KLChallengeBossPanel
    self.panel = panel
    self.data = data
    self.level = data.level
    self.monsterid = data.monsterid
    self.type = type
    local tab = SL:GetConfigMultiKeys('cfg_monster', self.monsterid, 'id')
    local name = tab.name
    local icon = tab.icon
    local playerLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    local level_str = "Lv." .. self.level
--[[    if playerLevel < self.level then
        level_str = "开启等级: <color=#ff2323>".. self.level.."</color>"
    end]]
    GUI:Text_setString(self.view.level,level_str)
    GUI:Text_setString(self.view.name,name)

    GUI:Image_loadTexture(self.view.touxiang,icon,"Atlas/Monster_icon.spriteatlas")
    if self.type == EBossChallengeType.Field then
        if self.data.index == select_gold_level then
            GUI:setVisible(self.view.level_select,true)
        else
            GUI:setVisible(self.view.level_select,false)
        end
--[[    elseif self.type == EBossChallengeType.Secret then
        if self.data.index == select_gold_level then
            GUI:setVisible(self.view.level_select,true)
        else
            GUI:setVisible(self.view.level_select,false)
        end]]
    elseif self.type == EBossChallengeType.Sanctuary then
        if self.level == select_gold_level then
            GUI:setVisible(self.view.level_select,true)
        else
            GUI:setVisible(self.view.level_select,false)
        end
    elseif self.type == EBossChallengeType.Privilege then
        if self.data.index == select_gold_level then
            GUI:setVisible(self.view.level_select,true)
        else
            GUI:setVisible(self.view.level_select,false)
        end
    end
end

function this:HideItem()
    GUI:setVisible(self.view.level_select,false)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn,self,self.OnclickIcon)
end


function this:OnclickIcon()
    if self.type == 2 then
        self.panel:HideSelectLevelOutdoor()
        GUI:setVisible(self.view.level_select,true)
        self.panel:SelectLevelOutdoor(self.data.index,self)
    elseif self.type == 3 then
        self.panel:HideSelectLevelSecret()
        GUI:setVisible(self.view.level_select,true)
        self.panel:SelectLevelSecret(self.data.index,self)
    elseif self.type == 4 then
        self.panel:HideSelectLevelPrivilege()
        GUI:setVisible(self.view.level_select,true)
        self.panel:SelectLevelPrivilege(self.data.index,self)
    elseif self.type == EBossChallengeType.Sanctuary then
        self.panel:HideSanctuaryLevelSecret()
        GUI:setVisible(self.view.level_select,true)
        self.panel:SelectSanctuarySecret(self.level,self)
    end
end


function this:Close()
end

return this
