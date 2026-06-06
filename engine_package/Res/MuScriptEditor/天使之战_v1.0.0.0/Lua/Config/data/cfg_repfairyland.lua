-- 此文件工具自动生成，不要修改
---@class cfg_repfairyland_column
---@field id number @唯一id column=1 A
---策划备注
---@field cehuakan string @备注 column=2 B
---关卡名称
---@field name StringList @关卡名称 column=3 C
---到达等级可进入挑战
---填空=无限制
---@field level number @等级限制 column=4 D
---开服天数到达X天可进入挑战
---填空=无限制
---@field startDay number @开服天数限制 column=5 E
---检测全身穿戴的装备的强化等级，到达配置等级后可进入挑战
---填空=无限制
---@field strengthenLevel number @强化等级限制 column=6 F
---关联cfg_map_info表ID
---@field mapId number @地图id column=7 G
---关联cfg_mapMove表ID
---@field mapMove number @传送id column=8 H
---关联cfg_repfairyland_monster表
---@field monster number @怪物波次ID column=9 I
---进入副本后，左侧目标显示
---BOSS名称、BOSS状态、BOSS坐标
---@field repTarget string @副本目标 column=10 J
local cfg_repfairyland =
{
	{id=10001, cehuakan="残暴的 冰后", name={"秘境1层"}, level=20, mapId=10001, mapMove=63, monster=10001},
	{id=10002, cehuakan="残暴的 魔鬼戈登", name={"秘境2层"}, level=30, mapId=10002, mapMove=64, monster=10002},
	{id=10003, cehuakan="残暴的 魔王巴洛克", name={"秘境3层"}, level=45, mapId=10003, mapMove=65, monster=10003},
	{id=10004, cehuakan="残暴的 海魔希特拉", name={"秘境4层"}, level=65, mapId=10004, mapMove=66, monster=10004},
	{id=10005, cehuakan="炽炎魔", name={"秘境5层"}, level=100, mapId=10005, mapMove=67, monster=10005},
	{id=10006, cehuakan="丛林召唤者", name={"秘境6层"}, level=150, mapId=10006, mapMove=68, monster=10006},
	{id=10007, cehuakan="天魔菲尼斯", name={"秘境7层"}, level=170, mapId=10007, mapMove=128, monster=10007},
	{id=10008, cehuakan="疯魔", name={"秘境8层"}, level=200, mapId=10008, mapMove=129, monster=10008},
	{id=10009, cehuakan="玛雅之手", name={"秘境9层"}, level=250, mapId=10009, mapMove=130, monster=10009},
	{id=10010, cehuakan="幽灵巨蛛", name={"秘境10层"}, level=300, mapId=10010, mapMove=131, monster=10010},
	{id=10011, cehuakan="闪电巨人", name={"秘境11层"}, level=350, mapId=10011, mapMove=132, monster=10011},
	{id=10012, cehuakan="巨斧战士", name={"秘境12层"}, level=400, mapId=10012, mapMove=133, monster=10012},
	{id=10013, cehuakan="幽灵火焰巨人", name={"秘境13层"}, level=450, mapId=10013, mapMove=134, monster=10013},
	{id=10014, cehuakan="毒巨魔", name={"秘境14层"}, level=500, mapId=10014, mapMove=135, monster=10014},
	{id=10015, cehuakan="幽灵角斗士", name={"秘境15层"}, level=550, mapId=10015, mapMove=136, monster=10015},
	{id=10016, cehuakan="幽影疯魔", name={"秘境16层"}, level=600, mapId=10016, mapMove=137, monster=10016},
	{id=10017, cehuakan="暗黑指挥官", name={"秘境17层"}, level=650, mapId=10017, mapMove=138, monster=10017},
	{id=10018, cehuakan="帝国校尉", name={"秘境18层"}, level=700, mapId=10018, mapMove=139, monster=10018},
	{id=10019, cehuakan="帝国大魔法师", name={"秘境19层"}, level=750, mapId=10019, mapMove=140, monster=10019},
	{id=10020, cehuakan="英雄巨斧战士", name={"秘境20层"}, level=800, mapId=10020, mapMove=141, monster=10020},
	{id=10024, cehuakan="帝国刀盾兵", name={"秘境21层"}, level=850, mapId=10024, mapMove=142, monster=10024},
	{id=10025, cehuakan="屠夫", name={"秘境22层"}, level=900, mapId=10025, mapMove=143, monster=10025},
	{id=10026, cehuakan="帝国第一军团长", name={"秘境23层"}, level=950, mapId=10026, mapMove=144, monster=10026},
}

local defaults = {startDay=0, strengthenLevel=0, repTarget=""}
local mt = {__index = defaults}
for _, v in ipairs(cfg_repfairyland) do
	setmetatable(v, mt)
end

return cfg_repfairyland