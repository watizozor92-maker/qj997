---
--- Created by zhouzhipeng.
--- DateTime: 2024/8/26 上午11:13
--- Desc：
---

-- @lua gm_active_suit_chart 10001
function gm_active_suit_chart(actor, id)
    jprint("进入血 Castle:", DuplicateCommon.CheckEnterConditonCommon(actor, id))
    BloodyCastle.ReqEnterBloodyCastle(actor, id)

end

-- @lua gm_add_item1 20130121
-- @lua gm_add_item1 参数1：道具配置id 参数2：数量（不填默认为1）参数3：走掉落规则还是，生成规则，默认掉落规则（item表paramSource字段） 参数4：cfg_Monster_mbox表id（可不配，不配默认为空，走item表）
function gm_add_item1(actor, itemCfgId, count, paramSource, mboxCfgId)
    count = tonumber(count or 1)
    paramSource = tonumber(paramSource or 0)

    local mboxCfg = {}
    if mboxCfgId then
        local cfg_mbox = ConfigDataManager.getById('cfg_Monster_mbox', mboxCfgId)
        if table.notEmpty(cfg_mbox) then
            mboxCfg = cfg_mbox
        end
    end

    local ids = additemmaptobag(actor, { [itemCfgId] = count }, 0, 9999, "gm生成")
    local extData = Equip_PuTong.qzEquipAtt(itemCfgId, mboxCfg, paramSource)
    --info(actor, "玩家", actor, "触发掉落随机相关 掉落 cfgId：", itemCfgId ,"内容：", extData)
    for _, itemId in pairs(ids) do
        local itemExtData = EquipAndAppear.getItemExtData(actor, itemId)
        table.merge(itemExtData, extData)
        EquipAndAppear.SetItemExtData(actor, itemId, itemExtData)
    end
end

--  @lua gm_add_buff 1300000401
function gm_add_buff(actor, buffCfgId)
    addbuff(actor, buffCfgId)
    jprint("测试gm gm_add_buff 添加buff", buffCfgId)
end

-- @lua gm_del_buff 101000013
function gm_del_buff(actor, buffCfgId)
    delbuff(actor, buffCfgId)
    jprint("测试gm gm_del_buff 删除buff", buffCfgId)
end

-- @lua test1_zzp
function test1_zzp(actor)
    local lockItem = ConfigDataManager.getTableValue("cfg_item", "lockitem", "id", 10030001)
    print(lockItem)
    if lockItem == "" then
        jprint("测试测试  == \"\"")
    end
    if lockItem == nil then
        jprint("测试测试  == nil")

    end
    local lockItem1 = ConfigDataManager.getTableValue("cfg_item", "lockitem", "id", 333333)
    print(lockItem1)
    if lockItem1 == "" then
        jprint("测试测试1  == \"\"")

    end
    if lockItem1 == nil then
        jprint("测试测试1  == nil")
    end
    print("测试 test1_zzp")
end

-- @lua test2_zzp
function test2_zzp(actor)
    setontimerex(TimerIds.OPEN_BREAK_POINT_DEBUG, 9999999, 5)
    print("测试 test2_zzp")
end
-- @lua test3_zzp
function test3_zzp(actor)
    --local data = getrolefield(actor, "role")
    local msgData = {
        id = 4,
        line = 4,
    }
    --local mapCfgId = msgData.mapCfgId
    --local line = msgData.line
    --local y = msgData.y
    --local x = msgData.x
    CustomTransmit.mapMoveTransfer(actor, msgData)
    print("测试 test3_zzp")
end

-- @lua test4_zzp 1 1
function test4_zzp(actor, cfgId, count)
    additemtobag(actor, cfgId, count)
    print("测试 test4_zzp", cfgId, count)
end

-- @lua test5_zzp 1 1
function test5_zzp(actor, cfgId, cfgId2)
    --GetAllBagItemInfo
    --GetBagItemAndEquip
    local firstItemId
    local secondItemId
    local allItemInfo = getallbagiteminfo(actor)
    for _, info in pairs(allItemInfo) do
        if tonumber(cfgId) == info.cfgid and firstItemId == nil then
            firstItemId = info.id
            goto continue
        end
        if tonumber(cfgId2) == info.cfgid and secondItemId == nil then
            secondItemId = info.id
            goto continue
        end
        ::continue::
    end
    if firstItemId ==nil or secondItemId ==nil then
        tipinfo(actor, "没有找到道具")
        return
    end
    local msgData = {
        firstItemId = firstItemId,
        secondItemId = secondItemId,
    }
    EquipRefine.reqEquipRefine(actor, msgData)
    print("测试 test5_zzp", cfgId, cfgId2, firstItemId, secondItemId)
end

-- @lua test5_zzp 1
function test5_zzp(actor, cfgId)
    Buffer.reqNpcAddBuff(actor, {id=cfgId})
    print("测试 test5_zzp", cfgId)
end


ZzpTest = {}

local isPrint = false
-- @lua zzp_log_switch 1
function zzp_log_switch(actor, state)
    local result = tonumber(state) == 1 and true or false
    if result == isPrint then
        jprint("修改日志开关，当前已是该状态", isPrint)
        return
    end
    isPrint = result
    jprint("修改日志开关，当前为", isPrint)
end

function ZzpTest.print(...)
    if isPrint then
        jprint("测试测试 ", ...)
    end
end