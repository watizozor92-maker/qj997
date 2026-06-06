---@class KLBagTipsPanel:UIKmlLuaPanelBase
---@field view KLBagTipsPanelView
local KLBagTipsPanel = class(UIKmlLuaPanelBase)
local this = KLBagTipsPanel
---创建时调用一次
function this:Init()
    self.ShowTipType = EShortcutUserType.NormalBox
    self.ShowTipItemData = nil
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self:UpdataPanel()
end

---特殊属性点快捷提示
function this:SetAttrPosUI()
    self:CloseDownTimer()
    GUI:setVisible(self.view.Item, false)
    GUI:setVisible(self.view.TimeCountdown, false)

    local namestr = "<color=#F5EFE4>" .. "可分配点数" .. "</color>"
    local usestr = EShortcutUserTypeStr[EShortcutUserType.AttrPos]
    local AttrPoint = tostring(SL:GetMetaValue("REMAIN_ATTR_POINT"))
    GUI:SetOnPrefabControlLoaded(self.view.scroll_text_template, function()
        GUI:Text_setString(self.view.Text, namestr)
    end)

    GUI:Text_setString(self.view.UseText, usestr)
    GUI:setPositionX(self.view.UseText, 0)
    GUI:Text_setString(self.view.AttrText, AttrPoint)
    GUI:setVisible(self.view.AttrImage, true)
    
end
function this:IsNotMeetAttrSkillIdByCostItemId(cfgId)
    local skillTbl = SL:GetConfigTable("cfg_skill_info")
    for _,v in pairs(skillTbl) do
        if v.skillLevelUpItemID then
            for _,UpItem in pairs(v.skillLevelUpItemID) do
                if UpItem[1] == cfgId then
                    --属性
                    if #v.needAtt > 0 then
                        for _, v in pairs(v.needAtt) do
                            local attrId = v[1]
                            local attrVal = v[2]
                            local haveAttr = SL:GetMetaValue(EMetaVarGetKey.GET_ATTR_VALUE_BY_ID, attrId)
                            if attrVal > haveAttr then
                                return true ---不满足返回
                            end
                        end
                    end
                end
            end
        end
    end
    return false
end

function this:UpdataPanel()
    if not self.view then
        return
    end

    local bagItem = InfoManager.exBoxTipsInfo:GetShowEquip()
    local boxitems =   InfoManager.exBoxTipsInfo:GetShowBoxItem()
    if bagItem == nil and boxitems == nil then
        GUI:UIPanel_Close("dev/ui/Preview/Panel/KLBagTips/KLBagTipsPanel")
        return
    end
    self:SetAppendStrength(bagItem)
    local isNotMeetSkillAttr =false ---不满足技能属性条件
    if boxitems then
        isNotMeetSkillAttr = self:IsNotMeetAttrSkillIdByCostItemId(boxitems.itemId)
        if isNotMeetSkillAttr then
            GUI:UIPanel_Close("dev/ui/Preview/Panel/KLBagTips/KLBagTipsPanel")
            return
        end
    end
    if bagItem then
        local noMeet = InfoManager.exBoxTipsInfo:IsAttrMeet(bagItem.item)
        if not noMeet then
            GUI:UIPanel_Close("dev/ui/Preview/Panel/KLBagTips/KLBagTipsPanel")
            return
        end

        local isShow = EquipFunc.CheckBagEquipIsBetter(bagItem.item) 
        if not isShow then
            GUI:UIPanel_Close("dev/ui/Preview/Panel/KLBagTips/KLBagTipsPanel")
            return
        end
    end
    ---背包装备
    if self.isShowEquip and self.showBag and self.showBag == bagItem and boxitems == nil then
        --重复刷新当前正显示装备
        --self.ShowTipItemData = bagItem
        --self:UpdataEquipPanel(bagItem)
        return
    end
    self.showBag = bagItem
    self.isShowEquip = false   ---装备提示
    self.isShowAttrPos = false ---属性点提示
    ---在此处操作排序
    if boxitems == nil then
        self.ShowTipItemData = bagItem
        self:UpdataEquipPanel(bagItem)
        return
    end
    if self.qualityItem then
        GUI:UIPanel_Close(nil, self.qualityItem)
    end

    self.qualityItem = nil
    ---属性点，技能
    self.showBag = nil
    self.ShowTipItemData = boxitems
    GUI:setVisible(self.view.equiptag, false)
    GUI:setVisible(self.view.bagtag, false)
    if boxitems.itemId and boxitems.itemId == tonumber(SL:GetConfig("cfg_global",820002).value) then
        self.isShowAttrPos = true
        self.ShowTipType = EShortcutUserType.AttrPos
        self:SetAttrPosUI()
        GUI:setVisible(self.view.strengthLevel, false)
        GUI:setVisible(self.view.appendLevel, false)
        GUI:setVisible(self.view.xinyun, false)
    else
        self.ShowTipType = EShortcutUserType.NormalBox
        local itemcfg = SL:GetConfig("cfg_item", boxitems.itemId)

        if itemcfg == nil then
            return
        end
        GUI:SetOnPrefabControlLoaded(self.view.scroll_text_template, function()
            GUI:Text_setTextColor(self.view.Text, SL:GetColorCfg(itemcfg.color).color)
            GUI:Text_setString(self.view.Text, itemcfg.name)
        end)
        --GUI:Text_setTextColor(self.view.Text, SL:GetColorCfg(itemcfg.color).color)
        --GUI:Text_setString(self.view.Text, itemcfg.name)
        GUI:Text_setString(self.view.AttrText, "")
        GUI:setVisible(self.view.AttrImage, false)
        GUI:setVisible(self.view.Item, true)
        self:SetEquipItemIcon(true, itemcfg.id)
        self.nowCfgId = itemcfg.id
        if boxitems ~= nil or bagItem == nil then
            GUI:setVisible(self.view.TimeCountdown, false)
            self:CloseDownTimer() --删除倒计时
            self:UpdataItemPanel(boxitems.itemId)
        end
    end
