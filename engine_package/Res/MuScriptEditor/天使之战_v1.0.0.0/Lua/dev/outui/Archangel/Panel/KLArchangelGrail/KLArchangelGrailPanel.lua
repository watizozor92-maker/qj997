---@class KLArchangelGrailPanel:UIKmlLuaPanelBase
---@field view KLArchangelGrailPanelView
---@field isStrengthInfo boolean @
---@field isStrength boolean @注：由于强化成功有两个协议，考虑两个均返回后刷新
local KLArchangelGrailPanel = class(UIKmlLuaPanelBase)
local this = KLArchangelGrailPanel
function this:AsyncLoadUI()
end

local SendType = {
    UnFusion = enum(),
    Equip = enum(),
    Fusion = enum(),
    Strength = enum(),
}
---创建时调用一次
function this:Init()
    GUI:setVisible(self.view.equipatt_panel, false)
    self.strengthChange = {}
    self.isStrengthInfo = false
    self.isStrength = false
    self.equipGrailInfo = {}
    self.type = SendType.Equip
    self.isOther = self.args and self.args.isOther or false
    if self.args and self.args.z then
        GUI:setPositionZ(self.view.root, self.args.z)
    else
        GUI:setPositionZ(self.view.root, 0)
    end
    if self.isOther then

    else
        --GUI:UIPanel_Open("dev/outui/Archangel/Panel/KLArchangelGroup/KLArchangelGroupPanel")
        local equipPanel = GUI:GetUI("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
        if equipPanel then
            ---@type KLEquipUIPanel
            self.equipPanel = equipPanel
            self.equipPanel:SetSelfWearBarType(EEquipWearBarType.Archange)
        else
            self.equipPanel = GUI:UIPanel_Open("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel", nil, nil,
                { x = -465, hideTips = true, callBack = self.ClosePanel, }, false, function(equipPanelView)
                 self.equipPanel = equipPanelView
                 self.equipPanel:SetSelfWearBarType(EEquipWearBarType.Archange)
            end)
        end
    end
    self:InitDataList()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseButton, self, self.ClosePanel)
    GUI:AddOnClickEvent(self.view.item8, self, self.OpenEquip)
    GUI:AddOnClickEvent(self.view.strengthenBtn, self, self.Strengthen)
    GUI:AddOnClickEvent(self.view.btn_tips, self, self.BtnHelpOnClick)
    GUI:AddOnClickEvent(self.view.detail_bg, self, self.BtnHideSuitDetail)
    GUI:AddOnClickEvent(self.view.item_grail_tips, self, self.BtnGrailTipsOnClick)
    SL:RegisterLUAEvent(LUA_EVENT_EQUIP_GRID_CLICK, self.LUA_EVENT_EQUIP_GRID_CLICK, self)
    --SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GRAIL_FUSIBLE_INFO, self.RES_GRAIL_FUSIBLE_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GRAIL_ENTRY_INFO, self.RES_GRAIL_ENTRY_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_EQUIP_ALL_ENTRY_INFO, self.RES_EQUIP_ALL_ENTRY_INFO, self)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GRAIL_ENTRY_STRENGTHEN_RESULT, self.RES_GRAIL_ENTRY_STRENGTHEN_RESULT,
        self)
    SL:RegisterLUAEvent(LUA_EVENT_GRAIL_INFO_CHANGE, self.LUA_EVENT_GRAIL_INFO_CHANGE, self)
end

function this:RES_GRAIL_ENTRY_INFO(_, message)
    local attid = 0
    for i, v in pairs(self.equipGrailInfo) do
        if message[tostring(v.itemId)] then
            if self.type ~= SendType.UnFusion then
                v.attrInfo = message[tostring(v.itemId)]
                break
            end
            break
        end
    end
    if self.type == SendType.Fusion then
        -- 融合后的响应
        local data = self.equipGrailInfo[self.selectGrailIndex]
        --self.grailItemList[data.position]:UpdateUI({ itemCfgId = data.itemConfigId, id = data.itemId, holeIndex = data.position, isGray = false })
        self:RefreshGrail()
        self:GrailSelect(data.position, data.itemConfigId, data.itemId)
    elseif self.type == SendType.UnFusion then
        --self.grailItemList[self.unFusionHole]:UpdateUI({ holeIndex = self.unFusionHole, isGray = false })
        self.equipGrailInfo[self.unFusionHole] = nil
        GUI:setVisible(self.view.strength_panel, false)
        self:ShowEquipAtt()
        self:RefreshGrail()
        self:GrailSelect(self.unFusionHole)
    else
        self.isStrengthInfo = true
        self.strengthChange = {}
        if self.type == SendType.Strength then
            for _, v in pairs(message) do
                for _, k in pairs(v.secondary) do
                    for _, info in pairs(k) do
                        if info.attrId == "200011" then
                            if info.value ~= self.strengthQian["mAtt"].min then
                                table.insert(self.strengthChange, "200011")
                            end
                        elseif info.attrId == "200021" then
                            if info.value ~= self.strengthQian["mAtt"].max then
                                table.insert(self.strengthChange, "200021")
                            end
                        else
                            if info.value ~= self.strengthQian[info.id] then
                                table.insert(self.strengthChange, info.id)
                            end
                        end
                    end
                end
            end
        end
        if self.isStrength then
            -- 刷新UI
            self:GrailSelect(self.selectGrailIndex, self.selectGrail.cfgId, self.selectGrail.id)
        end
    end
    InfoManager.archangeEquipInfo:CheckEquipRed()
    InfoManager.archangeEquipInfo:CanStrengthGrail()
    local group = GUI:GetUI("dev/outui/Archangel/Panel/KLArchangelGroup/KLArchangelGroupPanel")
    if group then
        group:RefreshRed()
    end
    self:RefreshEquipWear()
    SL:onLUAEvent(LUA_EVENT_GRAIL_STRENGTH_SUCCESS_REFRESH_REDPOINT)
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self:IsSelectEquip(false)
    ---@type KLGrailItem[]
    self.grailItemList = {}
    self:RefreshUI()
