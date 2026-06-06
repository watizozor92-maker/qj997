-- 此文件工具自动生成，不要修改
---@class cfg_skill_attack_column
---唯一编号
---@field id number @id column=1 A
---名称备注
---@field name string @名称 column=2 B
---引援career职业表
---格式：所属职业#职业等级
---0为全职业
---多职业之间用|分隔
---@field career IntListList @职业 column=3 C
---item表subType字段id#model_charactor表part字段id
---用|分隔表示多个武器类型
---填写多个武器类型表示这几个武器类型均匹配该技能
---@field equip IntListList @装备 column=4 D
---参考skill_info表id
---技能id#技能等级
---@field skill IntList @匹配技能 column=5 E
---匹配到多个技能时，根据优先级生效序号最小的
---@field sort number @排序 column=6 F

local local_career = {
    career_1={{3,0}},

}

local local_equip = {
    equip_1={},

}

local local_skill = {
    skill_1={1004000,1},
    skill_2={1012000,1},

}

local cfg_skill_attack =
{
	{id=1, name="全职业#拳头#不可删除", career={{0,0}}, equip={{0,0}}},
	{id=2, name="剑士系#拳头", career={{1,0}}, skill={1011000,1}},
	{id=3, career={{2,0}}, skill=local_skill.skill_2},
	{id=4, name="职业4#拳头", career={{4,0}}, skill={1014000,1}},
	{id=5, name="职业5#拳头", career={{5,0}}, skill={1015000,1}},
	{id=6, name="职业6#拳头", career={{6,0}}, skill={1016000,1}},
	{id=7, name="弓手系#弓#临时#冰封箭", equip={{1,6}}, skill={1304001,1}},
	{id=8, name="弓手系#弩#临时#五重箭", equip={{1,7}}, skill={1304002,1}},
	{id=9, name="弓手系#拳头"},
	{id=10, career={{7,0}}, skill=local_skill.skill_2},
}

local defaults = {name="法师系#拳头", career={{3,0}}, equip={}, skill={1004000,1}, sort=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_skill_attack) do
	setmetatable(v, mt)
end

return cfg_skill_attack