-- 此文件工具自动生成，不要修改
---@class cfg_equip_suit_column
---@field id number @id column=1 A
---套装名称，套装名称会显示在装备tips上
---@field name string @套装名称 column=2 B
---0：装备套装
---1：时装套装
---2：叠加套装
---@field suitType number @套装类型 column=3 C
---同组套装能够根据套装等级向下兼容
---@field group number @套装组 column=4 D
---套装中部件的id
---引援item表id
---部件之间用#号分隔
---@field suitItemId IntList @套装部件 column=5 E
---前一字段配置了多少件装备
---@field suitCount number @套装数量 column=6 F
---@field level number @套装等级 column=7 G
---套装属性加成
---格式：穿戴套装部件数#属性id#属性值&属性id#属性值|穿戴套装部件数#属性id#属性值&属性id#属性值
---
---套装属性加成叠加
---@field suitEffect IntListList @套装效果 column=8 H
---格式：x件套时触发#技能ID#技能等级&技能ID#技能等级|x件套时触发#技能ID#技能等级&技能ID#技能等级
---引援cfg_skill表id
---套装技能叠加
---@field suitSkill intListListList @套装技能 column=9 I

local local_suitItemId = {
    suitItemId_1={21100064,20460431,20860431,20760431,21100065,20460451,20860451,20760451},
    suitItemId_2={20430441,20630441,20830441,20930441,20430461,20630461,20830461,20930461},
    suitItemId_3={20130431,20630431,20730431,20930431,21000063,20130451,20630451,20730451,20930451,21000065},
    suitItemId_4={25851,25871,25891,25853,25873,25893},
    suitItemId_5={2586,2587,2588,25862,25872,25882},
    suitItemId_6={20830341,20930341,20830361,20930361},
    suitItemId_7={20430331,20630331,20730331,20830331,20930331,20430351,20630351,20730351,20830351,20930351},
    suitItemId_8={21000034,2075010641,2085010641,2095010641,21000036,2075010661,2085010661,2095010661},
    suitItemId_9={21100024,2085010631,2065010631,2045010631,21100025,2085010651,2065010651,2045010651},
    suitItemId_10={20460441,20660441,20760441,20960441,20460461,20660461,20760461,20960461},
    suitItemId_11={20430231,20630231,20730231,20830231,20871,20430251,20630251,20730251,20830251,20872},
    suitItemId_12={20430141,20630141,20830141,20930141,20430161,20630161,20830161,20930161},
    suitItemId_13={20430131,20730131,20830131,20930131,21100043,20021,20430151,20730151,20830151,20930151,21100045,20022},
    suitItemId_14={21100034,2064010441,2084010441,2074010441,21100036,2064010461,2084010461,2074010461},
    suitItemId_15={21000053,2064010431,2084010431,2094010431,21000055,2064010451,2084010451,2094010451},
    suitItemId_16={20420441,20620441,20820441,20920441,20420461,20620461,20820461,20920461},
    suitItemId_17={20410131,20610131,20710131,20810131,20910131,21100013,20451,20410151,20610151,20710151,20810151,20910151,21100015,20452},
    suitItemId_18={20410141,20810141,20910141,21451,20410161,20810161,20910161,21453},
    suitItemId_19={2526,2527,2529,25262,25272,25292},
    suitItemId_20={25251,25271,25281,25253,25273,25283},
    suitItemId_21={21000013,21541,2530,2531,2532,21000015,21542,25302,25312,25322},
    suitItemId_22={25301,25311,25321,25331,25341,25303,25313,25323,25333,25343},
    suitItemId_23={20410241,20810241,20410261,20810261},
    suitItemId_24={20610231,20710231,20810231,20910231,21000023,20610251,20710251,20810251,20910251,21000025},
    suitItemId_25={20410341,20610341,20810341,20410361,20610361,20810361},
    suitItemId_26={20610331,20710331,20910331,21100023,21100053,20610351,20710351,20910351,21100026,21100055},
    suitItemId_27={20410441,20610441,20810441,21100044,20410461,20610461,20810461,21100046},
    suitItemId_28={20310431,20410431,20710431,20910431,20310451,20410451,20710451,20910451},
    suitItemId_29={20220131,20420331,20620331,20720331,20820331,20920331,20220151,20420351,20620351,20720351,20820351,20920351},
    suitItemId_30={20620341,20820341,20920341,20620361,20820361,20920361},
    suitItemId_31={20420131,20620131,20720131,20820131,21000033,21100063,21111,20420151,20620151,20720151,20820151,21000035,21100066,21112},
    suitItemId_32={20420141,20820141,20920141,20420161,20820161,20920161},
    suitItemId_33={20620231,20820231,20920231,21000043,20620251,20820251,20920251,21000045},
    suitItemId_34={20420241,20620241,20720241,20920241,20420261,20620261,20720261,20920261},
    suitItemId_35={20420431,20620431,20720431,21100033,20420451,20620451,20720451,21100035},
    suitItemId_36={20470351,20670351,20870351,20770351,20970351,20670631,20470631,20870631,20770631,20970631},
    suitItemId_37={20770531,20470531,20670531,20870531,20970531,20470251,20670251,20870251,20770251,20970251},
    suitItemId_38={20670131,20870131,20770131,20970131,20670231,20870231,20770231,20970231},
    suitItemId_39={20770331,20870331,20670331,20470331,20770431,20870431,20670431,20470431},

}