end

function this:SetAppendStrength(bagItem)
    if not bagItem or not bagItem.item then
        return
    end
    local item = bagItem.item
     --强化等级
    local strengthLevel = EquipFunc.GetEquipStrengthLevel(item)
    GUI:setVisible(self.view.strengthLevel, true)
    GUI:Text_setString(self.view.strengthLevel, strengthLevel ~= 0 and ("+" .. strengthLevel) or "")
    --追加等级
    local appendLv = EquipFunc.GetEquipAppendLevel(item)
    GUI:setVisible(self.view.appendLevel, true)
    GUI:Text_setString(self.view.appendLevel, appendLv ~= 0 and EquipFunc.GetEquipAppendLevelStr(appendLv) or "")
    ---是否显示幸运图标
    if not table.isNullOrEmpty(EquipFunc.GetEquipLuckyAttr(item))  then
        GUI:setVisible(self.view.xinyun, true)
    else
        GUI:setVisible(self.view.xinyun, false)
    end
end

function this:SetEquipItemIcon(show, id)
    GUI:setVisible(self.view.Item, show)
    if show then
        if self.equipIcon then
            --self.view.Item.kmlControl:HideAllChilds()
            GUI:RemoveAllChildren(self.view.Item)
        end
        self.equipIcon = GUI:Item_Create(self.view.Item, {
            width = "70",
            height = "70",
            itemid = id,
            tips = "1",
            noclip = "1",
            bgtype = "0",
            mfixsize = "70,70"
        })
        GUI:Item_UpdataData(self.equipIcon, {
            itemid = id,
        })
        --GUI:AddOnClickEvent(self.equipIcon, self, self.ClickEquipItemIcon, { id = id})
    end
end

----按钮倒计时设置
function this:CountDownText()
    if self.countDownTimer and self.countDownTimer <= 0 then
        return
    end
    self.countDownTimer = self.countDownTimer - 1
    GUI:Text_setString(self.view.TimeCountdown, string.format(" (%ds)", self.countDownTimer))
    --if DebugFlag.LogEnable then
    --    log('倒计时 find = ' ..self.countDownTimer)
    --end
    if self.countDownTimer <= 0 then
        GUI:Text_setString(self.view.TimeCountdown, "")
        self:CloseDownTimer()
        self:Use1BtnClick()
        if self.timer_autoUse then
            SL:UnSchedule(self.timer_autoUse)
            self.timer_autoUse = nil
        end
    end
