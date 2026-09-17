-- 此文件工具自动生成，不要修改
---@class synhtesis_yingshi_column
---@field id number @配方ID#客户端#C column=1 A
---合成后的道具ID 定向道具没有不用配 同一组的合成物定向道具唯一
---格式：道具id#数量#权重#定向道具id|道具id#权重#定向道具id
---@field productId IntListList @合成物#客户端#C column=2 B
---1、荧光宝石合成 2、荧之石抽取  3、镶嵌荧光宝石 4、抽取荧光宝石 5、荧光宝石升级
---@field synthesisType IntList @合成类型 column=3 C
---用于处理父类别下合成公式内容如何展示
---填1，则主要、次要、辅助材料都要直接展示给玩家
---填2，则只展示次要、辅助材料
---不填或填0，则都不展示，按默认的全问号处理
---*若父类别下有多行配置，此处又有对应显示配置，则展示父类别下第一行配置的对应内容
---*若合成材料为通过条件筛选的类型，不是明确的道具，则不要做对应显示配置，显示不出来会报错！
---@field typeShow number @父类别公式显示 column=4 D
---填0或者空的话=直接根据唯一id顺序 展示在父级页签下
---每个类别名称需一致，若不一致，则整个类别都不展示
---@field subType number @子类别 column=5 E
---@field name string @合成公式名称#客户端#C column=6 F
---合成炉为空时的显示
---@field descriptiondefault string @默认描述 column=7 G
---合成道具如果有进度则需要进度时间，单位毫秒
---@field composeTime string @合成时间 column=8 H
---满足了等级才会显示该合成配方
---格式：直接填等级
---@field level number @等级限制 column=9 I
---满足了职业才会显示该合成配方
---格式：所属职业#职业等级|所属职业#职业等级
---@field career IntListList @职业限制 column=10 J
---合成类型=1，固定道具
---合成类型#道具id#数量
---合成类型=2，大类消耗
---合成类型#强化等级#追加等级#品质需求#类别需求#数量（数量默认为1）
---品质需求（关联cfg_item表Outstanding）：0=白装装备，1=卓越装备，2=套装装备，99=不限
---类别需求（关联cfg_item表Mixtype）：0=不限，1=一代翅膀，2=二代翅膀，3=三代翅膀，4=洞装，5=首饰，6=玛雅武器, 其余未定义类别关联cfg_item表useLevelLimit字段
---合成类型3 卡槽数量（大于等于1）装备|荧光宝石
---合成类型4（镶嵌有荧光宝石的物品）
---合成类型5 荧光宝石|荧光宝石
---
---@field consumeItemMain IntListList @公式主要材料 column=11 K
---合成类型=1，固定道具
---合成类型#道具id#数量
---合成类型=2，大类消耗
---合成类型#强化等级#追加等级#品质需求#类别需求#指定道具的cfgId#数量（数量默认为1）
---品质需求（关联cfg_item表Outstanding）：0=白装装备，1=卓越装备，2=套装装备，99=不限
---类别需求（关联cfg_item表Mixtype）：0=不限，1=一代翅膀，2=二代翅膀，3=三代翅膀，4=洞装，5=首饰，6=玛雅武器, 其余未定义类别关联cfg_item表useLevelLimit字段
---@field consumeItem IntListList @公式次要材料 column=12 L
---万分比
---@field successRate string @前端显示成功几率 column=13 M
---万分比
---@field successRateReal string @后端真实成功几率 column=14 N
---万分比
---@field successRateMax string @最大成功率 column=15 O
---0或者空=显示成功率
---2=不显示
---@field successOpen number @成功率显示开关 column=16 P
---0或空=不使用转移功能
---1=开启转移
---将consumeItem字段的顺序第一个的材料的强化、追加、幸运、叠加属性 全复制到合成物上
---若开启转移 但 第一个材料或者合成物任意一个都不支持强化、追加、幸运、叠加，则等于不使用转移功能
---@field transfer number @强化、追加、幸运、叠加转移 column=17 Q
---合成的时候是否继承卓越词条
---1继承
---0或不填 不继承
---@field inheritEntry number @卓越词条继承 column=18 R
---合成失败次数乘以保底概率=提供的额外成功率
---格式 万比
---@field guarantees number @保底概率 column=19 S
---显示在界面上的条件
---关联cfg_condition_out表
---@field showCondition string @显示条件 column=20 T
---需要满足的条件
---关联cfg_condition_out表
---@field synthesisCondition string @合成条件 column=21 U
---关联NPC表，用于区分该合成方案在哪个NPC面板上
---@field npcid number @关联NPC column=22 V
---道具id#数量
---@field coin IntList @背包非显示道具的消耗 column=23 W
---@field synthesisname string @对应页签 column=24 X
---@field description string @介绍文字 column=25 Y

