---@class KLEquipAppendUIPanel:UIKmlLuaPanelBase
---@field view KLEquipAppendUIPanelView
---@field selectCostCfg cfg_equip_appendsCost_v2_column
--- kml代码lua化 会有较多冗余代码
local KLEquipAppendUIPanel = class(UIKmlLuaPanelBase)
local this = KLEquipAppendUIPanel
local canAppendMaxLevel = 9
---创建时调用一次
function this:Init()
    self:OpenEquipUIPanel()
    self.bagIndex = nil
    self.equipIndex = nil
    self.strengthAttTextList = {}
    self.costList = {}
    self.showLiuGuang = false
    GUI:DataListInitData(self.view.strength_list, function()
        return table.count(self.strengthAttTextList)
    end, function()

    end, function()

    end, function(realIndex)
        local strengthInfo = self.strengthAttTextList[realIndex + 1]
        local name = strengthInfo['attrName']
        local preValue = strengthInfo['preValue']
        local nextValue = strengthInfo['nextValue']
        local arrowShow = strengthInfo['arrowShow']

        local attControl = GUI:GetChildControl(self.view.strength_list, realIndex, 'attrName')
        local preControl = GUI:GetChildControl(self.view.strength_list, realIndex, 'preValue')
        local nextControl = GUI:GetChildControl(self.view.strength_list, realIndex, 'nextValue')
        local arrowControl = GUI:GetChildControl(self.view.strength_list, realIndex, 'arrow')

        local result = ""
        local len = utf8.len(name)  -- 获取字符串的 UTF-8 长度
        local i = 1
        local j = 1
        -- 使用 utf8.offset 来逐个字符提取
        while i <= len do
            local char = utf8.sub(name, i, i + 1)
            result = result .. char .. " "
            i = i + 1 -- 移动到下一个字符
        end
        GUI:Text_setString(attControl, result)
        GUI:Text_setString(preControl, tostring(preValue))
        GUI:Text_setString(nextControl, tostring(nextValue))
        GUI:setVisible(arrowControl, arrowShow)
    end)

    GUI:DataListInitData(self.view.cost_list, function()
        return table.count(self.costList)
    end, function()

    end, function()

    end, function(realIndex)
        local costInfo = self.costList[realIndex + 1]
        local cfgId = costInfo.costTag[1]
        local needCount = costInfo.costTag[2]

        local itemControl = GUI:GetChildControl(self.view.cost_list, realIndex, 'cost_item')
        local nameControl = GUI:GetChildControl(self.view.cost_list, realIndex, 'cost_name')
        local numControl = GUI:GetChildControl(self.view.cost_list, realIndex, 'cost_num')
        --local costAddBtn = GUI:GetChildControl(self.view.cost_list,realIndex,'costAddBtn')
        local costSelectTog = GUI:GetChildControl(self.view.cost_list, realIndex, 'costSelectTog')
        local bindItemTips = GUI:GetChildControl(self.view.cost_list, realIndex, 'bindItemTips')

        if not SL:HasConfig('cfg_item', cfgId) then
            return
        end
        GUI:Item_setItemId(itemControl, cfgId)

        local cfg = SL:GetConfig('cfg_item', cfgId)
        GUI:Text_setString(nameControl, cfg.name)
        GUI:setVisible(bindItemTips, cfg.lockItem[1] == 2)

        local haveCount = SL:GetBagItemCount(cfgId, false)
        if haveCount < needCount then
            GUI:Text_setString(numControl, string.format('<color="#FF2323">%d</color>/%d', haveCount, needCount))
        else
            GUI:Text_setString(numControl, string.format('<color="#00ff00">%d</color>/%d', haveCount, needCount))
        end

        GUI:SetToggleOnValueChange(costSelectTog, self, self.costSelectTog, { info = costInfo, showTips = true })
        --GUI:AddOnClickEvent(costAddBtn, self, self.costAddBtn, { cfgId = cfgId })
        if self.selectCostCfg.id == costInfo.id then
            --GUI:Toggle_setIsOn(costSelectTog, true)
            GUI:SetIsOnWithoutNotify(costSelectTog, true)
        end
        --GUI:setVisible(costAddBtn, haveCount < needCount)
        --GUI:setVisible(costSelectTog, haveCount >= needCount)
    end)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if not self.equipPanel then
        return
    end
    self.bagIndex = nil
    self.equipIndex = nil
    self:SelectEquip()
