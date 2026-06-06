-- 此文件工具自动生成，不要修改
---@class cfg_npcChest_column
---唯一id；
---第一位：商店编号（shopId字段）
---第二三位：编号
---@field id number @序号 column=1 A
---格式：道具id（cfg_item/id）#数量
---@field itemId IntList @商店道具 column=2 B
---商店编号
---,用于确定NPC调用那个商店
---@field shopId number @商店编号 column=3 C
---NPC商店显示道具名称
---@field itemName string @道具名称 column=4 D
---等级上限#等级下限
---[[客户端不使用]]@field conditions string @上架条件 column=5 E
---格式：需求道具类型#数量#是否关联#权重|需求道具类型#单价所需数量#是否关联#权重|需求道具类型#数量#是否关联#权重
---
---
---是否关联：0=不关联，1=关联
---为空时：此道具不可购买，商店内不上架此道具
---例：钻石#价格#是否关联
---权重：每次上架时根据权重随机出一个货币种类售卖
---3#2000#1
---[[客户端不使用]]@field price IntListList @上架价格 column=6 F
local cfg_npcChest =
{
	{id=100, itemId={40030004,1}, itemName="初萌木盒宝匣"},
	{id=101, itemId={40030005,1}, itemName="翠玉灵韵宝箱"},
	{id=102, itemId={40030006,1}, itemName="琉璃幻彩秘箱"},
	{id=103, itemId={40030007,1}, itemName="紫金御赐宝箱"},
	{id=104, itemId={40030008,1}, itemName="星耀璀璨圣箱"},
	{id=105, itemId={40030009,1}, itemName="灵虚幽梦仙箱"},
	{id=106, itemId={40030010,1}, itemName="梵天琉璃神箱"},
	{id=107, itemId={40030011,1}, itemName="创世永恒禁箱"},
	{id=108, itemId={40030012,1}, itemName="混沌鸿蒙至尊箱"},
	{id=109, itemId={40030016,1}, itemName="4阶限定职业装备宝箱"},
	{id=110, itemId={40030017,1}, itemName="5阶限定职业装备宝箱"},
	{id=111, itemId={40030018,1}, itemName="6阶限定职业装备宝箱"},
	{id=112, itemId={40030019,1}, itemName="7阶限定职业装备宝箱"},
	{id=113, itemId={40030020,1}, itemName="8阶限定职业装备宝箱"},
	{id=114, itemId={40030021,1}, itemName="9阶限定职业装备宝箱"},
	{id=115, itemId={40030022,1}, itemName="10阶限定职业装备宝箱"},
	{id=116, itemId={40030023,1}, itemName="11阶限定职业装备宝箱"},
	{id=117, itemId={40030024,1}, itemName="12阶限定职业装备宝箱"},
	{id=118, itemId={40030025,1}, itemName="13阶限定职业装备宝箱"},
	{id=119, itemId={40030026,1}, itemName="14阶限定职业装备宝箱"},
	{id=120, itemId={40030027,1}, itemName="15阶限定职业装备宝箱"},
	{id=121, itemId={40030028,1}, itemName="16阶限定职业装备宝箱"},
	{id=122, itemId={40030029,1}, itemName="17阶限定职业装备宝箱"},
	{id=123, itemId={40030030,1}, itemName="18阶限定职业装备宝箱"},
	{id=124, itemId={40030031,1}, itemName="19阶限定职业装备宝箱"},
	{id=125, itemId={40030032,1}, itemName="20阶限定职业装备宝箱"},
}

local defaults = {shopId=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_npcChest) do
	setmetatable(v, mt)
end

return cfg_npcChest