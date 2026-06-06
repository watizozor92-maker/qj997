-- 此文件工具自动生成，不要修改
---@class cfg_monster_attack_column
---引用monster表ID，决定刷哪只怪物
---@field id number @唯一id column=1 A
---1火龙来袭
---2黄金部队
---3魔王昆顿
---@field type number @类型 column=2 B
---策划备注
---@field monid number @怪物id column=3 C
---@field name string @名称 column=4 D
---@field line IntListList @地图线路ID column=5 E
---怪物的刷新条件，根据condition条件表来填，不配则没有条件，活动开启即刷
---@field condition number @生成条件 column=6 F
---引用map_info表ID，决定怪物的刷新地图
---@field mapid number @地图id column=7 G
---怪物的刷新坐标，格式为x#y
---@field poz IntList @坐标 column=8 H
---怪物刷新的随机范围，以poz配置为点位，随机range配置的范围
---@field range number @范围 column=9 I
---填写cfg_activity_rule表的id ，关联哪个活动刷新
---@field ruleId number @活动id column=10 J
---怪物在死亡后，头像在地图上消失的时间（如配5，即代表在怪物死亡5s后，头像消失）
---@field headPicture number @头像消失时间 column=11 K
---怪物在地图中显示的头像图片资源配置
---@field safeTime number @脱战安全时间 column=12 L

local local_line = {
    line_1={{3}},
    line_2={{2}},

}

local cfg_monster_attack =
{
	{id=201, monid=200001, name="黄金暗黑骑士", line={{3,4}}, mapid=1002, poz={117,180}},
	{id=202, monid=200002, name="黄金恶魔", line=local_line.line_1, mapid=1005, poz={228,90}},
	{id=203, monid=200003, name="黄金巫师王", line=local_line.line_1, mapid=1008, poz={96,61}},
	{id=204, monid=200004, name="黄金破坏骑士", line=local_line.line_1, mapid=1009, poz={113,215}},
	{id=205, monid=200005, name="黄金石巨人", line=local_line.line_1, mapid=1034, poz={129,89}},
	{id=206, monid=200006, name="黄金恶灵", mapid=1011, poz={49,143}},
	{id=207, monid=200007, name="黄金半兽人", mapid=1038, poz={235,96}},
	{id=208, monid=200008, name="黄金独步妖", mapid=1039, poz={108,154}},
	{id=209, monid=200009, name="黄金剑魂", mapid=1058, poz={133,181}},
	{id=210, monid=200010, name="黄金巨人", mapid=1057, poz={200,198}},
	{id=301, type=3, monid=23008, name="魔王昆顿", line={{1}}, mapid=1025, poz={38,78}, ruleId=27001},
}

local defaults = {type=2, line={{2}}, condition=0, range=2, ruleId=13001, headPicture=10, safeTime=30}
local mt = {__index = defaults}
for _, v in ipairs(cfg_monster_attack) do
	setmetatable(v, mt)
end

return cfg_monster_attack