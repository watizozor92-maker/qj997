local this = SL

function this:GetItemColor(cfgId)
    ---@type cfg_item_column
    local item = SL:GetConfig("cfg_item", cfgId)
    if item then
        ---@type cfg_color_column
        local colorTbl = SL:GetConfig("cfg_color", item.color)
        return colorTbl.color
    end
end

function this:GetServerOpendifferenceTime()
    --if LoginManager == nil or LoginManager.EnterRoleRes == nil then
    if not SL:GetEnterRoleRes() then
        return -1
    end
    local openTime = Time.FormatTimeYMDHMS(SL:GetEnterRoleRes().openServerTime / 1000)
    local hour = tonumber(string.sub(openTime, 12, 13))
    local minute = tonumber(string.sub(openTime, 15, 16))
    local second = tonumber(string.sub(openTime, 18, 19))
    local differenceTime = 0  --刷新差值
    local refreshTime = 5  --刷新时间5点改为0点
    local isbeforerefresh = hour < refreshTime
    differenceTime = hour * 3600 + minute * 60 + second
    return isbeforerefresh, differenceTime
end

---通过职业筛选奖励物品
function this:GetRewardIdByCareer(rewards)
    local rewardList = {}
    local myCarrer = SL:GetMetaValue(EMetaVarGetKey.JOB)
    for k, v in pairs(rewards) do
        if v[1] == myCarrer then
            for k, v1 in pairs(v) do
                if k ~= 1 then
                    table.insert(rewardList, v1)
                end
            end
        end
    end
    return rewardList
end

---获取职业头像的图集名和图片名
---@return string,string  @图集名，图片名
function this.GetAtlas2CareerHead(baseCareer)
    if tostring(baseCareer) == "1" then
        return "Atlas/MUIcon.spriteatlas", "s_1" .. baseCareer
    end
    return "Atlas/MUIcon.spriteatlas", "1" .. baseCareer
end

-- 校验字符串是否全为中文且不超过num个字
---@param str string @待校验字符串
---@param num number @最大字数,不传货或为0则不限制字数
---@return boolean @是否全为中文且不超过num个字
function this:CheckIsAllCN(str, num)
    if type(str) ~= "string" then
        return false
    end
    local count = 0
    for uchar in str:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        local byte = uchar:byte()
        -- 检查三字节中文范围 (0xE4-0xE9 开头)
        if #uchar ~= 3 or byte < 0xE4 or byte > 0xE9 then
            return false
        end
        count = count + 1
        if num and num > 0 then
            if count > num then
                return false
            end
        end
    end
    return count > 0
end

function this:SetRoleNameColor(role, color)
    if role and role.Head and role.RoleType == ERoleType.Npc then
        local lab_name = role.Head:GetHeadPart(EHeadPart.Name_Part)
        if lab_name then
            lab_name.color = SL:ConvertColorFromHexString(color)
        end
    end
end

local ShowMainPanel_originFunc = this.ShowMainPanel
function this:ShowMainPanel()

    local panel = GUI:GetUI("dev/ui/MainUI/Panel/KLUIPlayerInfo/KLUIPlayerInfoPanel")
    if not panel then
        panel = GUI:UIPanel_Open("dev/ui/MainUI/Panel/KLUIPlayerInfo/KLUIPlayerInfoPanel", nil, nil, nil, false, function(panel)
            GUI:SetAnchoredPosition(panel.view.root, Vector2.New(0, -1420))
            GUI:DOAnchorPos(GUI:GetRectTransform(panel.view.root), Vector2.New(0, 0), 0.5)
        end)
    else
        if GUI:getPositionY(panel.view.root) ~= 0 then
            GUI:DOAnchorPos(GUI:GetRectTransform(panel.view.root), Vector2.New(0, 0), 0.5)
        end
    end
    local panel1 = GUI:GetUI("dev/outui/Activity/Panel/KLTeamCopyStatus/KLTeamCopyStatusPanel")
    if not panel1 then
        return ShowMainPanel_originFunc(this)
    end
  
end
local HideMainPanel_originFunc = this.HideMainPanel
function this:HideMainPanel()
    return HideMainPanel_originFunc(this)
end
local SendTransferToNpcMessage_originFunc = this.SendTransferToNpcMessage
function this:SendTransferToNpcMessage(npcListId, show, ForceConditionMeet)
    local levelCondition = false
    local CostCondition = true
    local npcListId = tonumber(npcListId)
    if ForceConditionMeet then
        return SendTransferToNpcMessage_originFunc(this, npcListId, show)
    else
        local npcList = SL:GetConfig("cfg_npclist", npcListId)
        local map_info = SL:GetConfig("cfg_map_info", npcList.mapId)
        local mapMove_info = SL:GetConfigMultiKeys("cfg_mapMove", npcList.mapId, "mapID")
        --local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
        levelCondition = mapMove_info.level <= SL:MeData_GetLevel()
        local cost = map_info.transferCost
        local transmissionCost = InfoManager.redNameInfo:GetMapTransmissionCost()
        if cost and cost[1] and cost[1][2] then
            CostCondition = cost[1][2] * transmissionCost <= SL:GetBagItemCount(cost[1][1])
        end

        if levelCondition and CostCondition then
            self:FGRunToNpc(npcListId)
        else
            if not levelCondition then
                SL:TipMessage(string.format("等级不满足，%s等级后可传送", mapMove_info.level), 1, NoticeType.NoticeMid)
                return
            end
            if not CostCondition then
                SL:TipMessage("消耗金币不满足，无法传送", 1, NoticeType.NoticeMid)
                return
            end
        end

    end

