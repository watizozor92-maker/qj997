---@class AppearInfo
AppearInfo = class()
local this = AppearInfo

---@type table<EEquipSlotType,number>
local serverAppear = {}

---变身戒指缓存，在变身卡牌结束后再切回变身戒指变身
---@type table<number,number>
local cacheMonsterId = {}

local checkPos = {
    EEquipSlotType.Helmet,
    EEquipSlotType.Armor,
    EEquipSlotType.Boot,
    EEquipSlotType.Pant,
    EEquipSlotType.Glove,
    EEquipSlotType.FashionTotalArmor,
    EEquipSlotType.Banner,
}

---@class EquipSlot2AngleSlot
local EquipSlot2AngleSlot = {
    [EEquipSlotType.ArchangelWeapon] = EEquipSlotType.Weapon,
    [EEquipSlotType.Weapon] = EEquipSlotType.ArchangelWeapon,
    [EEquipSlotType.ArchangelOffHandWeapon] = EEquipSlotType.OffHandWeapon,
    [EEquipSlotType.OffHandWeapon] = EEquipSlotType.ArchangelOffHandWeapon,
    [EEquipSlotType.ArchangelTwoHandWeapon] = EEquipSlotType.TwoHandWeapon,
    [EEquipSlotType.TwoHandWeapon] = EEquipSlotType.ArchangelTwoHandWeapon,
    [EEquipSlotType.ArchangelHelmet] = EEquipSlotType.Helmet,
    [EEquipSlotType.Helmet] = EEquipSlotType.ArchangelHelmet,
    [EEquipSlotType.ArchangelArmor] = EEquipSlotType.Armor,
    [EEquipSlotType.Armor] = EEquipSlotType.ArchangelArmor,
    [EEquipSlotType.ArchangelGlove] = EEquipSlotType.Glove,
    [EEquipSlotType.Glove] = EEquipSlotType.ArchangelGlove,
    [EEquipSlotType.ArchangelPant] = EEquipSlotType.Pant,
    [EEquipSlotType.Pant] = EEquipSlotType.ArchangelPant,
    [EEquipSlotType.ArchangelBoot] = EEquipSlotType.Boot,
    [EEquipSlotType.Boot] = EEquipSlotType.ArchangelBoot,
}

---@class EquipSlot2FashionSlot
local EquipSlot2FashionSlot = {
    [EEquipSlotType.FashionHelmet] = EEquipSlotType.Helmet,
    [EEquipSlotType.Helmet] = EEquipSlotType.FashionHelmet,
    [EEquipSlotType.FashionArmor] = EEquipSlotType.Armor,
    [EEquipSlotType.Armor] = EEquipSlotType.FashionArmor,
    [EEquipSlotType.FashionWeapon] = EEquipSlotType.Weapon,
    [EEquipSlotType.Weapon] = EEquipSlotType.FashionWeapon,
    [EEquipSlotType.FashionTwoHandWeapon] = EEquipSlotType.TwoHandWeapon,
    [EEquipSlotType.TwoHandWeapon] = EEquipSlotType.FashionTwoHandWeapon,
    [EEquipSlotType.FashionOffHandWeapon] = EEquipSlotType.OffHandWeapon,
    [EEquipSlotType.OffHandWeapon] = EEquipSlotType.FashionOffHandWeapon,
    [EEquipSlotType.FashionGlove] = EEquipSlotType.Glove,
    [EEquipSlotType.Glove] = EEquipSlotType.FashionGlove,
    [EEquipSlotType.FashionPant] = EEquipSlotType.Pant,
    [EEquipSlotType.Pant] = EEquipSlotType.FashionPant,
    [EEquipSlotType.FashionBoot] = EEquipSlotType.Boot,
    [EEquipSlotType.Boot] = EEquipSlotType.FashionBoot,
    [EEquipSlotType.FashionWing] = EEquipSlotType.Wing,
    [EEquipSlotType.Wing] = EEquipSlotType.FashionWing,
    [EEquipSlotType.Guard] = EEquipSlotType.FashionGuard,
    [EEquipSlotType.FashionGuard] = EEquipSlotType.Guard,
    [EEquipSlotType.LeftArtifact] = EEquipSlotType.LeftArtifact,
    [EEquipSlotType.RightArtifact] = EEquipSlotType.RightArtifact,
    [EEquipSlotType.Banner] = EEquipSlotType.Banner,
}

