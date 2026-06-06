-- 此文件工具自动生成，不要修改
---@class cfg_Monster_mboxDecay_column
---唯一
---cfg_Monster_mbox表的mboxId
---@field id number @boxId column=1 A
---同组的盒子进行统一计数，对应后面衰减
---@field group number @盒子组 column=2 B
---盒子备注，策划看
---@field beizhu string @备注 column=3 C
---对应全服实际掉出box组计数
---次数#掉率衰减十万分比|次数#掉率衰减十万分比
---10#90000|100#10000
---击杀第11次开始，掉率下降90%，击杀第101次开始，掉率下降到10%
---掉率衰减是累乘算法
---每天第x\y\z。。。分钟重置，参数在global表
---@field globalcontrol string @全服掉落控制 column=4 D
---对应个人实际掉出box组计数
---次数#掉率衰减十万分比|次数#掉率衰减十万分比
---10#90000|100#10000
---击杀第11次开始，掉率下降90%，击杀第101次开始，掉率下降到10%
---掉率衰减是累乘算法
---每天第x\y\z。。。分钟重置，参数在global表
---@field playcontrol string @个人掉落控制 column=5 E
local cfg_Monster_mboxDecay =
{
	{id=201, beizhu="宝石组1"},
	{id=202, beizhu="宝石组2"},
	{id=203, beizhu="宝石组3"},
	{id=204, beizhu="宝石组4"},
	{id=205, beizhu="宝石组5"},
	{id=102, group=3, beizhu="实用技能组(小怪)", globalcontrol="9#0", playcontrol=""},
	{id=103, group=4, beizhu="2转技能组(小怪)", globalcontrol="3#0", playcontrol=""},
	{id=801, group=5, beizhu="卓越首饰组(小怪)", globalcontrol="5#0", playcontrol=""},
	{id=803, group=6, beizhu="卓越首饰组(boss)", globalcontrol="5#0", playcontrol=""},
	{id=1124, group=7, beizhu="保底白装武器1"},
	{id=1125, group=8, beizhu="保底白装武器2"},
	{id=1126, group=9, beizhu="保底白装武器3"},
	{id=1102, group=10, beizhu="新手宝石组1"},
	{id=1103, group=11, beizhu="新手宝石组2"},
	{id=1104, group=12, beizhu="新手宝石组3"},
	{id=1105, group=13, beizhu="新手宝石组4"},
}

local defaults = {group=2, globalcontrol="", playcontrol="2#0"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Monster_mboxDecay) do
	setmetatable(v, mt)
end

return cfg_Monster_mboxDecay