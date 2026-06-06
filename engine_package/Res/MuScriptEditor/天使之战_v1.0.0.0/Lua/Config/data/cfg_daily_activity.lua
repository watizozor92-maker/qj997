-- 此文件工具自动生成，不要修改
---@class cfg_daily_activity_column
---@field id number @id column=1 A
---此处只写文件名字，不含后缀
---@field icon string @活动图标 column=2 B
---活动名称
---显示在日常活动界面上
---@field name string @活动名称 column=3 C
---对应每次活动可获得的活跃度
---@field activity number @活跃度 column=4 D
---可获得的活跃度的次数次数
---@field timeMax number @活跃度获得次数 column=5 E
---活动界面UI排序，id小的在前
---@field rank number @排序 column=6 F
---达到特定条件的时候显示活动
---格式：读取cfg_conditions表
---@field showConditions string @活动显影条件 column=7 G
---达到特定条件的时候开放
---格式：读取cfg_conditions表
---@field conditions string @活动前往条件 column=8 H
---@field conditionsText string @条件提示文本 column=9 I
---引用cfg_task_target表id
---@field target number @活动目标 column=10 J
---当活跃度满时，是否显示已完成。
---填1=显示已完成，
---填0=继续使用前往按钮
---@field Done number @是否显示已完成 column=11 K
---0、常规活动
---1、限时活动
---常规活动则显示次数，限时活动显示时间
---2、找回活动
---@field type number @活动类型 column=12 L
---每日必做与今日活动的展示界面
---0、每日必做展示
---1、今日活动展示
---2、不展示
---@field displayInterface number @活动展示界面 column=13 M
---1 ：可根据次数上限计算找回次数
---2：恒定次数
---备注:用于找回功能中区分
---@field timeType number @找回次数类型 column=14 N
---引用item表的道具id
---道具id
---@field addItem number @次数增加道具 column=15 O
---@field explain string @活动描述 column=16 P
---引用item表道具id
---会员次数使用的道具id#道具数量
---道具id为0表示空
---@field item IntList @会员新增次数 column=17 Q
---引用cfg_vipSystem表会员id
---格式：
---会员id#购买次数|会员id#购买次数
---次数累加
---@field vipBuyTime IntListList @会员消耗道具新增次数新增购买次数 column=18 R

local local_item = {
    item_1={},

}

local local_vipBuyTime = {
    vipBuyTime_1={},

}

local cfg_daily_activity =
{
	{id=1, name="击杀一次<color=#00FF00>黄金怪</color>", activity=2, timeMax=30, rank=1, target=1230001},
	{id=2, name="击杀一次<color=#00FF00>野外BOSS</color>", activity=6, timeMax=10, rank=2, target=1230002},
	{id=3, name="击杀一次<color=#00FF00>秘境BOSS</color>", activity=5, timeMax=4, rank=3, target=1200002},
	{id=4, name="完成一次<color=#00FF00>血色城堡</color>", timeMax=6, rank=4, target=1043001},
	{id=5, name="完成一次<color=#00FF00>恶魔广场</color>", timeMax=6, rank=5, target=1043002},
	{id=6, name="完成一次<color=#00FF00>勇气试炼</color>", timeMax=1, rank=6, target=3000002},
	{id=7, name="完成一次<color=#00FF00>黄金挑战</color>", timeMax=4, rank=7, target=3000001},
	{id=8, name="完成一次<color=#00FF00>连击副本</color>", activity=5, timeMax=6, rank=8, target=1043004},
}

local defaults = {icon="img_activity_12", activity=10, showConditions="", conditions="", conditionsText="", Done=1, type=0, displayInterface=0, timeType=0, addItem=0, explain="", item={}, vipBuyTime={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_daily_activity) do
	setmetatable(v, mt)
end

return cfg_daily_activity