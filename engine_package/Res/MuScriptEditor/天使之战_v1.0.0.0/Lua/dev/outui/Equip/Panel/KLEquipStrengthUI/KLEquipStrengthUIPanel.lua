---@class KLEquipStrengthUIPanel:UIKmlLuaPanelBase
---@field view KLEquipStrengthUIPanelView
---@field selectCostCfg cfg_equip_strengthenCost_column
--- kml代码lua化 会有较多冗余代码
local KLEquipStrengthUIPanel = class(UIKmlLuaPanelBase)
local this =KLEquipStrengthUIPanel
local canStrengthMaxLevel = 9
local SoulGemId = 50030003
---创建时调用一次
function this:Init()
    self:OpenEquipUIPanel()
    -- GUI:SetZIndex(self.view.effect_tishi,210)
    self.bagIndex = nil
    self.equipIndex = nil
    self.strengthAttTextList = {}
    self.costList = {}
    self.showLiuGuang = false
    GUI:setVisible(self.view.equip_show_tips, false)
    GUI:DataListInitData(self.view.strength_list, function()
        return table.count(self.strengthAttTextList)
    end,function()

    end,function()

    end,function(realIndex)
        local strengthInfo = self.strengthAttTextList[realIndex+1]
        local name = strengthInfo['attrName']
        local preValue = strengthInfo['preValue']
        local nextValue = strengthInfo['nextValue']
        local arrowShow = strengthInfo['arrowShow']

        local attControl = GUI:GetChildControl(self.view.strength_list,realIndex,'attrName')
        local preControl = GUI:GetChildControl(self.view.strength_list,realIndex,'preValue')
        local nextControl = GUI:GetChildControl(self.view.strength_list,realIndex,'nextValue')
        local arrowControl = GUI:GetChildControl(self.view.strength_list,realIndex,'arrow')


        local result = ""
        local len = utf8.len(name)  -- 获取字符串的 UTF-8 长度
        local i = 1
        local j = 1
        -- 使用 utf8.offset 来逐个字符提取
        while i <= len do
            local char = utf8.sub(name, i, i+1)
            result = result .. char .. " "
            i = i+1 -- 移动到下一个字符
        end
        GUI:Text_setString(attControl, result)
        GUI:Text_setString(preControl, tostring(preValue))
        GUI:Text_setString(nextControl, tostring(nextValue))
        GUI:setVisible(arrowControl, arrowShow)
    end)

    GUI:DataListInitData(self.view.cost_list, function()
        return table.count(self.costList)
    end,function()

    end,function()

    end,function(realIndex)
        local costInfo = self.costList[realIndex+1]
        local cfgId = costInfo.costTag[1]
        local needCount = costInfo.costTag[2]

        local itemControl = GUI:GetChildControl(self.view.cost_list,realIndex,'cost_item')
        local nameControl = GUI:GetChildControl(self.view.cost_list,realIndex,'cost_name')
        local numControl = GUI:GetChildControl(self.view.cost_list,realIndex,'cost_num')
        --local costAddBtn = GUI:GetChildControl(self.view.cost_list,realIndex,'costAddBtn')
        local costSelectTog = GUI:GetChildControl(self.view.cost_list,realIndex,'costSelectTog')
        local bindItemTips = GUI:GetChildControl(self.view.cost_list,realIndex,'bindItemTips')

        if not SL:HasConfig('cfg_item', cfgId) then
            return
        end
        GUI:Item_setItemId(itemControl, cfgId)
        
        local cfg = SL:GetConfig('cfg_item', cfgId)
        GUI:Text_setString(nameControl, cfg.name)
        GUI:setVisible(bindItemTips, cfg.lockItem[1] == 2)
        
        local haveCount = SL:GetBagItemCount(cfgId, false)
        
        if haveCount < needCount then
            GUI:Text_setString(numControl, string.format('<color="#9b1818">%d</color>/%d', haveCount, needCount))
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


function this:costSelectTog(control, eventData, args, force)
    local isOn = args[1]
    if isOn then
        if force or self.selectCostCfg == nil or self.selectCostCfg.id ~= eventData.info.id then
            self.selectCostCfg = eventData.info
            -- 刷新成功等级，成功率，失败概率
            GUI:Text_setString(self.view.nextLevel, "+" .. self.strengthLevel + self.selectCostCfg.successLevel)
            local lucky =  EquipFunc.GetEquipLuckyRate(self.equipInfo, self.selectCostCfg.costTag[1])
            local rate = ((self.selectCostCfg.rateClient + lucky) // 100)
            rate = rate >= 100 and 100 or rate
            local luckyRateStr = ""
            -- 只有当使用的道具是灵魂宝石时才增加幸运成功率
            if lucky > 0 then
                luckyRateStr = string.format("（幸运+%d%%）", lucky // 100)
            end

            GUI:Text_setString(self.view.baseSuccessRatioText, "成功率+" .. rate .."%" .. SL:GetColorText(luckyRateStr,"#E27FE3"))
            GUI:Text_setString(self.view.failTips, self.selectCostCfg.tips)

            if self.selectCostCfg.rate/10000 >= 1 then
                GUI:setColor(self.view.failTips, "#1ADD1F")
            elseif self.strengthLevel > self.selectCostCfg.failLevel  then
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
    local cfgId = eventData.cfgId
    SL:CommonItemGetPath(nil, cfgId)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if not self.equipPanel then
        return
    end
    self.bagIndex = nil
    self.equipIndex = nil
    self:SelectEquip(self.args and self.args.equipSlot or nil)
    SL:RefreshPanelALLRedPoint("KLUIForgeGroupPanel")
    if self.args and self.args.equipSlot then
        self.args.equipSlot = nil
    end
    if self.args and self.args.showLight then
        GUI:setVisible(self.view.light_btn, true)
    else
        GUI:setVisible(self.view.light_btn, false)
    end
    GUI:setScaleY(self.view.RawImage, 0.52)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseButton, self, self.CloseButton)
    GUI:AddOnClickEvent(self.view.strengthButton, self, self.strengthButton)
    GUI:AddOnClickEvent(self.view.gotoButton, self, self.gotoButton)
    GUI:AddOnClickEvent(self.view.closeMask, self, self.closeMask)
    --GUI:AddOnClickEvent(self.view.liuGuangBtn, self, self.liuGuangBtn)
    GUI:AddOnClickEvent(self.view.strengthMasterBtn, self, self.strengthMasterBtn)
    --GUI:AddOnClickEvent(self.view.item_model, self, self.item_modelOnClick)
    GUI:AddOnClickEvent(self.view.Btn_Helper, self, self.OnClick_Btn_Helper)
    SL:RegisterLUAEvent(LUA_EVENT_EQUIP_GRID_CLICK, self.LUA_EVENT_EQUIP_GRID_CLICK, self)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
    --SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.LUA_EVENT_MONEYCHANGE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.STRENGTH_EQUIP_RESULT, self.STRENGTH_EQUIP_RESULT, self)
    
    GUI:SetToggleOnValueChange(self.view.equipBtn, self, self.equipBtn)
    GUI:SetToggleOnValueChange(self.view.bagBtn, self, self.ClickBag)
    SL:RegisterLUAEvent(LUA_EVENT_FORGE_GROUP_PANEL_CLOSE, self.CloseButton, self)
end

function this:OpenEquipUIPanel()
    ---@param equipPanel KLEquipUIPanel
    GUI:UIPanel_Open("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel",nil,nil,
                     {x=-480, hideTips=true, callBack=self.CloseEquipUi,forgeGroupType=EForgeGroupType.Strength,hideMount = true},nil,function(equipPanel)
         self.equipPanel = equipPanel
         self:Refresh()
     end)
end
 
function this:item_modelOnClick()
    SL:OpenTips("equip",self.equipInfo.cfgId,self.equipInfo.id,nil, self.equipInfo, {hideBtn=true}) 
end

function this:OnClick_Btn_Helper()
    local ruleCfg = SL:GetConfig("cfg_rule_text", 1)
    if ruleCfg then
        SL:CommonStrTipsMessage({title =ruleCfg.menutxt,str=ruleCfg.location})
    end
end

function this:liuGuangBtn()
    if self.showLiuGuang == false then
        local stream = SL:GetConfig('cfg_equip_strengthen', self.equipInfo.cfgId).stream
        if stream then
            local strengthLevel = EquipFunc.GetEquipStrengthLevel(self.equipInfo)
            for _, streamInfo in pairs(stream) do
                local nowStrengthLevel = streamInfo[1]
                local streamId = streamInfo[2]
                if strengthLevel < nowStrengthLevel then
                    --GUI:SetStreamAttr(self.view.item_model, streamId)
                    GUI:setVisible(self.view.liuguangInfo, true)
                    --GUI:Text_setString(self.view.liuguangInfo, '+' .. nowStrengthLevel .. '流光效果')

                    self.showLiuGuang = true
                    break
                end
            end
        end
        GUI:UIPanel_Open("dev/outui/Equip/Panel/KLEquipEffPreview/KLEquipEffPreviewPanel",
                         nil, nil, { ui = self, closeCallback = self.OnEffPreviewClose })
        GUI:UIPanel_Close("dev/outui/Equip/Panel/KLUIForgingMaster/KLUIForgingMasterPanel")
    else
        GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipEffPreview/KLEquipEffPreviewPanel")
    end
end

function this:OnEffPreviewClose()
    self:SetLiuGuang(self.equipInfo)
    GUI:setVisible(self.view.liuguangInfo, false)
    self.showLiuGuang = false
end

function this:strengthMasterBtn()
    if GUI:GetUI("dev/outui/Equip/Panel/KLUIForgingMaster/KLUIForgingMasterPanel") then
        GUI:UIPanel_Close("dev/outui/Equip/Panel/KLUIForgingMaster/KLUIForgingMasterPanel")
    else
        GUI:UIPanel_Open("dev/outui/Equip/Panel/KLUIForgingMaster/KLUIForgingMasterPanel", nil, nil, { uiType = 1, cfgId = self.equipInfo.cfgId })
        GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipEffPreview/KLEquipEffPreviewPanel")
    end
end

function this:equipBtn()
    if not self.isOpenBag then
        return
    end
    self.isOpenBag = false
    self:OpenEquipUIPanel()
    GUI:UIPanel_Close("dev/outui/Bag/Panel/KLStrengthBag/KLStrengthBagPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipEffPreview/KLEquipEffPreviewPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLUIForgingMaster/KLUIForgingMasterPanel")
    self.selectItem = nil
end

function this.CloseEquipUi()
    GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipStrengthUI/KLEquipStrengthUIPanel")
end

function this:closeMask()
    GUI:setVisible(self.view.equip_show_tips, false)
end

-- 强化结果回调
---@param message {issuccess:boolean, strengthlv:number, itemId:number}
function this:STRENGTH_EQUIP_RESULT(id, message)
    GUI:SetActive(self.view.strength_ok, false)
    GUI:SetActive(self.view.strength_fail, false)
    if message.issuccess then

        GUI:SetActive(self.view.strength_ok, true)
        local costId = SL:GetConfig('cfg_equip_strengthen', self.equipInfo.cfgId).costId
        local firstRate = SL:GetConfigTwoKeys('cfg_equip_strengthenCost', costId, message.strengthlv, 'costGroupId', 'level').firstRate
        if firstRate == 1 then
            self:ShowEquipSuccessMask(self.equipInfo.cfgId, message.strengthlv)
        end
    else
        GUI:SetActive(self.view.strength_fail, true)
    end
    SL:onLUAEvent(LUA_EVENT_STRENGTH_OK,message)
    
    --self:ClickEquip(self.equipInfo)


    if self.equipPanel == nil then
        self:ClickEquip(self.equipInfo)
    end
    
    if self.delayUpdt then
        SL:UnSchedule(self.delayUpdt)
        self.delayUpdt = nil
    end
    SL:ScheduleOnce(0.1,function()
        if self.equipPanel then
            self.equipPanel:UpdateAllItem()
            local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, self.equipIndex)
            if equip then
                self:ClickEquip(equip)
            else
                self.equipPanel.slotToGrid[self.equipIndex]:SetSelect(false)
                self.equipIndex = nil
                self:SelectEquip(self.equipIndex, true)
            end
        end
        SL:RefreshPanelALLRedPoint("KLUIForgeGroupPanel")
    end)
    --[[self.delayUpdt = SL:ScheduleOnce(0.3,function()
        SL:RefreshPanelALLRedPoint("KLUIForgeGroupPanel")
        if self.equipPanel then
            self.equipPanel:UpdateAllItem()
            self.equipPanel:SetSelectIndex(self.equipIndex)
        end
    end)]]
