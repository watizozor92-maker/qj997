---@class KLNewNewSynthesisPanel:UIKmlLuaPanelBase
---@field view KLNewNewSynthesisPanelView
---@field formulaCfg cfg_synthesis_column
local KLNewSynthesisPanel = class(UIKmlLuaPanelBase)
local this =KLNewSynthesisPanel

---@class NewNewSynthesisCostInfo
---@field formulaId number 配方Id
---@field consumeIndex number 消耗公式索引
---@field consumeItem table 消耗公式
---@field item table 道具
---@field needCount number 需要数量
---@field bindCount number 绑定数量
---@field unbindCount number 非绑定数量
---@field auxiliaryCostType number 辅助材料消耗类型

---创建时调用一次
function this:Init()
    GUI:UIPanel_Open("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel", nil, nil, nil, false, function(uipanel)
        self.bagUI = uipanel
    end)
    
    GUI:DataListInitData(self.view.DataList_TabType, function()
       return table.count(self.tabDatas) 
    end, nil , nil , function(realIndex, kmlControl)
        return self:ItemUpdateFunc(realIndex, kmlControl)
    end )

    ---@type table<NewNewSynthesisCostInfo>
    self.mainCost = {}
    ---主要材料item
    self.mainCostItems = {}
    GUI:DataListInitData(self.view.DataList_MainCost, function()
        return 1
    end, function(realIndex)
        return self:CostItemGetFunc(self.view.DataList_MainCost, realIndex, self.mainCostItems)
    end, nil, function(realIndex, kmlControl)
        return self:MainCostItemUpdateFunc(realIndex, kmlControl)
    end)
    
    ---@type table<NewNewSynthesisCostInfo>
    self.minorCost = {}
    ---次要材料item
    self.minorCostItems = {}
    GUI:DataListInitData(self.view.DataList_MinorCost, function()
        local count = table.count(self.minorCost)
        return count > 0 and count or 5
    end, function(realIndex)
        return self:CostItemGetFunc(self.view.DataList_MinorCost, realIndex, self.minorCostItems)
    end, nil, function(realIndex, kmlControl)
        return self:MinorCostItemUpdateFunc(realIndex, kmlControl)
    end)

    ---@type table<NewNewSynthesisCostInfo>
    self.auxiliaryCost = {}
    ---辅助材料item
    self.auxiliaryCostItems = {}
    GUI:DataListInitData(self.view.DataList_AuxiliaryCost, function()
        local count = table.count(self.auxiliaryCost)
        return count > 0 and count or 3
    end, function(realIndex)
        return self:CostItemGetFunc(self.view.DataList_AuxiliaryCost, realIndex, self.auxiliaryCostItems)
    end, nil, function(realIndex, kmlControl)
        return self:AuxiliaryCostItemUpdateFunc(realIndex, kmlControl)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Btn_Close, self, self.OnClick_Btn_Close)
    GUI:AddOnClickEvent(self.view.Btn_ShowTips, self, self.OnClick_Btn_ShowTips)
    GUI:AddOnClickEvent(self.view.Btn_LookPreview, self, self.OnClick_Btn_LookPreview)
    GUI:AddOnClickEvent(self.view.Btn_Confirm, self, self.OnClick_Btn_Confirm)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.STRENGTH_EQUIP_RESULT, self.STRENGTH_EQUIP_RESULT, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ITEM_SYNTHESIS, self.RES_ITEM_SYNTHESIS, self)
    SL:RegisterLUAEvent(LUA_EVENT_SYNTHESIS_COST_OPEN_PANEL, self.LUA_EVENT_SYNTHESIS_COST_OPEN_PANEL,self)
    SL:RegisterLUAEvent(LUA_EVENT_SYNTHESIS_COST_ITEM_SELECT, self.LUA_EVENT_SYNTHESIS_COST_ITEM_SELECT,self)
    SL:RegisterLUAEvent(LUA_EVENT_SYNTHESIS_BIND_COUNT_CHANGE, self.LUA_EVENT_SYNTHESIS_BIND_COUNT_CHANGE,self)
    --SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_UI_BOTTOM_SYSTEM_CLOSE, self.OnClick_Btn_Close,self)
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:Text_setText(self.view.Text_Title, self.args.cfg.name)
    local tbl = SL:GetConfigTable("cfg_synthesis")
    local tempTypes = {}
    for i, v in pairs(self.args.cfg.type) do
        tempTypes[v] = true
    end
    self.synthesisCfgDatas = {}
    self.tabDatas = {}
    local career = SL:MeData_GetCareer()
    ---@param v cfg_synthesis_column
    for i, v in pairs(tbl) do
        if tempTypes[v.type] and self:CheckCareer(career, v) then
            if self.synthesisCfgDatas[v.type] == nil then
                self.synthesisCfgDatas[v.type] = { v }
                table.insert(self.tabDatas, v)
            else
                table.insert(self.synthesisCfgDatas[v.type], v)
            end
        end
    end
    GUI:DataListUpdateData(self.view.DataList_TabType)
    GUI:DataListUpdateData(self.view.DataList_MainCost)
    GUI:DataListUpdateData(self.view.DataList_MinorCost)
    GUI:DataListUpdateData(self.view.DataList_AuxiliaryCost)
end

function this:Hide()
end

function this:Close()
end

function this:ItemUpdateFunc(realIndex, kmlControl)
    local tog = GUI:GetChildControl(self.view.DataList_TabType, realIndex, "Tog")
    local text_togName = GUI:GetChildControl(self.view.DataList_TabType, realIndex, "Text_TogName")
    ---@type cfg_synthesis_column
    local data = self.tabDatas[realIndex + 1]
    GUI:Text_setText(text_togName, data.typeName)
    GUI:SetToggleOnValueChange(tog, self, self.OnValueChange_TabTog, data)
    if realIndex == 0 then
        GUI:SetTogDefaultThis(tog)
    end
