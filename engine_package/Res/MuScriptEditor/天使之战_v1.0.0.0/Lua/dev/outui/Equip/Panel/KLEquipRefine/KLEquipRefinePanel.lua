---@class KLEquipRefinePanel:UIKmlLuaPanelBase
---@field view KLEquipRefinePanelView
local KLEquipRefinePanel = class(UIKmlLuaPanelBase)
local this =KLEquipRefinePanel

---创建时调用一次
function this:Init()
    self:OpenEquipUIPanel()
    
    ---属性列表
    self.attList = {}
    self.attMainList = {}
    ---消耗列表
    self.costList = {}
    GUI:DataListInitData(self.view.DataList_Att, function()
        return table.count(self.attList)
    end, nil, nil, function(realIndex)
        return self:AttDataListUpdate(realIndex)
    end)

    GUI:DataListInitData(self.view.DataList_MainAtt, function()
        return table.count(self.attMainList)
    end, nil, nil, function(realIndex)
        local text_curAtt = GUI:GetChildControl(self.view.DataList_MainAtt, realIndex, "Text_CurAttMain")
        local attInfo = self.attMainList[realIndex + 1]
        local entryId = attInfo.entryId
        local attInfoTbl = SL:GetConfig("cfg_equip_att", entryId)
        if attInfoTbl then
            GUI:Text_setText(text_curAtt,attInfoTbl.refineName)
        end
    end)
    
    GUI:DataListInitData(self.view.DataList_Cost, function()
        return table.count(self.costList)
    end, nil, nil, function(realIndex)
        return self:CostDataListUpdate(realIndex)
    end)
    
    GUI:Text_setText(self.view.Text_NoTips, SL:GetConfig("cfg_string", 46001).text)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Btn_Close, self, self.OnClick_Btn_Close)
    GUI:SetToggleOnValueChange(self.view.Tog_Equip, self, self.OnValueChange_Tog_Equip)
    GUI:SetToggleOnValueChange(self.view.Tog_Bag, self, self.OnValueChange_Tog_Bag)
    GUI:AddOnClickEvent(self.view.Btn_MainEquipCancel, self, self.OnClick_Btn_MainEquipCancel)
    GUI:AddOnClickEvent(self.view.Btn_AssistantEquipCancel, self, self.OnClick_Btn_AssistantEquipCancel)
    GUI:AddOnClickEvent(self.view.Btn_Refine, self, self.OnClick_Btn_Refine)
    GUI:AddOnClickEvent(self.view.Btn_RefineMain, self, self.OnClick_Btn_RefineMain)
    SL:RegisterLUAEvent(LUA_EVENT_EQUIP_GRID_CLICK, self.LUA_EVENT_EQUIP_GRID_CLICK, self)
    SL:RegisterLUAEvent(LUA_EVENT_FORGE_GROUP_PANEL_CLOSE, self.OnClick_Btn_Close, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_EQUIP_REFINE_RESULT, self.RES_EQUIP_REFINE_RESULT, self)
    SL:RegisterLuaNetMsg(MessageDef.ResBagChangeMessage, self.ResBagChangeMessage, self)
end
function this:OnClick_Btn_RefineMain()
    self:EquipCancel(1)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    if not self.equipPanel then
        return
    end
    self.bagIndex = nil
    self.equipIndex = nil
    --self:SelectEquip(self.args and self.args.equipSlot or nil)
    SL:RefreshPanelALLRedPoint("KLUIForgeGroupPanel")
end

function this:Hide()
end

function this:Close()
end

function this:OpenEquipUIPanel()
    ---@param equipPanel KLEquipUIPanel
    GUI:UIPanel_Open("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel",nil,nil,
                     {x=-480, hideTips=true, callBack=self.OnClick_Btn_Close,forgeGroupType=EForgeGroupType.Refine,hideMount = true},nil,function(equipPanel)
         self.equipPanel = equipPanel
         if self.equipIndex then
             self.equipPanel:SetSelectIndex(self.equipIndex)
         end
     end)