local local_suitEffect = {
    suitEffect_1={{2,304012,2000},{3,206011,60},{4,320011,30,303012,1500,305012,1500,303031,20,305031,20}},
    suitEffect_2={{2,315011,10},{3,304012,1000},{4,320011,20,303012,1500,305012,1500,317012,500}},
    suitEffect_3={{2,10002,30},{3,200011,20},{4,206011,20},{5,200021,20,303012,1500,305012,1500,303031,20,305031,20}},
    suitEffect_4={{2,320011,15},{3,304012,1000,305012,1000,10002,40}},
    suitEffect_5={{2,200021,20},{3,320011,25,1031,50,304012,500}},
    suitEffect_6={{2,10002,30,317012,500}},
    suitEffect_7={{2,10003,15},{3,207011,50},{4,209011,50},{5,10002,30,208011,50,317012,500,1031,50}},
    suitEffect_8={{2,315011,20},{3,320011,20},{4,10003,30,303012,1500,305012,1500,317012,500}},
    suitEffect_9={{2,304012,1000},{3,206011,40},{4,320011,20,303012,1500,305012,1500,303031,20,305031,20}},
    suitEffect_10={{2,202052,1500},{3,320011,25},{4,10003,30,303012,1500,305012,1500,317012,500}},
    suitEffect_11={{2,207011,100},{3,208011,100,206011,100}},
    suitEffect_12={{2,10002,20},{3,315011,25},{4,304012,2000,206011,40,305012,1000}},
    suitEffect_13={{2,10002,10},{3,207011,50},{4,206011,20},{5,206022,500},{6,10003,10,207011,50,10001,20}},
    suitEffect_14={{2,320011,10},{3,202052,1000},{4,304012,1000,303012,1500,305012,1500,206011,25,600011,2000}},
    suitEffect_15={{2,317012,500},{3,304012,1500},{4,320011,15,303012,1500,303031,30,202052,1000,10001,30}},
    suitEffect_16={{2,320011,10},{3,304012,1000},{4,10003,30,202052,1000,317012,500}},
    suitEffect_17={{2,10001,10},{3,320011,10},{4,1031,20},{5,302051,5},{6,206011,20},{7,10002,10,305012,500,303012,500,10001,25}},
    suitEffect_18={{2,207011,50},{3,10002,50},{4,206022,2500,315011,30}},
    suitEffect_19={{2,10003,15},{3,10002,15,320011,20,208011,30}},
    suitEffect_20={{2,10004,20},{3,320011,30,304012,1000,10002,20}},
    suitEffect_21={{2,320011,15},{3,209011,50},{4,202052,500},{5,207011,50,1031,30,305012,1000,303012,1000}},
    suitEffect_22={{2,200021,10},{3,200021,20},{4,200021,30},{5,200021,40,320011,40,10001,40}},
    suitEffect_23={{2,305012,2000,305031,50}},
    suitEffect_24={{2,1031,30},{3,304012,500},{4,10003,15},{5,207011,50,320011,25,202052,1500}},
    suitEffect_25={{2,320011,20},{3,304012,1000,317012,500,600011,3000}},
    suitEffect_26={{2,10003,15},{3,10004,30},{4,202052,1000},{5,10001,15,320011,25,303012,1000,303031,20}},
    suitEffect_27={{2,320011,15},{3,315011,15},{4,304012,1000,200021,30,200011,20,317012,500}},
    suitEffect_28={{2,206011,25},{3,304012,1000},{4,320011,20,303012,1500,305012,1500,303031,20,305031,20}},
    suitEffect_29={{2,10003,30},{3,206011,30,208011,100,320011,15}},
    suitEffect_30={{2,10003,10},{3,202052,500},{4,320011,10},{5,208011,30},{6,207011,30},{7,1031,20,303012,1000,305012,1000,10003,30}},
    suitEffect_31={{2,202052,1000},{3,10003,20,208011,100,320011,30}},
    suitEffect_32={{2,320011,15},{3,10004,20},{4,202052,1000,304012,500,209011,50,1031,5}},
    suitEffect_33={{2,304012,500},{3,305012,500},{4,206011,20,10001,50,10002,50,10003,50,10004,50}},
    suitEffect_34={{2,304012,1000},{3,208011,50},{4,202052,1000,303012,1500,305012,1500,303031,20,305031,20}},
    suitEffect_35={{2,207011,50},{3,206011,40},{4,304012,1500},{5,317012,500,303012,1500,305012,1500,303031,2000,305031,2000}},
    suitEffect_36={{2,207011,30},{3,320011,25},{4,206011,20},{5,304012,1000,303012,1000,305012,1000,303031,1000,305031,1000}},
    suitEffect_37={{2,304012,2000},{3,206011,60},{4,320011,30,303012,1500,305012,1500,303031,2000,305031,2000}},
    suitEffect_38={{2,202052,1500},{3,304012,1000},{4,10003,30,207011,50,303012,1500,305012,1500,317012,500}},
    suitEffect_39={{2,10001,50},{3,10002,50},{4,10003,50},{5,10004,50}},

}