end

function this:CostItemGetFunc(parent, realIndex, items)
    local item = GUI:UIPanel_Open("dev/outui/Synthesis/Item/KLNewNewSynthesisCost/KLNewNewSynthesisCostItem", parent, self, nil, true)
    items[item.view.root] = item
    return item.view.root
end

function this:MainCostItemUpdateFunc(realIndex, kmlControl)
    local cost = self.mainCost[realIndex + 1]
    ---@type KLNewNewSynthesisCostItem
    local item = self.mainCostItems[kmlControl]
    item:UpdateData(realIndex + 1, 1, cost, self.selectTab)
end

function this:MinorCostItemUpdateFunc(realIndex, kmlControl)
    local cost = self.minorCost[realIndex + 1]
    ---@type KLNewNewSynthesisCostItem
    local item = self.minorCostItems[kmlControl]
    item:UpdateData(realIndex + 1, 2, cost, self.resetMinorCostItemCount)
end

function this:AuxiliaryCostItemUpdateFunc(realIndex, kmlControl)
    local cost = self.auxiliaryCost[realIndex + 1]
    ---@type KLNewNewSynthesisCostItem
    local item = self.auxiliaryCostItems[kmlControl]
    item:UpdateData(realIndex + 1, 3, cost, self.resetAuxiliaryCostItemCount)
end

---检查职业
---@param cfg cfg_synthesis_column
function this:CheckCareer(career, cfg)
    if #cfg.career == 0 then
        return true
    end
    for i, v in pairs(cfg.career) do
        if v[1] == career.baseCareer and v[2] <= career.careerRank then
            return true
        end
    end
    return false
end

function this:GetSynthesisItemBindCfgId(item_cfg_Id)
    if item_cfg_Id == 50030002 then
        return 1253000299
    elseif item_cfg_Id == 50030004 then
        return 1253000499
    elseif item_cfg_Id == 50030003 then
        return 1253000399
    elseif item_cfg_Id == 1253000299 then
        return 50030002
    elseif item_cfg_Id == 1253000499 then
        return 50030004
    elseif item_cfg_Id == 1253000399 then
        return 50030003
    end
    local cfg = SL:GetConfig("cfg_item", item_cfg_Id) or {}
    return cfg.bindEqualItem or 0
end

---获取costs和dataList
function this:GetCostsAndItemAndDataListByCostType(costType)
    if costType == 1 then
        return self.mainCost, self.mainCostItems, self.view.DataList_MainCost
    elseif costType == 2 then
        return self.minorCost, self.minorCostItems, self.view.DataList_MinorCost
    else
        return self.auxiliaryCost, self.auxiliaryCostItems, self.view.DataList_AuxiliaryCost
    end
end

---刷新合成名称和模型
function this:RefreshSynthesisName()
    if self.formulaCfg == nil then
        local cfg = self.synthesisCfgDatas[self.selectTab][1]
        GUI:Text_setText(self.view.Text_SynthesisName, cfg.typeName)
        --GUI:Text_setText(self.view.Text_MainTips, cfg.descriptiondefault)
        self:SetEquipModel()
        self:SetLiuGuang()
        return
    end
    --GUI:Text_setText(self.view.Text_MainTips, "")
    if self.selectTab < 3 then
        local equip = self.mainCost[1].item
        local targetLevel = EquipFunc.GetEquipStrengthLevel(equip) + 1
        local name = SL:GetConfig("cfg_item", equip.cfgId).name
        GUI:Text_setText(self.view.Text_SynthesisName, string.format("%s +%d", name, targetLevel))
        self:SetEquipModel(equip.cfgId)
        self:SetLiuGuang(equip, targetLevel)
        return
    end
    self:SetLiuGuang()
    -- 检查定向道具
    for i, v in pairs(self.auxiliaryCost) do
        if v.auxiliaryCostType == ESynthesisAuxiliaryCostType.dingxia and v.item then
            for _, k in pairs(self.formulaCfg.productId) do
                if GUIUtil.ItemEquals(v.item.cfgId, k[4]) then
                    local cfg = SL:GetConfig("cfg_item", k[1])
                    self:SetEquipModel(cfg.id)
                    GUI:Text_setText(self.view.Text_SynthesisName, cfg.name)
                    return
                end
            end
        end
    end
    local career = SL:MeData_GetCareer()
    for i, v in pairs(self.formulaCfg.productId) do
        local cfg = SL:GetConfig("cfg_item", v[1])
        for _, k in pairs(cfg.job) do
            if k[1] == career.baseCareer and v[2] <= career.careerRank then
                self:SetEquipModel(cfg.id)
                GUI:Text_setText(self.view.Text_SynthesisName, cfg.name)
                return
            end
        end
    end
    self:SetEquipModel(self.formulaCfg.productId[1][1])
    GUI:Text_setText(self.view.Text_SynthesisName, self.formulaCfg.name)
end

function this:SetEquipModel(cfgId)
    self.modelCfgId = cfgId
    GUI:setVisible(self.view.Btn_LookPreview, cfgId ~= nil)
    if cfgId == nil then
        GUI:setVisible(self.view.Item_Model, false)
        return
    end
    GUI:setVisible(self.view.Item_Model, true)
    local itemTbl = SL:GetConfig("cfg_item", cfgId)
    local shape = itemTbl.shape[1]
    local model_charactor = SL:GetConfig("cfg_model_charactor", shape)
    local _pos = string.format("%d,%d,%d",model_charactor.forgeposition[1],model_charactor.forgeposition[2],model_charactor.forgeposition[3])
    local _rotate = string.format("%d,%d,%d",model_charactor.wearrotate[1],model_charactor.wearrotate[2],model_charactor.wearrotate[3])
    local data = {
        itemid = cfgId,
        mscale = EquipFunc.GetEquipInScaleAtt(cfgId, nil, EquipFunc.ItemForgeShowEquipScale(cfgId)),
        mrotate = _rotate,
        mpos = _pos,
    }
    GUI:Item_UpdataData(self.view.Item_Model, data)
