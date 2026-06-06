-- 此文件工具自动生成，不要修改
---@class cfg_recovery_out_column
---唯一序号
---@field id number @id column=1 A
---1：分解结果 > 1
---2：分解结果 =< 1
---@field group number @执行分类 column=2 B
---1：装备
---2：技能
---空：则没有类型，不显示
---@field recoverType number @执行类型 column=3 C
---回收和分解的装备组
---@field groupName1 string @分组名 column=4 D
---执行分解时读取
---
---道具id#数量&道具id#数量|道具id&数量#道具id&数量
---
---0为不能执行分解
---@field needMaterial IntListList @消耗材料 column=5 E
---
---道具id#固定值#权重|道具id#固定值#权重
---
---回收获得的道具数量无随机功能
---
---0为不可执行回收/分解
---@field material IntListList @#10#10000 column=6 F
---当装备附带幸运/卓越词条/强化等级
---额外对获得材料进行加成，相处后大于1就取整1
---
---material*{100+(幸运/[1]+卓越词条数/[2]+强化等级/[3])}
---@field jiacheng IntListList @分解加成 column=7 G

local local_needMaterial = {
    needMaterial_1={{10010001,1000000}},
    needMaterial_2={{10010001,10000000}},
    needMaterial_3={{10010001,10000}},
    needMaterial_4={{10010001,100000}},

}

local local_jiacheng = {
    jiacheng_1={{1,2,4}},
    jiacheng_2={},

}

local cfg_recovery_out =
{
	{id=1, groupName1="1级卓越装备", needMaterial=local_needMaterial.needMaterial_1, jiacheng={{0,0,0}}},
	{id=2, groupName1="2级卓越装备", needMaterial=local_needMaterial.needMaterial_1, material={{50040060,1,10000}}},
	{id=3, groupName1="3级卓越装备", needMaterial=local_needMaterial.needMaterial_1, material={{50040060,2,10000}}},
	{id=4, groupName1="首饰分解", needMaterial=local_needMaterial.needMaterial_2, material={{1015086,5,10000}}},
	{id=5, groupName1="战旗分解", needMaterial=local_needMaterial.needMaterial_2, material={{1016109,33,10000}}, jiacheng={{1,2,1}}},
	{id=6, groupName1="套装分解", needMaterial={{10010001,5000000}}, material={{2000050,10,10000}}, jiacheng={{1,0,4}}},
	{id=7, recoverType=2, groupName1="1级技能书分解", needMaterial=local_needMaterial.needMaterial_3, material={{1015346,1,10000}}, jiacheng=local_jiacheng.jiacheng_2},
	{id=8, recoverType=2, groupName1="2级技能书分解", needMaterial=local_needMaterial.needMaterial_3, material={{1015346,3,10000}}, jiacheng=local_jiacheng.jiacheng_2},
	{id=9, recoverType=2, groupName1="3级技能书分解", needMaterial=local_needMaterial.needMaterial_3, material={{1015346,5,10000}}, jiacheng=local_jiacheng.jiacheng_2},
	{id=10, recoverType=2, groupName1="4级技能书分解", needMaterial=local_needMaterial.needMaterial_3, material={{1015346,10,10000}}, jiacheng=local_jiacheng.jiacheng_2},
	{id=11, groupName1="祝福宝石组合", material={{50030002,10,10000}}, jiacheng=local_jiacheng.jiacheng_2},
	{id=12, groupName1="灵魂宝石组合", material={{50030003,10,10000}}, jiacheng=local_jiacheng.jiacheng_2},
	{id=13, groupName1="玛雅之石组合", material={{50030001,10,10000}}, jiacheng=local_jiacheng.jiacheng_2},
	{id=14, groupName1="创造宝石组合", material={{50030005,10,10000}}, jiacheng=local_jiacheng.jiacheng_2},
	{id=15, groupName1="生命宝石组合", material={{50030004,10,10000}}, jiacheng=local_jiacheng.jiacheng_2},
	{id=16, groupName1="金砖分解", needMaterial={{10040001,1}}, material={{10010001,10000000}}, jiacheng=local_jiacheng.jiacheng_2},
	{id=17, groupName1="黄金卷分解", needMaterial=local_needMaterial.needMaterial_1, material={{10040001,200}}, jiacheng=local_jiacheng.jiacheng_2},
}

local defaults = {group=1, recoverType=1, needMaterial={{10010001,100000}}, material={{50040060,1,5000},{50040060,2,5000}}, jiacheng={{1,2,4}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_recovery_out) do
	setmetatable(v, mt)
end

return cfg_recovery_out