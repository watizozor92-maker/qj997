---@class KLGemSynthesisPanel:UIKmlLuaPanelBase
---@field view KLGemSynthesisPanelView
---@field bagUI KLUIBagPanel 当前打开的背包界面实例
---@field targetItems table<number, { control: UIKmlLuaControl, bagItem: KLBagItemItem, itemInfo: {item:CommonProtos.Item, count: number} }> 目标位数据，key 是目标位索引（从1开始），value 包含目标位的UI控件、当前放在目标位的KLBagItemItem实例和item数据
---@field curSelectedTab number 当前选中的页签索引
---@field gemCfgTable table<number, synhtesis_yingshi_column> 荧石合成配置表数据
---@field rateBase number 成功率基数，配置表中的成功率需要除以这个数才是实际成功率
---@field targetItemCount number 目标位需要的物品数量
---@field resultInfo { bagItem: KLBagItemItem, itemInfo: {item:CommonProtos.Item, count: number} } 合成结果数据，包含结果物品的KLBagItemItem实例和item数据
---@field resultAttrId number 合成结果属性id
local KLGemSynthesisPanel = class(UIKmlLuaPanelBase)
local this =KLGemSynthesisPanel -- 萤石合成面板

---创建时调用一次
function this:Init()
    self.bagUI = nil
    self.targetItems = {}
    self.curSelectedTab = 1
    self.resultInfo = nil
    self.resultAttrId = nil
    self:InitCfg()
    self:InitDataList()
end

function this:InitCfg()
    self.targetSynthesisType = {1, 2, 3, 4, 5} -- 目标位合成类型，其他类型没有目标位
    self.targetConsumeType = {1, 2, 3, 4, 5}
    self.rateBase = 10000
    self.clickSynBtnDelay = 1 -- 点击合成按钮后的操作间隔，单位秒，防止重复点击
    self.canClickSynBtn = true
    self.targetItemCount = 1
    self.curMatchedFormula = nil -- 当前页签(类型)匹配到的具体配方（同类型多配方时由拖拽道具定位）
    self.synthesisFormulasByType = {} -- 按合成类型缓存全部配方（同类型多配方时用于匹配）
    self.inlayExtraHeight = 30 -- 镶嵌信息显示时增加的目标位区域高度
    self.inlayExpandHeight = 200 -- 镶嵌信息展开时增加的目标位区域高度
    self.inlayExpandPosOffset = 170 -- 镶嵌信息展开时目标位区域的Y轴偏移
    self.initTargetSizeW, self.initTargetSizeH = GUI:getSizeDelta(self.view.target)
    self.initTargetSizeW = math.floor(self.initTargetSizeW)
    self.initTargetSizeH = math.floor(self.initTargetSizeH)
    self.initTargetBgSizeW, self.initTargetBgSizeH = GUI:getSizeDelta(self.view.target_bg)
    self.initTargetBgSizeW = math.floor(self.initTargetBgSizeW)
    self.initTargetBgSizeH = math.floor(self.initTargetBgSizeH)
    self.initinlayInfoBtnPosY = GUI:getPositionY(self.view.btn_inlayInfo)
    ---@type table<number, synhtesis_yingshi_column>
    local synhtesis_yingshi_table = SL:GetConfigTable("synhtesis_yingshi")
    self.gemCfgTable = {}
    local meLevel = SL:GetMetaValue("LEVEL") -- 玩家等级
    for _, column in ipairs(synhtesis_yingshi_table) do
        -- 合成类型
        local synthesisType = column.synthesisType and column.synthesisType[1] or nil
        local checkType = false
        for _, t in ipairs(self.targetSynthesisType) do
            if synthesisType == t then
                checkType = true
                break
            end
        end
        -- 合成等级要求
        local needLevel = column.level or 1
        local checkLevel = meLevel >= needLevel

        -- 缓存每个合成类型下的全部配方
        if checkType and checkLevel and synthesisType then
            self.synthesisFormulasByType[synthesisType] = self.synthesisFormulasByType[synthesisType] or {}
            table.insert(self.synthesisFormulasByType[synthesisType], column)
        end
        -- 一个类型只显示一个页签
        local checkDuplicate = true
        for _, cfg in ipairs(self.gemCfgTable) do
            if cfg.synthesisType[1] == synthesisType then
                checkDuplicate = false
                break
            end
        end

        if checkType and checkLevel and checkDuplicate then
            table.insert(self.gemCfgTable, column)
        end
    end
    table.sort(self.gemCfgTable, function(a, b)
        return a.synthesisType[1] < b.synthesisType[1]
    end)

    -- 每个类型内部按id排序，保证匹配稳定
    for _, list in pairs(self.synthesisFormulasByType) do
        table.sort(list, function(a, b)
            return (a.id or 0) < (b.id or 0)
        end)
    end
end

function this:InitDataList()
    -- 页签数据列表
    GUI:DataListInitData(self.view.datalist_tab, function()
        return self:TabDataListItemCountFunc()
    end, function(realIndex)
        return
    end, function(realIndex, kmlCtrl)
        return
    end, function(realIndex, kmlCtrl)
        return self:TabDataListItemUpdateFunc(realIndex, kmlCtrl)
    end)

    -- 合成目标数据列表
    GUI:DataListInitData(self.view.datalist_target, function()
        return self:TargetDataListItemCountFunc()
    end, function(realIndex)
        return
    end, function(realIndex, kmlCtrl)
        return
    end, function(realIndex, kmlCtrl)
        return self:TargetDataListItemUpdateFunc(realIndex, kmlCtrl)
    end)

    -- 消耗数据列表
    GUI:DataListInitData(self.view.datalist_cost, function()
        return self:CostDataListItemCountFunc()
    end, function(realIndex)
        return
    end, function(realIndex, kmlCtrl)
        return
    end, function(realIndex, kmlCtrl)
        return self:CostDataListItemUpdateFunc(realIndex, kmlCtrl)
    end)

    -- 镶嵌信息数据列表
    GUI:DataListInitData(self.view.datalist_inlay, function()
        return self:InlayDataListItemCountFunc()
    end, function(realIndex)
        return
    end, function(realIndex, kmlCtrl)
        return
    end, function(realIndex, kmlCtrl)
        return self:InlayDataListItemUpdateFunc(realIndex, kmlCtrl)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ITEM_SYNTHESIS, self.RES_ITEM_SYNTHESIS, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_SYNTHESIS_PUT_BAG, self.RES_SYNTHESIS_PUT_BAG, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GEM_CURRENT_SCHEME, self.RES_GEM_CURRENT_SCHEME, self)
    SL:RegisterTrigger(LUA_EVENT_BAG_ITEM_COUNT_VIRTUAL_COST, self.LUA_EVENT_BAG_ITEM_COUNT_VIRTUAL_COST, self)
    SL:RegisterTrigger(LUA_TRIGGER_TRAD_GOODS_MESSAGE, self.LUA_TRIGGER_TRAD_GOODS_MESSAGE, self)
    SL:RegisterLUAEvent(Event.BagInfo_Change, self.BagInfo_Change, self)
    GUI:AddOnClickEvent(self.view.btn_synthesis, self, self.OnClickSynthesisBtn)
    GUI:AddOnClickEvent(self.view.btn_close, self, self.OnClickCloseBtn)
    GUI:AddOnClickEvent(self.view.btn_inlayInfo, self, self.OnClickInlayInfoBtn)
    GUI:AddOnClickEvent(self.view.inlayInfoPanel, self, self.HideInlayPanel)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:DataListUpdateData(self.view.datalist_tab)
    GUI:UIPanel_Open("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel", nil, nil, {
        closeCallBack = function()
            GUI:UIPanel_Close(self.filePath)
        end
    }, false, function(uipanel)
        self.bagUI = uipanel
    end)
end

function this:Hide()
end

