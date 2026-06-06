-- 此文件工具自动生成，不要修改
---@class cfg_equip_regenerationGroup_column
---词库
---组id*10000+属性序列序列*100+等级
---@field id number @词库 column=1 A
---同一id为同一组
---@field group number @组id column=2 B
---策划使用
---@field note string @备注 column=3 C
---属性序列
---@field sequence number @属性序列 column=4 D
---强化等级
---@field level number @强化等级 column=5 E
---中文
---@field attName string @强化属性 column=6 F
---属性#数值|属性#数值 万分比
---对应cfg_att_info表的id字段
---@field att string @强化属性 column=7 G
---属性权重
---同一组中，出现该属性的权重
---@field weight number @权重 column=8 H
local cfg_equip_regenerationGroup =
{
	{id=10101, att="200011#8"},
	{id=10102, level=2, att="200011#18"},
	{id=10103, level=3, att="200011#28"},
	{id=10104, level=4, att="200011#38"},
	{id=10105, level=5, att="200011#48"},
	{id=10106, level=6, att="200011#58"},
	{id=10201, sequence=2, attName="最大攻击力提高", att="200021#8"},
	{id=10202, sequence=2, level=2, attName="最大攻击力提高", att="200021#18"},
	{id=10203, sequence=2, level=3, attName="最大攻击力提高", att="200021#28"},
	{id=10204, sequence=2, level=4, attName="最大攻击力提高", att="200021#38"},
	{id=10205, sequence=2, level=5, attName="最大攻击力提高", att="200021#48"},
	{id=10206, sequence=2, level=6, attName="最大攻击力提高", att="200021#58"},
	{id=10301, sequence=3, attName="攻击力上升", att="314023#8"},
	{id=10302, sequence=3, level=2, attName="攻击力上升", att="314023#18"},
	{id=10303, sequence=3, level=3, attName="攻击力上升", att="314023#28"},
	{id=10304, sequence=3, level=4, attName="攻击力上升", att="314023#38"},
	{id=10305, sequence=3, level=5, attName="攻击力上升", att="314023#48"},
	{id=10306, sequence=3, level=6, attName="攻击力上升", att="314023#58"},
	{id=10401, sequence=4, attName="加重攻击力", att="314022#8"},
	{id=10402, sequence=4, level=2, attName="加重攻击力", att="314022#18"},
	{id=10403, sequence=4, level=3, attName="加重攻击力", att="314022#28"},
	{id=10404, sequence=4, level=4, attName="加重攻击力", att="314022#38"},
	{id=10405, sequence=4, level=5, attName="加重攻击力", att="314022#48"},
	{id=10406, sequence=4, level=6, attName="加重攻击力", att="314022#58"},
	{id=10501, sequence=5, attName="技能攻击力", att="320011#8"},
	{id=10502, sequence=5, level=2, attName="技能攻击力", att="320011#18"},
	{id=10503, sequence=5, level=3, attName="技能攻击力", att="320011#28"},
	{id=10504, sequence=5, level=4, attName="技能攻击力", att="320011#38"},
	{id=10505, sequence=5, level=5, attName="技能攻击力", att="320011#48"},
	{id=10506, sequence=5, level=6, attName="技能攻击力", att="320011#58"},
	{id=10601, sequence=6, attName="所需力量减少", att="301065#8"},
	{id=10602, sequence=6, level=2, attName="所需力量减少", att="301065#18"},
	{id=10603, sequence=6, level=3, attName="所需力量减少", att="301065#28"},
	{id=10604, sequence=6, level=4, attName="所需力量减少", att="301065#38"},
	{id=10605, sequence=6, level=5, attName="所需力量减少", att="301065#48"},
	{id=10606, sequence=6, level=6, attName="所需力量减少", att="301065#58"},
	{id=10701, sequence=7, attName="所需敏捷减少", att="301066#8"},
	{id=10702, sequence=7, level=2, attName="所需敏捷减少", att="301066#18"},
	{id=10703, sequence=7, level=3, attName="所需敏捷减少", att="301066#28"},
	{id=10704, sequence=7, level=4, attName="所需敏捷减少", att="301066#38"},
	{id=10705, sequence=7, level=5, attName="所需敏捷减少", att="301066#48"},
	{id=10706, sequence=7, level=6, attName="所需敏捷减少", att="301066#58"},
	{id=10801, sequence=8, attName="PVP攻击率", att="210031#8"},
	{id=10802, sequence=8, level=2, attName="PVP攻击率", att="210031#18"},
	{id=10803, sequence=8, level=3, attName="PVP攻击率", att="210031#28"},
	{id=10804, sequence=8, level=4, attName="PVP攻击率", att="210031#38"},
	{id=10805, sequence=8, level=5, attName="PVP攻击率", att="210031#48"},
	{id=10806, sequence=8, level=6, attName="PVP攻击率", att="210031#58"},
	{id=10901, sequence=9, attName="SD消耗减少率", att="301064#8"},
	{id=10902, sequence=9, level=2, attName="SD消耗减少率", att="301064#18"},
	{id=10903, sequence=9, level=3, attName="SD消耗减少率", att="301064#28"},
	{id=10904, sequence=9, level=4, attName="SD消耗减少率", att="301064#38"},
	{id=10905, sequence=9, level=5, attName="SD消耗减少率", att="301064#48"},
	{id=10906, sequence=9, level=6, attName="SD消耗减少率", att="301064#58"},
	{id=11001, sequence=10, attName="无视SD概率", att="301052#8"},
	{id=11002, sequence=10, level=2, attName="无视SD概率", att="301052#18"},
	{id=11003, sequence=10, level=3, attName="无视SD概率", att="301052#28"},
	{id=11004, sequence=10, level=4, attName="无视SD概率", att="301052#38"},
	{id=11005, sequence=10, level=5, attName="无视SD概率", att="301052#48"},
	{id=11006, sequence=10, level=6, attName="无视SD概率", att="301052#58"},
	{id=20101, group=2, note="防具", attName="防御力", att="206011#8"},
	{id=20102, group=2, note="防具", level=2, attName="防御力", att="206011#18"},
	{id=20103, group=2, note="防具", level=3, attName="防御力", att="206011#28"},
	{id=20104, group=2, note="防具", level=4, attName="防御力", att="206011#38"},
	{id=20105, group=2, note="防具", level=5, attName="防御力", att="206011#48"},
	{id=20106, group=2, note="防具", level=6, attName="防御力", att="206011#58"},
	{id=20201, group=2, note="防具", sequence=2, attName="生命值(HP)上限", att="207011#8"},
	{id=20202, group=2, note="防具", sequence=2, level=2, attName="生命值(HP)上限", att="207011#18"},
	{id=20203, group=2, note="防具", sequence=2, level=3, attName="生命值(HP)上限", att="207011#28"},
	{id=20204, group=2, note="防具", sequence=2, level=4, attName="生命值(HP)上限", att="207011#38"},
	{id=20205, group=2, note="防具", sequence=2, level=5, attName="生命值(HP)上限", att="207011#48"},
	{id=20206, group=2, note="防具", sequence=2, level=6, attName="生命值(HP)上限", att="207011#58"},
	{id=20301, group=2, note="防具", sequence=3, attName="AG值", att="302011#8"},
	{id=20302, group=2, note="防具", sequence=3, level=2, attName="AG值", att="302011#18"},
	{id=20303, group=2, note="防具", sequence=3, level=3, attName="AG值", att="302011#28"},
	{id=20304, group=2, note="防具", sequence=3, level=4, attName="AG值", att="302011#38"},
	{id=20305, group=2, note="防具", sequence=3, level=5, attName="AG值", att="302011#48"},
	{id=20306, group=2, note="防具", sequence=3, level=6, attName="AG值", att="302011#58"},
	{id=20401, group=2, note="防具", sequence=4, attName="每3秒固定回复生命", att="207063#8"},
	{id=20402, group=2, note="防具", sequence=4, level=2, attName="每3秒固定回复生命", att="207063#18"},
	{id=20403, group=2, note="防具", sequence=4, level=3, attName="每3秒固定回复生命", att="207063#28"},
	{id=20404, group=2, note="防具", sequence=4, level=4, attName="每3秒固定回复生命", att="207063#38"},
	{id=20405, group=2, note="防具", sequence=4, level=5, attName="每3秒固定回复生命", att="207063#48"},
	{id=20406, group=2, note="防具", sequence=4, level=6, attName="每3秒固定回复生命", att="207063#58"},
	{id=20501, group=2, note="防具", sequence=5, attName="每3秒固定回复魔力", att="208052#8"},
	{id=20502, group=2, note="防具", sequence=5, level=2, attName="每3秒固定回复魔力", att="208052#18"},
	{id=20503, group=2, note="防具", sequence=5, level=3, attName="每3秒固定回复魔力", att="208052#28"},
	{id=20504, group=2, note="防具", sequence=5, level=4, attName="每3秒固定回复魔力", att="208052#38"},
	{id=20505, group=2, note="防具", sequence=5, level=5, attName="每3秒固定回复魔力", att="208052#48"},
	{id=20506, group=2, note="防具", sequence=5, level=6, attName="每3秒固定回复魔力", att="208052#58"},
	{id=20601, group=2, note="防具", sequence=6, attName="PVP防御率", att="212031#8"},
	{id=20602, group=2, note="防具", sequence=6, level=2, attName="PVP防御率", att="212031#18"},
	{id=20603, group=2, note="防具", sequence=6, level=3, attName="PVP防御率", att="212031#28"},
	{id=20604, group=2, note="防具", sequence=6, level=4, attName="PVP防御率", att="212031#38"},
	{id=20605, group=2, note="防具", sequence=6, level=5, attName="PVP防御率", att="212031#48"},
	{id=20606, group=2, note="防具", sequence=6, level=6, attName="PVP防御率", att="212031#58"},
	{id=20701, group=2, note="防具", sequence=7, attName="伤害减少", att="314015#8"},
	{id=20702, group=2, note="防具", sequence=7, level=2, attName="伤害减少", att="314015#18"},
	{id=20703, group=2, note="防具", sequence=7, level=3, attName="伤害减少", att="314015#28"},
	{id=20704, group=2, note="防具", sequence=7, level=4, attName="伤害减少", att="314015#38"},
	{id=20705, group=2, note="防具", sequence=7, level=5, attName="伤害减少", att="314015#48"},
	{id=20706, group=2, note="防具", sequence=7, level=6, attName="伤害减少", att="314015#58"},
	{id=20801, group=2, note="防具", sequence=8, attName="SD比率提高", att="314020#8"},
	{id=20802, group=2, note="防具", sequence=8, level=2, attName="SD比率提高", att="314020#18"},
	{id=20803, group=2, note="防具", sequence=8, level=3, attName="SD比率提高", att="314020#28"},
	{id=20804, group=2, note="防具", sequence=8, level=4, attName="SD比率提高", att="314020#38"},
	{id=20805, group=2, note="防具", sequence=8, level=5, attName="SD比率提高", att="314020#48"},
	{id=20806, group=2, note="防具", sequence=8, level=6, attName="SD比率提高", att="314020#58"},
}

local defaults = {group=1, note="武器", sequence=1, level=1, attName="最小攻击力提高", weight=1000}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_regenerationGroup) do
	setmetatable(v, mt)
end

return cfg_equip_regenerationGroup