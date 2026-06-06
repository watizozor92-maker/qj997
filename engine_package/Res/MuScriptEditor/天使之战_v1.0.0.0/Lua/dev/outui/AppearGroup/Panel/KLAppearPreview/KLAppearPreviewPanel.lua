---@class KLAppearPreviewPanel:UIKmlLuaPanelBase
---@field view KLAppearPreviewPanelView
local KLAppearPreviewPanel = class(UIKmlLuaPanelBase)
local this = KLAppearPreviewPanel
---创建时调用一次
function this:Init()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.isHideWing = GUI:Toggle_getIsOn(self.view.TogHideWing) == "1"
    self:OnAppearPreviewChange();
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.BtnClose, self, self.BtnCloseOnClick)
    GUI:SetToggleOnValueChange(self.view.TogHideWing, self, self.OnTogHideWingChange)
    SL:RegisterLUAEvent(APPEAR_PREVIEW_SELECT_CHANGE, self.OnAppearPreviewChange, self)
    SL:RegisterLUAEvent(TITLE_PREVIEW_SELECT_CHANGE, self.OnTitlePreviewChange, self)
    SL:RegisterLUAEvent(TRANSFER_RING_PREVIEW_SELECT_CHANGE, self.OnRingPreviewChange, self)
end

function this:OnTogHideWingChange()
    self.isHideWing = GUI:Toggle_getIsOn(self.view.TogHideWing) == "1"
    self:OnPreview(self.appearList, self.curMonsterId, self.curTitleId)
end

function this:OnAppearPreviewChange(_, appearList)
    local cfgIds = appearList
    if not cfgIds then
        cfgIds = InfoManager.appearInfo.GetCurAppearList()
    end
    local curMonsterId = InfoManager.appearInfo.GetCurMonsterId()
    local curTitleId = InfoManager.appearInfo.GetCurTitleId()
    return self:OnPreview(cfgIds, curMonsterId, curTitleId)
end

function this:OnRingPreviewChange(_, ringId)
    local monsterId
    local appearList = InfoManager.appearInfo.GetCurAppearList()
    local curTitleId = InfoManager.appearInfo.GetCurTitleId()
    if ringId and ringId > 0 then
        ---@type cfg_item_column
        local itemTbl = SL:GetConfig("cfg_item", ringId)
        monsterId = tonumber(itemTbl.useParam)
    end
    return self:OnPreview(appearList, monsterId, curTitleId)
end

function this:OnTitlePreviewChange(_, titleId)
    local appearList = InfoManager.appearInfo.GetCurAppearList()
    local curMonsterId = InfoManager.appearInfo.GetCurMonsterId()

    return self:OnPreview(appearList, curMonsterId, titleId)
end