function this:Close()
    self:PutResultItemToBag()
end

---合成放入背包回包
function this:RES_SYNTHESIS_PUT_BAG(_, msg)
    if not self.resultInfo then
        return
    end
    local itemId = self.resultInfo.itemInfo and self.resultInfo.itemInfo.item and self.resultInfo.itemInfo.item.id or nil
    if itemId then
        self:RefreshBagItemInBag(itemId)
    end
    self.resultInfo.itemInfo = nil
    -- 关闭结果KLBagItemItem显示
    if self.resultInfo and self.resultInfo.bagItem then
        GUI:UIPanel_Close(nil, self.resultInfo.bagItem)
        self.resultInfo.bagItem = nil
    end

    self.resultInfo = nil
end

function this:RES_GEM_CURRENT_SCHEME(_, msg)
    local itemId = msg.itemId
    local item = SL:GetItemInfoByItemId(itemId)
    self.resultInfo = self.resultInfo or {}
    self.resultInfo.itemInfo = { item = item, count = item.count or 1 } -- 合成结果的item数据
    -- 刷新结果显示
    self:RefreshResult(true)
    -- 清理主要材料(Target位)数据并刷新显示
    self:ClearAllTargets()
    -- 刷新次要材料显示
    self:RefreshCost()
    -- 刷新描述显示(货币和成功率)
    self:RefreshDesc()

    local isVisible = GUI:getVisible(self.view.inlayInfoPanel)
    if isVisible then
        GUI:DataListUpdateData(self.view.datalist_inlay)
    end
end

--- 合成回包
function this:RES_ITEM_SYNTHESIS(_, msg)
    if msg.result then
        local meId = tostring(SL:MeData_GetId())
        for _, v in pairs(msg.res) do
            self.resultAttrId = tonumber(v.attrId)
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_GOODS_INFO, { v.itemId, meId })
        end
    else
        SL:TipMessage("合成失败", 1.5, NoticeType.NoticeMid)
        if msg.itemIds then
            for _, v in pairs(msg.itemIds) do
                local item = { itemId = v }
                SL:onLUAEvent(LUA_EVENT_STRENGTH_OK, item)
            end
        end
        -- 刷新结果显示
        self:RefreshResult(true)
        -- 清理主要材料(Target位)数据并刷新显示
        self:ClearAllTargets()
        -- 刷新次要材料显示
        self:RefreshCost()
        -- 刷新描述显示(货币和成功率)
        self:RefreshDesc()
    end
end

---背包道具虚拟消耗
function this:LUA_EVENT_BAG_ITEM_COUNT_VIRTUAL_COST(itemId)
    if not self.view or not self.view.root or not itemId or not self.targetItems then
        return 0
    end
    local count = 0
    for _, info in pairs(self.targetItems) do
        if info and info.itemInfo and info.itemInfo.item and info.itemInfo.item.id == itemId then
            count = count + info.itemInfo.count
        end
    end
    local resultItem = self.resultInfo and self.resultInfo.itemInfo and self.resultInfo.itemInfo.item or nil
    if resultItem then -- 镶嵌物品不会扣除，移到结果还需要拖拽回去
        if resultItem.id == itemId then
            count = count + (self.resultInfo.itemInfo.count or 0)
        end
    end
    return count
end

function this:LUA_TRIGGER_TRAD_GOODS_MESSAGE(message)
    local item = message.items[1]
    self.resultInfo = self.resultInfo or {}
    self.resultInfo.itemInfo = { item = item, count = item.count or 1 } -- 合成结果的item数据
    self:SetItemExtData(item, self.resultAttrId) -- 设置合成结果的属性id
    self.resultAttrId = nil
    -- 刷新结果显示
    self:RefreshResult(true)
    -- 清理主要材料(Target位)数据并刷新显示
    self:ClearAllTargets()
    -- 刷新次要材料显示
    self:RefreshCost()
    -- 刷新描述显示(货币和成功率)
    self:RefreshDesc()
    return true
end

-- 多重保障，背包数据变化时刷新界面显示
function this:BagInfo_Change()
    -- 刷新次要材料显示
    self:RefreshCost()
    -- 刷新描述显示(货币和成功率)
    self:RefreshDesc()
end

-- 点击合成按钮
function this:OnClickSynthesisBtn()
    if not self.canClickSynBtn then
        SL:TipMessage("请勿频繁点击", 1, NoticeType.NoticeMid)
        return
    end
    self.canClickSynBtn = false
    SL:ScheduleOnce(self.clickSynBtnDelay, function()
        self.canClickSynBtn = true
    end)

    -- 判断合成结果是否已经进背包
    if self.resultInfo and self.resultInfo.itemInfo and self.resultInfo.itemInfo.item then
        SL:TipMessage("请先将合成结果放入背包", 1, NoticeType.NoticeMid)
        return
    end

    -- 判断主要材料是否足够
    if not self:IsMainTargetEnough() then
        SL:TipMessage("请放入所有合成材料", 1, NoticeType.NoticeMid)
        return
    end

    -- 消耗材料
    local cfgData = self:GetCurFormula()
    if not cfgData then
        return
    end
    -- 货币
    local costMoneyId = cfgData.coin and cfgData.coin[1]
    local costMoneyCount = cfgData.coin and cfgData.coin[2] or 0
    local haveMoney = SL:GetBagItemCount(costMoneyId)
    if haveMoney < costMoneyCount then
        SL:TipMessage("货币不足", 1, NoticeType.NoticeMid)
        return
    end
    -- 次要材料
    local consumeList = cfgData.consumeItem
    if table.count(consumeList) > 0 then
        for _, v in ipairs(consumeList) do
            local costType = v and v[1] or nil
            if costType == 1 then -- 固定道具
                local itemId = v[2]
                local itemCount = v[3] or 0
                local haveCount = SL:GetBagItemCount(itemId)
                if haveCount < itemCount then
                    SL:TipMessage("合成材料不足", 1, NoticeType.NoticeMid)
                    return
                end
            end
        end
    end

    if not self:CheckIsInlay() then -- 荧光宝石合成
        self:SendHeChengMsg()
    else
        self:SendXiangQianMsg() -- 镶嵌相关
    end
end

-- 合成消息
function this:SendHeChengMsg()
    --配方
    local formula = self:GetCurFormula()
    if formula == nil then
        SL:TipMessage("合成配方不满足", 1, NoticeType.NoticeMid)
        return
    end
    -- 主要材料
    local putItems = {}
    for _, targetInfo in pairs(self.targetItems) do
        if targetInfo and targetInfo.itemInfo and targetInfo.itemInfo.item then
            local item = targetInfo.itemInfo.item
            local count = targetInfo.itemInfo.count
            local index = SL:GetBagIndex(item.id)
            local putItem = {
                id = item.id,
                itemConfigId = item.cfgId,
                itemIndex = index, -- 背包物品索引, 10000+
                itemCount = count
            }
            table.insert(putItems, putItem)
        end
    end
    -- 次要材料
    local consumeItem = formula.consumeItem
    for _, v in ipairs(consumeItem) do
        local itemCfgId = v and v[2] or nil
        local needCount = v and v[3] or 0
        if itemCfgId then
            local item = self:GetBagItemInfoByCfgId(itemCfgId)
            if item then
                local index = SL:GetBagIndex(item.id)
                local extritItem = {
                    id = item.id,
                    itemConfigId = item.cfgId,
                    itemIndex = index,
                    itemCount = needCount
                }
                table.insert(putItems, extritItem)
            end
        end
    end
    -- 第一个target位item的唯一id
    local firstTargetItemId = self:GetTargetItemByIndex(1) and self:GetTargetItemByIndex(1).id or 0

    local data = {
        [1] = formula.id,
        [2] = putItems,
        [3] = firstTargetItemId
    }
    -- 发送合成请求
    ---检查合成是否有绑定道具
    for _, v in pairs(data) do
        if type(v) == "table" then
            for _, k in pairs(v) do
                if type(k) ~= "table" then
                    break
                end
                local item = SL:GetPosItemInfo("bag", k.itemConfigId, k.id)
                if not item then
                    break
                end
                if EquipFunc.GetItemIsBind(item.cfgId, item) then
                    SL:CommonTipsMessage({
                        stringTblID = 67001,
                        sureBtnText = "确定",
                        callback = function()
                            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SYNTHESIS_YING_SHI, data)
                        end,
                    })
                    return
                end
            end
        end
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SYNTHESIS_YING_SHI, data)
end