end
function this:FGRunToNpc(npcListId)
    local npcList = SL:GetConfig("cfg_npclist", npcListId)
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    local mapMoveTbl = SL:GetConfigMultiKeys("cfg_mapMove",mapId,"mapID")
    if mapId ~= npcList.mapId then---非同地图
        SL:showTransferAnimation()
        SL:ScheduleOnce(0.5, function()
            local ShortcutMgr = SL:Get_G()['ShortcutMgr']
            ShortcutMgr.RunToNpc(npcListId, function()
                self:RangeClickNpc(npcListId)
            end)
        end)
    else
        local findDot = SL.Scene:GetFindNearNpcAvilPoint(Dot2(npcList.x, npcList.y), 3, nil)
        SL:ShortcutDO({"moveTo",tostring(mapMoveTbl.id),tostring(findDot.x),tostring(findDot.z)},nil,nil,function()
            self:RangeClickNpc(npcListId)
        end)
    end

end
---到npc一定范围内点击npc
function this:RangeClickNpc(npcListId)
    local npcList_ = SL:GetConfig("cfg_npclist", npcListId)
    local roleX, roleY = SL:MeData_Pos()
    if Mathf.Abs(roleX - npcList_.x) <= 3 and Mathf.Abs(roleY - npcList_.y) <= 3 then
        SL:TalkToNpc(npcListId)
        SL:onLUAEvent(Event.UIShow_MePathMoveStop)
        
        SL:onLUAEvent(LUA_EVENT_UI_SHOW_ME_PATH_STOP)
    end
end
local MessageTip_originFunc = this.MessageTip
function this:MessageTip(messageData)
    local data = SL:GetConfig("cfg_string", messageData.id, "id")
    if not data then
        return
    end
    local type = data.messageType[1]
    local horseRaceLamp = GUI:GetUI("dev/outui/Message/Panel/KLHorseRaceLamp/KLHorseRaceLampPanel")
    if horseRaceLamp and (type == 1 or type == 2 or type == 3 or type == 4 or type == 5 or type == 15 or type == 12 or type == 17 or type == 18) then
        horseRaceLamp:Other(messageData)
    else
        MessageTip_originFunc(this, messageData)
    end
end

function this:OpenCommonTipPanelById(id, self, callbackLeft, callbackRight)
    local data = SL:GetConfig("cfg_privilege_new", id)
    if not data then
        return
    end

    SL:CommonTipsMessage({
        showTips = data.text,
        sureBtnText = (data.instructionRight and data.instructionRight[1] and data.instructionRight[1][1]) or "确定",
        cancelBtnText = not table.isNullOrEmpty(data.instructionLeft) and (data.instructionLeft[1] and data.instructionLeft[1][1]) or "取消",
        ui = self,
        callback = function()
            if callbackRight then
                callbackRight()
                return
            end
            
            if data.instructionRight[2] then
                if data.instructionRight[2][1] == "openUIPanel" then
                    SL:HideAllKmlPanel()
                end
                shortcutOutMgr.DO(data.instructionRight[2])
            end
        end,
        cancelCallBack = function()
            if callbackLeft then
                callbackLeft()
                return
            end

            if data.instructionLeft[2] then
                shortcutOutMgr.DO(data.instructionLeft[2])
            end
        end
    })
end

local GetTotalCoinBaseId_OriginFunc = this.GetTotalCoinBaseId
---@param isAddBind number 是否计算绑定道具数量,默认为true
function this:GetTotalCoinBaseId(cfgId, isAddBind)
    isAddBind = isAddBind == nil and true or isAddBind
    local count = GetTotalCoinBaseId_OriginFunc(this, cfgId)
    if isAddBind then
        ---@type cfg_item_column
        local cfg = SL:GetConfig("cfg_item", cfgId)
        if cfg and cfg.bindEqualItem ~= 0 then
            count = count + GetTotalCoinBaseId_OriginFunc(this, cfg.bindEqualItem)
        end
    end
    return count
end

local GetBagItemCount_OriginFunc = this.GetBagItemCount
function this:GetBagItemCount(cfgId, isAddBind)
    isAddBind = isAddBind == nil and true or isAddBind
    local count = GetBagItemCount_OriginFunc(this, cfgId)
    if isAddBind then
        ---@type cfg_item_column
        if SL:HasConfig("cfg_item", cfgId) then
            local cfg = SL:GetConfig("cfg_item", cfgId)
            if cfg and cfg.bindEqualItem ~= 0 then
                count = count + GetBagItemCount_OriginFunc(this, cfg.bindEqualItem)
            end
        end
    end
    return count
end

---获取绑定道具的数量
---@param cfgId number 道具的cfgId
function this:GetBagBindItemCount(cfgId)
    if SL:HasConfig("cfg_item", cfgId) then
        local cfg = SL:GetConfig("cfg_item", cfgId)
        if cfg.lockItem[1] and cfg.lockItem[1] == 2 then
            -- 绑定道具直接返回数量
            return GetBagItemCount_OriginFunc(this, cfgId)
        end
        return GetBagItemCount_OriginFunc(this, cfg.bindEqualItem)
    end
    return 0
end

local itemGetPathPanelWidth = 242
---根据道具id打开获取途径面板
---@param _equip_pos string @打开的位置
---@param _cfgId number @表id
---@param _id number @唯一id
---@param _count number @数量
---@param _ui UIKmlLuaPanelBase @从什么面板打开的
---@param _callBack function @回调
function this:CommonItemGetPath(_equip_pos, _cfgId, _id, _count, _ui, _callBack, _item, _info)
    if _cfgId then
        SL:OpenTips(_equip_pos, _cfgId, _id, _count, _item, _info, nil, function(tipsKml)
            ---@type cfg_item_column
            local itemCfg = SL:GetConfig("cfg_item", _cfgId)
            if itemCfg.Quickshopping and table.count(itemCfg.Quickshopping) > 0 then
                local posX, posY = GUI:getPosition(tipsKml.view.root)
                local w, h = GUI:getSizeDelta(tipsKml.view.panel_bg)

                -- tips最下面的高度
                --posY = posY - h / 2

                GUI:UIPanel_Open("dev/ui/Common/Panel/KLItemGetPath/KLItemGetPathPanel", nil, nil,
                        { itemId = _cfgId, pos = { posX, posY }, width = w, height = h, ui = _ui, callBack = _callBack, info = _info })
            end
        end)
    end