end

function this:costSelectTog(control, eventData, args, force)
    local isOn = args[1]
    if isOn then
        if force or self.selectCostCfg == nil or self.selectCostCfg.id ~= eventData.info.id then
            self.selectCostCfg = eventData.info
            -- 刷新成功等级，成功率，失败概率
            GUI:Text_setString(self.view.nextLevel, "+" .. self.appendLevel + self.selectCostCfg.successLevel)
            local rate = (self.selectCostCfg.rateClient // 100)
            rate = rate >= 100 and 100 or rate
            GUI:Text_setString(self.view.baseSuccessRatioText, "成功率+" .. rate .."%")-- .. SL:GetColorText(luckyRateStr,"#E27FE3"))
            GUI:Text_setString(self.view.failTips, self.selectCostCfg.tips)
            if self.selectCostCfg.rate/10000 >= 1 then
                GUI:setColor(self.view.failTips, "#1ADD1F")
            elseif self.appendLevel > self.selectCostCfg.failLevel  then
                GUI:setColor(self.view.failTips, "#FF2323")
            else
                GUI:setColor(self.view.failTips, "#1ADD1F")
            end
        else
            if eventData.showTips then
                SL:CommonItemGetPath(nil, self.selectCostCfg.costTag[1], nil, nil, nil, nil, nil, {clickControl = control})
            end
        end
    end
end

function this:costAddBtn(control, eventData)
    print(eventData)
    local cfgId = eventData.cfgId
    SL:CommonItemGetPath(nil, cfgId)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseButton, self, self.CloseButton)
    GUI:AddOnClickEvent(self.view.strengthButton, self, self.strengthButton)
    GUI:AddOnClickEvent(self.view.gotoButton, self, self.gotoButton)
    GUI:AddOnClickEvent(self.view.appendMasterBtn, self, self.AppendMasterBtn)
    --GUI:AddOnClickEvent(self.view.item_model, self, self.item_modelOnClick)
    GUI:AddOnClickEvent(self.view.Btn_Helper, self, self.OnClick_Btn_Helper)
    SL:RegisterLUAEvent(LUA_EVENT_EQUIP_GRID_CLICK, self.LUA_EVENT_EQUIP_GRID_CLICK, self)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.APPEND_EQUIP_RESULT, self.APPEND_EQUIP_RESULT, self)

    GUI:SetToggleOnValueChange(self.view.equipBtn, self, self.equipBtn)
    GUI:SetToggleOnValueChange(self.view.bagBtn, self, self.ClickBag)
    SL:RegisterLUAEvent(LUA_EVENT_FORGE_GROUP_PANEL_CLOSE, self.CloseButton, self)
end

function this:OpenEquipUIPanel()
    ---@param equipPanel KLEquipUIPanel
    GUI:UIPanel_Open("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel", nil, nil, { x = -480, hideTips = true, callBack = self.CloseEquipUi,
                                                                                forgeGroupType = EForgeGroupType.Add,hideMount = true }, nil, function(equipPanel)
        self.equipPanel = equipPanel
        self:Refresh()
    end)
end

function this:equipBtn()
    if not self.isOpenBag then
        return
    end
    self.isOpenBag = false
    --self.equipPanel = GUI:UIPanel_Open("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel",nil,nil, {x=-465, hideTips=true, callBack=self.CloseEquipUi,forgeGroupType=EForgeGroupType.Add})
    self:OpenEquipUIPanel()
    GUI:UIPanel_Close("dev/outui/Bag/Panel/KLStrengthBag/KLStrengthBagPanel")
    self.selectItem = nil
    --self:SelectEquip()
end

function this:item_modelOnClick()
    SL:OpenTips("equip", self.equipInfo.cfgId, self.equipInfo.id, nil, self.equipInfo, { hideBtn = true })
end