local local_suitSkill = {
    suitSkill_1={},

}

local cfg_equip_suit =
{
	{id=1, name="哈德的皮套", group=1, suitCount=14, level=1},
	{id=2, name="瑞恩的青铜套", group=2, suitItemId=local_suitItemId.suitItemId_19, suitCount=6, level=1, suitEffect=local_suitEffect.suitEffect_19},
	{id=3, name="赫兰德的翡翠套", group=3, suitItemId=local_suitItemId.suitItemId_21, suitCount=10, level=1, suitEffect=local_suitEffect.suitEffect_21},
	{id=4, name="哈德的强化皮套", group=4, suitItemId=local_suitItemId.suitItemId_18, level=1, suitEffect=local_suitEffect.suitEffect_18},
	{id=5, name="瑞恩的强化青铜套", group=5, suitItemId=local_suitItemId.suitItemId_20, suitCount=6, level=1, suitEffect=local_suitEffect.suitEffect_20},
	{id=6, name="赫兰德的强化翡翠套", group=6, suitItemId=local_suitItemId.suitItemId_22, suitCount=10, level=1, suitEffect=local_suitEffect.suitEffect_22},
	{id=7, name="海德拉的强化黄金套", group=7, suitItemId=local_suitItemId.suitItemId_23, suitCount=4, level=1, suitEffect=local_suitEffect.suitEffect_23},
	{id=8, name="菲斯特的强化白金套", group=8, suitItemId=local_suitItemId.suitItemId_25, suitCount=6, level=1, suitEffect=local_suitEffect.suitEffect_25},
	{id=9, name="汉斯的强化龙王套", group=9, suitItemId=local_suitItemId.suitItemId_27, level=1, suitEffect=local_suitEffect.suitEffect_27},
	{id=10, name="海德拉的黄金套", group=10, suitItemId=local_suitItemId.suitItemId_24, suitCount=10, level=1, suitEffect=local_suitEffect.suitEffect_24},
	{id=11, name="菲斯特的白金套", group=11, suitItemId=local_suitItemId.suitItemId_26, suitCount=10, level=1, suitEffect=local_suitEffect.suitEffect_26},
	{id=12, name="汉斯的龙王套", group=12, suitItemId=local_suitItemId.suitItemId_28, level=1, suitEffect=local_suitEffect.suitEffect_28},
	{id=13, name="安东尼斯的魔王套", group=13, suitItemId=local_suitItemId.suitItemId_29, suitCount=12, level=1, suitEffect={{2,10001,20},{3,311022,1000},{4,206022,500},{5,10003,15},{6,209011,50,303012,1000,305012,1000,207011,50,208011,50}}},
	{id=14, name="奥维兰的革套", group=14, suitItemId=local_suitItemId.suitItemId_31, suitCount=14, level=1, suitEffect=local_suitEffect.suitEffect_30},
	{id=15, name="奥维兰的强化革套", group=15, suitItemId=local_suitItemId.suitItemId_32, suitCount=6, level=1, suitEffect=local_suitEffect.suitEffect_31},
	{id=16, name="索尔思的骷髅套", group=16, suitItemId=local_suitItemId.suitItemId_33, level=1, suitEffect=local_suitEffect.suitEffect_32},
	{id=17, name="索尔思的强化骷髅套", group=17, suitItemId=local_suitItemId.suitItemId_34, level=1, suitEffect=local_suitEffect.suitEffect_33},
	{id=18, name="安东尼斯的强化魔王套", group=18, suitItemId=local_suitItemId.suitItemId_30, suitCount=6, level=1, suitEffect=local_suitEffect.suitEffect_29},
	{id=19, name="帕希的传说套", group=19, suitItemId=local_suitItemId.suitItemId_35, level=1, suitEffect=local_suitEffect.suitEffect_34},
	{id=20, name="帕希的强化传说套", group=20, suitItemId=local_suitItemId.suitItemId_16, level=1, suitEffect=local_suitEffect.suitEffect_16},
	{id=21, name="凯文的亚特兰蒂斯套", group=21, suitItemId=local_suitItemId.suitItemId_15, level=1, suitEffect=local_suitEffect.suitEffect_15},
	{id=22, name="凯文的强化亚特兰蒂斯套", group=22, suitItemId=local_suitItemId.suitItemId_14, level=1, suitEffect=local_suitEffect.suitEffect_14},
	{id=23, name="希尔芙的藤套", group=23, suitItemId=local_suitItemId.suitItemId_13, suitCount=12, level=1, suitEffect=local_suitEffect.suitEffect_13},
	{id=24, name="希尔芙的强化藤套", group=24, suitItemId=local_suitItemId.suitItemId_12, level=1, suitEffect=local_suitEffect.suitEffect_12},
	{id=25, name="洛迪丝的天蚕套", group=25, suitItemId=local_suitItemId.suitItemId_11, suitCount=10, level=1, suitEffect=local_suitEffect.suitEffect_11},
	{id=26, name="罗拉娜的风套", group=26, suitItemId=local_suitItemId.suitItemId_7, suitCount=10, level=1, suitEffect=local_suitEffect.suitEffect_7},
	{id=27, name="罗拉娜的强化风套", group=27, suitItemId=local_suitItemId.suitItemId_6, suitCount=4, level=1, suitEffect=local_suitEffect.suitEffect_6},
	{id=28, name="玫菲尔的精灵套", group=28, suitItemId=local_suitItemId.suitItemId_5, suitCount=6, level=1, suitEffect=local_suitEffect.suitEffect_5},
	{id=29, name="玫菲尔的强化精灵套", group=29, suitItemId=local_suitItemId.suitItemId_4, suitCount=6, level=1, suitEffect=local_suitEffect.suitEffect_4},
	{id=30, name="安吉拉的女神套", group=30, suitItemId=local_suitItemId.suitItemId_3, suitCount=10, level=1, suitEffect=local_suitEffect.suitEffect_3},
	{id=31, name="安吉拉的强化女神套", group=31, suitItemId=local_suitItemId.suitItemId_2, level=1, suitEffect=local_suitEffect.suitEffect_2},
	{id=32, name="露西的红翼套", group=32, suitItemId=local_suitItemId.suitItemId_1, level=1, suitEffect=local_suitEffect.suitEffect_1},
	{id=33, name="露西的强化红翼套", group=33, suitItemId=local_suitItemId.suitItemId_10, level=1, suitEffect=local_suitEffect.suitEffect_10},
	{id=34, name="阿莱斯的圣魂套", group=34, suitItemId=local_suitItemId.suitItemId_9, level=1, suitEffect=local_suitEffect.suitEffect_9},
	{id=35, name="阿莱斯的强化圣魂套", group=35, suitItemId=local_suitItemId.suitItemId_8, level=1, suitEffect=local_suitEffect.suitEffect_8},
	{id=36, name="卓越的露西的红翼套", group=32, suitItemId=local_suitItemId.suitItemId_1, suitEffect=local_suitEffect.suitEffect_1},
	{id=37, name="卓越的安吉拉的强化女神套", group=31, suitItemId=local_suitItemId.suitItemId_2, suitEffect=local_suitEffect.suitEffect_2},
	{id=38, name="卓越的安吉拉的女神套", group=30, suitItemId=local_suitItemId.suitItemId_3, suitCount=10, suitEffect=local_suitEffect.suitEffect_3},
	{id=39, name="卓越的玫菲尔的强化精灵套", group=29, suitItemId=local_suitItemId.suitItemId_4, suitCount=6, suitEffect=local_suitEffect.suitEffect_4},
	{id=40, name="卓越的玫菲尔的精灵套", group=28, suitItemId=local_suitItemId.suitItemId_5, suitCount=6, suitEffect=local_suitEffect.suitEffect_5},
	{id=41, name="卓越的罗拉娜的强化风套", group=27, suitItemId=local_suitItemId.suitItemId_6, suitCount=4, suitEffect=local_suitEffect.suitEffect_6},
	{id=42, name="卓越的罗拉娜的风套", group=26, suitItemId=local_suitItemId.suitItemId_7, suitCount=10, suitEffect=local_suitEffect.suitEffect_7},
	{id=43, name="卓越的阿莱斯的强化圣魂套", group=35, suitItemId=local_suitItemId.suitItemId_8, suitEffect=local_suitEffect.suitEffect_8},
	{id=44, name="卓越的阿莱斯的圣魂套", group=34, suitItemId=local_suitItemId.suitItemId_9, suitEffect=local_suitEffect.suitEffect_9},
	{id=45, name="卓越的露西的强化红翼套", group=33, suitItemId=local_suitItemId.suitItemId_10, suitEffect=local_suitEffect.suitEffect_10},
	{id=46, name="卓越的洛迪丝的天蚕套", group=25, suitItemId=local_suitItemId.suitItemId_11, suitCount=10, suitEffect=local_suitEffect.suitEffect_11},
	{id=47, name="卓越的希尔芙的强化藤套", group=24, suitItemId=local_suitItemId.suitItemId_12, suitEffect=local_suitEffect.suitEffect_12},
	{id=48, name="卓越的希尔芙的藤套", group=23, suitItemId=local_suitItemId.suitItemId_13, suitCount=12, suitEffect=local_suitEffect.suitEffect_13},
	{id=49, name="卓越的凯文的强化亚特兰蒂斯套", group=22, suitItemId=local_suitItemId.suitItemId_14, suitEffect=local_suitEffect.suitEffect_14},
	{id=50, name="卓越的凯文的亚特兰蒂斯套", group=21, suitItemId=local_suitItemId.suitItemId_15, suitEffect=local_suitEffect.suitEffect_15},
	{id=51, name="卓越的帕希的强化传说套", group=20, suitItemId=local_suitItemId.suitItemId_16, suitEffect=local_suitEffect.suitEffect_16},
	{id=52, name="卓越的哈德的皮套", group=1, suitCount=14},
	{id=53, name="卓越的哈德的强化皮套", group=4, suitItemId=local_suitItemId.suitItemId_18, suitEffect=local_suitEffect.suitEffect_18},
	{id=54, name="卓越的瑞恩的青铜套", group=2, suitItemId=local_suitItemId.suitItemId_19, suitCount=6, suitEffect=local_suitEffect.suitEffect_19},
	{id=55, name="卓越的瑞恩的强化青铜套", group=5, suitItemId=local_suitItemId.suitItemId_20, suitCount=6, suitEffect=local_suitEffect.suitEffect_20},
	{id=56, name="卓越的赫兰德的翡翠套", group=3, suitItemId=local_suitItemId.suitItemId_21, suitCount=10, suitEffect=local_suitEffect.suitEffect_21},
	{id=57, name="卓越的赫兰德的强化翡翠套", group=6, suitItemId=local_suitItemId.suitItemId_22, suitCount=10, suitEffect=local_suitEffect.suitEffect_22},
	{id=58, name="卓越的海德拉的强化黄金套", group=7, suitItemId=local_suitItemId.suitItemId_23, suitCount=4, suitEffect=local_suitEffect.suitEffect_23},
	{id=59, name="卓越的海德拉的黄金套", group=10, suitItemId=local_suitItemId.suitItemId_24, suitCount=10, suitEffect=local_suitEffect.suitEffect_24},
	{id=60, name="卓越的菲斯特的强化白金套", group=8, suitItemId=local_suitItemId.suitItemId_25, suitCount=6, suitEffect=local_suitEffect.suitEffect_25},
	{id=61, name="卓越的菲斯特的白金套", group=11, suitItemId=local_suitItemId.suitItemId_26, suitCount=10, suitEffect=local_suitEffect.suitEffect_26},
	{id=62, name="卓越的汉斯的强化龙王套", group=9, suitItemId=local_suitItemId.suitItemId_27, suitEffect=local_suitEffect.suitEffect_27},
	{id=63, name="卓越的汉斯的龙王套", group=12, suitItemId=local_suitItemId.suitItemId_28, suitEffect=local_suitEffect.suitEffect_28},
	{id=64, name="卓越的安东尼斯的魔王套", group=13, suitItemId=local_suitItemId.suitItemId_29, suitCount=12, suitEffect={{2,10001,15},{3,311022,1000},{4,206022,500},{5,10003,15},{6,209011,50,303012,1000,305012,1000,207011,50,208011,50}}},
	{id=65, name="卓越的安东尼斯的强化魔王套", group=18, suitItemId=local_suitItemId.suitItemId_30, suitCount=6, suitEffect=local_suitEffect.suitEffect_29},
	{id=66, name="卓越的奥维兰的革套", group=14, suitItemId=local_suitItemId.suitItemId_31, suitCount=14, suitEffect=local_suitEffect.suitEffect_30},
	{id=67, name="卓越的奥维兰的强化革套", group=15, suitItemId=local_suitItemId.suitItemId_32, suitCount=6, suitEffect=local_suitEffect.suitEffect_31},
	{id=68, name="卓越的索尔思的骷髅套", group=16, suitItemId=local_suitItemId.suitItemId_33, suitEffect=local_suitEffect.suitEffect_32},
	{id=69, name="卓越的索尔思的强化骷髅套", group=17, suitItemId=local_suitItemId.suitItemId_34, suitEffect=local_suitEffect.suitEffect_33},
	{id=70, name="卓越的帕希的传说套", group=19, suitItemId=local_suitItemId.suitItemId_35, suitEffect=local_suitEffect.suitEffect_34},
	{id=71, name="卓越的密诺瓦的圣职者套", group=36, suitItemId=local_suitItemId.suitItemId_36, suitCount=10, suitEffect=local_suitEffect.suitEffect_35},
	{id=72, name="密诺瓦的圣职者套", group=36, suitItemId=local_suitItemId.suitItemId_36, suitCount=10, suitEffect=local_suitEffect.suitEffect_35},
	{id=73, name="卓越的的海姆达尔的闪光套", group=37, suitItemId=local_suitItemId.suitItemId_37, suitCount=10, suitEffect=local_suitEffect.suitEffect_36},
	{id=74, name="海姆达尔的闪光套", group=37, suitItemId=local_suitItemId.suitItemId_37, suitCount=10, suitEffect=local_suitEffect.suitEffect_36},
	{id=75, name="玛古斯之魔焰套", group=38, suitItemId=local_suitItemId.suitItemId_38, suitEffect=local_suitEffect.suitEffect_37},
	{id=76, name="卓越的玛古斯之魔焰套", group=38, suitItemId=local_suitItemId.suitItemId_38, suitEffect=local_suitEffect.suitEffect_37},
	{id=77, name="巴德尔之魔焰套", group=39, suitItemId=local_suitItemId.suitItemId_39, suitEffect=local_suitEffect.suitEffect_38},
	{id=78, name="卓越的巴德尔之魔焰套", group=39, suitItemId=local_suitItemId.suitItemId_39, suitEffect=local_suitEffect.suitEffect_38},
	{id=666, name="测试法师套装", group=666, suitItemId={66666603,66666604,66666605,66666606,66666607}, suitCount=5, level=0, suitEffect=local_suitEffect.suitEffect_39},
	{id=777, name="测试弓箭手套装", group=777, suitItemId={77777703,77777704,77777705,77777706,77777707}, suitCount=5, level=0, suitEffect=local_suitEffect.suitEffect_39},
	{id=888, name="测试战士套装", group=888, suitItemId={88888802,88888803,88888804,88888805,88888806}, suitCount=5, level=0, suitEffect=local_suitEffect.suitEffect_39},
	{id=1001, name="一代耳环", group=1001, suitItemId={21200101,21200111}, suitCount=2, level=1, suitEffect={{2,317012,100,303012,400}}},
	{id=1002, name="二代耳环", group=1002, suitItemId={21200201,21200211}, suitCount=2, level=1, suitEffect={{2,317012,200,303012,800}}},
	{id=1003, name="三代耳环", group=1003, suitItemId={21200301,21200311}, suitCount=2, level=1, suitEffect={{2,317012,500,303012,1200}}},
}

local defaults = {suitType=0, suitItemId={20410131,20610131,20710131,20810131,20910131,21100013,20451,20410151,20610151,20710151,20810151,20910151,21100015,20452}, suitCount=8, level=2, suitEffect={{2,10001,10},{3,320011,10},{4,1031,20},{5,302051,5},{6,206011,20},{7,10002,10,305012,500,303012,500,10001,25}}, suitSkill={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_suit) do
	setmetatable(v, mt)
end

return cfg_equip_suit