end

function this:RefreshUI()
    ---刷新全部属性
    GUI:Image_loadTexture(self.view.img_attr_title, "equip_attr_suit", "Atlas/UIArchangelGrail.spriteatlas")
    GUI:setVisible(self.view.equip_top, false)
    GUI:setVisible(self.view.warning_img, false)
    self.equipAttinfo = {}
    local data = {}
    GUI:setVisible(self.view.equipatt_panel, true)
    GUI:setPositionY(self.view.equipatt_panel, 100)
    local attr_list
    if self.isOther then
        attr_list = InfoManager.archangeEquipInfo.otherGrailAllAttrList
    else
        attr_list = InfoManager.archangeEquipInfo:RefreshAllGrailAttrInfo()
    end

    if attr_list then
        for i, v in pairs(attr_list) do
            if data[tonumber(i)] then
                data[tonumber(i)].att = data[tonumber(i)].att + v
            else
                data[tonumber(i)] = {}
                data[tonumber(i)].att = v
            end
        end
        local minAtt, maxAtt
        for i, v in pairs(data) do
            if i == 200011 then
                minAtt = v.att
                if maxAtt then
                    table.insert(self.equipAttinfo, { key = "mAtt", id = i, max = maxAtt, min = minAtt, color = v.color })
                    minAtt = nil
                    maxAtt = nil
                end
            elseif i == 200021 then
                maxAtt = v.att
                if minAtt then
                    table.insert(self.equipAttinfo, { key = "mAtt", id = i, max = maxAtt, min = minAtt, color = v.color })
                    minAtt = nil
                    maxAtt = nil
                end
            else
                table.insert(self.equipAttinfo, { id = i, value = v.att, color = v.color })
            end
        end
    end
    if #self.equipAttinfo > 0 then
        GUI:setVisible(self.view.empty_attr_bg, false)
    else
        GUI:setVisible(self.view.empty_attr_bg, true)
    end
    GUI:DataListUpdateData(self.view.equip_att_list)

    ---刷新全部套装
    self.grailSuitList = {}
    ---@type cfg_equip_angelGrailSuit_column[]
    local suitTbl = SL:GetConfigTable("cfg_equip_angelGrailSuit")
    for _, v in ipairs(suitTbl) do
        if not self.grailSuitList[v.group] then
            self.grailSuitList[v.group] = {}
        end
        self.grailSuitList[v.group].name = v.mainName
        local info = self.grailSuitList[v.group].attr or {}
        local count
        if self.isOther then
            count = InfoManager.archangeEquipInfo:GetOtherGrailSuitCount(v.group, v.level)
        else
            count = InfoManager.archangeEquipInfo:GetGrailSuitCount(v.group, v.level)
        end
        for j, k in pairs(v.suitEffect) do
            if info[k[1]] then
                if count >= k[1] then
                    info[k[1]] = {}
                    info[k[1]].attrName = k[2]
                    info[k[1]].attrValue = k[3]
                    info[k[1]].color = E_ArchangelGrailQualityColor[v.level]
                end
            else
                info[k[1]] = {}
                info[k[1]].attrName = k[2]
                info[k[1]].attrValue = k[3]
                info[k[1]].color = k[1] <= count and E_ArchangelGrailQualityColor[v.level] or "#999999"
            end
        end
        self.grailSuitList[v.group].attr = info
    end
    GUI:DataListUpdateData(self.view.grail_all_suit_list)
end

function this:RefreshEquip()
    if not self.selectEquip then
        self:IsSelectEquip(false)
        return
    end
    self:IsSelectEquip(true)
    self:EquipItemShow()
    --请求装备信息
    self.type = SendType.Equip
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_EQUIP_ALL_ENTRY_INFO, self.selectEquip.id)
end

function this:RES_EQUIP_ALL_ENTRY_INFO(_, message)
    if self.type == SendType.Equip then
        self.equipGrailInfo = {}
        -- 选择装备后的请求
        for i, v in pairs(message) do
            self.equipGrailInfo[v.position] = v
        end
        self:RefreshGrail()
        self:ShowEquipAtt()
    elseif self.type == SendType.Fusion then
        -- 融合后的响应
        local data = message["1"]
        self.equipGrailInfo[data.position] = data
        --self.grailItemList[data.position]:UpdateUI({ itemCfgId = data.itemConfigId, id = data.itemId, holeIndex = data.position, isGray = false })
        InfoManager.archangeEquipInfo:GrailChange(self.selectEquip.id, data.position, data.itemConfigId, data.itemId)
        InfoManager.archangeEquipInfo:GrailInfoChange(data.itemId, message["1"])
        self:RefreshGrail()
        self:GrailSelect(data.position, data.itemConfigId, data.itemId)
    else
        --self.grailItemList[self.unFusionHole]:UpdateUI({ holeIndex = self.unFusionHole, isGray = false })
        self.equipGrailInfo[self.unFusionHole] = nil
        --local info = { equipId = self.selectEquip.id, gradePosition = self.unFusionHole }
        InfoManager.archangeEquipInfo:GrailChange(self.selectEquip.id, self.unFusionHole)
        self:RefreshGrail()
        self:GrailSelect(self.unFusionHole)
    end
    InfoManager.archangeEquipInfo:CheckEquipRed()
    local group = GUI:GetUI("dev/outui/Archangel/Panel/KLArchangelGroup/KLArchangelGroupPanel")
    if group then
        group:RefreshRed()
    end
    self:RefreshEquipWear()