end

local GetSlotBaseOnCfgId_OriginFunc = this.GetSlotBaseOnCfgId
---根据配置id获取道具在背包的索引
function this:GetSlotBaseOnCfgId(cfgId)
    local index = GetSlotBaseOnCfgId_OriginFunc(this, cfgId)
    if index == nil then
        local cfg = SL:GetConfig("cfg_item", cfgId)
        if cfg.bindEqualItem ~= 0 then
            index = GetSlotBaseOnCfgId_OriginFunc(this, cfg.bindEqualItem)
        end
    end

    return index
end

local GetSuitEquipInfoList_OriginFunc = this.GetSuitEquipInfoList
---获取套装内装备，以及套装效果
---@return table<number,{cfgId:number,isActive:boolean}>,table<number,{attId:number,attNum:number,isActive:boolean}[]>
function this:GetSuitEquipInfoList(cfgId)
    local suitEquipInfoList, suitEffectInfoList = GetSuitEquipInfoList_OriginFunc(this, cfgId)
    if suitEquipInfoList == nil and suitEffectInfoList == nil then
        local cfg = SL:GetConfig("cfg_item", cfgId)
        if cfg and cfg.bindEqualItem ~= 0 then
            suitEquipInfoList, suitEffectInfoList = GetSuitEquipInfoList_OriginFunc(this, cfg.bindEqualItem)
        end
    end
    return suitEquipInfoList, suitEffectInfoList
end

--------------套装---------------
---套装激活的装备数量
---@return number
---@param cfgId number @套装id
function this:GetSuitActiveCount(cfgId)
    if not SL:HasConfig("cfg_equip_suit", cfgId) then
        return 0
    end
    local count = 0
    ---拿一下套装数据

    ---@type cfg_equip_suit_column
    local tbl = SL:GetConfig("cfg_equip_suit", cfgId)
    local levelTb = {}
    ---叠加套装需要判断condition
    if tbl.suitType == EEquipSuitType.AddSuit then
        local suit, result = RedDotConditionUtil.CalculateConditionGroup(tbl.conditions)
        levelTb = result
    end
    ---@type cfg_equip_suit_column[]
    local equipInfo = SL:GetConfigTable("cfg_equip_suit")

    local suitItemList = {}
    local function addSuitItem(id)
        if not suitItemList[id] then
            suitItemList[id] = 1
        else
            suitItemList[id] = suitItemList[id] + 1
        end
    end
    ---拿下同组的套装，可能会有更高级别的
    for _, v in pairs(equipInfo) do
        if v.group == tbl.group and v.level >= tbl.level then
            for _, id in pairs(v.suitItemId) do
                addSuitItem(id)
                if SL:HasConfig("cfg_item", id) then
                    local cfg = SL:GetConfig("cfg_item", id)
                    if cfg.bindEqualItem ~= 0 then
                        addSuitItem(cfg.bindEqualItem)
                    end
                end
            end
        end
    end
    local RoleManager = SL:Get_G()['RoleManager']
    --同group每等级所装备的套装数量
    for id, ct in pairs(suitItemList) do
        local isHave, equipTbl = RoleManager.meData.equipInfo:HaveGivenEquipList(id)
        if isHave then
            for i, k in pairs(equipTbl) do
                if i <= ct then
                    if tbl.suitType == EEquipSuitType.AddSuit and table.count(levelTb) >= 3 then
                        if RoleManager.meData.equipInfo:GetWear380LevelByCfgIdAndAttrType(k.cfgId, tonumber(levelTb[2])) >= tonumber(levelTb[3]) then
                            count = count + 1
                        end
                    else
                        count = count + 1
                    end
                end
            end
        end
    end
    if count >= tbl.suitCount then
        count = tbl.suitCount
    end

    return count
end

local UseItem_OriginFunc = this.UseItem
--- 使用道具
---@param cfgId number
---@param id number
---@param count number
---@param notice boolean 是否广播到buffer
---@return boolean @是否使用成功
function this:UseItem(cfgId, id, count, notice)
    local cfg = SL:GetConfig("cfg_item", cfgId)
    if not string.isNullOrEmpty(cfg.useLevelLimit) then
        local useLevelLimit = tonumber(cfg.useLevelLimit)
        if SL:MeData_GetLevel() < useLevelLimit then
            SL:TipMessage(SL:GetConfig("cfg_string", 117).text, 1, NoticeType.NoticeMid)
            return false
        end
    end
    if cfg.useItemAtt and table.count(cfg.useItemAtt) > 0 then
        for i, v in pairs(cfg.useItemAtt) do
            local attId = v[1]
            local attValue = v[2]
            local my_attValue = SL:MeData_GetSpecialAttrValue(attId)
            if my_attValue < attValue then
                SL:TipMessage(SL:GetConfig("cfg_string", 42001).text, 1, NoticeType.NoticeMid)
                return false
            end
        end
    end
    return UseItem_OriginFunc(this, cfgId, id, count, notice)
end

---获取道具绑定的cfgId
function this:GetItemBindCfgId(cfgId)
    if SL:HasConfig("cfg_item", cfgId) then
        local cfg = SL:GetConfig("cfg_item", cfgId)
        if cfg.lockItem[1] and cfg.lockItem[1] == 2 then
            return cfgId
        end
        if cfg.bindEqualItem ~= 0 then
            return cfg.bindEqualItem
        end
    end
    return 0
end

---获取非绑和绑定的道具cfgId
function this:GetItemUnbindAndBindCfgId(cfgId)
    if SL:HasConfig("cfg_item", cfgId) then
        local cfg = SL:GetConfig("cfg_item", cfgId)
        if EquipFunc.GetItemIsBind(cfgId) then
            return cfg.bindEqualItem, cfgId
        end
        return cfgId, cfg.bindEqualItem
    end
    return 0, 0