end

-- 强化跑马灯展示（特定等级展示）
function this:ShowEquipSuccessMask(cfgId, strengthLevel)
    GUI:setVisible(self.view.equip_show_tips, true)
    local name = SL:GetConfig("cfg_item", cfgId).name
    GUI:Text_setString(self.view.mask_text, string.format("%s+%d", name, strengthLevel))
    GUI:Item_setItemId(self.view.mask_item, cfgId)

    local liuGuangId = EquipFunc.GetEquipLiuGuangId(self.equipInfo)
    GUI:SetStreamAttr(self.view.mask_item, liuGuangId)
    
end

-- 点击强化按钮
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
    -- if not self.isOpenBag then
        -- 检查下一级属性够不够
        -- if not EquipFunc.GetEquipCanPutOn(self.equipInfo, self.equipInfo.cfgId, "Equip", EquipFunc.GetEquipStrengthLevel(self.equipInfo) + 1) then
        --     SL:CommonTipsMessage({
        --                              showTips = SL:GetConfig("cfg_string", 53001).text,
        --                              isShowCancelBtn = false,
        --                          })
        --     return
        -- end
    -- end
    if not EquipFunc.GetItemIsBind(nil, self.equipInfo) then
        -- 检查是否绑定道具
        local bindItem = SL:GetConfig("cfg_item", self.selectCostCfg.costTag[1]).lockItem[1] == 2
        if bindItem then
            SL:CommonTipsMessage({
                                     --cancelButtonPos = {x=182,y=39},
                                     --sureButtonPos = {x=-182,y=39},
                                     showTips = SL:GetConfig("cfg_string", 40001).text,
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
    GUI:setVisible(self.view.light_btn, false)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_STRENGTH_EQUIP, { itemId = self.equipInfo.id, costCfgId = self.selectCostCfg.id })
end

-- 跳转
function this:gotoButton()
    SL:SendTransferToNpcMessage(100404, true)
end

-- 背包改变后
function this:LUA_EVENT_BAG_CHANGE_AFTER(_,message)
    if not message then
        return
    end
    if self.equipInfo then
        local lv = EquipFunc.GetEquipStrengthLevel(self.equipInfo)
        if lv < canStrengthMaxLevel then
            local isMax = this.IsMaxEquip(self.equipInfo,lv)
            if not isMax then
                self:SetEquipCostInfo(self.equipInfo.cfgId, lv)
            end
        end
    end
    if self.isOpenBag then
        return
    end
    -- 临时处理下， 等后端整合成一个消息包

    if self.delayUpdt then
        SL:UnSchedule(self.delayUpdt)
        self.delayUpdt = nil
    end
    self.delayUpdt = SL:ScheduleOnce(0.3,function()
        if self.equipPanel then
            self.equipPanel:UpdateAllItem()
        end
        SL:RefreshPanelALLRedPoint("KLUIForgeGroupPanel")
    end)
    
    if self.selectItem then
        self.selectItem:SetSelect(true)
    end
end

-- 货币变更
function this:LUA_EVENT_MONEYCHANGE(_,message)
    if self.equipInfo then
        local lv = EquipFunc.GetEquipStrengthLevel(self.equipInfo)
        local isMax = this.IsMaxEquip(self.equipInfo,lv)
        if not isMax then
            self:SetEquipCostInfo(self.equipInfo.cfgId, lv)
        end
    end
    if self.isOpenBag then
        return
    end
    if self.delayUpdt then
        SL:UnSchedule(self.delayUpdt)
        self.delayUpdt = nil
    end
    self.delayUpdt = SL:ScheduleOnce(0.3,function()
        if self.equipPanel then
            self.equipPanel:UpdateAllItem()
        end
        SL:RefreshPanelALLRedPoint("KLUIForgeGroupPanel")
    end)
end

-- 点击装备事件回调
function this:LUA_EVENT_EQUIP_GRID_CLICK(_, index)
    local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, index)
    if index == E_AppearEquipType.Weapon and equip == nil then
        equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, E_AppearEquipType.TwoHandWeapon)
    end
    if equip then
        if SL:HasConfig('cfg_equip_strengthen', equip['cfgId']) then
            self.bagIndex = nil
            self.equipIndex = index
            self.equipPanel:SetSelectIndex(index)
            self:ClickEquip(equip)
            return
        else
            SL:TipMessage( SL:GetConfig('cfg_string',268).text, 1, NoticeType.NoticeMid )--"该装备无法被强化",
        end
    end
