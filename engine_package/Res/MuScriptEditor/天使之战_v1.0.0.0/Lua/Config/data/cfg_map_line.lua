-- 此文件工具自动生成，不要修改
---@class cfg_map_line_column
---实际的地图序列只支持数字[实际的地图序列ID]
---@field id number @地图序列（对应json中的sceneItemId） column=1 A
---[地图名称]
---@field mapname string @地图名字 column=2 B
---默认玩家出生在一线地图；
---格式：地图线路名称#地图线路ID|地图线路名称#地图线路ID[默认玩家出生在一线地图；格式：地图线路名称#地图线路ID|地图线路名称#地图线路ID]
---@field mapLine StringListList @地图线路 column=3 C
---1、切线界面线路名称的后缀显示
---2、格式与mapLine对应，用#分隔
---3、备注想显示为空时配置英文符号
---@field lineName StringList @线路备注 column=4 D
---1、条件参考condition_out表
---2、配置格式：条件id#数值#线路id
---@field showCondition string @前端显示条件 column=5 E
---1、条件参考condition_out表
---2、配置格式：条件id#数值#线路id
---@field entryCondition string @后端进入条件 column=6 F
---1、随机
---2、均匀
---0或空、优先1线
---@field mode number @玩家传送分配模式 column=7 G
---配置线路id即可，多线路用#连接
---@field peaceline IntList @和平线路 column=8 H
---PK线路，线路id|线路id
---@field pkline string @PK线路 column=9 I
---分线状态人数设定，格式：流畅人数#拥挤人数#火爆人数[分线状态]
---@field lineState IntList @线路状态人数 column=10 J
---1、未开启支线功能的干线配置人数读取这里的上限；
---2、注意：开启支线功能的干线也需要配置此字段，否则内置报错服务器起不来
---3、配置格式 线路id#上限人数
---@field lineLoad IntListList @干线总人数上限 column=11 K
---@field sidelineSwitch IntList @开启支线功能的干线id column=12 L
---配置格式：干线id#开服天数下限#天数上限#每条干线支线数
---@field sidelineCount IntListList @每条干线对应支线数量 column=13 M
---开服天数下限#天数上限#支线人数上限
---@field sidelinePeople IntListList @支线人数上限 column=14 N

local local_mapLine = {
    mapLine_1={{"狼魂要塞-1线","1"}},
    mapLine_2={{"会员领地1-1线","1"}},

}

local local_lineName = {
    lineName_1={"(和平线路)","(PK线路)","(PK线路)"},
    lineName_2={""},

}

local local_peaceline = {
    peaceline_1={1},
    peaceline_2={},

}

local local_lineState = {
    lineState_1={30,60,100},

}

local local_lineLoad = {
    lineLoad_1={{1,500},{2,500},{3,500}},
    lineLoad_2={{1,5000}},
    lineLoad_3={{1,800}},
    lineLoad_4={{1,300},{2,300}},
    lineLoad_5={{1,200},{2,200},{3,200}},

}

local local_sidelineSwitch = {
    sidelineSwitch_1={1,2,3},
    sidelineSwitch_2={},

}

local local_sidelineCount = {
    sidelineCount_1={{1,1,9999,1},{2,1,9999,1},{3,1,9999,1}},
    sidelineCount_2={},

}

local local_sidelinePeople = {
    sidelinePeople_1={{1,9999,300}},
    sidelinePeople_2={},

}