end

function this:FGReleaseSkill(skillDat)

    if skillDat.common then
        local rid = SL:MeData_GetId()
        local SkillData = InfoManager.LianJiInfo:GetAutoReleaseSkill(tonumber(rid),false,true)
        local commonSkillId = SL:GetMetaValue(EMetaVarGetKey.SKILL_GET_COMMON_ID)---普工技能id
        --logError("SkillId="..SkillData.skillId)
        if SkillData.skillId ~= 0 and SkillData.skillId ~= commonSkillId then
            skillDat.common = nil
            skillDat.skillId = SkillData.skillId
        end
    end

    SL:onLUAEvent(Event.ReleaseSkill, skillDat)
end

function this:MainCameraCreateRoleSet()
    local MainCamera = SL.MainCamera:GetMainCamera()
    if MainCamera then
        local global = SL:GetConfig("cfg_global", 550001)
        if global then
            local strList = string.split(global.value, "|")
            local posList = string.split(strList[1], "#")
            local rotationList = string.split(strList[2], "#")
            local scaleList = string.split(strList[3], "#")
            local trans = MainCamera.initCamera.transform
            trans:SetLocalPosition(tonumber(posList[1]), tonumber(posList[2]), tonumber(posList[3]))
            trans:SetLocalEulerAngles(tonumber(rotationList[1]), tonumber(rotationList[2]), tonumber(rotationList[3]))
            trans:SetLocalScale(tonumber(scaleList[1]), tonumber(scaleList[2]), tonumber(scaleList[3]))
            MainCamera.initCamera.fieldOfView = tonumber(strList[4])
        end

    end
end

function this:GetShowEquip()
    return InfoManager.exBoxTipsInfo:GetShowEquip()
end

function this:ReMoveNowItem()
    return InfoManager.exBoxTipsInfo:ReMoveNowItem()
end

function this:UpdateUseTipPanel()
    return InfoManager.exBoxTipsInfo:UpdateUseTipPanel()
end

function this:AddBoxItem(item)
    return InfoManager.exBoxTipsInfo:AddBoxItem(item)
end

function this:DeleteBoxItem(cfgId)
    return InfoManager.exBoxTipsInfo:DeleteBoxItem(cfgId)
end

function this:UiBoxTipsInfo_GetShowBoxItem()
    return InfoManager.exBoxTipsInfo:GetShowBoxItem()
end

local GetCompareEquip_OriginFunc = this.GetCompareEquip
function this:GetCompareEquip(cfgId)
    ---@type cfg_item_column
    local itemCfg = SL:GetConfig("cfg_item", cfgId)
    local wearBar = itemCfg.wearBarID[1]

    if #itemCfg.strPart == 2 and itemCfg.strPart[1] == EEquipSlotType.Weapon then
        local target = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, EEquipSlotType.TwoHandWeapon)
        if target then
            return target
        end
        --[[if not SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, 1) or not SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, 2) then
            return nil
        end]]
        target = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, EEquipSlotType.Weapon)
        --[[if target == nil then
            target = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, 2)
        end]]
        return target
    end

    if #itemCfg.strPart == 1 and itemCfg.strPart[1] == EEquipSlotType.TwoHandWeapon then
        local target = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, EEquipSlotType.TwoHandWeapon)
        if target == nil then -- 跟主手比
            target = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, EEquipSlotType.Weapon)
        end
        return target
    end

    if #itemCfg.strPart == 1 and (itemCfg.strPart[1] == EEquipSlotType.OffHandWeapon or itemCfg.strPart[1] == EEquipSlotType.Weapon) then
        local target = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, EEquipSlotType.TwoHandWeapon)
        if target then
            local itemCfg2 = SL:GetConfig("cfg_item", target.cfgId)
            local modelCfg = SL:GetConfig("cfg_model_charactor", itemCfg2.shape[1])
            if modelCfg.part == 6 or modelCfg.part == 7 then -- 弓箭手的武器单独处理
                modelCfg = SL:GetConfig("cfg_model_charactor", itemCfg.shape[1])
                if modelCfg.part == 114 or modelCfg.part == 115 then
                    target = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, itemCfg.strPart[1])
                end
            end
        else
            target = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, itemCfg.strPart[1])
        end
        return target
    end

    return GetCompareEquip_OriginFunc(this, cfgId)
end

function this:FormatTimeDHMNoShowDay(time)
    local s = time % 60
    local m = time // 60 % 60
    local h = time // 3600 % 24
    local d = time // 86400

    if d <= 0 then
        return string.format("%02d时%02d分%02d秒", h, m, s);
    end
    return string.format("%02d天%02d时%02d分%02d秒", d, h, m, s);
end

local refreshRed = this.RefreshPanelALLRedPoint
function this:RefreshPanelALLRedPoint(panelName)
    if panelName == "KLUISystemLeftPanel" then
        SL:RefreshPanelALLRedPoint("KLUIPlayerInfoPanel")
    end
    refreshRed(self, panelName)
end

local checkEquipWear = this.CheckEquipWear
---@param item CommonProtos.Item @装备的cfgId
---@return number @ 0不满足 1满足 穿戴要求
function this:CheckEquipWear(item)
    if not SL:MeData_Check() then
        return 0
    end
    if item then
        if SL:HasConfig("cfg_item", item.cfgId) then
            local cfgInfo = SL:GetConfig("cfg_item", item.cfgId)
            if cfgInfo == nil then
                return 0
            end

            if cfgInfo.type ~= EItemType.Equip then
                return 0
            end
        end
        local needAttrs = EquipFunc.CheckAttrsCanEquip(item)
        if table.count(needAttrs) > 0 then
            return 0
        end
        if not EquipFunc.CheckLevelCanEquip(item) then
            return 0
        end
        if not EquipFunc.CheckJobCanEquip(item) then
            return 0
        end
        return 1
    end

    return checkEquipWear(this, item)
end

