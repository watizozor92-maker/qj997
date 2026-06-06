-- 此文件工具自动生成，不要修改
---@class cfg_OperateActivity_all_column
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
local cfg_OperateActivity_all =
{
	{id=101001, des="【跨服】跨服活动第1期", mainGroup=1, showIcon="button_kfhd", priority=2, openCondition="2302#1", showTitle="跨服活动", showType=1},
	{id=101014, des="【合服】合服活动第1期", mainGroup=14, showIcon="button_hfhd", priority=3, openCondition="2402#1", closeCondition="980#14#3", showTitle="合服活动", showType=1},
}

local defaults = {closeCondition="980#1#3"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_OperateActivity_all) do
	setmetatable(v, mt)
end

return cfg_OperateActivity_all