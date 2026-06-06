---@class KLArchangelGrailTipsPanel:UIKmlLuaPanelBase
---@field view KLArchangelGrailTipsPanelView
local KLArchangelGrailTipsPanel = class(UIKmlLuaPanelBase)
local this = KLArchangelGrailTipsPanel
function this:AsyncLoadUI()
end

---创建时调用一次
function this:Init()
    self:CloseOtherTips()
    -- self.args = info
    self.otherGrail = nil
    if self.args.info and self.args.info.hideMask then
        GUI:setVisible(self.view.background_close, false)
    else
        GUI:setVisible(self.view.background_close, true)
    end
    if self.args.info and self.args.info.isRight then
        GUI:setAnchorPoint(self.view.root, 2, 0)
    end
    if self.args.info and self.args.info.posX then
        GUI:setPositionX(self.view.root, self.args.info.posX)
    end

    GUI:DataListInitData(self.view.all_info_data, function()
        return self:EquipAttrDataListItemCountFunc()
    end, function(realIndex)
        return self:EquipAttrDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:EquipAttrDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:EquipAttrDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.firstCharge_list = { 28810531, 28820531, 28830531 }
    self.left_all = {}
end

---界面显示时调用一次
function this:Show()
    if self.args.info and self.args.info.otherRid and self.args.id then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_OTHER_ANGE_GRAIL_INFO,
            { rid = tonumber(self.args.info.otherRid), itemId = tonumber(self.args.id) })
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.archenge = {}
    self.all_info = {}
    GUI:Item_setItemId(self.view.item5, self.args.cfgId)
    local itemTbl = SL:GetConfig("cfg_item", self.args.cfgId)
    local shape = itemTbl.shape[1]
    local rotation = SL:GetConfig("cfg_model_charactor", shape).rotateAxis
    local rotation_str = rotation .. ",50,0"
    if self.Schedule1 then
        SL:UnSchedule(self.Schedule1)
    end
    self.Schedule1 = SL:ScheduleOnce(0.2, function()
        GUI:Item_Rotate(self.view.item5, rotation_str)
    end)
    GUI:Text_setTextColor(self.view.item_name, SL:GetConfig("cfg_color", tonumber(itemTbl.color), "id").color)
    GUI:Text_setString(self.view.item_name, itemTbl.name)
    local tbl = SL:GetConfig("cfg_equip_angelGrail", self.args.cfgId, "id")
    local strPart = "可融合部位：<color='#e6e600'>"
    for i, v in pairs(tbl.strPart) do
        strPart = strPart .. E_ArchangelGrailstrPart[v] .. " "
    end
    strPart = strPart .. "</color>"
    GUI:Text_setString(self.view.fusion_pos, strPart)
    --self:NoHaveGrail()
    if not self.args.id then
        self:NoHaveGrail()
    else
        self:HaveGrail()
    end

    if self.args.info and self.args.info.hideBtn then
        GUI:setVisible(self.view.bag_root, false)
        GUI:setVisible(self.view.equip_root, false)
    elseif self.args.equip_pos == "bag" then
        GUI:setVisible(self.view.bag_root, true)
        GUI:setVisible(self.view.equip_root, false)
        self:bagBtnUpdate()
    elseif self.args.equip_pos == "depots" then
        GUI:setVisible(self.view.bag_root, true)
        GUI:setVisible(self.view.equip_root, false)
        self:depotsBtnUpdate()
    elseif self.args.equip_pos == "equip" then
        GUI:setVisible(self.view.equip_root, true)
        GUI:setVisible(self.view.bag_root, false)
        local wearBarId = SL:GetEquipValue(EMetaVarGetKey.EQUIP_WEAR_BAR_ID, nil, self.args.cfgId)
        if wearBarId[1] and wearBarId[1] > 2 then
            GUI:setVisible(self.view.duanzaobtn, false)
        elseif self.subType == 14 then
            GUI:setVisible(self.view.duanzaobtn, false)
        else
            GUI:setVisible(self.view.duanzaobtn, true)
        end

        if self.subType == 10 or self.subType == 11 or self.subType == 12 then
            GUI:setVisible(self.view.tuoxiabtn, false)
            GUI:setVisible(self.view.shengjibtn, true)
        else
            GUI:setVisible(self.view.tuoxiabtn, true)
            GUI:setVisible(self.view.shengjibtn, false)
        end
    elseif self.args.equip_pos == "synthesis" then
        GUI:setVisible(self.view.left_btn, true)
        GUI:setVisible(self.view.right_btn, true)
        GUI:setVisible(self.view.equip_root, false)

        GUI:Button_setTitleText(self.view.left_btn, "取消")
        GUI:Button_setTitleText(self.view.right_btn, "替换")
    else
        GUI:setVisible(self.view.equip_root, false)
        GUI:setVisible(self.view.bag_root, false)
        --没有下方二个按钮的模型位置（equip_pos不是bag）
        --GUI:setPositionY(self.view.model1, -220)
    end

    GUI:DataListUpdateData(self.view.all_info_data)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.background_close, self, self.CloseEquipTips)
    GUI:AddOnClickEvent(self.view.left_btn, self, self.BtnLeftOnClick)
    GUI:AddOnClickEvent(self.view.right_btn, self, self.BtnRightOnClick)
    --GUI:AddOnClickEvent(self.view.tuoxiabtn, self, self.TakeOffEquip)
    --GUI:AddOnClickEvent(self.view.shengjibtn, self, self.ShengJi)
    --GUI:AddOnClickEvent(self.view.duanzaobtn, self, self.ForgeOnClick)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_OTHER_ANGE_GRAIL_INFO, self.RES_OTHER_ANGE_GRAIL_INFO, self)
