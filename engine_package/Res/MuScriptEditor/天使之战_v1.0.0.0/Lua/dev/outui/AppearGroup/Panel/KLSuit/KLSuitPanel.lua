---@class KLSuitPanel:UIKmlLuaPanelBase
---@field view KLSuitPanelView
local KLSuitPanel = class(UIKmlLuaPanelBase)
local this = KLSuitPanel
---@type table<number,cfg_fashion_column[]>
local grade2Tbls = {}

---@type table<number,KLSuitEquipItem>
local id2Item = {}

---@type number[]
local selectCfgIds = {}
---@type number[]
local showPreviewList = {}

---@type table<EEquipSlotType,number> <EEquipSlotType,cfgId>
local appearCfgIds = {}
---@type table<EEquipSlotType,number> <EEquipSlotType,cfgId>
local serverCfgIds = {}

---@type number[]
local stateCfgIds = {}

---是否是去保存
---@type boolean
local isToSave

---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.loopscrollviewData,
            function()
                return self:ItemCountFunc()
            end,
            function(realIndex)
                return self:ItemGetFunc(realIndex)
            end,
            function(realIndex, kmlCtrl)
                return self:ItemInitFunc(realIndex, kmlCtrl)
            end,
            function(realIndex, kmlCtrl)
                return self:ItemUpdateFunc(realIndex, kmlCtrl)
            end,
            function(realIndex)
                return self:ItemSizeGetFunc(realIndex)
            end
    )

    self.Part_ITEM_H = 72

    self.Page_Width = GUI:GetWidth(self.view.loopscrollview)
    self.PAGE_EXT_H = 40
    ---@type table<KingML.KmlControl,KLSuitItem>
    self.partItems = {}
end

function this:ItemCountFunc()
    return #self.partData
end


function this:ItemGetFunc()
    ---@type KLSuitItem
    local item = GUI:UIPanel_Open("dev/outui/AppearGroup/Item/KLSuit/KLSuitItem", self.view.loopscrollviewData, self, nil, true)

    
    local kmlCtrl = item.view.root
    self.partItems[kmlCtrl] = item
    return kmlCtrl
end

function this:ItemInitFunc()
end

---@param realIndex number
---@param kmlCtrl KingML.KmlControl
function this:ItemUpdateFunc(realIndex, kmlCtrl)
    local item = self.partItems[kmlCtrl]
    local luaIndex = realIndex + 1
    local grade = self.partData[luaIndex]
    local titleStr = SL:NumberToChinese(grade) .. "阶卓越套装"
    item:UpdateUI(appearCfgIds, stateCfgIds, grade2Tbls[grade], titleStr, self.itemY, luaIndex)

end

---@param realIndex number
function this:ItemSizeGetFunc(realIndex)
    local luaIndex = realIndex + 1
    local slot = self.partData[luaIndex]
    local equipCount = #grade2Tbls[slot]

    local line = math.ceil(equipCount / 4)
    self.itemY = line * self.Part_ITEM_H + (line - 1) * 4 + self.PAGE_EXT_H
    return Vector2(self.Page_Width, self.itemY)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:onLUAEvent(APPEAR_PREVIEW_SELECT_CHANGE)
    self:AnalysisEquipData()
    SL:SendLuaNetMsg(LuaMessageIdToSever.GET_EQUIP_APPEAR)
end

function this:AnalysisEquipData()
    self.partData = {}
    grade2Tbls = {}

    ---@type cfg_fashion_column[]
    local tbl = SL:GetConfigTable('cfg_fashion')

    ---@type cfg_career_column
    local meCareer = SL:GetMetaValue(EMetaVarGetKey.ME_CAREER_TAB_COLUMN)

    local meLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    for _, fashTbl in pairs(tbl) do
        if table.contains(fashTbl.type, E_FashionType.Change) and (#fashTbl.job == 0 or table.contains(fashTbl.job, meCareer.baseCareer)) and fashTbl.level <= meLevel then

            if not grade2Tbls[fashTbl.grade] then
                grade2Tbls[fashTbl.grade] = {}
            end
            table.insert(grade2Tbls[fashTbl.grade], fashTbl)

            if not table.contains(self.partData, fashTbl.grade) then
                table.insert(self.partData, fashTbl.grade)
            end
        end
    end

    table.sort(self.partData)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.BtnClose, self, self.BtnCloseOnClick)
    GUI:AddOnClickEvent(self.view.BtnCancel, self, self.BtnCancelOnClick)
    GUI:AddOnClickEvent(self.view.BtnSure, self, self.BtnSureOnClick)
    GUI:AddOnClickEvent(self.view.BtnHelp, self, self.BtnHelpOnClick)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.GET_EQUIP_APPEAR, self.GET_EQUIP_APPEAR, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_EQUIP_FASHION, self.RES_EQUIP_FASHION, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ACT_EQUIP_FASHION, self.RES_ACT_EQUIP_FASHION, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_SETTING_EQUIP_APPEAR, self.RES_SETTING_EQUIP_APPEAR, self)

    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE, self.OnMeLevelChange,self)
