-- 此文件工具自动生成，不要修改
---@class cfg_SourceEnumeration_column
---@field id number @id column=1 A
---物品来源
---@field Source string @物品来源 column=2 B
---1-内置
---2-外置
---@field type number @内外置 column=3 C
---填写重写后的内容
---@field Rewrite string @重写内容 column=4 D
local cfg_SourceEnumeration =
{
	{id=1, Source="好友", Rewrite="好友获取"},
	{id=2, Source="果实", Rewrite="果实"},
	{id=3, Source="黄金任务", Rewrite="黄金任务"},
	{id=4, Source="物品合成", Rewrite="合成"},
	{id=5, Source="等级奖励", Rewrite="等级奖励"},
	{id=6, Source="离线挂机", Rewrite="挂机"},
	{id=7, Source="血色城堡", Rewrite="血色城堡"},
	{id=8, Source="恶魔广场", Rewrite="恶魔广场"},
	{id=9, Source="秘境boss", Rewrite="秘境BOSS"},
	{id=10, Source="战盟BOSS", Rewrite="战盟BOSS"},
	{id=11, Source="荧石", Rewrite="荧石"},
	{id=12, Source="每日抽奖", Rewrite="每日抽奖"},
	{id=13, Source="装备首曝", Rewrite="首爆"},
	{id=14, Source="宝箱商人", Rewrite="宝箱商人"},
	{id=15, Source="gm"},
	{id=16, Source="充值奖励", Rewrite="充值"},
	{id=17, Source="首充礼包", Rewrite="首充"},
	{id=18, Source="道具-拾取", type=1, Rewrite="拾取"},
	{id=19, Source="装备-穿装-入包", type=1, Rewrite="穿戴"},
	{id=20, Source="个人商店-商店到背包", type=1, Rewrite="商店"},
	{id=21, Source="邮件-附件交易", type=1, Rewrite="邮件"},
	{id=22, Source="装备-爆装备", type=1, Rewrite="掉落"},
	{id=23, Source="道具合成", type=1, Rewrite="合成"},
	{id=25, Source="任务-获取道具", type=1, Rewrite="任务获取"},
	{id=26, Source="职业转换", type=1, Rewrite="职业转换"},
	{id=27, Source="兑换码兑换", type=1, Rewrite="兑换码"},
	{id=28, Source="创角道具", type=1, Rewrite="创角"},
	{id=29, Source="创角装备", type=1, Rewrite="创角"},
	{id=30, Source="系统发放", type=1},
	{id=31, Source="职业转换装备更换", type=1},
	{id=32, Source="GM-操作", type=1},
	{id=33, Source="NPC积分兑换", type=1, Rewrite="NPC积分兑换"},
	{id=34, Source="自动买药", Rewrite="自动买药"},
	{id=35, Source="面对面交易", Rewrite="面对面交易"},
	{id=36, Source="随机宝箱", Rewrite="随机宝箱"},
	{id=37, Source="普通商店-购买物品", type=1, Rewrite="商城"},
	{id=38, Source="战盟任务", Rewrite="战盟任务奖励"},
}

local defaults = {type=2, Rewrite="系统制造"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_SourceEnumeration) do
	setmetatable(v, mt)
end

return cfg_SourceEnumeration