end

function this:RefreshGrail()
    self.grailInfo = {}
    local equipInfo = InfoManager.archangeEquipInfo:GetEquipLevelInfo(self.selectEquip.id)
    local hole, max = self:GetHole(equipInfo.rank, self.selectEquip.cfgId)
    local tbl = {}
    for i, v in pairs(self.equipGrailInfo) do
        tbl[v.position] = { id = v.itemId, cfgId = v.itemConfigId }
    end

    for i = 1, max do
        local data = {}
        if i <= hole then
            -- 孔位解锁
            data.isGray = false
            if tbl[i] then
                -- 是否有圣杯
                data.itemCfgId = tbl[i].cfgId
                data.id = tbl[i].id
            end
        else
            data.isGray = true
        end
        data.holeIndex = i
        table.insert(self.grailInfo, data)
    end
    GUI:DataListUpdateData(self.view.grail_list, nil, function()
        self.isHideSelect = false
    end)
end

function this:AttShow(holeIndex)
    self.grailAttrInfo = {}
    GUI:setVisible(self.view.strength_panel, true)
    GUI:setVisible(self.view.equipatt_panel, false)
    for i, v in pairs(self.equipGrailInfo) do
        if v.position == holeIndex then
            local minAtt = nil
            local maxAtt = nil
            for _, att in pairs(v.attrInfo.main) do
                if tonumber(att.attrId) == 200011 then
                    minAtt = att.value
                    if maxAtt then
                        table.insert(self.grailAttrInfo,
                            { key = "mAtt", id = att.id, isMain = true, max = maxAtt, min = minAtt })
                        minAtt = nil
                        maxAtt = nil
                    end
                elseif tonumber(att.attrId) == 200021 then
                    maxAtt = att.value
                    if minAtt then
                        table.insert(self.grailAttrInfo,
                            { key = "mAtt", id = att.id, isMain = true, max = maxAtt, min = minAtt })
                        minAtt = nil
                        maxAtt = nil
                    end
                else
                    att.isMain = true
                    table.insert(self.grailAttrInfo, att)
                end
            end
            minAtt = nil
            maxAtt = nil
            for _, att in pairs(v.attrInfo.secondary) do
                for _, k in pairs(att) do
                    if tonumber(k.attrId) == 200011 then
                        minAtt = k.value
                        if maxAtt then
                            table.insert(self.grailAttrInfo,
                                { key = "mAtt", id = k.id, isMain = false, max = maxAtt, min = minAtt })
                            minAtt = nil
                            maxAtt = nil
                        end
                    elseif tonumber(k.attrId) == 200021 then
                        maxAtt = k.value
                        if minAtt then
                            table.insert(self.grailAttrInfo,
                                { key = "mAtt", id = k.id, isMain = false, max = maxAtt, min = minAtt })
                            minAtt = nil
                            maxAtt = nil
                        end
                    else
                        k.isMain = false
                        table.insert(self.grailAttrInfo, k)
                    end
                end
            end
        end
    end
    GUI:DataListUpdateData(self.view.grail_att_list, nil, function()
        self.strengthChange = {}
    end)
end

function this:ShowEquipAtt()
    self.equipAttinfo = {}
    if table.count(self.equipGrailInfo) == 0 then
        GUI:setVisible(self.view.strength_panel, false)
        GUI:setVisible(self.view.equipatt_panel, false)
        GUI:setVisible(self.view.warning_img, false)
        return
    end
    local data = {}
    GUI:setVisible(self.view.warning_img, false)
    GUI:setVisible(self.view.strength_panel, false)
    GUI:setVisible(self.view.equipatt_panel, true)
    for i, v in pairs(self.equipGrailInfo) do
        for _, k in pairs(v.attrInfo.main) do
            if data[tonumber(k.attrId)] then
                data[tonumber(k.attrId)].att = data[tonumber(k.attrId)].att + k.value
            else
                data[tonumber(k.attrId)] = {}
                data[tonumber(k.attrId)].att = k.value

                data[tonumber(k.attrId)].color = E_ArchangelGrailQualityColor
                    [SL:GetConfig("cfg_equip_angelEntry", k.id, "id").attQuality]
            end
        end
        if not v.attrInfo.secondary then
            v.attrInfo.secondary = {}
        end
        for _, k in pairs(v.attrInfo.secondary) do
            for _, j in pairs(k) do
                if data[tonumber(j.attrId)] then
                    data[tonumber(j.attrId)].att = data[tonumber(j.attrId)].att + j.value
                else
                    data[tonumber(j.attrId)] = {}
                    data[tonumber(j.attrId)].att = j.value
                    data[tonumber(j.attrId)].color = E_ArchangelGrailQualityColor
                        [SL:GetConfig("cfg_equip_angelEntry", j.id, "id").attQuality]
                end
            end
        end
    end
    local minAtt = nil
    local maxAtt = nil
    for i, v in pairs(data) do
        if i == 200011 then
            minAtt = v.att
            if maxAtt then
                table.insert(self.equipAttinfo, { key = "mAtt", id = i, max = maxAtt, min = minAtt, color = v.color })
                minAtt = nil
                maxAtt = nil
            end
        elseif i == 200021 then
            maxAtt = v.att
            if minAtt then
                table.insert(self.equipAttinfo, { key = "mAtt", id = i, max = maxAtt, min = minAtt, color = v.color })
                minAtt = nil
                maxAtt = nil
            end
        else
            table.insert(self.equipAttinfo, { id = i, value = v.att, color = v.color })
        end
    end
    GUI:DataListUpdateData(self.view.equip_att_list)
