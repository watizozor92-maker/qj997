-- 此文件工具自动生成，不要修改
---@class cfg_careerchange_column
---排序
---@field id number @id column=1 A
---职业的名称
---@field name string @职业名称 column=2 B
---对标equipchange表字段name+转换名
---@field EquipName string @装备转换名 column=3 C
---对标career表baseCareer字段
---@field CareerID number @根职业ID column=4 D
---在转职时装备的变化，索引equip_entryLib表careerequip字段
---@field Equip number @装备组 column=5 E
---对标career表
---@field careerRec number @加点权重 column=6 F
local cfg_careerchange =
{
	{id=1, name="剑士", EquipName="A", CareerID=1, Equip=101},
	{id=2, name="魔法师", EquipName="B", CareerID=2, Equip=201},
	{id=3, name="弓箭手（敏弓）", EquipName="C", CareerID=3, Equip=301},
	{id=4, name="弓箭手（智弓）", EquipName="D", CareerID=3, Equip=302, careerRec=2},
	{id=5, name="魔剑士（力魔）", EquipName="E", CareerID=4, Equip=401, careerRec=2},
	{id=6, name="魔剑士（法魔）", EquipName="F", CareerID=4, Equip=402},
	{id=7, name="圣导师", EquipName="G", CareerID=5, Equip=501},
	{id=8, name="召唤师", EquipName="H", CareerID=6, Equip=601},
}

local defaults = {careerRec=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_careerchange) do
	setmetatable(v, mt)
end

return cfg_careerchange