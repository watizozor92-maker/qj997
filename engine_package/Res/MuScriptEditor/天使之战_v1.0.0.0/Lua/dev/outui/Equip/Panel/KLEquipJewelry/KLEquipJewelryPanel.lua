---@class KLEquipJewelryPanel:UIKmlLuaPanelBase
---@field view KLEquipJewelryPanelView
local KLEquipJewelryPanel = class(UIKmlLuaPanelBase)
local this = KLEquipJewelryPanel
---创建时调用一次
function this:Init()

    self.equipIndex = nil
    GUI:UIPanel_Open("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel", nil, nil,
            { x = -465, hideTips = true, callBack = self.CloseEquipUi, forgeGroupType = EForgeGroupType.Jewelry },true,
            function(panel)
                self.equipPanel = panel
                self:Refresh()
            end
    )
    self.OrnamentsGroupList = {}
    local ornamentsTbl = SL:GetConfigTable('cfg_equip_ornaments')
    for _, v in pairs(ornamentsTbl) do
        if not self.OrnamentsGroupList[v.ornamentsGroup] then
            self.OrnamentsGroupList[v.ornamentsGroup] = {}
        end
        table.insert(self.OrnamentsGroupList[v.ornamentsGroup], v)
    end
    self.AttTextList = {}
    GUI:DataListInitData(self.view.Attr_list, function()
        return table.count(self.AttTextList)
    end, function()
    end, function()
    end, function(realIndex)
        local strengthInfo = self.AttTextList[realIndex + 1]
        local name = strengthInfo['attrName']
        local preValue = strengthInfo['preValue']
        local nextValue = strengthInfo['nextValue']
        local arrowShow = strengthInfo['arrowShow']

        local attControl = GUI:GetChildControl(self.view.Attr_list, realIndex, 'attrName')
        local preControl = GUI:GetChildControl(self.view.Attr_list, realIndex, 'preValue')
        local nextControl = GUI:GetChildControl(self.view.Attr_list, realIndex, 'nextValue')
        local arrowControl = GUI:GetChildControl(self.view.Attr_list, realIndex, 'attrArrow')

        GUI:Text_setString(attControl, name)
        GUI:Text_setString(preControl, tostring(preValue))
        GUI:Text_setString(nextControl, tostring(nextValue))
        GUI:setVisible(arrowControl, arrowShow)
    end)
    self.ExceAttTextList = {}
    GUI:DataListInitData(self.view.Exce_list, function()
        return table.count(self.ExceAttTextList)
    end, function()
    end, function()
    end, function(realIndex)
        local strengthInfo = self.ExceAttTextList[realIndex + 1]
        local attrName = strengthInfo['attrName']
        local lv = strengthInfo['lv']
        local attrValue = strengthInfo['attrValue']
        local isActive = strengthInfo['isActive']
        local isUnlock = strengthInfo['isUnlock']
        local attShow = strengthInfo['attShow']

        local nameControl = GUI:GetChildControl(self.view.Exce_list, realIndex, 'ExceAttrName')
        local BtnControl = GUI:GetChildControl(self.view.Exce_list, realIndex, 'ExceActiveBtn')
        local LockControl = GUI:GetChildControl(self.view.Exce_list, realIndex, 'ExceLock')
        local activeTextControl = GUI:GetChildControl(self.view.Exce_list, realIndex, 'ActiveText')
        local exceActiveBtnRedPoint = GUI:GetChildControl(self.view.Exce_list, realIndex, 'ExceActiveBtnRedPoint')

        GUI:SetActive(exceActiveBtnRedPoint, InfoManager.equipJewelryInfo:IsJewelryCanActive(self.equipInfo))

        if isActive then
            GUI:SetActive(LockControl, false)
            GUI:SetActive(BtnControl, false)
            GUI:SetActive(activeTextControl, true)
            if attShow == 0 then
                GUI:Text_setString(nameControl, string.format('<color="#4BA7E8">%s</color>', attrName))
            else
                GUI:Text_setString(nameControl, string.format('<color="#4BA7E8">%s</color>', attrName .. " +" .. attrValue))
            end

            GUI:Text_setString(activeTextControl, string.format('<color="#2a8430">%s</color>', ""))
        else
            if isUnlock then
                GUI:SetActive(LockControl, false)
                GUI:SetActive(BtnControl, true)
            else
                GUI:SetActive(LockControl, true)
                GUI:SetActive(BtnControl, false)
            end
            GUI:SetActive(activeTextControl, false)
            if attShow == 0 then
                GUI:Text_setString(nameControl, string.format('<color="#9b9b9b">%s</color>', attrName))
            else
                GUI:Text_setString(nameControl, string.format('<color="#9b9b9b">%s</color>', attrName .. " +" .. attrValue))
            end
        end
        GUI:AddOnClickEvent(BtnControl, self, self.ActiveBtn, { ExceAttTextList = self.ExceAttTextList, preLevel = self.preLevel, equipInfo = self.equipInfo })

    end)
    self.costList = {}
    GUI:DataListInitData(self.view.cost_List, function()
        return table.count(self.costList)
    end, function()
    end, function()
    end, function(realIndex)
        local costInfo = self.costList[realIndex + 1]
        local cfgId = costInfo['cfgId']
        local needCount = costInfo['needCount']

        local itemControl = GUI:GetChildControl(self.view.cost_List, realIndex, 'cost_item')
        local nameControl = GUI:GetChildControl(self.view.cost_List, realIndex, 'cost_name')
        local numControl = GUI:GetChildControl(self.view.cost_List, realIndex, 'cost_num')
        local costAddBtn = GUI:GetChildControl(self.view.cost_List, realIndex, 'costAddBtn')

        if SL:GetConfig('cfg_item', cfgId) == nil then
            return
        end
        GUI:Item_setItemId(itemControl, cfgId)

        local name = SL:GetConfig('cfg_item', cfgId).name
        GUI:Text_setString(nameControl, name)

        local haveCount = SL:GetBagItemCount(cfgId)
        if haveCount < needCount then
            GUI:Text_setString(numControl, string.format('<color="#9b1818">%d</color>/%d', haveCount, needCount))
        else
            GUI:Text_setString(numControl, string.format('<color="#5CE366FF">%d</color>/%d', haveCount, needCount))
        end

        GUI:AddOnClickEvent(costAddBtn, self, self.costAddBtn, { cfgId = cfgId })

    end)
