-- 此文件工具自动生成，不要修改
---@class cfg_LuckyBoxUnbind_6_column
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
    skillbaoxiang_10={1100005,1,2500},
    skillbaoxiang_11={1300002,1,2500},

}

local local_strengthenbaoxiang = {
    strengthenbaoxiang_1={},
    strengthenbaoxiang_2={{8000,0},{1300,1},{450,2},{190,3},{50,4},{9,5},{1,6}},

}

local local_appendsbaoxiang = {
    appendsbaoxiang_1={},
    appendsbaoxiang_2={{0,0},{9900,1},{99,2},{1,3}},

}

local cfg_LuckyBoxUnbind_6 =
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
	{item=200699, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=200799, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=200899, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=200999, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=203999, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=204099, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=204199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=204699, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=206699, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=206899, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=207299, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2013032199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=208899, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=208999, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=211399, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2022032199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=215499, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=215299, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=215099, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
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
	{item=201199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=204299, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=204399, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=204799, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=206599, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=206999, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=207399, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=208299, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=209099, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2012022199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2012032199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2022022199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=215699, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2022042199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2041042199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2061042199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2081042199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2071042199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2091042199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2042042199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2062042199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2082042199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2072042199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2092042199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2043042199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2063042199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2083042199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2073042199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2093042199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1280034199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1280034299, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1280034499, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1280034399, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2031032199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=201599, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_8, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=204899, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=207499, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2013042199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=209199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2012042199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=215799, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=215899, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2041052199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2061052199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2081052199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2071052199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2091052199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2042052199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2062052199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2082052199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2072052199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2092052199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=219599, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=226599, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=234099, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=241599, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=248199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1280025199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1280026099, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1280028699, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1280028599, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=201299, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2031042199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=209299, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2012052199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2022062199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=204999, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_8, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2041062199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2061062199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2081062199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2071062199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2091062199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2042062199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2062062199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2082062199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2072062199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2092062199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2043062199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2063062199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2083062199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2073062199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2093062199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1280035199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1280035299, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1280035499, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1280035399, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2031052199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=201799, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_8, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=205199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=207599, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2013062199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=209499, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=211999, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2041051199, luckbaoxiang=1500},
	{item=2061051199, luckbaoxiang=1500},
	{item=2081051199, luckbaoxiang=1500},
	{item=2071051199, luckbaoxiang=1500},
	{item=2091051199, luckbaoxiang=1500},
	{item=2042051199, luckbaoxiang=1500},
	{item=2062051199, luckbaoxiang=1500},
	{item=2082051199, luckbaoxiang=1500},
	{item=2072051199, luckbaoxiang=1500},
	{item=2092051199, luckbaoxiang=1500},
	{item=120099, luckbaoxiang=1500},
	{item=127499, luckbaoxiang=1500},
	{item=135499, luckbaoxiang=1500},
	{item=143499, luckbaoxiang=1500},
	{item=150599, luckbaoxiang=1500},
	{item=1280019899, luckbaoxiang=1500},
	{item=1280019999, luckbaoxiang=1500},
	{item=1280022399, luckbaoxiang=1500},
	{item=1280022299, luckbaoxiang=1500},
	{item=101299, skillbaoxiang={1100002,1,2500}, luckbaoxiang=1500},
	{item=2031041199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_9, luckbaoxiang=1500},
	{item=109499, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_11, luckbaoxiang=1500},
	{item=2012051199, luckbaoxiang=1500},
	{item=2022061199, luckbaoxiang=1500},
	{item=105099, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_10, luckbaoxiang=1500},
	{item=2041061199, luckbaoxiang=1500},
	{item=2061061199, luckbaoxiang=1500},
	{item=2081061199, luckbaoxiang=1500},
	{item=2071061199, luckbaoxiang=1500},
	{item=2091061199, luckbaoxiang=1500},
	{item=2042061199, luckbaoxiang=1500},
	{item=2062061199, luckbaoxiang=1500},
	{item=2082061199, luckbaoxiang=1500},
	{item=2072061199, luckbaoxiang=1500},
	{item=2092061199, luckbaoxiang=1500},
	{item=2043061199, luckbaoxiang=1500},
	{item=2063061199, luckbaoxiang=1500},
	{item=2083061199, luckbaoxiang=1500},
	{item=2073061199, luckbaoxiang=1500},
	{item=2093061199, luckbaoxiang=1500},
	{item=1280029199, luckbaoxiang=1500},
	{item=1280029299, luckbaoxiang=1500},
	{item=1280029499, luckbaoxiang=1500},
	{item=1280029399, luckbaoxiang=1500},
	{item=2031051199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_9, luckbaoxiang=1500},
	{item=101799, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_10, luckbaoxiang=1500},
	{item=105299, luckbaoxiang=1500},
	{item=107799, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_9, luckbaoxiang=1500},
	{item=2013061199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_11, luckbaoxiang=1500},
	{item=109699, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_11, luckbaoxiang=1500},
	{item=112299, luckbaoxiang=1500},
}

local defaults = {num="1#1", skillbaoxiang={}, strengthenbaoxiang={{8000,0},{1300,1},{450,2},{190,3},{50,4},{9,5},{1,6}}, luckbaoxiang=500, appendsbaoxiang={{0,0},{9900,1},{99,2},{1,3}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_LuckyBoxUnbind_6) do
	setmetatable(v, mt)
end

return cfg_LuckyBoxUnbind_6