end

---属性列表更新
function this:AttDataListUpdate(realIndex)
    local text_curAtt = GUI:GetChildControl(self.view.DataList_Att, realIndex, "Text_CurAtt")
    local text_previewAtt = GUI:GetChildControl(self.view.DataList_Att, realIndex, "Text_PreviewAtt")
    local arrow = GUI:GetChildControl(self.view.DataList_Att, realIndex, "arrow")
    local attInfo = self.attList[realIndex + 1]
    GUI:setVisible(arrow, attInfo.curAtt ~= nil)
    GUI:Text_setText(text_curAtt, attInfo.curAtt ~= nil and attInfo.curAtt.name or "")
    GUI:Text_setText(text_previewAtt, attInfo.previewAtt.name)
end

---消耗列表更新
function this:CostDataListUpdate(realIndex)
    local item_cost = GUI:GetChildControl(self.view.DataList_Cost, realIndex, "Item_Cost")
    local text_costName = GUI:GetChildControl(self.view.DataList_Cost, realIndex, "Text_CostName")
    local text_costNum = GUI:GetChildControl(self.view.DataList_Cost, realIndex, "Text_CostNum")
    local btn_costAdd = GUI:GetChildControl(self.view.DataList_Cost,realIndex,'Btn_CostAdd')
    local costInfo = self.costList[realIndex + 1]
    local cfgId = costInfo[1]
    if not SL:HasConfig("cfg_item", cfgId) then
        return
    end
    GUI:Item_setItemId(item_cost, cfgId)
    local name = SL:GetConfig('cfg_item', cfgId).name
    GUI:Text_setString(text_costName, name)

    local haveCount = SL:GetBagItemCount(cfgId)
    if haveCount < costInfo[2] then
        GUI:Text_setString(text_costNum, string.format('<color="#9b1818">%d</color>/%d', haveCount, costInfo[2]))
    else
        GUI:Text_setString(text_costNum, string.format('<color="#00ff00">%d</color>/%d', haveCount, costInfo[2]))
    end
    
    GUI:AddOnClickEvent(item_cost, self, self.OnClick_CostAddBtn, { cfgId = cfgId })
end

---选择装备
function this:SelectEquip(_index, noEquipReset)
    --[[if self.selectItem then
        if SL:HasConfig('cfg_equip_refine', self.selectItem.item.cfgId) then
            self.bagIndex = nil
            ---@type cfg_item_column
            local part =  SL:GetConfig("cfg_item",self.selectItem.item.cfgId).subType
            self.equipIndex = part
            self.equipPanel:SetSelectIndex(part)
            self:ClickEquip(self.selectItem.item)
            return
        end
    end]]
    if _index then
        local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, _index)
        if equip then
            if SL:HasConfig('cfg_equip_refine', equip.cfgId) then
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
        if SL:HasConfig('cfg_equip_refine', equip_boot.cfgId) then
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
            if SL:HasConfig('cfg_equip_refine', equip.cfgId) then
                self.bagIndex = nil
                self.equipIndex = index
                self.equipPanel:SetSelectIndex(index)
                self:ClickEquip(equip)
                return
            end
        end
    end
end

---选择放入装备
function this:SelectItem(equip_pos, cfgid, id)
    local equip = SL:GetPosItemInfo(equip_pos, cfgid, id)
    self:ClickEquip(equip)
end

-- 点击装备（装备栏内）
function this:ClickEquip(equipInfo)
    if SL:HasConfig('cfg_equip_refine', equipInfo.cfgId) then
        if self.mainEquip == nil then
            self:RefreshMainEquip(equipInfo)
            self:hideMainPanel()
        else
            self:RefreshAssistantEquip(equipInfo)
            self:hideMainPanel()
        end
    else
        SL:TipMessage(SL:GetConfig('cfg_string', 46002).text, 1, NoticeType.NoticeMid)--"该装备无法被强化",
    end
end

