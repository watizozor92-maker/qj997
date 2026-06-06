-- 此文件工具自动生成，不要修改
---@class cfg_card_shop_column
---id
---@field id number @唯一id column=1 A
---[[客户端不使用]]@field name string @策划看 column=2 B
---1：泰坦碎片兑换
---2：专类泰坦碎片兑换
---@field type number @兑换类型 column=3 C
---角色等级购买限制
---不填则无限制
---@field condition number @兑换条件 column=4 D
---格式：道具id#道具数量
---@field exchangeAdd IntList @兑换获得道具 column=5 E
---格式：道具id#道具数量
---@field exchangeConsume IntList @兑换消耗材料 column=6 F
local cfg_card_shop =
{
	{id=100001, type=1, exchangeAdd={40010801,1}, exchangeConsume={50010010,5}},
	{id=100002, type=1, condition=250, exchangeAdd={40010802,1}, exchangeConsume={50010010,30}},
	{id=100003, type=1, condition=350, exchangeAdd={40010803,1}, exchangeConsume={50010010,70}},
	{id=200011, type=2, exchangeAdd={40010812,1}, exchangeConsume={50010010,4}},
	{id=200031, type=2, exchangeAdd={40010813,1}, exchangeConsume={50010010,6}},
	{id=200021, type=2, exchangeAdd={40010811,1}, exchangeConsume={50010010,10}},
}

local defaults = {condition=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_card_shop) do
	setmetatable(v, mt)
end

return cfg_card_shop