end

function this:HaveGrail()
    local grailInfo = InfoManager.archangeEquipInfo:GetGrailInfo(self.args.id)
    if not grailInfo then
        if self.otherGrail then
            grailInfo = self.otherGrail
        elseif SL.OpenTips_item then
            local type = SL:GetMetaValue(EMetaVarGetKey.ITEMTYPE, SL.OpenTips_item.cfgId)
            local subType = SL:GetMetaValue(EMetaVarGetKey.ITEMSUBTYPE, SL.OpenTips_item.cfgId)
            if type == 9 and subType == 1 then
                grailInfo = SL:JsonDecode(SL.OpenTips_item.luaExtData)
            end
            
        end
    end
    if table.isNullOrEmpty(grailInfo) then
        self:NoHaveGrail()
        return
    end
    local itemTbl = SL:GetConfig("cfg_item", self.args.cfgId)
    GUI:Text_setTextColor(self.view.item_name, SL:GetConfig("cfg_color", tonumber(itemTbl.color), "id").color)
    if grailInfo.level > 0 then
        GUI:Text_setString(self.view.item_name, itemTbl.name .. "+" .. tostring(grailInfo.level))
    else
        GUI:Text_setString(self.view.item_name, itemTbl.name)
    end

    ---@type CommonProtos.Item
    local iteminfo = SL:GetPosItemInfo(self.args.equip_pos, self.args.cfgId, self.args.id)
    if not iteminfo then
        GUI:setVisible(self.view.bing_text, false)
    else
        GUI:setVisible(self.view.bing_text, true)
        if iteminfo.bind then
            GUI:Text_setString(self.view.bing_text, "不可交易")
        else
            GUI:Text_setString(self.view.bing_text, "可交易")
        end
    end

    if grailInfo.score and grailInfo.score ~= 0 then
        GUI:Text_setString(self.view.score_text, "圣杯评分：" .. tostring(grailInfo.score))
        GUI:setVisible(self.view.score_text, true)
    else
        GUI:setVisible(self.view.score_text, false)
    end
    GUI:Text_setString(self.view.rant_text, "圣杯阶数：" .. tostring(grailInfo.grailGrade) .. "阶")
    local grailQuality = SL:GetConfig("cfg_equip_angelGrail", grailInfo.itemConfigId, "id").grailQuality
    GUI:Text_setString(self.view.quality_text,
        "圣杯品质：<color='" ..
        E_ArchangelGrailQualityColor[grailQuality] .. "'>" .. E_ArchangelGrailQualityName[grailQuality] .. "</color>")
    self.all_info = {}
    ---主属性
    table.insert(self.all_info, { title = "tips_attribute27" })
    local maxAtt = nil
    local minAtt = nil
    for i, v in pairs(grailInfo.main) do
        if tonumber(v.attrId) == 200021 then
            maxAtt = v.value
            if minAtt then
                table.insert(self.all_info,
                    { name = "攻击力", value = tostring(minAtt) .. "~" .. tostring(maxAtt), color =
                    E_ArchangelGrailQualityColor[SL:GetConfig("cfg_equip_angelEntry", v.id, "id").attQuality] })
                minAtt = nil
                maxAtt = nil
            end
        elseif tonumber(v.attrId) == 200011 then
            minAtt = v.value
            if maxAtt then
                table.insert(self.all_info,
                    { name = "攻击力", value = tostring(minAtt) .. "~" .. tostring(maxAtt), color =
                    E_ArchangelGrailQualityColor[SL:GetConfig("cfg_equip_angelEntry", v.id, "id").attQuality] })
                minAtt = nil
                maxAtt = nil
            end
        else
            ---@type cfg_att_info_column
            local attTbl = SL:GetConfig("cfg_att_info", tonumber(v.attrId), "id")
            local strName = attTbl.name
            local strValeue = ""
            if attTbl.remarks == 2 then
                strValeue = tostring(v.value / 100) .. "%"
            else
                strValeue = tostring(v.value)
            end
            --SL:GetConfig("cfg_equip_angelEntry",v.id,"id").attQuality
            table.insert(self.all_info,
                { name = strName, value = strValeue, color = E_ArchangelGrailQualityColor
                [SL:GetConfig("cfg_equip_angelEntry", v.id, "id").attQuality] })
        end
    end
    ---副属性
    table.insert(self.all_info, { title = "tips_attribute26" })
    maxAtt = nil
    minAtt = nil
    if grailInfo.secondary then
        for i, v in pairs(grailInfo.secondary) do
            for _, k in pairs(v) do
                if tonumber(k.attrId) == 200021 then
                    maxAtt = k.value
                    if minAtt then
                        table.insert(self.all_info,
                            { name = "攻击力", value = tostring(minAtt) .. "~" .. tostring(maxAtt), color = v.color })
                        minAtt = nil
                        maxAtt = nil
                    end
                elseif tonumber(k.attrId) == 200011 then
                    minAtt = k.value
                    if maxAtt then
                        table.insert(self.all_info,
                            { name = "攻击力", value = tostring(minAtt) .. "~" .. tostring(maxAtt), color = v.color })
                        minAtt = nil
                        maxAtt = nil
                    end
                else
                    ---@type cfg_att_info_column
                    local attTbl = SL:GetConfig("cfg_att_info", tonumber(k.attrId), "id")
                    local strName = attTbl.name
                    local strValeue = ""
                    if attTbl.remarks == 2 then
                        strValeue = tostring(k.value / 100) .. "%"
                    else
                        strValeue = tostring(k.value)
                    end
                    --SL:GetConfig("cfg_equip_angelEntry",k.id,"id").attQuality
                    table.insert(self.all_info,
                        { name = strName, value = strValeue, color = E_ArchangelGrailQualityColor
                        [SL:GetConfig("cfg_equip_angelEntry", k.id, "id").attQuality] })
                end
            end
        end
    end
    ---圣杯套装
    table.insert(self.all_info, { title = "tips_attribute2" })
    table.insert(self.all_info, { name = "融合一定数量该圣杯，即可获得额外效果", value = "", isSuit = true, color = "#e6e600" })
    ---@type cfg_equip_angelGrail_column
    local tbl = SL:GetConfig("cfg_equip_angelGrail", self.args.cfgId)
    ---@type cfg_equip_angelGrailSuit_column[]
    local angelGrailTbl = SL:GetConfigTable("cfg_equip_angelGrailSuit")
    for _, v in pairs(angelGrailTbl) do
        if v.group == tbl.grailGrade and v.level == tbl.grailQuality then
            local count = InfoManager.archangeEquipInfo:GetGrailSuitCount(v.group, v.level) or 0
            local groupInfo = InfoManager.archangeEquipInfo:GetGrailGroupInfo(v.group) or {}
            local heightCount = 0
            for m, n in pairs(groupInfo) do
                if m > v.level then
                    heightCount = heightCount + n
                end
            end
            table.insert(self.all_info,
                { name = v.name, value = "(" .. count .. "/7)", isSuit = true, color = "#ff8a00" })
            for j, k in pairs(v.suitEffect) do
                local colorStr = "#999999"
                if k[1] <= count and k[1] > heightCount then
                    colorStr = E_ArchangelGrailQualityColor[v.level]
                end
                ---@type cfg_att_info_column
                local attTbl = SL:GetConfig("cfg_att_info", tonumber(k[2]))
                local strValeue = ""
                if attTbl.remarks == 2 then
                    strValeue = tostring(k[3] / 100) .. "%"
                else
                    strValeue = tostring(k[3])
                end
                table.insert(self.all_info,
                    { name = k[1] .. "件套效果", value = attTbl.name .. "+" .. strValeue, color = colorStr, isSuit = true })
            end
            break
        end
    end