local local_productId = {
    productId_1={},

}

local local_synthesisType = {
    synthesisType_1={1},
    synthesisType_2={5},

}

local local_career = {
    career_1={},

}

local local_consumeItem = {
    consumeItem_1={{1,1253000599,1},{1,1253000199,1}},
    consumeItem_2={{1,2100103,5}},
    consumeItem_3={{1,2100103,6}},
    consumeItem_4={{1,2100103,7}},
    consumeItem_5={{1,2100103,8}},
    consumeItem_6={{1,2100103,12}},
    consumeItem_7={{1,2100103,13}},
    consumeItem_8={{1,2100103,15}},
    consumeItem_9={{1,2100103,4}},
    consumeItem_10={{1,2100103,10}},
    consumeItem_11={{1,2100103,11}},
    consumeItem_12={{1,2100103,17}},

}

local local_coin = {
    coin_1={10010002,4000},
    coin_2={10010002,10000000},
    coin_3={10010002,22000000},
    coin_4={10010002,25000000},
    coin_5={10010002,28000000},
    coin_6={10010002,34000000},
    coin_7={10010002,40000000},
    coin_8={10010002,55000000},
    coin_9={10010002,12000000},
    coin_10={10010002,16000000},
    coin_11={10010002,20000000},
    coin_12={10010002,30000000},
    coin_13={10010002,32000000},
    coin_14={10010002,42000000},
    coin_15={10010002,47000000},
    coin_16={10010002,50000000},
    coin_17={10010002,52000000},
    coin_18={10010002,60000000},
    coin_19={10010002,62000000},
    coin_20={10010002,15000000},
    coin_21={10010002,35000000},
    coin_22={10010002,45000000},
    coin_23={10010002,17000000},
    coin_24={10010002,23000000},
    coin_25={10010002,46000000},
    coin_26={10010002,53000000},

}

