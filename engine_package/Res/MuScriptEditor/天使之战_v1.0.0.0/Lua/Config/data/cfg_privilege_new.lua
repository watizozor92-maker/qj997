-- 此文件工具自动生成，不要修改
---@class cfg_privilege_new_column
---@field id number @唯一id column=1 A
---@field beizhu string @特权备注 column=2 B
---1、配置外置condition
---2、特权卡无需配置条件，cfg_privilege表配置特权id即可
---@field condition IntList @特权生效条件 column=3 C
---配置1特权过期是否再次校验生效条件，满足时再次开通
---配空或0，特权过期后不再次校验
---@field reopen number @能否多开 column=4 D
---4:  配置新增格子数
---    格子数必须是列的整数倍
---5： 仓库增加页数
---11：回收收益提升（百分比）
---9： att_info att_special 
---    引用属性值#万分比数值
---    掉落加成为累加型特权 
---10：属性id#万分比,经验加成覆盖型特权
---14：寄售货架增加数量
---15：掉落经验提升
---    (这个显示效果在一起
---     配置上9和10必须配一样的)
---19：连击试炼每日次数增加
---21：配置后交易税率读此数值，万分比
---
---
---@field para IntList @参数 column=5 E
---buff增益效果的持续时间填
---格式:单位（分钟）
---填空表示永久生效
---@field time number @特权时间 column=6 F
---@field text string @界面文本 column=7 G
---@field instructionLeft StringListList @左按钮 column=8 H
---@field instructionRight StringListList @右按钮 column=9 I

local local_condition = {
    condition_1={},

}

local local_para = {
    para_1={},

}

local local_instructionLeft = {
    instructionLeft_1={},

}

local local_instructionRight = {
    instructionRight_1={{"确定","btn_sure","FG_Common"},{"openUIPanel","dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel"}},

}

local cfg_privilege_new =
{
	{id=2, beizhu="随身商店", text="是否开通月卡获得随身商店特权？", instructionLeft={{"传送","btn_chuansong","FG_Common"},{"transferNPC","100101"}}},
	{id=3, beizhu="小怪挂机保护"},
	{id=4, beizhu="背包空间增加（需配置参数）"},
	{id=5, beizhu="特权仓库增加（需配置参数）"},
	{id=6, beizhu="自动买药"},
	{id=9, beizhu="掉落提升（需配置参数）"},
	{id=10, beizhu="经验提升（需配置参数）"},
	{id=13, beizhu="随身仓库", text="是否开通月卡获得随身仓库特权？", instructionLeft={{"传送","btn_chuansong","FG_Common"},{"transferNPC","100107"}}},
	{id=14, beizhu="交易行寄售货架数量增加（需配置参数）"},
	{id=16, beizhu="自动拾取", text="是否开通月卡获得自动拾取特权？"},
	{id=17, beizhu="自动回收", text="是否开通月卡获得自动回收特权？"},
	{id=18, beizhu="交易行上架", text="是否开通月卡获得交易行上架特权？"},
	{id=21, beizhu="调整税率"},
	{id=22, beizhu="地图切线", condition={101,1}, time=0, text="是否开通月卡获得地图切线特权？"},
	{id=23, beizhu="离线挂机", text="是否开通月卡获得离线挂机特权？"},
	{id=24, beizhu="世界聊天", text="是否开通月卡获得世界聊天特权？"},
	{id=25, beizhu="自动修理", text="是否开通月卡获得自动维修特权？"},
	{id=27, beizhu="黄金分线", text="是否开通月卡获得黄金分线特权？"},
	{id=28, beizhu="面对面交易", text="是否开通月卡获得面对面交易特权？"},
}

local defaults = {condition={}, reopen=1, para={}, time=43200, text="是否开通月卡获得特权？", instructionLeft={}, instructionRight={{"确定","btn_sure","FG_Common"},{"openUIPanel","dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel"}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_privilege_new) do
	setmetatable(v, mt)
end

return cfg_privilege_new