function this:OnClick_Btn_Helper()
    local ruleCfg = SL:GetConfig("cfg_rule_text", 1)
    if ruleCfg then
        SL:CommonStrTipsMessage({ title = ruleCfg.menutxt, str = ruleCfg.location })
    end
end

function this.CloseEquipUi()
    GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipAppendUI/KLEquipAppendUIPanel")
end

function this:closeMask()
    GUI:setVisible(self.view.equip_show_tips, false)
end

---@param message {issuccess:boolean, appendlv:number, itemId:number}
function this:APPEND_EQUIP_RESULT(id, message)

    GUI:SetActive(self.view.append_ok, false)
    GUI:SetActive(self.view.append_fail, false)
    if message.issuccess then
        GUI:SetActive(self.view.append_ok, true)
    else
        GUI:SetActive(self.view.append_fail, true)
    end
    SL:onLUAEvent(LUA_EVENT_APPEND_OK, message)

    self:ClickEquip(self.equipInfo)
    if self.equipPanel == nil then
        self.selectItem:SetSelect(true)
    end

    if self.delayUpdt then
        SL:UnSchedule(self.delayUpdt)
        self.delayUpdt = nil
    end
    self.delayUpdt = SL:ScheduleOnce(0.3, function()
        SL:RefreshPanelALLRedPoint("KLUIForgeGroupPanel")
        if self.equipPanel then
            self.equipPanel:UpdateAllItem()
            self.equipPanel:SetSelectIndex(self.equipIndex)
        end
    end)
end

function this:strengthButton()
    -- 检查道具够不够
    if not self.selectCostCfg then
        SL:TipMessage("请选择消耗道具", 1, NoticeType.NoticeMid)
        return
    end
    if SL:GetBagItemCount(self.selectCostCfg.costTag[1], false) < self.selectCostCfg.costTag[2] then
        SL:CommonItemGetPath(nil, self.selectCostCfg.costTag[1])
        return
    end
    if not EquipFunc.GetItemIsBind(nil, self.equipInfo) then
        -- 检查是否绑定道具
        local bindItem = SL:GetConfig("cfg_item", self.selectCostCfg.costTag[1]).lockItem[1] == 2
        if bindItem then
            SL:CommonTipsMessage({
                                     --cancelButtonPos = { x = -65, y = -74 },
                                     --sureButtonPos = { x = 65, y = -74 },
                                     showTips = SL:GetConfig("cfg_string", 40003).text,
                                     callback = function()
                                         self:ConfirmStrength()
                                     end
                                 })
            return
        end
    end
    
    self:ConfirmStrength()
    -- self:STRENGTH_EQUIP_RESULT(_, {isSuccess = true})
end

function this:ConfirmStrength()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_APPEND_EQUIP, { itemId = self.equipInfo.id, costCfgId = self.selectCostCfg.id })
end

-- 跳转
function this:gotoButton()
    SL:SendTransferToNpcMessage(100404, true)
end

function this:AppendMasterBtn()
    GUI:UIPanel_Open("dev/outui/Equip/Panel/KLUIForgingMaster/KLUIForgingMasterPanel", nil, nil, { uiType = 2, cfgId = self.equipInfo.cfgId })
end

function this:LUA_EVENT_BAG_CHANGE_AFTER(_, message)
    if not message then
        return
    end
    if self.equipInfo then
        local lv = EquipFunc.GetEquipAppendLevel(self.equipInfo)
        if lv < canAppendMaxLevel then
            local isMax = this.IsMaxEquip(self.equipInfo, lv)
            if not isMax then
                self:SetEquipCostInfo(self.equipInfo.cfgId, lv)
            end
        end
    end
    if self.isOpenBag then
        return
    end
    if self.delayUpdt then
        SL:UnSchedule(self.delayUpdt)
        self.delayUpdt = nil
    end
    self.delayUpdt = SL:ScheduleOnce(0.3, function()
        if self.equipPanel then
            self.equipPanel:UpdateAllItem()
        end
        SL:RefreshPanelALLRedPoint("KLUIForgeGroupPanel")
    end)
end