-- 点击道具回调（背包）
function this:itemClickCallBack(control, item)
    local pos = self:GetPos(item.id)
    SL:OpenTips(pos, item.cfgId, item.id, nil, nil, { hideComparsion = true})
end

---获取装备位置
function this:GetPos(itemId)
    if self.bagItems then
        for _, v in pairs(self.bagItems) do
            if v == itemId then
                return "bag"
            end
        end
    end
    return "equip"
end

---刷新主装备
function this:RefreshMainEquip(equip)
    self.mainEquip = equip
    GUI:Item_setItemId(self.view.item_mainEquip, equip and equip.cfgId or 0)
    if equip then
        self.preEquipPos = self:GetPos(equip.id)
        GUI:Text_setText(self.view.Text_MainEquipName, SL:GetEquipValue(EMetaVarGetKey.EQUIP_NAME, nil, equip.cfgId, nil))
        local refineCfg = SL:GetConfig("cfg_equip_refine", self.mainEquip.cfgId)
        GUI:Text_setText(self.view.Text_AssistantEquipName, SL:GetEquipValue(EMetaVarGetKey.EQUIP_NAME, nil, refineCfg.Consumption[2], nil))
    else
        if self.equipPanel and self.equipIndex then
            self.equipPanel:SetUnselectIndex(self.equipIndex)
        end
        self.equipIndex = nil
        GUI:Text_setText(self.view.Text_MainEquipName, "")
        GUI:Text_setText(self.view.Text_AssistantEquipName, "")
    end
    GUI:setVisible(self.view.img_equip_source_add, self.mainEquip == nil)
    --GUI:setVisible(self.view.img_equip_target_add, self.mainEquip ~= nil and self.assistantEquip == nil)
    GUI:setColor(self.view.img_equip_target_add, self.mainEquip ~= nil and self.assistantEquip == nil and "#FFFFFF" or "#FFFFFF00")
    GUI:setVisible(self.view.text27, self.assistantEquip == nil)
    local isOn = tonumber(GUI:Toggle_getIsOn(self.view.Tog_Bag))
    if equip and isOn == 0 then
        GUI:Toggle_setIsOn(self.view.Tog_Bag, true)
    else
        self:RefreshShowItems()
    end
    --self:showMainPanel()
    self:RefreshRefineAttMain(self.mainEquip == nil)
end
---刷新主洗练属性
function this:RefreshRefineAttMain(isNull)
    self.attMainList = {}
    if not isNull then
        local entryAttr = SL:GetEquipValue(EMetaVarGetKey.EQUIP_ENTRY_ATTR, self.preEquipPos, self.mainEquip.cfgId, self.mainEquip.id)
        --logError("MainId="..self.mainEquip.id)
        if entryAttr and table.count(entryAttr) > 0 then
            self.attMainList = entryAttr
        end
    end
    GUI:DataListUpdateData(self.view.DataList_MainAtt)
end
function this:GetBaseAttr(baseAttr, connectSign,isShowHead, showMinMaxAtt,params)
    if params == nil then
        params = {}
    end
    params.round = true
    local baseAttrList = EquipFunc.GetBaseAttr(baseAttr,self.preEquipPos, self.mainEquip.cfgId, self.mainEquip.id, connectSign,isShowHead, showMinMaxAtt,params)
    return baseAttrList
end
function this:showMainPanel()
    GUI:SetActive(self.view.scrollviewMain,true)
    GUI:SetActive(self.view.Btn_RefineMain,true)
    GUI:SetActive(self.view.AttTitle,true)
    GUI:SetActive(self.view.text1,false)
    GUI:SetActive(self.view.Img_Tips,false)
    GUI:SetActive(self.view.text27,false)
end
function this:hideMainPanel()
    GUI:SetActive(self.view.scrollviewMain,false)
    --GUI:SetActive(self.view.text27,true)
    GUI:SetActive(self.view.text1,true)
    GUI:SetActive(self.view.Btn_RefineMain,false)
