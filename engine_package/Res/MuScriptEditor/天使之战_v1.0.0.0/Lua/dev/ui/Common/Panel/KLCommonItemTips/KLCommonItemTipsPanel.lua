---@class KLCommonItemTipsPanel:UIKmlLuaPanelBase
---@field view KLCommonItemTipsPanelView
local KLCommonItemTipsPanel = class(UIKmlLuaPanelBase)
local this =KLCommonItemTipsPanel
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if self.args and self.args.showTips then
        --普通空格会导致换行出错，替换成不会换行的空格
        self.args.showTips = string.replace( self.args.showTips," ","\u{00A0}")
        GUI:Text_setString(self.view.tipContent, self.args.showTips)
    end
    
    self.cfgId = self.args.cfgId
    self.needCount = self.args.needCount or 1
    GUI:Item_setItemId(self.view.showItem, self.cfgId)
    local totalCount = SL:GetBagItemCount(self.cfgId)
    if self.needCount > totalCount then
        GUI:Text_setString(self.view.countInfo, string.format('<color="#ff0000">%d</color>/%d',totalCount, self.needCount))
    else
        GUI:Text_setString(self.view.countInfo, string.format('<color="#00ff00">%d</color>/%d',totalCount, self.needCount))
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_sure,self,self.OnClickSureButton)
    GUI:AddOnClickEvent(self.view.btn_cancel,self,self.CloseSelf)
    GUI:AddOnClickEvent(self.view.closeBtn,self,self.CloseSelf)
end 

function this:Close()
end

function this:CloseSelf()
    GUI:UIPanel_Close('dev/ui/Common/Panel/KLCommonItemTips/KLCommonItemTipsPanel')
end

function this:OnClickSureButton()
    if self.args and self.args.callback then
        self.args.callback(self, self.args.callbackData)
    end
    self:CloseSelf()
end

return this