end
function this:costAddBtn(control, eventData)
    local cfgId = eventData.cfgId
    SL:CommonItemGetPath(nil, cfgId)
end
function this:ActiveBtn(control, eventData)
    GUI:UIPanel_Open("dev/outui/Equip/Panel/KLEquipJewelryActive/KLEquipJewelryActivePanel", nil, nil,
            { ExceAttTextList = eventData.ExceAttTextList, preLevel = eventData.preLevel, equipInfo = eventData.equipInfo })
end
function this.CloseEquipUi()
    GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipJewelry/KLEquipJewelryPanel")
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if not self.equipPanel then
        return
    end
    GUI:setVisible(self.view.success_ok, false)
    GUI:setVisible(self.view.bg2, false)
    GUI:setVisible(self.view.tips, true)
    local equipAll = SL:GetMetaValue(EMetaVarGetKey.EQUIP_DATA)
    if equipAll and equipAll[1] and next(equipAll[1]) then
        for i, v in pairs(equipAll[1]) do
            for _, j in pairs(E_JewelryEquipType) do
                if i == j then
                    self:LUA_EVENT_EQUIP_GRID_CLICK(_, i)
                    return
                end
            end
        end
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_EQUIP_GRID_CLICK, self.LUA_EVENT_EQUIP_GRID_CLICK, self)
    GUI:AddOnClickEvent(self.view.CloseBtn, self, self.CloseEquipUi)
    GUI:AddOnClickEvent(self.view.LevelButton, self, self.LevelButtonOnClick)
    GUI:AddOnClickEvent(self.view.item_model, self, self.item_modelOnClick)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_UPDATE_EQUIP_ORNAMENTS, self.RES_UPDATE_EQUIP_ORNAMENTS, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ACT_EQUIP_ORNAMENTS, self.RES_ACT_EQUIP_ORNAMENTS, self)
    --SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
    --SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.LUA_EVENT_MONEYCHANGE, self)

    SL:RegisterLUAEvent(LUA_EVENT_FORGE_GROUP_PANEL_CLOSE, self.CloseEquipUi, self)
end

function this:item_modelOnClick()
    SL:OpenTips("equip", self.equipInfo.cfgId, self.equipInfo.id, nil, self.equipInfo, { hideBtn = true })
end

