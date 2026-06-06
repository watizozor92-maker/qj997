---@class KLItemItem:UIKmlLuaPanelBase
---@field view KLItemItemView
local KLItemItem = class(UIKmlLuaPanelBase)
local this =KLItemItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:setContentSize(self.view.control_item,self.args.width,self.args.height)
    GUI:setContentSize(self.view.KLItemItem,self.args.width,self.args.height)
    self:RefreshItem(self.args.cfgId,self.args.count)
    --GUI:Image_loadTexture(self.view.control_item,self.args.src,self.args.atlas)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.control_item,self,self.OnCliCkTipBtn)
end

function this:OnCliCkTipBtn()
    SL:OpenTips(nil, self.args.cfgId)
end

function this:RefreshItem(cfgId,count)
    if self.cfgId ~= cfgId then
        GUI:Item_UpdataData(self.view.control_item, {
            itemid = cfgId,
            mfixsize = self.args.width..","..self.args.height
        })
        self.cfgId = cfgId
    end
    GUI:Item_setItemCount(self.view.control_item, not string.isNullOrEmpty(count) and GUIUtil.FormatNumber(tonumber(count),true) or count)
end

function this:Close()
end

return this