end

-- 设置流光
function this:SetLiuGuang(equip, strengthLv)
    local liuGuangId = equip and EquipFunc.GetEquipLiuGuangId(equip, strengthLv) or nil
    if liuGuangId then
        GUI:SetStreamAttr(self.view.Item_Model, liuGuangId)
    else
        GUI:ResetStreamAttr(self.view.Item_Model)
    end
end

---刷新成功概率
function this:RefreshSuccessRate()
    if self.formulaCfg == nil then
        GUI:Text_setText(self.view.Text_SuccessRate, "0%")
        GUI:setVisible(self.view.tishi, false)
        return
    end
    GUI:setVisible(self.view.tishi, true)
    local canSynthesis, totalRate, successRate = self:IsCanSynthesis(), 0, 0
    -- 找一下道具增加成功率
    ---@param v NewNewSynthesisCostInfo
    for i, v in pairs(self.auxiliaryCost) do
        if v.item and v.auxiliaryCostType == ESynthesisAuxiliaryCostType.extrit then
            for _, k in pairs(self.formulaCfg.specialConsumeRate) do
                if GUIUtil.ItemEquals(v.item.cfgId, k[1]) then
                    successRate = successRate + k[2] * (v.item.count + (v.bindCount or 0))
                end
            end
        end
    end
    if self.selectTab < 3 then -- 装备强化概率
        local equip = self.mainCost[1].item
        local targetLevel = EquipFunc.GetEquipStrengthLevel(equip) + 1
        ---@type cfg_equip_strengthen_column
        local strengthenCfg = SL:GetConfig("cfg_equip_strengthen", equip.cfgId)
        local equipIntensifyCfg = SL:GetConfigTwoKeys("cfg_equip_strengthenCost", strengthenCfg.costId, targetLevel, "costGroupId", "level")
        totalRate = math.min(equipIntensifyCfg.rate + successRate, 10000) / 100
        local luckyRate = EquipFunc.GetEquipStrengthLuckyRate(equip)
        local luckyRateStr = luckyRate == 0 and "" or SL:GetColorText(string.format("（+%d%%）", luckyRate / 100),"#E27FE3")
        if canSynthesis then
            GUI:Text_setText(self.view.Text_SuccessRate, string.format("%d%%%s", totalRate, luckyRateStr).. "(<color=#E6E600>上限100%</color>)")
        else
            GUI:Text_setText(self.view.Text_SuccessRate, "0%")
        end
        if not string.isNullOrEmpty(equipIntensifyCfg.tips) then
            if self:HasBaohuItem() then
                GUI:Text_setText(self.view.tishi, "本次失败装备保留，强化归零（道具保护）")
            else
                GUI:Text_setText(self.view.tishi, equipIntensifyCfg.tips)
            end
        end
        self:RefreshCoinCost(canSynthesis and equipIntensifyCfg.coincost or nil)
        --GUI:Text_setText(self.view.Text_SuccessRate, canSynthesis and tostring(totalRate) .. (table.count(self.formulaCfg.consumeItem2) > 0 and "%"..luckyRateStr.."(<color=#E6E600>上限100%</color>)" or "") or "0%")
        return
    else
        totalRate = tonumber(self.formulaCfg.successRate)
    end
    self:RefreshCoinCost(canSynthesis and self.formulaCfg.coin or nil)
    totalRate = math.min(totalRate + successRate, tonumber(self.formulaCfg.successRateMax)) / 100
    if #self.formulaCfg.fail > 0 then
        local hasBaohu = self:HasBaohuItem()
        if not hasBaohu then
            GUI:Text_setText(self.view.tishi, "失败后，原先的合成材料会全部消失")
            --[[if self.formulaCfg.fail[1] == 0 and self.formulaCfg.fail[2] == 0 then
                GUI:Text_setText(self.view.tishi, "失败后，投入装备强化追加等级清零")
            else
                GUI:Text_setText(self.view.tishi, string.format("失败后，装备强化等级降为%d级，追加等级降为%d级", self.formulaCfg.fail[1], self.formulaCfg.fail[2]))
            end]]
        else
            --GUI:Text_setText(self.view.tishi, SL:GetConfig("cfg_string", 55001).text)
            GUI:Text_setText(self.view.tishi, "失败后，投入装备强化追加等级清零（道具保护）")
        end
    else
        GUI:Text_setText(self.view.tishi, "失败后，原先的合成材料会全部消失")
    end
    GUI:Text_setText(self.view.Text_SuccessRate, canSynthesis and string.format("%d%%(<color=#E6E600>上限%d%%</color>)", totalRate, tonumber(self.formulaCfg.successRateMax) / 100) or "0%")
end

---刷新金币消耗
function this:RefreshCoinCost(coinCost)
    self.coinCost = coinCost
    if self.coinCost == nil then
        GUI:Text_setText(self.view.Text_CostName, "消耗金币")
        GUI:Text_setText(self.view.Text_CostValue, "0")
        GUI:Text_setTextColor(self.view.Text_CostValue, "#")
        return
    end
    local cfg = SL:GetConfig("cfg_item", self.coinCost[1])
    GUI:Text_setText(self.view.Text_CostName, "消耗"..cfg.name)
    GUI:Text_setText(self.view.Text_CostValue, tostring(self.coinCost[2]))
    GUI:Text_setTextColor(self.view.Text_CostValue, SL:GetBagItemCount(self.coinCost[1]) < self.coinCost[2] and "#F33841" or "#FF2323 ")
end

