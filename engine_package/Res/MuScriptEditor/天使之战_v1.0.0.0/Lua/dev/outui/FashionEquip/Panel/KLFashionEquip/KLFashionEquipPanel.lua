---@class KLFashionEquipPanel:UIKmlLuaPanelBase
---@field view KLFashionEquipPanelView
local KLFashionEquipPanel = class(UIKmlLuaPanelBase)
local this =KLFashionEquipPanel

---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:UIPanel_Open("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel", _, _, {isSuit = true})
end

function this:Hide()
end

function this:Close()
end

return this