end

-- 关闭按钮回调
function this:CloseButton()
    GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipStrengthUI/KLEquipStrengthUIPanel")
    GUI:UIPanel_Close("dev/outui/Bag/Panel/KLStrengthBag/KLStrengthBagPanel")
    self.selectItem = nil
    self.equipPanel = nil
end

function this:Close()
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipEffPreview/KLEquipEffPreviewPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLUIForgingMaster/KLUIForgingMasterPanel")
    if self.delayUpdt then
        SL:UnSchedule(self.delayUpdt)
        self.delayUpdt = nil
    end
end

-- 选择装备
function this:SelectEquip(_index, noEquipReset)
    if self.selectItem then
        if SL:HasConfig('cfg_equip_strengthen', self.selectItem.item.cfgId) then
            self.bagIndex = nil
            ---@type cfg_item_column
            local part =  SL:GetConfig("cfg_item",self.selectItem.item.cfgId).subType
            self.equipIndex = part
            self.equipPanel:SetSelectIndex(part)
            self:ClickEquip(self.selectItem.item)
            return
        end
    end
    if _index then
        local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, _index)
        if equip then
            if SL:HasConfig('cfg_equip_strengthen', equip['cfgId']) then
                self.bagIndex = nil
                self.equipIndex = _index
                self.equipPanel:SetSelectIndex(_index)
                self:ClickEquip(equip)
                return
            end
        end
    end
    
    -- 策划要求先选中武器
    local equip_boot = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, EEquipSlotType.TwoHandWeapon)
    if equip_boot then
        if SL:HasConfig('cfg_equip_strengthen', equip_boot['cfgId']) then
            self.bagIndex = nil
            self.equipIndex = EEquipSlotType.TwoHandWeapon
            self.equipPanel:SetSelectIndex(EEquipSlotType.TwoHandWeapon)
            self:ClickEquip(equip_boot)
            return
        end
    end
    
    for index=1, 15 do
        local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, index)
        if equip then
            if SL:HasConfig('cfg_equip_strengthen', equip['cfgId']) then
                self.bagIndex = nil
                self.equipIndex = index
                self.equipPanel:SetSelectIndex(index)
                self:ClickEquip(equip)
                return
            end
        end

    end
    if noEquipReset then
        self:ResetUi()
        self.strengthAttTextList = {}
        GUI:DataListUpdateData(self.view.strength_list)
    end
    GUI:setVisible(self.view.noticeText, true)
    GUI:setVisible(self.view.bagNoticeText, false)