-- 镶嵌消息
function this:SendXiangQianMsg()
    local formula = self:GetCurFormula()
    local equipItem = self:GetTargetItemByIndex(1)  -- 默认第一个放装备
    if not formula or not formula.synthesisType or not equipItem then
        return
    end
    local synthesisType = formula.synthesisType[1]
    if synthesisType == self.targetSynthesisType[3] then -- 镶嵌
        local gemItem = self:GetTargetItemByIndex(2)  -- 默认第二个放宝石
        if not gemItem then
            return
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GEM_PUT_ON, { equipid = equipItem.id, itemid = gemItem.id })
    elseif synthesisType == self.targetSynthesisType[4] then -- 镶嵌提取
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GEM_TAKE_OFF, { itemid = equipItem.id })
    end
end

-- 检测是否是镶嵌相关的合成类型
function this:CheckIsInlay()
    local formula = self:GetCurFormula()
    if not formula then
        return false
    end
    local synthesisType = formula.synthesisType and formula.synthesisType[1] or nil
    return synthesisType == self.targetSynthesisType[3] or synthesisType == self.targetSynthesisType[4]
end

function this:OnClickCloseBtn()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    GUI:UIPanel_Close(self.filePath)
end

function this:OnClickInlayInfoBtn()
    local isVisible = GUI:getVisible(self.view.inlayInfoPanel)
    GUI:setVisible(self.view.inlayInfoPanel, not isVisible)
    local atlas = "Atlas/FG_Common.spriteatlas"
    local src = isVisible and "btn_down" or "btn_up"
    GUI:Image_loadTexture(self.view.btn_inlayInfo, src, atlas)

    -- 刷新镶嵌信息显示
    if not isVisible then
        GUI:DataListUpdateData(self.view.datalist_inlay)
        GUI:setContentSize(self.view.target, self.initTargetSizeW, self.initTargetSizeH + self.inlayExpandHeight)
        GUI:setContentSize(self.view.target_bg, self.initTargetBgSizeW, self.initTargetBgSizeH + self.inlayExpandHeight)
        GUI:setPositionY(self.view.btn_inlayInfo, self.initinlayInfoBtnPosY + self.inlayExpandPosOffset)
    else
        self:RefreshInlayInfo()
    end
end

-- 检测主要材料是否足够
function this:IsMainTargetEnough()
    if table.count(self.targetItems) == 0 then
        return false
    end

    -- 主要合成材料
    local hasItem = true
    for _, info in pairs(self.targetItems) do
        if not (info and info.itemInfo and info.itemInfo.item and info.itemInfo.count and info.itemInfo.count > 0) then
            hasItem = false
            break
        end
    end
    return hasItem
end

function this:TabDataListItemCountFunc()
    return #self.gemCfgTable
end

function this:TabDataListItemUpdateFunc(realIndex, kmlcontrol)
    local index = realIndex + 1
    local tabItem = GUI:GetChildControl(self.view.datalist_tab, realIndex, "tabItem")
    local tab_title = GUI:GetChildControl(self.view.datalist_tab, realIndex, "tab_title")
    local tab_content = GUI:GetChildControl(self.view.datalist_tab, realIndex, "tab_content")

    local data = self.gemCfgTable[index]

    GUI:SetToggleOnValueChange(tabItem, self, self.OnTabToggleValueChange, index)
    GUI:Text_setText(tab_title, data.synthesisname)
    GUI:Text_setText(tab_content, data.description)

    if realIndex == 0 then
        GUI:SetTogDefaultThis(tabItem)
    end
end

function this:OnTabToggleValueChange(control, index)
    local isOn = GUI:Toggle_getIsOn(control) == "1"
    GUI:Button_setBright(control, not isOn)
    if isOn then
        self.curSelectedTab = index
        self.curMatchedFormula = nil
        self:RefreshTarget()
        self:RefreshCost()
        self:RefreshDesc()
        self:RefreshResult()
        self:RefreshInlayInfo()
    end
end

function this:RefreshTarget()
    self:ClearAllTargets(true)
    local targetTitle = self:GetTargetTitle(self.curSelectedTab)
    GUI:Text_setText(self.view.txt_targetTitle, targetTitle)
    -- 刷新目标数据列表
    GUI:DataListUpdateData(self.view.datalist_target)
end

function this:GetTargetTitle(index)
    local data = self.gemCfgTable[index]
    if data.synthesisType[1] == self.targetSynthesisType[2] then
        return "放置卓越/套装物品"
    elseif data.synthesisType[1] == self.targetSynthesisType[3] then
        return "荧光宝石镶嵌"
    elseif data.synthesisType[1] == self.targetSynthesisType[4] then
        return "荧光宝石提取"
    else
        return data.synthesisname
    end
end

function this:RefreshCost()
    local costTitle = self:GetCostTitle(self.curSelectedTab)
    GUI:Text_setText(self.view.txt_costTitle, costTitle)
    -- 刷新消耗数据列表
    GUI:DataListUpdateData(self.view.datalist_cost)
end

function this:GetCostTitle(index)
    local data = self.gemCfgTable[index]
    if data.synthesisType[1] == self.targetSynthesisType[5] then
        return "附加材料"
    else
        return "宝石物品"
    end
end

function this:RefreshDesc()
    local data = self:GetCurFormula()
    if not data then
        return
    end
    -- 货币
    local costMoneyId = data.coin and data.coin[1]
    local costMoneyCount = data.coin and data.coin[2] or 0
    ---@type cfg_item_column
    local costCfgId = SL:GetConfig("cfg_item", costMoneyId)
    if not costCfgId then
        SL:LogError("cfg_item not found, id:" .. tostring(costMoneyId))
        return
    end
    local haveMoney = SL:GetBagItemCount(costMoneyId)
    -- local costMoneyStr = string.format("必要%s：%d(%d)", costCfgId.name, costMoneyCount, haveMoney)
    local costMoneyStr = string.format("必要金币：%d(%d)", costMoneyCount, haveMoney)
    GUI:Text_setText(self.view.txt_costMoney, costMoneyStr)
    -- 成功率
    local notShowRate = data.successOpen == 2
    GUI:setVisible(self.view.txt_successRate, not notShowRate)
    if not notShowRate then
        local successRate = tonumber(data.successRate) / self.rateBase
        local maxRate = tonumber(data.successRateMax) / self.rateBase
        successRate = math.max(0, math.min(successRate, maxRate))
        successRate = successRate * 100
        local successRateStr = string.format("合成成功率：%d%%", successRate)
        GUI:Text_setText(self.view.txt_successRate, successRateStr)
    end
end

