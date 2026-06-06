---@class KLNewNewSynthesisBindCostSelectPanel:UIKmlLuaPanelBase
---@field view KLNewNewSynthesisBindCostSelectPanelView
local KLNewNewSynthesisBindCostSelectPanel = class(UIKmlLuaPanelBase)
local this =KLNewNewSynthesisBindCostSelectPanel

---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.DataList_Cost, function()
        return table.count(self.itemInfos)
    end, nil, nil, function(readIndex)
        return self:ItemUpdateFunc(readIndex)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Btn_Close, self, self.OnClick_Btn_Close)
    GUI:AddOnClickEvent(self.view.Btn_MaskClose, self, self.OnClick_Btn_Close)
    GUI:AddOnClickEvent(self.view.Btn_Confirm, self, self.OnClick_Btn_Confirm)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    self.unbindCount = self.args.unbindCount
    self.bindCount = self.args.bindCount
    local unbindId, bindId = SL:GetItemUnbindAndBindCfgId(self.args.cfgId)
    self.unbindMaxCount = SL:GetBagItemCount(unbindId, false)
    self.bindMaxCount = SL:GetBagItemCount(bindId, false)
    self.itemInfos = {}
    table.insert(self.itemInfos, { cfgId = unbindId, count = self.unbindCount, maxCount = self.unbindMaxCount })
    table.insert(self.itemInfos, { cfgId = bindId, count = self.bindCount, maxCount = self.bindMaxCount, isBind = true })
    GUI:DataListUpdateData(self.view.DataList_Cost)
end

function this:Hide()
end

function this:Close()
end
    
function this:CloseSelf()
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
    GUI:UIPanel_Close("dev/outui/Synthesis/Panel/KLNewNewSynthesisBindCostSelect/KLNewNewSynthesisBindCostSelectPanel")
end

function this:ItemUpdateFunc(readIndex)
    local item = GUI:GetChildControl(self.view.DataList_Cost, readIndex, "Item")
    local bind = GUI:GetChildControl(self.view.DataList_Cost, readIndex, "Bind")
    local text_AddCount = GUI:GetChildControl(self.view.DataList_Cost, readIndex, "Text_AddCount")
    local btn_Max = GUI:GetChildControl(self.view.DataList_Cost, readIndex, "Btn_Max")
    local btn_Minus = GUI:GetChildControl(self.view.DataList_Cost, readIndex, "Btn_Minus")
    local itemInfo = self.itemInfos[readIndex + 1]
    GUI:Item_setItemId(item, itemInfo.cfgId)
    GUI:setVisible(bind, itemInfo.isBind)
    GUI:Text_setText(text_AddCount, tostring(itemInfo.count))
    GUI:AddOnClickEvent(btn_Max, self, self.OnClick_Btn_Max, readIndex)
    GUI:AddOnClickEvent(btn_Minus, self, self.OnClick_Btn_Minus, readIndex)
    GUI:AddOnClickEvent(item, self, self.OnClick_Item, itemInfo.cfgId)
end

function this:OnClick_Btn_Close()
    SL:onLUAEvent(LUA_EVENT_SYNTHESIS_BIND_COUNT_CHANGE, self.args.consumeItemIndex, 3)
    self:CloseSelf()
end

function this:OnClick_Btn_Confirm()
    SL:onLUAEvent(LUA_EVENT_SYNTHESIS_BIND_COUNT_CHANGE, self.args.consumeItemIndex, 2)
    self:CloseSelf()
end

function this:OnClick_Btn_Max(_, eventData)
    local itemInfo = self.itemInfos[eventData + 1]
    if itemInfo.maxCount == 0 then
        SL:TipMessage("道具不足", 1, NoticeType.NoticeMid)
        return
    end
    if itemInfo.count >= itemInfo.maxCount then
        SL:TipMessage("道具数量上限", 1, NoticeType.NoticeMid)
        return
    end
    local totalCount = 0
    for i, v in pairs(self.itemInfos) do
        totalCount = totalCount + v.count
    end
    -- 判断是否超过最大提交数量
    local redundancyCount = self.args.maxCount - totalCount
    if redundancyCount <= 0 then
        if self.args.auxiliaryCostType == ESynthesisAuxiliaryCostType.extrit then
            SL:TipMessage("成功率上限，无法继续添加", 1, NoticeType.NoticeMid)
        else
            SL:TipMessage("提交数量上限", 1, NoticeType.NoticeMid)
        end
        return
    end
    if redundancyCount > itemInfo.maxCount then
        itemInfo.count = itemInfo.maxCount
    else
        itemInfo.count = itemInfo.count + redundancyCount
    end
    GUI:Text_setText(GUI:GetChildControl(self.view.DataList_Cost, eventData, "Text_AddCount"), tostring(itemInfo.count))
    SL:onLUAEvent(LUA_EVENT_SYNTHESIS_BIND_COUNT_CHANGE, self.args.consumeItemIndex, 1, itemInfo.cfgId, itemInfo.count)
end

function this:OnClick_Btn_Minus(_, eventData)
    local itemInfo = self.itemInfos[eventData + 1]
    if itemInfo.count <= 0 then
        return
    end
    itemInfo.count = itemInfo.count - 1
    GUI:Text_setText(GUI:GetChildControl(self.view.DataList_Cost, eventData, "Text_AddCount"), tostring(itemInfo.count))
    SL:onLUAEvent(LUA_EVENT_SYNTHESIS_BIND_COUNT_CHANGE, self.args.consumeItemIndex, 1, itemInfo.cfgId, itemInfo.count)
end

function this:OnClick_Item(_, eventData)
    SL:OpenTips(nil, eventData, nil, nil, nil, { hideBtn = true, posX = 309, zindex = 999, hideComparsion = true })
end

return this
