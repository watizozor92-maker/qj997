-- 此文件工具自动生成，不要修改
---@class cfg_OperateActivity_subActivity_column
---@field id number @唯一ID column=1 A
---页签名称
---@field showTogName string @页签名称 column=2 B
---关联cfg_OperateActivity_all表mainGroupID
---关联主表活动，本期活动开哪几个活动
---@field mainGroup number @ column=3 C
---活动类型
---1.直购
---2.累充
---3.抽奖                                                                                                                                                                                             4.钻石礼包                                                                                                                                                                                         5.消费排行
---@field subType number @活动组 column=4 D
---填cfg_sub_OperateActivity表id
---关联cfg_sub_OperateActivity表
---@field subId number @ column=5 E
---填写活动开启时间
---填写condition表达式
---活动开启的时间条件用971，且只填开启的当天，不填持续几天
---多个填写格式condition1&condition2
---不填=没有此条限制 
---@field openCondition string @开启条件判定 column=6 F
---填写活动持续时间
---填写condition表达式
---持续时间的condition用981
---多个填写格式condition1&condition2
---不填=没有此条限制 
---@field closeCondition string @关闭条件判定 column=7 G
---填非时间的条件表达式
---@field specialCondition string @特殊条件判断 column=8 H
local cfg_OperateActivity_subActivity =
{
	{id=10011, showTogName="跨服直购", mainGroup=1, openCondition="2302#1"},
	{id=10033, subType=3, subId=10013, closeCondition="981#3#3#2"},
	{id=10034, showTogName="周日礼包", closeCondition="981#3#1#2"},
	{id=10035, showTogName="周日累充", subType=2, subId=10012, closeCondition="981#3#2#2"},
	{id=10036, showTogName="钻石礼包", subType=4, subId=10014, closeCondition="981#3#4#2"},
	{id=10037, showTogName="消费排行", subType=5, subId=10015, closeCondition="981#3#5#2"},
	{id=10053, mainGroup=5, subType=3, subId=10013, openCondition="901#22&903#28&991#6", closeCondition="981#5#3#2"},
	{id=10054, showTogName="周日礼包", mainGroup=5, openCondition="901#22&903#28&991#6", closeCondition="981#5#1#2"},
	{id=10055, showTogName="周日累充", mainGroup=5, subType=2, subId=10012, openCondition="901#22&903#28&991#6", closeCondition="981#5#2#2"},
	{id=10056, showTogName="钻石礼包", mainGroup=5, subType=4, subId=10014, openCondition="901#22&903#28&991#6", closeCondition="981#5#4#2"},
	{id=10073, mainGroup=7, subType=3, subId=10013, openCondition="901#36&903#42&991#6", closeCondition="981#7#3#2"},
	{id=10074, showTogName="周日礼包", mainGroup=7, openCondition="901#36&903#42&991#6", closeCondition="981#7#1#2"},
	{id=10075, showTogName="周日累充", mainGroup=7, subType=2, subId=10012, openCondition="901#36&903#42&991#6", closeCondition="981#7#2#2"},
	{id=10076, showTogName="钻石礼包", mainGroup=7, subType=4, subId=10014, openCondition="901#36&903#42&991#6", closeCondition="981#7#4#2"},
	{id=10093, mainGroup=9, subType=3, subId=10013, openCondition="901#50&903#56&991#6", closeCondition="981#9#3#2"},
	{id=10094, showTogName="周日礼包", mainGroup=9, openCondition="901#50&903#56&991#6", closeCondition="981#9#1#2"},
	{id=10095, showTogName="周日累充", mainGroup=9, subType=2, subId=10012, openCondition="901#50&903#56&991#6", closeCondition="981#9#2#2"},
	{id=10096, showTogName="钻石礼包", mainGroup=9, subType=4, subId=10014, openCondition="901#50&903#56&991#6", closeCondition="981#9#4#2"},
	{id=10113, mainGroup=11, subType=3, subId=10013, openCondition="901#64&903#70&991#6", closeCondition="981#11#3#2"},
	{id=10114, showTogName="周日礼包", mainGroup=11, openCondition="901#64&903#70&991#6", closeCondition="981#11#1#2"},
	{id=10115, showTogName="周日累充", mainGroup=11, subType=2, subId=10012, openCondition="901#64&903#70&991#6", closeCondition="981#11#2#2"},
	{id=10116, showTogName="钻石礼包", mainGroup=11, subType=4, subId=10014, openCondition="901#64&903#70&991#6", closeCondition="981#11#4#2"},
	{id=10133, mainGroup=13, subType=3, subId=10013, openCondition="901#78&903#84&991#6", closeCondition="981#13#3#2"},
	{id=10134, showTogName="周日礼包", mainGroup=13, openCondition="901#78&903#84&991#6", closeCondition="981#13#1#2"},
	{id=10135, showTogName="周日累充", mainGroup=13, subType=2, subId=10012, openCondition="901#78&903#84&991#6", closeCondition="981#13#2#2"},
	{id=10136, showTogName="钻石礼包", mainGroup=13, subType=4, subId=10014, openCondition="901#78&903#84&991#6", closeCondition="981#13#4#2"},
	{id=10141, showTogName="合服豪礼", mainGroup=14, openCondition="2402#1", closeCondition="981#14#1#3"},
	{id=10144, showTogName="合服礼包", mainGroup=14, subType=4, subId=10014, openCondition="2402#1", closeCondition="981#14#4#3"},
}

local defaults = {showTogName="好运抽奖", mainGroup=3, subType=1, subId=10011, openCondition="901#8&903#14&991#6", closeCondition="981#1#1#3", specialCondition="101#70"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_OperateActivity_subActivity) do
	setmetatable(v, mt)
end

return cfg_OperateActivity_subActivity