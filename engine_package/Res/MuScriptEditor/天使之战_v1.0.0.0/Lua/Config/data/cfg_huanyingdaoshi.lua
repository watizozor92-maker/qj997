-- 此文件工具自动生成，不要修改
---@class cfg_huanyingdaoshi_column
---@field id number @唯一id column=1 A
---1、免费领buff
---2、消耗道具获得道具
---3、免费领buff(白银特权特供)
---@field type number @类型 column=2 B
---@field level IntList @等级 column=3 C
---先判断等级，等级都满足时判断condition，去决定给哪个id的导师buff
---@field condition string @领取条件 column=4 D
---buffid
---@field buff IntList @buff column=5 E
---消耗道具#数量|获得道具#数量
---@field item IntListList @道具 column=6 F
---@field text string @注意文本 column=7 G

local local_level = {
    level_1={1,99},

}

local local_item = {
    item_1={},

}

local cfg_huanyingdaoshi =
{
	{id=1, type=1, condition="", buff={10300002}, item=local_item.item_1},
	{id=2, type=2, level={100,999}, condition="", buff={}, text="一键加生命之光、守护之魂、战神之力、守护之光，效果随角色等级变，最大30%生命百分比、30%伤害吸收、120攻击力，120防御力，持续24H，死亡不消失。"},
	{id=3, type=3, condition="2103#24", buff={10300003}, item=local_item.item_1},
}

local defaults = {level={1,99}, item={{10250001,800},{100000004,1}}, text="物理攻击力+30，魔法攻击力+80，防御力+30，\n生命值+100，魔法值+40\n持续8小时，死亡消失<color=#4C961D>(畅玩卡死亡不消失)</color>"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_huanyingdaoshi) do
	setmetatable(v, mt)
end

return cfg_huanyingdaoshi