end

function this:NoHaveGrail()
    GUI:Text_setString(self.view.bing_text, "可交易")
    ---@type cfg_equip_angelGrail_column
    local grailTbl = SL:GetConfig("cfg_equip_angelGrail", self.args.cfgId, "id")
    GUI:setVisible(self.view.score_text, false)
    GUI:Text_setString(self.view.rant_text, "圣杯阶数：" .. tostring(grailTbl.grailGrade) .. "阶")

    local grailQuality = grailTbl.grailQuality
    GUI:Text_setString(self.view.quality_text,
        "圣杯品质：<color='" ..
        E_ArchangelGrailQualityColor[grailQuality] .. "'>" .. E_ArchangelGrailQualityName[grailQuality] .. "</color>")
    self.all_info = {}
    table.insert(self.all_info, { title = "tips_attribute27" })
    --主词条
    local entryGroup = grailTbl.mainAttGroup
    ---@type cfg_equip_angelEntry_column[]
    local mainEntry = SL:FindConfigs("cfg_equip_angelEntry", "group", entryGroup)

    --走表的老铁 todo
    local data = {}
    local maxAtt = nil
    local minAtt = nil
    for i, v in pairs(mainEntry) do
        for _, att in pairs(v.att) do
            local attTbl = SL:GetConfig("cfg_att_info", tonumber(att[1]), "id")
            local strName = attTbl.name
            local strValeue
            if tonumber(att[1]) == 200021 then
                maxAtt = att[3]
                if minAtt then
                    if minAtt == maxAtt then
                        table.insert(self.all_info,
                            { name = "攻击力", value = tostring(minAtt), color = E_ArchangelGrailQualityColor[v.attQuality] })
                    else
                        table.insert(self.all_info,
                            { name = "攻击力", value = tostring(minAtt) .. "~" .. tostring(maxAtt), color =
                            E_ArchangelGrailQualityColor[v.attQuality] })
                    end
                    minAtt = nil
                    maxAtt = nil
                end
            elseif tonumber(att[1]) == 200011 then
                minAtt = att[2]
                if maxAtt then
                    if minAtt == maxAtt then
                        table.insert(self.all_info,
                            { name = "攻击力", value = tostring(minAtt), color = E_ArchangelGrailQualityColor[v.attQuality] })
                    else
                        table.insert(self.all_info,
                            { name = "攻击力", value = tostring(minAtt) .. "~" .. tostring(maxAtt), color =
                            E_ArchangelGrailQualityColor[v.attQuality] })
                    end
                    minAtt = nil
                    maxAtt = nil
                end
            else
                if att[2] == att[3] then
                    if attTbl.remarks == 2 then
                        strValeue = tostring(att[2] / 100) .. "%"
                    else
                        strValeue = tostring(att[2])
                    end
                else
                    if attTbl.remarks == 2 then
                        strValeue = tostring(att[2] / 100) .. "%~" .. tostring(att[3] / 100) .. "%"
                    else
                        strValeue = tostring(att[2]) .. "~" .. tostring(att[3])
                    end
                end
                table.insert(self.all_info,
                    { name = strName, value = strValeue, color = E_ArchangelGrailQualityColor[v.attQuality] })
            end
        end
    end
    table.insert(self.all_info, { title = "tips_attribute26" })
    local haveEntry = {}
    --副词条
    entryGroup = grailTbl.randomAttGroup
    -- 存储词条信息
    for _, v in pairs(entryGroup) do
        for _, j in pairs(v) do
            ---@type cfg_equip_angelEntry_column[]
            local entry = SL:FindConfigs("cfg_equip_angelEntry", "group", j)
            for _, c in pairs(entry) do
                for _, att in pairs(c.att) do
                    if not haveEntry[att[1]] then
                        haveEntry[att[1]] = {}
                        haveEntry[att[1]].att = {}
                    end
                    table.insert(haveEntry[att[1]].att,
                        { value = att[2], color = E_ArchangelGrailQualityColor[c.attQuality] })
                end
            end
        end
    end
    maxAtt = nil
    minAtt = nil
    for i, v in pairs(haveEntry) do
        table.sort(v.att, function(a, b)
            return a.value < b.value
        end)
        local attTbl = SL:GetConfig("cfg_att_info", tonumber(i), "id")
        local strName = attTbl.name
        local strValeue
        if i == 200021 then
            maxAtt = v.att[table.count(v.att)]
            if minAtt then
                if minAtt.value == maxAtt.value then
                    table.insert(self.all_info, { name = "攻击力", value = tostring(minAtt.value) })
                else
                    table.insert(self.all_info,
                        { name = "攻击力", value = "<color='" ..
                        minAtt.color ..
                        "'>" ..
                        tostring(minAtt.value) ..
                        "</color>~<color='" .. maxAtt.color .. "'>" .. tostring(maxAtt.value) .. "</color>" })
                end

                minAtt = nil
                maxAtt = nil
            end
        elseif i == 200011 then
            minAtt = v.att[1]
            if maxAtt then
                if minAtt.value == maxAtt.value then
                    table.insert(self.all_info, { name = "攻击力", value = tostring(minAtt.value) })
                else
                    table.insert(self.all_info,
                        { name = "攻击力", value = "<color='" ..
                        minAtt.color ..
                        "'>" ..
                        tostring(minAtt.value) ..
                        "</color>~<color='" .. maxAtt.color .. "'>" .. tostring(maxAtt.value) .. "</color>" })
                end
                minAtt = nil
                maxAtt = nil
            end
        else
            if v.att[1].value == v.att[table.count(v.att)].value then
                if attTbl.remarks == 2 then
                    strValeue = "<color='" ..
                    v.att[table.count(v.att)].color ..
                    "'>" .. tostring(v.att[table.count(v.att)].value / 100) .. "%</color>"
                else
                    strValeue = "<color='" ..
                    v.att[table.count(v.att)].color .. "'>" .. tostring(v.att[table.count(v.att)].value) .. "</color>"
                end
            else
                if attTbl.remarks == 2 then
                    strValeue = "<color='" ..
                    v.att[1].color ..
                    "'>" ..
                    tostring(v.att[1].value / 100) ..
                    "%</color>~<color='" ..
                    v.att[table.count(v.att)].color ..
                    "'>" .. tostring(v.att[table.count(v.att)].value / 100) .. "%</color>"
                else
                    strValeue = "<color='" ..
                    v.att[1].color ..
                    "'>" ..
                    tostring(v.att[1].value) ..
                    "</color>~<color='" ..
                    v.att[table.count(v.att)].color .. "'>" .. tostring(v.att[table.count(v.att)].value) .. "</color>"
                end
            end
            table.insert(self.all_info, { name = strName, value = strValeue })
        end
    end