---@type number
local curTitleId

---@type number
local curMonsterId

---@param message table<EEquipSlotType,number>
local function OnEquipAppearSaveSucc(_, message)
    if not message then
        return
    end

    table.clear(serverAppear)
    for slot, cfgId in pairs(message) do
        slot = tonumber(slot)
        serverAppear[slot] = cfgId
    end

    local meId = SL:GetMetaValue("UID")

    SL:RefreshAppear(meId, serverAppear)

end

---@param message {rid:number,appear:{slot:number,cfgId:number}[],ring:number,title:number}
local function OnOtherRoleAppearChange(_, message)
    ---@type table<EEquipSlotType,number>
    local dt = {}
    if message.appear then
        for _, kp in pairs(message.appear) do
            local slot = tonumber(kp.slot)
            dt[slot] = kp.cfgId
        end
    end

    SL:RefreshAppear(message.rid, dt)

    local monsterId
    local ringId = tonumber(message.ring)
    if ringId and ringId > 0 then
        ---@type cfg_item_column
        local itemTbl = SL:GetConfig("cfg_item", ringId)
        monsterId = tonumber(itemTbl.useParam)
    end

    cacheMonsterId[message.rid] = monsterId
    if SL:GetMetaValue("ACTOR_IS_MAINPLAYER", message.rid) then
        ---变身卡牌优先级更高
        if InfoManager.shapeShiftCardInfo:isShiftMonster(message.rid) then
            monsterId = InfoManager.shapeShiftCardInfo:GetMonsterModelId()
        end
    end
    SL:RefreshToShowMonster(message.rid, monsterId)

    local titleId = tonumber(message.title)
    SL:RefreshTitle(message.rid, titleId)
end

local function GetEquipItem(pos, cfgId)
    ---@type CommonProtos.Item[]
    local allEquips = SL:GetMetaValue("EQUIP_DATA_LIST", pos)
    for _, equipItem in pairs(allEquips) do
        if equipItem.cfgId == cfgId then
            return equipItem
        end
    end
end

---@param equip CommonProtos.Item
local function GetGrade(equip)
    return (equip and equip.itemExtInfo and equip.itemExtInfo.equipExtInfo and equip.itemExtInfo.equipExtInfo.grade) or 0
end


