---@class KLRecycleIncomeItemItem:UIKmlLuaPanelBase
---@field view KLRecycleIncomeItemItemView
local KLRecycleIncomeItemItem = class(UIKmlLuaPanelBase)
local this =KLRecycleIncomeItemItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.KmlRecycleIncomeItemTemplate, self, self.ShowTips)
end

function this:Close()
end

---刷新显示
---@param data {count:number,cfgId:number}
function this:RefreshItem(data)
    self.cfgId=data.cfgId
    --self.view.
    GUI:Text_setString(self.view.IncomeCount,tostring(math.floor( data.count)))
    if self.item then
        --self.view.IncomeIcon.kmlControl:HideAllChilds()
        GUI:HideAllChilds(self.view.IncomeIcon)
    end
    self.item = GUI:Item_Create(self.view.IncomeIcon,{
        width = "30",
        height = "30",
        itemid = data.cfgId,
        tips = "1",
        bgscale = "0,0"
    })
end

function this:ShowTips()
   -- SL:OpenTips(bag, self.cfgId)
end

return this