--强化后穿戴要求变了，改成外置自己的逻辑
function this.Equip:ShowCantEquipTip_Out(ItemInfo)
    if not EquipFunc.CheckLevelCanEquip(ItemInfo) then
        --显示等级不足提示
        SL:CommonTipsMessage({showTips = "等级不符合"})
    elseif not EquipFunc.CheckJobCanEquip(ItemInfo) then
        --显示职业不符合
        SL:CommonTipsMessage({showTips = "职业不符合"})
    else
        local needAttrs = EquipFunc.CheckAttrsCanEquip(ItemInfo)
        local needPoint = 0
        if table.count(needAttrs) > 0 then
            --显示属性不足
            local strList = {}
            local changeLine = "\n"
            table.insert(strList, "<color=#FF2323>")
            for _, v in pairs(needAttrs) do
                needPoint = needPoint + v.subValue
                ---@type cfg_att_info_column
                local att = SL:GetConfig("cfg_att_info", v.attrId)
                local text = string.format("<color=#FFFFFF>%s:%d</color>(还差%d)", att.name, v.attrValue, v.subValue)
                table.insert(strList, text)
                table.insert(strList, changeLine)
            end
            table.insert(strList, "</color>")
            local ownPoint = SL:GetMetaValue("REMAIN_ATTR_POINT")
            local endText 
            local callBack 
            if ownPoint >= needPoint then
                endText = "检测到有可分配属性点数，是否分配"
                callBack = function()
                    SL:PutOnEquip(ItemInfo)
                end
            else
                endText = "<color=#FF2323>可分配属性点不足，请前往升级</color>"
                callBack = function()
                    SL:TipMessage( "可分配属性点不足", 1, NoticeType.NoticeMid )
                end
            end
            table.insert(strList, changeLine)
            table.insert(strList, endText)
            local content = table.concat(strList)
            SL:CommonTipsMessage({showTips = content, title = "穿戴装备需要满足", callback = callBack})
        end
    end
end

local jsonDecode = this.JsonDecode
function this:JsonDecode(data)
    if type(data) == "table" then
        return data
    end
    return jsonDecode(this, data)
end

local mapTransfer = this.MapTransfer
---传送到地图传送点
---@param mapid number
---@param line number
---@param mapMoveId number
function this:MapTransfer(mapId,line  , mapMoveId, data,moveType)
    local type = data and data.type or nil
    local x = data and data.x or nil
    local y = data and data.y or nil
    local errorNum = SL:MapLimitCondition(mapId, line,mapMoveId)
    if errorNum ~= EMapMoveConditionError.None then
        return
    end
    
    if line then
        local mapId = mapId and mapId or SL:GetConfig("cfg_mapMove",mapMoveId).mapID
        local lines = SL:GetConfig("cfg_map_line",mapId).mapLine
        if line > #lines then -- 不能超过最大线路
            line = #lines
        end
    end

    if not mapId then
        if SL:HasConfig("cfg_mapMove", mapMoveId) then
            ---@type cfg_mapMove_column
            local mapMoveTbl = SL:GetConfig("cfg_mapMove", mapMoveId)
            if SL:HasConfig("cfg_map_info", mapMoveTbl.mapID) then
                mapId = mapMoveTbl.mapID
            end
        end
    end
    
     --冰封堡特殊处理
    if mapId == 1003 and line == 6 then
        type = 2
        x = InfoManager.bingFengBaoInfo.config[2]
        y = InfoManager.bingFengBaoInfo.config[3]
    end
    
    if not type then
        mapTransfer(this, mapId, line, mapMoveId)----这个接口切换不了线路了
    elseif type == 1 then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MAP_MOVE_TRANSFER, { id = mapMoveId, line = line ,moveType = moveType })
    elseif type == 2 then     -- 自定义传送位置
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CUSTOM_TRANSFER,
            {
                mapCfgId = mapId,
                line = line,
                x = x,
                y = y
            })
    end
end

---传送方法集合,内置通用传送，外置通用传送，副本传送等可集合在这里
---@param mapId number
---@param line number
---@param mapMoveId number
---@param data {type:number,isUseCommonConditionLimit:boolean }
function this:ReqTransfer(mapId, line, mapMoveId, data,moveType)
    --通过这个判断使用哪个类型的传送
    local type = data and data.type or nil
    local x = data and data.x or nil
    local y = data and data.y or nil
    --是否使用地图通用条件限制
    local isUseCommonConditionLimit = data and data.isUseCommonConditionLimit or nil
    if isUseCommonConditionLimit then
        local errorNum = SL:MapLimitCondition(mapId, line,mapMoveId)
        if errorNum ~= EMapMoveConditionError.None then
            return
        end
    end

    if not mapId then
        if SL:HasConfig("cfg_mapMove", mapMoveId) then
            ---@type cfg_mapMove_column
            local mapMoveTbl = SL:GetConfig("cfg_mapMove", mapMoveId)
            if SL:HasConfig("cfg_map_info", mapMoveTbl.mapID) then
                mapId = mapMoveTbl.mapID
            end
        end
    end
    --冰封堡特殊处理
    if mapId == 1003 and line == 6 then
        type = 2
        x = InfoManager.bingFengBaoInfo.config[2]
        y = InfoManager.bingFengBaoInfo.config[3]
    end

    if not type then
        SL:MapTransfer(mapId, line, mapMoveId)
    elseif type == 1 then
        if not mapMoveId then
            ---@type cfg_mapMove_column
            local mapMoveInfo = SL:GetConfigMultiKeys("cfg_mapMove", mapId, "mapID")
            if mapMoveInfo then
                mapMoveId = mapMoveInfo.id
            end
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MAP_MOVE_TRANSFER, { id = mapMoveId, line = line,moveType = moveType })
    elseif type == 2 then -- 自定义传送位置
         SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CUSTOM_TRANSFER,
            {
                mapCfgId = mapId,
                line = line,
                x=x, 
                y=y
            })
    end