end

function this:CloseEquipTips()
    GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLArchangelGrailTips/KLArchangelGrailTipsPanel")
end

function this:Close()
    if self.Schedule1 then
        SL:UnSchedule(self.Schedule1)
    end
end

function this:EquipAttrDataListItemCountFunc()
    return #self.all_info
end

function this:EquipAttrDataListItemGetFunc(realIndex)

end

function this:EquipAttrDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:EquipAttrDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.all_info[realIndex + 1]
    local root = GUI:GetChildControl(self.view.all_info_data, realIndex, "root")
    local title = GUI:GetChildControl(self.view.all_info_data, realIndex, "title")
    local di = GUI:GetChildControl(self.view.all_info_data, realIndex, "di")
    local bg = GUI:GetChildControl(self.view.all_info_data, realIndex, "bg")
    local value = GUI:GetChildControl(self.view.all_info_data, realIndex, "value")
    local desc = GUI:GetChildControl(self.view.all_info_data, realIndex, "desc")
    if data.title then
        GUI:setContentSize(root, 350, 25)
        GUI:setVisible(title, true)
        GUI:setVisible(di, true)
        GUI:setVisible(value, false)
        GUI:setVisible(desc, false)
        GUI:setVisible(bg, false)
        GUI:Image_loadTexture(title, data.title, "Atlas/TipsAttTitle.spriteatlas")
    else
        GUI:setContentSize(root, 350, 16)
        GUI:setVisible(title, false)
        GUI:setVisible(di, false)
        GUI:setVisible(value, true)
        GUI:setVisible(bg, true)
        local value_str = data.name .. "  " .. data.value
        GUI:Text_setString(value, value_str)
        if data.color then
            GUI:Text_setTextColor(value, data.color)
        end
        if not data.isSuit then
            if data.color == E_ArchangelGrailQualityColor[E_ArchangelGrailQuality.Green] then
                GUI:Image_loadTexture(bg, "bg_tips_1", "Atlas/UIArchangelGrail.spriteatlas")
            elseif data.color == E_ArchangelGrailQualityColor[E_ArchangelGrailQuality.Blue] then
                GUI:Image_loadTexture(bg, "bg_tips_2", "Atlas/UIArchangelGrail.spriteatlas")
            elseif data.color == E_ArchangelGrailQualityColor[E_ArchangelGrailQuality.Purple] then
                GUI:Image_loadTexture(bg, "bg_tips_3", "Atlas/UIArchangelGrail.spriteatlas")
            elseif data.color == E_ArchangelGrailQualityColor[E_ArchangelGrailQuality.Golden] then
                GUI:Image_loadTexture(bg, "bg_tips_4", "Atlas/UIArchangelGrail.spriteatlas")
            elseif data.color == E_ArchangelGrailQualityColor[E_ArchangelGrailQuality.Color] then
                GUI:Image_loadTexture(bg, "bg_tips_5", "Atlas/UIArchangelGrail.spriteatlas")
            end
        end

        if data.desc then
            GUI:setVisible(desc, true)
            GUI:Text_setString(desc, data.desc)
        end
        if data.descColor then
            GUI:Text_setTextColor(desc, data.descColor)
        end
    end