-- 刷新合成结果显示
---@param addResultItem boolean|nil 是否合成完毕后增加一个结果物品显示
function this:RefreshResult(addResultItem)
    local isExtract = self:GetCurSynthesisType() == self.targetSynthesisType[2] -- 荧之石抽取才显示
    GUI:setVisible(self.view.result_tip, isExtract)

    -- 合成显示结果
    if addResultItem then
        local itemInfo = self.resultInfo and self.resultInfo.itemInfo
        if not itemInfo or not itemInfo.item then
            return
        end
        local bagItem = self.resultInfo and self.resultInfo.bagItem
        if bagItem then
            bagItem.args.item = itemInfo.item
            bagItem.args.count = itemInfo.count
            bagItem:Refresh()
        else
            local rect = GUI:GetRectTransform(self.view.result_show)
            local width = math.floor(rect and rect.rect.width or 64)
            local height = math.floor(rect and rect.rect.height or 64)

            local args = {
                type = "common",
                showTips = true,
                default = { width = width, height = height, mfixSizeX = width, mfixSizeY = height, strengthX = -2 },
                BagTileScrollViewId = EBagTileScrollViewId_Out.GemSynthesis,
                item = itemInfo.item,
                x = 0,
                y = 0,
                z = -100,
                canDrag = true,
                beginDrag = self.ResultBeginDrag,
                onDrag = self.ResultOnDrag,
                endDrag = self.ResultEndDrag,
                ins = self,
                callBackUI = self,
                click = self.OnClickResult,
            }

            GUI:UIPanel_Open("dev/ui/Common/Item/KLBagItem/KLBagItemItem", self.view.result_show, self, args, true, function(bItem)
                self.resultInfo.bagItem = bItem
            end)
        end
        return
    end

    -- 不是新增合成结果隐藏显示结果
    if self.resultInfo and self.resultInfo.itemInfo then
        self:PutResultItemToBag()
    end
end

function this:RefreshInlayInfo()
    self:HideInlayPanel() -- 切换页签时默认隐藏镶嵌信息面板
end

-- 将合成结果item放入背包并刷新显示
function this:PutResultItemToBag()
    local itemInfo = self.resultInfo and self.resultInfo.itemInfo
    if not itemInfo or not itemInfo.item then
        return
    end
    local item = itemInfo.item
    SL.OpenTips_item = nil -- 该值不为nil导致无法正确判断背包物品是否存在
    local isInBag = SL:GetPosItemInfo("bag", item.cfgId, item.id) ~= nil
    if isInBag then -- 镶嵌成功后只是刷新数据，本身还是在背包里
        local itemId = item.id
        self.resultInfo.itemInfo = nil
        if self.resultInfo and self.resultInfo.bagItem then
            GUI:UIPanel_Close(nil, self.resultInfo.bagItem)
            self.resultInfo.bagItem = nil
        end
        self.resultInfo = nil
        self:RefreshBagItemInBag(itemId)
        return
    end
    -- 发送消息请求放入背包
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SYNTHESIS_PUT_BAG, item.id)
end

-- 合成结果KLBagItemItem开始拖拽
function this:ResultBeginDrag()
end

-- 合成结果KLBagItemItem拖拽中
function this:ResultOnDrag()
end

-- 合成结果KLBagItemItem结束拖拽
function this:ResultEndDrag(eventData, systemData)
    local dragItem = eventData and eventData.dragItem
    if not dragItem or not systemData then
        return
    end

    local screenPos = systemData["position"]
    if not screenPos then
        return
    end

    if self:IsPointInBagArea(screenPos) then -- 拖回背包
        self:PutResultItemToBag()
        return
    end
end

function this:OnClickResult()
    local item = self.resultInfo and self.resultInfo.itemInfo and self.resultInfo.itemInfo.item or nil
    if item then
        local cfgId = item.cfgId or nil
        SL:OpenTips("gemSynthesisResult", cfgId, nil, nil, item)
    end
end

function this:TargetDataListItemCountFunc()
    local count = 2
    local data = self.gemCfgTable[self.curSelectedTab]
    if data.synthesisType[1] == self.targetSynthesisType[4] then -- 抽取荧光宝石只显示一个目标位
        count = 1
    end
    return count
end

function this:TargetDataListItemUpdateFunc(realIndex, kmlcontrol)
    local index = realIndex + 1
    local targetItem = GUI:GetChildControl(self.view.datalist_target, realIndex, "targetItem")
    local target_name = GUI:GetChildControl(self.view.datalist_target, realIndex, "target_name")
    local target_count = GUI:GetChildControl(self.view.datalist_target, realIndex, "target_count")

    self.targetItems[index] = { control = targetItem, bagItem = nil, itemInfo = {} }

    local targetName = self:GetTargetName(index)
    GUI:Text_setText(target_name, targetName)
    local numStr = string.format("0/%d", self.targetItemCount)
    numStr = SL:GetColorText(numStr, 0 >= self.targetItemCount and "#1ADD1F" or "#FF2323")
    GUI:Text_setText(target_count, numStr)
end

function this:GetTargetName(targetIndex)
    local targetInfo = self.targetItems[targetIndex]
    if not targetInfo then
        return ""
    end
    local data = self:GetCurFormula() or self.gemCfgTable[self.curSelectedTab]
    if not data or not data.synthesisType or not data.synthesisType[1] then
        return ""
    end
    local synthesisType = data.synthesisType[1]

    -- 同类型多配方且当前未匹配具体配方时，类型1目标名称固定显示
    if synthesisType == self.targetSynthesisType[1]
        and self:IsMultiFormulaType(synthesisType)
        and not self.curMatchedFormula then
        if targetIndex == 1 then
            return "光之石"
        elseif targetIndex == 2 then
            return "荧之石"
        end
        return ""
    end
    if synthesisType == self.targetSynthesisType[2] then
        local cosumeItemMain = data.consumeItemMain and data.consumeItemMain[targetIndex] or data.consumeItemMain[1]
        if table.count(cosumeItemMain) >= 2 then
            local strengthenLevel = cosumeItemMain[2] or 0
            if targetIndex == 1 then
                return string.format("至少+%d以上套装", strengthenLevel)
            elseif targetIndex == 2 then
                return string.format("至少+%d以上卓越", strengthenLevel)
            end
        end
    elseif synthesisType == self.targetSynthesisType[1] then
        local cosumeItemMain = data.consumeItemMain and data.consumeItemMain[targetIndex] or data.consumeItemMain[1]
        local itemCfgId = cosumeItemMain and cosumeItemMain[2] or nil
        local itemCfg = SL:GetConfig("cfg_item", itemCfgId)
        if itemCfg then
            return itemCfg.name
        end
    elseif synthesisType == self.targetSynthesisType[3] then
        if targetIndex == 1 then
            return "带有卡槽的镶嵌物品"
        elseif targetIndex == 2 then
            return "荧光宝石"
        end
    elseif synthesisType == self.targetSynthesisType[4] then
        if targetIndex == 1 then
            return "带有荧光宝石的镶嵌物品"
        end
    elseif synthesisType == self.targetSynthesisType[5] then
        if targetIndex == 1 then
            return "增强目标荧光宝石"
        elseif targetIndex == 2 then
            return "材料荧光宝石(合成后消失)"
        end
    end
    return ""
end

function this:RefreshTargetNames()
    for targetIndex, targetInfo in pairs(self.targetItems or {}) do
        local targetNameText = targetInfo and targetInfo.control and GUI:GetChildById(targetInfo.control, "target_name") or nil
        if targetNameText then
            GUI:Text_setText(targetNameText, self:GetTargetName(targetIndex))
        end
    end
end

-- 
function this:RefreshTargetCount(targetIndex)
    local targetInfo = self.targetItems[targetIndex]
    if not targetInfo then
        return
    end
    local count = targetInfo.itemInfo and targetInfo.itemInfo.count or 0
    local target_count_text = GUI:GetChildById(targetInfo.control, "target_count")
    if target_count_text then
        local numStr = string.format("%d/%d", count, self.targetItemCount)
        numStr = SL:GetColorText(numStr, count >= self.targetItemCount and "#00ff00" or "#FF2323")
        GUI:Text_setText(target_count_text, numStr)
    end
end

