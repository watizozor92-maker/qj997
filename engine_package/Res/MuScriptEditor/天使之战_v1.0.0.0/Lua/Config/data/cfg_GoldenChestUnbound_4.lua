-- 此文件工具自动生成，不要修改
---@class cfg_GoldenChestUnbound_4_column
---唯一id
---[[客户端不使用]]@field id number @id column=1 A
---1=统计概率，从所有道具中抽取1个（按权重）
---2=独立概率，每个道具单独判断概率
---*每张表只允许使用1个类型
---[[客户端不使用]]@field type number @掉落类型 column=2 B
---策划备注
---[[客户端不使用]]@field beizhu string @ column=3 C
---道具id
---@field item number @道具id column=4 D
---数量区间，从中随机数量
---x#y，左右闭区间
---@field num string @数量 column=5 E
---掉落类型为1时，此处为：掉落次数#权重
---掉落类型为2时，此处为：掉落次数#概率（万分比）
---掉落次数填本次掉落之前已经掉落的次数，例如首次掉落，之前没掉过，这里就填0
---[[客户端不使用]]@field probability string @概率 column=6 F
---限制职业
---只有对应职业才会掉落
---不填不做限制
---格式：所属职业#职业等级|所属职业#职业等级
---[[客户端不使用]]@field career string @职业 column=7 G
---限制等级
---只有角色在对应等级区间内才会掉
---x#y，左右闭区间
---999999标识无限大
---不填不做限制
---[[客户端不使用]]@field level string @等级 column=8 H
---宝箱开启时概率携带的技能id#等级#携带概率（万分比）
---@field skillbaoxiang IntList @装备携带【技能】概率 column=9 I
---宝箱开启时概率携带的权重#等级
---@field strengthenbaoxiang IntListList @装携带【强化】概率 column=10 J
---宝箱开启时概率携带的幸运的概率（万分比）
---@field luckbaoxiang number @装备携带【幸运】概率 column=11 K
---宝箱开启时概率携带的追加的权重#等级
---@field appendsbaoxiang IntListList @装备携带【追加】概率 column=12 L

local local_skillbaoxiang = {
    skillbaoxiang_1={},
    skillbaoxiang_2={1100003,1,10000},
    skillbaoxiang_3={1300002,1,10000},
    skillbaoxiang_4={1005003,1,10000},

}

local local_strengthenbaoxiang = {
    strengthenbaoxiang_1={},

}

local local_appendsbaoxiang = {
    appendsbaoxiang_1={},
    appendsbaoxiang_2={{9000,0},{900,1},{99,2},{1,3}},

}

local cfg_GoldenChestUnbound_4 =
{
	{item=1253000299, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000399, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000199, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000499, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000599, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000299, num="2#2", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000399, num="2#2", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000199, num="2#2", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000499, num="2#2", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000599, num="2#2", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2041042199},
	{item=2061042199},
	{item=2071042199},
	{item=2081042199},
	{item=2091042199},
	{item=2042042199},
	{item=2062042199},
	{item=2072042199},
	{item=2082042199},
	{item=2092042199},
	{item=2043042199},
	{item=2063042199},
	{item=2073042199},
	{item=2083042199},
	{item=2093042199},
	{item=1280034199},
	{item=1280034299},
	{item=1280034399},
	{item=1280034499},
	{item=2031032199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2},
	{item=201599, skillbaoxiang={1100005,1,10000}},
	{item=204899, skillbaoxiang={1100002,1,10000}},
	{item=207499, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2},
	{item=2013042199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3},
	{item=209199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3},
	{item=2012042199},
	{item=215799, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4},
	{item=215899, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4},
}

local defaults = {num="1#1", skillbaoxiang={}, strengthenbaoxiang={}, luckbaoxiang=500, appendsbaoxiang={{9000,0},{900,1},{99,2},{1,3}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_GoldenChestUnbound_4) do
	setmetatable(v, mt)
end

return cfg_GoldenChestUnbound_4