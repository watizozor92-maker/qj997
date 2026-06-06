-- 此文件工具自动生成，不要修改
---@class cfg_recharge_gear_column
---根据同一个页签内的唯一id 顺序排序 ，id越小越靠前
---@field id number @唯一id column=1 A
---[[客户端不使用]]@field text string @策划备注 column=2 B
---1：走服务器时间周期重置逻辑
---2：个人购买后重置，循环重置后奖励字段
---@field type number @规则类型 column=3 C
---@field conditions string @开启条件 column=4 D
---天数#等级
---两者都满足才会显示，不填则无条件
---@field needDayLevel IntList @开启天数及等级 column=5 E
---首次充值赠送的道具
---格式：职业id#道具id#数量|职业id#道具id#数量|职业id#道具id#数量|职业id#道具id#数量
---职业id关联career表
---道具id关联item表
---@field firstReward IntListList @首充奖励 column=6 F
---首充额外奖励再次生成的间隔时间，天数为单位，可配0
---@field resetTime number @首充奖励重置时间 column=7 G
---重置首次充值后，赠送的道具
---格式：职业id#道具id#数量#职业id#道具id#数量|职业id#道具id#数量#职业id#道具id#数量
---职业id关联career表
---道具id关联item表
---@field resetReward IntListList @重置后的首充奖励 column=8 H
---礼包图片，填图片名称
---@field name string @背景图 column=9 I
local cfg_recharge_gear =
{
}
return cfg_recharge_gear