function this:ClearAllTargets(clearTargetControl)
    clearTargetControl = clearTargetControl or false
    for targetIndex, v in pairs(self.targetItems) do
        if v.bagItem then
            if v.itemInfo and v.itemInfo.item and v.itemInfo.item.id then
                self.targetItems[targetIndex].itemInfo.count = 0 -- 直接置0
                self:RefreshTargetCount(targetIndex)
                self:RefreshBagItemInBag(v.itemInfo.item.id)
            end
            GUI:UIPanel_Close(nil, v.bagItem)
        end
        self.targetItems[targetIndex].bagItem = nil
        self.targetItems[targetIndex].itemInfo = nil
    end
    if clearTargetControl then
        self.targetItems = {}
    end

    if self:IsMultiFormulaType(self:GetCurSynthesisType()) then
        self.curMatchedFormula = nil
        if not clearTargetControl then
            self:RefreshTargetNames()
        end
    end
end

--region Drag&Drop

-- 处理拖拽
function this:HandleBagDragEnd(eventData)
    if not eventData or not eventData.dragItem or not eventData.mousePosition then
        return false
    end

    local screenPos = eventData.mousePosition
    local targetIndex = self:GetDropTargetIndex(screenPos)
    if not targetIndex then
        return false
    end

    local item = eventData.dragItem.item
    if not item then
        return false
    end

    self:TryPutBagItemToTarget(item, targetIndex)
    return true
end

--- 根据屏幕坐标判断落在了哪个目标控件上，返回控件索引（从1开始），如果没有则返回 nil
---@param screenPos Vector2 屏幕坐标
function this:GetDropTargetIndex(screenPos)
    for slotIndex, info in pairs(self.targetItems) do
        if self:IsPointInControl(info.control, screenPos) then
            return slotIndex
        end
    end
    return nil
end

-- 判断屏幕坐标是否在指定控件区域内
---@param control UIKmlLuaControl 目标ui控件
---@param screenPos Vector2 屏幕坐标
function this:IsPointInControl(control, screenPos)
    if not control or not screenPos then
        return false
    end
    local rectTransform = GUI:GetRectTransform(control)
    if not rectTransform then
        return false
    end
    local width = rectTransform.rect.width
    local height = rectTransform.rect.height
    local ok, pos = GUI:ScreenPointToLocalPointInRectangle(control, screenPos)
    if not ok or not pos then
        return false
    end
    return pos.x >= (-width / 2) and pos.x <= width / 2 and pos.y <= (height / 2) and pos.y >= (-height / 2)
end

function this:TryPutBagItemToTarget(item, targetIndex, putCount)
    local noSpecifyTarget = targetIndex == nil or targetIndex <= 0
    -- 如果没有指定目标位，先找空的，否则找第一个目标位
    if noSpecifyTarget then
        for tIndex, tInfo in ipairs(self.targetItems) do
            if not tInfo.itemInfo or not tInfo.itemInfo.item then
                targetIndex = tIndex
                break
            end
        end
        targetIndex = targetIndex or 1
    end
    putCount = putCount or 1

    local isAllow = self:IsItemAllowedInTarget(item, targetIndex, putCount)
    if not isAllow then
        -- 如果没有指定目标位，且targetIndex=1不满足条件，则尝试其它空位
        if noSpecifyTarget and targetIndex == 1 then
            for tIndex, tInfo in ipairs(self.targetItems) do
                if tIndex ~= targetIndex then
                    local allow = self:IsItemAllowedInTarget(item, tIndex, putCount)
                    if allow then
                        targetIndex = tIndex
                        isAllow = true
                        break
                    end
                end
            end
        end
    end
    if not isAllow then
        SL:TipMessage("该道具不符合放入条件", 1, NoticeType.NoticeMid)
        return false
    end

    self:PutBagItemToTarget(item, targetIndex, putCount)
end

-- 放入校验
function this:IsItemAllowedInTarget(item, targetIndex, putCount)
    if item == nil or item.cfgId == nil then
        return false
    end

    local tabFormula = self.gemCfgTable[self.curSelectedTab]
    if not tabFormula then
        return false
    end
    local synthesisType = tabFormula.synthesisType and tabFormula.synthesisType[1] or nil

    -- 同类型多配方：尝试找到一个能同时满足“当前已放入的目标位 + 本次将要放入的目标位”的配方
    if self:IsMultiFormulaType(synthesisType) then
        local itemsByIndex = {}
        for idx, info in pairs(self.targetItems or {}) do
            local itemInfo = info and info.itemInfo or nil
            local it = itemInfo and itemInfo.item or nil
            if it and (itemInfo.count or 0) > 0 then
                itemsByIndex[idx] = it
            end
        end
        itemsByIndex[targetIndex] = item
        local matchFormula = self:FindFormulaByTargets(synthesisType, itemsByIndex)
        return matchFormula ~= nil
    end

    -- 其他类型：用当前页签唯一配方规则判断
    local consumeItemMain = tabFormula.consumeItemMain
    local targetRule = consumeItemMain and consumeItemMain[targetIndex]
    targetRule = targetRule or (consumeItemMain and consumeItemMain[1])
    if not targetRule then
        return true
    end
    return self:IsItemMatchConsumeRule(item, targetRule, targetIndex)
end

-- 将背包物品放入目标位并刷新UI显示
---@param item CommonProtos.Item 背包物品数据
---@param targetIndex number 目标位索引（从1开始）
---@param putCount number 放入数量
function this:PutBagItemToTarget(item, targetIndex, putCount)
    if item == nil then
        return
    end

    local targetInfo = self.targetItems[targetIndex]
    if not targetInfo then
        return
    end

    local itemInfo = targetInfo.itemInfo
    if not itemInfo then
        self.targetItems[targetIndex].itemInfo = { item = item, count = putCount }
    else
        if not itemInfo.item then
            self.targetItems[targetIndex].itemInfo.item = item
            self.targetItems[targetIndex].itemInfo.count = putCount
        else
            if itemInfo.item.id ~= item.id then -- 不同物品置换
                -- 在target位置入背包
                local prevItemId = itemInfo.item.id
                self.targetItems[targetIndex].itemInfo.item = item
                self.targetItems[targetIndex].itemInfo.count = putCount
                self:RefreshBagItemInBag(prevItemId)
            else -- 同物品叠加
                -- if item.cfgId then
                --     ---@type cfg_item_column
                --     local cfg_item = SL:GetConfig("cfg_item", item.cfgId)
                --     if cfg_item then
                --         local maxPut = cfg_item.overlying or 1
                --         maxPut = math.max(maxPut, 1)
                --         local currentCount = itemInfo.count or 0
                --         if currentCount + putCount <= maxPut then
                --             self.targetItems[targetIndex].itemInfo.count = currentCount + putCount
                --         end
                --     end
                -- end
            end
        end
    end
    self:RefreshBagItemInTarget(targetIndex)
    self:RefreshBagItemInBag(item.id)
    self:RefreshTargetCount(targetIndex)

    self:RefreshMatchedFormulaByTargets(item, targetIndex)
end