---刷新次要消耗
function this:RefreshMinorCostItem()
    self.minorCost = {}
    if self.selectTab < 3 then -- 装备强化消耗
        local equip = self.mainCost[1].item
        ---@type cfg_equip_strengthen_column
        local strengthenCfg = SL:GetConfig("cfg_equip_strengthen", equip.cfgId)
        ---@type cfg_equip_strengthenCost_column
        local strengthenCostCfg = SL:GetConfigTwoKeys("cfg_equip_strengthenCost", strengthenCfg.costId, EquipFunc.GetEquipStrengthLevel(equip) + 1, "costGroupId", "level")
        if strengthenCostCfg then
            for i, v in pairs(strengthenCostCfg.cost) do
                local consumeItem = { 1, v[1], v[2] }
                local item = {
                    cfgId = v[1],
                    --count = math.min(v[2] or 1, self:GetBagItemCount(v[1]))
                    count = 0
                }
                table.insert(self.minorCost, { consumeIndex = i, consumeItem = consumeItem, item = item, needCount = v[2] })
            end
        end
    else
        local needCount
        for i, v in pairs(self.formulaCfg.consumeItem) do
            needCount = (v[1] == 1 and v[3] or v[7]) or 1
            local item
            if v[1] == 1 then
                local cfg = SL:GetConfig("cfg_item", v[2])
                if cfg.type ~= E_ItemType.Equip then
                    item = {
                        cfgId = v[2],
                        --count = math.min(v[3] or 1, self:GetBagItemCount(v[2]))
                        count = 0
                    }
                end
            end
            table.insert(self.minorCost, { consumeIndex = i, consumeItem = v, item = item, needCount = needCount })
        end
    end
    GUI:DataListUpdateData(self.view.DataList_MinorCost, nil, function()
        self.resetMinorCostItemCount = false
    end)
    GUI:setVisible(self.view.MinorCostMat, table.count(self.minorCost) > 0)
end

---刷新辅助消耗
function this:RefreshAuxiliaryCostItem()
    self.auxiliaryCost = {}
    local index = 1
    -- 强化追加没有这个材料
    if self.selectTab > 2 then
        for i, v in pairs(self.formulaCfg.consumeItem2) do
            local needCount = (v[1] == 1 and v[3] or v[7]) or -1
            local item
            if v[1] == 1 then
                local cfg = SL:GetConfig("cfg_item", v[2])
                if cfg.type ~= E_ItemType.Equip then
                    item = {
                        cfgId = v[2],
                        --count = math.min(v[3] or 1, self:GetBagItemCount(v[2]))
                        count = 0
                    }
                end
            end
            table.insert(self.auxiliaryCost, { consumeIndex = index, consumeItem = v, item = item, auxiliaryCostType = ESynthesisAuxiliaryCostType.extrit, needCount = needCount })
            index = index + 1
        end
    end

    -- 合成保护道具
    for i, v in pairs(self.formulaCfg.protect) do
        local consumeItem = { 1, v, 1}
        local item = {
            cfgId = v,
            --count = math.min(1, self:GetBagItemCount(v))
            count = 0
        }
        table.insert(self.auxiliaryCost, { consumeIndex = index, consumeItem = consumeItem, item = item, auxiliaryCostType = ESynthesisAuxiliaryCostType.baohu, needCount = 1 })
        index = index + 1
    end

    -- 合成定向道具
    local multiple = { 3 }
    for i, v in pairs(self.formulaCfg.productId) do
        if #v >= 4 then
            table.insert(multiple, v[4])
        end
    end

    if #multiple > 1 then
        table.insert(self.auxiliaryCost, { consumeIndex = index, consumeItem = multiple, auxiliaryCostType = ESynthesisAuxiliaryCostType.dingxia, needCount = 1 })
    end

    GUI:DataListUpdateData(self.view.DataList_AuxiliaryCost, nil, function()
        self.resetAuxiliaryCostItemCount = false
    end)
    GUI:setVisible(self.view.AuxiliaryCostMat, table.count(self.auxiliaryCost) > 0)
end

---判断是否可以合成
function this:IsCanSynthesis()
    ---@param v NewNewSynthesisCostInfo
    for i, v in pairs(self.mainCost) do
        if v.item == nil or v.needCount > v.item.count + (v.bindCount or 0) then
            return false
        end
    end
    ---@param v NewNewSynthesisCostInfo
    for i, v in pairs(self.minorCost) do
        if v.item == nil or v.needCount > v.item.count + (v.bindCount or 0) then
            return false
        end
    end
    return true
end

---判断是否有保护道具
function this:HasBaohuItem()
    ---@param v NewNewSynthesisCostInfo
    for i, v in pairs(self.auxiliaryCost) do
        if v.auxiliaryCostType == ESynthesisAuxiliaryCostType.baohu and v.item and v.item.count >= v.needCount then
            return true
        end
    end
    return false
end

---获取背包道具剩余数量
function this:GetBagItemCount(cfgId, isAddBind)
    local totalCount = SL:GetBagItemCount(cfgId, isAddBind)
    if self.costType == 1 then
        return totalCount
    end
    for i, v in pairs(self.mainCost) do
        if v.item and v.item.cfgId == cfgId then
            totalCount = totalCount - v.item.count
        end
    end
    for i, v in pairs(self.minorCost) do
        if v.item and v.item.cfgId == cfgId then
            totalCount = totalCount - v.item.count
        end
    end
    --[[for i, v in pairs(self.auxiliaryCost) do
        if v.item and v.item.cfgId == cfgId then
            totalCount = totalCount - v.item.count
        end
    end]]
    return totalCount
end