end

function this:depotsBtnUpdate()
    GUI:setVisible(self.view.left_btn, true)
    GUI:Button_setTitleText(self.view.left_btn, "丢弃")

    GUI:setVisible(self.view.right_btn, true)
    GUI:Button_setTitleText(self.view.right_btn, "取出")
    self.left_all = { { "11" } }
end

function this:bagBtnUpdate()
    local leftButton = SL:GetEquipValue(EMetaVarGetKey.EQUIP_TIPS_LEFT_BUTTON, self.args.equip_pos, self.args.cfgId,
        self.args.id)
    local rightButton = SL:GetEquipValue(EMetaVarGetKey.EQUIP_TIPS_RIGHT_BUTTON, self.args.equip_pos, self.args.cfgId,
        self.args.id)
    local isDelete = SL:GetConfig("cfg_item", self.args.cfgId).isDelete

    self.left_all = {}
    self.left_all_item = {}
    for i, v in ipairs(leftButton) do
        -- for j, btn_type in ipairs(v) do
        --     if btn_type == "9" and isDelete == 0 then
        --     else
        --         table.insert(self.left_all, btn_type)
        --     end
        -- end
        local btn_type = v[1]
        if btn_type == "9" and isDelete == 0 then
        else
            table.insert(self.left_all, v)
        end
    end
    self.right_all = {}
    self.right_all_item = {}
    for i, v in ipairs(rightButton) do
        -- for j, btn_type in ipairs(v) do
        --     if btn_type == "9" and isDelete == 0 then
        --     else
        --         table.insert(self.right_all, btn_type)
        --     end
        -- end
        local btn_type = v[1]
        if btn_type == "9" and isDelete == 0 then
        else
            table.insert(self.right_all, v)
        end
    end
    self.left_is_open = false
    local ui = GUI:GetUI("dev/outui/Archangel/Panel/KLArchangelGrail/KLArchangelGrailPanel")
    if not ui then
        if #self.left_all < 1 then
            GUI:setVisible(self.view.left_btn, false)
        elseif #self.left_all == 1 then
            GUI:setVisible(self.view.left_btn, true)
            local str = self:getBtnName(self.left_all[1])
            GUI:Button_setTitleText(self.view.left_btn, str)
        else
            GUI:setVisible(self.view.left_btn, true)
            GUI:Button_setTitleText(self.view.left_btn, "更多")
            GUI:DataListInitData(self.view.left_data_list, function()
                return self:LeftDataListItemCountFunc()
            end, function(realIndex)
                return self:LeftDataListItemGetFunc(realIndex)
            end, function(realIndex, kmlcontrol)
                return self:LeftDataListItemInitFunc(realIndex, kmlcontrol)
            end, function(realIndex, kmlcontrol)
                return self:LeftDataListItemUpdateFunc(realIndex, kmlcontrol)
            end)
        end
    end
    if GUI:GetUI("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel") then
        GUI:setVisible(self.view.right_btn, true)
        GUI:Button_setTitleText(self.view.right_btn, "放入")
        return
    end

    self.right_is_open = false
    if ui then
        GUI:setVisible(self.view.left_btn, true)
        GUI:setVisible(self.view.right_btn, true)
        GUI:Button_setTitleText(self.view.left_btn, "分解")
        GUI:Button_setTitleText(self.view.right_btn, "融合")
        return
    end
    if #self.right_all < 1 then
        GUI:setVisible(self.view.right_btn, false)
    elseif #self.right_all == 1 then
        GUI:setVisible(self.view.right_btn, true)
        local str = self:getBtnName(self.right_all[1])
        GUI:Button_setTitleText(self.view.right_btn, str)
    else
        GUI:setVisible(self.view.right_btn, true)
        GUI:Button_setTitleText(self.view.right_btn, "更多")
        GUI:DataListInitData(self.view.right_data_list, function()
            return self:RightDataListItemCountFunc()
        end, function(realIndex)
            return self:RightDataListItemGetFunc(realIndex)
        end, function(realIndex, kmlcontrol)
            return self:RightDataListItemInitFunc(realIndex, kmlcontrol)
        end, function(realIndex, kmlcontrol)
            return self:RightDataListItemUpdateFunc(realIndex, kmlcontrol)
        end)
    end
