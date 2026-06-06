---@class KLNewNewSynthesisCostSelectPanel:UIKmlLuaPanelBase
---@field view KLNewNewSynthesisCostSelectPanelView
local KLNewNewSynthesisCostSelectPanel = class(UIKmlLuaPanelBase)
local this =KLNewNewSynthesisCostSelectPanel

---创建时调用一次
function this:Init()
    self.selectCostItems = {}
    GUI:DataListInitData(self.view.DataList_Select, function()
        return table.count(self.costs)
    end, function(realIndex)
        return self:ItemGetFunc(realIndex)
    end, nil, function(realIndex, kmlControl)
        return self:ItemUpdateFunc(realIndex, kmlControl)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Btn_Close, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.Btn_MaskClose, self, self.OnClick_Btn_MaskClose)
    GUI:AddOnClickEvent(self.view.Btn_Confirm, self, self.OnClick_Btn_Confirm)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    self.costType = self.args.costType
    self.costs = self.args.costs
    self.selectCostIndex = nil
    local temp = {}
    local selectItem
    self.selectCost = nil
    if self.args.costItem then
        for i, v in pairs(self.costs) do
            if v.item.cfgId == self.args.costItem.cfgId and (self.args.costItem == nil or self.args.costItem.id == v.item.id) then
                selectItem = v
            else
                table.insert(temp, v)
            end
        end
        if selectItem then
            local bind = selectItem.bindCount or 0
            local unbind = selectItem.unbindCount or 0
            if bind + unbind > 0 then
                self.selectCostIndex = 1
                self.costs = {}
                table.insert(self.costs, selectItem)
                self.selectCost = selectItem
                for i, v in pairs(temp) do
                    table.insert(self.costs, v)
                end
            end
        end
    end
    
    ---@type NewNewSynthesisCostInfo
 
    GUI:Text_setText(self.view.Text_Title, self.costType == 1 and "放入主要材料" or (self.costType == 2 and "放入次要材料" or "放入辅助材料"))
    local tips = ""
    if self.costType == 1 then
        tips = self.args.consumeItem
    else
        tips = self:GetTips(self.args.consumeItem)
    end
    GUI:Text_setText(self.view.Text_Tips, tips)
    if self.costs == nil or table.count(self.costs) <= 0 then
        return
    end
    GUI:DataListUpdateData(self.view.DataList_Select)
end

function this:Hide()
end

function this:Close()
end

function this:ItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/Synthesis/Item/KLNewNewSynthesisCostSelect/KLNewNewSynthesisCostSelectItem", 
                                  self.view.DataList_Select, self, nil, true, function(uiItem)
         self.selectCostItems[uiItem.view.root] = uiItem
         self:ItemUpdateFunc(realIndex, uiItem.view.root)
     end)
    
    return item.view.root
end

function this:ItemUpdateFunc(realIndex, kmlControl)
    ---@type KLNewNewSynthesisCostSelectItem
    local item = self.selectCostItems[kmlControl]
    if item == nil then
        return
    end
    local costInfo = self.costs[realIndex + 1]
    item:UpdateData(costInfo, realIndex + 1, self.selectCostIndex == realIndex + 1)
end

function this:SelectItem(is)
    
end

function this:CloseSelf()
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
    GUI:UIPanel_Close("dev/outui/Tips/Panel/KLMountShowTips/KLMountShowTipsPanel")
    GUI:UIPanel_Close("dev/outui/Synthesis/Panel/KLNewNewSynthesisCostSelect/KLNewNewSynthesisCostSelectPanel")
end

---点击遮罩关闭
function this:OnClick_Btn_MaskClose()
    if GUI:GetUI("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel") or GUI:GetUI("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel") then
        GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel")
        GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
        GUI:UIPanel_Close("dev/outui/Tips/Panel/KLMountShowTips/KLMountShowTipsPanel")
        GUI:setVisible(self.view.Mask, true)
        return
    end
    self:CloseSelf()
end

function this:OnClick_Btn_Confirm()
    if self.selectCost then
        SL:onLUAEvent(LUA_EVENT_SYNTHESIS_COST_ITEM_SELECT, self.selectCost)
    end
    self:CloseSelf()
end

---@param data NewNewSynthesisCostInfo
function this:SelectItem(data, index)
    GUI:setVisible(self.view.Mask, false)
    SL:OpenTips("bag", data.item.cfgId, data.item.id, nil, nil, { hideBtn = true, hideMask = true, posX = 309, zindex = 1001, hideComparsion = true })
    for k, v in pairs(self.selectCostItems) do
        local isSelect = v.index == index
        v:SetSelect(isSelect)
    end
    self.selectCost = data
    self.selectCostIndex = index
end

function this:GetTips(consumeItem)
    if consumeItem[1] == 1 then -- 指定材料
        local itemCfg = SL:GetConfig("cfg_item", consumeItem[2])
        return string.format("<color=#E6E600>[%s]</color>", itemCfg.name)
    elseif consumeItem[1] == 2 then -- 大类材料
        return string.format("<color=#E6E600>%s</color>", self:GetFormulaType2Str(consumeItem))
    elseif consumeItem[1] == 3 then -- 多选一材料
        local tips
        for i = 2, #consumeItem do
            local itemCfg = SL:GetConfig("cfg_item", consumeItem[i])
            if i == 2 then
                tips = string.format("[%s]", itemCfg.name)
            else
                tips = string.format("%s, [%s]", tips, itemCfg.name)
            end
        end
        return string.format("<color=#E6E600>%s</color>", tips)
    end
    return ""
end

function this:GetFormulaType2Str(v)
    local str = ""
    if v[4] > 0 then
        if v[4] == 0 then
            str = str .. "白装"
        elseif v[4] == 1 then
            str = str .. "卓越"
        elseif v[4] == 2 then
            str = str .. "套装"
        elseif v[4] == 99 then
        end
    end

    if v[5] > 0 then
        if v[5] == 1 then
            str = str .. "[1代翅膀]"
        elseif v[5] == 2 then
            str = str .. "[2代翅膀]"
        elseif v[5] == 3 then
            str = str .. "[3代翅膀]"
        elseif v[5] == 4 then
            str = str .. "[套装]"
        elseif v[5] == 5 then
            str = str .. "[首饰]"
        elseif v[5] == 6 then
            str = str .. "[玛雅武器]"
        elseif v[5] == 7 then
            str = str .. "[2.5代翅膀材料]"
        elseif v[5] == 380 then
            str = str .. "[380装备]"
        else
            str = str .. "[其他]"
        end
    else
        if v[6] > 0 then
            local cfg = SL:GetConfig("cfg_item", v[6])
            str = str .."[".. cfg.name.."]"
        else
            str = str .. "[任意装备]"
        end
    end
    if v[2] > 0 then
        str = str .. " +" .. v[2]
    end
    if v[3] > 0 then
        str = str .. " z" .. tonumber(v[3])*4
    end
    return str
end

return this
