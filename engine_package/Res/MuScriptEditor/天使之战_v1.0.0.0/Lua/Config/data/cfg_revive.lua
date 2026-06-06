-- 此文件工具自动生成，不要修改
---@class cfg_revive_column
---被关联，不可重复
---@field id number @复活ID column=1 A
---1=副本复活点复活（读地图复活点）
---2=复活点复活
---3=原地复活
---4=自动传送到指定地图坐标（读地图复活点）
---5=自动原地复活（倒计时后原地复活）
---@field type number @复活类型 column=2 B
---直接显示按钮上面
---@field name string @文字描述 column=3 C
---读item表物品ID。
---@field itemId number @货币类型 column=4 D
---每次增加的数量
---格式：次数#数量|次数#数量.....
---@field quantity IntListList @数量 column=5 E
---基础单价
---@field price number @基础单价 column=6 F
---每次增加的价格
---@field addPrice number @每次增加的价格 column=7 G
---最大价格
---@field maxPrice number @最大价格 column=8 H
---等待时间
---@field cd number @等待时间 column=9 I
---增加时间
---@field addCd number @增加时间 column=10 J
---最大时间
---@field maxCd number @最大时间 column=11 K

local local_quantity = {
    quantity_1={{1,1},{2,2},{3,4},{4,6}},
    quantity_2={},

}

local cfg_revive =
{
	{id=1, type=1, name="回城复活", quantity=local_quantity.quantity_2},
	{id=2, type=2, name="立即入口复活", itemId=70800001, price=20, addPrice=30, maxPrice=100},
	{id=3, name="立即原地复活", itemId=70800001, price=20, addPrice=30, maxPrice=100},
	{id=4, type=4, name="自动入口复活", quantity=local_quantity.quantity_2, cd=30, addCd=10, maxCd=60},
	{id=5, type=5, name="自动原地复活", quantity=local_quantity.quantity_2, cd=30, addCd=10, maxCd=60},
	{id=6, type=2, name="免费立即复活", quantity=local_quantity.quantity_2},
	{id=7, name="免费立即复活", quantity=local_quantity.quantity_2},
	{id=8, type=4, name="免费复活", quantity=local_quantity.quantity_2, cd=30, addCd=10, maxCd=60},
	{id=9, name="原地复活", itemId=70800001, price=20, addPrice=30, maxPrice=100},
	{id=10, type=1, name="免费复活", quantity=local_quantity.quantity_2, cd=30, addCd=10, maxCd=60},
	{id=11, type=4, name="入口复活", quantity=local_quantity.quantity_2, cd=30, addCd=10, maxCd=60},
	{id=12, name="立即复活", itemId=70800001, price=30, addPrice=30, maxPrice=100},
}

local defaults = {type=3, itemId=0, quantity={{1,1},{2,2},{3,4},{4,6}}, price=0, addPrice=0, maxPrice=0, cd=0, addCd=0, maxCd=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_revive) do
	setmetatable(v, mt)
end

return cfg_revive