end
function this:MapLimitCondition(mapId,line,mapMoveId)
    if line then
        local showCondition,entryCondition = SL:LineCondition(mapId,line)
        if not ConditionManager.Check4D(entryCondition) then
            SL:TipMessage("线路条件不满足", 1, NoticeType.NoticeMid)
            return EMapMoveConditionError.Line
        end
    end
    
    local mapMoveTbl = nil
    local map_info = nil
    if mapId then
        if SL:HasConfig("cfg_map_info", mapId) then
            map_info = SL:GetConfig("cfg_map_info", mapId)
            mapMoveTbl = SL:GetConfigMultiKeys("cfg_mapMove",mapId,"mapID")
        end
    elseif mapMoveId then
        if SL:HasConfig("cfg_mapMove", mapMoveId) then
            ---@type cfg_mapMove_column
            mapMoveTbl = SL:GetConfig("cfg_mapMove", mapMoveId)
            if SL:HasConfig("cfg_map_info", mapId) then
                map_info = SL:GetConfig("cfg_map_info", mapId)
            end
        end
    end
    


    if mapMoveTbl then
        if not SL:CheckCondition(mapMoveTbl.conditions) then
            SL:TipMessage("需要穿戴翅膀", 1, NoticeType.NoticeMid)
            return EMapMoveConditionError.Flying
        end
        if SL:MeData_GetLevel() < mapMoveTbl.level then
            SL:TipMessage(string.format("等级不满足，%s等级后可传送",  mapMoveTbl.level), 1, NoticeType.NoticeMid)
            return EMapMoveConditionError.Level,mapMoveTbl.level
        end
    end


    if map_info then
        local tips = InfoManager.redNameInfo:IsLimitTransferById(SL:GetMetaValue("MAIN_ACTOR_ID"), map_info.id, line)
        if tips then
            SL:TipMessage(tips, 1, NoticeType.NoticeMid)
            return EMapMoveConditionError.RedName
        end
        
        if SL:MeData_GetLevel() < map_info.intolv then
            SL:TipMessage(string.format("等级不满足，%s等级后可传送", map_info.intolv), 1, NoticeType.NoticeMid)
            return EMapMoveConditionError.Level,map_info.intolv
        end
        
        local cost = map_info.transferCost
        local conditionCheck2
        if cost and cost[1] and cost[1][2] then
            local transmissionCost = InfoManager.redNameInfo:GetMapTransmissionCost()
            conditionCheck2 = cost[1][2] * transmissionCost <= SL:GetBagItemCount(cost[1][1])
        else
            conditionCheck2 = true
        end
        if not conditionCheck2 then
            SL:TipMessage("消耗金币不满足，无法传送", 1, NoticeType.NoticeMid)
            return EMapMoveConditionError.Coin
        end
    end

    return EMapMoveConditionError.None
end
----线路进入条件
function this:LineCondition(mapID,lineId)
    local showCondition = ""--面板显示条件
    local entryCondition =""--实际进入条件
    if SL:HasConfig("cfg_map_line",mapID) then
        local map_line_table = SL:GetConfig("cfg_map_line",mapID)
        if map_line_table then
            local showStr = map_line_table.showCondition
            local showStrList = string.split(showStr,'|')
            for _,strInput in pairs(showStrList) do
                local char = strInput:sub(1, 1)
                if char == lineId then
                    showCondition = strInput:sub(3, string.len(strInput))
                end
            end

            local showStr2 = map_line_table.entryCondition
            local showStrList2 = string.split(showStr2,'|')
            for _,strInput in pairs(showStrList2) do
                local char = strInput:sub(1, 1)
                if char == lineId then
                    entryCondition = strInput:sub(3, string.len(strInput))
                end
            end
        end
    end
    return showCondition,entryCondition
end
---获取是否在副本中
function this:Out_IsInCopy()
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    if mapId then
        ---@type cfg_map_info_column
        local cfg = SL:GetConfig("cfg_map_info", mapId)
        if cfg.type == 2 then
            return true
        end
    end
    return false
end

---获取是否可使用召唤技能
function this:IsCanUseSummonSkill(skillId)
    local me = SL:GetRoleById(SL:MeData_GetId())
    if not me or (me and me:IsMoving()) then return false end
    if not SL:GetMeSummonBeastsRole() then
        local isCanUse, error  = SL:GetMetaValue(EMetaVarGetKey.SKILL_CHECK_CAN_USE,skillId,0,SL:MeData_GetCoord())
        if isCanUse or error == ESkillReleaseError.None then
            return true
        end
    end
    return false
end

---寻路（支持跨地图）
---@param monsterId number 寻路过程中碰到目标怪物配置id会回调目标位置，可以再次寻路到目标位置进行战斗
---@param isTransferLine boolean 是否传送到指定线路
function this:Pathfinding(mapId, line, x, y, arriveFunc, monsterId,isTransferLine)
    local mapInfo = SL:GetConfig("cfg_map_info", mapId, "id")
    if not SL:MeData_Check() or not mapInfo then
        return
    end
    SL.Scene:SetTransMapMoveToPointCallbackFunc(nil)
    local curLine = SL:GetMetaValue(EMetaVarGetKey.MAP_LINE)
    local curMapId = tonumber(SL:GetMetaValue(EMetaVarGetKey.MAP_ID))
    if curMapId and (curMapId ~= mapId or (curMapId == mapId and curLine ~= line)) then
        if mapInfo.type ~= EMapType.CopyMap then
            if isTransferLine then
                SL:ReqTransfer(mapId, line,nil,{isUseCommonConditionLimit = true,type = 1})
            else
                SL:ReqTransfer(mapId, line,nil,{isUseCommonConditionLimit = true})
            end
        end
        SL.Scene:SetTransMapMoveToPointCallbackFunc(function()
            SL:PathMoveTo(Dot2.New(x, y), nil, nil, arriveFunc, true, nil, nil, 1, nil, nil, nil, nil, monsterId)
        end)
    else
        SL:PathMoveTo(Dot2.New(x, y), nil, nil, arriveFunc, true, nil, nil, 1, nil, nil, nil, nil, monsterId)
    end
