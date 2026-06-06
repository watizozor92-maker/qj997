-- 此文件工具自动生成，不要修改
---@class cfg_LuckyBoxUnbind_3_column
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
    skillbaoxiang_5={1100004,1,10000},
    skillbaoxiang_6={1100001,1,10000},
    skillbaoxiang_7={1100003,1,10000},
    skillbaoxiang_8={1100003,1,2500},
    skillbaoxiang_9={1100002,1,2500},
    skillbaoxiang_10={1100004,1,2500},
    skillbaoxiang_11={1300002,1,2500},
    skillbaoxiang_12={1005003,1,2500},

}

local local_strengthenbaoxiang = {
    strengthenbaoxiang_1={},
    strengthenbaoxiang_2={{0,0},{9000,1},{750,2},{190,3},{50,4},{9,5},{1,6}},
    strengthenbaoxiang_3={{8000,0},{1300,1},{450,2},{190,3},{50,4},{9,5},{1,6}},

}

local local_appendsbaoxiang = {
    appendsbaoxiang_1={},
    appendsbaoxiang_2={{0,0},{9900,1},{99,2},{1,3}},

}

local cfg_LuckyBoxUnbind_3 =
{
	{item=10010001, num="10000#10000", strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=10010001, num="2000#2000", strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=10010001, num="500#500", strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263001399, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263002799, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263003599, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263002299, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263002599, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263001499, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263001299, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263000999, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263001099, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263001699, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263002899, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263002999, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263003699, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263003799, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263007999, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263002399, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263002199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263002699, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263001899, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263006699, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263003899, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263003999, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263008099, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1263008199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2041012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2061012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2081012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2071012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2091012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=216399, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=222999, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=230499, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=237999, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=244599, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2042012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2062012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2082012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2072012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2092012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2043012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2063012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2083012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2073012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2093012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2031012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=200099, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=200299, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=200499, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=200399, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=203599, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=203699, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=203799, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=203899, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=204499, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=204599, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=207099, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=206799, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=207199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2013012199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=207999, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2013022199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=208699, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=208799, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=211199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2012012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=214599, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=214999, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=214699, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=214799, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2022012199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=215599, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=216999, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=223599, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=231099, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=238599, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=245199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2041022199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2061022199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2081022199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2071022199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2091022199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2042022199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2062022199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2082022199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2072022199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2092022199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2043022199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2063022199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2083022199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2073022199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2093022199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=200699, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=200799, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=200899, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=200999, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=203999, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=204099, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=204199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=204699, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=206699, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=206899, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=207299, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2013032199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=208899, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=208999, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=211399, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2022032199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=215499, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=215299, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=215099, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2041032199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2061032199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2081032199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2071032199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2091032199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2042032199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2062032199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2082032199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2072032199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2092032199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2043032199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2063032199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2083032199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2073032199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2093032199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=217699, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=224299, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=231799, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=239299, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=245899, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2031022199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=201099, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=201199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=204299, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=204399, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=204799, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=206599, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=206999, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=207399, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=208299, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=209099, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2012022199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2012032199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2022022199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=215699, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2022042199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2041031199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=2061031199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=2081031199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=2071031199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=2091031199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=2042031199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=2062031199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=2082031199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=2072031199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=2092031199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=2043031199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=2063031199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=2083031199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=2073031199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=2093031199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=118199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=125199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=133199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=141199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=148299, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=2031021199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_8, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=101099, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_8, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=101199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_10, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=104399, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_9, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=104499, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_9, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_2, luckbaoxiang=1500},
	{item=104899, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_9, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=1500},
	{item=106799, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_8, luckbaoxiang=1500},
	{item=107199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_10, luckbaoxiang=1500},
	{item=107599, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_8, luckbaoxiang=1500},
	{item=108499, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_11, luckbaoxiang=1500},
	{item=109299, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_11, luckbaoxiang=1500},
	{item=2012021199, luckbaoxiang=1500},
	{item=2012031199, luckbaoxiang=1500},
	{item=2022021199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_12, luckbaoxiang=1500},
	{item=116099, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_12, luckbaoxiang=1500},
	{item=2022041199, luckbaoxiang=1500},
	{item=2041041199, luckbaoxiang=1500},
	{item=2061041199, luckbaoxiang=1500},
	{item=2081041199, luckbaoxiang=1500},
	{item=2071041199, luckbaoxiang=1500},
	{item=2091041199, luckbaoxiang=1500},
	{item=2042041199, luckbaoxiang=1500},
	{item=2062041199, luckbaoxiang=1500},
	{item=2082041199, luckbaoxiang=1500},
	{item=2072041199, luckbaoxiang=1500},
	{item=2092041199, luckbaoxiang=1500},
	{item=2043041199, luckbaoxiang=1500},
	{item=2063041199, luckbaoxiang=1500},
	{item=2083041199, luckbaoxiang=1500},
	{item=2073041199, luckbaoxiang=1500},
	{item=2093041199, luckbaoxiang=1500},
	{item=1280028199, luckbaoxiang=1500},
	{item=1280028299, luckbaoxiang=1500},
	{item=1280028499, luckbaoxiang=1500},
	{item=1280028399, luckbaoxiang=1500},
	{item=2031031199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_8, luckbaoxiang=1500},
	{item=101599, skillbaoxiang={1100005,1,2500}, luckbaoxiang=1500},
	{item=104999, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_9, luckbaoxiang=1500},
	{item=107699, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_8, luckbaoxiang=1500},
	{item=2013041199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_11, luckbaoxiang=1500},
	{item=109399, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_11, luckbaoxiang=1500},
	{item=2012041199, luckbaoxiang=1500},
	{item=116199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_12, luckbaoxiang=1500},
	{item=116299, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_12, luckbaoxiang=1500},
}

local defaults = {num="1#1", skillbaoxiang={}, strengthenbaoxiang={{8000,0},{1300,1},{450,2},{190,3},{50,4},{9,5},{1,6}}, luckbaoxiang=500, appendsbaoxiang={{0,0},{9900,1},{99,2},{1,3}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_LuckyBoxUnbind_3) do
	setmetatable(v, mt)
end

return cfg_LuckyBoxUnbind_3