function this:LUA_EVENT_BAG_CHANGE_AFTER(_, message)
    if not message then
        return
    end
    if not self.equipInfo then
        return
    end
    ----加载升级消耗
    self:SetLevelUpCost(self.equipInfo, self.preLevel)

    if self.delayUpdt then
        SL:UnSchedule(self.delayUpdt)
        self.delayUpdt = nil
    end
    self.delayUpdt = SL:ScheduleOnce(0.5, function()
        self.equipPanel:UpdateAllItem()
        GUI:DataListUpdateData(self.view.Exce_list)
        SL:RefreshPanelALLRedPoint("KLUIForgeGroupPanel")
    end)

end

function this:LUA_EVENT_MONEYCHANGE(_, message)
    if not self.equipInfo then
        return
    end
    ----加载升级消耗
    self:SetLevelUpCost(self.equipInfo, self.preLevel)

    if self.delayUpdt then
        SL:UnSchedule(self.delayUpdt)
        self.delayUpdt = nil
    end
    self.delayUpdt = SL:ScheduleOnce(0.3, function()
        self.equipPanel:UpdateAllItem()
        SL:RefreshPanelALLRedPoint("KLUIForgeGroupPanel")
    end)
end

---@param message RES_UPDATE_EQUIP_ORNAMENTS
function this:RES_ACT_EQUIP_ORNAMENTS(_, message)
    if message then
        local firstUnlock = false
        for _, v in pairs(self.ExceAttTextList) do
            for _, j in pairs(message.ssactlv) do
                if tonumber(j) == v.lv then
                    v.isActive = true
                end
            end
            if v.isActive == false and not firstUnlock then
                ---第一个未激活的解锁
                firstUnlock = true
                v.isUnlock = true
            end
        end

        if self.delayUpdt then
            SL:UnSchedule(self.delayUpdt)
            self.delayUpdt = nil
        end
        self.delayUpdt = SL:ScheduleOnce(0.3, function()
            GUI:DataListUpdateData(self.view.Exce_list)
            SL:onLUAEvent(LUA_EVENT_JEWELRY_CHANGE, self.equipInfo)
            SL:RefreshPanelALLRedPoint("KLUIForgeGroupPanel")
            self.equipPanel:UpdateAllItem()
        end)
    end
end
---@param message RES_UPDATE_EQUIP_ORNAMENTS
function this:RES_UPDATE_EQUIP_ORNAMENTS(_, message)
    GUI:setVisible(self.view.success_ok, false)
    if message then
        GUI:setVisible(self.view.success_ok, true)
        if self.equipInfo.id == message.itemId then
            self.OutEquipData = message
        end
        self:ClickEquip(self.equipInfo)
        SL:onLUAEvent(LUA_EVENT_JEWELRY_CHANGE, self.equipInfo)
        SL:RefreshPanelALLRedPoint("KLUIForgeGroupPanel")
        self.equipPanel:UpdateAllItem()
        if self.equipIndex then
            self.equipPanel:SetSelectIndex(self.equipIndex)
        end
    end
end
function this:LevelButtonOnClick()
    if not self.isHaveLevelCount then
        SL:TipMessage(SL:GetConfig('cfg_string', 260).text, 1, NoticeType.NoticeMid)--"材料不足！",
        SL:CommonItemGetPath(nil, self.levelCfgId)
    else
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UPDATE_EQUIP_ORNAMENTS, { itemId = self.equipInfo.id })
    end

end
function this:LUA_EVENT_EQUIP_GRID_CLICK(_, index)
    ---@type CommonProtos.Item
    local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, index)
    if index == E_AppearEquipType.Weapon and equip == nil then
        equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, E_AppearEquipType.TwoHandWeapon)
    end
    if equip then
        ---@type RES_UPDATE_EQUIP_ORNAMENTS
        self.OutEquipData = SL:JsonDecode(equip.luaExtData, false)---json.decode(equip.luaExtData)
        if SL:HasConfig('cfg_equip_ornamentsMain', equip['cfgId']) then
            local ornament_tbl = SL:GetConfig('cfg_equip_ornamentsMain', equip['cfgId'])
            if ornament_tbl then
                self.equipIndex = index
                if self.equipPanel then
                    self.equipPanel:SetSelectIndex(self.equipIndex)
                end
                self.equipInfo = equip
                self:ClickEquip(equip)
                return
            end
        else
            SL:TipMessage(SL:GetConfig('cfg_string', 261).text, 1, NoticeType.NoticeMid)--"请选择首饰装备！",
        end
    end
