---@class KLWearBarBtnItem:UIKmlLuaPanelBase
---@field view KLWearBarBtnItemView
local KLWearBarBtnItem = class(UIKmlLuaPanelBase)
local this =KLWearBarBtnItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local args = self.args
    if not args then
        return
    end
    local imgName = args.sprite
    local chooseName = args.selectSprite
    local toggleGroup = args.toggleGroup
    local atlas = args.altas
    self.wearBar = args.wearBar
    local width = args.width
    local height = args.height
    self.onClick = args.onClick
    self.clickData = args.clickData

    GUI:Image_loadTexture(self.view.ItemBackground, imgName, atlas)
    GUI:Image_loadTexture(self.view.ItemCheckmark, chooseName , atlas)
    GUI:Text_setString(self.view.ItemLabel, "")
    GUI:setContentSize(self.view.root, width, height)
    GUI:setContentSize(self.view.toggle_item, width, height)
    GUI:setContentSize(self.view.ItemBackground, width, height)
    GUI:setContentSize(self.view.ItemCheckmark, width, height)
    GUI:SetToggleGroup(self.view.toggle_item, toggleGroup)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.toggle_item, self, self.ToggleOnClick)
end

function this:ToggleOnClick(control, eventData, state)
    if state[1] and self.onClick then
        self.onClick(self.clickData, self.wearBar)
    end
end

function this:SetSelected()
    GUI:Toggle_setIsOn(self.view.toggle_item, true)
end

function this:SetSelectedIgnoreIsOn()
    local isOn = GUI:Toggle_getIsOn(self.view.toggle_item) == "1"
    if isOn then
        self:ToggleOnClick(_, _, {true})
    else
        GUI:Toggle_setIsOn(self.view.toggle_item, true)
    end
end

function this:Close()
end

return this