function this:LUA_EVENT_EQUIP_GRID_CLICK(_, index)
    local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, index)

    if index == E_AppearEquipType.Weapon and equip == nil then
        equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, E_AppearEquipType.TwoHandWeapon)
    end
    if equip then
        if SL:HasConfig('cfg_equip_appends', equip['cfgId']) then
            self.bagIndex = nil
            self.equipIndex = index
            self.equipPanel:SetSelectIndex(index)
            self:ClickEquip(equip)
            return
        else
            SL:TipMessage(SL:GetConfig('cfg_string', 259).text, 1, NoticeType.NoticeMid)--"该装备无法被追加",
        end
    end
end

function this:CloseButton()
    GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipAppendUI/KLEquipAppendUIPanel")
    GUI:UIPanel_Close("dev/outui/Bag/Panel/KLStrengthBag/KLStrengthBagPanel")
    self.selectItem = nil
end

function this:Close()
    if self.delayUpdt then
        SL:UnSchedule(self.delayUpdt)
        self.delayUpdt = nil
    end
end

function this:SelectEquip()
    if self.selectItem then
        if SL:HasConfig('cfg_equip_appends', self.selectItem.item.cfgId) then
            self.bagIndex = nil
            ---@type cfg_item_column
            local part = SL:GetConfig("cfg_item", self.selectItem.item.cfgId).subType
            self.equipIndex = part
            self.equipPanel:SetSelectIndex(part)
            self:ClickEquip(self.selectItem.item)
            return
        end
    end
    -- 策划要求先选中武器
    local equip_boot = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, EEquipSlotType.TwoHandWeapon)
    if equip_boot then
        if SL:HasConfig('cfg_equip_appends', equip_boot['cfgId']) then
            self.bagIndex = nil
            self.equipIndex = EEquipSlotType.TwoHandWeapon
            self.equipPanel:SetSelectIndex(EEquipSlotType.TwoHandWeapon)
            self:ClickEquip(equip_boot)
            return
        end
    end

    for index = 1, 15 do
        local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, index)
        if equip then
            if SL:HasConfig('cfg_equip_appends', equip['cfgId']) then
                self.bagIndex = nil
                self.equipIndex = index
                self.equipPanel:SetSelectIndex(index)
                self:ClickEquip(equip)
                return
            end
        end

    end
    GUI:setVisible(self.view.noticeText, true)
    GUI:setVisible(self.view.bagNoticeText, false)
end

function this:ResetUi()
    GUI:setVisible(self.view.maxLevelTips, false)
    GUI:setVisible(self.view.strengthIcon, false)
    GUI:setVisible(self.view.baseSuccessRatioText, false)
    GUI:setVisible(self.view.successIcon, false)
    GUI:setVisible(self.view.strengthIcon_1, false)
    GUI:setVisible(self.view.StrengthCustomScrollView, false)
    GUI:setVisible(self.view.strengthButton, false)
    GUI:setVisible(self.view.gotoButton, false)
    GUI:setVisible(self.view.strengthLevelBg, false)
    GUI:setVisible(self.view.maxStrengthLevelBg, false)
    GUI:setVisible(self.view.item_model, false)
    GUI:setVisible(self.view.equipName, false)
    GUI:setVisible(self.view.noticeText, false)
    GUI:setVisible(self.view.bagNoticeText, false)
    GUI:setVisible(self.view.liuguangInfo, false)
    GUI:setVisible(self.view.appendMasterBtn, false)
    GUI:setVisible(self.view.Text_StrengthTips, false)
    self.showLiuGuang = false
end

