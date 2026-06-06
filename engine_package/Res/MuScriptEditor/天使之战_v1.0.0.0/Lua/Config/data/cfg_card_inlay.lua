-- 此文件工具自动生成，不要修改
---@class cfg_card_inlay_column
---@field id number @唯一id column=1 A
---策划备注字段
---[[客户端不使用]]@field remark string @备注 column=2 B
---允许镶嵌卡牌的装备部位
---读取item/strPart
---@field part number @装备部位 column=3 C
---装备部位对应镶嵌卡牌类型
---读取item/subType
---@field type number @镶嵌卡牌类型 column=4 D
---部位对应镶嵌孔位数量
---@field holeAmount number @镶嵌孔位数量 column=5 E
---1.装备阶数类型
---2.首饰等级类型
---@field unlockType number @解锁孔位限制类型 column=6 F
---大于等于配置值解锁槽位
---不填则没有该限制
---孔位序号不能超出孔位总数
---unlockType=1，格式：孔位序号#装备阶数|孔位序号#装备阶数
---unlockType=2，格式：孔位序号#首饰等级|孔位序号#首饰等级
---@field unlockParameter IntListList @限制参数 column=7 G
---部位对应免费镶嵌孔位序号
---格式：孔位序号#孔位序号
---孔位序号不能超出孔位总数
---@field unlockFree IntList @免费解锁孔位数量 column=8 H
---格式：孔位序号#消耗道具id#道具数量#解锁概率（万比）|孔位序号#消耗道具id#道具数量#解锁概率（万比）
---孔位序号需要从免费孔位顺延，不能超出孔位总数
---@field unlockNormal IntListList @解锁孔位常规消耗道具 column=9 I
---格式：孔位序号#消耗道具#道具数量|孔位序号#消耗道具id#道具数量
---孔位序号需要从免费孔位顺延，不能超出孔位总数
---@field unlockSpecial IntListList @解锁孔位特殊消耗道具 column=10 J
---解锁失败增加幸运值，满一百后百分百成功
---格式：孔位序号#增加值|孔位序号#增加值
---孔位序号需要从免费孔位顺延，不能超出孔位总数
---@field luckPoint IntListList @失败幸运值 column=11 K

local local_unlockParameter = {
    unlockParameter_1={{1,1},{2,7},{3,9}},
    unlockParameter_2={{1,1},{2,20},{3,35}},

}

local local_unlockFree = {
    unlockFree_1={1,2,3},

}

local local_unlockNormal = {
    unlockNormal_1={},

}

local local_unlockSpecial = {
    unlockSpecial_1={},

}

local local_luckPoint = {
    luckPoint_1={},

}

local cfg_card_inlay =
{
	{id=1, part=1, type=3},
	{id=2, part=2, type=3},
	{id=3, part=3, type=3},
	{id=4, part=4},
	{id=5, part=5, type=1},
	{id=6, part=6},
	{id=7, part=7},
	{id=8, part=8},
	{id=9, part=9, unlockType=2, unlockParameter=local_unlockParameter.unlockParameter_2},
	{id=10, part=10, unlockType=2, unlockParameter=local_unlockParameter.unlockParameter_2},
	{id=11, part=11, unlockType=2, unlockParameter=local_unlockParameter.unlockParameter_2},
	{id=12, part=12, unlockType=2, unlockParameter=local_unlockParameter.unlockParameter_2},
	{id=13, part=13, unlockType=2, unlockParameter=local_unlockParameter.unlockParameter_2},
}

local defaults = {type=2, holeAmount=3, unlockType=1, unlockParameter={{1,1},{2,7},{3,9}}, unlockFree={1,2,3}, unlockNormal={}, unlockSpecial={}, luckPoint={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_card_inlay) do
	setmetatable(v, mt)
end

return cfg_card_inlay