-- 此文件工具自动生成，不要修改
---@class cfg_OperateActivity_week_column
---根据活动类型分组
---【常规活动】100000+1000（类型：每1000递增）+1（期数）
---【节日活动】200000+1000（类型：每1000递增）+1（期数）
---
---@field id number @唯一ID column=1 A
---无意义，策划自己用来自己备忘
---@field des string @备注 column=2 B
---程序好取数据
---@field mainGroup number @类型 column=3 C
---图标名称
---
---@field showIcon string @活动图标 column=4 D
---数字越大，优先级越高
---@field priority number @优先级 column=5 E
---
---填写condition时间相关的表达式
---实际开启时间的条件用971
---多个填写格式condition1&condition2
---不填=没有此条限制 
---@field openCondition string @开启条件判定 column=6 F
---填写主活动持续时间
---填写condition表达式
---持续时间的条件用980
---多个填写格式condition1&condition2
---不填=没有此条限制 
---@field closeCondition string @关闭条件判定 column=7 G
---标题名
---@field showTitle string @ column=8 H
---活动类型
---1=特殊活动（跨服、合服）
---0=周末
---@field showType number @ column=9 I
local cfg_OperateActivity_week =
{
	{id=101003, des="【周末】周末活动第2期", mainGroup=3},
	{id=101005, des="【周末】周末活动第4期", mainGroup=5, openCondition="901#22&903#28&991#6", closeCondition="980#5#2"},
	{id=101007, des="【周末】周末活动第6期", mainGroup=7, openCondition="901#36&903#42&991#6", closeCondition="980#7#2"},
	{id=101009, des="【周末】周末活动第8期", mainGroup=9, openCondition="901#50&903#56&991#6", closeCondition="980#9#2"},
	{id=101011, des="【周末】周末活动第10期", mainGroup=11, openCondition="901#64&903#70&991#6", closeCondition="980#11#2"},
	{id=101013, des="【周末】周末活动第12期", mainGroup=13, openCondition="901#78&903#84&991#6", closeCondition="980#13#2"},
}

local defaults = {showIcon="button_zmhd", priority=1, openCondition="901#8&903#14&991#6", closeCondition="980#3#2", showTitle="好运周末", showType=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_OperateActivity_week) do
	setmetatable(v, mt)
end

return cfg_OperateActivity_week