end

function this:OnMeLevelChange()
    self:AnalysisEquipData()
    GUI:DataListUpdateData(self.view.loopscrollviewData)
end

function this:BtnHelpOnClick()
    local helpCfg = SL:GetConfig("cfg_rule_text", 203)
    if helpCfg then
        SL:CommonStrTipsMessage({ title = helpCfg.menutxt, str = helpCfg.location })
    end
end


--保存设置成功
---@param message {slot:EEquipSlotType,cfgId:number}[]
function this:RES_SETTING_EQUIP_APPEAR(_, message)
    table.clear(appearCfgIds)
    table.clear(serverCfgIds)
    table.clear(showPreviewList)
    for slot, cfgId in pairs(message) do
        slot = tonumber(slot)
        appearCfgIds[slot] = cfgId
        serverCfgIds[slot] = cfgId
        table.insert(showPreviewList, cfgId)
    end
end

--激活成功
---@param message number[]
function this:RES_ACT_EQUIP_FASHION(_, message)
    if not message then return end
    table.clear(stateCfgIds)
    for _, cfgId in pairs(message) do
        table.insert(stateCfgIds, cfgId)
        local isHave = SL:GetMetaValue(EMetaVarGetKey.EQUIP_CHECK_EXIST_CFG, cfgId)
        if not isHave then
            table.removeByValue(showPreviewList, cfgId)
        end

        table.removeByValue(selectCfgIds, cfgId)
        table.removeByKeyValue(appearCfgIds, cfgId)
    end

    SL:onLUAEvent(APPEAR_PREVIEW_SELECT_CHANGE, showPreviewList)
    GUI:DataListUpdateData(self.view.loopscrollviewData)

end

--返回幻化激活状态
---@param message number[]
function this:RES_EQUIP_FASHION(_, message)
    table.clear(stateCfgIds)
    if message then
        for _, v in pairs(message) do
            table.insert(stateCfgIds, v)
        end
    end
    GUI:DataListUpdateData(self.view.loopscrollviewData)
end

--返回外观
---@param message {slot:EEquipSlotType,cfgId:number}[]
function this:GET_EQUIP_APPEAR(_, message)
    if not message then return end

    table.clear(appearCfgIds)
    table.clear(serverCfgIds)
    table.clear(showPreviewList)
    for _, kp in pairs(message) do
        local slot = tonumber(kp.slot)
        appearCfgIds[slot] = kp.cfgId
        serverCfgIds[slot] = kp.cfgId
        table.insert(showPreviewList, kp.cfgId)
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_EQUIP_FASHION)

end

function this:BtnSureOnClick()
    if isToSave then
        SL:CommonTipsMessage({
            stringTblID = 209,
            titlePos = {x= 0,y=-26},
            title = "提示",
            callback = function()
                ---@type {slot:number,cfgId:number}[]
                local dt = {}

                for slot, cfgId in pairs(appearCfgIds) do
                    table.insert(dt, { slot = slot, cfgId = cfgId })
                end

                SL:SendLuaNetMsg(LuaMessageIdToSever.SETTING_EQUIP_APPEAR, { equipindex = dt, isUpdateView = true })
                self:BtnCloseOnClick()
            end

        })

    else
        if #selectCfgIds == 0 then
            SL:TipMessage( SL:GetConfig('cfg_string', 254).text, 1, NoticeType.NoticeMid )-- "请选择激活道具", 
            return
        end
        GUI:UIPanel_Open("dev/outui/AppearGroup/Panel/KLAppearCost/KLAppearCostPanel", nil, nil, selectCfgIds)
    end
end

function this:BtnCancelOnClick()
    return self:BtnCloseOnClick()
end

function this:BtnCloseOnClick()
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLSuit/KLSuitPanel")
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppearGroup/KLAppearGroupPanel")
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppearPreview/KLAppearPreviewPanel")

end

function this:Close()
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppearCost/KLAppearCostPanel")
    table.clear(selectCfgIds)
end

