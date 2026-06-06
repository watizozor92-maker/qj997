-- 此文件工具自动生成，不要修改
---@class cfg_sub_OperateActivity_column
---@field id number @唯一ID column=1 A
---功能名称
---@field showTogName string @功能名称 column=2 B
---@field sortId number @页签排序 column=3 C
---关联的 cfg_OperateActivity_subActivity里的subType
---@field subType number @活动类型 column=4 D
---策划命名，程序做红点用
---@field togName string @页签开关路径 column=5 E
---@field mainUIPanel string @主页面路径 column=6 F
---@field subUIRoute string @子功能表页面路径 column=7 G
local cfg_sub_OperateActivity =
{
	{id=10011, showTogName="直购", sortId=1, subType=1, togName="tog_Directpurchase", subUIRoute="dev/outui/RunActive_RechargeDirect/Panel/KLUIRechargeDirect/KLUIRechargeDirectPanel"},
	{id=10012, showTogName="累充", sortId=2, subType=2, togName="tog_Accumulation", subUIRoute="dev/outui/MainOperateActivity/Panel/KLMainOperateAddRecharge/KLMainOperateAddRechargePanel"},
	{id=10013, showTogName="抽奖", sortId=3, subType=3, togName="tog_lottery", subUIRoute="dev/outui/OperateActivity/Panel/KLLuckyTurnTable/KLLuckyTurnTablePanel"},
	{id=10014, showTogName="钻石礼包", sortId=4, subType=4, togName="tog_Diamond", subUIRoute="dev/outui/OperateActivity/Panel/KLOperateDiamondRecharge/KLOperateDiamondRechargePanel"},
	{id=10015, showTogName="消费排行", sortId=5, subType=5, togName="tog_Rank", subUIRoute="dev/outui/ConsumerRanking/Panel/KLUIConsumerRanking/KLUIConsumerRankingPanel"},
}

local defaults = {mainUIPanel="KLMainOperateActivityPanel"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_sub_OperateActivity) do
	setmetatable(v, mt)
end

return cfg_sub_OperateActivity