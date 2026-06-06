-- 此文件工具自动生成，不要修改
---@class cfg_passive_condition_column
---唯一id，被引用于skill_info/passivityTrigger
---技能id+触发类型id
---@field id number @id column=1 A
---策划备注
---[[客户端不使用]]@field remark string @策划备注 column=2 B
---1.攻击目标血量
---2.受到控制
---3.卡牌变身持续触发
---4.卡牌变身触发（变身瞬间触发一次）
---@field type number @触发条件类型 column=3 C
---type=1，参数为目标生命值万分比（目标大于等于该值时生效）
---type=3，参数为变身卡牌组（填0表示所有变身）
---type=4，参数为变身卡牌组（填0表示所有变身）
---未备注的类型不存在参数
---@field parameter1 IntList @条件参数1 column=4 D
---type=3，参数为触发间隔时间（单位：毫秒）
---未备注的类型不存在参数
---@field parameter2 IntList @条件参数2 column=5 E

local local_parameter1 = {
    parameter1_1={6},

}

local local_parameter2 = {
    parameter2_1={},
    parameter2_2={1000},

}

local cfg_passive_condition =
{
	{id=101, type=1, parameter1={10000}},
	{id=102, type=1, parameter1={0}},
	{id=201, type=2, parameter1={}},
	{id=301, type=3, parameter1={1}, parameter2=local_parameter2.parameter2_2},
	{id=302, type=3, parameter1=local_parameter1.parameter1_1, parameter2=local_parameter2.parameter2_2},
	{id=401, parameter1={2}},
	{id=402, parameter1={3}},
	{id=403, parameter1={4}},
	{id=404, parameter1=local_parameter1.parameter1_1},
}

local defaults = {type=4, parameter2={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_passive_condition) do
	setmetatable(v, mt)
end

return cfg_passive_condition