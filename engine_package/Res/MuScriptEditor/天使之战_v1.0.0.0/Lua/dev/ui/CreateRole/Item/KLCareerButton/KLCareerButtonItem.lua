---@class KLCareerButtonItem:UIKmlLuaPanelBase
---@field view KLCareerButtonItemView
local KLCareerButtonItem = class(UIKmlLuaPanelBase)
local this =KLCareerButtonItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:Close()
end

function this:RefreshToggle(atlas, src, pimg)
    GUI:Toggle_setSrc(self.view.toggle_createrole,atlas,src,pimg)
end

---@param cfg cfg_character_create_column
function this:RefreshToggleName(cfg)
    self.cfg = cfg
    GUI:Text_setString(self.view.text_toggle_createrole, cfg.name)
    GUI:Text_setTextColor(self.view.text_toggle_createrole, cfg.isShow == 1 and "#FFFFFF" or "#999999")
    if self.cfg.id == 1 then
        GUI:Toggle_setIsOn(self.view.toggle_createrole, true)
    end
end

function this:SetOnValueChange(func, ui)
    GUI:SetToggleOnValueChange(self.view.toggle_createrole, ui, func, { data = self.cfg })
end

return this