-- local testLevel = 0
function this:ClickEquip(equipInfo)
    local strength_tbl = SL:GetConfig('cfg_equip_appends', equipInfo.cfgId)
    if strength_tbl then
        self.equipInfo = equipInfo

        self:ResetUi()
        local strengthLevel = EquipFunc.GetEquipAppendLevel(self.equipInfo)
        self.appendLevel = strengthLevel
        self:SetEquipName(self.equipInfo.cfgId, strengthLevel)
        self:SetEquipModel(self.equipInfo.cfgId)
        self:SetLiuGuang(self.equipInfo)
        local isMax = this.IsMaxEquip(self.equipInfo, strengthLevel)
        GUI:setVisible(self.view.arrow, not isMax)
        GUI:setVisible(self.view.nextLevel, not isMax)
        if isMax then
            GUI:setVisible(self.view.maxLevelTips, true)
            GUI:Text_setString(self.view.maxLevel, "+" .. strengthLevel)
            --GUI:setVisible(self.view.maxStrengthLevelBg, true)
            self:SetMaxAttrInfo(self.equipInfo.cfgId, strengthLevel)
        else
            self:SetEquipAttrInfo(self.equipInfo.cfgId, strengthLevel)
            --self:SetEquipLevelInfo(strengthLevel)
            GUI:setVisible(self.view.strengthButton, strengthLevel < canAppendMaxLevel)
            GUI:setVisible(self.view.Text_StrengthTips, strengthLevel >= canAppendMaxLevel)
            GUI:setVisible(self.view.gotoButton, strengthLevel >= canAppendMaxLevel)
            if strengthLevel >= canAppendMaxLevel then
                GUI:setVisible(self.view.strengthIcon_1, false)
                GUI:setVisible(self.view.StrengthCustomScrollView, false)
                GUI:Text_setText(self.view.Text_StrengthTips, SL:GetConfig('cfg_string', 40002).text)
            else
                self:SetEquipCostInfo(self.equipInfo.cfgId, strengthLevel)
                self:RefreshSuccessRatio(self.equipInfo.cfgId, strengthLevel)
            end
            --self:SetEquipFailText(self.equipInfo.cfgId, strengthLevel)
        end

        -- testLevel = testLevel + 1
    end

    --[[---@type cfg_item_column
    local item = SL:GetConfig("cfg_item", equipInfo.cfgId)
    local masterId = tonumber(item.strPart[1] .. "02")
    ---@type cfg_equip_masterGroup_column
    local master = SL:GetConfig("cfg_equip_masterGroup", masterId)
    if master then
        GUI:setVisible(self.view.appendMasterBtn, true)
    else
        GUI:setVisible(self.view.appendMasterBtn, false)
    end]]
end

function this:SetLiuGuang(equipInfo)
    local liuGuangId = EquipFunc.GetEquipLiuGuangId(equipInfo)
    if liuGuangId then
        --GUI:SetStreamAttr(self.view.item_model, liuGuangId)
    else
        --GUI:ResetStreamAttr(self.view.item_model)
        --GUI:ResetStreamAttr(self.view.item_model)
        --GUI:ResetStreamAttr(self.view.item_model)
    end
end

function this:ClickBag()
    if self.isOpenBag then
        return
    end
    self.equipPanel = nil
    self.isOpenBag = true
    self.selectItem = nil
    self:ResetUi()
    -- 清掉属性
    self.strengthAttTextList = {}
    GUI:setVisible(self.view.bagNoticeText, true)
    GUI:DataListUpdateData(self.view.strength_list)
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    GUI:UIPanel_Open("dev/outui/Bag/Panel/KLStrengthBag/KLStrengthBagPanel", nil, nil, { x = -480, itemClickCallBack = self.itemClickCallBack, callBackUI = self })
end

function this:itemClickCallBack(control, item)
    if SL:HasConfig('cfg_equip_appends', item.cfgId) then
        local itemInfo = SL:GetItemInfoByItemId(item.id)
        self:ClickEquip(itemInfo)
        self:HideSelectItem(false)
        control.ui:SetSelect(true)
        self.selectItem = control.ui
    else
        SL:TipMessage(SL:GetConfig('cfg_string', 259).text, 1, NoticeType.NoticeMid)--"该装备无法被追加",
    end
end

function this:HideSelectItem()
    if self.selectItem then
        self.selectItem:SetSelect(false)
    end
end

