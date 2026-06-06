LSK_Test = {}
LSK_Test.__index = LSK_Test

local this = {}


-- ------------------------------------------------------------- --

-- 测试入口 @lua l_test_main
function l_test_main(actor)
    jprint("-------- lua test main function --------")
end

-- ------------------------------------------------------------- --

-- 测试入口 @lua l_test_main1
function l_test_main1(actor)
    jprint("-------- lua test main1 function --------")
    KunDun.EnterKunDun(actor)
end
-- 测试入口 @lua l_test_main2
function l_test_main2(actor)
    jprint("-------- lua test main2 function --------")
    KunDun.sendPanelData(actor)
end
-- 测试入口 @lua l_test_main3
function l_test_main3(actor)
    jprint("-------- lua test main3 function --------")
    quitduplicate(actor)
end
-- 测试入口 @lua l_test_main4
function l_test_main4(actor)
    jprint("-------- lua test main4 function --------")
    sendmailbyrid(actor:toString(), "这是标题", "这是正文", { [20310111] = 1 })
end
-- 测试入口 @lua l_test_main5
function l_test_main5(actor, flagId)
    jprint("-------- lua test main5 function --------")
    ScriptFightModel.setScriptFightModel(actor)
    ScriptFightModel.setPlayerFightModelValue(actor, flagId, ScriptFightModel.FlagId.KunDun, {flagId})
end

-- ------------------------------------------------------------- --

-- 获取地图信息
-- @lua l_test_map_info
function l_test_map_info(actor)
    local mapId = getbaseinfo(actor, "mapid")
    local x = getbaseinfo(actor, "x")
    local y = getbaseinfo(actor, "y")
    jprint("当前地图ID:", mapId, x, y)
end

-- 校验是否可以进入跨服地图
-- @lua l_test_chack_is_can_enter_cross_map 21000
function l_test_chack_is_can_enter_cross_map(actor, map_id)
    local ret = CrossMap.canEnter(actor, map_id)
    this.jprint("检查是否可以进入跨服地图:", map_id, "result:", ret)
end

-- 初始化圣域BOSS缓存数据 
-- @lua l_test_sanctuary_boss_init_cache
function l_test_sanctuary_boss_init_cache()
    SanctuaryBoss.initBossState()
end

-- 结算战盟更换盟主 
-- @lua l_test_finish_union_change_leader
function l_test_finish_union_change_leader(actor)
    UnionChangeLeader.RunForLeader.finishRunforLeaderActor()
end

-- 战盟臂章最大等级缓存 
-- @lua l_test_union_armbands_init_cache
function l_test_union_armbands_init_cache()
    UnionArmbands.serverStart()
end

-- 发起定点传送 
-- @lua l_test_transfer_within_map 210 180
function l_test_transfer_within_map(actor, x, y)
    MapMoveTransfer.transferWithinMap(actor, { x, y })
end

-- 充值月卡礼包7001 
-- @lua l_test_month_gift_recharge_event 7001 1401
function l_test_month_gift_recharge_event(actor, param, id)
    MonthGiftPack.rechargeEvent(actor, { ['parameter'] = param, ['id'] = id })
end

-- 领取月卡每日礼包 
-- @lua l_test_month_gift_req_recharge 1401
function l_test_month_gift_req_recharge(actor, id)
    MonthGiftPack.reqRechargeAction(actor, _, "reward", { ["id"] = id })
end


-- 昆顿上架道具
-- @lua l_test_kun_dun_auction_system_publish
function l_test_kun_dun_auction_system_publish()
    KunDunAuction.Publish()
end

-- 昆顿执行一次定时器
-- @lua l_test_kun_dun_auction_on_timer
function l_test_kun_dun_auction_on_timer()
    KunDunAuction.ontimer()
end

-- 昆顿执行竞拍
-- @lua l_test_kun_dun_auction_player_bid 19142921868113925
function l_test_kun_dun_auction_player_bid(actor, goodsId)
    local msgData = {['goodsId'] = goodsId, ['type'] = 0}
    KunDunAuction.PlayerBidding(actor, msgData)
end

-- @lua l_test_set_dup_stage 1
function l_test_set_dup_stage(actor, stage)
    local uniMapId = getbaseinfo(actor, "unimapid")
    setduplicatestate(uniMapId, tonumber(stage))
end

function l_test_clear_monster(actor)

    local mapId = getbaseinfo(actor, "unimapid")
    local list = mapbossinfo(mapId)

    for k, v in pairs(list) do
        if tonumber(v.cfgid) ~= 17016 then
            local m_actor = getactor(v.id, mapId)
            removemapobject(m_actor)
        end
    end
    
    print()
end

-- @lua l_test_add_attr 201011 100
function l_test_add_attr(actor, ...)
    local args = { ... }
    local map = {}
    local key = "lsk_test_attr_key"

    if table.isEmpty(args) then
       RoleAttr.clearRoleAttrAndDB(actor, key)
       return
    end

    for i = 1, #args, 2 do
        local key = args[i]
        local value = args[i + 1]
        if key ~= nil and value ~= nil then
            map[key] = value
        end
    end
    
    -- local map = { [302022] = 20000, [1032] = 20000, [10321] = 200000 }
    RoleAttr.addAndSaveRoleAttr(actor, key, map)
end

function l_test_get_att_value(actor, att)
    tipinfo(actor, getattrinfo(actor, att))
end

-- ------------------------------------------------------------- --

this.log_open = true
this.log_name = "[LskTest]"

function this.debug(...)
    if not this.log_open then
        return
    end
    gameDebug.print(this.log_name, ...)
end

function this.jprint(...)
    if not this.log_open then
        return
    end
    if param == nil then
        param = "error! 输出内容为空. nil"
    end
    jprint(this.log_name, ...)
end

function this.info(actor, ...)
    info(actor, ...)
    this.jprint(...)
end