function this:RefreshDefault()
    local cfg = self.synthesisCfgDatas[self.selectTab or 1][1]
    if cfg.typeShow == 0 then
        for i = 1, 3 do
            local cost, _, dataList = self:GetCostsAndItemAndDataListByCostType(i)
            table.clear(cost)
            GUI:DataListUpdateData(dataList)
        end
        return
    end
    local main = cfg.consumeItemMain[1]
    if (main[1] == 2 and cfg.type < 3) or (main[1] == 1 and main[2] == 0) then
        for i = 1, 3 do
            local cost, _, dataList = self:GetCostsAndItemAndDataListByCostType(i)
            table.clear(cost)
            GUI:DataListUpdateData(dataList)
        end
        return
    end
    table.clear(self.mainCost)
    if cfg.typeShow == 1 then
        self.mainCost[1] = {
            bindCount = 0,
            unBindCount = 0,
            consumeItemIndex = 1,
            needCount = (main[1] == 1 and main[3] or main[7]) or 1,
            item = {
                cfgId = main[2],
                count = 0
            }
        }
    end
    GUI:DataListUpdateData(self.view.DataList_MainCost)
    self.formulaCfg = cfg
    self:RefreshMinorCostItem()
    self:RefreshAuxiliaryCostItem()
    self:RefreshSynthesisName()
end

function this:ResetSynthesis()
    self.formulaCfg = nil
    self:RefreshSuccessRate()
    self:RefreshCoinCost()
    self:RefreshSynthesisName()
    GUI:setVisible(self.view.MainCostMat, true)
    GUI:setVisible(self.view.MinorCostMat, true)
    GUI:setVisible(self.view.AuxiliaryCostMat, true)
    self.resetMinorCostItemCount = true
    self.resetAuxiliaryCostItemCount = true
    self:RefreshDefault()
    GUI:setVisible(self.view.tishi, false)
end

---点击关闭按钮
function this:OnClick_Btn_Close()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    GUI:UIPanel_Close("dev/outui/Synthesis/Panel/KLNewNewSynthesis/KLNewNewSynthesisPanel")
    SL.ShowMainPanel()
end

---点击显示提示按钮
function this:OnClick_Btn_ShowTips()
    if self.formulaCfg == nil or self.modelCfgId == nil then
        return
    end
    if self.selectTab < 3 then
        local equip = self.mainCost[1].item
        EquipFunc.addStrengthLevel = 1
        SL:OpenTips("bag", equip.cfgId, equip.id, nil, nil, { hideBtn = true, hideComparsion = true, posX = -466 }, false, function()
            EquipFunc.addStrengthLevel = 0
        end)
        return
    end
    SL:OpenTips("bag", self.modelCfgId, nil, nil, nil, { hideBtn = true, hideComparsion = true, posX = -466 }, false)
end

---点击预览按钮
function this:OnClick_Btn_LookPreview()
    if self.formulaCfg == nil or self.modelCfgId == nil then
        return
    end
    if self.selectTab < 3 then
        local equip = self.mainCost[1].item
        EquipFunc.addStrengthLevel = 1
        SL:OpenTips("bag", equip.cfgId, equip.id, nil, nil, { hideBtn = true, hideComparsion = true, posX = -466 }, false, function()
            EquipFunc.addStrengthLevel = 0
        end)
        return
    end
    
    if self.modelCfgId then
        SL:OpenTips("bag", self.modelCfgId, nil, nil, nil, { hideBtn = true, hideComparsion = true, posX = -466 }, false)
    else
        local previewItemIds = {}
        for i, v in pairs(self.formulaCfg.productId) do
            table.insert(previewItemIds, v[1])
        end
        if #previewItemIds > 0 then
            if #previewItemIds == 1 then
                SL:OpenTips(nil, previewItemIds[1], nil, nil, nil, { hideBtn = true })
                return
            end
            -- 打开合成预览界面
            GUI:UIPanel_Open("dev/outui/Synthesis/Panel/KLNewSynthesisPreview/KLNewSynthesisPreviewPanel", nil, nil, previewItemIds)
        end
    end
end

---页签改变
function this:OnValueChange_TabTog(_, args, data)
    if data[1] then
        self.selectTab = args.type
        self:ResetSynthesis()
    end
end