end

local startOnHook_Origin = this.StartOnHook
---开始挂机
function this:StartOnHook(isReq, isHandCall, attackMonsterCfgId)
    --self:ClearOnArriveCallBack()
    return startOnHook_Origin(this,isReq, isHandCall, attackMonsterCfgId)
end

---属性点(id:10070001)快捷提示条件是否满足 返回值 bool
function this:CheckIsShowAttributeBoxTip()
    local newAttrNum = SL:GetMetaValue("REMAIN_ATTR_POINT") or 0
    if newAttrNum ~= InfoManager.roleOtherInfo.oldAttrNum then
        InfoManager.roleOtherInfo.oldAttrNum = newAttrNum
        local meData = SL:GetMeData()
        if not meData then
            return false
        end
        if not meData.roleExtInfo then
            return false
        end

        local roleExtInfo = meData.roleExtInfo
        local boxItem = {}
        local item = {}
        item.cfgId = tonumber(SL:GetConfig("cfg_global",820002).value)
        boxItem.item = item
        if roleExtInfo.remainAttrPoint and roleExtInfo.remainAttrPoint >= 1 then
            --logError("属性点快捷提示条件满足")
            SL:AddBoxItem(boxItem)
            SL:UpdateUseTipPanel()
            return true
        else
            --logError("不满足显示条件 ")
            SL:DeleteBoxItem(item.cfgId)
            SL:UpdateUseTipPanel()
            return false
        end
    end
end

---检查地图相关快捷指令传送消耗是否满足，如instruct[1] = moveToNPCOpenPanel | transferMapAndLine | transferNPC
---@param instruct StringList
---@return boolean 是否是地图传送指令
---@return boolean 是否满足条件 
function this:CheckMapTransferInstructCost(instruct)
    local command = instruct[1]
    -- 根据不同的指令类型进行处理
    if command == "moveToNPCOpenPanel" or command == "transferNPC" then
        -- 这两种指令都需要传送到NPC所在位置
        if #instruct < 2 then
            SL:LogError("指令格式错误：" .. command)
            return true,false
        end
        local npcId = tonumber(instruct[2])
        if not npcId then
            return true,false
        end
        
        -- 获取NPC配置信息
        local npcList = SL:GetConfig("cfg_npclist", npcId)
        if not npcList then
            return true,false
        end
        
        local costId = SL:GetTransferCostId(npcList.mapId)
        return true,self:CheckMapTransferCost(npcList.mapId),costId
    elseif command == "transferMapAndLine" then
        -- 需要传送到指定地图和线路
        if #instruct < 3 then
            SL:LogError("指令格式错误：" .. command)
            return false,true
        end
        local mapMoveId = tonumber(instruct[2])
        local line = tonumber(instruct[3])
        if not mapMoveId or not line then
            return true,false
        end

        local costId = SL:GetTransferCostId(nil,mapMoveId)
        -- 使用现有的MapLimitCondition方法检查传送条件
        return true,self:CheckMapTransferCost(nil, line, mapMoveId),costId
    else
        -- 不支持的指令类型
        return false
    end
end

---检查地图传送消耗是否满足
function this:CheckMapTransferCost(mapId, line,mapMoveId)
    local errorNum = SL:MapLimitCondition(mapId, line,mapMoveId)
    if errorNum == EMapMoveConditionError.Coin then
        return false
    end
    return true
end

---获取地图传送消耗的货币id
---@param mapId number
---@param mapMoveId number
function this:GetTransferCostId(mapId,mapMoveId)
    local mapMoveTbl = nil
    ---@type cfg_map_info_column
    local map_info = nil
    if mapId then
        if SL:HasConfig("cfg_map_info", mapId) then
            map_info = SL:GetConfig("cfg_map_info", mapId)
            mapMoveTbl = SL:GetConfigMultiKeys("cfg_mapMove",mapId,"mapID")
        end
    elseif mapMoveId then
        if SL:HasConfig("cfg_mapMove", mapMoveId) then
            ---@type cfg_mapMove_column
            mapMoveTbl = SL:GetConfig("cfg_mapMove", mapMoveId)
            local mapId = mapMoveTbl.mapID

            if SL:HasConfig("cfg_map_info", mapId) then
                map_info = SL:GetConfig("cfg_map_info", mapId)
            end
        end
    end
    return map_info.transferCost[1] and map_info.transferCost[1][1]
end

---是否可以任务移动中自动击杀任务怪物
function this:CanTaskMovingAutoKillMonster()
    if SL:HasConfig("cfg_global", 890001) then
        return SL:GetConfig("cfg_global", 890001).value == "1"
    end
    return false
end

local ReqDestroyItemMessage_OriginFunc = this.ReqDestroyItemMessage
function this:ReqDestroyItemMessage(index)
    -- 合成界面不允许摧毁
    if GUI:GetUI("dev/outui/Synthesis/Panel/KLNewNewSynthesis/KLNewNewSynthesisPanel") then
        SL:TipMessage("当前界面不允许摧毁", 1, NoticeType.NoticeMid)
        return
    end
    ReqDestroyItemMessage_OriginFunc(this, index)
end 

---打开boss血条
function this:OpenBossHp(_id,_roleData)
    local panel = GUI:GetUI("dev/ui/MainUI/Panel/KLUIBossHp/KLUIBossHpPanel")
    if panel then
        panel:RefreshUI({ id = _id ,role=_roleData})
    else
        GUI:UIPanel_Open("dev/ui/MainUI/Panel/KLUIBossHp/KLUIBossHpPanel",nil,nil,nil,nil,
        function (ui)
            ui:RefreshUI({ id = _id ,role=_roleData})
        end)
    end
end

