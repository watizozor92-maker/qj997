-- 此文件工具自动生成，不要修改
---@class cfg_LuckyBox_1_column
---唯一id
---[[客户端不使用]]@field id number @id column=1 A
---1=统计概率，从所有道具中抽取1个（按权重）
---2=独立概率，每个道具单独判断概率
---*每张表只允许使用1个类型
---[[客户端不使用]]@field type number @掉落类型 column=2 B
---策划备注
---[[客户端不使用]]@field beizhu string @ column=3 C
---道具id
---@field item number @道具id column=4 D
---数量区间，从中随机数量
---x#y，左右闭区间
---@field num string @数量 column=5 E
---掉落类型为1时，此处为：掉落次数#权重
---掉落类型为2时，此处为：掉落次数#概率（万分比）
---掉落次数填本次掉落之前已经掉落的次数，例如首次掉落，之前没掉过，这里就填0
---[[客户端不使用]]@field probability string @概率 column=6 F
---限制职业
---只有对应职业才会掉落
---不填不做限制
---格式：所属职业#职业等级|所属职业#职业等级
---[[客户端不使用]]@field career string @职业 column=7 G
---限制等级
---只有角色在对应等级区间内才会掉
---x#y，左右闭区间
---999999标识无限大
---不填不做限制
---[[客户端不使用]]@field level string @等级 column=8 H
---宝箱开启时概率携带的技能id#等级#携带概率（万分比）
---@field skillbaoxiang IntList @装备携带【技能】概率 column=9 I
---宝箱开启时概率携带的权重#等级
---@field strengthenbaoxiang IntListList @装携带【强化】概率 column=10 J
---宝箱开启时概率携带的幸运的概率（万分比）
---@field luckbaoxiang number @装备携带【幸运】概率 column=11 K
---宝箱开启时概率携带的追加的权重#等级
---@field appendsbaoxiang IntListList @装备携带【追加】概率 column=12 L
---[[客户端不使用]]@field   @ column=13 M

local local_skillbaoxiang = {
    skillbaoxiang_1={},
    skillbaoxiang_2={1100002,1,10000},
    skillbaoxiang_3={1300002,1,10000},
    skillbaoxiang_4={1005003,1,10000},
    skillbaoxiang_5={1100002,1,2500},
    skillbaoxiang_6={1300002,1,2500},
    skillbaoxiang_7={1005003,1,2500},
    skillbaoxiang_8={1100004,1,2500},
    skillbaoxiang_9={1100001,1,2500},

}

local local_strengthenbaoxiang = {
    strengthenbaoxiang_1={},
    strengthenbaoxiang_2={{0,0},{9000,1},{750,2},{190,3},{50,4},{9,5},{1,6}},

}

local local_appendsbaoxiang = {
    appendsbaoxiang_1={},
    appendsbaoxiang_2={{0,0},{9900,1},{99,2},{1,3}},

}

local cfg_LuckyBox_1 =
{
	{item=10010002, num="10000#10000", strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=10010002, num="2000#2000", strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=10010002, num="500#500", strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030013, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030027, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030035, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030022, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030025, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030014, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030012, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030009, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030010, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030016, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030028, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030029, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030036, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030037, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030079, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030023, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030021, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030026, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030018, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030066, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030038, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030039, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030080, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=60030081, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20410121, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20610121, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20810121, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20710121, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20910121, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2163, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2229, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2304, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2379, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2445, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20420121, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20620121, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20820121, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20720121, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20920121, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20430121, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20630121, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20830121, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20730121, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20930121, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20310121, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2000, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2002, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2004, skillbaoxiang={1100001,1,10000}, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2003, skillbaoxiang={1100004,1,10000}, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2035, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2036, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2037, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2038, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2044, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2045, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2070, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2067, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2071, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20130121, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2079, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20130221, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2086, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2087, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2111, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20120121, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2145, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2149, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2146, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2147, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20220121, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2155, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20410111},
	{item=20610111},
	{item=20810111},
	{item=20710111},
	{item=20910111},
	{item=1168},
	{item=1238},
	{item=1318},
	{item=1398},
	{item=1469},
	{item=20420111},
	{item=20620111},
	{item=20820111},
	{item=20720111},
	{item=20920111},
	{item=20430111},
	{item=20630111},
	{item=20830111},
	{item=20730111},
	{item=20930111},
	{item=20310111},
	{item=1000},
	{item=1002},
	{item=1004, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_9},
	{item=1003, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_8},
	{item=1036},
	{item=1037},
	{item=1038, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5},
	{item=1039, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5},
	{item=1045},
	{item=1046, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5},
	{item=1072},
	{item=1069},
	{item=1073},
	{item=20130111, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6},
	{item=1081, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6},
	{item=20130211, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6},
	{item=1088, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6},
	{item=1089, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6},
	{item=1114},
	{item=20120111},
	{item=1149},
	{item=1153, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7},
	{item=1150},
	{item=1151},
	{item=20220111, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7},
	{item=1159, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7},
	{item=1174},
	{item=1244},
	{item=1324},
	{item=1404},
	{item=1475},
	{item=20410211},
	{item=20610211},
	{item=20810211},
	{item=20710211},
	{item=20910211},
	{item=20420211},
	{item=20620211},
	{item=20820211},
	{item=20720211},
	{item=20920211},
	{item=20430211},
	{item=20630211},
	{item=20830211},
	{item=20730211},
	{item=20930211},
	{item=1006, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_8},
	{item=1007, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_9},
	{item=1008, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_9},
	{item=1009, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_8},
	{item=1040},
	{item=1041, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5},
	{item=1042, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5},
	{item=1047},
	{item=1068},
	{item=1070},
	{item=1074, skillbaoxiang={1100003,1,2500}},
	{item=20130311, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6},
	{item=1090, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6},
	{item=1091, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6},
	{item=1116},
	{item=20220311},
	{item=1158, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7},
	{item=1156, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7},
	{item=1154, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7},
}

local defaults = {num="1#1", skillbaoxiang={}, strengthenbaoxiang={{0,0},{9000,1},{750,2},{190,3},{50,4},{9,5},{1,6}}, luckbaoxiang=1500, appendsbaoxiang={{0,0},{9900,1},{99,2},{1,3}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_LuckyBox_1) do
	setmetatable(v, mt)
end

return cfg_LuckyBox_1