end

function this:CloseDownTimer()
    if self.timer_autoUse then
        SL:UnSchedule(self.timer_autoUse)
        self.timer_autoUse = nil
    end
end

---按钮文本设置
function this:StartCountDownTimer(type, cfg)
    local usestr = EShortcutUserTypeStr[type]
    GUI:Text_setString(self.view.UseText, usestr)
    --local contentX = self.view.UseText.rectTransform.localPosition.x
    --self.view.UseText.rectTransform:SetLocalPosition(-18, 0)
    GUI:setLocalPosition(self.view.UseText, -18, 0)
    self.countDownTimer = 8
    if cfg ~= nil and cfg.bayWindow > 0 and cfg.bayWindow < 999 then
        self.countDownTimer = cfg.bayWindow
    end

    self.timer_autoUse = SL:Schedule(self.timer_autoUse, 0, 1, -1, function()
        self:CountDownText()
    end)
end

function this:SetUseText_NoCountDown(type)
    local usestr = EShortcutUserTypeStr[type]
    GUI:Text_setString(self.view.UseText, usestr)
    --self.view.UseText.rectTransform:SetLocalPosition(0, 0)
    GUI:setLocalPosition(self.view.UseText, 0, 0)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    -- if self.view then
    GUI:AddOnClickEvent(self.view.BtnClose, self, self.CloseBtnClick)
    GUI:AddOnClickEvent(self.view.BtnUse1, self, self.Use1BtnClick)
    GUI:AddOnClickEvent(self.view.buttonUseClose, self, self.CloseBtnClick)
    GUI:AddOnClickEvent(self.view.buttonUseEx, self, self.Use1BtnClick)
        --SL:RegisterLUAEvent(LUA_EVENT_ADDFIREND,self.LUA_EVENT_ADDFIREND,self)
    SL:RegisterLUAEvent(LUA_EVENT_OPEN_UI, self.LUA_EVENT_OPEN_UI, self)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, self.LUA_EVENT_CLOSEWIN, self)
    -- end
end

function this:LUA_EVENT_OPEN_UI(_, message)
    if message.panelName == "KLUIBagPanel" then
        SL:DelAllEquip()
    end
end

function this:LUA_EVENT_CLOSEWIN(_, message)
    if message == "KLUIBagPanel" then
        SL:DelAllEquip()
    end
end

---使用/穿戴
function this:Use1BtnClick(_, event)
    if self.isShowAttrPos then
        SL:OpenKLAttrPanel()
    elseif self.isShowEquip then
        self:CloseDownTimer()
        if self.ShowTipType == EShortcutUserType.WearEquip then
            --SL:SetMetaValue(EMetaVarSetKey.SET_ROLE_ATTR_VALUE_OFFSET, self.offsetAttrList)
            --SL:WearEquip()
            
            --SL:PutOnEquip(self.ShowTipItemData.item)
            SL:OpenKLBagPanel()
            self:CloseBtnClick()
        else
            SL:OpenKLBagPanel()
            self:CloseBtnClick()
        end
    else
        local itemcfg = SL:GetConfig("cfg_item", self.ShowTipItemData.itemId)
        if SL:CheckIsSkillBookType(self.ShowTipItemData.itemId) then
            local useParam = string.split(itemcfg.useParam, "#")
            local skillId = tonumber(useParam[1])
            SL:ReqUpSkillMessage(skillId)
            SL:DeleteBoxItem(self.ShowTipItemData.itemId)
        else
            --批量使用宝箱ReqBatchOpenBoxMessage
            local bag = SL:GetMetaValue("BAG_DATA")[1]
            for _, v in pairs(bag) do
                if v.cfgId == self.ShowTipItemData.itemId then
                    SL:UseItem(self.ShowTipItemData.itemId, v.id, 1)
                    self:CloseBtnClick()
                    return
                end
            end
            --SL:UseBoxItem()
            --SL:UseItem(self.args.cfgId, self.args.id, self.args.count)
        end
    end
    self:UpdataPanel()
end

---关闭活动预告
function this:CloseBtnClick()
    if self.isShowEquip then
        SL:ReMoveNowItem()
        self:UpdataPanel()
    else
        InfoManager.exBoxTipsInfo:HideBoxItem()
        self:UpdataPanel()
    end
