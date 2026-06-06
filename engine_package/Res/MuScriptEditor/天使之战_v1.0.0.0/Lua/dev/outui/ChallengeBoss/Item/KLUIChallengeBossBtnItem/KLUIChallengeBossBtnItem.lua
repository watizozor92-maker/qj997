---@class KLUIChallengeBossBtnItem:UIKmlLuaPanelBase
---@field view KLUIChallengeBossBtnItemView
local KLUIChallengeBossBtnItem = class(UIKmlLuaPanelBase)
local this = KLUIChallengeBossBtnItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

function this:RefreshItem(level,select_gold_level,panel)
    self.panel = panel
    self.level = level
    local playerLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    local level_str = self.level.."级"
    if playerLevel < self.level then
        level_str = "<color=#ff2323>".. self.level.."级</color>"
    end
    GUI:Text_setString(self.view.type_name,level_str)
    if level == select_gold_level then
        GUI:setVisible(self.view.level_select,true)
    else
        GUI:setVisible(self.view.level_select,false)
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
    self.panel:HideSelectLevel()
    GUI:setVisible(self.view.level_select,true)
    self.panel:SelectLevel(self.level,self)
end


function this:Close()
end

return this