end

function this:EquipAttUpdateItem(realIndex, kmlcontrol)
    local data = self.equipAttinfo[realIndex + 1]
    local text = GUI:GetChildControl(self.view.equip_att_list, realIndex, "equip_att_text")
    local equip_value_text = GUI:GetChildControl(self.view.equip_att_list, realIndex, "equip_value_text")
    --GUI:Text_setTextColor(text, data.color)
    if data.key then
        if data.key == "mAtt" then
            GUI:Text_setString(text, "攻击力")
            GUI:Text_setString(equip_value_text, "+" .. tostring(data.min) .. "~" .. tostring(data.max))
        end
        return
    end
    local attTbl = SL:GetConfig("cfg_att_info", tonumber(data.id), "id")
    GUI:Text_setString(text, attTbl.name)
    local value
    if attTbl.remarks == 2 then
        value = "+" .. tostring(data.value / 100) .. "%"
    else
        value = "+" .. tostring(data.value)
    end
    GUI:Text_setString(equip_value_text, tostring(value))
end

function this:GrailSuitUpdateItem(realIndex, kmlCtrl)
    local suit_name = GUI:GetChildControl(self.view.grail_all_suit_list, realIndex, "suit_name")
    local suit_attr_1 = GUI:GetChildControl(self.view.grail_all_suit_list, realIndex, "suit_attr_1")
    local suit_attr_2 = GUI:GetChildControl(self.view.grail_all_suit_list, realIndex, "suit_attr_2")
    local suit_attr_3 = GUI:GetChildControl(self.view.grail_all_suit_list, realIndex, "suit_attr_3")
    local tipsBtn = GUI:GetChildControl(self.view.grail_all_suit_list, realIndex, "tipsBtn")

    local data = self.grailSuitList[realIndex + 1]
    GUI:Text_setString(suit_name, data.name)
    for i, v in pairs(data.attr) do
        ---@type cfg_att_info_column
        local tbl = SL:GetConfig("cfg_att_info", v.attrName)
        local value
        if tbl.remarks == 1 then
            value = v.attrValue
        else
            value = v.attrValue / 100 .. "%"
        end
        if i == 3 then
            GUI:Text_setString(suit_attr_1, "3件套:" .. tbl.name .. "+" .. value)
            GUI:Text_setTextColor(suit_attr_1, v.color)
        elseif i == 5 then
            GUI:Text_setString(suit_attr_2, "5件套:" .. tbl.name .. "+" .. value)
            GUI:Text_setTextColor(suit_attr_2, v.color)
        elseif i == 7 then
            GUI:Text_setString(suit_attr_3, "7件套:" .. tbl.name .. "+" .. value)
            GUI:Text_setTextColor(suit_attr_3, v.color)
        end
    end
    GUI:AddOnClickEvent(tipsBtn, self, self.ShowSuitDetail, realIndex + 1)
end

function this:GrailAttDataListUpdateFunc(realIndex, kmlcontrol)
    local att_text = GUI:GetChildControl(self.view.grail_att_list, realIndex, "att_text")
    local zhufu_img = GUI:GetChildControl(self.view.grail_att_list, realIndex, "zhufu_img")
    local max_att_text = GUI:GetChildControl(self.view.grail_att_list, realIndex, "max_att_text")
    local select_img = GUI:GetChildControl(self.view.grail_att_list, realIndex, "select_img")
    local bg_img = GUI:GetChildControl(self.view.grail_att_list, realIndex, "bg_img")
    local loadingbar_attr = GUI:GetChildControl(self.view.grail_att_list, realIndex, "loadingbar_attr")
    local data = self.grailAttrInfo[realIndex + 1]
    if data.isMain then
        GUI:Image_loadTexture(zhufu_img, "icon_zhu", "Atlas/UIArchangelGrail.spriteatlas")
    else
        GUI:Image_loadTexture(zhufu_img, "icon_fu", "Atlas/UIArchangelGrail.spriteatlas")
    end
    ---@type cfg_equip_angelEntry_column
    local angelEntry = SL:GetConfig("cfg_equip_angelEntry", data.id, "id")
    GUI:Text_setTextColor(att_text, E_ArchangelGrailQualityColor[angelEntry.attQuality])
    GUI:Text_setTextColor(max_att_text, E_ArchangelGrailQualityColor[angelEntry.attQuality])
    GUI:Image_loadTexture(bg_img, "bg_attr_" .. angelEntry.attQuality, "Atlas/UIArchangelGrail.spriteatlas")
    if data.key then
        if data.key == "mAtt" then
            if table.contains(self.strengthChange, "200011") or table.contains(self.strengthChange, "200021") then
                GUI:setVisible(select_img, true)
            else
                GUI:setVisible(select_img, false)
            end
            if data.isMain and not table.isNullOrEmpty(self.strengthChange) then
                GUI:setVisible(select_img, true)
            end
            GUI:Text_setString(att_text, "攻击力+" .. tostring(data.min) .. "~" .. tostring(data.max))
            GUI:Text_setString(max_att_text,
                "最大：" .. tostring(angelEntry.attMax[1]) .. "~" .. tostring(angelEntry.attMax[2]))
            GUI:SetLoadingbar_startper(loadingbar_attr,
                (data.min + data.max) / (angelEntry.attMax[1] + angelEntry.attMax[2]) * 100)
        end
        return
    end
    if table.contains(self.strengthChange, data.id) then
        GUI:setVisible(select_img, true)
    else
        GUI:setVisible(select_img, false)
    end
    if data.isMain and not table.isNullOrEmpty(self.strengthChange) then
        GUI:setVisible(select_img, true)
    end
    ---@type cfg_att_info_column
    local attTbl = SL:GetConfig("cfg_att_info", tonumber(data.attrId), "id")
    local str = attTbl.name
    local maxStr = "最大："
    if attTbl.remarks == 2 then
        str = str .. "+" .. tostring(data.value / 100) .. "%"
        maxStr = maxStr .. tostring(angelEntry.attMax[1] / 100) .. "%"
    else
        str = str .. "+" .. tostring(data.value)
        maxStr = maxStr .. tostring(angelEntry.attMax[1])
    end
    GUI:SetLoadingbar_startper(loadingbar_attr, data.value / angelEntry.attMax[1] * 100)
    GUI:Text_setString(max_att_text, maxStr)
    GUI:Text_setString(att_text, str)