function this:RefreshBagItemInTarget(targetIndex)
    -- 目标槽位显示一个可拖拽的 KLBagItemItem
    local targetInfo = self.targetItems[targetIndex]
    if not targetInfo then
        return
    end

    local itemInfo = targetInfo.itemInfo
    local item = itemInfo and itemInfo.item
    if targetInfo.bagItem then
        if not item or (not itemInfo.count or itemInfo.count <= 0) then
            self:CloseBagItemByTargetIndex(targetIndex)
            return
        end
    end
    local rect = GUI:GetRectTransform(targetInfo.control)
    local width = math.floor(rect and rect.rect.width or 64)
    local height = math.floor(rect and rect.rect.height or 64)

    local args = {
        type = "common",
        showTips = true,
        default = { width = width, height = height, mfixSizeX = width, mfixSizeY = height, strengthX = -2 },
        BagTileScrollViewId = EBagTileScrollViewId_Out.GemSynthesis,
        item = item,
        x = 0,
        y = 0,
        z = -100,
        canDrag = true,
        beginDrag = self.TargetBeginDrag,
        onDrag = self.TargetOnDrag,
        endDrag = self.TargetEndDrag,
        ins = self,
        index = targetIndex * 100 + 1,
        callBackUI = self,
        click = self.OnClickBagItem,
    }

    local bagItem = targetInfo.bagItem
    if bagItem then
        bagItem.args = args
        bagItem.slotIndex = targetIndex
        bagItem:Refresh()
        return
    end

    GUI:UIPanel_Open("dev/ui/Common/Item/KLBagItem/KLBagItemItem", targetInfo.control, self, args, true, function(bagItem)
        bagItem.slotIndex = targetIndex
        self.targetItems[targetIndex].bagItem = bagItem
    end)
end

function this:CloseBagItemByTargetIndex(targetIndex)
    local targetInfo = self.targetItems[targetIndex]
    if targetInfo and targetInfo.bagItem then
        GUI:UIPanel_Close(nil, targetInfo.bagItem)
        self.targetItems[targetIndex].bagItem = nil
    end
end

function this:OnClickBagItem(_, item)
    SL:OpenTips("gemSynthesis", item.cfgId, item.id, nil, item)
end

function this:TargetBeginDrag()
end

function this:TargetOnDrag(eventData, systemData)
end

-- 判断屏幕坐标是否在背包区域内
function this:IsPointInBagArea(screenPos)
    if not self.bagUI or not self.bagUI.bagTileScrollView or not self.bagUI.bagTileScrollView.view then
        return false
    end
    local content = self.bagUI.bagTileScrollView.view.BagTileContent
    local ok, pos = GUI:ScreenPointToLocalPointInRectangle(content, screenPos)
    if not ok or not pos then
        return false
    end
    local rect = GUI:GetRectTransform(content)
    local width = rect.rect.width
    local height = rect.rect.height
    return pos.x >= 0 and pos.x <= width and pos.y <= 0 and pos.y >= -height
end

-- 从 target 槽位拖拽结束
function this:TargetEndDrag(eventData, systemData)
    local dragItem = eventData and eventData.dragItem
    if not dragItem or not systemData then
        return
    end
    local srcIndex = dragItem.slotIndex
    if not srcIndex then
        return
    end
    local screenPos = systemData["position"]
    if not screenPos then
        return
    end

    -- 目标槽位之间拖拽：置换/移动
    -- local dstTarget = self:GetDropTargetIndex(screenPos)
    -- if dstTarget and dstTarget ~= srcIndex then
    -- end

    if self:IsPointInBagArea(screenPos) then -- 拖回背包
        self:TryPutTargetItemToBag(dragItem.args.item, srcIndex)
        return
    end
end

-- 将目标位物品放回背包并刷新显示
---@param item CommonProtos.Item 目标位物品数据
---@param srcIndex number 源槽位索引
---@param putCount number 放回背包的数量(默认1)
function this:TryPutTargetItemToBag(item, srcIndex, putCount)
    if not item then
        return
    end

    if not srcIndex or srcIndex <= 0 then
        for index, tInfo in ipairs(self.targetItems) do
            if tInfo.bagItem and tInfo.itemInfo and tInfo.itemInfo.item and tInfo.itemInfo.item.id == item.id then
                srcIndex = index
                break
            end
        end
    end
    if not srcIndex then
        return
    end
    putCount = putCount or 1

    local curInfo = self.targetItems[srcIndex] and self.targetItems[srcIndex].itemInfo
    if not curInfo then
        return
    end
    local newCount = math.max((curInfo.count or 0) - putCount, 0)
    curInfo.count = newCount
    SL:ScheduleOnce(0.1, function() -- 延迟防止先关闭KLBagItemItem使界面数据清空然后再触发KLBagItemItem结束拖拽设置界面导致的报错
        self:RefreshBagItemInTarget(srcIndex)
    end)
    local itemId = curInfo and curInfo.item and curInfo.item.id
    self:RefreshBagItemInBag(itemId)
    if newCount <= 0 then
        self.targetItems[srcIndex].itemInfo = {}
    end
    self:RefreshTargetCount(srcIndex)

    local synthesisType = self:GetCurSynthesisType()
    if self:IsMultiFormulaType(synthesisType) then
        if not self:HasAnyTargetItem() then
            self.curMatchedFormula = nil
            self:RefreshTargetNames()
            self:RefreshCost()
            self:RefreshDesc()
            return
        end

        -- 类型1下：当第二个target位道具被拖回背包后，回退到未匹配状态并显示固定名称
        local target2Info = self.targetItems and self.targetItems[2] and self.targetItems[2].itemInfo or nil
        local target2HasItem = target2Info and target2Info.item and (target2Info.count or 0) > 0
        if synthesisType == self.targetSynthesisType[1] and srcIndex == 2 and not target2HasItem then
            self.curMatchedFormula = nil
            self:RefreshTargetNames()
            self:RefreshCost()
            self:RefreshDesc()
            return
        end

        self:RefreshMatchedFormulaByTargets()
    end
end

-- 从 target 位清空数据并恢复背包显示
---@param itemId number 物品id
function this:RefreshBagItemInBag(itemId)
    if not self.bagUI or not self.bagUI.bagTileScrollView then
        return
    end
    local bagItem = self.bagUI.bagTileScrollView:GetBagItem(itemId)
    if bagItem then
        bagItem:Refresh()
    end
end

--endregion

function this:CostDataListItemCountFunc()
    local data = self:GetCurFormula()
    if not data then
        return 0
    end
    local consumeItem = data.consumeItem or {}
    local costCount = #consumeItem
    return costCount
end

function this:CostDataListItemUpdateFunc(realIndex, kmlcontrol)
    local index = realIndex + 1
    local costItem = GUI:GetChildControl(self.view.datalist_cost, realIndex, "costItem")
    local cost_item = GUI:GetChildControl(self.view.datalist_cost, realIndex, "cost_item")
    local cost_name = GUI:GetChildControl(self.view.datalist_cost, realIndex, "cost_name")
    local cost_count = GUI:GetChildControl(self.view.datalist_cost, realIndex, "cost_count")

    local data = self:GetCurFormula()
    if not data then
        return
    end
    local consumeItem = data.consumeItem and data.consumeItem[index]
    local costType = consumeItem and consumeItem[1] -- 目前只处理了固定道具类型的消耗，后续如果有其他类型再补充
    local costItemId = consumeItem and consumeItem[2] -- itemId
    local costItemCount = consumeItem and consumeItem[3] or 0 -- 数量

    ---@type cfg_item_column
    local cfg_item = SL:GetConfig("cfg_item", costItemId)
    if cfg_item then
        GUI:Text_setText(cost_name, cfg_item.name)
        local haveCount = SL:GetBagItemCount(costItemId)
        local costStr = string.format("%d/%d", haveCount, costItemCount)
        costStr = SL:GetColorText(costStr, haveCount >= costItemCount and "#00ff00" or "#FF2323")
        GUI:Text_setText(cost_count, costStr)
        GUI:Item_setItemId(cost_item, costItemId)
        GUI:AddOnClickEvent(costItem, self, function()
            SL:OpenTips(nil, costItemId)
        end)
    end
end

function this:InlayDataListItemCountFunc()
    -- 默认第一位是装备
    local equipPos = 1
    local data = self.targetItems and self.targetItems[equipPos] and self.targetItems[equipPos].itemInfo
    if not data or not data.item then
        return 0
    end
    local equipItem = data.item
    local gemHoleNum = EquipFunc.GetEquipGemHoleNum(equipItem) or 0
    return gemHoleNum
end