-- 穿装后处理，返回哪些装备要显示到外观上
-- 时装部位显示高于装备部位（cfg_item/strPart）
-- 道具品阶越高显示优先级越高（cfg_equip_quality/id）
-- 品阶相同则道具id越低显示优先级越高（cfg_item/id）
---@param equip CommonProtos.Item
---@return table<EEquipSlotType,number>
local function PutEquipAndGetAppearIdx(putIndex, equip)
    local wearBar, pos = SL:GetWearBarAndPosBaseEquipIndex(putIndex)
    local isFashion = pos > 100 and pos ~= EEquipSlotType.Mount

    local isAngle = pos >= 71 and pos <= 78

    ---@type table<EEquipSlotType,number>
    local appearIdx = table.copy(serverAppear)
    local cfgId = equip.cfgId
    ---@type cfg_item_column
    local itemCfg = SL:GetConfig("cfg_item", cfgId)
    if not itemCfg then
        return serverAppear
    end


    --全身时装需要替换所有部件,头盔，护甲，鞋子，裤子， 护手,包括已经装的全身时装
    if pos == EEquipSlotType.FashionTotalArmor and isFashion then
        for _, slot in pairs(checkPos) do
            appearIdx[slot] = nil
            local rp = EquipSlot2FashionSlot[slot]
            if rp then
                appearIdx[rp] = nil
            end
        end

        appearIdx[pos] = cfgId
        return appearIdx
    end

    if appearIdx[EEquipSlotType.FashionTotalArmor] then
        for _, appearType in pairs(E_AppearSuitSlot) do
            --修改保存修改数据
            for _, part in pairs(E_AppearType2StrPart[appearType]) do
                if part == pos then
                    return appearIdx
                end
            end
        end
    end

    if isFashion then
        local normalSlot = EquipSlot2FashionSlot[pos]
        --穿戴的是fashion 普通去掉 ，如果有大天使，使用大天使(如果有fashion,同时将fashion去除 )
        appearIdx[normalSlot] = nil
        local angelSlot = EquipSlot2AngleSlot[normalSlot]
        if appearIdx[angelSlot] then
            appearIdx[pos] = nil
            return appearIdx
        end
    elseif isAngle then
        --穿戴大天使 普通去掉，fashion去掉
        local normalSlot = EquipSlot2AngleSlot[pos]
        appearIdx[normalSlot] = nil
        local fashionSlot = EquipSlot2FashionSlot[normalSlot]
        appearIdx[fashionSlot] = nil
    else
        local angelSlot = EquipSlot2AngleSlot[pos]
        if angelSlot and appearIdx[angelSlot] then
            --穿戴的是普通 有大天使 使用大天使，同时如果有fashion,将fashion去除
            local fashionSlot = EquipSlot2FashionSlot[pos]
            if fashionSlot then
                appearIdx[fashionSlot] = nil
            end
            return appearIdx
        end

        local fashionSlot = EquipSlot2FashionSlot[pos]
        if fashionSlot and appearIdx[fashionSlot] then
            --穿戴的是普通 没有大天使 同时如果有fashion,使用fashion
            return appearIdx
        end

    end

    local grade = GetGrade(equip)
    if appearIdx[pos] then
        ---@type CommonProtos.Item
        local useItem = GetEquipItem(pos, appearIdx[pos])
        local useGrade = GetGrade(useItem)
        if grade > useGrade or (grade == useGrade and cfgId < useItem.cfgId) then
            appearIdx[pos] = cfgId
        end
        return appearIdx
    end

    appearIdx[pos] = cfgId
    return appearIdx

end

---@return CommonProtos.Item
local function GetHightestGradeEquip(pos)
    ---@type CommonProtos.Item[]
    local allEquips = SL:GetMetaValue("EQUIP_DATA_LIST", pos)
    local hItem
    local grade = -1
    local cfgId = 0
    for _, equipItem in pairs(allEquips) do
        local tempGrade = GetGrade(equipItem)
        if tempGrade > grade or (tempGrade == grade and equipItem.cfgId < cfgId) then
            hItem = equipItem
            grade = tempGrade
            cfgId = equipItem.cfgId
        end
    end

    return hItem
end

---@param appearIdx  table<EEquipSlotType,number>
---@param slot  EEquipSlotType
local function InsertToAppear(appearIdx, slot)
    ---@type CommonProtos.Item
    local equipItem = GetHightestGradeEquip(slot)
    if equipItem then
        appearIdx[slot] = equipItem.cfgId
    end
end


