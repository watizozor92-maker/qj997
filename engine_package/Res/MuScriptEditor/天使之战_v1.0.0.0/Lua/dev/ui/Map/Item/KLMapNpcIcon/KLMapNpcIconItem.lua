---@class KLMapNpcIconItem:UIKmlLuaPanelBase
---@field view KLMapNpcIconItemView
local KLMapNpcIconItem = class(UIKmlLuaPanelBase)
local this =KLMapNpcIconItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if self.args then
        ---@type cfg_npclist_column
        local npcTbl = self.args[1]
        local showName = self.args[2]
        GUI:Text_setString(self.view.txt_name, showName and npcTbl.showInMinimap or "")
        if not string.isNullOrEmpty(npcTbl.icon) then
            GUI:setVisible(self.view.icon,true)
            GUI:Image_loadTexture(self.view.icon,npcTbl.icon,"Atlas/UIMapPanel.spriteatlas")
        else
            GUI:setVisible(self.view.icon,false)
        end
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:Close()
end

return this
