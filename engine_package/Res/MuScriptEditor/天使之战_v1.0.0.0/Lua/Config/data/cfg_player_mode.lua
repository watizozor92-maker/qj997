-- 此文件工具自动生成，不要修改
---@class cfg_player_mode_column
---模式id：
---1和平
---4组队
---5战盟
---10掠夺
---@field id number @模式id column=1 A
---地图内不可开启该模式
---格式：地图id#地图id#地图id#地图#地图id#地图id#
---0或不填为无禁止地图
---@field mapForbidden IntList @禁止该模式地图 column=2 B
---格式：副本id （引援cfg_avtivity_rule 中id）
---备注：副本的优先级高于地图 即：若血色城堡副本中 所在地图 没有禁止该模式，但该副本玩法禁止该模式，则在该地图中该模式禁止
---0或不填为无禁止副本
---@field activityRule IntList @禁止该模式副本 column=3 C
---该模式下反击时间，填空或0表示不反击
---格式：x天#x时#x分#x秒#毫秒
---@field counterattackTime IntList @反击时间 column=4 D

local local_mapForbidden = {
    mapForbidden_1={},

}

local local_activityRule = {
    activityRule_1={},

}

local local_counterattackTime = {
    counterattackTime_1={},

}

local cfg_player_mode =
{
	{id=1, mapForbidden=local_mapForbidden.mapForbidden_1, activityRule=local_activityRule.activityRule_1, counterattackTime=local_counterattackTime.counterattackTime_1},
	{id=4, mapForbidden=local_mapForbidden.mapForbidden_1, activityRule=local_activityRule.activityRule_1, counterattackTime=local_counterattackTime.counterattackTime_1},
	{id=5, mapForbidden={1012}, activityRule={2}, counterattackTime=local_counterattackTime.counterattackTime_1},
}
return cfg_player_mode