end

function this:UpdataItemPanel(itemId)
    local cfg = SL:GetConfig("cfg_item", itemId, "id")
    if cfg.bayWindow < 999 then
        --自动使用
        self.ShowTipType = EShortcutUserType.NormalBox
        GUI:setVisible(self.view.TimeCountdown, true)
        self:StartCountDownTimer(self.ShowTipType, cfg)
    else
        self.ShowTipType = EShortcutUserType.NormalBox
        self:CloseDownTimer()
        GUI:setVisible(self.view.TimeCountdown, false)
        self:SetUseText_NoCountDown(self.ShowTipType)
    end
end

---@param bagItem BagProtos.BagItem
function this:UpdataEquipPanel(bagItem)
    local canEquip = self:ShowEquip(bagItem)
    if self.isShowEquip then
        --装备替换的时候先卸下装备，再穿上新装备
        --此时如果下一个要显示快捷使用的装备跟替换的装备是同一个部位的话
        --会在穿上新装备之前检测了下一个同部位的装备，会出现身上对应部位没有装备，但是实际上下一帧就会有装备穿上
        --因此等下一帧再跑检测逻辑
        if self.coroutineAutoUse then
            Coroutine.Stop(self.coroutineAutoUse)
            self.coroutineAutoUse = nil
        end
        self.coroutineAutoUse = Coroutine.Start(self.CheckEquipAutoUse, self, canEquip)
    end
end

---canEquip == true  满足要求可自动穿戴
function this:CheckEquipAutoUse(canEquip)
    Coroutine.WaitForEndOfFrame()
    if self.showBag == nil then
        return
    end
    if self.qualityItem then
        self.qualityItem:SetData(self.showBag.item.cfgId, table.count(SL:GetEquipEntrys(self.showBag.item)))
    else
        GUI:UIPanel_Open("dev/ui/Common/Item/KLEquipQualityEntry/KLEquipQualityEntryItem",
            self.view.MainPanle, self,
            { cfgId = self.showBag.item.cfgId, entryCount = table.count(SL:GetEquipEntrys(self.showBag.item)) }, false,
            function(qualityItem)
                self.qualityItem = qualityItem
                GUI:setPosition(qualityItem.view.root,0, -33)
                GUI:setScale(qualityItem.view.root,0.82)
            end)
    end

    local cfg = SL:GetConfig("cfg_item", self.showBag.item.cfgId)

    if canEquip then
        ---立即装备
        local noEquip = true
        for i = 1, #cfg.strPart do
            --local equip = RoleManager.meData.equipInfo:GetEquipByPosAndWearBar(cfg.strPart[i], cfg.wearBarID[1])
            local equip = SL:MeData_GetEquipByPosAndWearBar(cfg.strPart[i], cfg.wearBarID[1])
            --对应部位没穿装备才开启自动使用
            if not equip then
                noEquip = true
                break
            end
        end
        if cfg.bayWindow == 999 then
            noEquip = false
        end
        if noEquip then
            --自动使用装备
            self.ShowTipType = EShortcutUserType.WearEquip
            GUI:setVisible(self.view.TimeCountdown, true)
            self:StartCountDownTimer(self.ShowTipType, cfg)
        else
            self.ShowTipType = EShortcutUserType.WearEquip
            self:CloseDownTimer()
            GUI:setVisible(self.view.TimeCountdown, false)
            self:SetUseText_NoCountDown(self.ShowTipType)
        end
    else
        ---打开背包
        self.ShowTipType = EShortcutUserType.NoWearEquip
        self:CloseDownTimer()
        GUI:setVisible(self.view.TimeCountdown, false)
        self:SetUseText_NoCountDown(self.ShowTipType)
    end
    GUI:setVisible(self.view.equiptag, self.ShowTipType == EShortcutUserType.WearEquip)
    GUI:setVisible(self.view.bagtag, self.ShowTipType == EShortcutUserType.NoWearEquip)
end

