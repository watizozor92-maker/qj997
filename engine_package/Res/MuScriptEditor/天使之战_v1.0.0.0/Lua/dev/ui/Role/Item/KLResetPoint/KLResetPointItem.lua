---@class KLResetPointItem:UIKmlLuaPanelBase
---@field view KLResetPointItemView
local KLResetPointItem = class(UIKmlLuaPanelBase)
local this =KLResetPointItem
---创建时调用一次
function this:Init()
    local cost_info = string.split(SL:GetConfig('cfg_global', 83).value,'#')
    self.itemId = tonumber(cost_info[1])
    self.itemCount = tonumber(cost_info[2])
end

---创建或者刷新界面数据时调用
function this:Refresh()

    GUI:Item_setItemId(self.view.cost_item, self.itemId)
    local level_info = string.split(SL:GetConfig('cfg_global', 82).value,'#')
    local minLevel = tonumber(level_info[2])
    local maxLevel = tonumber(level_info[3])
    if SL:MeData_GetLevel() >= minLevel and SL:MeData_GetLevel() <= maxLevel then
        GUI:setVisible(self.view.cost_item, false)
    else
        GUI:setVisible(self.view.cost_item, true)
    end
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.common_rt_btn,self,self.common_rt_btnOnClick)
    GUI:AddOnClickEvent(self.view.common_lf_btn,self,self.common_lf_btnOnClick)
    GUI:AddOnClickEvent(self.view.closeBtn,self,self.closeBtnOnClick)
    GUI:AddOnClickEvent(self.view.MaskBtn,self,self.closeBtnOnClick)
    GUI:AddOnClickEvent(self.view.item_click_img, self, self.ClickCostItem)
end

function this:common_rt_btnOnClick()
    local level_info = string.split(SL:GetConfig('cfg_global', 82).value,'#')
    local minLevel = tonumber(level_info[2])
    local maxLevel = tonumber(level_info[3])
    if SL:MeData_GetLevel() < minLevel or SL:MeData_GetLevel() > maxLevel then
    if self.itemCount > SL:GetBagItemCount(self.itemId) then
        SL:CommonItemGetPath(nil, self.itemId,nil,nil,nil,function ()
            GUI:UIPanel_Close("dev/ui/Role/Item/KLResetPoint/KLResetPointItem")
        end)
        SL:TipMessage("消耗不足", 1, NoticeType.NoticeMid)
        return
    end
    end

    self:closeBtnOnClick()
    SL:ReqResetAttrPointMessage()
    PrivilegeCardManager.SendMessageSetFreeAttrInfo(nil, {}, nil)
end

function this:common_lf_btnOnClick()
    self:closeBtnOnClick()
end

function this:ClickCostItem()
    SL:OpenTips(nil, self.itemId)
end

function this:closeBtnOnClick()
    GUI:UIPanel_Close("dev/ui/Role/Item/KLResetPoint/KLResetPointItem")
end

function this:Close()
end

return this