function this:SetMaxAttrInfo(cfgId, strengthLevel)
    self.strengthAttTextList = {
        {
            attrName = "追加等级",
            preValue = tostring(strengthLevel),
            nextValue = "",
            arrowShow = false
        }
    }
    --GUI:setVisible(self.view.strengthIcon, true)
    local now_attr_map = {}
    ---@type cfg_equip_appends_column
    local cfg = SL:GetConfig('cfg_equip_appends', cfgId)
    for i, v in pairs(cfg.groupId) do
        local groupId = v
        if SL:HasConfigTwoKeys('cfg_equip_appendsGroup', groupId, strengthLevel, 'group', 'lv') then
            local nowAttrInfo = SL:GetConfigTwoKeys('cfg_equip_appendsGroup', groupId, strengthLevel, 'group', 'lv').att
            for _, nowAttr in pairs(nowAttrInfo) do
                now_attr_map[nowAttr[1]] = nowAttr[2]
            end
        end
    end
    local specicalNowAtkAttr = EquipFunc.GetAtkAttrText(EquipFunc.DataChange(now_attr_map))
    for i, nowData in ipairs(specicalNowAtkAttr) do
        local tbl= {
            attrName = nowData.text,
            preValue = nowData.min_atk,
            nextValue = "",
            arrowShow = false
        }
        table.insert(self.strengthAttTextList, tbl)
    end

    --[[local minAtk = now_attr_map[201021]
    local maxAtk = now_attr_map[201011]
    if minAtk and maxAtk then

        local tbl = {
            attrName = "攻击力",
            preValue = minAtk .. '~' .. maxAtk,
            nextValue = "",
            arrowShow = false
        }
        table.insert(self.strengthAttTextList, tbl)
    end

    local minMAtk = now_attr_map[202021]
    local maxMAtk = now_attr_map[202011]
    if minMAtk and maxMAtk then
        local tbl = {
            --attrName = "魔法攻击力",
            attrName = "攻击力",
            preValue = minMAtk .. '~' .. maxMAtk,
            nextValue = "",
            arrowShow = false
        }
        table.insert(self.strengthAttTextList, tbl)
    end

    minAtk = now_attr_map[200011]
    maxAtk = now_attr_map[200021]
    if minAtk and maxAtk then
        local tbl = {
            attrName = "攻击力",
            preValue = minAtk .. '~' .. maxAtk,
            nextValue = "",
            arrowShow = false
        }
        table.insert(self.strengthAttTextList, tbl)
    end]]

    for attrId, attrValue in pairs(now_attr_map) do
        if not table.contains(EAtkAttrType, attrId) then
            local name = SL:GetConfig("cfg_att_info", attrId).name
            local att_remark = SL:GetConfig("cfg_att_info", attrId).remarks
            local tbl = {}
            if att_remark == 1 then
                tbl = {
                    attrName = name,
                    preValue = attrValue,
                    nextValue = "",
                    arrowShow = false
                }
            else
                tbl = {
                    attrName = name,
                    preValue = string.format("%g", attrValue / 100) .. '%',
                    nextValue = "",
                    arrowShow = false
                }
            end
            table.insert(self.strengthAttTextList, tbl)
        end

    end

    GUI:DataListUpdateData(self.view.strength_list)
end

function this:SetEquipFailText(cfgId, strengthLevel)
    local costId = SL:GetConfig('cfg_equip_appends', cfgId).costId
    local fail_tips = SL:GetConfigTwoKeys('cfg_equip_appendsCost', costId, strengthLevel + 1, 'costGroupId', 'level').tips
    if fail_tips then
        GUI:setVisible(self.view.failTips, true)
        GUI:Text_setString(self.view.failTips, fail_tips)
        if self.selectCostCfg.rate/10000 >= 1 then
            GUI:setColor(self.view.failTips, "#1ADD1F")
        elseif self.appendLevel > self.selectCostCfg.failLevel  then
            GUI:setColor(self.view.failTips, "#FF2323")
        else
            GUI:setColor(self.view.failTips, "#1ADD1F")
        end
    end
end

