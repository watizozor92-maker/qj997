-- 此文件工具自动生成，不要修改
---@class cfg_map_info_column
---实际的地图序列只支持数字[实际的地图序列ID]
---@field id number @地图序列（对应json中的sceneItemId） column=1 A
---关联SceneEditorCacheMapByte[关联SceneEditorCacheMapByte]
---@field data string @阻挡配置（可共用）#客户端#C   column=2 B
---@field img string @资源目录 column=3 C
---1表示本服地图，2表示跨服地图
---@field serverType number @是否为跨服地图 column=4 D
---格式：角色等级#全身强化总等级#全身追加总等级
---@field condition IntList @跨服地图限制 column=5 E
---服务器判断先后加载地图资源的顺序
---1=常驻地图
---2=副本地图
---编辑器读取
---{常驻地图=1|副本地图=2}[地图所属类型]
---@field type number @地图所属活动分类 column=6 F
---0.静态地图，地图复用
---1.动态地图，地图会发生变化时
---不填=填0，默认填0，特殊情况填1
---@field storageMode number @地图存储类型 column=7 G
---[地图名称]
---@field mapname string @地图名字 column=8 H
---1陆地
---2水中
---3空中
---编辑器读取
---{陆地=1|水中=2|空中=3}[地图区域类型]
---@field area number @地图区域 column=9 I
---[地图宽度]
---@field width number @地图宽度 column=10 J
---[地图高度]
---@field height number @地图高度 column=11 K
---[角色目视范围]
---@field viewRange number @视野范围 column=12 L
---1.不可穿
---编辑器读取
---{可穿=0|不可穿=1}[角色模型与角色模型之间是否可穿越]
---@field runhunman number @禁止穿人 column=13 M
---1：不可穿
---0或空：可穿[玩家模型与怪物模型之间是否可穿越]
---@field pveCrossModel number @玩家与怪物是否可穿 column=14 N
---1：不可穿
---0或空：可穿[怪物模型与怪物模型之间是否可穿越]
---@field eveCrossModel number @怪物与怪物是否可穿 column=15 O
---
---{允许传送=0|不可传送=1}
---@field nopositionmove number @是否可传送 column=16 P
---进入该地图等级限制，不填没有限制 默认为0[进入地图等级限制，默认为0]
---@field intolv number @进入等级 column=17 Q
---100代表经验倍数，除以100后为实际倍数[经验倍数]，10在公式中实际为为（100+10）/100=1.1
---@field exprate number @杀怪经验倍率 column=18 R
---填写cfg_audio表对应的音效id
---进入地图时自动播放
---空为不播放[地图音乐，填空为不播放]
---@field mapBgm number @地图背景音乐 column=19 S
---初始地图显示大小，进行倍数缩放
---@field showSize number @地图缩放 column=20 T
---格式：X坐标#Y坐标；不填默认不偏移[偏移坐标]
---@field showPosition IntList @地图显示偏移 column=21 U
---读取cfg_revive内id
---@field rebirthType IntList @复活类型 column=22 V
---角色死亡复活点（指定某个地图的某个点）
---格式：地图id#X坐标#Y坐标#范围
---低优先级，会被副本复活点覆盖[复活点位置，格式：X坐标#Y坐标#范围]
---@field rebirthPoint IntList @地图复活点 column=23 W
---怪点显示开关
---1开启
---0关闭
---关闭后，小地图界面不显示怪点列表，地图上不显示怪点[怪点显示开关，关闭后小地图界面不显示怪点列表]
---@field showPoints number @是否显示怪点 column=24 X
---是否死亡可以传送，传送的时候自动复活，
---1表示可以，
---0或者不配表示不可以[是否死亡可以传送，传送的时候自动复活]
---@field dieCanTransmit number @死亡传送 column=25 Y
---1表示展开
---0表示不展开[点击小地图是否展开]
---@field switchUi number @点击小地图是否展开界面 column=26 A
---填写小地图文件名
---@field miniMap string @小地图 column=27 AA
---地图传送后浮现在主界面的地图说明图标
---格式：填写文件名称，不填则不显示
---@field mapIcon string @地图场景传送图标 column=28 AB
---1为黄金地图，空或0为非黄金地图
---@field goldmap number @黄金地图 column=29 AC
---1：不可穿
---0或空：可穿[怪物模型与掉落道具模型之间是否可穿越]
---@field monsterCrossItem number @怪物与掉落道具是否可穿 column=30 AD
---地图镜头普通资源,多个特效资源用#分隔
---参考cfg_model_effect表id
---
---@field specialEffect1 StringList @地图镜头特效（普通特效） column=31 AE
---地图镜头间隔特效，
---格式：id#播放间隔#触发几率&id#播放间隔#触发几率
---参考cfg_model_effect表id，播放间隔单位：毫秒；触发几率单位：万分比
---@field specialEffec2 StringListList @地图镜头特效（间隔特效） column=32 AF
---地图离线挂机后，是否进行系统托管自动战斗
---填0或不填则进行托管，填1则不进行托管
---[[客户端不使用]]@field onhook number @地图离线挂机设置 column=33 AG
---场景资源类型
---默认为0，不填即为默认值
---1为新导入场景资源
---@field scenetype number @场景类型 column=34 AH
---2D地形贴图width#height#widthCount#heightCount#maxWidth#maxHeight
---@field mapAttr2D IntList @2D地形贴图 column=35 AI
---传送消耗
---@field transferCost IntListList @传送消耗 column=36 AJ
---1不发送，0或空发送
---@field deathMail number @场景死亡是否发送死亡邮件 column=37 AK
---1、包含pvp于pve
---2、0或空触发，1不触发
---@field deathpunishment number @该地图是否触发死亡惩罚 column=38 AL
---[[客户端不使用]]@field   @ column=39 AM
---[[客户端不使用]]@field   @ column=40 AN

local local_condition = {
    condition_1={},

}

local local_showPosition = {
    showPosition_1={0.5,0.5},
    showPosition_2={0.68,0.5},

}

local local_rebirthType = {
    rebirthType_1={8,9},

}

local local_rebirthPoint = {
    rebirthPoint_1={1003,210,44,3},
    rebirthPoint_2={1002,109,242,3},
    rebirthPoint_3={1005,207,78,3},
    rebirthPoint_4={1008,21,20,3},
    rebirthPoint_5={1009,197,63,3},
    rebirthPoint_6={1034,83,11,3},
    rebirthPoint_7={1038,30,209,3},
    rebirthPoint_8={1039,78,105,3},
    rebirthPoint_9={1058,215,205,3},
    rebirthPoint_10={1001,135,128,3},
    rebirthPoint_11={1001,140,124,1},

}

local local_specialEffect1 = {
    specialEffect1_1={""},
    specialEffect1_2={"21001"},
    specialEffect1_3={"21002","21003"},
    specialEffect1_4={"21004"},
    specialEffect1_5={"21007"},

}

local local_specialEffec2 = {
    specialEffec2_1={},

}

local local_mapAttr2D = {
    mapAttr2D_1={256,256,28,19,7144,4772},

}

local local_transferCost = {
    transferCost_1={},
    transferCost_2={{10010002,1200}},
    transferCost_3={{10010002,2500}},
    transferCost_4={{10010002,3300}},
    transferCost_5={{10010002,4500}},
    transferCost_6={{10010002,5500}},
    transferCost_7={{10010002,6500}},
    transferCost_8={{10010002,8500}},
    transferCost_9={{10010002,9500}},
    transferCost_10={{10010002,10500}},
    transferCost_11={{10010002,2000}},
    transferCost_12={{10010002,0}},

}

local cfg_map_info =
{
	{id=1001, data="1001", img="1001", mapname="勇者大陆", rebirthPoint=local_rebirthPoint.rebirthPoint_10, miniMap="scene_1001", mapIcon="icon_map_yzdl", transferCost=local_transferCost.transferCost_1},
	{id=1004, data="1004", img="1004", mapname="仙踪林", mapBgm=10005, rebirthPoint={1004,174,115,3}, miniMap="scene_1004", mapIcon="icon_map_xzl", transferCost=local_transferCost.transferCost_1},
	{id=1052, data="1052", img="1052", mapname="幻术园", mapBgm=10001, rebirthPoint={1052,50,225,3}, miniMap="scene_1052", mapIcon="icon_map_hsy", transferCost=local_transferCost.transferCost_1},
	{id=1003, intolv=20, mapBgm=10006, rebirthPoint=local_rebirthPoint.rebirthPoint_1, mapIcon="icon_map_bfg", specialEffect1=local_specialEffect1.specialEffect1_2, transferCost=local_transferCost.transferCost_2},
	{id=1013, intolv=20, mapBgm=10006, rebirthPoint=local_rebirthPoint.rebirthPoint_1, mapIcon="icon_map_bfg", specialEffect1=local_specialEffect1.specialEffect1_2, transferCost=local_transferCost.transferCost_2},
	{id=1023, intolv=20, mapBgm=10006, rebirthPoint=local_rebirthPoint.rebirthPoint_1, mapIcon="icon_map_bfg", specialEffect1=local_specialEffect1.specialEffect1_2, transferCost=local_transferCost.transferCost_2},
	{id=1033, intolv=20, mapBgm=10006, rebirthPoint=local_rebirthPoint.rebirthPoint_1, mapIcon="icon_map_bfg", specialEffect1=local_specialEffect1.specialEffect1_2, transferCost=local_transferCost.transferCost_2},
	{id=1002, data="1002", img="1002", mapname="地下城1", intolv=30, mapBgm=10015, showPosition={0.5,0.75}, rebirthPoint=local_rebirthPoint.rebirthPoint_2, miniMap="scene_1002", mapIcon="icon_map_dxc", transferCost=local_transferCost.transferCost_3},
	{id=1102, data="1102", img="1102", mapname="地下城2", intolv=40, mapBgm=10015, showSize=0.68, showPosition={0.6,0.25}, rebirthPoint=local_rebirthPoint.rebirthPoint_2, miniMap="scene_1102", mapIcon="icon_map_dxc", transferCost=local_transferCost.transferCost_3},
	{id=1202, data="1202", img="1202", mapname="地下城3", intolv=50, mapBgm=10015, showSize=1.5, showPosition={0.1,0.35}, rebirthPoint=local_rebirthPoint.rebirthPoint_2, miniMap="scene_1202", mapIcon="icon_map_dxc", transferCost=local_transferCost.transferCost_3},
	{id=1005, data="1005", img="1005", mapname="失落之塔1", intolv=50, mapBgm=10011, showSize=0.9, showPosition={0.8,0.25}, rebirthPoint=local_rebirthPoint.rebirthPoint_3, miniMap="scene_1005", mapIcon="icon_map_slzt"},
	{id=1105, data="1105", img="1105", mapname="失落之塔2", intolv=50, mapBgm=10011, showSize=1, showPosition={0.8,0.8}, rebirthPoint=local_rebirthPoint.rebirthPoint_3, miniMap="scene_1105", mapIcon="icon_map_slzt"},
	{id=1205, data="1205", img="1205", mapname="失落之塔3", intolv=50, mapBgm=10011, showSize=1.5, showPosition={0.4,0.8}, rebirthPoint=local_rebirthPoint.rebirthPoint_3, miniMap="scene_1205", mapIcon="icon_map_slzt"},
	{id=1305, data="1305", img="1305", mapname="失落之塔4", intolv=80, mapBgm=10011, showSize=2.2, showPosition={0.416,0.42}, rebirthPoint=local_rebirthPoint.rebirthPoint_3, miniMap="scene_1305", mapIcon="icon_map_slzt"},
	{id=1405, data="1405", img="1405", mapname="失落之塔5", intolv=80, mapBgm=10011, showSize=1.5, showPosition={0.42,0.12}, rebirthPoint=local_rebirthPoint.rebirthPoint_3, miniMap="scene_1405", mapIcon="icon_map_slzt"},
	{id=1505, data="1505", img="1505", mapname="失落之塔6", intolv=80, mapBgm=10011, showSize=1.5, showPosition={0.13,0.13}, rebirthPoint=local_rebirthPoint.rebirthPoint_3, miniMap="scene_1505", mapIcon="icon_map_slzt"},
	{id=1605, data="1605", img="1605", mapname="失落之塔7", intolv=80, mapBgm=10011, showSize=0.8, showPosition={0.12,0.66}, rebirthPoint=local_rebirthPoint.rebirthPoint_3, miniMap="scene_1605", mapIcon="icon_map_slzt"},
	{id=1008, data="1008", img="1008", mapname="亚特兰蒂斯", area=2, intolv=70, mapBgm=10004, showSize=0.55, showPosition={0.5,0.48}, rebirthPoint=local_rebirthPoint.rebirthPoint_4, miniMap="scene_1008", mapIcon="icon_map_ytlds", specialEffect1=local_specialEffect1.specialEffect1_3, transferCost=local_transferCost.transferCost_5},
	{id=1108, data="1108", img="1108", mapname="亚特兰蒂斯2", area=2, intolv=70, mapBgm=10004, showSize=0.55, rebirthPoint=local_rebirthPoint.rebirthPoint_4, miniMap="scene_1108", mapIcon="icon_map_ytlds", specialEffect1=local_specialEffect1.specialEffect1_3, transferCost=local_transferCost.transferCost_5},
	{id=1009, data="1009", img="1009", mapname="死亡沙漠", intolv=140, mapBgm=10013, showSize=0.55, rebirthPoint=local_rebirthPoint.rebirthPoint_5, miniMap="scene_1009", mapIcon="icon_map_swsm", specialEffect1=local_specialEffect1.specialEffect1_4, transferCost=local_transferCost.transferCost_6},
	{id=1109, data="1109", img="1109", mapname="死亡沙漠2", intolv=140, mapBgm=10013, showSize=0.55, rebirthPoint=local_rebirthPoint.rebirthPoint_5, miniMap="scene_1109", mapIcon="icon_map_swsm", specialEffect1=local_specialEffect1.specialEffect1_4, transferCost=local_transferCost.transferCost_6},
	{id=1034, data="1034", img="1034", mapname="幽暗森林", intolv=170, mapBgm=10012, showPosition={0.6,0.35}, rebirthPoint=local_rebirthPoint.rebirthPoint_6, miniMap="scene_1034", mapIcon="icon_map_yasl", transferCost=local_transferCost.transferCost_7},
	{id=1134, data="1134", img="1134", mapname="幽暗森林2", intolv=170, mapBgm=10012, showSize=1.3, showPosition={0.35,0.55}, rebirthPoint=local_rebirthPoint.rebirthPoint_6, miniMap="scene_1134", mapIcon="icon_map_yasl", transferCost=local_transferCost.transferCost_7},
	{id=1011, data="1011", img="1011", mapname="天空之城", area=3, intolv=160, mapBgm=10010, showSize=0.55, showPosition={0.15,0.45}, rebirthPoint={1011,13,23,3}, miniMap="scene_1011", mapIcon="icon_map_tkzc", specialEffect1={"21005"}, specialEffec2={{"21006","2000","10000"}}, transferCost={{10010002,7500}}},
	{id=1038, data="1038", img="1038", mapname="坎特鲁废墟", intolv=170, mapBgm=10009, showSize=0.6, rebirthPoint=local_rebirthPoint.rebirthPoint_7, miniMap="scene_1038", mapIcon="icon_map_ktlfx", transferCost=local_transferCost.transferCost_8},
	{id=103802, data="1038", img="1038", mapname="坎特鲁废墟2", intolv=230, mapBgm=10009, showSize=0.6, rebirthPoint=local_rebirthPoint.rebirthPoint_7, miniMap="scene_1038", mapIcon="icon_map_ktlfx", transferCost=local_transferCost.transferCost_8},
	{id=1039, data="1039", img="1039", mapname="坎特鲁遗址", intolv=230, mapBgm=10008, showSize=0.9, rebirthPoint=local_rebirthPoint.rebirthPoint_8, miniMap="scene_1039", mapIcon="icon_map_ktlyz", transferCost=local_transferCost.transferCost_9},
	{id=103902, data="1039", img="1039", mapname="坎特鲁遗址2", intolv=230, mapBgm=10008, showSize=0.9, rebirthPoint=local_rebirthPoint.rebirthPoint_8, miniMap="scene_1039", mapIcon="icon_map_ktlyz", transferCost=local_transferCost.transferCost_9},
	{id=1058, data="1058", img="1058", mapname="冰霜之城", intolv=280, mapBgm=10001, showSize=0.65, showPosition=local_showPosition.showPosition_2, rebirthPoint=local_rebirthPoint.rebirthPoint_9, miniMap="scene_1058", mapIcon="icon_map_bszc", specialEffect1=local_specialEffect1.specialEffect1_5, transferCost=local_transferCost.transferCost_10},
	{id=105802, data="1058", img="1058", mapname="冰霜之城2", intolv=300, mapBgm=10001, showSize=0.65, showPosition=local_showPosition.showPosition_2, rebirthPoint=local_rebirthPoint.rebirthPoint_9, miniMap="scene_1058", mapIcon="icon_map_bszc", specialEffect1=local_specialEffect1.specialEffect1_5, transferCost={{10010002,10000}}},
	{id=105803, data="1058", img="1058", mapname="冰霜之城3", intolv=320, mapBgm=10001, showSize=0.65, showPosition=local_showPosition.showPosition_2, rebirthPoint=local_rebirthPoint.rebirthPoint_9, miniMap="scene_1058", mapIcon="icon_map_bszc", specialEffect1=local_specialEffect1.specialEffect1_5, transferCost=local_transferCost.transferCost_10},
	{id=1057, data="1057", img="1057", mapname="安宁池", intolv=350, mapBgm=10001, rebirthPoint={1057,140,108,3}, miniMap="scene_1057", mapIcon="icon_map_anc", specialEffect1={"21008"}, transferCost={{10010002,11500}}},
	{id=1006, data="1006", img="1006", mapname="竞技场", mapBgm=10001, rebirthPoint={1001,135,128,15}, dieCanTransmit=0, miniMap="scene_1006", transferCost=local_transferCost.transferCost_11},
	{id=1010, data="1010", img="1010", type=2, mapname="恶魔广场", pveCrossModel=1, nopositionmove=1, mapBgm=10001, showSize=3, showPosition={0.55,0.38}, rebirthPoint={1010,136,97,3}, dieCanTransmit=0, miniMap="scene_1010", transferCost=local_transferCost.transferCost_11, deathpunishment=1},
	{id=1012, data="1012", img="1012", type=2, mapname="血色城堡", pveCrossModel=1, nopositionmove=1, mapBgm=10016, showSize=2, showPosition={0.08,0.2}, rebirthPoint={1012,13,7,3}, dieCanTransmit=0, miniMap="scene_1012", transferCost=local_transferCost.transferCost_11, deathpunishment=1},
	{id=1025, data="1025", img="1025", mapname="卡利玛神庙", area=2, mapBgm=10007, showSize=1, showPosition={0.25,0.25}, rebirthPoint=local_rebirthPoint.rebirthPoint_10, dieCanTransmit=0, miniMap="scene_1025", transferCost={{10010002,999999999}}},
	{id=1040, data="1040", img="1040", mapname="提炼之塔", mapBgm=10008, rebirthPoint={1001,135,128,50}, dieCanTransmit=0, switchUi=0, miniMap="scene_1040", transferCost=local_transferCost.transferCost_1},
	{id=16001, data="1031", img="1031", type=2, mapname="罗兰攻城战", nopositionmove=1, mapBgm=10001, rebirthPoint={16001,87,209}, dieCanTransmit=0, miniMap="scene_1031", transferCost=local_transferCost.transferCost_3},
	{id=70001, data="70001", img="70001", mapname="地下城", viewRange=4, miniMap="scene_70001", mapIcon="icon_map_yzdl", goldmap=0, transferCost=local_transferCost.transferCost_3},
	{id=70002, data="70002", img="70002", mapname="失落之塔", viewRange=4, miniMap="scene_70002", mapIcon="icon_map_yzdl", goldmap=0, transferCost={{10010002,3500}}},
	{id=70003, data="70003", img="70003", mapname="亚特兰蒂斯", viewRange=4, miniMap="scene_70003", mapIcon="icon_map_yzdl", goldmap=0, transferCost=local_transferCost.transferCost_5},
	{id=70004, data="70004", img="70004", mapname="死亡沙漠", viewRange=4, miniMap="scene_70004", mapIcon="icon_map_yzdl", goldmap=0, transferCost=local_transferCost.transferCost_6},
	{id=70005, data="70005", img="70005", mapname="幽暗森林", viewRange=4, miniMap="scene_70005", mapIcon="icon_map_yzdl", goldmap=0, transferCost=local_transferCost.transferCost_7},
	{id=70006, data="70006", img="70006", mapname="坎特鲁废墟", viewRange=4, miniMap="scene_70006", mapIcon="icon_map_yzdl", goldmap=0, transferCost=local_transferCost.transferCost_8},
	{id=70007, data="70007", img="70007", mapname="幻术园", viewRange=4, miniMap="scene_70007", mapIcon="icon_map_yzdl", goldmap=0, transferCost=local_transferCost.transferCost_1},
	{id=70008, data="70008", img="70008", mapname="冰霜之城", viewRange=4, miniMap="scene_70008", mapIcon="icon_map_yzdl", goldmap=0, transferCost=local_transferCost.transferCost_10},
	{id=1035, data="1035", img="1035", mapname="狼魂要塞", viewRange=4, runhunman=1, nopositionmove=1, mapBgm=10014, dieCanTransmit=0, miniMap="scene_1035", scenetype=0, transferCost=local_transferCost.transferCost_12},
	{id=1019, data="1019", img="1019", type=2, storageMode=1, mapname="赤色要塞", viewRange=4, runhunman=1, eveCrossModel=0, nopositionmove=1, rebirthPoint={}, dieCanTransmit=0, miniMap="scene_1019", scenetype=0, transferCost=local_transferCost.transferCost_12, deathpunishment=1},
	{id=10013, data="1013", img="1013", type=2, mapname="战盟boss地图", viewRange=4, runhunman=0, pveCrossModel=0, nopositionmove=1, intolv=70, mapBgm=10014, rebirthPoint={1013,16,82,1}, miniMap="scene_1013", scenetype=0, transferCost=local_transferCost.transferCost_12},
	{id=11003, data="11003", img="11003", mapname="菲利亚", viewRange=4, intolv=400, miniMap="scene_11003", scenetype=0, transferCost={{10010002,11000}}},
	{id=11005, data="11005", img="11005", mapname="深渊地下城", viewRange=4, intolv=400, miniMap="scene_11005", scenetype=0, transferCost={{10010002,13000}}},
	{id=11004, data="11004", img="11004", mapname="尼克西斯湖", viewRange=4, intolv=400, miniMap="scene_11004", specialEffect1={"21001","21008","21010"}, scenetype=0, transferCost={{10010002,15000}}},
	{id=1042, data="1042", img="1042", mapname="巴卡斯兵营", viewRange=4, mapBgm=10005, rebirthPoint={1042,13,81,1}, miniMap="scene_1042", scenetype=0, transferCost=local_transferCost.transferCost_12},
	{id=1043, data="1043", img="1043", mapname="巴卡斯休息室", viewRange=4, mapBgm=10006, rebirthPoint={1043,13,81,1}, miniMap="scene_1043", scenetype=0, transferCost=local_transferCost.transferCost_12},
}

local defaults = {data="1003", img="1003", serverType=1, condition={}, type=1, storageMode=0, mapname="冰风谷", area=1, width=256, height=256, viewRange=6, runhunman=0, pveCrossModel=0, eveCrossModel=1, nopositionmove=0, intolv=1, exprate=0, mapBgm=10002, showSize=0.57, showPosition={0.5,0.5}, rebirthType={8,9}, rebirthPoint={1001,140,124,1}, showPoints=0, dieCanTransmit=1, switchUi=1, miniMap="scene_1003", mapIcon="", goldmap=0, monsterCrossItem=0, specialEffect1={""}, specialEffec2={}, scenetype=0, mapAttr2D={256,256,28,19,7144,4772}, transferCost={{10010002,3300}}, deathMail=1, deathpunishment=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_map_info) do
	setmetatable(v, mt)
end

return cfg_map_info