end

function this:LUA_EVENT_EQUIP_GRID_CLICK(_, pos)
    self.selectEquipPos = pos
    local equip = SL:GetMetaValue("EQUIP_DATA_LIST", pos)[1]
    if pos == EEquipSlotType.ArchangelWeapon and not equip then
        equip = SL:GetMetaValue("EQUIP_DATA_LIST", EEquipSlotType.ArchangelTwoHandWeapon)[1]
        self.selectEquipPos = EEquipSlotType.ArchangelTwoHandWeapon
    end
    if pos == EEquipSlotType.ArchangelTwoHandWeapon and not equip then
        equip = SL:GetMetaValue("EQUIP_DATA_LIST", EEquipSlotType.ArchangelWeapon)[1]
        self.selectEquipPos = EEquipSlotType.ArchangelWeapon
    end
    if not equip then
        return
    end
    GUI:Image_loadTexture(self.view.img_attr_title, "equip_att_title", "Atlas/UIArchangelGrail.spriteatlas")
    GUI:setPositionY(self.view.equipatt_panel, -155)
    GUI:setVisible(self.view.equip_top, true)
    GUI:setVisible(self.view.grail_suit_all, false)
    GUI:setVisible(self.view.suit_detail_panel, false)
    self.equipPanel:SetSelectIndex(self.selectEquipPos)
    self.selectEquip = equip
    self.selectGrail = {}
    self:RefreshEquip()
    self.isHideSelect = true
end

function this:Strengthen()
    if table.isNullOrEmpty(self.selectGrail) then
        return
    end
    if self.isStrengthlvMax then
        return
    end
    GUI:setVisible(self.view.effectfail, false)
    GUI:setVisible(self.view.effectSucceed, false)
    self.isStrengthInfo = false
    self.isStrength = false
    self.type = SendType.Strength
    self.strengthQian = {}
    for i, v in pairs(self.grailAttrInfo) do
        if not v.attrId then
            self.strengthQian[v.key] = { v.max, v.min }
        elseif not self.strengthQian[v.attrId] and v.isMain == false then
            self.strengthQian[v.id] = v.value
        end
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_STRENGTHEN_ANGEL_GRAIL,
        { itemConfigId = self.selectGrail.cfgId, itemId = self.selectGrail.id })
end

function this:BtnHelpOnClick()
    local helpCfg = SL:GetConfig("cfg_rule_text", 29001)
    if helpCfg then
        SL:CommonStrTipsMessage({ title = helpCfg.menutxt, str = helpCfg.location })
    end
end

function this:BtnHideSuitDetail()
    GUI:setVisible(self.view.suit_detail_panel, false)
end

function this:BtnGrailTipsOnClick()
    if self.selectGrail and self.selectGrail.cfgId then
        SL:OpenTips("", tonumber(self.selectGrail.cfgId), tonumber(self.selectGrail.id))
    else
        self:OpenEquip()
    end
end

function this:ShowSuitDetail(_, eventData)
    GUI:setVisible(self.view.suit_detail_panel, true)
    if eventData then
        local name
        local data = {}
        ---@type cfg_equip_angelGrailSuit_column[]
        local tbl = SL:GetConfigTable("cfg_equip_angelGrailSuit")
        for i, v in ipairs(tbl) do
            if v.group == eventData then
                name = v.mainName
                for j, k in ipairs(v.suitEffect) do
                    ---@type cfg_att_info_column
                    local tbl_2 = SL:GetConfig("cfg_att_info", k[2])
                    local attrValue
                    if tbl_2.remarks == 2 then
                        attrValue = k[3] / 100 .. "%"
                    else
                        attrValue = k[3]
                    end
                    attrValue = "<color=" .. E_ArchangelGrailQualityColor[v.level] .. ">" .. attrValue .. "</color>"
                    if not data[k[1]] then
                        data[k[1]] = tbl_2.name .. "+" .. attrValue
                    else
                        data[k[1]] = data[k[1]] .. "/" .. attrValue
                    end
                end
            end
        end
        GUI:Text_setString(self.view.detail_name, name)
        GUI:Text_setString(self.view.detail_attr_1, "3件套:" .. data[3])
        GUI:Text_setString(self.view.detail_attr_2, "5件套:" .. data[5])
        GUI:Text_setString(self.view.detail_attr_3, "7件套:" .. data[7])
    end