end
---刷新副装备
function this:RefreshAssistantEquip(equip)
    if self.assistantEquip and equip then
        SL:TipMessage("请先卸下装备", 1, NoticeType.NoticeMid)
        return
    end
    self.assistantEquip = equip
    GUI:Item_setItemId(self.view.item_assistantEquip, equip and equip.cfgId or 0)
    --GUI:setVisible(self.view.img_equip_target_add, self.mainEquip ~= nil and self.assistantEquip == nil)
    GUI:setColor(self.view.img_equip_target_add, self.mainEquip ~= nil and self.assistantEquip == nil and "#FFFFFF" or "#FFFFFF00")
    GUI:setVisible(self.view.text27, self.assistantEquip == nil)
    GUI:Text_setText(self.view.Text_AssistantEquipName, self.assistantEquip and SL:GetEquipValue(EMetaVarGetKey.EQUIP_NAME, nil, equip.cfgId, nil) or "")
    self:RefreshRefineAtt(self.assistantEquip == nil)
    self:RefreshNeedMats(self.assistantEquip == nil)
    self:RefreshShowItems()
    self:RefreshUIState()
end

---刷新洗练属性
function this:RefreshRefineAtt(isNull)
    self.attList = {}
    if not isNull then
        local previewAtt = {}
        ---@type cfg_equip_refine_column
        local refineCfgs = SL:GetConfigFieldToList("cfg_equip_refine", "id", self.mainEquip.cfgId)
        local _, refineCfg = self:CheckAssistantEquip(self.assistantEquip, refineCfgs, SL:GetConfig("cfg_item", self.assistantEquip.cfgId), true)
        local attGroupKey = {}
        for i, v in pairs(refineCfg.att) do
            local key = refineCfg.att[i][1]
            if attGroupKey[key] == nil then
                local attCfgs = SL:GetConfigFieldToList("cfg_equip_att", "group", key)
                for _, k in pairs(attCfgs) do
                    table.insert(previewAtt, k)
                end
                attGroupKey[key] = true
            end
        end

        local entryAttr = SL:GetEquipValue(EMetaVarGetKey.EQUIP_ENTRY_ATTR, self.preEquipPos, self.mainEquip.cfgId, self.mainEquip.id)
        self.attList = {}
        for i, v in pairs(previewAtt) do
            local attInfo = {
                previewAtt = v,
            }
            if table.count(entryAttr) >= i then
                local entryId = entryAttr[i].entryId
                attInfo.curAtt = SL:GetConfig("cfg_equip_att", entryId)
            end
            
            table.insert(self.attList, attInfo)
        end
    end
    
    GUI:DataListUpdateData(self.view.DataList_Att)
end

---刷新需要的材料
function this:RefreshNeedMats(isNull)
    self.costList = {}
    if not isNull then
        local refineCfg = SL:GetConfig("cfg_equip_refine", self.mainEquip.cfgId)
        self.costList = refineCfg.cost
    end

    GUI:DataListUpdateData(self.view.DataList_Cost)
end

---刷新显示的装备
function this:RefreshShowItems()
    if not self.isOpenBag then
        return
    end
    self:GetShowItems()
    self.bagUI:RefreshBagItemShow(self.showItemList)
end

---获取显示的装备
function this:GetShowItems()
    local data = {}
    self.bagItems = {}
    local bagItemTabl = SL:GetMetaValue("BAG_DATA")[1]
    if self.mainEquip == nil then
        local career = SL:MeData_GetCareer()
        for _, v in pairs(bagItemTabl) do
            if SL:HasConfig("cfg_equip_refine", v.cfgId) and self:CheckMainEquipCareer(SL:GetConfig("cfg_item", v.cfgId), career) then
                table.insert(data, v)
                table.insert(self.bagItems, v.id)
            end
        end
    else
        local itemCfg
        ---@type cfg_equip_refine_column[]
        local refineCfgs = SL:GetConfigFieldToList("cfg_equip_refine", "id", self.mainEquip.cfgId) -- 注意处理同key多个配置
        for _, v in pairs(bagItemTabl) do
            itemCfg = SL:GetConfig("cfg_item", v.cfgId)
            if self:CheckAssistantEquip(v, refineCfgs, itemCfg) then
                table.insert(data, v)
                table.insert(self.bagItems, v.id)
            end
        end
    end

    data = SL.Bag:SortItemList(data)
    self.showItemList = data

    return data
