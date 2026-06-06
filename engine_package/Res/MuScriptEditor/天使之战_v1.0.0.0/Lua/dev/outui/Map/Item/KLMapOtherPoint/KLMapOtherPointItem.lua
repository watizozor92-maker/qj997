---@class KLMapOtherPointItem:UIKmlLuaPanelBase
---@field view KLMapOtherPointItemView
local KLMapOtherPointItem = class(UIKmlLuaPanelBase)
local this =KLMapOtherPointItem

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
    if self.args then
        ---@type cfg_npclist_column
        local npcTbl = self.args[1]
        GUI:Text_setString(self.view.txt_name, self.args.name)
        if not string.isNullOrEmpty(self.args.icon) then
            GUI:setVisible(self.view.icon,true)
            GUI:Image_loadTexture(self.view.icon,self.args.icon,"Atlas/FG_MapPanel.spriteatlas")
        else
            GUI:setVisible(self.view.icon,false)
        end
    end
end

function this:Hide()
end

function this:Close()
end

return this
