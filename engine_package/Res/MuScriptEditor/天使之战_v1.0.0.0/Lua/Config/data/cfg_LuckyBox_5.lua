-- 此文件工具自动生成，不要修改
---@class cfg_LuckyBox_5_column
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
    skillbaoxiang_2={1100001,1,10000},
    skillbaoxiang_3={1100004,1,10000},
    skillbaoxiang_4={1100002,1,10000},
    skillbaoxiang_5={1300002,1,10000},
    skillbaoxiang_6={1005003,1,10000},
    skillbaoxiang_7={1100003,1,10000},
    skillbaoxiang_8={1100005,1,10000},
    skillbaoxiang_9={1100003,1,2500},
    skillbaoxiang_10={1300002,1,2500},
    skillbaoxiang_11={1005003,1,2500},
    skillbaoxiang_12={1100002,1,2500},
    skillbaoxiang_13={1100005,1,2500},

}

local local_strengthenbaoxiang = {
    strengthenbaoxiang_1={},
    strengthenbaoxiang_2={{8000,0},{1300,1},{450,2},{190,3},{50,4},{9,5},{1,6}},

}

local local_appendsbaoxiang = {
    appendsbaoxiang_1={},
    appendsbaoxiang_2={{0,0},{9900,1},{99,2},{1,3}},

}

local cfg_LuckyBox_5 =
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
	{item=2169, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2235, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2310, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2385, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2451, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20410221, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20610221, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20810221, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20710221, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20910221, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20420221, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20620221, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20820221, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20720221, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20920221, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20430221, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20630221, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20830221, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20730221, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20930221, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2006, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2007, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2008, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2009, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2039, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2040, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2041, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2046, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2066, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2068, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2072, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20130321, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2088, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2089, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2113, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20220321, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2154, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2152, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2150, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20410321, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20610321, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20810321, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20710321, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20910321, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20420321, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20620321, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20820321, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20720321, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20920321, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20430321, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20630321, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20830321, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20730321, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20930321, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2176, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2242, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2317, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2392, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2458, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20310221, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2010, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2011, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2042, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2043, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2047, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2065, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2069, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2073, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2082, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2090, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20120221, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20120321, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20220221, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2156, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20220421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20410421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20610421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20810421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20710421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20910421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20420421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20620421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20820421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20720421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20920421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20430421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20630421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20830421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20730421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20930421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2064010421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2084010421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2074010421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2094010421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20310321, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2015, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_8, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2048, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2074, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20130421, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2091, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20120421, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2157, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2158, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20410521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20610521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20810521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20710521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20910521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20420521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20620521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20820521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20720521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20920521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2195, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2265, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2340, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2415, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2481, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2064010521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2084010521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2074010521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2094010521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2012, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20310421, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2092, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20120521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20220621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2049, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_8, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20410411, luckbaoxiang=1500},
	{item=20610411, luckbaoxiang=1500},
	{item=20810411, luckbaoxiang=1500},
	{item=20710411, luckbaoxiang=1500},
	{item=20910411, luckbaoxiang=1500},
	{item=20420411, luckbaoxiang=1500},
	{item=20620411, luckbaoxiang=1500},
	{item=20820411, luckbaoxiang=1500},
	{item=20720411, luckbaoxiang=1500},
	{item=20920411, luckbaoxiang=1500},
	{item=20430411, luckbaoxiang=1500},
	{item=20630411, luckbaoxiang=1500},
	{item=20830411, luckbaoxiang=1500},
	{item=20730411, luckbaoxiang=1500},
	{item=20930411, luckbaoxiang=1500},
	{item=2064010411, luckbaoxiang=1500},
	{item=2084010411, luckbaoxiang=1500},
	{item=2074010411, luckbaoxiang=1500},
	{item=2094010411, luckbaoxiang=1500},
	{item=20310311, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_9, luckbaoxiang=1500},
	{item=1015, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_13, luckbaoxiang=1500},
	{item=1049, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_12, luckbaoxiang=1500},
	{item=1076, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_9, luckbaoxiang=1500},
	{item=20130411, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_10, luckbaoxiang=1500},
	{item=1093, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_10, luckbaoxiang=1500},
	{item=20120411, luckbaoxiang=1500},
	{item=1161, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_11, luckbaoxiang=1500},
	{item=1162, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_11, luckbaoxiang=1500},
	{item=20410511, luckbaoxiang=1500},
	{item=20610511, luckbaoxiang=1500},
	{item=20810511, luckbaoxiang=1500},
	{item=20710511, luckbaoxiang=1500},
	{item=20910511, luckbaoxiang=1500},
	{item=20420511, luckbaoxiang=1500},
	{item=20620511, luckbaoxiang=1500},
	{item=20820511, luckbaoxiang=1500},
	{item=20720511, luckbaoxiang=1500},
	{item=20920511, luckbaoxiang=1500},
	{item=1200, luckbaoxiang=1500},
	{item=1274, luckbaoxiang=1500},
	{item=1354, luckbaoxiang=1500},
	{item=1434, luckbaoxiang=1500},
	{item=1505, luckbaoxiang=1500},
	{item=2064010511, luckbaoxiang=1500},
	{item=2084010511, luckbaoxiang=1500},
	{item=2074010511, luckbaoxiang=1500},
	{item=2094010511, luckbaoxiang=1500},
	{item=1012, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_12, luckbaoxiang=1500},
	{item=20310411, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_9, luckbaoxiang=1500},
	{item=1094, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_10, luckbaoxiang=1500},
	{item=20120511, luckbaoxiang=1500},
	{item=20220611, luckbaoxiang=1500},
	{item=1050, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_13, luckbaoxiang=1500},
}

local defaults = {num="1#1", skillbaoxiang={}, strengthenbaoxiang={{8000,0},{1300,1},{450,2},{190,3},{50,4},{9,5},{1,6}}, luckbaoxiang=500, appendsbaoxiang={{0,0},{9900,1},{99,2},{1,3}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_LuckyBox_5) do
	setmetatable(v, mt)
end

return cfg_LuckyBox_5