end

---装备取消
function this:EquipCancel(index)
    if index == 1 then
        if self.mainEquip then
            self:RefreshMainEquip(nil)
            self:RefreshAssistantEquip(nil)
        end
    else
        if self.assistantEquip then
            self:RefreshAssistantEquip(nil)
--[[            if self.mainEquip then
                self:showMainPanel()
            end]]
        end
    end
end

---检查主装备职业
function this:CheckMainEquipCareer(cfg, career)
    for i, v in pairs(cfg.job) do
        if v[1] == career.baseCareer and v[2] <= career.careerRank then
            return true
        end
    end
    return false
end

---检查副装备
---@param refineCfgs cfg_equip_refine_column[]
function this:CheckAssistantEquip(equip, refineCfgs, itemCfg, ignoreAssistantEquip)
    ignoreAssistantEquip = ignoreAssistantEquip or false
    if equip.id == self.mainEquip.id or (self.assistantEquip and (not ignoreAssistantEquip and equip.id == self.assistantEquip.id)) then
        return false
    end
    for i, refineCfg in pairs(refineCfgs) do
        if refineCfg.Consumption[1] == 1 then -- 消耗类型#装备品质（item-Outstanding）#装备最低品阶（item-rank）#装备最高品阶#职业id#基础职业
            if itemCfg.Outstanding == refineCfg.Consumption[2] and
             itemCfg.rank >= refineCfg.Consumption[3] and
             itemCfg.rank <= refineCfg.Consumption[4] and
             self.CheckEquipCareer(refineCfg.Consumption, itemCfg) then
                return true, refineCfg
            end
        else
            if GUIUtil.ItemEquals(refineCfg.Consumption[2], equip.cfgId) then
                return true, refineCfg
            end
            --[[if refineCfg.Consumption[2] == equip.cfgId then
                return true, refineCfg
            end]]
        end
    end
    return false
end

---检查装备职业
function this.CheckEquipCareer(consumption, itemCfg)
    if consumption[5] == 0 and consumption[6] == 0 then
        return true
    end
    for i, v in pairs(itemCfg.job) do
        if consumption[5] == v[1] and consumption[6] >= v[2] then -- 基础职业#职业等级，职业等级可以向下兼容
            return true
        end
    end
    return false
end

function this:RefreshUIState()
    GUI:setVisible(self.view.AttTitle, self.assistantEquip ~= nil)
    GUI:setVisible(self.view.NeedMatTitle, self.assistantEquip ~= nil)
    GUI:setVisible(self.view.Btn_Refine, self.assistantEquip ~= nil)
    GUI:setVisible(self.view.Img_Tips, self.assistantEquip == nil)
end

--region 事件 

---点击关闭按钮
function this:OnClick_Btn_Close()
    GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipRefine/KLEquipRefinePanel")
    GUI:UIPanel_Close("dev/outui/Bag/Panel/KLStrengthBag/KLStrengthBagPanel")
end

---点击装备
function this:OnValueChange_Tog_Equip(_, data, args)
    local isOn = args[1]
    if isOn then
        if not self.isOpenBag then
            return
        end
        self.isOpenBag = false
        self:OpenEquipUIPanel()
        GUI:UIPanel_Close("dev/outui/Bag/Panel/KLStrengthBag/KLStrengthBagPanel")
    end
end