function this:OnPreview(appearList, curMonsterId, curTitleId)
    self.appearList = appearList
    self.curMonsterId = curMonsterId
    self.curTitleId = curTitleId
    if self.curShowRole then
        SL:UIModel_Recycle(self.curShowRole)
    end
    if curMonsterId and curMonsterId > 0 then
        GUI:SetActive(self.view.MonsterModle, true)
        GUI:SetActive(self.view.RoleModel, false)
        GUI:SetActive(self.view.GuardModel, false)
        ---@type cfg_monster_column
        local monsterTbl = SL:GetConfig('cfg_monster', curMonsterId)

        ---@type cfg_model_monster_column
        local modelTbl = SL:GetConfig('cfg_model_monster', monsterTbl.appr)

        GUI:Model_setSrc(self.view.MonsterModle, modelTbl.path)
    else
        GUI:SetActive(self.view.RoleModel, false)
        GUI:SetActive(self.view.MonsterModle, false)
        local model_list, equip_list, guardCfgId = self:GetPlayerRoleInfo(appearList)
        -- GUI:SetPlayerRoleInfo(self.view.RoleModel, model_list, equip_list)
        local roleInfoExtData = InfoManager.cardShapeShiftInfo:DeepCopy(SL:MeData_GetRoleExtInfo().roleInfoExtData)
        for k, v in pairs(roleInfoExtData.equip) do
            local i, j = SL:GetWearBarAndPosBaseEquipIndex(v.index)
            local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", i, j)
            if equip then
                local strengthLevel = EquipFunc.GetEquipStrengthLevel(equip)
                v.gmExtInfo.luaExt = string.format("{\"strengthlv\":%d}", strengthLevel)
            end
        end
        local roleAppear = {}
        for k, v in pairs(appearList) do
            local itemCfg = SL:GetConfig("cfg_item", v)
            if self.isHideWing and itemCfg.type == E_ItemType.Equip and itemCfg.subType == E_ItemSubType_Equip.ChiBang then
            else
                table.insert(roleAppear, { cfgId = v, pos = itemCfg.strPart[1] })
            end
        end
        roleInfoExtData.roleAppear = roleAppear
        self.curShowRole = SL:UIModel_Create(GUI:GetRectTransform(self.view.role_model_root),
            SL:GetMetaValue(EMetaVarGetKey.UID),
            SL:MeData_GetCareer(), SL:MeData_GetLevel(), SL:GetMetaValue(EMetaVarGetKey.USER_NAME),
            0, EAction.Stand, EBehaviourType_Stand.Stand, roleInfoExtData,
            0, -287, -200, 224,
            0, 40, 0)
        if guardCfgId then
            GUI:SetActive(self.view.GuardModel, true)

            ---@type cfg_item_column
            local itemTbl = SL:GetConfig("cfg_item", guardCfgId)

            local modelId = itemTbl.field[1]
            ---@type cfg_model_charactor_column
            local modelTbl = SL:GetConfig('cfg_model_charactor', modelId)

            GUI:Model_setSrc(self.view.GuardModel, modelTbl.path)
        else
            GUI:SetActive(self.view.GuardModel, false)
        end
    end

    if curTitleId and curTitleId > 0 and SL:HasConfig("cfg_item", curTitleId) then
        GUI:SetActive(self.view.TitleModel, true)

        ---@type cfg_item_column
        local itemTbl = SL:GetConfig("cfg_item", curTitleId)
        ---@type cfg_model_charactor_column
        local modelTbl = SL:GetConfig('cfg_model_charactor', itemTbl.shape[1])

        ---@type cfg_fashion_column
        local fashionTbl = SL:GetConfig("cfg_fashion", curTitleId)
        local scale = "300,300,300"
        if fashionTbl.modelScale > 0 then
            scale = string.replace(scale, "300", tostring(fashionTbl.modelScale), "0,0,0")
        end

        GUI:Model_setSrc(self.view.TitleModel, modelTbl.path, scale)
    else
        GUI:Model_setSrc(self.view.TitleModel, "")
        GUI:SetActive(self.view.TitleModel, false)
    end
end

function this:BtnCloseOnClick()
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppearPreview/KLAppearPreviewPanel")
end

function this:Close()
    if self.curShowRole then
        SL:UIModel_Recycle(self.curShowRole)
    end
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppear/KLAppearPanel")
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLTitle/KLTitlePanel")
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLSuit/KLSuitPanel")
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLRender/KLRenderPanel")
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLTransferRing/KLTransferRingPanel")

    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppearGroup/KLAppearGroupPanel")
end

