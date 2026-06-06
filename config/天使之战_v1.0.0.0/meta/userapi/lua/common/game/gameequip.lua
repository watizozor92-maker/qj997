---
--- Created by zhouzhipeng.
--- DateTime: 2024/8/21 下午8:26
---

gameequip = {}

--- 装备栏
---@param idxOfEquip 装备索引
---@return 装备栏
function gameequip.wearBar(idxOfEquip)
    return idxOfEquip >> 16
end

--- 装备部位
---@param idxOfEquip 装备索引
---@return 装备部位
function gameequip.pos(idxOfEquip)
    return idxOfEquip & 0xFF
end

--- 装备索引
---@param 穿戴栏
---@param 装备部位
---@return 装备索引
function gameequip.index(wearBar, pos)
    return wearBar << 16 | pos
end


-- 自定义装备索引
GameEquipIndex = {
    mount = gameequip.index(1, 10001) -- 坐骑装备索引
}

--[[
function testgamemap(actor)
    local indexofequip = 65538
    local wearBarOrSuitId = gameequip.wearBar(indexofequip)
    local pos = gameequip.pos(indexofequip)
    local aa = gameequip.index(wearBarOrSuitId, pos)
    jprint("测试测试", indexofequip, wearBarOrSuitId, pos,aa)
end]]