-- 脱装后处理，返回哪些装备要显示到外观上
-- 脱下当前外观装备时，外观选中所穿戴的高阶装备
-- 没有其他装备则为裸模
-- 脱下全身时装时， 按规则显示对应的5个防具
-- 脱下主手，副手时装时，找普通装备的最高阶
-- 脱下普通装备， 不找时装， 只找该pos下的最高阶
---@param equip CommonProtos.Item
---@return table<EEquipSlotType,number>
local function TakeOffEquipAndGetAppearIdx(takeOffIndex, equip)
    local wearBar, pos = SL:GetWearBarAndPosBaseEquipIndex(takeOffIndex)
    ---@type table<EEquipSlotType,number>
    local appearIdx = table.copy(serverAppear)

    if not appearIdx[pos] or appearIdx[pos] ~= equip.cfgId then
        return appearIdx
    end

    if appearIdx[pos] and appearIdx[pos] == equip.cfgId then
        appearIdx[pos] = nil
    end

    if pos == EEquipSlotType.FashionTotalArmor then
        InsertToAppear(appearIdx, EEquipSlotType.Helmet)
        InsertToAppear(appearIdx, EEquipSlotType.Armor)
        InsertToAppear(appearIdx, EEquipSlotType.Boot)
        InsertToAppear(appearIdx, EEquipSlotType.Glove)
        InsertToAppear(appearIdx, EEquipSlotType.Pant)
        return appearIdx
    end

    local isFashion = pos > 100

    local isAngle = pos >= 71 and pos <= 78

    if isFashion then
        local normalSlot = EquipSlot2FashionSlot[pos]
        --脱下的是fashion ，如果有大天使，使用大天使,没有用普通
        local angelSlot = EquipSlot2AngleSlot[normalSlot]
        if appearIdx[angelSlot] then
            appearIdx[pos] = nil
            appearIdx[normalSlot] = nil
            return appearIdx
        end

        InsertToAppear(appearIdx, angelSlot)
        if appearIdx[angelSlot] then
            appearIdx[pos] = nil
            appearIdx[normalSlot] = nil
            return appearIdx
        end
        InsertToAppear(appearIdx, normalSlot)
        return appearIdx

    elseif isAngle then
        --脱下大天使  如果有 fashion使用fashion,没有fashion使用普通的
        local normalSlot = EquipSlot2AngleSlot[pos]
        local fashionSlot = EquipSlot2FashionSlot[normalSlot]
        InsertToAppear(appearIdx, pos)

        if appearIdx[pos] then
            appearIdx[fashionSlot] = nil
            appearIdx[normalSlot] = nil
            return appearIdx
        end

        if appearIdx[fashionSlot] then
            appearIdx[normalSlot] = nil
            return appearIdx
        end

        InsertToAppear(appearIdx, fashionSlot)
        if appearIdx[fashionSlot] then
            appearIdx[normalSlot] = nil
            return appearIdx
        end
        InsertToAppear(appearIdx, normalSlot)
        return appearIdx
    end
    
    return appearIdx
end

---@param message EquipProto.EquipIndex
local function OnEquipTakeOn(_, message)
    ---@type table<EEquipSlotType,number>
    local roleAppear = PutEquipAndGetAppearIdx(message.index, message.equip)
    ---@type {slot:number,cfgId:number}[]
    local dt = {}
    for slot, cfgId in pairs(roleAppear) do
        table.insert(dt, { slot = slot, cfgId = cfgId })

        --为了解决新创建弓箭手第一次进入场景中，再同一帧会连续给角色穿戴一个箭袋一个弓箭所导致外观保存发出的第一个请求还没有回包，serverAppear数据没有修改，第二个装备保存覆盖第一个导致弓箭不显示,这样处理是不严谨的
        serverAppear[slot] = cfgId
    end

    SL:SendLuaNetMsg(LuaMessageIdToSever.SETTING_EQUIP_APPEAR, { equipindex = dt, isUpdateView = true })

    --穿戴装备带技能的自动选中挂机的技能
    local cfgId = message.equip.cfgId
    local skillName = EquipFunc.GetEquipSkillShow(message.equip)
    if skillName and not string.isNullOrEmpty(skillName) then
        ---@type cfg_item_column
        local cfg =  SL:GetConfig("cfg_item",cfgId)
        if cfg.skillzidai and table.count(cfg.skillzidai) > 0  then
            SL:SetMetaValue(EMetaVarSetKey.SET_HOOK_ATUO_RELEASE_SKILL,cfg.skillzidai[1],cfg.skillzidai[1])
        end
    end