end

function this:BtnLeftOnClick()
    ---@type KLArchangelGrailPanel
    local archangelGroup = GUI:GetUI("dev/outui/Archangel/Panel/KLArchangelGroup/KLArchangelGroupPanel")
    if archangelGroup then
        GUI:Toggle_setIsOn(archangelGroup.view.decomposeToggle, true)
        self:CloseEquipTips()
        return
    end
    if #self.left_all < 1 then

    elseif #self.left_all == 1 then
        local btnType = self.left_all[1][1]
        if not InfoManager.equipOrItemTipsInfo:IsCanOnClickButton(self.left_all[1]) then
            return
        end
        if btnType == "0" then
            self:CloseEquipTips()
        elseif btnType == "2" then
            self:CloseEquipTips()
        elseif btnType == "3" then
            self:PutOneEquip()
        elseif btnType == "9" then
            local name = SL:GetEquipValue(EMetaVarGetKey.EQUIP_NAME, self.args.equip_pos, self.args.cfgId, self.args.id)
            SL:CommonTipsMessage({
                showTips = "是否摧毁" .. name,
                ui = self,
                sureBtnText = "确定",
                cancelBtnText = "取消",
                callback = self.DestroyItem
            })
        elseif btnType == "10" then
            self:JieFeng()
        elseif btnType == "11" then
            self:DiuQi()
        elseif btnType == "13" then
            self:Decompose()
        elseif btnType == "99" then
            self:OpenPanel(self.left_all[1])
        end
    else
        if not self.left_is_open then
            GUI:setVisible(self.view.left_btn_content, true)
            self.left_is_open = true
            GUI:DataListUpdateData(self.view.left_data_list)
        else
            GUI:setVisible(self.view.left_btn_content, false)
            self.left_is_open = false
        end
    end