local synhtesis_yingshi =
{
	{id=10001, productId={{50031101,1,100}}, synthesisType=local_synthesisType.synthesisType_1, composeTime="1000", level=1, consumeItemMain={{1,50030101,1},{1,50030201,1}}, consumeItem=local_consumeItem.consumeItem_1, successRate="10000", successRateReal="10000", successRateMax="10000", npcid=100404, synthesisname="荧光宝石合成", description="你可以将荧之石和光之石合成为荧光宝石"},
	{id=10002, productId={{50031201,1,100}}, synthesisType=local_synthesisType.synthesisType_1, composeTime="1000", level=1, consumeItemMain={{1,50030101,1},{1,50030305,1}}, consumeItem=local_consumeItem.consumeItem_1, successRate="9900", successRateReal="9900", successRateMax="9900", npcid=100404, synthesisname="荧光宝石合成", description="你可以将荧之石和光之石合成为荧光宝石"},
	{id=10003, productId={{50031301,1,100}}, synthesisType=local_synthesisType.synthesisType_1, composeTime="1000", level=1, consumeItemMain={{1,50030101,1},{1,50030401,1}}, consumeItem=local_consumeItem.consumeItem_1, successRate="9700", successRateReal="9700", successRateMax="9700", npcid=100404, synthesisname="荧光宝石合成", description="你可以将荧之石和光之石合成为荧光宝石"},
	{id=10004, productId={{50031401,1,100}}, synthesisType=local_synthesisType.synthesisType_1, composeTime="1000", level=1, consumeItemMain={{1,50030101,1},{1,50030504,1}}, consumeItem=local_consumeItem.consumeItem_1, successRate="9500", successRateReal="9500", successRateMax="9500", npcid=100404, synthesisname="荧光宝石合成", description="你可以将荧之石和光之石合成为荧光宝石"},
	{id=10005, productId={{50031501,1,100}}, synthesisType=local_synthesisType.synthesisType_1, composeTime="1000", level=1, consumeItemMain={{1,50030101,1},{1,50030604,1}}, consumeItem=local_consumeItem.consumeItem_1, successRate="9500", successRateReal="9500", successRateMax="9500", npcid=100404, synthesisname="荧光宝石合成", description="你可以将荧之石和光之石合成为荧光宝石"},
	{id=10006, productId={{50031601,1,100}}, synthesisType=local_synthesisType.synthesisType_1, composeTime="1000", level=1, consumeItemMain={{1,50030101,1},{1,50030701,1}}, consumeItem=local_consumeItem.consumeItem_1, successRate="9300", successRateReal="9300", successRateMax="9300", npcid=100404, synthesisname="荧光宝石合成", description="你可以将荧之石和光之石合成为荧光宝石"},
	{id=10007, synthesisType={2}, composeTime="1000", level=1, consumeItem={{1,50030008,1},{1,1253000599,1},{1,1253000199,1}}, successRate="9300", successRateReal="9300", successRateMax="9300", npcid=100404, coin={10010002,60000}, synthesisname="荧之石抽取", description="你可以从高品质的装备中抽取荧之石"},
	{id=10008, productId=local_productId.productId_1, synthesisType={3}, composeTime="1000", level=1, consumeItemMain={{3}}, consumeItem=local_consumeItem.consumeItem_1, successRate="9000", successRateReal="9000", successRateMax="9000", npcid=100404, coin={10010002,120000}, synthesisname="镶嵌荧光宝石", description="你可以将荧石宝石和带孔的镶嵌装备进行组合，变成带萤石镶嵌的物品"},
	{id=10009, productId=local_productId.productId_1, synthesisType={4}, composeTime="1000", level=1, consumeItemMain={{4}}, consumeItem=local_consumeItem.consumeItem_1, successRate="9000", successRateReal="9000", successRateMax="9000", npcid=100404, coin={10010002,240000}, synthesisname="抽取荧光宝石", description="你可以从镶嵌完成的装备中提取荧石，并保持荧石的等级"},
	{id=10010, productId={{50031102,1,1}}, composeTime="1000", level=1, consumeItemMain={{1,50031101,1},{1,50031101,1}}, consumeItem=local_consumeItem.consumeItem_9, npcid=100404, coin={10010002,9500000}, synthesisname="荧光宝石升级", description="你可以提高镶嵌宝石的等级，例如你可以将4级荧光宝石升级为5级"},
	{id=10011, productId={{50031103,1,1}}, consumeItemMain={{1,50031102,1},{1,50031102,1}}, coin=local_coin.coin_2},
	{id=10012, productId={{50031104,1,1}}, consumeItemMain={{1,50031103,1},{1,50031103,1}}, coin=local_coin.coin_9},
	{id=10013, productId={{50031105,1,1}}, consumeItemMain={{1,50031104,1},{1,50031104,1}}, coin=local_coin.coin_20},
	{id=10014, productId={{50031106,1,1}}, consumeItemMain={{1,50031105,1},{1,50031105,1}}, consumeItem=local_consumeItem.consumeItem_3, coin=local_coin.coin_11},
	{id=10015, productId={{50031107,1,1}}, consumeItemMain={{1,50031106,1},{1,50031106,1}}, consumeItem=local_consumeItem.consumeItem_3, coin=local_coin.coin_3},
	{id=10016, productId={{50031108,1,1}}, consumeItemMain={{1,50031107,1},{1,50031107,1}}, consumeItem=local_consumeItem.consumeItem_4, coin=local_coin.coin_4},
	{id=10017, productId={{50031109,1,1}}, consumeItemMain={{1,50031108,1},{1,50031108,1}}, consumeItem=local_consumeItem.consumeItem_4, coin=local_coin.coin_5},
	{id=10018, productId={{50031110,1,1}}, consumeItemMain={{1,50031109,1},{1,50031109,1}}, consumeItem=local_consumeItem.consumeItem_5, coin=local_coin.coin_12},
	{id=10019, productId={{50031111,1,1}}, consumeItemMain={{1,50031110,1},{1,50031110,1}}, consumeItem=local_consumeItem.consumeItem_5, coin=local_coin.coin_13},
	{id=10020, productId={{50031112,1,1}}, consumeItemMain={{1,50031111,1},{1,50031111,1}}, consumeItem=local_consumeItem.consumeItem_10, coin=local_coin.coin_6},
	{id=10021, productId={{50031113,1,1}}, consumeItemMain={{1,50031112,1},{1,50031112,1}}, consumeItem=local_consumeItem.consumeItem_11, coin={10010002,36000000}},
	{id=10022, productId={{50031114,1,1}}, consumeItemMain={{1,50031113,1},{1,50031113,1}}, consumeItem=local_consumeItem.consumeItem_6, coin={10010002,38000000}},
	{id=10023, productId={{50031115,1,1}}, consumeItemMain={{1,50031114,1},{1,50031114,1}}, consumeItem=local_consumeItem.consumeItem_6, coin=local_coin.coin_7},
	{id=10024, productId={{50031116,1,1}}, consumeItemMain={{1,50031115,1},{1,50031115,1}}, consumeItem=local_consumeItem.consumeItem_7, coin=local_coin.coin_14},
	{id=10025, productId={{50031117,1,1}}, consumeItemMain={{1,50031116,1},{1,50031116,1}}, consumeItem=local_consumeItem.consumeItem_7, coin=local_coin.coin_8},
	{id=10026, productId={{50031118,1,1}}, consumeItemMain={{1,50031117,1},{1,50031117,1}}, consumeItem=local_consumeItem.consumeItem_8, coin={10010002,58000000}},
	{id=10027, productId={{50031119,1,1}}, consumeItemMain={{1,50031118,1},{1,50031118,1}}, consumeItem=local_consumeItem.consumeItem_8, coin={10010002,61000000}},
	{id=10028, productId={{50031120,1,1}}, consumeItemMain={{1,50031119,1},{1,50031119,1}}, consumeItem=local_consumeItem.consumeItem_12, coin={10010002,64000000}},
	{id=10029, productId={{50031202,1,1}}, consumeItemMain={{1,50031201,1},{1,50031201,1}}, consumeItem=local_consumeItem.consumeItem_9, coin=local_coin.coin_2},
	{id=10030, productId={{50031203,1,1}}, consumeItemMain={{1,50031202,1},{1,50031202,1}}, coin={10010002,13000000}},
	{id=10031, productId={{50031204,1,1}}, consumeItemMain={{1,50031203,1},{1,50031203,1}}, coin=local_coin.coin_10},
	{id=10032, productId={{50031205,1,1}}, consumeItemMain={{1,50031204,1},{1,50031204,1}}, coin={10010002,19000000}},
	{id=10033, productId={{50031206,1,1}}, consumeItemMain={{1,50031205,1},{1,50031205,1}}, consumeItem=local_consumeItem.consumeItem_3, coin=local_coin.coin_3},
	{id=10034, productId={{50031207,1,1}}, consumeItemMain={{1,50031206,1},{1,50031206,1}}, consumeItem=local_consumeItem.consumeItem_3, coin=local_coin.coin_4},
	{id=10035, productId={{50031208,1,1}}, consumeItemMain={{1,50031207,1},{1,50031207,1}}, consumeItem=local_consumeItem.consumeItem_4, coin=local_coin.coin_5},
	{id=10036, productId={{50031209,1,1}}, consumeItemMain={{1,50031208,1},{1,50031208,1}}, consumeItem=local_consumeItem.consumeItem_4, coin={10010002,31000000}},
	{id=10037, productId={{50031210,1,1}}, consumeItemMain={{1,50031209,1},{1,50031209,1}}, consumeItem=local_consumeItem.consumeItem_5, coin=local_coin.coin_6},
	{id=10038, productId={{50031211,1,1}}, consumeItemMain={{1,50031210,1},{1,50031210,1}}, consumeItem=local_consumeItem.consumeItem_5, coin={10010002,37000000}},
	{id=10039, productId={{50031212,1,1}}, consumeItemMain={{1,50031211,1},{1,50031211,1}}, consumeItem=local_consumeItem.consumeItem_10, coin=local_coin.coin_7},
	{id=10040, productId={{50031213,1,1}}, consumeItemMain={{1,50031212,1},{1,50031212,1}}, consumeItem=local_consumeItem.consumeItem_11, coin={10010002,43000000}},
	{id=10041, productId={{50031214,1,1}}, consumeItemMain={{1,50031213,1},{1,50031213,1}}, consumeItem=local_consumeItem.consumeItem_6, coin=local_coin.coin_25},
	{id=10042, productId={{50031215,1,1}}, consumeItemMain={{1,50031214,1},{1,50031214,1}}, consumeItem=local_consumeItem.consumeItem_6, coin=local_coin.coin_15},
	{id=10043, productId={{50031216,1,1}}, consumeItemMain={{1,50031215,1},{1,50031215,1}}, consumeItem=local_consumeItem.consumeItem_7, coin=local_coin.coin_16},
	{id=10044, productId={{50031217,1,1}}, consumeItemMain={{1,50031216,1},{1,50031216,1}}, consumeItem=local_consumeItem.consumeItem_7, coin=local_coin.coin_17},
	{id=10045, productId={{50031218,1,1}}, consumeItemMain={{1,50031217,1},{1,50031217,1}}, consumeItem=local_consumeItem.consumeItem_8, coin=local_coin.coin_8},
	{id=10046, productId={{50031219,1,1}}, consumeItemMain={{1,50031218,1},{1,50031218,1}}, consumeItem=local_consumeItem.consumeItem_8, coin=local_coin.coin_18},
	{id=10047, productId={{50031220,1,1}}, consumeItemMain={{1,50031219,1},{1,50031219,1}}, consumeItem=local_consumeItem.consumeItem_12, coin=local_coin.coin_19},
	{id=10048, productId={{50031302,1,1}}, consumeItemMain={{1,50031301,1},{1,50031301,1}}, consumeItem=local_consumeItem.consumeItem_9, coin=local_coin.coin_2},
	{id=10049, productId={{50031303,1,1}}, consumeItemMain={{1,50031302,1},{1,50031302,1}}, coin=local_coin.coin_9},
	{id=10050, productId={{50031304,1,1}}, consumeItemMain={{1,50031303,1},{1,50031303,1}}, coin={10010002,14000000}},
	{id=10051, productId={{50031305,1,1}}, consumeItemMain={{1,50031304,1},{1,50031304,1}}, coin=local_coin.coin_10},
	{id=10052, productId={{50031306,1,1}}, consumeItemMain={{1,50031305,1},{1,50031305,1}}, consumeItem=local_consumeItem.consumeItem_3, coin=local_coin.coin_11},
	{id=10053, productId={{50031307,1,1}}, consumeItemMain={{1,50031306,1},{1,50031306,1}}, consumeItem=local_consumeItem.consumeItem_3, coin=local_coin.coin_3},
	{id=10054, productId={{50031308,1,1}}, consumeItemMain={{1,50031307,1},{1,50031307,1}}, consumeItem=local_consumeItem.consumeItem_4, coin=local_coin.coin_4},
	{id=10055, productId={{50031309,1,1}}, consumeItemMain={{1,50031308,1},{1,50031308,1}}, consumeItem=local_consumeItem.consumeItem_4, coin=local_coin.coin_12},
	{id=10056, productId={{50031310,1,1}}, consumeItemMain={{1,50031309,1},{1,50031309,1}}, consumeItem=local_consumeItem.consumeItem_5, coin=local_coin.coin_13},
	{id=10057, productId={{50031311,1,1}}, consumeItemMain={{1,50031310,1},{1,50031310,1}}, consumeItem=local_consumeItem.consumeItem_5, coin=local_coin.coin_21},
	{id=10058, productId={{50031312,1,1}}, consumeItemMain={{1,50031311,1},{1,50031311,1}}, consumeItem=local_consumeItem.consumeItem_10, coin=local_coin.coin_7},
	{id=10059, productId={{50031313,1,1}}, consumeItemMain={{1,50031312,1},{1,50031312,1}}, consumeItem=local_consumeItem.consumeItem_11, coin=local_coin.coin_14},
	{id=10060, productId={{50031314,1,1}}, consumeItemMain={{1,50031313,1},{1,50031313,1}}, consumeItem=local_consumeItem.consumeItem_6, coin=local_coin.coin_22},
	{id=10061, productId={{50031315,1,1}}, consumeItemMain={{1,50031314,1},{1,50031314,1}}, consumeItem=local_consumeItem.consumeItem_6, coin=local_coin.coin_15},
	{id=10062, productId={{50031316,1,1}}, consumeItemMain={{1,50031315,1},{1,50031315,1}}, consumeItem=local_consumeItem.consumeItem_7, coin=local_coin.coin_16},
	{id=10063, productId={{50031317,1,1}}, consumeItemMain={{1,50031316,1},{1,50031316,1}}, consumeItem=local_consumeItem.consumeItem_7, coin=local_coin.coin_17},
	{id=10064, productId={{50031318,1,1}}, consumeItemMain={{1,50031317,1},{1,50031317,1}}, consumeItem=local_consumeItem.consumeItem_8, coin=local_coin.coin_8},
	{id=10065, productId={{50031319,1,1}}, consumeItemMain={{1,50031318,1},{1,50031318,1}}, consumeItem=local_consumeItem.consumeItem_8, coin=local_coin.coin_18},
	{id=10066, productId={{50031320,1,1}}, consumeItemMain={{1,50031319,1},{1,50031319,1}}, consumeItem=local_consumeItem.consumeItem_12, coin=local_coin.coin_19},
	{id=10067, productId={{50031402,1,1}}, consumeItemMain={{1,50031401,1},{1,50031401,1}}, consumeItem=local_consumeItem.consumeItem_9, coin=local_coin.coin_2},
	{id=10068, productId={{50031403,1,1}}, consumeItemMain={{1,50031402,1},{1,50031402,1}}, coin=local_coin.coin_9},
	{id=10069, productId={{50031404,1,1}}, consumeItemMain={{1,50031403,1},{1,50031403,1}}, coin=local_coin.coin_20},
	{id=10070, productId={{50031405,1,1}}, consumeItemMain={{1,50031404,1},{1,50031404,1}}, coin=local_coin.coin_23},
	{id=10071, productId={{50031406,1,1}}, consumeItemMain={{1,50031405,1},{1,50031405,1}}, consumeItem=local_consumeItem.consumeItem_3, coin=local_coin.coin_11},
	{id=10072, productId={{50031407,1,1}}, consumeItemMain={{1,50031406,1},{1,50031406,1}}, consumeItem=local_consumeItem.consumeItem_3, coin=local_coin.coin_24},
	{id=10073, productId={{50031408,1,1}}, consumeItemMain={{1,50031407,1},{1,50031407,1}}, consumeItem=local_consumeItem.consumeItem_4, coin=local_coin.coin_4},
	{id=10074, productId={{50031409,1,1}}, consumeItemMain={{1,50031408,1},{1,50031408,1}}, consumeItem=local_consumeItem.consumeItem_4, coin=local_coin.coin_12},
	{id=10075, productId={{50031410,1,1}}, consumeItemMain={{1,50031409,1},{1,50031409,1}}, consumeItem=local_consumeItem.consumeItem_5, coin=local_coin.coin_13},
	{id=10076, productId={{50031411,1,1}}, consumeItemMain={{1,50031410,1},{1,50031410,1}}, consumeItem=local_consumeItem.consumeItem_5, coin=local_coin.coin_21},
	{id=10077, productId={{50031412,1,1}}, consumeItemMain={{1,50031411,1},{1,50031411,1}}, consumeItem=local_consumeItem.consumeItem_10, coin=local_coin.coin_7},
	{id=10078, productId={{50031413,1,1}}, consumeItemMain={{1,50031412,1},{1,50031412,1}}, consumeItem=local_consumeItem.consumeItem_11, coin=local_coin.coin_14},
	{id=10079, productId={{50031414,1,1}}, consumeItemMain={{1,50031413,1},{1,50031413,1}}, consumeItem=local_consumeItem.consumeItem_6, coin=local_coin.coin_22},
	{id=10080, productId={{50031415,1,1}}, consumeItemMain={{1,50031414,1},{1,50031414,1}}, consumeItem=local_consumeItem.consumeItem_6, coin=local_coin.coin_15},
	{id=10081, productId={{50031416,1,1}}, consumeItemMain={{1,50031415,1},{1,50031415,1}}, consumeItem=local_consumeItem.consumeItem_7, coin=local_coin.coin_16},
	{id=10082, productId={{50031417,1,1}}, consumeItemMain={{1,50031416,1},{1,50031416,1}}, consumeItem=local_consumeItem.consumeItem_7, coin=local_coin.coin_17},
	{id=10083, productId={{50031418,1,1}}, consumeItemMain={{1,50031417,1},{1,50031417,1}}, consumeItem=local_consumeItem.consumeItem_8, coin=local_coin.coin_8},
	{id=10084, productId={{50031419,1,1}}, consumeItemMain={{1,50031418,1},{1,50031418,1}}, consumeItem=local_consumeItem.consumeItem_8, coin=local_coin.coin_18},
	{id=10085, productId={{50031420,1,1}}, consumeItemMain={{1,50031419,1},{1,50031419,1}}, consumeItem=local_consumeItem.consumeItem_12, coin=local_coin.coin_19},
	{id=10086, productId={{50031502,1,1}}, consumeItemMain={{1,50031501,1},{1,50031501,1}}, consumeItem=local_consumeItem.consumeItem_9, coin=local_coin.coin_2},
	{id=10087, productId={{50031503,1,1}}, consumeItemMain={{1,50031502,1},{1,50031502,1}}, coin=local_coin.coin_9},
	{id=10088, productId={{50031504,1,1}}, consumeItemMain={{1,50031503,1},{1,50031503,1}}, coin=local_coin.coin_20},
	{id=10089, productId={{50031505,1,1}}, consumeItemMain={{1,50031504,1},{1,50031504,1}}, coin=local_coin.coin_23},
	{id=10090, productId={{50031506,1,1}}, consumeItemMain={{1,50031505,1},{1,50031505,1}}, consumeItem=local_consumeItem.consumeItem_3, coin=local_coin.coin_11},
	{id=10091, productId={{50031507,1,1}}, consumeItemMain={{1,50031506,1},{1,50031506,1}}, consumeItem=local_consumeItem.consumeItem_3, coin=local_coin.coin_24},
	{id=10092, productId={{50031508,1,1}}, consumeItemMain={{1,50031507,1},{1,50031507,1}}, consumeItem=local_consumeItem.consumeItem_4, coin=local_coin.coin_4},
	{id=10093, productId={{50031509,1,1}}, consumeItemMain={{1,50031508,1},{1,50031508,1}}, consumeItem=local_consumeItem.consumeItem_4, coin=local_coin.coin_12},
	{id=10094, productId={{50031510,1,1}}, consumeItemMain={{1,50031509,1},{1,50031509,1}}, consumeItem=local_consumeItem.consumeItem_5, coin=local_coin.coin_13},
	{id=10095, productId={{50031511,1,1}}, consumeItemMain={{1,50031510,1},{1,50031510,1}}, consumeItem=local_consumeItem.consumeItem_5, coin=local_coin.coin_21},
	{id=10096, productId={{50031512,1,1}}, consumeItemMain={{1,50031511,1},{1,50031511,1}}, consumeItem=local_consumeItem.consumeItem_10, coin=local_coin.coin_7},
	{id=10097, productId={{50031513,1,1}}, consumeItemMain={{1,50031512,1},{1,50031512,1}}, consumeItem=local_consumeItem.consumeItem_11, coin=local_coin.coin_14},
	{id=10098, productId={{50031514,1,1}}, consumeItemMain={{1,50031513,1},{1,50031513,1}}, consumeItem=local_consumeItem.consumeItem_6, coin=local_coin.coin_22},
	{id=10099, productId={{50031515,1,1}}, consumeItemMain={{1,50031514,1},{1,50031514,1}}, consumeItem=local_consumeItem.consumeItem_6, coin=local_coin.coin_25},
	{id=10100, productId={{50031516,1,1}}, consumeItemMain={{1,50031515,1},{1,50031515,1}}, consumeItem=local_consumeItem.consumeItem_7, coin=local_coin.coin_26},
	{id=10101, productId={{50031517,1,1}}, consumeItemMain={{1,50031516,1},{1,50031516,1}}, consumeItem=local_consumeItem.consumeItem_7, coin={10010002,56000000}},
	{id=10102, productId={{50031518,1,1}}, consumeItemMain={{1,50031517,1},{1,50031517,1}}, consumeItem=local_consumeItem.consumeItem_8, coin={10010002,59000000}},
	{id=10103, productId={{50031519,1,1}}, consumeItemMain={{1,50031518,1},{1,50031518,1}}, consumeItem=local_consumeItem.consumeItem_8, coin=local_coin.coin_18},
	{id=10104, productId={{50031520,1,1}}, consumeItemMain={{1,50031519,1},{1,50031519,1}}, consumeItem=local_consumeItem.consumeItem_12, coin=local_coin.coin_19},
	{id=10105, productId={{50031602,1,1}}, consumeItemMain={{1,50031601,1},{1,50031601,1}}, consumeItem=local_consumeItem.consumeItem_9, coin=local_coin.coin_2},
	{id=10106, productId={{50031603,1,1}}, consumeItemMain={{1,50031602,1},{1,50031602,1}}, coin=local_coin.coin_9},
	{id=10107, productId={{50031604,1,1}}, consumeItemMain={{1,50031603,1},{1,50031603,1}}, coin=local_coin.coin_20},
	{id=10108, productId={{50031605,1,1}}, consumeItemMain={{1,50031604,1},{1,50031604,1}}, coin=local_coin.coin_23},
	{id=10109, productId={{50031606,1,1}}, consumeItemMain={{1,50031605,1},{1,50031605,1}}, consumeItem=local_consumeItem.consumeItem_3, coin={10010002,21000000}},
	{id=10110, productId={{50031607,1,1}}, consumeItemMain={{1,50031606,1},{1,50031606,1}}, consumeItem=local_consumeItem.consumeItem_3, coin=local_coin.coin_24},
	{id=10111, productId={{50031608,1,1}}, consumeItemMain={{1,50031607,1},{1,50031607,1}}, consumeItem=local_consumeItem.consumeItem_4, coin={10010002,26000000}},
	{id=10112, productId={{50031609,1,1}}, consumeItemMain={{1,50031608,1},{1,50031608,1}}, consumeItem=local_consumeItem.consumeItem_4, coin=local_coin.coin_12},
	{id=10113, productId={{50031610,1,1}}, consumeItemMain={{1,50031609,1},{1,50031609,1}}, consumeItem=local_consumeItem.consumeItem_5, coin=local_coin.coin_13},
	{id=10114, productId={{50031611,1,1}}, consumeItemMain={{1,50031610,1},{1,50031610,1}}, consumeItem=local_consumeItem.consumeItem_5, coin=local_coin.coin_21},
	{id=10115, productId={{50031612,1,1}}, consumeItemMain={{1,50031611,1},{1,50031611,1}}, consumeItem=local_consumeItem.consumeItem_10, coin=local_coin.coin_7},
	{id=10116, productId={{50031613,1,1}}, consumeItemMain={{1,50031612,1},{1,50031612,1}}, consumeItem=local_consumeItem.consumeItem_11, coin=local_coin.coin_14},
	{id=10117, productId={{50031614,1,1}}, consumeItemMain={{1,50031613,1},{1,50031613,1}}, consumeItem=local_consumeItem.consumeItem_6, coin=local_coin.coin_22},
	{id=10118, productId={{50031615,1,1}}, consumeItemMain={{1,50031614,1},{1,50031614,1}}, consumeItem=local_consumeItem.consumeItem_6, coin=local_coin.coin_15},
	{id=10119, productId={{50031596,1,1}}, consumeItemMain={{1,50031615,1},{1,50031615,1}}, consumeItem=local_consumeItem.consumeItem_7, coin=local_coin.coin_16},
	{id=10120, productId={{50031597,1,1}}, consumeItemMain={{1,50031596,1},{1,50031596,1}}, consumeItem=local_consumeItem.consumeItem_7, coin=local_coin.coin_26},
	{id=10121, productId={{50031598,1,1}}, consumeItemMain={{1,50031597,1},{1,50031597,1}}, consumeItem=local_consumeItem.consumeItem_8, coin=local_coin.coin_8},
	{id=10122, productId={{50031599,1,1}}, consumeItemMain={{1,50031598,1},{1,50031598,1}}, consumeItem=local_consumeItem.consumeItem_8, coin=local_coin.coin_18},
	{id=10123, productId={{50031500,1,1}}, consumeItemMain={{1,50031599,1},{1,50031599,1}}, consumeItem=local_consumeItem.consumeItem_12, coin=local_coin.coin_19},
}

local defaults = {productId={{50030201,1,16},{50030305,1,16},{50030401,1,16},{50030504,1,16},{50030604,1,16},{50030701,1,16}}, synthesisType={5}, typeShow=0, subType=0, name="", descriptiondefault="", composeTime="", level=0, career={}, consumeItemMain={{2,4,0,2,0,1},{2,4,0,1,0,1}}, consumeItem={{1,2100103,5}}, successRate="7200", successRateReal="7200", successRateMax="7200", successOpen=0, transfer=0, inheritEntry=0, guarantees=0, showCondition="", synthesisCondition="", npcid=0, coin={10010002,4000}, synthesisname="", description=""}
local mt = {__index = defaults}
for _, v in ipairs(synhtesis_yingshi) do
	setmetatable(v, mt)
end

return synhtesis_yingshi