end

-- 初始化UI为初始状态
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
    GUI:setVisible(self.view.liuGuangBtn, false)
    GUI:setVisible(self.view.liuguangInfo, false)
    GUI:setVisible(self.view.strengthMasterBtn, false)
    GUI:setVisible(self.view.Text_StrengthTips, false)
    self.showLiuGuang = false
end

-- 点击装备（装备栏内）
-- local testLevel = 0
function this:ClickEquip(equipInfo)
    if SL:HasConfig('cfg_equip_strengthen', equipInfo.cfgId) then
        self.equipInfo = equipInfo
        self:ResetUi()
        --GUI:setVisible(self.view.liuGuangBtn, true)
        local strengthLevel = EquipFunc.GetEquipStrengthLevel(self.equipInfo)
        self.strengthLevel = strengthLevel
        self:SetEquipName(self.equipInfo.cfgId, strengthLevel)
        --self:SetEquipModel(self.equipInfo.cfgId)
        self:SetLiuGuang(self.equipInfo)
        self:SetLiuGuangBtn(self.equipInfo)
        local isMax = this.IsMaxEquip(self.equipInfo,strengthLevel)
        GUI:setVisible(self.view.arrow, not isMax)
        GUI:setVisible(self.view.nextLevel, not isMax)
        if isMax then
            GUI:setVisible(self.view.maxLevelTips, true)
            GUI:Text_setString(self.view.maxLevel, "+" .. strengthLevel)
            --GUI:setVisible(self.view.maxStrengthLevelBg, true)
            self:SetMaxAttrInfo(self.equipInfo.cfgId, strengthLevel)
        else
            --self:SetEquipLevelInfo(strengthLevel)
            self:SetEquipAttrInfo(self.equipInfo.cfgId, strengthLevel)
            GUI:setVisible(self.view.strengthButton, strengthLevel < canStrengthMaxLevel)
            GUI:setVisible(self.view.Text_StrengthTips, strengthLevel >= canStrengthMaxLevel)
            GUI:setVisible(self.view.gotoButton, strengthLevel >= canStrengthMaxLevel)
            if strengthLevel >= canStrengthMaxLevel then
                GUI:setVisible(self.view.strengthIcon_1, false)
                GUI:setVisible(self.view.StrengthCustomScrollView, false)
                GUI:Text_setText(self.view.Text_StrengthTips, SL:GetConfig('cfg_string', 40002).text)
            else
                self:SetEquipCostInfo(self.equipInfo.cfgId, strengthLevel)
                self:RefreshSuccessRatio(self.equipInfo.cfgId, strengthLevel)
                --self:SetEquipFailText(self.equipInfo.cfgId, strengthLevel)
            end
        end
        
        -- testLevel = testLevel + 1
    end
    ---@type cfg_item_column
    local item = SL:GetConfig("cfg_item", equipInfo.cfgId)
    local masterId = tonumber(item.strPart[1] .. "01")
    ---@type cfg_equip_masterGroup_column
    local master = SL:GetConfig("cfg_equip_masterGroup", masterId)
    if master then
        GUI:setVisible(self.view.strengthMasterBtn, true)
    else
        GUI:setVisible(self.view.strengthMasterBtn, false)
    end
