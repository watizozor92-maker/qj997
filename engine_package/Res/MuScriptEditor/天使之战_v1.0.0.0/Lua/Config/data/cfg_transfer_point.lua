-- 此文件工具自动生成，不要修改
---@class cfg_transfer_point_column
---@field id number @编号id column=1 A
---[所在地图]
---@field mapId number @所在地图 column=2 B
---传送点名称[传送点名称]
---@field name string @名称 column=3 C
---此表为使用传送功能或传送道具，传送后到达的坐标[使用传送功能或传送道具，传送后到达的坐标]
---@field desc string @备注 column=4 D
---[检测等级]
---@field condition string @传送条件 column=5 E
---[位置]
---@field position IntList @位置 column=6 F
---传送点半径[传送点半径]
---@field param number @参数 column=7 G
---传送点的特效路径[传送点的特效路径]
---@field sfx number @特效 column=8 H
---传送点的特效偏移
---格式:X#Y#Z
---@field sfxOffset IntList @特效偏移 column=9 I
---传送点的特效旋转
---格式:X#Y#Z
---@field sfxRotation IntList @特效旋转角度 column=10 J
---传送到哪个地图[传送到某个地图]
---@field targetId number @目标编号 column=11 K
---[无备注]
---@field targetPosition IntList @目标位置 column=12 L
---传送点半径[传送点半径]
---@field targetParam number @目标参数 column=13 M

local local_position = {
    position_1={57,176},
    position_2={124,109},
    position_3={68,52},
    position_4={139,95},
    position_5={197,13},
    position_6={149,109},
    position_7={185,187},
    position_8={139,125},
    position_9={160,204},
    position_10={94,242},

}

local local_sfxOffset = {
    sfxOffset_1={0,0.5,0},
    sfxOffset_2={},
    sfxOffset_3={1,0.5,-1.5},
    sfxOffset_4={2,1,0},

}

local local_sfxRotation = {
    sfxRotation_1={},
    sfxRotation_2={0,-90,0},
    sfxRotation_3={0,90,0},
    sfxRotation_4={0,120,0},
    sfxRotation_5={0,-80,0},

}

local local_targetPosition = {
    targetPosition_1={138,109},
    targetPosition_2={64,177},
    targetPosition_3={66,46},
    targetPosition_4={204,12},
    targetPosition_5={191,191},
    targetPosition_6={94,237},
    targetPosition_7={167,204},

}