---获取玩家对该怪物的综合防御能力
function this:GetHookRealDefense(monsterId)
    local fastItemList = SL:GetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST)
    local hpItemId = fastItemList[2]
    if not SL:HasConfig("cfg_item",hpItemId) then
        hpItemId = InfoManager.mainUIInfo.hpShowModeItemId
    end
    ---@type cfg_item_column
    local item = SL:GetConfig("cfg_item", hpItemId)
    local buffId = tonumber(item.useParam)
    ---@type cfg_buff_column
    local buffTbl = SL:GetConfig("cfg_buff", buffId)
    local _v = buffTbl.buffValue[1][2]                                                                   --当前红药的V
    local _percent = buffTbl.buffValue[1][3] * 0.0001                                                          --当前红药的比例
    local _meLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)                                          --玩家等级
    local _meMaxHp = SL:GetMetaValue(EMetaVarGetKey.MAXHP)                                          --玩家最大生命
    local _hpUpSpeed = SL:GetMetaValue(EMetaVarGetKey.GET_ATTR_VALUE_BY_ID, 207063)          --玩家生命恢复速度
    local _meDamageReduce = SL:GetMetaValue(EMetaVarGetKey.GET_ATTR_VALUE_BY_ID, 312012)     --玩家伤害减少
    local _meDamageSuck =  SL:GetMetaValue(EMetaVarGetKey.GET_ATTR_VALUE_BY_ID, 313012)      --玩家伤害吸收
    local _meDefense = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.armor)   --玩家防御
    local _meMissRate = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.missRate)--玩家防御率
    local _monsterHitRate = SL:GetConfig("cfg_monster_attribute_group", monsterId).hitRate       --怪的攻击率
    local _monsterAttactCoumt = SL:GetConfig("cfg_monster", monsterId).monsterCount              --会同时攻击玩家的怪只数
    if _monsterAttactCoumt == 0 then _monsterAttactCoumt = 1 end
    local _monsterHitSuccessRate                                                                          --怪的命中率
    if _monsterHitRate > _meMissRate then
        _monsterHitSuccessRate = 1 - _meMissRate / _monsterHitRate
    else
        _monsterHitSuccessRate = 0.03
    end
    if _monsterHitRate == 0 then
        logError(monsterId.."怪物命中率为0")
        return 0
    end
    if _monsterAttactCoumt == 0 then
        logError(monsterId.."同时攻击怪物的怪只数为0")
        return 0 
    end
    local max = math.max(_v * 10 - _meLevel * 2, 0)
    --玩家对该怪的综合防御能力 =（实际当前在用的红药的V*10-玩家等级*2 + 实际当前在用的红药的比例*玩家最大生命 + 生命回复速度/3*玩家最大生命）/ 怪的命中率/（会同时攻击玩家的怪只数*0.5）/（1-玩家伤害减少）/（1-玩家伤害吸收） + 玩家防御/2
    local result = (max + _percent * _meMaxHp + _hpUpSpeed * 0.0001 / 3 * _meMaxHp) / _monsterHitSuccessRate / (_monsterAttactCoumt * 0.5) / (1 - _meDamageReduce * 0.0001) / (1 - _meDamageSuck * 0.0001) + _meDefense / 2
    log(monsterId .. "综合防御能力为： "..result)
    return result * 2
end

function this:GetMapLineName(mapId,line)
    local mapLineInfo = SL:GetConfig("cfg_map_line",mapId)
    if string.contains(mapLineInfo.lineName[line],"黄金") then
        return "-黄金"
    end
    if string.contains(mapLineInfo.lineName[line],"PK") then
        return "-PK"
    end
    if string.contains(mapLineInfo.lineName[line],"和平") then
        return "-和平"
    end
    local pkline = string.split(mapLineInfo.pkline,"|")
    if table.contains(pkline,tostring(line)) then
        return "-PK"
    end
    local peaceline = mapLineInfo.peaceline
    if table.contains(peaceline,line) then
        return "-和平"
    end
    local showCondition,entryCondition = SL:LineCondition(mapId,tostring(line))
    if entryCondition and string.contains(entryCondition,"2103#27") then ---黄金分线
        return "-黄金"
    end
    return ""
end 
function this:IsCanUseBuffSkill(skillId)
    local meId = tonumber(SL:MeData_GetId())
    local me = SL:GetRoleById(meId)
    if not me or (me and me:IsMoving()) then return false end
    local isCanUse,error = SL:GetMetaValue(EMetaVarGetKey.SKILL_CHECK_CAN_USE,skillId,0,SL:MeData_GetCoord())
    if not isCanUse or (error ~= ESkillReleaseError.None and error ~= ESkillReleaseError.SkillRangeNotEnough) then
    
    else
        local skills = SL:GetMetaValue(EMetaVarGetKey.LEARNED_SKILLS)
        local skillInfo = skills[skillId].skillInfoTbl
        if skillInfo ~= nil then
            local buffs = SL:GetTargetBuffID(skillInfo)
            if buffs ~= nil then
                for _, buffID in pairs(buffs) do
                    local hasBuff = SL:GetMetaValue(EMetaVarGetKey.ACTOR_HAS_ONE_BUFF_BY_CFG_ID,meId,buffID[1])
                    if hasBuff  then
                        return false
                    else
                        if InfoManager.guardPetInfo.IsOpenMM then
                            local repBuffId = InfoManager.skillInfo:ReplaceBuffId(buffID[1])
                            if repBuffId then
                                local repValue = InfoManager.skillInfo:GetBuffValue(repBuffId)
                                local curValue = InfoManager.skillInfo:GetBuffValue(buffID[1])
                                if curValue <= repValue then
                                    return false
                                end
                            end
                        end
                    end
                end
                return true
            end
        end
    end
    return false
end



---@param cfg cfg_skill_info_column
function this:GetTargetBuffID(cfg)
    if cfg.master_targetBuffID then
        return cfg.master_targetBuffID
    end
    return cfg.targetBuffID
end