end

function this:SetLiuGuangBtn(equipInfo)
    local stream = SL:GetConfig('cfg_equip_strengthen', equipInfo.cfgId).stream
    if stream then
        local strengthLevel = EquipFunc.GetEquipStrengthLevel(self.equipInfo)
        for _, streamInfo in pairs(stream) do
            local nowStrengthLevel = streamInfo[1]
            if strengthLevel < nowStrengthLevel then
                --GUI:setVisible(self.view.liuGuangBtn, true)
                return
            end
        end
    end

    GUI:setVisible(self.view.liuGuangBtn, false)
end

-- 设置流光
function this:SetLiuGuang(equipInfo)
    local liuGuangId = EquipFunc.GetEquipLiuGuangId(equipInfo)
    if liuGuangId then
        GUI:SetStreamAttr(self.view.item_model, liuGuangId)
    else
        GUI:ResetStreamAttr(self.view.item_model)
    end
end

-- 点击背包
function this:ClickBag()
    if self.isOpenBag then
        return
    end
    self.equipPanel = nil
    self.selectItem = nil
    self.isOpenBag = true
    self:ResetUi()
    -- 清掉属性
    self.strengthAttTextList = {}
    GUI:setVisible(self.view.bagNoticeText, true)
    GUI:DataListUpdateData(self.view.strength_list)
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipEffPreview/KLEquipEffPreviewPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLUIForgingMaster/KLUIForgingMasterPanel")
    GUI:UIPanel_Open("dev/outui/Bag/Panel/KLStrengthBag/KLStrengthBagPanel", nil, nil, {x=-480, bagType = 1 , itemClickCallBack=self.itemClickCallBack,callBackUI=self})
    GUI:Text_setString(self.view.strength_tip,"")
end

-- 点击道具回调（背包）
function this:itemClickCallBack(control, item)
    if SL:HasConfig('cfg_equip_strengthen', item.cfgId) then
        local itemInfo = SL:GetItemInfoByItemId(item.id)
        self:ClickEquip(itemInfo)
        self:HideSelectItem(false)
        control.ui:SetSelect(true)
        self.selectItem = control.ui
    else
        SL:TipMessage( SL:GetConfig('cfg_string',268).text, 1, NoticeType.NoticeMid )--"该装备无法被强化",
    end
