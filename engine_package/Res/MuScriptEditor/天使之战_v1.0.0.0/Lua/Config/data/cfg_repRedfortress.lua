-- 此文件工具自动生成，不要修改
---@class cfg_repRedfortress_column
---@field id number @id column=1 A
---@field name string @活动名称 column=2 B
---@field repId number @副本ID column=3 C
---地图中容纳单位的最大数量
---
---活动开始生成怪物数量=本字段值-玩家数量
---@field maxUnit number @地图中单位最大数量 column=4 D
---活动内生成的怪物
---格式：怪物id#怪物id#怪物id
---对应职业外表为 职业1#职业2#职业3 以此类推
---@field monsterId IntList @怪物id column=5 E
---用于各职业进入的伪装的模型外表
---格式：怪物id#怪物id#怪物id
---对应职业外表为 职业1#职业2#职业3 以此类推
---@field transfiguration IntList @变身怪物ID column=6 F
---击杀角色获得积分#击杀怪物获得积分
---@field points IntList @获得积分 column=7 G
---玩家与怪物死亡后的复活次数
---@field rebornChance number @复活次数 column=8 H
---玩家与怪物死亡后的复活时间（单位：秒）
---@field rebornTime number @复活时间 column=9 I
---填写cfg_buff表id，玩家死亡复活后，自动获得该buff
---@field buff number @复活后获得buff column=10 J
---进入副本后，再该位置进行准备停留
---x1,x2,y1,y2
---@field ready IntList @准备区 column=11 K
---初次进入战斗区域时，传送的位置
---x1,x2,y1,y2
---@field start IntList @初始战斗区域 column=12 L
---减少条件#减少量|减少条件#减少量
---减少条件：玩家和怪物总数量
---减少量：与正常地图大小对比，长宽减少的百分比
---例：70#30|50#20|30#10为剩70人时地图长宽减少30%，剩50人时再减少原地图长宽大小的20%，剩30人时再减少原地图长宽大小的10%
---
---注：减少量的数值加起来不可超过100
---@field mapCut IntListList @地图减少 column=13 M
---和地图减少一一对应，减少时，提前X秒进行预警。
---@field warning IntList @地图减少预计时间 column=14 N
---获得奖励的普通掉落包
---格式：名次上限#名次上限#道具id#道具数量#道具id#道具数量|
---道具id引用cfg_item表id
---@field reward IntListList @活动奖励 column=15 O

local local_monsterId = {
    monsterId_1={17009001,17009002,17009003,17009001,17009001,17009002},

}

local local_transfiguration = {
    transfiguration_1={44001,44002,44003,44001,44001,44002,44002},

}

local local_points = {
    points_1={5,1},

}

local local_ready = {
    ready_1={100,146,162,196},

}

local local_start = {
    start_1={193,219,78,115},

}

local local_mapCut = {
    mapCut_1={{50,30},{35,20},{15,10}},

}

local local_warning = {
    warning_1={5,5,5},

}

local local_reward = {
    reward_1={{1,1,2100101,10},{2,2,2100101,8},{3,3,2100101,6},{4,5,2100101,4},{6,10,2100101,3},{11,20,2100101,2},{21,50,2100101,1},{51,999,10010002,10000}},

}

local cfg_repRedfortress =
{
	{id=17001, repId=17001, monsterId={17001001,17001002,17001003,17001001,17001001,17001002}},
	{id=17002, repId=17002, monsterId={17002001,17002002,17002003,17002001,17002001,17002002}},
	{id=17003, repId=17003, monsterId={17003001,17003002,17003003,17003001,17003001,17003002}},
	{id=17004, repId=17004, monsterId={17004001,17004002,17004003,17004001,17004001,17004002}},
	{id=17005, repId=17005, monsterId={17005001,17005002,17005003,17005001,17005001,17005002}},
	{id=17006, repId=17006, monsterId={17006001,17006002,17006003,17006001,17006001,17006002}},
	{id=17007, repId=17007, monsterId={17007001,17007002,17007003,17007001,17007001,17007002}},
	{id=17008, repId=17008, monsterId={17008001,17008002,17008003,17008001,17008001,17008002}},
	{id=17009, repId=17009},
	{id=17010, repId=17010},
	{id=17011, repId=17011},
	{id=17012, repId=17012},
	{id=17013, repId=17013},
	{id=17014, repId=17014},
	{id=17015, repId=17015},
	{id=17016, repId=17016},
	{id=17017, repId=17017},
	{id=17018, repId=17018},
	{id=17019, repId=17019},
}

local defaults = {name="赤色要塞", maxUnit=100, monsterId={17009001,17009002,17009003,17009001,17009001,17009002}, transfiguration={44001,44002,44003,44001,44001,44002,44002}, points={5,1}, rebornChance=3, rebornTime=5, buff=56, ready={100,146,162,196}, start={193,219,78,115}, mapCut={{50,30},{35,20},{15,10}}, warning={5,5,5}, reward={{1,1,2100101,10},{2,2,2100101,8},{3,3,2100101,6},{4,5,2100101,4},{6,10,2100101,3},{11,20,2100101,2},{21,50,2100101,1},{51,999,10010002,10000}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_repRedfortress) do
	setmetatable(v, mt)
end

return cfg_repRedfortress