function this:GetPlayerRoleInfo(cfgIds)
    local role_param = { "body", "head", "head1", "armor", "hand", "pants", "boot" }
    local wear_list_str = ""
    local model_list_str = ""
    local guardCfgId
    ---@type cfg_career_column
    local careerTbl = SL:GetMetaValue("ME_CAREER_TAB_COLUMN")
    local default_tbl = SL:GetConfig("cfg_model_default", careerTbl.modelId)
    local model_list = {}
    for _, v in pairs(role_param) do
        model_list[v] = default_tbl[v]
    end

    --修复背了两把短剑只显示一把
    local lastSub2Id = {}

    local hasSuitBody
    for _, cfgId in pairs(cfgIds) do
        if SL:HasConfig("cfg_item", cfgId) then
            ---@type cfg_item_column
            local itemInfo = SL:GetConfig("cfg_item", cfgId)

            if itemInfo.type == E_ItemType.Equip then
                if itemInfo.subType == E_ItemSubType_Equip.MainWeapon then
                    if not lastSub2Id[itemInfo.subType] then
                        if wear_list_str == "" then
                            wear_list_str = "WeaponRspineParent#" .. itemInfo.field[1]
                        else
                            wear_list_str = wear_list_str .. ",WeaponRspineParent#" .. itemInfo.field[1]
                        end
                        lastSub2Id[itemInfo.subType] = cfgId
                    else
                        if wear_list_str == "" then
                            wear_list_str = "WeaponLspineParent#" .. itemInfo.field[1]
                        else
                            wear_list_str = wear_list_str .. ",WeaponLspineParent#" .. itemInfo.field[1]
                        end
                    end
                elseif itemInfo.subType == E_ItemSubType_Equip.SecWeapon then
                    if not lastSub2Id[itemInfo.subType] then
                        if wear_list_str == "" then
                            wear_list_str = "WeaponLspineParent#" .. itemInfo.field[1]
                        else
                            wear_list_str = wear_list_str .. ",WeaponLspineParent#" .. itemInfo.field[1]
                        end
                        lastSub2Id[itemInfo.subType] = cfgId
                    else
                        if wear_list_str == "" then
                            wear_list_str = "WeaponRspineParent#" .. itemInfo.field[1]
                        else
                            wear_list_str = wear_list_str .. ",WeaponRspineParent#" .. itemInfo.field[1]
                        end
                    end
                elseif itemInfo.subType == E_ItemSubType_Equip.MainSecWeapon then
                    if not lastSub2Id[itemInfo.subType] then
                        if wear_list_str == "" then
                            wear_list_str = "WeaponRspineParent#" .. itemInfo.field[1]
                        else
                            wear_list_str = wear_list_str .. ",WeaponRspineParent#" .. itemInfo.field[1]
                        end
                        lastSub2Id[itemInfo.subType] = cfgId
                    else
                        if wear_list_str == "" then
                            wear_list_str = "WeaponLspineParent#" .. itemInfo.field[1]
                        else
                            wear_list_str = wear_list_str .. ",WeaponLspineParent#" .. itemInfo.field[1]
                        end
                    end
                elseif itemInfo.subType == E_ItemSubType_Equip.ChiBang then
                    if not self.isHideWing then
                        if wear_list_str == "" then
                            wear_list_str = "Wing#" .. itemInfo.field[1]
                        else
                            wear_list_str = wear_list_str .. ",Wing#" .. itemInfo.field[1]
                        end
                    end
                elseif itemInfo.subType == E_ItemSubType_Equip.ShouHu then
                    guardCfgId = itemInfo.id
                elseif itemInfo.subType == 30 then
                    if wear_list_str == "" then
                        wear_list_str = "BuffspineParent#" .. itemInfo.field[1]
                    else
                        wear_list_str = wear_list_str .. ",BuffspineParent#" .. itemInfo.field[1]
                    end
                elseif itemInfo.subType == E_ItemSubType_Equip.SuitBody then
                    hasSuitBody = true
                    model_list.head = nil
                    model_list.armor = nil
                    model_list.hand = nil
                    model_list.pants = nil
                    model_list.boot = nil

                    for i = 1, #itemInfo.field do
                        local point
                        ---@type cfg_model_charactor_column
                        local model_tbl = SL:GetConfig("cfg_model_charactor", itemInfo.field[i])
                        if model_tbl then
                            if model_tbl.part == 23 then
                                point = "body"
                            elseif model_tbl.part == 11 then
                                point = "head"
                            elseif model_tbl.part == 2 then
                                point = "armor"
                            elseif model_tbl.part == 9 then
                                point = "hand"
                            elseif model_tbl.part == 15 then
                                point = "pants"
                            elseif model_tbl.part == 5 then
                                point = "boot"
                            end
                            if point then
                                model_list[point] = itemInfo.field[i]
                            end
                        end
                    end
                else
                    local point
                    ---@type cfg_model_charactor_column
                    local model_tbl = SL:GetConfig("cfg_model_charactor", itemInfo.field[1])
                    if model_tbl then
                        if model_tbl.part == 23 then
                            point = "body"
                        elseif model_tbl.part == 11 then
                            if itemInfo.subType == E_ItemSubType_Equip.MianJin then
                                point = "head1"
                            else
                                if not hasSuitBody then
                                    point = "head"
                                end
                            end
                        elseif not hasSuitBody then
                            if model_tbl.part == 2 then
                                point = "armor"
                            elseif model_tbl.part == 9 then
                                point = "hand"
                            elseif model_tbl.part == 15 then
                                point = "pants"
                            elseif model_tbl.part == 5 then
                                point = "boot"
                            end
                        end

                        if point then
                            model_list[point] = itemInfo.field[1]
                        end
                    end
                end
            elseif itemInfo.type == E_ItemType.TriggerItem and itemInfo.subType == E_OutTriggerItemType.GuardSkin then
                guardCfgId = itemInfo.id
            end
        end
    end

    for _, v in pairs(model_list) do
        if model_list_str == "" then
            model_list_str = tostring(v)
        else
            model_list_str = model_list_str .. "#" .. v
        end
    end
    return model_list_str, wear_list_str, guardCfgId
end

return this