end

function this.DestroyItem(returnData)
    local ui = returnData.ui
    local index = SL:GetBagIndex(ui.args.id)
    SL:ReqDestroyItemMessage(index)
    ui:CloseEquipTips()
end

function this:getBtnName(data)
    local btn_type = data[1]
    if btn_type == "0" then
        return "取消"
    elseif btn_type == "1" then
        return "使用"
    elseif btn_type == "2" then
        return "回收"
    elseif btn_type == "3" then
        return "穿戴"
    elseif btn_type == "4" then
        return "强化"
    elseif btn_type == "5" then
        return "上架"
    elseif btn_type == "6" then
        return "合并"
    elseif btn_type == "7" then
        return "拆分"
    elseif btn_type == "8" then
        return "批量使用"
    elseif btn_type == "9" then
        return "摧毁"
    elseif btn_type == "10" then
        return "解封"
    elseif btn_type == "11" then
        return "丢弃"
    elseif btn_type == "13" then
        return "分解"
    elseif btn_type == "14" then
        return "装备"
    elseif btn_type == "99" then
        return data[2]
    end
    return ""
end

function this:LeftDataListItemCountFunc()
    return #self.left_all
end

function this:LeftDataListItemGetFunc(realIndex)
    local data = self.left_all[realIndex + 1]
    local str = self:getBtnName(data)
    local message = { equip_pos = self.args.equip_pos, cfgId = self.args.cfgId, id = self.args.id, btnType = data, nameStr =
    str }
    local item = GUI:UIPanel_Open("dev/ui/Tips/Item/KLUITips/KLTipBtntem", self.view.left_data_list, self, message, true)
    self.left_all_item[item.view.root] = item
    return item.view.root
end

function this:LeftDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:LeftDataListItemUpdateFunc(realIndex, kmlcontrol)
end

