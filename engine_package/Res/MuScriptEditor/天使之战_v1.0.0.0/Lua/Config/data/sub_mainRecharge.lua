-- 此文件工具自动生成，不要修改
---@class sub_mainRecharge_column
---@field id number @id column=1 A
---@field showTogName string @左侧页签需要展示的名称 column=2 B
---@field mainUIPanel string @父界面名称 column=3 C
---找程序要
---@field subUIRoute string @子界面名称 column=4 D
---里的字段对应
---@field togName string @开关 column=5 E
---@field sortId number @页签排序 column=6 F
---@field showCondition string @条件级 column=7 G
---后端控制此功能开关，（目前支持的功能只有）
---[[客户端不使用]]@field inshowCondition string @后端条件级 column=8 H
local sub_mainRecharge =
{
	{id=1, showTogName="每日礼包", subUIRoute="dev/outui/MainRecharge/Panel/KLDailyPackRecharge/KLDailyPackRechargePanel", togName="tog_DailyPack", sortId=1},
	{id=2, showTogName="月卡", subUIRoute="dev/outui/RechargeMonthlycard/Panel/KLUIRechargeMonthlycard/KLUIRechargeMonthlycardPanel", togName="tog_RechargeMonthlycard", sortId=2, showCondition="101#10&901#1"},
	{id=3, showTogName="投资基金", subUIRoute="dev/outui/MainRecharge/Panel/KLInvestmentFund/KLInvestmentFundPanel", togName="tog_Nvestment", sortId=3, showCondition="101#70&901#1"},
	{id=4, showTogName="每周礼包", subUIRoute="dev/outui/MainRecharge/Panel/KLWeekDailyPackRecharge/KLWeekDailyPackRechargePanel", togName="tog_WeekDailyPack", sortId=4},
	{id=5, showTogName="终生礼包", subUIRoute="dev/outui/LifetimeGift/Panel/KLUILifetimeGift/KLUILifetimeGiftPanel", togName="tog_GiftPanel", sortId=5},
	{id=6, showTogName="每日馈赠", subUIRoute="dev/outui/MainRecharge/Panel/KLEveryDayGiftRecharge/KLEveryDayGiftRechargePanel", togName="tog_3", sortId=6},
	{id=7, showTogName="每日累充", subUIRoute="dev/outui/MainRecharge/Panel/KLDailyAddRecharge/KLDailyAddRechargePanel", togName="tog_DailyAddRecharge", sortId=7},
	{id=8, showTogName="每日抽奖", subUIRoute="dev/outui/DailyRaffle/Panel/KLDailyRaffle/KLDailyRafflePanel", togName="tog_6", sortId=8, showCondition="101#50&903#10"},
	{id=9, showTogName="开服连充", subUIRoute="dev/outui/Recharge/Panel/KLRechargeLink/KLRechargeLinkPanel", togName="tog_NewServerRecharge", sortId=9, showCondition="903#7&101#60"},
	{id=10, showTogName="新手礼包", subUIRoute="dev/outui/MainRecharge/Panel/KLNoobPlayerPack/KLNoobPlayerPackPanel", togName="tog_NoobPlayer", sortId=100},
	{id=12, showTogName="超值连领", subUIRoute="dev/outui/MainRecharge/Panel/KLRechargeSevenDayGift/KLRechargeSevenDayGiftPanel", togName="tog_rechargeSevenDayGift", sortId=12},
	{id=13, showTogName="钻石礼包", subUIRoute="dev/outui/MainRecharge/Panel/KLDailyDiamondRecharge/KLDailyDiamondRechargePanel", togName="tog_DailyDiamond", sortId=13, showCondition="101#100&901#1"},
}

local defaults = {mainUIPanel="KLMainRechargePanel", showCondition="101#9999"}
local mt = {__index = defaults}
for _, v in ipairs(sub_mainRecharge) do
	setmetatable(v, mt)
end

return sub_mainRecharge