end

---@param message EquipProto.EquipIndex
local function OnEquipTakeOff(_, message)
    ---@type table<EEquipSlotType,number>
    local roleAppear = TakeOffEquipAndGetAppearIdx(message.index, message.equip)

    ---@type {slot:number,cfgId:number}[]
    local dt = {}
    for slot, cfgId in pairs(roleAppear) do
        table.insert(dt, { slot = slot, cfgId = cfgId })
    end
    --为了解决重置属性点导致的同一帧所有穿戴的有属性点要求的装备脱下时，导致的消息响应不及时，这里面将服务器即将返回的数据提前保存
    serverAppear = roleAppear
    SL:SendLuaNetMsg(LuaMessageIdToSever.SETTING_EQUIP_APPEAR, { equipindex = dt, isUpdateView = true })

    SL:ScheduleOnce(0.5, function()
        local showSkills = SL:GetMetaValue(EMetaVarGetKey.SKILL_SHOW_LIST)
        local num = 0 
        local skill_id = 0
        for k, v in pairs(showSkills) do
            if v ~= 0 then
                num = num + 1
                skill_id = v
            end
        end
        if num == 1 and skill_id ~= 0 then
            SL:SetMetaValue(EMetaVarSetKey.SET_HOOK_ATUO_RELEASE_SKILL,skill_id,skill_id)
        end
    end)
end

local function OnRingSaveSucc(_, message)
    local ring = tonumber(message)
    curMonsterId = nil
    if ring and ring > 0 then
        ---@type cfg_item_column
        local itemTbl = SL:GetConfig("cfg_item", ring)
        curMonsterId = tonumber(itemTbl.useParam)
    end
    --local meId = SL:GetMetaValue("UID")
    local meId = SL:GetMetaValue(EMetaVarGetKey.UID)
    cacheMonsterId[meId] = curMonsterId
    SL:RefreshToShowMonster(meId, curMonsterId)
end

local function OnTitleSaveSucc(_, titleId)
    local meId = SL:GetMetaValue("UID")
    curTitleId = titleId
    SL:RefreshTitle(meId, titleId)
end

---@param message {title:TitleData[],curEquipTitle:number,hidden:boolean}
local function OnGetTitle(_, message)
    curTitleId = tonumber(message.curEquipTitle)
    this.titleData = message
end

---@param message {curWearRing:number,title:RingData[]}
local function OnGetRing(_, message)
    curMonsterId = nil
    local ring = tonumber(message.curWearRing)
    if ring and ring > 0 then
        ---@type cfg_item_column
        local itemTbl = SL:GetConfig("cfg_item", ring)
        curMonsterId = tonumber(itemTbl.useParam)
    end
    this.ringData = message
end

--返回外观
---@param message {slot:number,cfgId:number}[]
local function OnGetAppear(_, message)
    table.clear(serverAppear)
    for _, kp in pairs(message) do
        local slot = tonumber(kp.slot)
        serverAppear[slot] = kp.cfgId
    end
end

---@param message {rid:number,curEquipTitle:number}
local function OnTitleChange(_, message)
    if not message or not message.rid then
        return
    end

    SL:RefreshTitle(message.rid, message.curEquipTitle)
end

---@param message {rid:number,curEquipRing:number}
local function OnRingChange(_, message)
    if not message or not message.rid then
        return
    end
    local ring = tonumber(message.curEquipRing)
    curMonsterId = nil
    if ring and ring > 0 then
        ---@type cfg_item_column
        local itemTbl = SL:GetConfig("cfg_item", ring)
        curMonsterId = tonumber(itemTbl.useParam)
    end
    cacheMonsterId[message.rid] = curMonsterId
    local monsterId = curMonsterId
    ---变身卡牌优先级更高
    if InfoManager.shapeShiftCardInfo:isShiftMonster(message.rid) then
        monsterId = InfoManager.shapeShiftCardInfo:GetMonsterModelId()
    end
    SL:RefreshToShowMonster(message.rid, monsterId)
