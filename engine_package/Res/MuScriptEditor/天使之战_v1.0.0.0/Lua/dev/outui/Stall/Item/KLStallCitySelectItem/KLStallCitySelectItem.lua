---@class KLStallCitySelectItem:UIKmlLuaPanelBase
---@field view KLStallCitySelectItemView
local KLStallCitySelectItem = class(UIKmlLuaPanelBase)
local this = KLStallCitySelectItem
---创建时调用一次
function this:Init()
   
end

---创建或者刷新界面数据时调用
function this:RefreshItem(data,select,StallPanel)
    self.data = data
    self.StallPanel = StallPanel
    self.select_id = select
    local map_id = self.data.message.map
    local mapname = SL:GetConfig("cfg_map_info",map_id,"id").mapname
    GUI:Text_setString(self.view.name,mapname)
    self:CheckShow()
end

function this:CheckShow()
    if self.select_id == self.data.message.id then
        GUI:setVisible(self.view.select, true)
    else
        GUI:setVisible(self.view.select, false)
    end
    
end


---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.name,self,self.SelectClick)
end


function this:Close()
end

function this:SelectClick()
    self.StallPanel:SelectCity(self.data.message.id)

end


return this
