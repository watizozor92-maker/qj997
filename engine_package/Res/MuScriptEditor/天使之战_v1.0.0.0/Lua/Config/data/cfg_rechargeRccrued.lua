-- 此文件工具自动生成，不要修改
---@class cfg_rechargeRccrued_column
---可被调用的唯一id
---@field id number @唯一id column=1 A
---显示在界面中的文本
---@field text string @策划备注 column=2 B
---用于读取cfg_OperateActivity_all中的mainGroup字段
---@field mainGroup number @活动组id column=3 C
---1,活动期间充值的金额计入 0,所有充值计入
---@field type number @充值类型 column=4 D
---达成对应金额才会显示该档位，不填表示直接显示
---@field showCount number @显示参数 column=5 E
---获取该档位奖励信息，读取Count_count中的id字段
---@field Countkey number @累充档位 column=6 F
---需要充值的具体金额
---@field amount number @累充金额 column=7 G
---格式：id#数量|道具id#数量#领取职业id，不填职业就是没有限制（道具id在cfg_item中查找）
---@field reward IntListList @奖励道具 column=8 H
---格式：槽位1#特效ID|槽位2#特效ID
---0/空代表不生效
---@field effect IntListList @奖励特效 column=9 I

local local_reward = {
    reward_1={{50030002,2},{50030003,2},{40030014,1}},
    reward_2={{50030004,5},{50030001,20},{40030014,2}},
    reward_3={{50040028,50},{40030014,2},{50030004,5}},
    reward_4={{50040061,60},{50040028,80},{50030005,1}},
    reward_5={{50040097,80},{50040028,200},{50030005,2}},
    reward_6={{50040097,100},{50040061,80},{50030005,5}},
    reward_7={{21600055,1},{50010010,100},{50030005,5}},
    reward_8={{10040001,10},{10020001,1000}},
    reward_9={{10040001,200},{50030004,10},{10020001,6000}},
    reward_10={{10040001,400},{50040061,20},{10020001,10000}},
    reward_11={{10040001,600},{50010010,100},{10020001,15000}},
    reward_12={{10040001,1000},{50010010,200},{10020001,20000}},
    reward_13={{10040001,2000},{40011401,3},{10020001,25000}},
    reward_14={{10040001,3500},{40011402,2},{10020001,30000}},
    reward_15={{10040001,5000},{40011403,1},{10020001,35000}},
    reward_16={{50040100,5},{40030014,2},{50030004,5}},
    reward_17={{50040061,80},{50040100,10},{50030005,1}},
    reward_18={{50040097,90},{50040061,100},{50030005,2}},
    reward_19={{50040097,100},{50040061,150},{50030005,5}},
    reward_20={{21600053 ,1},{50010010,200},{50030005,5}},
    reward_21={{10040001,200},{50040100,2},{10020001,6000}},
    reward_22={{10040001,400},{50030005,1},{10020001,10000}},
    reward_23={{10040001,1000},{50040061,50},{10020001,20000}},
    reward_24={{10040001,2000},{50010010,300},{10020001,25000}},
    reward_25={{10040001,3500},{40011403,2},{10020001,30000}},
    reward_26={{10040001,5000},{40011404,1},{10020001,35000}},
    reward_27={{50040100,10},{40030014,5},{50030004,5}},
    reward_28={{50040061,90},{50040100,10},{50030005,1}},
    reward_29={{21600049,1},{50010010,300},{50030005,5}},
    reward_30={{10040001,200},{50040100,5},{10020001,6000}},
    reward_31={{10040001,400},{50030005,2},{10020001,10000}},
    reward_32={{10040001,600},{50010010,200},{10020001,15000}},
    reward_33={{10040001,1000},{50040061,100},{10020001,20000}},
    reward_34={{10040001,2000},{50010010,500},{10020001,25000}},
    reward_35={{10040001,3500},{40011404,2},{10020001,30000}},
    reward_36={{10040001,5000},{40011405,1},{10020001,35000}},
    reward_37={{50030002,1},{10020001,1000}},
    reward_38={{50030004,1},{50030001,10},{10020001,6000}},
    reward_39={{50040078,1},{40030014,2},{10020001,10000}},

}

local local_effect = {
    effect_1={},

}

