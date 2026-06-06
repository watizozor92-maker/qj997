-- 此文件工具自动生成，不要修改
---@class cfg_LuckyBox_10_column
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
    skillbaoxiang_2={1100003,1,10000},
    skillbaoxiang_3={1100005,1,10000},
    skillbaoxiang_4={1300002,1,10000},
    skillbaoxiang_5={1004019,1,10000},
    skillbaoxiang_6={1100003,1,2500},
    skillbaoxiang_7={1004019,1,2500},
    skillbaoxiang_8={1300002,1,2500},

}

local local_strengthenbaoxiang = {
    strengthenbaoxiang_1={},
    strengthenbaoxiang_2={{8000,0},{1300,1},{450,2},{190,3},{50,4},{9,5},{1,6}},

}

local local_appendsbaoxiang = {
    appendsbaoxiang_1={},
    appendsbaoxiang_2={{0,0},{9900,1},{99,2},{1,3}},

}

local cfg_LuckyBox_10 =
{
	{item=10010002, num="10000#10000", strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=10010002, num="2000#2000", strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
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
	{item=2012, skillbaoxiang={1100002,1,10000}, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20310421, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2092, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20120521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20220621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2049, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20410621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20610621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20810621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20710621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20910621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20420621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20620621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20820621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20720621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20920621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20430621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20630621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20830621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20730621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20930621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2064010621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2084010621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2074010621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2094010621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20310521, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2017, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2051, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2075, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20130621, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2094, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2119, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20410721, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20610721, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20810721, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20710721, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20910721, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20420721, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20620721, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20820721, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20720721, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20920721, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20430721, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20630721, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20830721, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20730721, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20930721, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2064010721, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2084010721, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2074010721, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2094010721, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2024, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2031, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2018, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2025, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20130921, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20130721, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2097, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20120621, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20120821, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20410921, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20610921, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20810921, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20710921, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20910921, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20420921, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20620921, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20820921, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20720921, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20920921, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20430521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20630521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20830521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20730521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20930521, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2064010921, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2084010921, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2074010921, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2094010921, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20310621, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20310721, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2021, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2023, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2076, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20131021, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20130521, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20120921, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=20410911, luckbaoxiang=1500},
	{item=20610911, luckbaoxiang=1500},
	{item=20810911, luckbaoxiang=1500},
	{item=20710911, luckbaoxiang=1500},
	{item=20910911, luckbaoxiang=1500},
	{item=20420911, luckbaoxiang=1500},
	{item=20620911, luckbaoxiang=1500},
	{item=20820911, luckbaoxiang=1500},
	{item=20720911, luckbaoxiang=1500},
	{item=20920911, luckbaoxiang=1500},
	{item=20430511, luckbaoxiang=1500},
	{item=20630511, luckbaoxiang=1500},
	{item=20830511, luckbaoxiang=1500},
	{item=20730511, luckbaoxiang=1500},
	{item=20930511, luckbaoxiang=1500},
	{item=2064010911, luckbaoxiang=1500},
	{item=2084010911, luckbaoxiang=1500},
	{item=2074010911, luckbaoxiang=1500},
	{item=2094010911, luckbaoxiang=1500},
	{item=20310611, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, luckbaoxiang=1500},
	{item=20310711, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, luckbaoxiang=1500},
	{item=1021, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, luckbaoxiang=1500},
	{item=1023, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, luckbaoxiang=1500},
	{item=1078, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, luckbaoxiang=1500},
	{item=20131011, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_8, luckbaoxiang=1500},
	{item=20130511, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_8, luckbaoxiang=1500},
	{item=20120911, luckbaoxiang=1500},
}

local defaults = {num="1#1", skillbaoxiang={}, strengthenbaoxiang={{8000,0},{1300,1},{450,2},{190,3},{50,4},{9,5},{1,6}}, luckbaoxiang=500, appendsbaoxiang={{0,0},{9900,1},{99,2},{1,3}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_LuckyBox_10) do
	setmetatable(v, mt)
end

return cfg_LuckyBox_10