function this:InlayDataListItemUpdateFunc(realIndex, kmlcontrol)
    local index = realIndex + 1
    local inlayItem = GUI:GetChildControl(self.view.datalist_inlay, realIndex, "inlay_item")
    local inlay_attr = GUI:GetChildControl(self.view.datalist_inlay, realIndex, "inlay_attr")

    local gemInlayData = self:GetGemInlayData() or {}
    local gemCount = table.count(gemInlayData)
    local str = ""
    if index <= gemCount then -- 有镶嵌
        str = self:GetGemAttrStr(gemInlayData[index], index)
        GUI:Text_setText(inlay_attr, str)
    else
        str = string.format("%d：没有可以镶嵌的物品", index)
    end
    GUI:Text_setText(inlay_attr, str)
end

function this:HideInlayPanel()
    GUI:setVisible(self.view.inlayInfoPanel, false)
    GUI:Image_loadTexture(self.view.btn_inlayInfo, "btn_down", "Atlas/FG_Common.spriteatlas")
    local isInlay = self:CheckIsInlay() -- 镶嵌相关的合成类型
    GUI:setVisible(self.view.btn_inlayInfo, isInlay)
    GUI:setContentSize(self.view.target, self.initTargetSizeW,
        self.initTargetSizeH + (isInlay and self.inlayExtraHeight or 0))
    GUI:setContentSize(self.view.target_bg, self.initTargetBgSizeW,
        self.initTargetBgSizeH + (isInlay and self.inlayExtraHeight or 0))
    GUI:setPositionY(self.view.btn_inlayInfo, self.initinlayInfoBtnPosY)
end

-- 获取当前页签的合成类型
function this:GetCurSynthesisType()
    local tabFormula = self.gemCfgTable[self.curSelectedTab]
    return tabFormula and tabFormula.synthesisType and tabFormula.synthesisType[1] or nil
end

-- 是否是同一合成类型有多条配方
function this:IsMultiFormulaType(synthesisType)
    if not synthesisType then
        return false
    end
    local list = self.synthesisFormulasByType and self.synthesisFormulasByType[synthesisType] or nil
    return list ~= nil and table.count(list) > 1
end

---获取当前真正生效的配方（同一合成类型有多条配方时，根据拖拽道具定位到具体配方）
---@return synhtesis_yingshi_column|nil
function this:GetCurFormula()
    local tabFormula = self.gemCfgTable[self.curSelectedTab]
    if not tabFormula then
        return nil
    end
    local synthesisType = tabFormula.synthesisType and tabFormula.synthesisType[1] or nil
    if self:IsMultiFormulaType(synthesisType) then
        return self.curMatchedFormula or tabFormula
    end
    return tabFormula
end

-- 是否有任何一个目标位放了道具
function this:HasAnyTargetItem()
    for _, info in pairs(self.targetItems or {}) do
        local itemInfo = info and info.itemInfo or nil
        if itemInfo and itemInfo.item and (itemInfo.count or 0) > 0 then
            return true
        end
    end
    return false
end

--- 同一合成类型有多条配方时，根据目标位索引获取对应的消耗规则
---@param formula synhtesis_yingshi_column
---@param targetIndex number 目标位索引，从1开始
function this:GetConsumeRuleByTarget(formula, targetIndex)
    if not formula then
        return nil
    end
    local consumeItemMain = formula.consumeItemMain
    if not consumeItemMain or table.count(consumeItemMain) == 0 then
        return nil
    end
    local rule = consumeItemMain[targetIndex]
    rule = rule or consumeItemMain[1]
    return rule
end

-- 判断道具是否满足目标位的消耗规则
function this:IsItemMatchConsumeRuleSet(item, ruleSet, targetIndex)
    if not ruleSet then
        return true
    end

    if type(ruleSet[1]) == "table" then
        for _, subRule in ipairs(ruleSet) do
            if self:IsItemMatchConsumeRule(item, subRule, targetIndex) then
                return true
            end
        end
        return false
    end
    return self:IsItemMatchConsumeRule(item, ruleSet, targetIndex)
end

-- 判断当前放在目标位的道具是否满足配方的消耗规则（同一合成类型有多条配方时，根据目标位索引获取对应规则进行判断）
---@param formula synhtesis_yingshi_column
---@param itemsByIndex table<number, CommonProtos.Item>
function this:DoesFormulaMatchTargets(formula, itemsByIndex)
    if not formula then
        return false
    end
    if not itemsByIndex then
        return true
    end
    for targetIndex, item in pairs(itemsByIndex) do
        if item then
            local rule = self:GetConsumeRuleByTarget(formula, targetIndex)
            if rule and not self:IsItemMatchConsumeRuleSet(item, rule, targetIndex) then
                return false
            end
        end
    end
    return true
end

--- 同一synthesisType下有多条配方时，根据当前目标位道具组合反查匹配到具体配方
---@param synthesisType number
---@param itemsByIndex table<number, CommonProtos.Item>
---@return synhtesis_yingshi_column|nil
function this:FindFormulaByTargets(synthesisType, itemsByIndex)
    if not synthesisType then
        return nil
    end
    local list = self.synthesisFormulasByType and self.synthesisFormulasByType[synthesisType] or nil
    if not list or table.count(list) == 0 then
        return nil
    end
    for _, formula in ipairs(list) do
        if self:DoesFormulaMatchTargets(formula, itemsByIndex) then
            return formula
        end
    end
    return nil
end

