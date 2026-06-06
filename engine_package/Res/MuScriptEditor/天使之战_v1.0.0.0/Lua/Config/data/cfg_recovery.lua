-- 此文件工具自动生成，不要修改
---@class cfg_recovery_column
---唯一序号
---@field id number @id column=1 A
---1：回收
---2：分解
---3：卡牌回收
---@field group number @执行分类 column=2 B
---1：道具
---2：技能
---空：则没有类型，不显示
---@field recoverType number @执行类型 column=3 C
---回收和分解的装备组
---@field groupName1 string @分组名 column=4 D
---1 回收金币
---2 回收积分
---@field type number @类型分组 column=5 E
---执行分解时读取
---品阶1消耗|品阶2消耗|品阶3消耗
---
---道具id#数量&道具id#数量|道具id&数量#道具id&数量
---
---0为不能执行分解
---@field needMaterial IntListList @消耗材料 column=6 F
---品阶1获得
---1(非绑)#道具id#数量下限#数量上限|2(绑定)#道具id#数量下限#数量上限
---
---回收获得的道具数量无随机功能，需要将数据下限和数据上限填写一致
---
---0为不可执行回收/分解
---@field material IntListList @获得材料 column=7 G
---1默认勾选
---0或空默认不勾选
---@field default number @是否默认勾选开启 column=8 H

local local_needMaterial = {
    needMaterial_1={},

}

local local_material = {
    material_1={{1,10240001,1,1},{2,10240001,1,1}},

}

local cfg_recovery =
{
	{id=101, groupName1="白装", type=1, material={{1,10010001,2,2},{2,10010002,2,2}}, default=1},
	{id=102, groupName1="宝石"},
	{id=104, groupName1="技能", type=1, material={{1,10010001,1,1},{2,10010002,1,1}}},
	{id=103, groupName1="卓越"},
	{id=199, groupName1="套装"},
	{id=198, groupName1="卓越套装"},
}

local defaults = {group=1, recoverType=1, type=2, needMaterial={}, material={{1,10240001,1,1},{2,10240001,1,1}}, default=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_recovery) do
	setmetatable(v, mt)
end

return cfg_recovery