-- 此文件工具自动生成，不要修改
---@class cfg_huangjinbaoxiang_column
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
    skillbaoxiang_2={1300002,1,10000},

}

local local_strengthenbaoxiang = {
    strengthenbaoxiang_1={},

}

local local_appendsbaoxiang = {
    appendsbaoxiang_1={},
    appendsbaoxiang_2={{9000,1},{900,2},{99,3},{1,4}},

}

local cfg_huangjinbaoxiang =
{
	{item=10040001, num="20#100", skillbaoxiang=local_skillbaoxiang.skillbaoxiang_1, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=10010001, num="20#100", skillbaoxiang=local_skillbaoxiang.skillbaoxiang_1, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=10020001, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_1, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20120211, skillbaoxiang={1300002,1,1000}, luckbaoxiang=1000, appendsbaoxiang={{9000,0},{900,1},{99,2},{1,3}}},
	{item=20120221, strengthenbaoxiang={{8000,1},{1300,2},{450,3},{190,4},{50,5},{9,6},{1,7}}, luckbaoxiang=5000},
	{item=20120431, strengthenbaoxiang={{8000,2},{1300,3},{450,4},{190,5},{50,6},{9,7},{1,8}}, luckbaoxiang=10000},
	{item=30010013, num="1#2", skillbaoxiang=local_skillbaoxiang.skillbaoxiang_1, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
}

local defaults = {num="1#1", skillbaoxiang={1300002,1,10000}, strengthenbaoxiang={{8000,0},{1300,1},{450,2},{190,3},{50,4},{9,5},{1,6}}, luckbaoxiang=0, appendsbaoxiang={{9000,1},{900,2},{99,3},{1,4}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_huangjinbaoxiang) do
	setmetatable(v, mt)
end

return cfg_huangjinbaoxiang