--是否满足穿戴要求
function this:ShowEquip(bagItem)
    if bagItem == nil then
        return false
    end
    local itemCfg = SL:GetConfig("cfg_item", bagItem.item.cfgId)
    if itemCfg == nil then
        return false
    end
    GUI:SetOnPrefabControlLoaded(self.view.scroll_text_template, function()
        GUI:Text_setTextColor(self.view.Text, SL:GetColorCfg(itemCfg.color).color)
        GUI:Text_setString(self.view.Text, SL:GetItemNameByItemData(bagItem.item))
    end)
    --GUI:Text_setTextColor(self.view.Text, SL:GetColorCfg(itemCfg.color).color)
    --GUI:Text_setString(self.view.Text, SL:GetItemNameByItemData(bagItem.item))
    GUI:Text_setString(self.view.AttrText, "")
    GUI:setVisible(self.view.AttrImage, false)
    self:SetEquipItemIcon(true, bagItem.item.cfgId)
    self.isShowEquip = true
    local needLevelList = SL:Split(itemCfg.useLevelLimit, '#')
    if #needLevelList ~= 0 then
        --- 超过某一级才能使用的装备
        if #needLevelList == 1 then
            if tonumber(needLevelList[1]) > SL:GetMetaValue(EMetaVarGetKey.LEVEL) then
                return false
            end
            --- 等级在某一区间才能用
        elseif #needLevelList == 2 then
            if tonumber(needLevelList[1]) > SL:GetMetaValue(EMetaVarGetKey.LEVEL) or SL:GetMetaValue(EMetaVarGetKey.LEVEL) > tonumber(needLevelList[2]) then
                return false
            end
        end
    end
    ---穿戴栏是否解锁  rein 为空
    if itemCfg.wearBarID[1] and itemCfg.wearBarID[1] > SL:MeData_GetCareer().careerRank - 1 then
        --return false
    end
    --- 属性判断
    local needAttrList = SL:GetNeedAttrList(bagItem.item.cfgId)
    self.offsetAttrList = {}
    for _, attrInfo in pairs(needAttrList) do
        local attrId = attrInfo[1]
        local attrValue = attrInfo[2]
        local attrCfg = SL:GetConfig("cfg_att_info", attrId)

        if attrCfg ~= nil then
            local haveAttr = SL:GetMetaValue(EMetaVarGetKey.GET_ATTR_VALUE_BY_ID, attrId)
            local offsetValue = EquipFunc.GetAttrValueOffset(attrId, attrValue,
                bagItem.item.itemExtInfo.equipExtInfo.entryAttr)
            self.offsetAttrList[attrId] = -offsetValue
            attrValue = attrValue - offsetValue
            if haveAttr < attrValue then
                return false
            end
        end
    end
    return true
end

---获取被属性衰减过的实际生效属性
---@param attrList CommonProtos.EquipEntryAttrVo[] 幸运属性
function this:GetAttrValueOffset(attrId, attrValue, attrList)
    if not attrList then
        return 0
    end
    local specialValue = 0
    ---@type cfg_att_special_column
    local specialTbl = SL:GetConfig("cfg_att_special", tostring(attrId), "param")
    if specialTbl and specialTbl.type[1] == 21 then
        for _, v in pairs(attrList) do
            if v.type == specialTbl.id then
                specialValue = v.num
                break
            end
        end
        ---@type cfg_att_info_column
        local tbl = SL:GetConfig("cfg_att_info", specialTbl.id)
        if tbl then
            if tbl.remarks == 2 then
                specialValue = attrValue * specialValue * 100
            end
        end
    end
    return specialValue
end

function this:Close()
    --SL:RegisterLUAEvent(LUA_EVENT_ADDFIREND,self.LUA_EVENT_ADDFIREND,self)
    SL:UnRegisterLUAEvent(LUA_EVENT_OPEN_UI, self.LUA_EVENT_OPEN_UI, self)
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, self.LUA_EVENT_CLOSEWIN, self)
    if self.coroutineAutoUse then
        Coroutine.Stop(self.coroutineAutoUse)
        self.coroutineAutoUse = nil
    end
    self:CloseDownTimer()
    Coroutine.Stop(self.coroutineAutoUse)
    -- Coroutine.StopAll()
    if self.qualityItem then
        GUI:UIPanel_Close(nil, self.qualityItem)
        self.qualityItem = nil
    end
end

return this