---点击确定按钮
function this:OnClick_Btn_Confirm()
    if self.formulaCfg == nil or not self:IsCanSynthesis() or self.coinCost == nil then
        return SL:TipMessage("合成配方不满足", 1, NoticeType.NoticeMid)
    end
    if SL:GetBagItemCount(self.coinCost[1]) < self.coinCost[2] then
        return SL:TipMessage(SL:GetConfig("cfg_item", self.coinCost[1]).name .. "不足", 1, NoticeType.NoticeMid)
    end
    local hasBind = false
    if self.selectTab < 3 then
        local equip = self.mainCost[1].item
        local putCostItems = {}
        local mainIsBind = EquipFunc.GetItemIsBind(equip.cfgId, equip)
        hasBind = mainIsBind
        ---@param v NewNewSynthesisCostInfo
        for i, v in pairs(self.minorCost) do
            local unBindCfgId, bindCfgId = SL:GetItemUnbindAndBindCfgId(v.item.cfgId)
            if v.bindCount > 0 then
                table.insert(putCostItems, { itemConfigId = bindCfgId, itemCount = v.bindCount })
                hasBind = true
            end
            if v.item.count > 0 then
                table.insert(putCostItems, { itemConfigId = unBindCfgId, itemCount = v.item.count })
            end
        end
        local baohuItems = {}
        local extritItems = {}
        for i, v in pairs(self.auxiliaryCost) do
            if v.item and v.item.count + (v.bindCount or 0) >= v.needCount then
                local tempItems = {}
                if v.auxiliaryCostType == ESynthesisAuxiliaryCostType.baohu then
                    tempItems = baohuItems
                elseif v.auxiliaryCostType == ESynthesisAuxiliaryCostType.extrit then
                    tempItems = extritItems
                end
                local unBindCfgId, bindCfgId = SL:GetItemUnbindAndBindCfgId(v.item.cfgId)
                if v.bindCount > 0 then
                    table.insert(tempItems, bindCfgId)
                    hasBind = true
                end
                if v.item.count > 0 then
                    table.insert(tempItems, unBindCfgId)
                end
            end
        end
        local function ConfirmStrength(equip2)
            local data = { itemId = equip2.id, putCost = putCostItems, successItems = extritItems, protectIds = baohuItems }
            --SL:LogTable(data, true)
            if self.selectTab == 1 then -- 装备强化
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_STRENGTH_EQUIP, data)
            else -- 装备追加
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_APPEND_EQUIP, { itemId = equip2.id, successItems = extritItems })
            end
        end
        if not mainIsBind and hasBind then
            SL:CommonTipsMessage({
                                     showTips = SL:GetConfig("cfg_string", 40001).text,
                                     callback = function()
                                         ConfirmStrength(equip)
                                     end
                                 })
            return
        end
        ConfirmStrength(equip)
        return
    end
    
    -- 主要材料
    local mainItems = {}
    for i, v in pairs(self.mainCost) do
        if v.item.id then -- 装备就不管
            local mainItem = {
                id = v.item.id,
                itemConfigId = v.item.cfgId,
                itemCount = v.item.count,
                itemIndex = SL:GetBagIndex(v.item.id)  -- 有id是装备，要加上索引
            }
            table.insert(mainItems, mainItem)
            hasBind = hasBind or EquipFunc.GetItemIsBind(v.item.cfgId, v.item)
        else
            hasBind = self:CheckBindPut(mainItems, v, hasBind)
        end
    end
    -- 次要材料
    local putItems = {}
    for i, v in pairs(self.minorCost) do
        if v.item.id then -- 装备就不管
            local putItem = {
                id = v.item.id,
                itemConfigId = v.item.cfgId,
                itemCount = v.item.count,
                itemIndex = SL:GetBagIndex(v.item.id)  -- 有id是装备，要加上索引
            }
            hasBind = hasBind or EquipFunc.GetItemIsBind(v.item.cfgId, v.item)
            table.insert(putItems, putItem)
        else
            hasBind = self:CheckBindPut(putItems, v, hasBind)
        end
    end
    -- 辅助材料，可选的
    local extritItems = {}
    local dingxiaItems = {}
    local baohuItems = {}
    for i, v in pairs(self.auxiliaryCost) do
        if v.item and v.item.count + (v.bindCount or 0) >= v.needCount then
            local tableCon
            if v.auxiliaryCostType == ESynthesisAuxiliaryCostType.extrit then
                tableCon = extritItems
            elseif v.auxiliaryCostType == ESynthesisAuxiliaryCostType.dingxia then
                tableCon = dingxiaItems
            else
                tableCon = baohuItems
            end
            if v.item.id then -- 装备就不管
                local tempItem = {
                    id = v.item.id,
                    itemConfigId = v.item.cfgId,
                    itemCount = v.item.count,
                    itemIndex = SL:GetBagIndex(v.item.id)  -- 有id是装备，要加上索引
                }
                hasBind = hasBind or EquipFunc.GetItemIsBind(v.item.cfgId, v.item)
                table.insert(tableCon, tempItem)
            else
                local unBindCfgId, bindCfgId = SL:GetItemUnbindAndBindCfgId(v.item.cfgId)
                if v.bindCount > 0 then
                    hasBind = true
                    if v.auxiliaryCostType == ESynthesisAuxiliaryCostType.baohu then
                        table.insert(baohuItems, bindCfgId)
                    else
                        table.insert(tableCon, { itemConfigId = bindCfgId, itemCount = v.bindCount })    
                    end
                end
                if v.item.count > 0 then
                    if v.auxiliaryCostType == ESynthesisAuxiliaryCostType.baohu then
                        table.insert(baohuItems, v.item.cfgId)
                    else
                        table.insert(tableCon, { itemConfigId = unBindCfgId, itemCount = v.item.count })
                    end
                end
            end
        end
    end
    
    local data = {
        [1] = self.formulaCfg.id,
        [2] = putItems,
        [3] = extritItems,
        [4] = dingxiaItems,
        [5] = baohuItems,
        [6] = mainItems,
    }
    --SL:LogTable(data,true)
    ---检查合成是否有绑定道具
    if hasBind then
        SL:CommonTipsMessage({
                                 stringTblID = 67001,
                                 sureBtnText = "确定" ,
                                 callback = function()
                                     SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ITEM_SYNTHESIS, data)
                                 end;
                             })
        return
    end
    
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ITEM_SYNTHESIS, data)
end

---检查合成是否有绑定道具
function this:CheckBindPut(putItems, costInfo, hasBind)
    local unBindCfgId, bindCfgId = SL:GetItemUnbindAndBindCfgId(costInfo.item.cfgId)
    if costInfo.bindCount and costInfo.bindCount > 0 then
        hasBind = true
        table.insert(putItems, { itemConfigId = bindCfgId, itemCount = costInfo.bindCount })
    end
    if costInfo.item.count > 0 then
        table.insert(putItems, { itemConfigId = unBindCfgId, itemCount = costInfo.item.count })
    end
    return hasBind
end

---装备强化回包
function this:STRENGTH_EQUIP_RESULT(_, msg)
    if msg.issuccess then
        SL:TipMessage("装备强化成功", 1, NoticeType.NoticeMid)
    else
        SL:TipMessage("装备强化失败", 1.5, NoticeType.NoticeMid)
    end
    SL:onLUAEvent(LUA_EVENT_STRENGTH_OK, msg)
    self:ResetSynthesis()
end

---合成回包
function this:RES_ITEM_SYNTHESIS(_, msg)
    SL:TipMessage(msg.result and "合成成功" or "合成失败", 1.5, NoticeType.NoticeMid)
    if msg.res then
        for i, v in pairs(msg.res) do
            SL:onLUAEvent(LUA_EVENT_STRENGTH_OK, v)
        end
    end
    self:ResetSynthesis()
end

function this:SelectCostNum(consumeItemIndex, count)
    local costInfos, costItems = self:GetCostsAndItemAndDataListByCostType(self.costType)
    local costInfo = costInfos[consumeItemIndex]
    costInfo.item.count = count
    ---@param v KLNewNewSynthesisCostItem
    for i, v in pairs(costItems) do
        if v.index == costInfo.consumeIndex then
            v:UpdateData(v.index, self.costType, costInfo)
        end
    end
    self:RefreshSuccessRate()