---根据合成材料规则判断道具是否满足
function this:IsItemMatchConsumeRule(item, consumeRule, targetIndex)
    if not item or not item.cfgId or not consumeRule or table.count(consumeRule) == 0 then
        return false
    end
    targetIndex = targetIndex or 1

    local consumeType = consumeRule[1]
    ---@type cfg_item_column
    local itemCfg = SL:GetConfig("cfg_item", item.cfgId)
    ---@type cfg_item_column
    local itemCfg2 = nil
    if not itemCfg then
        return false
    end
    if itemCfg.bindEqualItem > 0 then
        itemCfg2 = SL:GetConfig("cfg_item", itemCfg.bindEqualItem)
    end
    if consumeType == self.targetConsumeType[1] then -- 固定道具：合成类型#道具id#数量
        local needItemCfgId = table.count(consumeRule) >= 2 and consumeRule[2] or nil
        return item.cfgId == needItemCfgId or (itemCfg2 and itemCfg2.id == needItemCfgId)
    elseif consumeType == self.targetConsumeType[2] then -- 大类消耗
        local needStrengthenLevel = table.count(consumeRule) >= 2 and consumeRule[2] or 0
        local needAppendLevel = table.count(consumeRule) >= 3 and consumeRule[3] or 0
        local needOutstanding = table.count(consumeRule) >= 4 and consumeRule[4] or 99
        local needMixtype = table.count(consumeRule) >= 5 and consumeRule[5] or 0
        local strengthLevel = EquipFunc.GetEquipStrengthLevel(item) or 0
        local appendLevel = EquipFunc.GetEquipAppendLevel(item) or 0
        if strengthLevel < needStrengthenLevel or appendLevel < needAppendLevel then
            return false
        end
        if needOutstanding ~= 99 and itemCfg.Outstanding ~= needOutstanding then
            return false
        end
        if needMixtype ~= 0 and itemCfg.Mixtype ~= needMixtype then
            return false
        end
        return true
    elseif consumeType == self.targetConsumeType[3] then -- 卡槽数量装备|荧光宝石
        if targetIndex == 1 then -- 装备需要判断卡槽数量和萤石镶嵌槽位是否匹配
            local slotCount = EquipFunc.GetEquipGemHoleNum(item) or 0
            local haveSlot = slotCount >= 1
            local isMatchingPos = true
            -- 如果target2有萤石：根据实际道具校验装备部位与宝石wearbarPos是否匹配
            local target2Item = self.targetItems and self.targetItems[2] and self.targetItems[2].itemInfo and self.targetItems[2].itemInfo.item or nil
            if target2Item and target2Item.cfgId then
                ---@type cfg_item_column
                local cfg_item = SL:GetConfig("cfg_item", item.cfgId)
                ---@type cfg_equip_gem_column
                local cfg_equip_gem = SL:GetConfig("cfg_equip_gem", target2Item.cfgId)
                if cfg_item and cfg_equip_gem and cfg_item.strPart and cfg_equip_gem.wearbarPos then
                    local strPart = cfg_item.strPart
                    local wearbarPos = cfg_equip_gem.wearbarPos
                    for _, pos in ipairs(strPart) do
                        if not table.contains(wearbarPos, pos) then
                            isMatchingPos = false
                            break
                        end
                    end
                end
            end
            return haveSlot and isMatchingPos
        elseif targetIndex == 2 then -- 需要判断是否是荧光宝石，同时如果target1有装备要判断装备和萤石镶嵌槽位是否匹配
            local isGem = itemCfg.type == 5 and itemCfg.subType == 4
            if not isGem then
                return false
            end
            local isMatchingPos = true
            local target1Item = self.targetItems and self.targetItems[1] and self.targetItems[1].itemInfo and self.targetItems[1].itemInfo.item or nil
            if target1Item and target1Item.cfgId then
                ---@type cfg_item_column
                local cfg_item = SL:GetConfig("cfg_item", target1Item.cfgId)
                ---@type cfg_equip_gem_column
                local cfg_equip_gem = SL:GetConfig("cfg_equip_gem", item.cfgId)
                if cfg_item and cfg_equip_gem and cfg_item.strPart and cfg_equip_gem.wearbarPos then
                    local strPart = cfg_item.strPart
                    local wearbarPos = cfg_equip_gem.wearbarPos
                    for _, pos in ipairs(strPart) do
                        if not table.contains(wearbarPos, pos) then
                            isMatchingPos = false
                            break
                        end
                    end
                end
            end

            return isGem and isMatchingPos
        end
        return false
    elseif consumeType == self.targetConsumeType[4] then -- 镶嵌有荧光宝石的物品(要有镶嵌数据)
        local hasGemSlot = (EquipFunc.GetEquipGemHoleNum(item) or 0) > 0
        local gemInlayData = EquipFunc.GetEquipGemInlayData(item) or {}
        local hasGemData = table.count(gemInlayData) > 0
        return hasGemSlot and hasGemData
    elseif consumeType == self.targetConsumeType[5] then -- 荧光宝石|荧光宝石
        if not (itemCfg.type == 5 and itemCfg.subType == 4) then
            return false
        end
    end

    return false
end

---同类型多配方：根据当前目标位道具组合刷新当前配方，并刷新次要消耗/货币显示
function this:RefreshMatchedFormulaByTargets(fallbackItem, fallbackTargetIndex)
    local synthesisType = self:GetCurSynthesisType()
    if not self:IsMultiFormulaType(synthesisType) then
        return
    end

    -- 类型1时，拖拽道具成功放入target1后，不刷新target名称/消耗/描述
    if synthesisType == self.targetSynthesisType[1] and fallbackItem and fallbackTargetIndex == 1 then
        return
    end

    local itemsByIndex = {}
    for targetIndex, info in pairs(self.targetItems or {}) do
        local it = info and info.itemInfo and info.itemInfo.item or nil
        if it then
            itemsByIndex[targetIndex] = it
        end
    end
    if fallbackItem and fallbackTargetIndex then
        itemsByIndex[fallbackTargetIndex] = fallbackItem
    end

    -- 若当前一个道具都没有，则不强行匹配，回退使用页签默认配方
    if table.count(itemsByIndex) == 0 then
        return
    end

    local newFormula = self:FindFormulaByTargets(synthesisType, itemsByIndex)
    local oldId = self.curMatchedFormula and self.curMatchedFormula.id or nil
    local newId = newFormula and newFormula.id or nil
    self.curMatchedFormula = newFormula

    -- 配方发生变化刷新消耗和描述
    if oldId ~= newId then
        self:RefreshTargetNames()
        self:RefreshCost()
        self:RefreshDesc()
    end
end

function this:GetBagItemInfoByCfgId(cfgId)
    if not cfgId then
        return nil
    end
    local itemList = SL:GetMetaValue("BAG_DATA")[1]
    for _, item in pairs(itemList) do
        if item.cfgId == cfgId then
            return item
        end
    end
    return nil
end

-- 根据目标位索引获取当前放在目标位的物品数据
function this:GetTargetItemByIndex(index)
    return self.targetItems and self.targetItems[index] and self.targetItems[index].itemInfo and self.targetItems[index].itemInfo.item or nil
end

-- 获取目标装备的镶嵌信息数据
function this:GetGemInlayData()
    -- 默认第一位是装备
    local equipPos = 1
    local data = self.targetItems and self.targetItems[equipPos] and self.targetItems[equipPos].itemInfo
    if not data or not data.item then
        return nil
    end
    local equipItem = data.item
    local gemInlayData = EquipFunc.GetEquipGemInlayData(equipItem)
    return gemInlayData
end

function this:GetGemAttrStr(gemData, index)
    if not gemData then
        return ""
    end
    local gemId = gemData.cfgId
    ---@type cfg_equip_gem_column
    local cfg_equip_gem = SL:GetConfig("cfg_equip_gem", gemId)
    if not cfg_equip_gem then
        SL:LogError("cfg_equip_gem not found, id:" .. tostring(gemId))
        return ""
    end
    local gemBelong = cfg_equip_gem.gemBelong
    local belongStr = EElement[gemBelong[1]] or ""
    local gemAtt = gemData.attr or {}
    local attStr = ""
    if table.count(gemAtt) > 0 then
        for attrId, attrValue in pairs(gemAtt) do
            ---@type cfg_att_info_column
            local cfg_att_info = SL:GetConfig("cfg_att_info", attrId)
            if cfg_att_info then
                if attStr ~= "" then
                    attStr = attStr .. "，"
                end
                attStr = attStr .. (EquipFunc.GetAttText(attrId, attrValue) or "")
            else
                SL:LogError("cfg_att_info not found, id:" .. tostring(attrId))
            end
        end
    end

    local returnStr = string.format("%d：%s（%s）", index, belongStr, attStr)
    return returnStr
end

--- 将萤石属性添加到结果item的luaExtData中，供合成结果tips显示使用
---@param item CommonProtos.Item 合成结果item数据
---@param attrId number 萤石属性id
function this:SetItemExtData(item, attrId)
    if not item or not attrId or attrId <= 0 then
        return
    end
    local luaExtData = {}
    if item.luaExtData and item.luaExtData ~= "null" and item.luaExtData ~= "" then
        luaExtData = SL:JsonDecode(item.luaExtData)
    end
    if luaExtData.gemAttr ~= nil then return end
    if luaExtData.isInit == nil then
        luaExtData.isInit = true
    end

    ---@type cfg_equip_gem_column
    local cfg_equip_gem = SL:GetConfig("cfg_equip_gem", item.cfgId)
    if not cfg_equip_gem then
        SL:LogError("cfg_equip_gem not found, id:" .. tostring(item.cfgId))
        return
    end
    local gemAtt = cfg_equip_gem.gemAtt
    local attrValue = nil
    for _, att in ipairs(gemAtt) do
        local id = att[1]
        if id == attrId then
            attrValue = att[2]
            break
        end
    end
    if not attrValue then
        SL:LogError("attrId not found in gemAtt, attrId:" .. tostring(attrId) .. ", gemId:" .. tostring(item.cfgId))
        return
    end
    luaExtData.gemAttr = { [attrId] = attrValue }
    item.luaExtData = SL:JsonEncode(luaExtData)
end

return this