end

function this:RES_GRAIL_ENTRY_STRENGTHEN_RESULT(_, message)
    self.isStrength = true
    if not message then
        GUI:setVisible(self.view.effectfail, true)
        self:GrailSelect(self.selectGrailIndex, self.selectGrail.cfgId, self.selectGrail.id)
        return
    end
    GUI:setVisible(self.view.effectSucceed, true)
    if self.isStrengthInfo then
        self:GrailSelect(self.selectGrailIndex, self.selectGrail.cfgId, self.selectGrail.id)
    end
end

function this:LUA_EVENT_GRAIL_INFO_CHANGE(_, message)
    if self.bagUI then
        if self.type == SendType.Fusion then
            self:RefreshBag(self.selectGrailIndex)
        elseif self.type == SendType.UnFusion then
            self:RefreshBag(self.unFusionHole)
        end
    end
end

function this:IsSelectEquip(IsSelect)
    GUI:setVisible(self.view.item_add_img, not IsSelect)
    GUI:setVisible(self.view.item_name, IsSelect)
    GUI:setVisible(self.view.item8, IsSelect)
    GUI:setVisible(self.view.warning_img, not IsSelect)
    --GUI:setVisible(self.view.equipatt_panel, IsSelect)
    --GUI:setVisible(self.view.strength_panel, IsSelect)
end

function this:CostDataListUpdateFunc(realIndex, kmlcontrol)
    local cost_item = GUI:GetChildControl(self.view.cost_list, realIndex, "cost_item")
    local cost_name = GUI:GetChildControl(self.view.cost_list, realIndex, "cost_name")
    local cost_num = GUI:GetChildControl(self.view.cost_list, realIndex, "cost_num")
    local costAddBtn = GUI:GetChildControl(self.view.cost_list, realIndex, "costAddBtn")
    local data = self.costList[realIndex + 1]
    GUI:Item_setItemId(cost_item, data[1])
    ---@type cfg_item_column
    local itemTbl = SL:GetConfig("cfg_item", data[1], "id")
    GUI:Text_setString(cost_name, itemTbl.name)
    local costNumStr = ""
    local bagCount = SL:GetBagItemCount(data[1])

    if bagCount >= data[2] then
        costNumStr = "<color='#00ff00'>" .. tostring(bagCount) .. "</color>/" .. tostring(data[2])
        --self.isCost = true
    else
        costNumStr = "<color='#ff2323'>" .. tostring(bagCount) .. "</color>/" .. tostring(data[2])
        --self.isCost = false
    end
    GUI:Text_setString(cost_num, costNumStr)
    GUI:AddOnClickEvent(costAddBtn, self, function()
        SL:CommonItemGetPath(nil, data[1])
    end)
end

function this:GrailItemGet(realIndex)
    ---@type KLGrailItem
    local item = GUI:UIPanel_Open("dev/outui/Archangel/Item/KLGrail/KLGrailItem", self.view.grail_list, self, nil, true)
    self.grailItemList[item.view.root] = item
    return item.view.root
end

function this:GrailUpdateItem(realIndex, kmlcontrol)
    self.grailItemList[kmlcontrol]:UpdateUI(self.grailInfo[realIndex + 1], self.isHideSelect)
end

function this:GetGrailItemShowRedPoint(holeIndex, cfgId)
    if not self.equipGrailInfo[holeIndex] then
        return false
    end
    local angelstrengthenLv = self.equipGrailInfo[holeIndex].attrInfo.level
    local strengthenTbl = SL:GetConfig("cfg_equip_angelStrengthen", cfgId, "id")
    local costTbl = SL:GetConfigTwoKeys("cfg_equip_angelStrengthenCost", strengthenTbl.costGroup, angelstrengthenLv,
        "AngelstrengthenGroup", "AngelstrengthenLv")
    if table.count(costTbl.Angelstrengthencost) == 0 then
        return false
    end
    for _, v in pairs(costTbl.Angelstrengthencost) do
        if v[2] > SL:GetBagItemCount(v[1]) then
            return false
        end
    end
    return true
end

function this:GetGrailByHoleIndex(holeIndex)
    local data = self:GetBagItem(holeIndex, self.selectEquipPos)
    if data and table.count(data) > 0 then
        return true
    else
        return false
    end
end

