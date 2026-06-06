-- 此文件工具自动生成，不要修改
---@class cfg_activity_angelWeapon_column
---小任务101起
---大奖任务10001起
---@field id number @唯一id column=1 A
---排序
---@field sortId number @排序 column=2 B
---1.穿戴任务
---2.大奖任务
---@field angelWeaponType number @任务类型 column=3 C
---@field angelWeaponTaskgroup number @任务组 column=4 D
---关联career表id
---@field career number @职业 column=5 E
---满足时显示已完成
---道具id#数量|道具id#数量，穿戴在身上后计数
---@field angelWeaponTask IntListList @任务条件 column=6 F
---道具id#数量|道具id#数量
---@field angelWeaponReward IntListList @奖励 column=7 G

local local_angelWeaponTask = {
    angelWeaponTask_1={{21100031,1}},
    angelWeaponTask_2={{21100041,1}},
    angelWeaponTask_3={{21100051,1}},
    angelWeaponTask_4={{21000021,1},{21200121,1}},
    angelWeaponTask_5={{21000051,1},{21200121,1}},
    angelWeaponTask_6={},
    angelWeaponTask_7={{21000071,1},{21200121,1}},

}

local local_angelWeaponReward = {
    angelWeaponReward_1={{10020001,100}},
    angelWeaponReward_2={{10020001,10000}},

}

local cfg_activity_angelWeapon =
{
	{id=1001, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_1},
	{id=1002, sortId=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_2},
	{id=1003, sortId=3, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_3},
	{id=1004, sortId=4},
	{id=1005, sortId=5, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_5},
	{id=1006, sortId=6, angelWeaponTask={{21000021,1},{21100031,2},{21200121,2}}},
	{id=1099, sortId=7, angelWeaponType=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_6},
	{id=2001, career=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_1},
	{id=2002, sortId=2, career=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_2},
	{id=2003, sortId=3, career=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_3},
	{id=2004, sortId=4, career=2},
	{id=2005, sortId=5, career=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_5},
	{id=2006, sortId=6, career=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_7},
	{id=2099, sortId=7, angelWeaponType=2, career=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_6},
	{id=3001, career=3, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_1},
	{id=3002, sortId=2, career=3, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_2},
	{id=3003, sortId=3, career=3, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_3},
	{id=3004, sortId=4, career=3},
	{id=3005, sortId=5, career=3, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_5},
	{id=3006, sortId=6, career=3, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_7},
	{id=3099, sortId=7, angelWeaponType=2, career=3, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_6, angelWeaponReward=local_angelWeaponReward.angelWeaponReward_2},
	{id=1201, angelWeaponTaskgroup=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_1},
	{id=1202, sortId=2, angelWeaponTaskgroup=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_2},
	{id=1203, sortId=3, angelWeaponTaskgroup=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_3},
	{id=1204, sortId=4, angelWeaponTaskgroup=2},
	{id=1205, sortId=5, angelWeaponTaskgroup=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_5},
	{id=1206, sortId=6, angelWeaponTaskgroup=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_7},
	{id=1299, sortId=7, angelWeaponType=2, angelWeaponTaskgroup=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_6},
	{id=2201, angelWeaponTaskgroup=2, career=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_1},
	{id=2202, sortId=2, angelWeaponTaskgroup=2, career=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_2},
	{id=2203, sortId=3, angelWeaponTaskgroup=2, career=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_3},
	{id=2204, sortId=4, angelWeaponTaskgroup=2, career=2},
	{id=2205, sortId=5, angelWeaponTaskgroup=2, career=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_5},
	{id=2206, sortId=6, angelWeaponTaskgroup=2, career=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_7},
	{id=2299, sortId=7, angelWeaponType=2, angelWeaponTaskgroup=2, career=2, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_6},
	{id=3201, angelWeaponTaskgroup=2, career=3, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_1},
	{id=3202, sortId=2, angelWeaponTaskgroup=2, career=3, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_2},
	{id=3203, sortId=3, angelWeaponTaskgroup=2, career=3, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_3},
	{id=3204, sortId=4, angelWeaponTaskgroup=2, career=3},
	{id=3205, sortId=5, angelWeaponTaskgroup=2, career=3, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_5},
	{id=3206, sortId=6, angelWeaponTaskgroup=2, career=3, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_7},
	{id=3299, sortId=7, angelWeaponType=2, angelWeaponTaskgroup=2, career=3, angelWeaponTask=local_angelWeaponTask.angelWeaponTask_6, angelWeaponReward=local_angelWeaponReward.angelWeaponReward_2},
}

local defaults = {sortId=1, angelWeaponType=1, angelWeaponTaskgroup=1, career=1, angelWeaponTask={{21000021,1},{21200121,1}}, angelWeaponReward={{10020001,100}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_activity_angelWeapon) do
	setmetatable(v, mt)
end

return cfg_activity_angelWeapon