end

---合成消耗打开面板
function this:LUA_EVENT_SYNTHESIS_COST_OPEN_PANEL(_, costType, consumeItemIndex, openPanelType)
    self.costType = costType
    local costInfos = self:GetCostsAndItemAndDataListByCostType(costType)
    ---@type NewNewSynthesisCostInfo
    local costInfo = costInfos[consumeItemIndex]
    if openPanelType == ESynthesisOpenPanelType.NumSelect then
        local maxCount = self:GetBagItemCount(costInfo.item.cfgId)
        -- 设置辅助消耗最大数量
        if costInfo.auxiliaryCostType ~= ESynthesisAuxiliaryCostType.extrit then
            maxCount = math.min(maxCount, 1)
        end
        GUI:UIPanel_Open("dev/outui/Synthesis/Panel/KLNewNewSynthesisNumSelect/KLNewNewSynthesisNumSelectPanel", nil, self,
                         { cfgId = costInfo.item.cfgId,
                           maxCount = maxCount,
                           consumeItemIndex = consumeItemIndex,
                           callback = self.SelectCostNum }, false)
        return
    elseif openPanelType == ESynthesisOpenPanelType.BindSelect then
        local maxCount = costInfo.needCount
        if costInfo.auxiliaryCostType == ESynthesisAuxiliaryCostType.extrit then
            -- 获取最大放置数量
            local singleSuccessRate
            local curSingleSuccessRate = 0
            local curSuccessRate = tonumber(self.formulaCfg.successRate)
            -- 计算出其他格子提供的成功率
            for i, v in pairs(self.auxiliaryCost) do
                if v.auxiliaryCostType == ESynthesisAuxiliaryCostType.extrit then
                    singleSuccessRate = 0
                    for _, k in pairs(self.formulaCfg.specialConsumeRate) do
                        if GUIUtil.ItemEquals(v.item.cfgId, k[1]) then
                            singleSuccessRate = k[2]
                            break
                        end
                    end
                    if i == consumeItemIndex then
                        curSingleSuccessRate = singleSuccessRate
                    else
                        curSuccessRate = curSuccessRate + (v.item.count + (v.bindCount or 0)) * singleSuccessRate
                    end
                end
            end
            local remainRate = tonumber(self.formulaCfg.successRateMax) - curSuccessRate
            maxCount = math.ceil(remainRate / curSingleSuccessRate)
        end
        GUI:UIPanel_Open("dev/outui/Synthesis/Panel/KLNewNewSynthesisBindCostSelect/KLNewNewSynthesisBindCostSelectPanel", nil, self,{
            cfgId = costInfo.item.cfgId,
            maxCount = maxCount,
            bindCount = costInfo.bindCount,
            unbindCount = costInfo.item.count,
            consumeItemIndex = consumeItemIndex,
            auxiliaryCostType = costInfo.auxiliaryCostType,
        }, false)
        return
    end
    
    local costs = {}
    local bagItemList = SL:GetMetaValue("BAG_DATA")[1]
    -- 搜集这类所有配方的消耗
    local cfgs = self.synthesisCfgDatas[self.selectTab]
    local tipsConsumeItem = {}
    if self.costType == 1 then -- 主要公式消耗
        ---@param v cfg_synthesis_column
        for i, v in pairs(cfgs) do
            for index, k in pairs(v.consumeItemMain) do
                self:GetCostA(costs, k, bagItemList, v.id, index)
            end
            if i == 1 then
                tipsConsumeItem = v.descriptiondefault
            end
        end
    else
        tipsConsumeItem = costInfo.consumeItem
        self:GetCostA(costs, costInfo.consumeItem, bagItemList, self.formulaCfg.id, consumeItemIndex)
    end
    
    GUI:UIPanel_Open("dev/outui/Synthesis/Panel/KLNewNewSynthesisCostSelect/KLNewNewSynthesisCostSelectPanel", nil, nil, 
                     { costType = costType, costs = costs, consumeItem = tipsConsumeItem, costItem = costInfo and costInfo.item or nil })
end

---消耗绑定数量改变
function this:LUA_EVENT_SYNTHESIS_BIND_COUNT_CHANGE(_, consumeItemIndex, changeType, cfgId, count)
    local _, items = self:GetCostsAndItemAndDataListByCostType(self.costType)
    ---@param v KLNewNewSynthesisCostItem
    for i, v in pairs(items) do
        if v.index == consumeItemIndex then
            if changeType == 1 then
                v:SetCount(cfgId, count)
            elseif changeType == 2 then
                v:ConfirmCount()
            else
                v:ResetCount()
            end
        end
    end
    self:RefreshSuccessRate()
end

