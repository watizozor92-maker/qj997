-- 此文件工具自动生成，不要修改
---@class cfg_common_tips_panel_column
---@field id number @唯一id column=1 A
---@field beizhu string @特权备注 column=2 B
---@field condition IntList @特权生效条件 column=3 C
---4:  配置新增格子数
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
---@field para number @参数 column=4 D
---@field text string @界面文本 column=5 E
---@field instructionLeft StringListList @左按钮 column=6 F
---@field instructionRight StringListList @右按钮 column=7 G
local cfg_common_tips_panel =
{
	{id=2, beizhu="随身商店", condition={2102,72}, text="是否开通月卡获得自动买药特权？", instructionLeft={{"传送"},{"transferNPC","100101"}}, instructionRight={{"确定"},{"openUIPanel","dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel"}}},
	{id=3, beizhu="小怪挂机保护"},
	{id=4, beizhu="背包空间增加（需配置参数）", para=10},
	{id=5, beizhu="特权仓库增加（需配置参数）", para=1},
	{id=6, beizhu="自动买药"},
	{id=7, beizhu="切换加点方案"},
	{id=8, beizhu="大师天赋免费切换"},
	{id=9, beizhu="掉落提升（需配置参数）", para=10000},
	{id=10, beizhu="经验提升（需配置参数）"},
	{id=11, beizhu="回收收益提升（需配置参数）", para=10000},
	{id=12, beizhu="巡逻挂机"},
	{id=13, beizhu="随身仓库", condition={2102,72}, text="是否开通月卡获得随身仓库特权？", instructionLeft={{"传送"},{"transferNPC","100107"}}, instructionRight={{"确定"},{"openUIPanel","dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel"}}},
	{id=14, beizhu="交易行寄售货架数量增加（需配置参数）", para=4},
	{id=15, beizhu="掉落经验提升（需配置参数）", para=10000},
	{id=16, beizhu="自动拾取", condition={2102,73}, text="是否开通月卡获得自动拾取特权？", instructionRight={{"确定"},{"openUIPanel","dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel"}}},
	{id=17, beizhu="自动回收", condition={2102,73}, text="是否开通月卡获得自动回收特权？", instructionRight={{"确定"},{"openUIPanel","dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel"}}},
	{id=18, beizhu="交易行上架", condition={2102,73}, text="是否开通月卡获得交易行上架特权？", instructionRight={{"确定"},{"openUIPanel","dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel"}}},
	{id=19, beizhu="连击试炼每日次数增加（具体配在下一个字段）", para=4},
	{id=20, beizhu="连击试炼扫荡功能开启"},
	{id=21, beizhu="调整税率", para=1000},
	{id=22, beizhu="地图切线", condition={2102,73}, text="是否开通月卡获得地图切线特权？", instructionRight={{"确定"},{"openUIPanel","dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel"}}},
	{id=23, beizhu="离线挂机", condition={2102,72}, text="是否开通月卡获得离线挂机特权？", instructionRight={{"确定"},{"openUIPanel","dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel"}}},
	{id=24, beizhu="世界聊天", condition={2102,72}, text="是否开通月卡获得世界聊天特权？", instructionRight={{"确定"},{"openUIPanel","dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel"}}},
	{id=25, beizhu="自动修理", condition={2102,73}, text="是否开通月卡获得自动修理特权？", instructionRight={{"确定"},{"openUIPanel","dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel"}}},
	{id=26, beizhu="黄金地图", condition={2102,73}, text="是否开通月卡获得黄金地图特权？", instructionRight={{"确定"},{"openUIPanel","dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel"}}},
}

local defaults = {condition={}, para=0, text="", instructionLeft={}, instructionRight={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_common_tips_panel) do
	setmetatable(v, mt)
end

return cfg_common_tips_panel