---@param equipItem KLSuitEquipItem
function this:OnEquipItemSelect(equipItem, suitIndex, suitEquipIndex, isUnlocked)
    local grade = self.partData[suitIndex]
    local itemId = grade2Tbls[grade][suitEquipIndex].id
    ---@type cfg_item_column
    local itemTbl = SL:GetConfig("cfg_item", itemId)
    local part = itemTbl.strPart[1]

    local isDel = table.contains(selectCfgIds, itemId)
    local isHave = SL:GetMetaValue(EMetaVarGetKey.EQUIP_CHECK_EXIST_CFG, itemId)

    if isUnlocked then
        --点击的是已激活的，将选中的未激活的清理掉,将列表中的同部位的装备去掉,该点击放到即将保存列表列表，
        --GUI:Text_setString(self.view.BtnSure, "保存")
        GUI:Button_loadTextureNormal(self.view.BtnSure, "btn_baocun", "Atlas/FG_Common.spriteatlas")

        if isDel then
            table.removeByValue(selectCfgIds, itemId)
            if id2Item[itemId] then
                id2Item[itemId]:SetState(false)
                id2Item[itemId] = nil
            end

            if serverCfgIds[part] and serverCfgIds[part] ~= itemId then
                appearCfgIds[part] = serverCfgIds[part]
            else
                appearCfgIds[part] = nil
            end

            if not isHave then
                table.removeByValue(showPreviewList, itemId)
                if serverCfgIds[part] and not table.contains(showPreviewList, serverCfgIds[part]) then
                    table.insert(showPreviewList, serverCfgIds[part])
                end
            end

        else
            for i = #selectCfgIds, 1, -1 do
                local cfgId = selectCfgIds[i]
                ---@type cfg_item_column
                local tmpTbl = SL:GetConfig("cfg_item", cfgId)
                local tmpPart = tmpTbl.strPart[1]
                if not table.contains(stateCfgIds, cfgId) then
                    if id2Item[cfgId] then
                        id2Item[cfgId]:SetState(false)
                        id2Item[cfgId] = nil
                    end

                    table.remove(selectCfgIds, i)

                    if tmpPart == part then
                        table.removeByValue(showPreviewList, cfgId)
                    else
                        local isEquip = SL:GetMetaValue(EMetaVarGetKey.EQUIP_CHECK_EXIST_CFG, cfgId)
                        if not isEquip then
                            table.removeByValue(showPreviewList, cfgId)
                        end
                    end
                elseif tmpPart == part then
                    if id2Item[cfgId] then
                        id2Item[cfgId]:SetState(false)
                        id2Item[cfgId] = nil
                    end

                    table.remove(selectCfgIds, i)
                    table.removeByValue(showPreviewList, cfgId)
                end
            end

            table.insert(selectCfgIds, itemId)
            id2Item[itemId] = equipItem
            equipItem:SetState(true)

            --将外观列表 appearCfgIds 中的同部位的装备替换
            appearCfgIds[part] = itemId

            if not table.contains(showPreviewList, itemId) then
                table.insert(showPreviewList, itemId)
            end
        end

        isToSave = true
    else
        --点击的也是未激活的， 将所有选中的已激活清理掉,该点击放到即将激活列表，并且将列表中的同部位的装备去掉
        --GUI:Text_setString(self.view.BtnSure, "激活")
        GUI:Button_loadTextureNormal(self.view.BtnSure, "btn_common_1_select", "Atlas/FG_Common.spriteatlas")

        if isDel then
            table.removeByValue(selectCfgIds, itemId)
            if id2Item[itemId] then
                id2Item[itemId]:SetState(false)
                id2Item[itemId] = nil
            end

            if not isHave then
                table.removeByValue(showPreviewList, itemId)
                if serverCfgIds[part] and not table.contains(showPreviewList, serverCfgIds[part]) then
                    table.insert(showPreviewList, serverCfgIds[part])
                end
            end

        else
            for i = #selectCfgIds, 1, -1 do
                local cfgId = selectCfgIds[i]
                ---@type cfg_item_column
                local tmpTbl = SL:GetConfig("cfg_item", cfgId)
                local tmpPart = tmpTbl.strPart[1]
                if table.contains(stateCfgIds, cfgId) then
                    if id2Item[cfgId] then
                        id2Item[cfgId]:SetState(false)
                        id2Item[cfgId] = nil
                    end

                    table.remove(selectCfgIds, i)
                    appearCfgIds[tmpPart] = nil

                    if tmpPart == part then
                        table.removeByValue(showPreviewList, cfgId)
                    else
                        local isEquip = SL:GetMetaValue(EMetaVarGetKey.EQUIP_CHECK_EXIST_CFG, cfgId)
                        if not isEquip then
                            table.removeByValue(showPreviewList, cfgId)
                        end
                    end
                elseif tmpPart == part then
                    if id2Item[cfgId] then
                        id2Item[cfgId]:SetState(false)
                        id2Item[cfgId] = nil
                    end

                    table.remove(selectCfgIds, i)
                    appearCfgIds[tmpPart] = nil
                    table.removeByValue(showPreviewList, cfgId)
                end
            end

            table.insert(selectCfgIds, itemId)
            id2Item[itemId] = equipItem
            equipItem:SetState(true)

            if not table.contains(showPreviewList, itemId) then
                table.insert(showPreviewList, itemId)
            end
        end
        isToSave = false
    end

    SL:onLUAEvent(APPEAR_PREVIEW_SELECT_CHANGE, showPreviewList)
end

return this
