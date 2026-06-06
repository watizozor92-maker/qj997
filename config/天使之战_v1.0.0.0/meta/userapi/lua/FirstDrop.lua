-- 装备首曝
-------------------------------------------------- domain层 -----------------------------------------------------
FirstDrop = {}

local FirstDropConfig = {}


-- 首曝全局数据
local FirstDropGlobalRecord = {}
---@class FirstDropGlobalRecord 首曝全局数据
---@field 示例数据 table {itemId = {{首曝玩家数据},{次曝玩家数据}...} }






------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- trigger层 -----------------------------------------------------
-- 事件
function FirstDrop.onItemAdded(actor, itemId, itemCfgId)
    --仅本服执行
    local curServerType = getbaseinfo(actor, "servertype")
    if curServerType ~= ServerType.Game then
        return
    end
    local type = ConfigDataManager.getTableValue("cfg_item", "type", "id", itemCfgId)
    if tonumber(type) ~= ItemType.EQUIP then
        return
    end
   
    local config = FirstDropConfig.getById(itemCfgId)
    if config == nil then
        return
    end
    -- 给道具一个标记，否则玩家装备又脱下会重复触发
    local equipdata = EquipAndAppear.getItemExtData(actor, itemId)
    if equipdata.isFirstObtain == true then
        return
    end
    equipdata.isFirstObtain = true
    EquipAndAppear.SetItemExtData(actor, itemId, equipdata)

    -- 卓越词条限制
    local itemInfo = getequipinfo(actor, itemId, 1)
    if table.count(itemInfo.entries) < config.excellentLimit then
        return
    end
    -- 幸运词条数量限制
    if config.luckyLimit > 0 then
        local extData = itemInfo.luaextdata
        if not extData then
            return
        end
        if table.isNullOrEmpty(extData.luckAttr) then
            return
        end
        if table.count(extData.luckAttr) < config.luckyLimit then
            return
        end
    end
    


    local times = config.times
    local itemRecord = FirstDropGlobalRecord.getById(itemCfgId)
    -- 如果记录已满，则无需继续
    if (not table.isNullOrEmpty(itemRecord)) and #itemRecord >= times then
        return
    end

    --修改全局变量，单线程执行
    callonserial(actor, "record_first_drop", config)
end

-- 全服数据处理
function FirstDrop.combineGlobalVar(varData)
    for sid, var in pairs(varData) do
        if table.count(var) > 0 then
            FirstDropGlobalRecord.set(var)
            info("合服装备首曝数据处理，使用sid为" .. sid .. "的数据")
            break
        end
    end
end

-- 请求
function FirstDrop.reqPanle(actor)
    local globaRecord = FirstDropGlobalRecord.get()
    if table.isNullOrEmpty(globaRecord) then
        globaRecord = {}
    end
    sendluamsg(actor, LuaMessageIdToClient.RES_FIRST_DROP_PANEL, globaRecord)
end

------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- service层 -----------------------------------------------------
function record_first_drop(actor, config)
    local itemCfgId = config.id
    local maxTimes = config.times
    local globaRecord = FirstDropGlobalRecord.get()
    if table.isNullOrEmpty(globaRecord) then
        globaRecord = {}
    end
    local itemRecord = globaRecord[itemCfgId]
    if table.isNullOrEmpty(itemRecord) then
        itemRecord = {}
    end
    if #itemRecord < maxTimes then
        -- 记录玩家信息
        local roleInfo = getrolesummaryinfobyrid(actor)
        local roleRecord = {}
        roleRecord.rid = roleInfo.rid
        roleRecord.name = roleInfo.name
        table.insert(itemRecord, roleRecord)
        globaRecord[itemCfgId] = itemRecord
        FirstDropGlobalRecord.set(globaRecord)
        -- 发奖励给玩家
        local reward = config.reward[#itemRecord]
        local itemCount
        for _, value in pairs(reward) do
            itemCount = value
            break
        end
        Bag.sendRewards(actor, reward, ItemActionProxy.EQUIPMENT_FIRST_SHOW)
        local bao = ""
        if #itemRecord == 1 then
            bao = "首爆"
        elseif #itemRecord == 2 then
            bao = "二爆"
        elseif #itemRecord == 3 then
            bao = "三爆"
        end

        info("装备" .. itemCfgId .. "第" .. (#itemRecord) .. "爆！奖励玩家为:" .. roleInfo.name .. " rid:" .. roleInfo.rid)
        --天降宝藏！【%s】达成【%i】的 %d 获赠了 %s 钻石！
        noticeTip.noticeinfo(actor, StringIdConst.TEXT51001, roleInfo.name, config.name, bao, itemCount)
    end
end

------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- infrastructure层 ----------------------------------------------
-- 配置读取
function FirstDropConfig.getById(itemCfgId)
    local config = ConfigDataManager.getTableFirst("cfg_firstDrop", "id", itemCfgId)
    if config == nil then
        local bindItemId = ConfigDataManager.getTableValue("cfg_item", "bindEqualItem", "id", itemCfgId)
        config = ConfigDataManager.getTableFirst("cfg_firstDrop", "id", bindItemId)
        if config == nil then
            return nil
        end
    end
    local configDTO = {}
    --道具id
    configDTO.id = tonumber(config.id)
    configDTO.name = config.munetext
    --曝次数，例如3就是首曝、次爆、三爆
    configDTO.times = tonumber(config.type)
    --奖励，不同次数奖励不同
    configDTO.reward = {}
    -- 卓越词条数量限制
    configDTO.excellentLimit = string.tonumber(config.excellenceatt)
    -- 幸运词条数量限制
    configDTO.luckyLimit = string.tonumber(config.luckyatt)
    local rSplit = string.split(config.reward, "|")
    for index, value in ipairs(rSplit) do
        local vMap = string.toIntIntMap(value, "#", "&")
        table.insert(configDTO.reward, vMap)
    end
    return configDTO
end

-- 数据存取
function FirstDropGlobalRecord.get()
    local globalData = getsysvar(SystemVarConst.FIRST_DROP_GLOBAL_RECORD)
    return globalData
end

function FirstDropGlobalRecord.set(globalData)
    setsysvar(SystemVarConst.FIRST_DROP_GLOBAL_RECORD, globalData)
end

function FirstDropGlobalRecord.getById(itemCfgId)
    local globalData = getsysvar(SystemVarConst.FIRST_DROP_GLOBAL_RECORD)
    if table.isNullOrEmpty(globalData) then
        return nil
    end
    return globalData[tonumber(itemCfgId)]
end

---------------------------------------------------------------------------------------------------------------------

function test_first_drop_panel(actor)
    FirstDrop.reqPanle(actor)
end

function test_first_drop_clear(actor)
    FirstDropGlobalRecord.set({})
end
