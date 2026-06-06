-- 此文件工具自动生成，不要修改
---@class cfg_Portableshop_column
---序号
---@field id number @唯一id column=1 A
---买药组id
---@field group number @组id column=2 B
---格式：道具id
---@field itemId number @道具id column=3 C
---@field itemName string @道具名称 column=4 D
---格式：需求道具类型#数量
---@field price IntListList @上架价格 column=5 E
---购买等级要求，同组优先购买高等级药水
---为空：没有等级要求
---@field level number @等级要求 column=6 F
---低于一定数量则自动买药
---格式：同组药水剩余数量#每次自动买药的购买数量
---@field autobuy IntListList @自动买药参数 column=7 G

local local_price = {
    price_1={{10010002,50}},
    price_2={{10010002,100}},
    price_3={{10010002,200}},
    price_4={{10010002,1000}},

}

local local_autobuy = {
    autobuy_1={{5,20}},

}

local cfg_Portableshop =
{
	{id=1, itemId=30010001, itemName="苹果", price={{10010002,2}}, level=9999, autobuy={{10,99}}},
	{id=2, itemId=30010002, itemName="小瓶治疗药水"},
	{id=3, itemId=30010003, itemName="中瓶治疗药水", price=local_price.price_2, level=50},
	{id=4, itemId=30010004, itemName="大瓶治疗药水", price=local_price.price_3, level=100},
	{id=5, itemId=30010005, itemName="超大治疗药水", price={{10010002,400}}, level=200},
	{id=6, itemId=30010006, itemName="小型精华治疗药水", price={{10010002,500}}},
	{id=7, itemId=30010007, itemName="中型精华治疗药水", price=local_price.price_4, level=50},
	{id=8, itemId=30010008, itemName="大型精华治疗药水", price={{10010002,2000}}, level=100},
	{id=9, itemId=30010009, itemName="超大精华治疗药水", price={{10010002,4000}}, level=200},
	{id=10, group=2, itemId=30010012, itemName="小瓶魔力药水"},
	{id=11, group=2, itemId=30010013, itemName="中瓶魔力药水", price=local_price.price_2, level=50},
	{id=12, group=2, itemId=30010014, itemName="大瓶魔力药水", price=local_price.price_3, level=100},
	{id=13, group=2, itemId=30010015, itemName="精华魔力药水", price=local_price.price_4},
}

local defaults = {group=1, price={{10010002,50}}, level=1, autobuy={{5,20}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Portableshop) do
	setmetatable(v, mt)
end

return cfg_Portableshop