---点击背包
function this:OnValueChange_Tog_Bag(_, data, args)
    local isOn = args[1]
    if isOn then
        if self.isOpenBag then
            return
        end
        self.equipPanel = nil
        self.isOpenBag = true
        GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
        self.bagUI = GUI:UIPanel_Open("dev/outui/Bag/Panel/KLStrengthBag/KLStrengthBagPanel", nil, nil,
                         { x = -480, bagType = 1, itemList = self:GetShowItems(), itemClickCallBack = self.itemClickCallBack, callBackUI = self, needSelect = false })
    end
end

---点击主装备取消
function this:OnClick_Btn_MainEquipCancel()
    if self.mainEquip then
        local pos = "bag"
        local itemInfo = SL:GetPosItemInfo(pos, self.mainEquip.cfgId, self.mainEquip.id)
        if not itemInfo then
            pos = "equip"
        end
        SL:OpenTips(pos, self.mainEquip.cfgId, self.mainEquip.id, nil, nil, { hideComparsion = true, other = 1})
    end
end

---点击副装备取消
function this:OnClick_Btn_AssistantEquipCancel()
    if self.assistantEquip then
        local pos = "bag"
        local itemInfo = SL:GetPosItemInfo(pos, self.assistantEquip.cfgId, self.assistantEquip.id)
        if not itemInfo then
            pos = "equip"
        end
        SL:OpenTips(pos, self.assistantEquip.cfgId, self.assistantEquip.id, nil, nil, { hideComparsion = true, other = 2})
    end
end

---点击洗练
function this:OnClick_Btn_Refine()
    if self.mainEquip == nil or self.assistantEquip == nil then
        return
    end
    for i, v in pairs(self.costList) do
        if SL:GetBagItemCount(v[1]) < v[2] then
            SL:CommonItemGetPath(nil, v[1])
            return
        end
    end
    --- 主手非绑定，副手绑定
    if not EquipFunc.GetItemIsBind(self.mainEquip.cfgId, self.mainEquip) and EquipFunc.GetItemIsBind(self.assistantEquip.cfgId, self.assistantEquip) then
        SL:CommonTipsMessage({
                                 stringTblID = 68001,
                                 sureBtnText = "确定",
                                 callback = function()
                                     SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_EQUIP_REFINE, { firstItemId = self.mainEquip.id, secondItemId = self.assistantEquip.id })
                                 end;
                             })
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_EQUIP_REFINE, { firstItemId = self.mainEquip.id, secondItemId = self.assistantEquip.id })
end

---点击获取按钮
function this:OnClick_CostAddBtn(_, data)
    SL:CommonItemGetPath(nil, data.cfgId, nil, nil, self)
end

---点击装备
function this:LUA_EVENT_EQUIP_GRID_CLICK(_, index)
    local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, index)
    if index == E_AppearEquipType.Weapon and equip == nil then
        equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, E_AppearEquipType.TwoHandWeapon)
    end
    if self.mainEquip then
        if self.mainEquip.id == equip.id then
            SL:TipMessage("已经放置主装备", 1, NoticeType.NoticeMid)
        else
            SL:TipMessage("请先卸下主装备", 1, NoticeType.NoticeMid)
        end
        return
    end
    if equip then
        if SL:HasConfig('cfg_equip_refine', equip.cfgId) then
            self.bagIndex = nil
            self.equipIndex = index
            self.equipPanel:SetSelectIndex(index)
            self:ClickEquip(equip)
            return
        else
            SL:TipMessage(SL:GetConfig('cfg_string', 46002).text, 1, NoticeType.NoticeMid)--"该装备无法被洗练",
        end
    end
end

---洗练完成
function this:RES_EQUIP_REFINE_RESULT()
    SL:ScheduleOnce(0.1,function()
        self:EquipCancel(2)
        self:showMainPanel()
        self:RefreshRefineAttMain(self.mainEquip == nil)
        GUI:setVisible(self.view.Prefab_RefineComponent, false)
        GUI:setVisible(self.view.Prefab_RefineComponent, true)
    end)
end

---背包物品改变
function this:ResBagChangeMessage()
    GUI:DataListUpdateData(self.view.DataList_Cost)
end

--endregion

return this
