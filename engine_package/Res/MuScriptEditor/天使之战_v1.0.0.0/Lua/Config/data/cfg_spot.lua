-- 此文件工具自动生成，不要修改
---@class cfg_spot_column
---@field id number @编号 column=1 A
---1普通摆摊
---2特权摆摊
---@field type number @类型 column=2 B
---关联map_info表
---@field map number @地图ID column=3 C
---该地图的摊位总数
---@field maxSpot number @摊位总数 column=4 D
---x最大#y最大#x最小#y最小
---@field position IntListList @摊位位置 column=5 E
---等级不够时隐藏该选项
---@field level number @等级限制 column=6 F
---1.开始时间不到隐藏，填空不限制
---2.填开服天数
---@field serverday number @开服时间限制 column=7 G
---1类型：摆摊时间#道具id#数量
---时间单位：小时
---2类型：摆摊时间#所需次数
---@field cost IntListList @消耗 column=8 H
---关联cfg_model_default表ID
---格式：
---职业ID#cfg_model_default表ID|职业#cfg_model_default表ID|职业#cfg_model_default表ID
---@field model IntListList @摊位模型 column=9 I
---摊位的橙色字显示
---@field name string @摊位等级 column=10 J

local local_cost = {
    cost_1={{4,10010002,5000},{8,10010002,10000},{12,10010002,15000}},

}

local local_model = {
    model_1={{1,1},{2,2},{3,3}},

}

local cfg_spot =
{
	{id=1, type=1, map=1001, maxSpot=40, level=1, serverday=0, name="摊位"},
	{id=2, type=1, map=1004, maxSpot=40, position={{196,136,156,116}}, level=1, serverday=0, name="摊位"},
}

local defaults = {position={{160,144,120,104}}, cost={{4,10010002,5000},{8,10010002,10000},{12,10010002,15000}}, model={{1,1},{2,2},{3,3}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_spot) do
	setmetatable(v, mt)
end

return cfg_spot