local cfg_transfer_point =
{
	{id=103102, mapId=1031, name="罗兰峡谷", desc="从罗兰峡谷到罗兰峡谷", sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1031, targetPosition=local_targetPosition.targetPosition_6},
	{id=103101, mapId=1031, name="罗兰峡谷", desc="从罗兰峡谷到罗兰峡谷", position=local_position.position_10, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1031, targetPosition=local_targetPosition.targetPosition_7},
	{id=100401, mapId=1004, name="勇者大陆", desc="从仙踪林到勇者大陆", position={151,3}, sfxOffset={3.5,0.5,0}, sfxRotation=local_sfxRotation.sfxRotation_2, targetId=1001, targetPosition={216,241}},
	{id=100301, mapId=1003, name="勇者大陆", desc="从冰风谷到勇者大陆", position={244,35}, sfxOffset={0,1,0}, sfxRotation=local_sfxRotation.sfxRotation_2, targetId=1001, targetPosition={10,39}},
	{id=100201, mapId=1002, name="勇者大陆", desc="从地下城到勇者大陆", position={108,248}, sfxOffset=local_sfxOffset.sfxOffset_3, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1001, targetPosition={122,229}},
	{id=101304, mapId=10013, name="战盟BOSS5层", desc="战盟BOSS4层到战盟BOSS5层", position={187,187}, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=10013, targetPosition={76,174}},
	{id=101303, mapId=10013, name="战盟BOSS4层", desc="战盟BOSS3层到战盟BOSS4层", position={239,96}, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=10013, targetPosition={183,174}},
	{id=101302, mapId=10013, name="战盟BOSS3层", desc="战盟BOSS2层到战盟BOSS3层", position={133,96}, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=10013, targetPosition={236,82}},
	{id=101301, mapId=10013, name="战盟BOSS2层", desc="战盟BOSS1层到战盟BOSS2层", position={18,95}, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=10013, targetPosition={131,81}},
	{id=103401, mapId=1034, name="仙踪林", desc="从幽暗森林到仙踪林", condition="checkLevel>=1", position={74,11}, sfxRotation=local_sfxRotation.sfxRotation_4, targetId=1004, targetPosition={222,33}},
	{id=100801, mapId=1008, name="仙踪林", desc="从亚特兰蒂斯1到仙踪林", condition="checkLevel>=1", position={10,10}, targetId=1004, targetPosition={237,241}},
	{id=100103, mapId=1001, name="仙踪林", desc="从勇者大陆到仙踪林", condition="checkLevel>=1", position={215,246}, sfxOffset={1,1,-1.5}, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1004, targetPosition={152,8}},
	{id=105201, mapId=1052, name="冰风谷", desc="从幻术园到冰风谷", condition="checkLevel>=20", position={24,29}, sfx=0, sfxOffset=local_sfxOffset.sfxOffset_2, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1003, targetPosition={162,241}},
	{id=100507, mapId=1005, name="冰风谷", desc="从失落之塔到冰风谷", condition="checkLevel>=20", position={164,0}, sfxOffset={1,0.5,0}, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1003, targetPosition={6,246}},
	{id=100102, mapId=1001, name="冰风谷", desc="从勇者大陆到冰风谷", condition="checkLevel>=20", position={5,39}, targetId=1003, targetPosition={238,36}},
	{id=103801, mapId=1038, name="死亡沙漠", desc="从坎特鲁废墟到死亡沙漠", condition="checkLevel>=130", position={18,221}, sfxRotation={0,160,0}, targetId=1009, targetPosition={11,200}},
	{id=100802, mapId=1008, name="死亡沙漠", desc="从亚特兰蒂斯1到死亡沙漠", condition="checkLevel>=130", position={14,227}, sfxOffset={0,1.5,-1}, sfxRotation=local_sfxRotation.sfxRotation_4, targetId=1009, targetPosition={241,43}},
	{id=100403, mapId=1004, name="幽暗森林", desc="从仙踪林到幽暗森林", condition="checkLevel>=170", position={223,30}, sfx=0, sfxOffset=local_sfxOffset.sfxOffset_2, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1034, targetPosition={78,10}},
	{id=103901, mapId=1039, name="坎特鲁废墟", desc="从坎特鲁遗址到坎特鲁废墟", condition="checkLevel>=250", position={69,105}, sfxRotation={0,110,0}, targetId=1038, targetPosition={82,91}},
	{id=100902, mapId=1009, name="坎特鲁废墟", desc="从死亡沙漠到坎特鲁废墟", condition="checkLevel>=250", position={6,200}, sfxOffset={0,0.5,-2}, targetId=1038, targetPosition={20,218}},
	{id=103802, mapId=1038, name="坎特鲁遗址", desc="从坎特鲁废墟到坎特鲁遗址", condition="checkLevel>=290", position={89,90}, sfxRotation=local_sfxRotation.sfxRotation_5, targetId=1039, targetPosition={74,106}},
	{id=100206, mapId=1102, name="地下城3", desc="从地下城2到地下城3", condition="checkLevel>=30", position={5,33}, sfxOffset=local_sfxOffset.sfxOffset_3, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1202, targetPosition={29,119}},
	{id=100204, mapId=1102, name="地下城3", desc="从地下城2到地下城3", condition="checkLevel>=30", position={2,17}, targetId=1202, targetPosition={7,85}},
	{id=100203, mapId=1102, name="地下城1", desc="从地下城2到地下城1", condition="checkLevel>=30", position={232,128}, sfxOffset=local_sfxOffset.sfxOffset_3, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1002, targetPosition={243,149}},
	{id=100202, mapId=1002, name="地下城2", desc="从地下城1到地下城2", condition="checkLevel>=30", position={239,149}, targetId=1102, targetPosition={233,123}},
	{id=100101, mapId=1001, name="地下城", desc="从勇者大陆到地下城", condition="checkLevel>=30", position={122,232}, sfxOffset={0.5,0.5,-2}, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1002, targetPosition={110,245}},
	{id=100208, mapId=1202, name="地下城2", desc="从地下城3到地下城2", condition="checkLevel>=30", position={2,85}, sfxOffset={0,0.5,-1}, targetId=1102, targetPosition={7,18}},
	{id=100207, mapId=1202, name="地下城2", desc="从地下城3到地下城2", condition="checkLevel>=30", position={29,127}, sfxOffset={1,0.5,-2.5}, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1102, targetPosition={8,28}},
	{id=100304, mapId=1003, name="冰霜之城", desc="从冰风谷到冰霜之城", condition="checkLevel>=330", position={53,92}, sfx=0, sfxOffset=local_sfxOffset.sfxOffset_2, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1058, targetPosition={224,209}},
	{id=105708, desc="从安宁池上岛到安宁池左上", condition="checkLevel>=370", position=local_position.position_1},
	{id=105707, desc="从安宁池左上到安宁池上岛", condition="checkLevel>=370", position=local_position.position_2, targetPosition=local_targetPosition.targetPosition_2},
	{id=105706, desc="从安宁池左岛到安宁池左上", condition="checkLevel>=370", position=local_position.position_3, sfxOffset=local_sfxOffset.sfxOffset_4, sfxRotation={0,-120,0}},
	{id=105705, desc="从安宁池左下到安宁池左岛", condition="checkLevel>=370", position=local_position.position_4, sfxOffset={2,0.5,-1.5}, sfxRotation=local_sfxRotation.sfxRotation_1, targetPosition=local_targetPosition.targetPosition_3},
	{id=105704, desc="从安宁池下岛到安宁池右下", condition="checkLevel>=370", position=local_position.position_5},
	{id=105703, desc="从安宁池右下到安宁池下岛", condition="checkLevel>=370", position=local_position.position_6, sfxOffset=local_sfxOffset.sfxOffset_4, sfxRotation=local_sfxRotation.sfxRotation_2, targetPosition=local_targetPosition.targetPosition_4},
	{id=105702, desc="从安宁池右岛到安宁池右上", condition="checkLevel>=370", position=local_position.position_7, sfxRotation={0,60,0}},
	{id=105701, desc="从安宁池右上到安宁池右岛", condition="checkLevel>=370", position=local_position.position_8, sfxRotation={0,180,0}, targetPosition=local_targetPosition.targetPosition_5},
	{id=115708, mapId=1157, name="黄金安宁池", condition="checkLevel>=350", position=local_position.position_1, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1157},
	{id=115707, mapId=1157, name="黄金安宁池", condition="checkLevel>=350", position=local_position.position_2, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1157, targetPosition=local_targetPosition.targetPosition_2},
	{id=115706, mapId=1157, name="黄金安宁池", condition="checkLevel>=350", position=local_position.position_3, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1157},
	{id=115705, mapId=1157, name="黄金安宁池", condition="checkLevel>=350", position=local_position.position_4, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1157, targetPosition=local_targetPosition.targetPosition_3},
	{id=115704, mapId=1157, name="黄金安宁池", condition="checkLevel>=350", position=local_position.position_5, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1157},
	{id=115703, mapId=1157, name="黄金安宁池", condition="checkLevel>=350", position=local_position.position_6, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1157, targetPosition=local_targetPosition.targetPosition_4},
	{id=115702, mapId=1157, name="黄金安宁池", condition="checkLevel>=350", position=local_position.position_7, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1157},
	{id=115701, mapId=1157, name="黄金安宁池", condition="checkLevel>=350", position=local_position.position_8, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1157, targetPosition=local_targetPosition.targetPosition_5},
	{id=100506, mapId=1505, name="失落之塔7", desc="从失落之塔6到失落之塔7", condition="checkLevel>=40", position={6,6}, sfx=0, sfxOffset=local_sfxOffset.sfxOffset_2, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1605, targetPosition={9,87}},
	{id=100505, mapId=1405, name="失落之塔6", desc="从失落之塔5到失落之塔6", condition="checkLevel>=40", position={131,16}, sfx=0, sfxOffset=local_sfxOffset.sfxOffset_2, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1505, targetPosition={54,55}},
	{id=100504, mapId=1305, name="失落之塔5", desc="从失落之塔4到失落之塔5", condition="checkLevel>=40", position={133,135}, sfx=0, sfxOffset=local_sfxOffset.sfxOffset_2, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1405, targetPosition={131,51}},
	{id=100503, mapId=1205, name="失落之塔4", desc="从失落之塔3到失落之塔4", condition="checkLevel>=40", position={133,245}, sfx=0, sfxOffset=local_sfxOffset.sfxOffset_2, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1305, targetPosition={87,90}},
	{id=100502, mapId=1105, name="失落之塔3", desc="从失落之塔2到失落之塔3", condition="checkLevel>=40", position={166,164}, sfx=0, sfxOffset=local_sfxOffset.sfxOffset_2, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1205, targetPosition={86,168}},
	{id=100501, mapId=1005, name="失落之塔2", desc="从失落之塔1到失落之塔2", condition="checkLevel>=40", position={190,7}, sfxRotation=local_sfxRotation.sfxRotation_4, targetId=1105, targetPosition={248,240}},
	{id=100302, mapId=1003, name="失落之塔", desc="从冰风谷到失落之塔", condition="checkLevel>=40", position={2,248}, sfx=0, sfxOffset=local_sfxOffset.sfxOffset_2, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=1005, targetPosition={164,5}},
	{id=105202, mapId=1052, name="亚特兰蒂斯", desc="从幻术园到亚特兰蒂斯", condition="checkLevel>=70", position={247,149}, sfxRotation=local_sfxRotation.sfxRotation_2, targetId=1008, targetPosition={17,19}},
	{id=100901, mapId=1009, name="亚特兰蒂斯", desc="从死亡沙漠到亚特兰蒂斯", condition="checkLevel>=70", position={246,42}, sfxOffset={0,0.5,-2.5}, sfxRotation={0,-30,0}, targetId=1008, targetPosition={20,227}},
	{id=100402, mapId=1004, name="亚特兰蒂斯", desc="从仙踪林到亚特兰蒂斯", condition="checkLevel>=70", position={243,241}, sfxRotation=local_sfxRotation.sfxRotation_5, targetId=1008, targetPosition={15,11}},
	{id=1600101, mapId=16001, name="罗兰峡谷", desc="从罗兰峡谷到罗兰峡谷", sfxRotation=local_sfxRotation.sfxRotation_1, targetId=16001, targetPosition=local_targetPosition.targetPosition_6},
	{id=1600102, mapId=16001, name="罗兰峡谷", desc="从罗兰峡谷到罗兰峡谷", position=local_position.position_10, sfxRotation=local_sfxRotation.sfxRotation_1, targetId=16001, targetPosition=local_targetPosition.targetPosition_7},
}

local defaults = {mapId=1057, name="安宁池", desc="从黄金安宁池到黄金安宁池", condition="checkLevel>=0", position={160,204}, param=2, sfx=54, sfxOffset={0,0.5,0}, sfxRotation={0,90,0}, targetId=1057, targetPosition={138,109}, targetParam=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_transfer_point) do
	setmetatable(v, mt)
end

return cfg_transfer_point