function this:SetEquipCostInfo(cfgId, strengthLevel)
    self.costList = {}
    --GUI:setVisible(self.view.strengthIcon_1, true)
    GUI:setVisible(self.view.StrengthCustomScrollView, true)
    local costId = SL:GetConfig('cfg_equip_appends', cfgId).costId
    local next_level = strengthLevel + 1
    local cost_info = SL:GetConfigTwoKeys('cfg_equip_appendsCost', costId, next_level, "costGroupId", "level").appendCost
    
    for _, v in pairs(cost_info) do
        ---@type cfg_equip_appendsCost_v2_column
        local cost2Cfg = SL:GetConfig("cfg_equip_appendsCost_v2", v)
        table.insert(self.costList, cost2Cfg)
    end
    -- 消耗信息是否已经改变
    if self:IsCostInfoChanged(cost_info) then
        -- 检查当前选择是否仍然有效
        local isValid, matchingCfg = self:IsCurrentCostCfgValid(self.costList)
        local bast = self:FindBestAvailableCostCfg(self.costList)
        -- 有效并且成功率仍然最高
        self.selectCostCfg = (isValid and matchingCfg.rateClient >= bast.rateClient) and matchingCfg or bast
    end
    if self.selectCostCfg == nil then
        self.selectCostCfg = self.costList[1]
    end
    self.lastCost_Info = cost_info

    self:costSelectTog(nil, { info = self.selectCostCfg }, { true }, true)

    GUI:DataListUpdateData(self.view.cost_list)
end

-- 将寻找最佳成本配置的逻辑提取为独立函数
function this:FindBestAvailableCostCfg(cost_info)
    local bestCfg = nil
    for _, v in pairs(cost_info) do
        if SL:GetBagItemCount(v.costTag[1], false) >= v.costTag[2] and
         (bestCfg == nil or v.rateClient > bestCfg.rateClient) then
            bestCfg = v
        end
    end
    return bestCfg
end

-- 检查当前选择的成本配置是否仍然有效
function this:IsCurrentCostCfgValid(cost_info)
    if self.selectCostCfg then
        for _, v in pairs(cost_info) do
            if self.selectCostCfg.costTag[1] == v.costTag[1] then
                return true, v
            end
        end
    end
    return false, nil
end

-- 检查成本配置是否有变化
function this:IsCostInfoChanged(new_cost_info)
    if self.lastCost_Info == nil then
        return true
    end
    if table.count(self.lastCost_Info) ~= table.count(new_cost_info) then
        return true
    end

    for i, v in pairs(self.lastCost_Info) do
        if v ~= new_cost_info[i] then
            return true
        end
    end
    return false
end

function this:SetEquipAttrInfo(cfgId, strengthLevel)

    self.strengthAttTextList = {
        {
            attrName = "追加等级",
            preValue = tostring(strengthLevel),
            nextValue = tostring(strengthLevel + 1),
            arrowShow = true
        }
    }
    --GUI:setVisible(self.view.strengthIcon, true)
    local now_attr_map = {}
    local next_attr_map = {}
    ---@type cfg_equip_appends_column
    local cfg = SL:GetConfig('cfg_equip_appends', cfgId)
    for i, v in pairs(cfg.groupId) do
        local groupId = v
        if SL:HasConfigTwoKeys('cfg_equip_appendsGroup', groupId, strengthLevel, 'group', 'lv') then
            local nowAttrInfo = SL:GetConfigTwoKeys('cfg_equip_appendsGroup', groupId, strengthLevel, 'group', 'lv').att
            for _, nowAttr in pairs(nowAttrInfo) do
                now_attr_map[nowAttr[1]] = nowAttr[2]
            end
        end
        if SL:HasConfigTwoKeys('cfg_equip_appendsGroup', groupId, strengthLevel + 1, 'group', 'lv') then
            local nextAttrInfo = SL:GetConfigTwoKeys('cfg_equip_appendsGroup', groupId, strengthLevel + 1, 'group', 'lv').att
            for _, nextAttr in pairs(nextAttrInfo) do
                next_attr_map[nextAttr[1]] = tonumber(nextAttr[2])
            end
        end
    end

    for nextId, _ in pairs(next_attr_map) do
        if now_attr_map[nextId] == nil then
            now_attr_map[nextId] = 0
        end
    end
    
    local specicalNowAtkAttr = EquipFunc.GetAtkAttrText(EquipFunc.DataChange(now_attr_map))
    local specicalNextAtkAttr = EquipFunc.GetAtkAttrText(EquipFunc.DataChange(next_attr_map))
    for i, nowData in ipairs(specicalNowAtkAttr) do
        local nextData = specicalNextAtkAttr[i]
        local tbl= {
            attrName = nowData.text,
            preValue = nowData.min_atk,
            nextValue = nextData.min_atk,
            arrowShow = true
        }
        table.insert(self.strengthAttTextList, tbl)
    end
    for attrId, attrValue in pairs(now_attr_map) do
        if not table.contains(EAtkAttrType, attrId)  then
            local nextValue = next_attr_map[attrId]
            local name = SL:GetConfig("cfg_att_info", attrId).name
            local att_remark = SL:GetConfig("cfg_att_info", attrId).remarks
            local tbl = {}
            if att_remark == 1 then
                tbl = {
                    attrName = name,
                    preValue = attrValue,
                    nextValue = nextValue,
                    arrowShow = true
                }
            else
                tbl = {
                    attrName = name,
                    preValue = string.format("%g", attrValue / 100) .. '%',
                    nextValue = string.format("%g", nextValue / 100) .. '%',
                    arrowShow = true
                }
            end
            table.insert(self.strengthAttTextList, tbl)
        end

    end

    --[[local tips = SL:GetConfigTwoKeys('cfg_equip_appendsGroup', groupId, strengthLevel + 1, 'group', 'lv').tips
    if not string.isNullOrEmpty(tips) then
        local tbl = {
            attrName = tips,
            preValue = '',
            nextValue = '',
            arrowShow = false
        }
        table.insert(self.strengthAttTextList, tbl)
    end]]

    GUI:DataListUpdateData(self.view.strength_list)
