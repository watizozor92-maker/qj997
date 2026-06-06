---@class KLBossHpItem:UIKmlLuaPanelBase
---@field view KLBossHpItemView
local KLBossHpItem = class(UIKmlLuaPanelBase)
local this = KLBossHpItem
---创建时调用一次
function this:Init()
   
end

---创建或者刷新界面数据时调用
function this:RefreshItem(args)
    self.args = args
    GUI:Item_setItemId(self.view.equip_item,self.args.cfgId)
    --GUI:Item_setItemId(self.view.equip_item,20900002)
end


---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn,self,self.BtnClick)
end

function this:BtnClick()
    SL:OpenTips("", self.args.cfgId)
end

function this:Close()
end



return this