local cfg_rechargeRccrued =
{
	{id=1001, Countkey=16001, reward=local_reward.reward_37},
	{id=1002, text="累计充值6元", Countkey=16002, amount=6, reward=local_reward.reward_38},
	{id=1003, text="累计充值60元", Countkey=16003, amount=60, reward=local_reward.reward_39},
	{id=1004, text="累计充值150元", Countkey=16004, amount=150, reward={{40011401,1},{40030014,5},{10020001,15000}}},
	{id=1005, text="累计充值300元", Countkey=16005, amount=300, reward={{40011402,1},{40011401,1},{10020001,20000}}},
	{id=1006, text="累计充值600元", Countkey=16006, amount=600, reward={{40011402,2},{40011401,2},{10020001,25000}}},
	{id=1007, text="累计充值900元", Countkey=16007, amount=900, reward={{40011403,1},{40011401,3},{10020001,30000}}},
	{id=1008, text="累计充值1200元", Countkey=16008, amount=1200, reward={{40011403,2},{40011402,1},{10020001,35000}}},
	{id=1009, text="累计充值1500元", Countkey=16009, amount=1500, reward={{21500026,1},{40011402,2},{10020001,50000}}},
	{id=1010, mainGroup=2, Countkey=16010},
	{id=1011, text="累计充值30元", mainGroup=2, Countkey=16011, amount=30, reward=local_reward.reward_2},
	{id=1012, text="累计充值90元", mainGroup=2, Countkey=16012, amount=90, reward=local_reward.reward_3},
	{id=1013, text="累计充值200元", mainGroup=2, Countkey=16013, amount=200, reward=local_reward.reward_4},
	{id=1014, text="累计充值500元", mainGroup=2, Countkey=16014, amount=500, reward=local_reward.reward_5},
	{id=1015, text="累计充值800元", mainGroup=2, Countkey=16015, amount=800, reward=local_reward.reward_6},
	{id=1016, text="累计充值1100元", mainGroup=2, Countkey=16016, amount=1100, reward=local_reward.reward_7},
	{id=1017, mainGroup=3, Countkey=16017, reward=local_reward.reward_8},
	{id=1018, text="累计充值30元", mainGroup=3, Countkey=16018, amount=30, reward=local_reward.reward_9},
	{id=1019, text="累计充值90元", mainGroup=3, Countkey=16019, amount=90, reward=local_reward.reward_10},
	{id=1020, text="累计充值200元", mainGroup=3, Countkey=16020, amount=200, reward=local_reward.reward_11},
	{id=1021, text="累计充值500元", mainGroup=3, Countkey=16021, amount=500, reward=local_reward.reward_12},
	{id=1022, text="累计充值1000元", mainGroup=3, Countkey=16022, amount=1000, reward=local_reward.reward_13},
	{id=1023, text="累计充值1500元", mainGroup=3, Countkey=16023, amount=1500, reward=local_reward.reward_14},
	{id=1024, text="累计充值2000元", mainGroup=3, Countkey=16024, amount=2000, reward=local_reward.reward_15},
	{id=1025, mainGroup=4, Countkey=16025},
	{id=1026, text="累计充值30元", mainGroup=4, Countkey=16026, amount=30, reward=local_reward.reward_2},
	{id=1027, text="累计充值90元", mainGroup=4, Countkey=16027, amount=90, reward=local_reward.reward_3},
	{id=1028, text="累计充值200元", mainGroup=4, Countkey=16028, amount=200, reward=local_reward.reward_4},
	{id=1029, text="累计充值500元", mainGroup=4, Countkey=16029, amount=500, reward=local_reward.reward_5},
	{id=1030, text="累计充值800元", mainGroup=4, Countkey=16030, amount=800, reward=local_reward.reward_6},
	{id=1031, text="累计充值1100元", mainGroup=4, Countkey=16031, amount=1100, reward=local_reward.reward_7},
	{id=1032, mainGroup=5, Countkey=16032, reward=local_reward.reward_8},
	{id=1033, text="累计充值30元", mainGroup=5, Countkey=16033, amount=30, reward=local_reward.reward_9},
	{id=1034, text="累计充值90元", mainGroup=5, Countkey=16034, amount=90, reward=local_reward.reward_10},
	{id=1035, text="累计充值200元", mainGroup=5, Countkey=16035, amount=200, reward=local_reward.reward_11},
	{id=1036, text="累计充值500元", mainGroup=5, Countkey=16036, amount=500, reward=local_reward.reward_12},
	{id=1037, text="累计充值1000元", mainGroup=5, Countkey=16037, amount=1000, reward=local_reward.reward_13},
	{id=1038, text="累计充值1500元", mainGroup=5, Countkey=16038, amount=1500, reward=local_reward.reward_14},
	{id=1039, text="累计充值2000元", mainGroup=5, Countkey=16039, amount=2000, reward=local_reward.reward_15},
	{id=1040, mainGroup=6, Countkey=16040},
	{id=1041, text="累计充值30元", mainGroup=6, Countkey=16041, amount=30, reward=local_reward.reward_2},
	{id=1042, text="累计充值90元", mainGroup=6, Countkey=16042, amount=90, reward=local_reward.reward_16},
	{id=1043, text="累计充值200元", mainGroup=6, Countkey=16043, amount=200, reward=local_reward.reward_17},
	{id=1044, text="累计充值500元", mainGroup=6, Countkey=16044, amount=500, reward=local_reward.reward_18},
	{id=1045, text="累计充值800元", mainGroup=6, Countkey=16045, amount=800, reward=local_reward.reward_19},
	{id=1046, text="累计充值1100元", mainGroup=6, Countkey=16046, amount=1100, reward=local_reward.reward_20},
	{id=1047, mainGroup=7, Countkey=16047, reward=local_reward.reward_8},
	{id=1048, text="累计充值30元", mainGroup=7, Countkey=16048, amount=30, reward=local_reward.reward_21},
	{id=1049, text="累计充值90元", mainGroup=7, Countkey=16049, amount=90, reward=local_reward.reward_22},
	{id=1050, text="累计充值200元", mainGroup=7, Countkey=16050, amount=200, reward=local_reward.reward_11},
	{id=1051, text="累计充值500元", mainGroup=7, Countkey=16051, amount=500, reward=local_reward.reward_23},
	{id=1052, text="累计充值1000元", mainGroup=7, Countkey=16052, amount=1000, reward=local_reward.reward_24},
	{id=1053, text="累计充值1500元", mainGroup=7, Countkey=16053, amount=1500, reward=local_reward.reward_25},
	{id=1054, text="累计充值2000元", mainGroup=7, Countkey=16054, amount=2000, reward=local_reward.reward_26},
	{id=1055, mainGroup=8, Countkey=16055},
	{id=1056, text="累计充值30元", mainGroup=8, Countkey=16056, amount=30, reward=local_reward.reward_2},
	{id=1057, text="累计充值90元", mainGroup=8, Countkey=16057, amount=90, reward=local_reward.reward_16},
	{id=1058, text="累计充值200元", mainGroup=8, Countkey=16058, amount=200, reward=local_reward.reward_17},
	{id=1059, text="累计充值500元", mainGroup=8, Countkey=16059, amount=500, reward=local_reward.reward_18},
	{id=1060, text="累计充值800元", mainGroup=8, Countkey=16060, amount=800, reward=local_reward.reward_19},
	{id=1061, text="累计充值1100元", mainGroup=8, Countkey=16061, amount=1100, reward=local_reward.reward_20},
	{id=1062, mainGroup=9, Countkey=16062, reward=local_reward.reward_8},
	{id=1063, text="累计充值30元", mainGroup=9, Countkey=16063, amount=30, reward=local_reward.reward_21},
	{id=1064, text="累计充值90元", mainGroup=9, Countkey=16064, amount=90, reward=local_reward.reward_22},
	{id=1065, text="累计充值200元", mainGroup=9, Countkey=16065, amount=200, reward=local_reward.reward_11},
	{id=1066, text="累计充值500元", mainGroup=9, Countkey=16066, amount=500, reward=local_reward.reward_23},
	{id=1067, text="累计充值1000元", mainGroup=9, Countkey=16067, amount=1000, reward=local_reward.reward_24},
	{id=1068, text="累计充值1500元", mainGroup=9, Countkey=16068, amount=1500, reward=local_reward.reward_25},
	{id=1069, text="累计充值2000元", mainGroup=9, Countkey=16069, amount=2000, reward=local_reward.reward_26},
	{id=1070, mainGroup=10, Countkey=16070},
	{id=1071, text="累计充值30元", mainGroup=10, Countkey=16071, amount=30, reward=local_reward.reward_2},
	{id=1072, text="累计充值90元", mainGroup=10, Countkey=16072, amount=90, reward=local_reward.reward_27},
	{id=1073, text="累计充值200元", mainGroup=10, Countkey=16073, amount=200, reward=local_reward.reward_28},
	{id=1074, text="累计充值500元", mainGroup=10, Countkey=16074, amount=500, reward=local_reward.reward_18},
	{id=1075, text="累计充值800元", mainGroup=10, Countkey=16075, amount=800, reward=local_reward.reward_19},
	{id=1076, text="累计充值1100元", mainGroup=10, Countkey=16076, amount=1100, reward=local_reward.reward_29},
	{id=1077, mainGroup=11, Countkey=16077, reward=local_reward.reward_8},
	{id=1078, text="累计充值30元", mainGroup=11, Countkey=16078, amount=30, reward=local_reward.reward_30},
	{id=1079, text="累计充值90元", mainGroup=11, Countkey=16079, amount=90, reward=local_reward.reward_31},
	{id=1080, text="累计充值200元", mainGroup=11, Countkey=16080, amount=200, reward=local_reward.reward_32},
	{id=1081, text="累计充值500元", mainGroup=11, Countkey=16081, amount=500, reward=local_reward.reward_33},
	{id=1082, text="累计充值1000元", mainGroup=11, Countkey=16082, amount=1000, reward=local_reward.reward_34},
	{id=1083, text="累计充值1500元", mainGroup=11, Countkey=16083, amount=1500, reward=local_reward.reward_35},
	{id=1084, text="累计充值2000元", mainGroup=11, Countkey=16084, amount=2000, reward=local_reward.reward_36},
	{id=1085, mainGroup=12, Countkey=16085},
	{id=1086, text="累计充值30元", mainGroup=12, Countkey=16086, amount=30, reward=local_reward.reward_2},
	{id=1087, text="累计充值90元", mainGroup=12, Countkey=16087, amount=90, reward=local_reward.reward_27},
	{id=1088, text="累计充值200元", mainGroup=12, Countkey=16088, amount=200, reward=local_reward.reward_28},
	{id=1089, text="累计充值500元", mainGroup=12, Countkey=16089, amount=500, reward=local_reward.reward_18},
	{id=1090, text="累计充值800元", mainGroup=12, Countkey=16090, amount=800, reward=local_reward.reward_19},
	{id=1091, text="累计充值1100元", mainGroup=12, Countkey=16091, amount=1100, reward=local_reward.reward_29},
	{id=1092, mainGroup=13, Countkey=16092, reward=local_reward.reward_8},
	{id=1093, text="累计充值30元", mainGroup=13, Countkey=16093, amount=30, reward=local_reward.reward_30},
	{id=1094, text="累计充值90元", mainGroup=13, Countkey=16094, amount=90, reward=local_reward.reward_31},
	{id=1095, text="累计充值200元", mainGroup=13, Countkey=16095, amount=200, reward=local_reward.reward_32},
	{id=1096, text="累计充值500元", mainGroup=13, Countkey=16096, amount=500, reward=local_reward.reward_33},
	{id=1097, text="累计充值1000元", mainGroup=13, Countkey=16097, amount=1000, reward=local_reward.reward_34},
	{id=1098, text="累计充值1500元", mainGroup=13, Countkey=16098, amount=1500, reward=local_reward.reward_35},
	{id=1099, text="累计充值2000元", mainGroup=13, Countkey=16099, amount=2000, reward=local_reward.reward_36},
	{id=1100, mainGroup=14, Countkey=16100, reward=local_reward.reward_37},
	{id=1101, text="累计充值6元", mainGroup=14, Countkey=16101, amount=6, reward=local_reward.reward_38},
	{id=1102, text="累计充值60元", mainGroup=14, Countkey=16102, amount=60, reward=local_reward.reward_39},
	{id=1103, text="累计充值150元", mainGroup=14, Countkey=16103, amount=150, reward={{40011403,1},{40030014,5},{10020001,15000}}},
	{id=1104, text="累计充值300元", mainGroup=14, Countkey=16104, amount=300, reward={{40011403,2},{40011401,1},{10020001,20000}}},
	{id=1105, text="累计充值600元", mainGroup=14, Countkey=16105, amount=600, reward={{40011404,1},{40011401,2},{10020001,25000}}},
	{id=1106, text="累计充值900元", mainGroup=14, Countkey=16106, amount=900, reward={{40011404,2},{40011401,3},{10020001,30000}}},
	{id=1107, text="累计充值1200元", mainGroup=14, Countkey=16107, amount=1200, reward={{40011405,1},{40011402,1},{10020001,35000}}},
	{id=1108, text="累计充值1500元", mainGroup=14, Countkey=16108, amount=1500, reward={{21500027,1},{40011402,2},{10020001,50000}}},
}

local defaults = {text="累计充值0元", mainGroup=1, type=1, showCount=0, amount=0, reward={{50030002,2},{50030003,2},{40030014,1}}, effect={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_rechargeRccrued) do
	setmetatable(v, mt)
end

return cfg_rechargeRccrued