end

local function OnPlayerEnterMap()
    --进入地图需要请求数据
    SL:SendLuaNetMsg(LuaMessageIdToSever.GET_EQUIP_APPEAR)
    SL:SendLuaNetMsg(LuaMessageIdToSever.GET_TITLE)
    SL:SendLuaNetMsg(LuaMessageIdToSever.GET_SHAPE_RING)
end

--{
--    oldIndex : 旧装备索引
--    newIndex : 新装备索引
--    itemId : 装备唯一id
--}
---@param message {oldIndex : number ,newIndex:number,itemId:number}
local function OnWearAutoChange(_,message)
    --刷新装备数据 
    SL:SwitchEquipSlot(message)
    
    --处理外观数据
    local wearBar1, oldPos = SL:GetWearBarAndPosBaseEquipIndex(message.oldIndex)
    local wearBar2, newPos = SL:GetWearBarAndPosBaseEquipIndex(message.newIndex)

    local roleAppear = table.copy(serverAppear)
    roleAppear[newPos]= roleAppear[oldPos]
    roleAppear[oldPos] = nil
    ---@type {slot:number,cfgId:number}[]
    local dt = {}
    for slot, cfgId in pairs(roleAppear) do
        table.insert(dt, { slot = slot, cfgId = cfgId })
    end

    SL:SendLuaNetMsg(LuaMessageIdToSever.SETTING_EQUIP_APPEAR, { equipindex = dt, isUpdateView = true })
    
end

local function RegistNetMsgs()

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_SETTING_EQUIP_APPEAR, OnEquipAppearSaveSucc)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.OTHER_ROLE_APPEAR, OnOtherRoleAppearChange)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TITLE_CHANGE_UPDATE, OnTitleChange)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RING_CHANGE_UPDATE, OnRingChange)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PUTOON_RING, OnRingSaveSucc)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.SETTING_TITLE_APPEAR, OnTitleSaveSucc)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.GET_TITLE, OnGetTitle)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.GET_SHAPE_RING, OnGetRing)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.GET_EQUIP_APPEAR, OnGetAppear)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WEAPON_CHANGE_AUTO, OnWearAutoChange)

    SL:RegisterLUAEvent(LUA_EVENT_TAKE_ON_EQUIP, OnEquipTakeOn)
    SL:RegisterLUAEvent(LUA_EVENT_TAKE_OFF_EQUIP, OnEquipTakeOff)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_ENTER_MAP, OnPlayerEnterMap)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_EQUIP_SUIT_CHART, this.RES_EQUIP_SUIT_CHART)
end

local function Init()
    RegistNetMsgs()
end

local function Reset()
    table.clear(serverAppear)
    table.clear(cacheMonsterId)
    ---@type number
    curTitleId = nil

    ---@type number
    curMonsterId = nil
    table.clear(this.fasionMapData)
    this.ringData = {}
    this.titleData = {}
end

---==对外==============================================================================================================
this.Init = Init
this.Reset = Reset

this.GetCurAppearList = function()
    return serverAppear
end

this.GetCurTitleId = function()
    return curTitleId
end

this.GetCurMonsterId = function()
    return curMonsterId
end

this.GetCacheMeMonsterId = function(rid)
    return cacheMonsterId[rid]
end

--时装
function this.RES_EQUIP_SUIT_CHART(id, message)
    this.fasionMapData = message
    SL:onLUAEvent(LUA_EVENT_FASHION_EQUIP_DATA_CHANGE)
end

function this.GetFashionActiveInfo(cfgId)
    if this.fasionMapData and this.fasionMapData.suitChart then
        return this.fasionMapData.suitChart[cfgId] or this.fasionMapData.suitChart[tostring(cfgId)]
    end
end

function this.GetFashionMapData()
    return this.fasionMapData
end