end

function this:HideSelectItem()
    if self.selectItem then
        self.selectItem:SetSelect(false)
    end
end

-- 满级属性
function this:SetMaxAttrInfo(cfgId, strengthLevel)
    self.strengthAttTextList = {
        {
            attrName = "强化等级",
            preValue = strengthLevel,
            nextValue = "",
            arrowShow = false
        }
    }
    --GUI:setVisible(self.view.strengthIcon, true)
    local groupIds = SL:GetConfig('cfg_equip_strengthen', cfgId).groupId
    local groupId = groupIds
    if not SL:HasConfigTwoKeys('cfg_equip_strengthenGroup', groupId, strengthLevel, 'group', 'lv') then
        return
    end
    local nowAttrInfo = SL:GetConfigTwoKeys('cfg_equip_strengthenGroup', groupId, strengthLevel, 'group', 'lv').att

    local now_attr_map = {}
    for _, nowAttr in pairs(nowAttrInfo) do
        now_attr_map[nowAttr[1]] = nowAttr[2]
    end
    local equipPart = EquipFunc.GetEquipModelPart(self.equipInfo.cfgId)
    local specicalAtkAttr = EquipFunc.GetAtkAttrText(EquipFunc.DataChange(now_attr_map))
    for i, v in ipairs(specicalAtkAttr) do
        local tbl= {
            --attrName = v.text,
            attrName = "攻击力",
            preValue = self:AttrCal(nil,v.min_atk,strengthLevel, equipPart)  .. '~' .. self:AttrCal(nil,v.max_atk,strengthLevel, equipPart) ,
            nextValue = "",
            arrowShow = false
        }
        table.insert(self.strengthAttTextList, tbl)
    end
    

    for attrId, attrValue in pairs(now_attr_map) do
        if attrId ~= 201021 and attrId ~= 201011 and attrId ~= 202021 and attrId ~= 202011 and attrId ~= 200011 and attrId ~= 200021 then
            local itemT = SL:GetConfig("cfg_item", cfgId)
            local slot = itemT.strPart[1]
            if (slot == EEquipSlotType.Boot or slot == EEquipSlotType.Glove) and  attrId == 318022 then
                --鞋子护手不显示强化移速
            else
                local attTbl =  SL:GetConfig("cfg_att_info", attrId)
                local name = attTbl.name
                local att_remark = attTbl.remarks
                if not attTbl.attHide[1] or attTbl.attHide[1] ~= 0 then
                    local tbl = {}
                    if att_remark == 1 then
                        tbl = {
                            attrName = name,
                            preValue = self:AttrCal(attrId,attrValue,strengthLevel, equipPart) ,
                            nextValue = "",
                            arrowShow = false
                        }
                    else
                        tbl = {
                            attrName = name,
                            preValue = string.format("%g",self:AttrCal(attrId,attrValue / 100,strengthLevel, equipPart)) .. '%',
                            nextValue = "",
                            arrowShow = false
                        }
                    end
                    table.insert(self.strengthAttTextList, tbl) 
                end
            end
        end

    end
    
    local tbl = {
        attrName = "耐久",
        preValue = tostring(EquipFunc.GetMaxDurability(self.equipInfo)),
        nextValue = "",
        arrowShow = false
    }
    table.insert(self.strengthAttTextList, tbl)

    local limitAttInfo = EquipFunc.GetEquipUseAttLimit(nil, cfgId, strengthLevel)
    for i, v in pairs(limitAttInfo) do
        local info = {
            attrName = "所需"..SL:GetConfig("cfg_att_info", i).name,
            preValue = tostring(v),
            nextValue = "",
            arrowShow = false
        }
        table.insert(self.strengthAttTextList, info)
    end
    GUI:DataListUpdateData(self.view.strength_list)
    local itemT = SL:GetConfig("cfg_item", cfgId)
    local slot = itemT.strPart[1]
    if slot == EEquipSlotType.Boot then
        local str1 = SL:GetConfig("cfg_global",630005).value
        GUI:Text_setString(self.view.strength_tip,str1)
    elseif slot == EEquipSlotType.Glove then
        local str1 = SL:GetConfig("cfg_global",630006).value
        GUI:Text_setString(self.view.strength_tip,str1)
    else
        GUI:Text_setString(self.view.strength_tip,"")
    end
end

--失败文本
function this:SetEquipFailText(cfgId, strengthLevel)
    local costId = SL:GetConfig('cfg_equip_strengthen', cfgId).costId
    local tab = SL:GetConfigTwoKeys('cfg_equip_strengthenCost', costId, strengthLevel+1, 'costGroupId', 'level')
    local fail_tips = tab.tips
    if fail_tips then
        GUI:setVisible(self.view.failTips, true)
        GUI:Text_setString(self.view.failTips, fail_tips)
        if self.selectCostCfg.rate/10000 >= 1 then
            GUI:setColor(self.view.failTips, "#1ADD1F")
        elseif self.strengthLevel > self.selectCostCfg.failLevel  then
            GUI:setColor(self.view.failTips, "#FF2323")
        else
            GUI:setColor(self.view.failTips, "#1ADD1F")
        end
    end
