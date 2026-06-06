-- 此文件工具自动生成，不要修改
---@class cfg_equip_angelGroup_column
---装备id
---@field id number @id column=1 A
---相同职业为1组
---@field angelEquipSuit number @装备套装组 column=2 B
---不同的组对应不同的升级属性，对应cfg_equip_angelAtt表ornamentsGroup字段
---@field angelEquipGroup number @装备升级组 column=3 C
---阶数#槽位数量|阶数#槽位数量
---@field grailOpen IntListList @圣杯孔位开放阶数 column=4 D
---备注
---[[客户端不使用]]@field text string @备注 column=5 E

local local_grailOpen = {
    grailOpen_1={{1,1},{2,2},{3,3},{4,4},{5,5},{6,6},{7,7},{8,8},{9,9},{10,10},{11,11},{12,12},{13,13},{14,14},{15,15},{16,16},{17,17},{18,18}},

}

local cfg_equip_angelGroup =
{
	{id=20310112, angelEquipSuit=1, angelEquipGroup=1},
	{id=204102112, angelEquipSuit=1},
	{id=207102112, angelEquipSuit=1},
	{id=206102112, angelEquipSuit=1},
	{id=208102112, angelEquipSuit=1},
	{id=209102112, angelEquipSuit=1},
	{id=20120112, angelEquipSuit=2, angelEquipGroup=1},
	{id=20220112, angelEquipSuit=2, angelEquipGroup=1},
	{id=204202112, angelEquipSuit=2},
	{id=207202112, angelEquipSuit=2},
	{id=206202112, angelEquipSuit=2},
	{id=208202112, angelEquipSuit=2},
	{id=209202112, angelEquipSuit=2},
	{id=20130112, angelEquipGroup=1},
	{id=20230112, angelEquipGroup=1},
	{id=204302112},
	{id=207302112},
	{id=206302112},
	{id=208302112},
	{id=209302112},
	{id=1019},
	{id=1124},
	{id=1098},
}

local defaults = {angelEquipSuit=3, angelEquipGroup=2, grailOpen={{1,1},{2,2},{3,3},{4,4},{5,5},{6,6},{7,7},{8,8},{9,9},{10,10},{11,11},{12,12},{13,13},{14,14},{15,15},{16,16},{17,17},{18,18}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_angelGroup) do
	setmetatable(v, mt)
end

return cfg_equip_angelGroup