function this:BtnRightOnClick()
    ---@type KLArchangelGrailPanel
    local archangelGrail = GUI:GetUI("dev/outui/Archangel/Panel/KLArchangelGrail/KLArchangelGrailPanel")
    if archangelGrail then
        archangelGrail:Fusion(self.args.id, self.args.cfgId)
        self:CloseEquipTips()
        return
    end
    if self.args.equip_pos == "depots" then
        local storeIndex = SL:GetDepotsIndex(self.args.id)
        SL.Equip:ReqStoreTakeButtonMessage(storeIndex)
        self:CloseEquipTips()
        return
    end
    local depotPanel = GUI:GetUI("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel")
    if depotPanel then
        local BagIndex = SL:GetBagIndex(self.args.id)
        if depotPanel.bagType == "privilege" then
            SL.Equip:ReqBagPutStoreButtonMessage(BagIndex, SL:GetDepotsCurPage() + depotPanel.maxDepotsPages)
        else
            SL.Equip:ReqBagPutStoreButtonMessage(BagIndex, SL:GetDepotsCurPage())
        end
        self:CloseEquipTips()
        return
    end

    if #self.right_all < 1 then

    elseif #self.right_all == 1 then
        local btnType = self.right_all[1][1]
        if not InfoManager.equipOrItemTipsInfo:IsCanOnClickButton(self.right_all[1]) then
            return
        end
        if btnType == "0" then
            self:CloseEquipTips()
        elseif btnType == "1" then
            self:UseItem()
        elseif btnType == "2" then
            self:CloseEquipTips()
        elseif btnType == "3" then
            self:PutOneEquip()
        elseif btnType == "9" then
            SL:CommonTipsMessage({
                showTips = "是否摧毁" .. name,
                ui = self,
                sureBtnText = "确定",
                cancelBtnText = "取消",
                callback = self.DestroyItem
            })
        elseif btnType == "10" then
            self:JieFeng()
        elseif btnType == "11" then
            self:DiuQi()
        elseif btnType == "13" then
            self:Decompose()
        elseif btnType == "14" then
            --准备坐骑道具
            local panel = GUI:GetUI("dev/outui/Mount/Panel/KLMountEquip/KLMountEquipPanel")
            if panel then
                local BagIndex = SL:GetBagIndex(self.args.id)
                ---@type cfg_item_column
                local tbl = SL:GetConfig("cfg_item", self.args.cfgId, "id")
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MOUNT_PUT_ON_ITEM,
                    { self.args.mountId, BagIndex, tbl.subType, self.args.cfgId, self.args.id })
            else
                GUI:UIPanel_Open("dev/outui/Mount/Panel/KLMountStore/KLMountStorePanel", nil, nil)
                GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
            end
            self:CloseEquipTips()
        elseif btnType == "99" then
            self:OpenPanel(self.right_all[1])
        end
    else
        if not self.right_is_open then
            GUI:setVisible(self.view.right_btn_content, true)
            self.right_is_open = true
            GUI:DataListUpdateData(self.view.right_data_list)
        else
            GUI:setVisible(self.view.right_btn_content, false)
            self.right_is_open = false
        end
    end
end

function this:OpenPanel(btnType)
    if #btnType < 3 then
        return
    end
    self:CloseEquipTips()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    local panel = btnType[4]
    if #btnType == 4 then
        GUI:UIPanel_Open(panel)
    elseif #btnType == 5 then
        local num = btnType[5]
        if tonumber(num) then
            num = tonumber(num)
        end
        GUI:UIPanel_Open(panel, nil, nil, num)
    elseif #btnType >= 7 then
        local message = {}
        for i = 5, #btnType - 2, 3 do
            if btnType[i] and btnType[i + 1] and btnType[i + 2] then
                if btnType[i + 1] == "string" then
                    message[btnType[i]] = btnType[i + 2]
                else
                    message[btnType[i]] = tonumber(btnType[i + 2])
                end
            end
        end
        GUI:UIPanel_Open(panel, nil, nil, message)
    end
    SL.HideMainPanel()
end

function this:RightDataListItemCountFunc()
    return #self.right_all
end

function this:RightDataListItemGetFunc(realIndex)
    local data = self.right_all[realIndex + 1]
    local str = self:getBtnName(data)
    local message = { equip_pos = self.args.equip_pos, cfgId = self.args.cfgId, id = self.args.id, btnType = data, nameStr =
    str }
    local item = GUI:UIPanel_Open("dev/ui/Tips/Item/KLUITips/KLTipBtntem", self.view.right_data_list, self, message, true)
    self.right_all_item[item.view.root] = item
    return item.view.root
end

function this:RightDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:RightDataListItemUpdateFunc(realIndex, kmlcontrol)
end

function this:RES_OTHER_ANGE_GRAIL_INFO(_, message)
    self.otherGrail = message[tostring(self.args.id)]
    self:Refresh()
end

function this:DiuQi()
    local index = SL:GetDepotsIndex(self.args.id)
    if index then
        SL:ReqStoreGiveUpItemMessage(index)
    end
    self:CloseEquipTips()
end

function this:CloseOtherTips()
    if self.args.baseUI then
        GUI:UIPanel_Close(nil, self.args.baseUI)
    end
    local itemGetPathPanel = GUI:GetUI("dev/ui/Common/Panel/KLItemGetPath/KLItemGetPathPanel")
    if itemGetPathPanel then
        GUI:UIPanel_Close("dev/ui/Common/Panel/KLItemGetPath/KLItemGetPathPanel")
    end
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTipsOther/KLIUItemTipsOtherPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
end

return this