end

-- 消耗道具
function this:SetEquipCostInfo(cfgId, strengthLevel)
    self.costList = {}  
    --GUI:setVisible(self.view.strengthIcon_1, true)
    GUI:setVisible(self.view.StrengthCustomScrollView, true)
    local costId = SL:GetConfig('cfg_equip_strengthen', cfgId).costId
    local next_level = strengthLevel + 1
    local cost_info = SL:GetConfigTwoKeys('cfg_equip_strengthenCost', costId, next_level, "costGroupId", "level").strengthenCost
    
    for _, v in pairs(cost_info) do
        ---@type cfg_equip_strengthenCost_v2_column
        local cost2Cfg = SL:GetConfig("cfg_equip_strengthenCost_v2", v)
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
    
    self:costSelectTog(nil, { info = self.selectCostCfg } , { true }, true)
    
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

function this:AttrCal(attrId, value, lv, equipPart)
    return EquipFunc.EquipStrengthAttrCal(value, lv, attrId, equipPart)
end

-- 装备属性
function this:SetEquipAttrInfo(cfgId, strengthLevel)

    self.strengthAttTextList = {
        {
            attrName = "强化等级",
            preValue = tostring(strengthLevel),
            nextValue = tostring(strengthLevel + 1),
            arrowShow = true
        }
    }
    --GUI:setVisible(self.view.strengthIcon, true)
    local groupId = SL:GetConfig('cfg_equip_strengthen', cfgId).groupId
    local nowAttrInfo
    if SL:HasConfigTwoKeys('cfg_equip_strengthenGroup', groupId, strengthLevel, 'group', 'lv') then
        nowAttrInfo = SL:GetConfigTwoKeys('cfg_equip_strengthenGroup', groupId, strengthLevel, 'group', 'lv')
    end
    nowAttrInfo = nowAttrInfo and nowAttrInfo.att or {}
    
    local nextAttrInfo
    if SL:HasConfigTwoKeys('cfg_equip_strengthenGroup', groupId, strengthLevel+1, 'group', 'lv') then
        nextAttrInfo = SL:GetConfigTwoKeys('cfg_equip_strengthenGroup', groupId, strengthLevel+1, 'group', 'lv')
    end
    nextAttrInfo = nextAttrInfo and nextAttrInfo.att or {}

    local now_attr_map = {}
    for _, nowAttr in pairs(nowAttrInfo) do
        now_attr_map[nowAttr[1]] = nowAttr[2]
    end

    local next_attr_map = {}
    for _, nextAttr in pairs(nextAttrInfo) do
        next_attr_map[nextAttr[1]] = tonumber(nextAttr[2])
    end

    for nextId, _ in pairs(next_attr_map) do
        if now_attr_map[nextId] == nil then
            now_attr_map[nextId] = 0
        end
    end
    local equipPart = EquipFunc.GetEquipModelPart(self.equipInfo.cfgId)
    local specicalNowAtkAttr = EquipFunc.GetAtkAttrText(EquipFunc.DataChange(now_attr_map))
    local specicalNextAtkAttr = EquipFunc.GetAtkAttrText(EquipFunc.DataChange(next_attr_map))
    for i, nowData in ipairs(specicalNowAtkAttr) do
        local nextData = specicalNextAtkAttr[i]
        local tbl= {
            --attrName = v.text,
            attrName = "攻击力",
            preValue = self:AttrCal(nil, nowData.min_atk,strengthLevel, equipPart),
            nextValue = self:AttrCal(nil, nextData.min_atk,strengthLevel+1, equipPart),
            arrowShow = true
        }
        table.insert(self.strengthAttTextList, tbl)
    end
    
    
    for attrId, attrValue in pairs(now_attr_map) do
        if attrId ~= 201021 and attrId ~= 201011 and attrId ~= 202021 and attrId ~= 202011 and attrId ~= 200011 and attrId ~= 200021 then
            local itemT = SL:GetConfig("cfg_item", cfgId)
            local slot = itemT.strPart[1]
            if (slot == EEquipSlotType.Boot or slot == EEquipSlotType.Glove) and  attrId == 318022 then
                --鞋子护手不显示强化移速
            else
                local nextValue = next_attr_map[attrId] or 0
                ---@type cfg_att_info_column
                local attTbl = SL:GetConfig("cfg_att_info", attrId)
                local name = attTbl.name
                local att_remark = attTbl.remarks
                if not attTbl.attHide[1] or attTbl.attHide[1] ~= 0 then
                    local tbl = {}
                    if att_remark == 1 then
                        tbl = {
                            attrName = name,
                            preValue = self:AttrCal(attrId, attrValue,strengthLevel, equipPart),
                            nextValue = self:AttrCal(attrId, nextValue,strengthLevel+1, equipPart),
                            arrowShow = true
                        }
                    else
                        tbl = {
                            attrName = name,
                            preValue = string.format("%g",self:AttrCal(attrId, (attrValue / 100),strengthLevel, equipPart)) .. '%',
                            nextValue = string.format("%g", self:AttrCal(attrId, (nextValue / 100),strengthLevel + 1, equipPart)) .. '%',
                            arrowShow = true
                        }
                    end
                    table.insert(self.strengthAttTextList, tbl)
                end
            end
        end

    end
    
    local tips = SL:GetConfigTwoKeys('cfg_equip_strengthenGroup',  groupId, strengthLevel+1, 'group', 'lv').tips
    if not string.isNullOrEmpty(tips) then
        local tbl = {
            attrName = tips,
            preValue = '',
            nextValue = '',
            arrowShow = false
        }
        table.insert(self.strengthAttTextList, tbl)
    end

    local tbl = {
        attrName = "耐久",
        preValue = tostring(EquipFunc.GetMaxDurability(self.equipInfo)),
        nextValue = tostring(EquipFunc.GetMaxDurability(self.equipInfo, strengthLevel + 1)),
        arrowShow = true
    }
    table.insert(self.strengthAttTextList, tbl)
    
    local limitAttInfo = EquipFunc.GetEquipUseAttLimit(nil, cfgId, strengthLevel)
    local nextLimitAttInfo = EquipFunc.GetEquipUseAttLimit(nil, cfgId, strengthLevel + 1)
    for i, v in pairs(limitAttInfo) do
        local info = {
            attrName = "所需"..SL:GetConfig("cfg_att_info", i).name,
            preValue = tostring(v),
            nextValue = tostring(nextLimitAttInfo[i]),
            arrowShow = true
        }
        table.insert(self.strengthAttTextList, info)
    end

    GUI:DataListUpdateData(self.view.strength_list)

    local itemT = SL:GetConfig("cfg_item", cfgId)
    local slot = itemT.strPart[1]
    if slot == EEquipSlotType.Boot then
        local str1 = SL:GetConfig("cfg_global",630005).value
        GUI:Text_setString(self.view.strength_tip,str1)
    elseif slot == EEquipSlotType.Glove then
        local str1 = SL:GetConfig("cfg_global",630006).value
        GUI:Text_setString(self.view.strength_tip,str1)
    else
        GUI:Text_setString(self.view.strength_tip,"")
    end