local cfg_map_line =
{
	{id=1001, mapname="勇者大陆", mapLine={{"勇者大陆-1线","1"},{"勇者大陆-2线","2"},{"勇者大陆-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1004, mapname="仙踪林", mapLine={{"仙踪林-1线","1"},{"仙踪林-2线","2"},{"仙踪林-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1052, mapname="幻术园", mapLine={{"幻术园-1线","1"},{"幻术园-2线","2"},{"幻术园-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1003, mapname="冰风谷", mapLine={{"冰风谷遗迹-1线","1"},{"冰风谷遗迹-2线","2"},{"冰风谷遗迹-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1002, mapname="地下城1", mapLine={{"地下城1-1线","1"},{"地下城1-2线","2"},{"地下城1-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1102, mapname="地下城2", mapLine={{"地下城2-1线","1"},{"地下城2-2线","2"},{"地下城2-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1202, mapname="地下城3", mapLine={{"地下城3-1线","1"},{"地下城3-2线","2"},{"地下城3-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1008, mapname="亚特兰蒂斯1", mapLine={{"亚特兰蒂斯1-1线","1"},{"亚特兰蒂斯1-2线","2"},{"亚特兰蒂斯1-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1108, mapname="亚特兰蒂斯2", mapLine={{"亚特兰蒂斯2-1线","1"},{"亚特兰蒂斯2-2线","2"},{"亚特兰蒂斯2-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1005, mapname="失落之塔1", mapLine={{"失落之塔1-1线","1"},{"失落之塔1-2线","2"},{"失落之塔1-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1105, mapname="失落之塔2", mapLine={{"失落之塔2-1线","1"},{"失落之塔2-2线","2"},{"失落之塔2-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1205, mapname="失落之塔3", mapLine={{"失落之塔3-1线","1"},{"失落之塔3-2线","2"},{"失落之塔3-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1305, mapname="失落之塔4", mapLine={{"失落之塔4-1线","1"},{"失落之塔4-2线","2"},{"失落之塔4-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1405, mapname="失落之塔5", mapLine={{"失落之塔5-1线","1"},{"失落之塔5-2线","2"},{"失落之塔5-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1505, mapname="失落之塔6", mapLine={{"失落之塔6-1线","1"},{"失落之塔6-2线","2"},{"失落之塔6-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1605, mapname="失落之塔7", mapLine={{"失落之塔7-1线","1"},{"失落之塔7-2线","2"},{"失落之塔7-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1009, mapname="死亡沙漠1", mapLine={{"死亡沙漠1-1线","1"},{"死亡沙漠1-2线","2"},{"死亡沙漠1-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1109, mapname="死亡沙漠2", mapLine={{"死亡沙漠2-1线","1"},{"死亡沙漠2-2线","2"},{"死亡沙漠2-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1034, mapname="幽暗森林1", mapLine={{"幽暗森林1-1线","1"},{"幽暗森林1-2线","2"},{"幽暗森林1-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1134, mapname="幽暗森林2", mapLine={{"幽暗森林2-1线","1"},{"幽暗森林2-2线","2"},{"幽暗森林2-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1011, mapname="天空之城1", mapLine={{"天空之城1-1线","1"},{"天空之城1-2线","2"},{"天空之城1-3线","3"}}, peaceline=local_peaceline.peaceline_1, sidelineCount={{1,1,9999,1}}, sidelinePeople={{1,9999,100}}},
	{id=1038, mapname="坎特鲁废墟1", mapLine={{"坎特鲁废墟1-1线","1"},{"坎特鲁废墟1-2线","2"},{"坎特鲁废墟1-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=103802, mapname="坎特鲁废墟2", mapLine={{"坎特鲁废墟2-1线","1"},{"坎特鲁废墟2-2线","2"},{"坎特鲁废墟2-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1039, mapname="坎特鲁遗址1", mapLine={{"坎特鲁遗址1-1线","1"},{"坎特鲁遗址1-2线","2"},{"坎特鲁遗址1-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=103902, mapname="坎特鲁遗址2", mapLine={{"坎特鲁遗址2-1线","1"},{"坎特鲁遗址2-2线","2"},{"坎特鲁遗址2-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=103903, mapname="坎特鲁遗址3", mapLine={{"坎特鲁遗址3-1线","1"},{"坎特鲁遗址3-2线","2"},{"坎特鲁遗址3-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1058, mapname="冰霜之城1", mapLine={{"冰霜之城1-1线","1"},{"冰霜之城1-2线","2"},{"冰霜之城1-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=105802, mapname="冰霜之城2", mapLine={{"冰霜之城2-1线","1"},{"冰霜之城2-2线","2"},{"冰霜之城2-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=105803, mapname="冰霜之城3", mapLine={{"冰霜之城3-1线","1"},{"冰霜之城3-2线","2"},{"冰霜之城3-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1057, mapname="安宁池", mapLine={{"安宁池1-1线","1"},{"安宁池1-2线","2"},{"安宁池1-3线","3"}}, peaceline=local_peaceline.peaceline_1},
	{id=1031, mapname="罗兰峡谷", mapLine={{"罗兰峡谷-1线","1"}}, lineName=local_lineName.lineName_2, pkline="1", lineLoad=local_lineLoad.lineLoad_2, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=1010, mapname="恶魔广场", mapLine={{"恶魔广场-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_2, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=1012, mapname="血色城堡", mapLine={{"血色城堡-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_2, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=1025, mapname="卡利玛神庙", mapLine={{"卡利玛神庙-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_2, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=1019, mapname="赤色要塞", mapLine={{"赤色要塞1线","1"}}, lineName=local_lineName.lineName_2, pkline="1", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=1035, mapname="狼魂要塞", mapLine=local_mapLine.mapLine_1, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=1064, mapname="囚禁之地", mapLine=local_mapLine.mapLine_1, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=1007, mapname="会员领地", lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=1080, mapname="罗兰市场", lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=1081, mapname="卡伦特1", lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=1059, mapname="孵化之地", mapLine={{"孵化之地1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=1042, mapname="巴克斯兵营", mapLine={{"巴克斯兵营-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=1043, mapname="巴卡斯休息室", mapLine={{"巴卡斯休息室-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=11000, mapname="四风平原", mapLine={{"四风平原-1线","1"},{"四风平原-2线","2"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_4, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=11001, mapname="腐蚀之地", mapLine={{"腐蚀之地-1线","1"},{"腐蚀之地-2线","2"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_4, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=11002, mapname="永歌森林", mapLine={{"永歌森林-1线","1"},{"永歌森林-2线","2"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_4, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=11003, mapname="菲利亚", mapLine={{"菲利亚-1线","1"},{"菲利亚-2线","2"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_4, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=11004, mapname="尼克西斯湖", mapLine={{"尼克西斯湖-1线","1"},{"尼克西斯湖-2线","2"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_4, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=11005, mapname="深渊地下城", mapLine={{"深渊地下城-1线","1"},{"深渊地下城-2线","2"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_4, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=11006, mapname="暗魂之森", mapLine={{"暗魂之森-1线","1"},{"暗魂之森-2线","2"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_4, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=11007, mapname="黑暗之沼泽", mapLine={{"黑暗之沼泽-1线","1"},{"黑暗之沼泽-2线","2"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_4, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=11008, mapname="库贝拉矿山", mapLine={{"库贝拉矿山-1线","1"},{"库贝拉矿山-2线","2"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_4, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=11009, mapname="乌尔克山", mapLine={{"乌尔克山-1线","1"},{"乌尔克山-2线","2"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_4, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=11010, mapname="远古地区", mapLine={{"远古地区-1线","1"},{"远古地区-2线","2"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_4, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=11011, mapname="阿卡玛尔", mapLine={{"阿卡玛尔-1线","1"},{"阿卡玛尔-2线","2"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_4, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=11012, mapname="德斑泰尔", mapLine={{"德斑泰尔-1线","1"},{"德斑泰尔-2线","2"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_4, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=21000, mapname="神之国度", mapLine={{"神之国度-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=30001, mapname="圣域1层", mapLine={{"圣域1层-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=30002, mapname="圣域2层", mapLine={{"圣域2层-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=30003, mapname="圣域3层", mapLine={{"圣域3层-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=30004, mapname="圣域4层", mapLine={{"圣域4层-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=30005, mapname="圣域5层", mapLine={{"圣域5层-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=30006, mapname="圣域6层", mapLine={{"圣域6层-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=30007, mapname="圣域7层", mapLine={{"圣域7层-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=30008, mapname="圣域8层", mapLine={{"圣域8层-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=30009, mapname="圣域9层", mapLine={{"圣域9层-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=30010, mapname="圣域10层", mapLine={{"圣域10层-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=30011, mapname="圣域11层", mapLine={{"圣域11层-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=30012, mapname="圣域12层", mapLine={{"圣域12层-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=30013, mapname="圣域13层", mapLine={{"圣域13层-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=30014, mapname="圣域14层", mapLine={{"圣域14层-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=30015, mapname="圣域15层", mapLine={{"圣域15层-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=100702, mapname="VIP地图", mapLine={{"VIP地图-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_3, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=1060, mapname="泊湖雨林1", mapLine={{"泊湖雨林1-1线","1"},{"泊湖雨林1-2线","2"},{"泊湖雨林1-3线","3"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_5, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=1160, mapname="泊湖雨林2", mapLine={{"泊湖雨林2-1线","1"},{"泊湖雨林2-2线","2"},{"泊湖雨林2-3线","3"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_5, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
	{id=10013, mapname="战盟boss地图", mapLine={{"战盟BOSS-1线","1"}}, lineName=local_lineName.lineName_2, pkline="", lineLoad=local_lineLoad.lineLoad_5, sidelineSwitch=local_sidelineSwitch.sidelineSwitch_2, sidelineCount=local_sidelineCount.sidelineCount_2, sidelinePeople=local_sidelinePeople.sidelinePeople_2},
}

local defaults = {mapLine={{"会员领地1-1线","1"}}, lineName={"(和平线路)","(PK线路)","(PK线路)"}, showCondition="", entryCondition="", mode=2, peaceline={}, pkline="2|3", lineState={30,60,100}, lineLoad={{1,500},{2,500},{3,500}}, sidelineSwitch={1,2,3}, sidelineCount={{1,1,9999,1},{2,1,9999,1},{3,1,9999,1}}, sidelinePeople={{1,9999,300}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_map_line) do
	setmetatable(v, mt)
end

return cfg_map_line