function this:GrailSelect(holeIndex, cfgId, id)
    for i, v in pairs(self.grailItemList) do
        v:SelectItemUIChange(holeIndex)
    end
    if not self.grailInfo[holeIndex] then
        return
    end

    self.selectGrailIndex = holeIndex
    if cfgId then
        self.selectGrail = { cfgId = cfgId, id = id }
        local angelstrengthenLv = self.equipGrailInfo[holeIndex].attrInfo.level
        local strengthenTbl = SL:GetConfig("cfg_equip_angelStrengthen", cfgId, "id")
        local costTbl = SL:GetConfigTwoKeys("cfg_equip_angelStrengthenCost", strengthenTbl.costGroup, angelstrengthenLv,
            "AngelstrengthenGroup", "AngelstrengthenLv")
        local tbl = SL:FindConfigs("cfg_equip_angelStrengthenCost", "AngelstrengthenGroup", strengthenTbl.costGroup)
        table.sort(tbl, function(a, b)
            return a.AngelstrengthenLv > b.AngelstrengthenLv
        end)
        self:GrailItemShow(holeIndex)
        self:OpenEquip()
        self.costList = costTbl.Angelstrengthencost
        GUI:Text_setString(self.view.success_rate, tostring(costTbl.AngelstrengthenSuccessRate) .. "%")
        self:AttShow(holeIndex)
        GUI:DataListUpdateData(self.view.cost_list)
        if angelstrengthenLv == tbl[1].AngelstrengthenLv then
            --等级已满
            GUI:Button_setGrey(self.view.strengthenBtn, true)
            self.isStrengthlvMax = true
            GUI:Button_setTitleText(self.view.strengthenBtn, "等级已满")
            GUI:setVisible(self.view.success_img, false)
            GUI:setVisible(self.view.cost_title, false)
            GUI:setVisible(self.view.StrengthCostScrollView, false)
        elseif self:IsGrailEntryMax(holeIndex) then
            GUI:Button_setGrey(self.view.strengthenBtn, true)
            self.isStrengthlvMax = true
            GUI:Button_setTitleText(self.view.strengthenBtn, "属性已满")
            GUI:setVisible(self.view.success_img, false)
            GUI:setVisible(self.view.cost_title, false)
            GUI:setVisible(self.view.StrengthCostScrollView, false)
        else
            GUI:Button_setGrey(self.view.strengthenBtn, false)
            GUI:Button_setTitleText(self.view.strengthenBtn, "强化")
            self.isStrengthlvMax = false
            GUI:setVisible(self.view.success_img, true)
            GUI:setVisible(self.view.cost_title, true)
            GUI:setVisible(self.view.StrengthCostScrollView, true)
        end
    else
        self.selectGrail = {}
        self:ShowEquipAtt()
        self:RefreshBag(holeIndex)
        self:EquipItemShow()
    end
end

function this:IsGrailEntryMax(holeIndex)
    local data = self.equipGrailInfo[holeIndex]
    for i, v in pairs(self.equipGrailInfo[holeIndex].attrInfo.main) do
        if v.isMax == false then
            return false
        end
    end

    for i, v in pairs(self.equipGrailInfo[holeIndex].attrInfo.secondary) do
        for _, j in pairs(v) do
            if j.isMax == false then
                return false
            end
        end
    end
    return true
end

function this:GrailItemShow(holeIndex)
    if self.equipGrailInfo[holeIndex] then
        GUI:Item_setItemId(self.view.item8, self.equipGrailInfo[holeIndex].itemConfigId)
        ---@type cfg_item_column
        local itemCfg = SL:GetConfig("cfg_item", self.equipGrailInfo[holeIndex].itemConfigId, "id")
        GUI:Text_setTextColor(self.view.item_name, SL:GetConfig("cfg_color", tonumber(itemCfg.color), "id").color)
        GUI:Text_setString(self.view.item_name, itemCfg.name)
        GUI:Text_setString(self.view.preLevel, "+" .. tostring(self.equipGrailInfo[holeIndex].attrInfo.level))
        local maxLevel = InfoManager.archangeEquipInfo:GetGrailMaxStrengthLv(self.equipGrailInfo[holeIndex].itemConfigId)
        if maxLevel == self.equipGrailInfo[holeIndex].attrInfo.level then
            GUI:setVisible(self.view.nextLevel, false)
            GUI:setVisible(self.view.arrow, false)
            GUI:setPositionX(self.view.preLevel, 0)
        else
            GUI:setPositionX(self.view.preLevel, -45)
            GUI:setVisible(self.view.nextLevel, true)
            GUI:setVisible(self.view.arrow, true)
            GUI:Text_setString(self.view.nextLevel, "+" .. tostring(self.equipGrailInfo[holeIndex].attrInfo.level + 1))
        end
    else
        self:EquipItemShow()
    end
end

function this:EquipItemShow()
    if not self.selectEquip then
        return
    end
    GUI:Item_setItemId(self.view.item8, self.selectEquip.cfgId)
    ---@type cfg_item_column
    local itemCfg = SL:GetConfig("cfg_item", self.selectEquip.cfgId, "id")
    GUI:Text_setTextColor(self.view.item_name, SL:GetConfig("cfg_color", tonumber(itemCfg.color), "id").color)
    GUI:Text_setString(self.view.item_name, itemCfg.name)
end

--- 传入阶数和配置id获取孔位
---@return number,number 解锁的孔位，总孔位
function this:GetHole(rank, cfgId)
    if not cfgId then
        return 0, 0
    end
    ---@type cfg_equip_angelGroup_column
    local tbl = SL:GetConfig("cfg_equip_angelGroup", cfgId, "id")
    if not rank or rank == 0 then
        return 0, table.count(tbl.grailOpen)
    end
    local grailOpen = table.copy(tbl.grailOpen)
    table.sort(grailOpen, function(a, b)
        return a[1] < b[1]
    end)
    --local rankIndex = 1
    for i, v in pairs(grailOpen) do
        if v[1] > rank then
            return grailOpen[i - 1][2], table.count(grailOpen)
        end
        if v[1] == rank then
            return grailOpen[i][2], table.count(grailOpen)
        end
    end
    return 0, table.count(grailOpen)
end

function this:Fusion(itemId, cfgId)
    local data = {
        equipId = self.selectEquip.id,
        itemId = itemId,
        index = SL:GetBagIndex(itemId),
        position = self
            .selectGrailIndex,
        itemConfigId = cfgId,
        equipConfigId = self.selectEquip.cfgId
    }
    --local da  =data
    self.type = SendType.Fusion
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_INLAY_ANGEL_GRAIL, data)
end

function this:UnFusion(itemId, cfgId, holeIndex)
    self.type = SendType.UnFusion
    self.unFusionHole = holeIndex
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UNLOAD_ANGEL_GRAIL,
        { equipId = self.selectEquip.id, itemId = itemId, itemConfigId = cfgId })