end
---@param equipInfo CommonProtos.Item
function this:ClickEquip(equipInfo)
    if self.OutEquipData == nil or (self.OutEquipData and not self.OutEquipData.ssuplv) then
        self.preLevel = 0
    else
        self.preLevel = tonumber(self.OutEquipData.ssuplv)
    end
    local PreOrnament_Tbl = self:GetJewelryTblInfoByLevel(equipInfo.cfgId, self.preLevel)
    local NextOrnament_Tbl = self:GetJewelryTblInfoByLevel(equipInfo.cfgId, self.preLevel + 1)
    ---@type cfg_item_column
    local itemTbl = SL:GetConfig("cfg_item", equipInfo.cfgId)
    if PreOrnament_Tbl then
        local nextLevel = ""
        if NextOrnament_Tbl then
            nextLevel = self.preLevel + 1
        end
        GUI:setVisible(self.view.bg2, true)
        GUI:setVisible(self.view.tips, false)
        if nextLevel == "" then
            GUI:Text_setString(self.view.preLevel, "+" .. self.preLevel)
            GUI:Text_setString(self.view.nextLevel, "")
            GUI:SetActive(self.view.arrow, false)
            GUI:SetActive(self.view.Material, false)
            GUI:SetActive(self.view.LevelButton, false)
            GUI:SetActive(self.view.maxLevelTips, true)
            GUI:SetActive(self.view.maxLevelTips, true)
        else
            GUI:Text_setString(self.view.preLevel, "+" .. self.preLevel)
            GUI:Text_setString(self.view.nextLevel, "+" .. nextLevel)
            GUI:SetActive(self.view.arrow, true)
            GUI:SetActive(self.view.Material, true)
            GUI:SetActive(self.view.LevelButton, true)
            GUI:SetActive(self.view.maxLevelTips, false)
            ----加载升级消耗
            self:SetLevelUpCost(equipInfo, self.preLevel)
        end

        GUI:Text_setString(self.view.equipName, itemTbl.name .. "(" .. self.preLevel .. "级)")
        ---@type cfg_color_column
        local colorCfg = SL:GetConfig("cfg_color", itemTbl.color)
        GUI:Text_setTextColor(self.view.equipName, colorCfg.color)
        ----加载上面模型
        self:SetEquipModel(equipInfo.cfgId)
        ----加载基础属性
        self:SetAttrInfo(PreOrnament_Tbl, NextOrnament_Tbl)
        ----加载卓越属性
        self:SetExcellenceAttrInfo(equipInfo.cfgId)
    end
end
function this:SetEquipModel(cfgId)
    GUI:setVisible(self.view.item_model, true)
    GUI:Item_setItemId(self.view.item_model, cfgId)
    GUI:setScale(self.view.item_model, 2)
    GUI:setPosition(self.view.item_model, 0, -50)
end
function this:SetLevelUpCost(equipInfo, level)
    self.costList = {}
    self.isHaveLevelCount = true
    local ornament_tbl = self:GetJewelryTblInfoByLevel(equipInfo.cfgId, level)
    if next(ornament_tbl.lvDeplete) then
        for _, attrValue in pairs(ornament_tbl.lvDeplete) do
            local tbl = {}
            tbl = {
                cfgId = tonumber(attrValue[1]),
                needCount = tonumber(attrValue[2])
            }
            local haveCount = SL:GetBagItemCount(tbl.cfgId)
            local needCount = tbl.needCount
            if haveCount < needCount then
                self.isHaveLevelCount = false
                self.levelCfgId = tbl.cfgId
            end
            table.insert(self.costList, tbl)
        end
    end
    GUI:SetActive(self.view.LevelButtonRedPoint,
            InfoManager.equipJewelryInfo:IsJewelryCanUpLevel(self.equipInfo))
    GUI:DataListUpdateData(self.view.cost_List)
