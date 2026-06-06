---@class KLGrailDecomposeItem:UIKmlLuaPanelBase
---@field view KLGrailDecomposeItemView
local KLGrailDecomposeItem = class(UIKmlLuaPanelBase)
local this = KLGrailDecomposeItem

---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.grail_item, self, function()
        SL:OpenTips("bag", self.itemCfg, self.itemId, nil, nil, { hideBtn = true })
    end)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:RefeshData(itemCfg, itemId)
    self.itemCfg = itemCfg
    self.itemId = itemId
    GUI:Item_setItemId(self.view.grail_item, itemCfg)
    local strengthlv = InfoManager.archangeEquipInfo:GetGrailStrengthLv(itemId)
    if strengthlv > 0 then
        GUI:setVisible(self.view.strengthLevel, true)
        GUI:Text_setString(self.view.strengthLevel, "+" .. tostring(strengthlv))
    else
        GUI:setVisible(self.view.strengthLevel, false)
    end

end

function this:Hide()
end

function this:Close()
end

return this