---@param totalCost NewNewSynthesisCostInfo 总消耗
---@param consumeItem table 消耗公式
---@param bagItemList table 背包道具
---@param formulaId number 配方Id
---@param consumeIndex number 消耗公式索引
function this:GetCostA(totalCost, consumeItem, bagItemList, formulaId, consumeIndex)
    if consumeItem[1] == 1 then -- 固定道具消耗
        local cfg = SL:GetConfig("cfg_item", consumeItem[2])
        if cfg.type == E_ItemType.Equip then
            for i, v in pairs(bagItemList) do
                if GUIUtil.ItemEquals(v.cfgId, cfg.id) and not self:GetEquipIsUse(v.id, consumeIndex) then
                    table.insert(totalCost, {
                        formulaId = formulaId,
                        consumeIndex = consumeIndex,
                        item = v,
                        needCount = consumeItem[3],
                    })
                end
            end
        else
            -- 处理绑定道具
            local unbindCfgId, bindCfgId = SL:GetItemUnbindAndBindCfgId(consumeItem[2])
            if unbindCfgId > 0 then
                local unbindCount = self:GetBagItemCount(unbindCfgId, false)
                if unbindCount > 0 then
                    local costInfo = {
                        formulaId = formulaId,
                        consumeIndex = consumeIndex,
                        needCount = consumeItem[3],
                        item = {
                            cfgId = unbindCfgId,
                            count = math.min(unbindCount, consumeItem[3] or 0),
                        }
                    }
                    table.insert(totalCost, costInfo)
                end
            end
            if bindCfgId > 0 then
                local bindCount = self:GetBagItemCount(bindCfgId, false)
                if bindCount > 0 then
                    local costInfo = {
                        formulaId = formulaId,
                        consumeIndex = consumeIndex,
                        item = {
                            cfgId = bindCfgId,
                            count = 0,
                        },
                        bindCount = math.min(bindCount, consumeItem[3] or 0),
                    }
                    costInfo.needCount = consumeItem[3]
                    table.insert(totalCost, costInfo)
                end
            end
        end
    elseif consumeItem[1] == 2 then -- 大类消耗
        for i, v in pairs(bagItemList) do
            -- 检查强化等级
            if consumeItem[2] > 0 then
                if EquipFunc.GetEquipStrengthLevel(v) < consumeItem[2] then
                    goto continue
                elseif self.selectTab < 3 and EquipFunc.GetEquipStrengthLevel(v) == 15 then
                    goto continue
                end
            end
            -- 检查追加等级
            if consumeItem[3] > 0 then
                if EquipFunc.GetEquipAppendLevel(v) < consumeItem[3] then
                    goto continue
                end
            end
            local cfg = SL:GetConfig("cfg_item", v.cfgId)
            -- 检查品质需求
            if consumeItem[4] ~= 99 then -- 99 为不限
                local quality = cfg.Outstanding or 0
                if quality ~= consumeItem[4] then
                    goto continue
                end
            end
            -- 检查类别需求
            if consumeItem[5] ~= 0 then -- 0 为不限
                local mixtype = cfg.Mixtype or 0
                if consumeItem[5] == 5 then -- 首饰有好几种
                    if cfg.type ~= 2 and (cfg.subType ~= 10 or cfg.subType ~= 11 or cfg.subType ~= 12) then
                        goto continue
                    end
                else
                    if mixtype ~= consumeItem[5] then
                        goto continue
                    end
                end
            end
            -- 检查指定道具id
            if consumeItem[6] ~= 0 then
                if not GUIUtil.ItemEquals(v.cfgId, consumeItem[6]) then
                    goto continue
                end
            end

            if not self:GetEquipIsUse(v.id, consumeIndex) then
                table.insert(totalCost, { formulaId = formulaId, consumeIndex = consumeIndex, item = v, needCount = consumeItem[7] or 1 })
            end

            ::continue::
        end
    elseif consumeItem[1] == 3 then -- 多选1材料
        for i = 2, #consumeItem do
            -- 处理绑定道具
            local unbindCfgId, bindCfgId = SL:GetItemUnbindAndBindCfgId(consumeItem[i])
            if unbindCfgId > 0 then
                local unbindCount = self:GetBagItemCount(unbindCfgId, false)
                if unbindCount > 0 then
                    local costInfo = {
                        formulaId = formulaId,
                        consumeIndex = consumeIndex,
                        needCount = 1,
                        item = {
                            cfgId = unbindCfgId,
                            count = math.min(unbindCount, 1),
                        }
                    }
                    table.insert(totalCost, costInfo)
                end
            end
            if bindCfgId > 0 then
                local bindCount = self:GetBagItemCount(bindCfgId, false)
                if bindCount > 0 then
                    local costInfo = {
                        formulaId = formulaId,
                        consumeIndex = consumeIndex,
                        needCount = 1,
                        item = {
                            cfgId = bindCfgId,
                            count = 0,
                        },
                        bindCount = math.min(bindCount, 1),
                    }
                    table.insert(totalCost, costInfo)
                end
            end
        end
    end
end

---获取装备是否使用
function this:GetEquipIsUse(id, consumeIndex)
    for i = 1, 3 do
        local costInfos = self:GetCostsAndItemAndDataListByCostType(i)
        for k, v in pairs(costInfos) do
            if v.item and v.item.id == id and (self.costType ~= i or consumeIndex ~= k) then
                return true
            end
        end
    end
    
    return false
end

---消耗道具选择
---@param costInfo NewNewSynthesisCostInfo
function this:LUA_EVENT_SYNTHESIS_COST_ITEM_SELECT(_, costInfo)
    local cost, costItems = self:GetCostsAndItemAndDataListByCostType(self.costType)
    ---@param v KLNewNewSynthesisCostItem
    for i, v in pairs(costItems) do
        if v.index == costInfo.consumeIndex then
            if cost[v.index] then
                cost[v.index].item = SL:CopyData(costInfo.item)
                cost[v.index].bindCount = costInfo.bindCount
            else
                cost[v.index] = SL:CopyData(costInfo)
            end
            v:UpdateData(v.index, self.costType, cost[v.index])
            break
        end
    end
    if self.costType == 1 then
        if self.formulaCfg == nil or costInfo.formulaId ~= self.formulaCfg.id then
            self.formulaCfg = SL:GetConfig("cfg_synthesis", costInfo.formulaId)
            self:RefreshMinorCostItem()
            self:RefreshAuxiliaryCostItem()
        end
        self:RefreshSynthesisName()
    elseif self.costType == 3 then
        self:RefreshSynthesisName()
    end
    self:RefreshSuccessRate()
end

---背包更新
function this:LUA_EVENT_BAG_CHANGE_AFTER(_, massage)
    if self.formulaCfg == nil then
        return
    end
    self:RefreshMinorCostItem()
    self:RefreshAuxiliaryCostItem()
    self:RefreshSuccessRate()
end

return this