end

function this:BagItemClick(itemControl, itemData)
    SL:OpenTips("bag", itemData.cfgId, itemData.id)
    --self:Fusion(itemData.id, itemData.cfgId)
    --SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_ANGEL_GRAIL_INFO, itemData.id)
end

--- 打开背包并筛选
---@param holeIndex number @孔位
function this:RefreshBag(holeIndex)
    if holeIndex <= 0 then
        return
    end
    if not self.bagUI then
        self.bagUI = GUI:UIPanel_Open("dev/outui/Archangel/Panel/KLFusionBag/KLFusionBagPanel", nil, nil,
                { x = -482, y = 0, itemClick = self.BagItemClick, selectList = {}, callBackUI = self }, true, function(bagUI)
                    ---@type KLFusionBagPanel
                    self.bagUI = bagUI
                    self.bagUI:RefreshItem(self:GetBagItem(holeIndex, self.selectEquipPos))
                end)
    else
        if not GUI:IsUILoading(self.bagUI) then
            self.bagUI:RefreshItem(self:GetBagItem(holeIndex, self.selectEquipPos))
        end
    end
    if self.equipPanel then
        GUI:UIPanel_Close(nil, self.equipPanel)
        self.equipPanel = nil
    end

    --if self.selectEquip then
    --
    --end
    --self.bagUI:RefreshItem(self:GetBagItem(holeIndex))
end

--- 打开穿戴栏
function this:OpenEquip()
    if not self.equipPanel then
        local equipPanel = GUI:GetUI("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
        if equipPanel then
            self.equipPanel = equipPanel
        else
            self.equipPanel = GUI:UIPanel_Open("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel", nil, nil,
                { x = -465, hideTips = true, callBack = self.ClosePanel, })
        end

        self.equipPanel:SetSelfWearBarType(EEquipWearBarType.Archange)
        self.equipPanel:SetSelectIndex(self.selectEquipPos)
    end
    if self.bagUI then
        GUI:UIPanel_Close(nil,self.bagUI)
        self.bagUI = nil
    end
    --self:GrailSelect(-1)
end

--- 刷新穿戴栏（重开一次）
function this:RefreshEquipWear()
    if self.equipPanel then
        local equipPanel = GUI:GetUI("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
        if equipPanel then
            self.equipPanel = equipPanel
        else
            self.equipPanel = GUI:UIPanel_Open("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel", nil, nil,
                { x = -465, hideTips = true, callBack = self.ClosePanel, })
        end
        self.equipPanel:SetSelfWearBarType(EEquipWearBarType.Archange)
        self.equipPanel:SetSelectIndex(self.selectEquipPos)
    end
    --self:GrailSelect(-1)
end

--self.archangeGrailInfo[equipId][grailId] = { grailPosition = grailPos, itemConfigId = grailCfgId }


function this:Hide()
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLArchangelGrail/KLArchangelGrailPanel")
    GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLArchangelGroup/KLArchangelGroupPanel")
end

function this:Close()
    if self.bagUI then
        GUI:UIPanel_Close(nil, self.bagUI)
    elseif self.equipPanel then
        GUI:UIPanel_Close(nil, self.equipPanel)
    end
    if self.isOther then
        InfoManager.archangeEquipInfo:ResetOtherInfo()
    end
end

function this:InitDataList()
    GUI:DataListInitData(self.view.cost_list, function()
        return table.count(self.costList)
    end, function(realIndex)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:CostDataListUpdateFunc(realIndex, kmlcontrol)
    end)

    GUI:DataListInitData(self.view.grail_att_list, function()
        return table.count(self.grailAttrInfo)
    end, function(realIndex)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GrailAttDataListUpdateFunc(realIndex, kmlcontrol)
    end)

    GUI:DataListInitData(self.view.grail_list, function()
        return table.count(self.grailInfo)
    end, function(realIndex)
        return self:GrailItemGet(realIndex)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GrailUpdateItem(realIndex, kmlcontrol)
    end)

    GUI:DataListInitData(self.view.equip_att_list, function()
        return table.count(self.equipAttinfo)
    end, function(realIndex)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:EquipAttUpdateItem(realIndex, kmlcontrol)
    end)

    GUI:DataListInitData(self.view.grail_all_suit_list, function()
        return table.count(self.grailSuitList)
    end, function(realIndex)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GrailSuitUpdateItem(realIndex, kmlcontrol)
    end)
end

function this:LUA_EVENT_BAG_CHANGE_AFTER(_, message)
    if self.bagUI then
        if self.type == SendType.Fusion then
            self:RefreshBag(self.selectGrailIndex)
        elseif self.type == SendType.UnFusion then
            self:RefreshBag(self.unFusionHole)
        end
    end
end

--- 筛选背包物品
function this:GetBagItem(holeIndex, pos)
    local data = {}
    local bagItemTabl = SL:GetMetaValue("BAG_DATA")[1]
    if bagItemTabl then
        for _, v in pairs(bagItemTabl) do
            local tbl = nil
            if SL:HasConfig("cfg_equip_angelGrail", v.cfgId, "id") then
                tbl = SL:GetConfig("cfg_equip_angelGrail", v.cfgId, "id")
            end
            if pos then
                if tbl and table.contains(tbl.gradePosition, holeIndex) and table.contains(tbl.strPart, pos) then
                    table.insert(data, v)
                end
            else
                if tbl and table.contains(tbl.gradePosition, holeIndex) then
                    table.insert(data, v)
                end
            end
        end
    end
    return data
end

return this