end

-- 装备等级
function this:SetEquipLevelInfo(strengthLevel)
    GUI:setVisible(self.view.strengthLevelBg, true)
    GUI:Text_setString(self.view.preLevel, "+" .. strengthLevel)
    GUI:Text_setString(self.view.nextLevel, "+" .. strengthLevel+1)
end

-- 成功率
function this:RefreshSuccessRatio(cfgId, strengthLevel)

    GUI:setVisible(self.view.baseSuccessRatioText, true)
    --GUI:setVisible(self.view.successIcon, true)
    if strengthLevel >= canStrengthMaxLevel then
        local costId = SL:GetConfig('cfg_equip_strengthen', cfgId).costId
        local cfg = SL:GetConfigTwoKeys('cfg_equip_strengthenCost', costId, strengthLevel + 1, "costGroupId", "level")
        local next_level = strengthLevel + 1
        local lucky =  EquipFunc.GetEquipLuckyRate(self.equipInfo,cfg.costTag[1]) // 100
        local rate_client = cfg.rateClient + lucky
        rate_client = rate_client // 100
        rate_client = rate_client >= 100 and 100 or rate_client

        local luckyRateStr = lucky == 0 and "" or string.format("（幸运+%d%%d）",lucky)
        GUI:Text_setString(self.view.baseSuccessRatioText, "成功率+"..rate_client .. '%' .. SL:GetColorText(luckyRateStr,"#E27FE3"))
    end
end

-- 装备名字
function this:SetEquipName(cfgId, strengthLevel)

    GUI:setVisible(self.view.equipName, true)
    local equipName = SL:GetConfig('cfg_item', cfgId).name
    local colorStr = EquipFunc.GetEquipNameColor(cfgId)
    if strengthLevel > 0 then
        equipName = equipName .. '+' .. strengthLevel
    end
    GUI:Text_setString(self.view.equipName, string.format("<color=%s>%s</color>", colorStr, equipName))
end

-- 装备模型
function this:SetEquipModel(cfgId)
    GUI:setVisible(self.view.item_model, true)
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
    GUI:Item_UpdataData(self.view.item_model, data)
end

--是否是满级装备
function this.IsMaxEquip(equipInfo, strength_level)

    local cfgId = equipInfo.cfgId
    --local strength_level = equipInfo["strengthlevel"]
    ---首饰换表处理
    local ornament_tbl = SL:HasConfig('cfg_equip_ornamentsMain', cfgId)
    if ornament_tbl then
        if InfoManager.equipJewelryInfo:GetCurLevelMaxStrength(equipInfo) <= strength_level then
            return true
        end
        return false
    end
    local strength_tbl = SL:GetConfig('cfg_equip_strengthen', cfgId)
    if strength_tbl then
        if strength_tbl.maxLevel <= strength_level then
            return true
        end
        
        return false
        
    end
    return false
end

return this
