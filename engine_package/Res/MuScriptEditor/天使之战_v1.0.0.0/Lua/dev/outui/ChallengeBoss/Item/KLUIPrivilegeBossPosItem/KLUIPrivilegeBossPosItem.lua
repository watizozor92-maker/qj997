---@class KLUIPrivilegeBossPosItem:UIKmlLuaPanelBase
---@field view KLUIPrivilegeBossPosItemView
local KLUIPrivilegeBossPosItem = class(UIKmlLuaPanelBase)
local this = KLUIPrivilegeBossPosItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

function this:RefreshItem(data,mapId,panel)
    --SL:LogTable(data,true)
    self.isOpen = true
    self.mapId = mapId
    self.panel = panel
    self.data = data
    self.monsterId = self.data.monsterId
    local tab = SL:GetConfigMultiKeys('cfg_repfairyland', self.mapId, 'id')
    local name = self.data.monsterName
    self.isDie = self.data.isDie
    local num_str = "(<color=#ff2323>0</color>/1)"
    if self.isDie and self.isDie == 1 then
        num_str = "(<color=#ff2323>1</color>/1)"
    end
    GUI:Text_setString(self.view.name,"击杀 " .. name)
    GUI:Text_setString(self.view.num,num_str)
    GUI:Text_setString(self.view.info,"击杀任务")
    
end


function this:RefreshData()
    if not self.isOpen then
        return
    end
    self.panel:GetBossList()
end

function this:HideItem()
    GUI:setVisible(self.view.level_select,false)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn,self,self.Onclick)
end

function this:Onclick()
    SL:Pathfinding(self.mapId, 1, self.x, self.y)
end


function this:RefreshFirstData()
    
end

function this:Close()
    if self.Schedule then
        SL:UnSchedule(self.Schedule)
    end
end

return this