end
function this:SetExcellenceAttrInfo(cfgId)
    self.ExceAttTextList = {}
    local firstUnlock = false
    local ornament_tbl = SL:GetConfig('cfg_equip_ornamentsMain', cfgId)
    if ornament_tbl.ornamentsGroup and self.OrnamentsGroupList[ornament_tbl.ornamentsGroup] then
        for i, v in pairs(self.OrnamentsGroupList[ornament_tbl.ornamentsGroup]) do
            if next(v.excellenceAtt) then
                for _, attrValue in pairs(v.excellenceAtt) do
                    local attrName = SL:GetConfig("cfg_att_info", tonumber(attrValue[1])).name
                    local att_remark = SL:GetConfig("cfg_att_info", tonumber(attrValue[1])).remarks
                    local att_show = SL:GetConfig("cfg_att_info", tonumber(attrValue[1])).attShow
                    local att_Value = attrValue[2]
                    local isActive = false  --是否激活
                    local isUnlock = false  ---是否解锁
                    if self.OutEquipData and self.OutEquipData.ssactlv then
                        for _, data in pairs(self.OutEquipData.ssactlv) do
                            if tonumber(data) == v.lv then
                                isActive = true
                            end
                        end
                    end
                    if isActive == false and not firstUnlock then
                        ---第一个未激活的解锁
                        firstUnlock = true
                        isUnlock = true
                    end
                    local tbl = {}
                    if att_remark == 1 then
                        tbl = {
                            attrName = attrName,
                            attrValue = tostring(att_Value),
                            lv = v.lv,
                            unlockDeplete = v.unlockDeplete,
                            isActive = isActive,
                            isUnlock = isUnlock,
                            attShow = att_show
                        }
                    else
                        tbl = {
                            attrName = attrName,
                            attrValue = tonumber(att_Value) / 100 .. '%',
                            lv = v.lv,
                            unlockDeplete = v.unlockDeplete,
                            isActive = isActive,
                            isUnlock = isUnlock,
                            attShow = att_show
                        }
                    end
                    table.insert(self.ExceAttTextList, tbl)
                end
            end
        end
    end
    GUI:DataListUpdateData(self.view.Exce_list)
end
function this:SetAttrInfo(PreOrnament_Tbl, NextOrnament_Tbl)
    self.AttTextList = {}
    local AtkSpecialTbl = InfoManager.equipJewelryInfo:GetAttrJewelSpecialTbl(ESpecialAttrID.minAtk, ESpecialAttrID.maxAtk, PreOrnament_Tbl, NextOrnament_Tbl, "攻 击 力")
    if AtkSpecialTbl then
        table.insert(self.AttTextList, AtkSpecialTbl)
    end
    for _, attrValue in pairs(PreOrnament_Tbl.basicAtt) do
        local attrId = attrValue[1]
        if not InfoManager.equipJewelryInfo:IsSpecialAttrId(attrId) then
            local name = SL:GetConfig("cfg_att_info", tonumber(attrId)).name
            local att_remark = SL:GetConfig("cfg_att_info", tonumber(attrId)).remarks
            local att_Value = attrValue[2]
            local NextAttrValue = ""
            local arrowShow = true
            if NextOrnament_Tbl then
                for _, nextAttrvalue in pairs(NextOrnament_Tbl.basicAtt) do
                    if tonumber(nextAttrvalue[1]) == tonumber(attrValue[1]) then
                        NextAttrValue = nextAttrvalue[2]
                    end
                end
            end
            if NextAttrValue == "" then
                arrowShow = false
            end

            local tbl = {}
            if att_remark == 1 then
                tbl = {
                    attrName = name,
                    preValue = att_Value,
                    nextValue = NextAttrValue,
                    arrowShow = arrowShow
                }
            else
                tbl = {
                    attrName = name,
                    preValue = tonumber(att_Value) / 100 .. '%',
                    nextValue = NextAttrValue,
                    arrowShow = arrowShow
                }
            end
            table.insert(self.AttTextList, tbl)
        end
    end

    GUI:DataListUpdateData(self.view.Attr_list)
end

---@return cfg_equip_ornaments_column
function this:GetJewelryTblInfoByLevel(cfgId, Level)
    ---@type cfg_equip_ornamentsMain_column
    local ornament_tbl = SL:GetConfig('cfg_equip_ornamentsMain', cfgId)
    if ornament_tbl.ornamentsGroup and self.OrnamentsGroupList and self.OrnamentsGroupList[ornament_tbl.ornamentsGroup] then
        for _, v in pairs(self.OrnamentsGroupList[ornament_tbl.ornamentsGroup]) do
            if v.lv == tonumber(Level) then
                return v
            end
        end
    end
    return nil
end
function this:Close()
    if self.delayUpdt then
        SL:UnSchedule(self.delayUpdt)
        self.delayUpdt = nil
    end
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipJewelryActive/KLEquipJewelryActivePanel")
end

return this
