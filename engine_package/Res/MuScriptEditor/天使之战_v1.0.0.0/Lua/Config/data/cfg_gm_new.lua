-- 此文件工具自动生成，不要修改
---@class cfg_gm_new_column
---id,唯一id，不要进行修改，只可添加
---@field id number @id column=1 A
---1：角色
---2：怪物
---3：副本
---4：服务器
---5：任务
---6：背包&道具
---7：属性
---@field commandType number @GM命令类型 column=2 B
---GM命令名称
---@field commandName string @GM命令名称 column=3 C
---格式：
---一键神装：道具id#修正id&道具id#修正id|道具id#修正id&道具id#修正id
---填满货币：道具id#道具数量|道具id#道具数量
---材料生成：（材料包1）道具id#道具数量&道具id#道具数量|（材料包2）道具id#道具数量&道具id#道具数量
---备注：需要通过配表的命令可以走此参数字段，不需要配表的命令可以不填
---@field parameter1 intListListList @GM命令参数1 column=4 D
---格式：
---一键神装：根职业id|根职业id
---清空货币：道具id|道具id|道具id
---材料生成：材料包名称|材料包名称
---备注：需要通过配表的命令可以走此参数字段，不需要配表的命令可以不填
---@field parameter2 StringListList @GM命令参数2 column=5 E
---GM命令备注
---@field beizhu string @GM命令备注 column=6 F
---高亮路径
---@field selectUI string @高亮路径 column=7 G

local local_parameter1 = {
    parameter1_1={},

}

local local_parameter2 = {
    parameter2_1={},

}

local cfg_gm_new =
{
	{id=1, commandName="一键神装", parameter2={{"1"},{"2"},{"3"}}, beizhu="满等级、满属性点、满转职等级、满技能", selectUI="GMContent/viewport/content/role/RoleContent/Bg/juese1"},
	{id=2, commandName="锁血锁蓝", parameter1=local_parameter1.parameter1_1, beizhu="开启后、任何情况下血量和蓝量都不会减少。满血满蓝：开启后 直接回满血量和蓝量", selectUI="GMContent/viewport/content/role/RoleContent/Bg/juese2"},
	{id=3, commandName="增加经验", parameter1=local_parameter1.parameter1_1, beizhu="增加当前角色的经验值", selectUI="GMContent/viewport/content/role/RoleContent/Bg/juese3"},
	{id=4, commandName="设置等级", parameter1=local_parameter1.parameter1_1, beizhu="设置当前角色等级", selectUI="GMContent/viewport/content/role/RoleContent/Bg/juese4"},
	{id=5, commandName="学习技能", parameter1=local_parameter1.parameter1_1, beizhu="引援cfg_skill，随配置表变化。能够学习当前职业 可学习的所有技能", selectUI="GMContent/viewport/content/role/RoleContent/Bg/juese5"},
	{id=6, commandName="传送", parameter1=local_parameter1.parameter1_1, beizhu="引援cfg_mapMove，随配置表变化。根据地图、x坐标和y坐标直接传送到对应位置", selectUI="GMContent/viewport/content/role/RoleContent/Bg/juese7"},
	{id=7, commandName="转职", parameter1=local_parameter1.parameter1_1, beizhu="引援cfg_career，随配置表变化。直接转职到任意职业（包含更高职级）", selectUI="GMContent/viewport/content/role/RoleContent/Bg/juese8"},
	{id=9, commandType=2, commandName="生成怪物", parameter1=local_parameter1.parameter1_1, beizhu="引援cfg_monster，随配置表变化。在角色当前位置，生成指定怪物、指定数量", selectUI="GMContent/viewport/content/monster/MonsterContent/monster1"},
	{id=10, commandType=2, commandName="杀死怪物/人", parameter1=local_parameter1.parameter1_1, beizhu="输入x坐标和y坐标，直接击杀该坐标上的怪物或者人", selectUI="GMContent/viewport/content/monster/MonsterContent/monster2"},
	{id=11, commandType=3, commandName="副本", parameter1=local_parameter1.parameter1_1, beizhu="引援cfg_activity_rule，随配置表变化。开启副本活动、关闭副本活动、完成副本活动、开启所有副本、关闭所有副本", selectUI="GMContent/viewport/content/fuben/DupContent/juese2 (4)"},
	{id=12, commandType=4, commandName="服务器时间", parameter1=local_parameter1.parameter1_1, beizhu="往后调整服务器时间，获取当前服务器时间。", selectUI="GMContent/viewport/content/fuwuqi/ServerContent/time"},
	{id=13, commandType=5, commandName="任务", parameter1=local_parameter1.parameter1_1, beizhu="引援cfg_task，随配置表变化。", selectUI="GMContent/viewport/content/task/TaskContent/task"},
	{id=14, commandType=6, commandName="背包", parameter1=local_parameter1.parameter1_1, beizhu="随机生成物品填满背包、清空背包内所有物品", selectUI="GMContent/viewport/content/baganditem/BagAndItemContent/Bg/bag"},
	{id=15, commandType=6, commandName="货币", parameter1={{{10010001,999999999}},{{10020001,9999999999}},{{10030001,9999999999}},{{10040001,9999999999}},{{10060001,9999999999}},{{10070001,9999999999}}}, parameter2={{"10010001"},{"10020001"},{"10030001"},{"10040001"},{"10050001"},{"10060001"},{"10070001"}}, beizhu="生成货币", selectUI="GMContent/viewport/content/baganditem/BagAndItemContent/Bg/huobi"},
	{id=16, commandType=6, commandName="材料生成", parameter1=local_parameter1.parameter1_1, parameter2={{"强化材料包"},{"追加材料包"},{"符文重铸材料包"}}, beizhu="材料生成", selectUI="GMContent/viewport/content/baganditem/BagAndItemContent/Bg/cailiao"},
	{id=17, commandType=6, commandName="自定义装备", parameter1=local_parameter1.parameter1_1, beizhu="自定义装备", selectUI="GMContent/viewport/content/baganditem/BagAndItemContent/Bg/customequip"},
	{id=18, commandType=6, commandName="预设装备", parameter1=local_parameter1.parameter1_1, beizhu="预设装备", selectUI="GMContent/viewport/content/baganditem/BagAndItemContent/Bg/customequip"},
	{id=19, commandType=7, commandName="一级属性", parameter1=local_parameter1.parameter1_1, beizhu="引援cfg_att_info，随配置表变化。", selectUI="GMContent/viewport/content/att/AttContent/Bg/bag"},
	{id=20, commandType=7, commandName="二级属性", parameter1=local_parameter1.parameter1_1, beizhu="引援cfg_att_info，随配置表变化。", selectUI="GMContent/viewport/content/att/AttContent/Bg/bag"},
}

local defaults = {commandType=1, parameter1={{{20311231,0},{20311231,0},{20411231,0},{20611231,0},{20711231,0},{20811231,0},{20911231,0}},{{20121231,0},{20221231,0},{20421231,0},{20621231,0},{20721231,0},{20821231,0},{20921231,0}},{{20131231,0},{20231231,0},{20431231,0},{20631231,0},{20731231,0},{20831231,0},{20931231,0}}}, parameter2={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_gm_new) do
	setmetatable(v, mt)
end

return cfg_gm_new