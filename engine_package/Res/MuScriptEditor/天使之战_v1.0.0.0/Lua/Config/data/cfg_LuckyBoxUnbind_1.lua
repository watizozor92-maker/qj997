-- 此文件工具自动生成，不要修改
---@class cfg_LuckyBoxUnbind_1_column
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

local cfg_LuckyBoxUnbind_1 =
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
	{item=2041012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2061012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2081012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2071012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2091012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=216399, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=222999, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=230499, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=237999, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=244599, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2042012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2062012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2082012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2072012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2092012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2043012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2063012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2083012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2073012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2093012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2031012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=200099, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=200299, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=200499, skillbaoxiang={1100001,1,10000}, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=200399, skillbaoxiang={1100004,1,10000}, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=203599, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=203699, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=203799, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=203899, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=204499, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=204599, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=207099, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=206799, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=207199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2013012199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=207999, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2013022199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=208699, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=208799, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=211199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2012012199, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=214599, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=214999, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=214699, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=214799, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2022012199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=215599, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4, strengthenbaoxiang=local_strengthenbaoxiang.strengthenbaoxiang_1, luckbaoxiang=500, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2041011199},
	{item=2061011199},
	{item=2081011199},
	{item=2071011199},
	{item=2091011199},
	{item=116899},
	{item=123899},
	{item=131899},
	{item=139899},
	{item=146999},
	{item=2042011199},
	{item=2062011199},
	{item=2082011199},
	{item=2072011199},
	{item=2092011199},
	{item=2043011199},
	{item=2063011199},
	{item=2083011199},
	{item=2073011199},
	{item=2093011199},
	{item=2031011199},
	{item=100099},
	{item=100299},
	{item=100499, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_9},
	{item=100399, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_8},
	{item=103699},
	{item=103799},
	{item=103899, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5},
	{item=103999, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5},
	{item=104599},
	{item=104699, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5},
	{item=107299},
	{item=106999},
	{item=107399},
	{item=2013011199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6},
	{item=108199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6},
	{item=2013021199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6},
	{item=108899, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6},
	{item=108999, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6},
	{item=111499},
	{item=2012011199},
	{item=114999},
	{item=115399, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7},
	{item=115099},
	{item=115199},
	{item=2022011199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7},
	{item=115999, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7},
	{item=117499},
	{item=124499},
	{item=132499},
	{item=140499},
	{item=147599},
	{item=2041021199},
	{item=2061021199},
	{item=2081021199},
	{item=2071021199},
	{item=2091021199},
	{item=2042021199},
	{item=2062021199},
	{item=2082021199},
	{item=2072021199},
	{item=2092021199},
	{item=2043021199},
	{item=2063021199},
	{item=2083021199},
	{item=2073021199},
	{item=2093021199},
	{item=100699, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_8},
	{item=100799, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_9},
	{item=100899, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_9},
	{item=100999, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_8},
	{item=104099},
	{item=104199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5},
	{item=104299, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5},
	{item=104799},
	{item=106899},
	{item=107099},
	{item=107499, skillbaoxiang={1100003,1,2500}},
	{item=2013031199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6},
	{item=109099, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6},
	{item=109199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6},
	{item=111699},
	{item=2022031199},
	{item=115899, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7},
	{item=115699, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7},
	{item=115499, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_7},
}

local defaults = {num="1#1", skillbaoxiang={}, strengthenbaoxiang={{0,0},{9000,1},{750,2},{190,3},{50,4},{9,5},{1,6}}, luckbaoxiang=1500, appendsbaoxiang={{0,0},{9900,1},{99,2},{1,3}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_LuckyBoxUnbind_1) do
	setmetatable(v, mt)
end

return cfg_LuckyBoxUnbind_1