end

function this:SetEquipLevelInfo(strengthLevel)
    GUI:setVisible(self.view.strengthLevelBg, true)
    GUI:Text_setString(self.view.preLevel, "+" .. strengthLevel)
    GUI:Text_setString(self.view.nextLevel, "+" .. strengthLevel + 1)
end

function this:RefreshSuccessRatio(cfgId, strengthLevel)
    GUI:setVisible(self.view.baseSuccessRatioText, true)
    --GUI:setVisible(self.view.successIcon, true)
    if strengthLevel >= canAppendMaxLevel then
        local costId = SL:GetConfig('cfg_equip_appends', cfgId).costId
        local next_level = strengthLevel + 1
        local rate_client = SL:GetConfigTwoKeys('cfg_equip_appendsCost', costId, next_level, "costGroupId", "level").rateClient
        rate_client = rate_client // 100
        rate_client = rate_client >= 100 and 100 or rate_client
        GUI:Text_setString(self.view.baseSuccessRatioText, "成功率+"..rate_client .. '%')-- .. SL:GetColorText(luckyRateStr,"#E27FE3"))
    end
end

function this:SetEquipName(cfgId, strengthLevel)

    GUI:setVisible(self.view.equipName, true)
    local equipName = SL:GetConfig('cfg_item', cfgId).name
    local colorStr = EquipFunc.GetEquipNameColor(cfgId)
    if strengthLevel > 0 then
        equipName = equipName .. '+' .. strengthLevel
    end
    GUI:Text_setString(self.view.equipName, string.format("<color=%s>%s</color>", colorStr, equipName))
end

function this:SetEquipModel(cfgId)
    --GUI:setVisible(self.view.item_model, true)
    -- GUI:Item_UpdataData(self.view.item_model, {
    --     itemid = cfgId,
    --     mscale = EquipFunc.GetEquipInScaleAtt(cfgId, nil, EquipFunc.ItemForgeShowEquipScale(cfgId)),
    -- })
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
    --GUI:Item_UpdataData(self.view.item_model, data)
end

function this.IsMaxEquip(equipInfo, strength_level)

    local cfgId = equipInfo.cfgId
    --local strength_level = equipInfo["strengthlevel"]
    ---首饰换表处理
    local ornament_tbl = SL:HasConfig('cfg_equip_ornamentsMain', cfgId)
    if ornament_tbl then
        if InfoManager.equipJewelryInfo:GetCurLevelMaxAppend(equipInfo) <= strength_level then
            return true
        end
        return false
    end
    local strength_tbl = SL:GetConfig('cfg_equip_appends', cfgId)
    if strength_tbl then
        if strength_tbl.maxLevel <= strength_level then
            return true
        end

        return false

    end
    return false
end

return this
