-- 此文件工具自动生成，不要修改
---@class cfg_synthesis_column
---@field id number @配方ID#客户端#C column=1 A
---合成后的道具ID 定向道具没有不用配 同一组的合成物定向道具唯一
---格式：道具id#数量#权重#定向道具id|道具id#权重#定向道具id
---@field productId IntListList @合成物#客户端#C column=2 B
---1、普通合成（合成物无需生成随机属性时使用，合成无数量限制）
---2、特殊合成(合成物需要生成随机属性时使用，一次最多合成10个，避免卡顿）3、消耗道具大类  强化等级要求
---@field synthesisType IntList @合成类型 column=3 C
---1强化装备
---2追加装备
---
---
---@field type number @页签物品父类别#客户端#C column=4 D
---每个类别名称需一致，若不一致，则整个类别都不展示
---@field typeName string @父类别名称 column=5 E
---填0或者空的话=直接根据唯一id顺序 展示在父级页签下
---每个类别名称需一致，若不一致，则整个类别都不展示
---@field subType number @子类别 column=6 F
---子页签填0则不需要写名称
---@field subTypeName string @子类别名称 column=7 G
---@field name string @合成公式名称#客户端#C column=8 H
---合成炉为空时的显示
---@field descriptiondefault string @默认描述 column=9 I
---合成道具如果有进度则需要进度时间，单位毫秒
---@field composeTime string @合成时间 column=10 J
---满足了等级才会显示该合成配方
---格式：直接填等级
---@field level number @等级限制 column=11 K
---满足了职业才会显示该合成配方
---格式：所属职业#职业等级|所属职业#职业等级
---@field career IntListList @职业限制 column=12 L
---合成类型=1，固定道具
---合成类型#道具id#数量
---
---合成类型=2，大类消耗
---合成类型#强化等级#追加等级#品质需求#类别需求#指定道具的cfgId#数量（数量默认为1）
---品质需求（关联cfg_item表Outstanding）：0=白装装备，1=卓越装备，2=套装装备，99=不限
---类别需求（关联cfg_item表Mixtype）：0=不限，1=一代翅膀，2=二代翅膀，3=三代翅膀，4=洞装，5=首饰，6=玛雅武器, 其余未定义类别关联cfg_item表useLevelLimit字段
---
---合成类型=3，强化追加属性能额外增加成功率的道具
---合成类型#强化等级#追加等级#品质需求#类别需求#成功率组id#指定道具id#数量
---品质需求（关联cfg_item表Outstanding）：0=白装装备，1=卓越装备，2=套装装备，99=不限
---类别需求（关联cfg_item表Mixtype）：0=不限，1=一代翅膀，2=二代翅膀，3=三代翅膀，4=洞装，5=首饰，6=玛雅武器, 其余未定义类别关联cfg_item表useLevelLimit字段
---成功率组id（关联cfg_synthesisRateGroup表id）：当道具身上有强化等级，追加等级，某条属性时可以增加额外成功率
---
---合成类型=4，固定道具
---合成类型#道具id#数量
---合成类型=5，大类消耗
---合成类型#强化等级#追加等级#品质需求#类别需求#数量（数量默认为1）
---品质需求（关联cfg_item表Outstanding）：0=白装装备，1=卓越装备，2=套装装备，99=不限
---类别需求（关联cfg_item表Mixtype）：0=不限，1=一代翅膀，2=二代翅膀，3=三代翅膀，4=洞装，5=首饰，6=玛雅武器, 其余未定义类别关联cfg_item表useLevelLimit字段
---合成类型6 卡槽数量（大于等于1）装备|荧光宝石
---合成类型7（镶嵌有荧光宝石的物品）
---合成类型8 荧光宝石|荧光宝石
---@field consumeItem IntListList @公式刚需消耗道具 column=13 M
---合成类型=1，固定道具
---合成类型#道具id#辅助材料增加成功率（没有填0）
---合成类型=2
---合成类型#强化等级#追加等级#品质需求#类别需求#指定道具的cfgId（没有指定填0）#辅助材料增加成功率（没有填0）
---品质需求（关联cfg_item表Outstanding）：0=白装装备，1=卓越装备，2=套装装备，99=不限
---类别需求（关联cfg_item表Mixtype）：0=不限，1=一代翅膀，2=二代翅膀，3=三代翅膀，4=洞装，5=首饰，6=玛雅武器, 其余未定义类别关联cfg_item表useLevelLimit字段
---合成类型=3，强化追加属性能额外增加成功率的道具
---合成类型#强化等级#追加等级#品质需求#类别需求#成功率组id#指定道具id#辅助材料增加成功率
---品质需求（关联cfg_item表Outstanding）：0=白装装备，1=卓越装备，2=套装装备，99=不限
---类别需求（关联cfg_item表Mixtype）：0=不限，1=一代翅膀，2=二代翅膀，3=三代翅膀，4=洞装，5=首饰，6=玛雅武器, 其余未定义类别关联cfg_item表useLevelLimit字段
---成功率组id（关联cfg_synthesisRateGroup表id）：当道具身上有强化等级，追加等级，某条属性时可以增加额外成功率
---@field consumeItem2 IntListList @公式额外消耗道具 成功率增加道具 column=14 N
---额外材料折扣比例
---
---万分比，不填时不启用折扣比例
---
---@field reduceitemrate number @额外材料价值折扣计算 column=15 O
---在代码通过item表value字段进行额外道具的价值对应的概率计算之外，额外提供的固定概率（直接加在原有概率上）
---
---cfgid#额外概率|cfgid#额外概率
---@field specialConsumeRate IntListList @额外道具的额外成功率 column=16 P
---辅助材料能够增加的额外成功率上限，额外成功率上限即使超过最大成功率，也以最大成功率为主
---@field specialConsumeRateMax number @辅助材料的额外成功率上限 column=17 Q
---格式：道具id#道具id|道具id#道具id
---@field arbitrarily StringListList @公式特殊消耗道具 column=18 R
---0或者空=可以批量合成
---2=不可以批量合成
---@field timesOpen number @多次合成开关 column=19 S
---万分比
---@field successRate string @前端显示成功几率 column=20 T
---万分比
---@field successRateReal string @后端真实成功几率 column=21 U
---万分比
---@field successRateMax string @最大成功率 column=22 V
---0或者空=显示成功率
---2=不显示
---@field successOpen number @成功率显示开关 column=23 W
---0或空=不使用转移功能
---1=开启转移
---将consumeItem字段的顺序第一个的材料的强化、追加、幸运、叠加属性 全复制到合成物上
---若开启转移 但 第一个材料或者合成物任意一个都不支持强化、追加、幸运、叠加，则等于不使用转移功能
---@field transfer number @强化、追加、幸运、叠加转移 column=24 X
---合成的时候是否继承卓越词条
---1继承
---0或不填 不继承
---@field inheritEntry number @卓越词条继承 column=25 Y
---合成失败次数乘以保底概率=提供的额外成功率
---格式 万比
---@field guarantees number @保底概率 column=26 A
---显示在界面上的条件
---关联cfg_condition_out表
---@field showCondition string @显示条件 column=27 AA
---需要满足的条件
---关联cfg_condition_out表
---@field synthesisCondition string @合成条件 column=28 AB
---关联NPC表，用于区分该合成方案在哪个NPC面板上
---@field npcid number @关联NPC column=29 AC
---特殊消耗道具验证类型：1神器等级，2装备词条数，空或者0不需要验证
---@field checkType number @验证类型 column=30 AD
---根据类型验证，参数分割与特殊消耗道具分割格式一样且一一对应
---@field checkParam IntListList @验证参数 column=31 AE
---道具id#数量
---@field coin IntList @背包非显示道具的消耗 column=32 AF
---合成失败时，会返回合成类型为2的公式刚需消耗道具，返还的道具可以自定义强化追加等级。若不配置，则不需要返还装备，合成失败时，大类装备任然是原有等级
---配置格式：强化等级#追加等级
---@field fail IntList @合成失败返回装备 column=33 AG
---使用该道具可以保护装备在合成失败时，不会降低等级
---配置格式：道具id#道具id
---@field protect IntList @合成保护道具 column=34 AH
---格式：`道具id#加成成功率|道具id#加成成功率`，多个幸运道具用 `|` 隔开，每个道具的 id 和加成率用 `#` 隔开，加成成功率单位：万分之一（10000 = 100%，1000 = 10%），- 不填或为空 = 这条合成不支持幸运道具
---@field luckyItem IntList @幸运符咒 column=35 AI

local local_productId = {
    productId_1={},
    productId_2={{1019199,1,20},{1124199,1,20},{1098199,1,20},{1144199,1,20},{1058199,1,20}},
    productId_3={{1160004399,1,100}},
    productId_4={{2132506199,1,100}},
    productId_5={{2134006199,1,100}},

}

local local_synthesisType = {
    synthesisType_1={1},

}

local local_career = {
    career_1={},

}

local local_consumeItem = {
    consumeItem_1={},
    consumeItem_2={{1,1160000499,1},{1,1253000599,10},{1,1253000199,5},{2,4,1,99,0,0,1}},

}

local local_consumeItem2 = {
    consumeItem2_1={},
    consumeItem2_2={{1,1253000299,500},{1,1253000399,300}},

}

local local_specialConsumeRate = {
    specialConsumeRate_1={},

}

local local_arbitrarily = {
    arbitrarily_1={},

}

local local_checkParam = {
    checkParam_1={},

}

local local_coin = {
    coin_1={},
    coin_2={10010002,400000},
    coin_3={10040001,500},
    coin_4={10040001,1000},
    coin_5={10010002,50000000},
    coin_6={10040001,300},
    coin_7={10010002,1000000},
    coin_8={10040001,100},
    coin_9={10040001,800},
    coin_10={10010002,10000000},
    coin_11={10040001,2000},

}

local local_fail = {
    fail_1={},

}

local local_protect = {
    protect_1={},
    protect_2={1254003899},

}

local local_luckyItem = {
    luckyItem_1={},
    luckyItem_2={1254004099,1000},

}

local cfg_synthesis =
{
	{id=10001, productId=local_productId.productId_1, type=1, typeName="装备强化", name="", descriptiondefault="请放入想强化的装备(需+9以上)", composeTime="", level=0, consumeItem=local_consumeItem.consumeItem_1, consumeItem2=local_consumeItem2.consumeItem2_1, timesOpen=0, successRate="", successRateReal="", successRateMax="", npcid=0, coin=local_coin.coin_1, fail={0,0}, protect=local_protect.protect_2},
	{id=10002, productId=local_productId.productId_1, type=2, typeName="装备追加", name="", descriptiondefault="请放入想追加的装备", composeTime="", level=0, consumeItem=local_consumeItem.consumeItem_1, consumeItem2=local_consumeItem2.consumeItem2_1, timesOpen=0, successRate="", successRateReal="", successRateMax="", npcid=0, coin=local_coin.coin_1, luckyItem=local_luckyItem.luckyItem_1},
	{id=10003, productId={{600076156,1,100}}, name="透明披风+1", consumeItem={{1,50040043,1},{1,50040044,1},{1,1253000199,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, coin={10010002,5000}, luckyItem=local_luckyItem.luckyItem_1},
	{id=10004, productId={{600076157,1,100}}, name="透明披风+2", consumeItem={{1,500400431,1},{1,500400441,1},{1,1253000199,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, coin={10010002,80000}, luckyItem=local_luckyItem.luckyItem_1},
	{id=10005, productId={{600076158,1,100}}, name="透明披风+3", consumeItem={{1,500400432,1},{1,500400442,1},{1,1253000199,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, coin={10010002,150000}, luckyItem=local_luckyItem.luckyItem_1},
	{id=10006, productId={{600076159,1,100}}, name="透明披风+4", consumeItem={{1,500400433,1},{1,500400443,1},{1,1253000199,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, coin={10010002,250000}, luckyItem=local_luckyItem.luckyItem_1},
	{id=10007, productId={{600076160,1,100}}, name="透明披风+5", consumeItem={{1,500400434,1},{1,500400444,1},{1,1253000199,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, coin=local_coin.coin_2, luckyItem=local_luckyItem.luckyItem_1},
	{id=10008, productId={{600076161,1,100}}, name="透明披风+6", consumeItem={{1,500400435,1},{1,500400445,1},{1,1253000199,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, coin={10010002,600000}, luckyItem=local_luckyItem.luckyItem_1},
	{id=10009, productId={{600076162,1,100}}, name="透明披风+7", consumeItem={{1,500400436,1},{1,500400446,1},{1,1253000199,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, coin={10010002,800000}, luckyItem=local_luckyItem.luckyItem_1},
	{id=10010, productId={{2000022,1,100}}, name="恶魔广场通行证+1", consumeItem={{1,1253000199,1},{1,50040011,1},{1,50040012,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, coin={10010002,100000}, luckyItem=local_luckyItem.luckyItem_1},
	{id=10011, productId={{2000023,1,100}}, name="恶魔广场通行证+2", consumeItem={{1,1253000199,1},{1,500400111,1},{1,500400121,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, coin={10010002,200000}, luckyItem=local_luckyItem.luckyItem_1},
	{id=10012, productId={{2000024,1,100}}, name="恶魔广场通行证+3", consumeItem={{1,1253000199,1},{1,500400112,1},{1,500400122,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, coin=local_coin.coin_2, luckyItem=local_luckyItem.luckyItem_1},
	{id=10013, productId={{2000025,1,100}}, name="恶魔广场通行证+4", consumeItem={{1,1253000199,1},{1,500400113,1},{1,500400123,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, coin={10010002,700000}, luckyItem=local_luckyItem.luckyItem_1},
	{id=10014, productId={{2000026,1,100}}, name="恶魔广场通行证+5", consumeItem={{1,1253000199,1},{1,500400114,1},{1,500400124,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, coin={10010002,1100000}, luckyItem=local_luckyItem.luckyItem_1},
	{id=10015, productId={{2000027,1,100}}, name="恶魔广场通行证+6", consumeItem={{1,1253000199,1},{1,500400115,1},{1,500400125,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, coin={10010002,1600000}, luckyItem=local_luckyItem.luckyItem_1},
	{id=10016, productId={{2000028,1,100}}, name="恶魔广场通行证+7", consumeItem={{1,1253000199,1},{1,500400116,1},{1,500400126,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, coin={10010002,2000000}, luckyItem=local_luckyItem.luckyItem_1},
	{id=10017, productId={{2131001199,1,20,},{2131002199,1,20,},{2131003199,1,20,},{2131004199,1,20,},{2137001199,1,20,}}, type=4, typeName="1代翅膀", name="1代翅膀", descriptiondefault="玛雅武器（+4以上且z4以上）\n玛雅之石", consumeItem={{3,4,1,99,6,2,0,1},{1,1253000199,1}}, successRate="1000", successRateReal="1000", successRateMax="8000", coin=local_coin.coin_8},
	{id=10018, productId={{2132001199,1,100,600076127},{2132002199,1,100,600076129},{2132003199,1,100,600076131},{2132004199,1,100,},{2132005199,1,100,},{2137002199,1,100,}}, type=5, typeName="2代翅膀", name="2代翅膀", descriptiondefault="1代翅膀\n洛克之羽\n玛雅之石", consumeItem={{3,0,0,99,1,3,0,1},{1,1254001499,1},{1,1253000199,1}}, successRate="1000", successRateReal="1000", successRateMax="5500", coin=local_coin.coin_6},
	{id=10019, productId={{2132501199,1,100,600076149},{2132502199,1,100,600076151},{2132503199,1,100,600076153}}, type=6, typeName="2.5代翅膀", name="2.5代翅膀", descriptiondefault="2代翅膀(+9以上且z4以上)\n创造宝石\n玛雅之石", consumeItem={{2,9,1,0,2,0,1},{1,1253000599,1},{1,1253000199,1}}, successRate="1000", successRateReal="1000", successRateMax="4500", coin=local_coin.coin_3},
	{id=10020, productId={{2133001199,1,100},{2133002199,1,100},{2133003199,1,100},{2137004199,1,100},{2133004199,1,100},{2133005199,1,100}}, type=7, typeName="3代翅膀", name="3代翅膀", descriptiondefault="神鹰之羽\n神鹰火种\n卓越品质装备（+9以上z4以上）\n玛雅之石\n灵魂宝石\n创造宝石", consumeItem={{1,1254004299,1},{1,1254004199,1},{2,9,1,1,0,0,1},{1,1253000199,1},{1,1253000399,1},{1,1253000599,1}}, successRate="1000", successRateReal="1000", successRateMax="3500", coin=local_coin.coin_9},
	{id=10021, productId={{2134001199,1,100},{2134002199,1,100},{2134003199,1,100},{2134004199,1,100},{2134005199,1,100}}, type=8, typeName="4代翅膀", name="4代翅膀", descriptiondefault="加鲁达之羽\n加鲁达火种\n卓越品质装备（+9以上z4以上）\n玛雅之石\n灵魂宝石\n创造宝石\n祝福宝石\n黄金纹章", consumeItem={{1,1254001599,1},{1,1254010199,1},{2,9,1,1,0,0,1},{1,1253000199,30},{1,1253000399,30},{1,1253000599,30},{1,1253000299,30},{1,600076116,50}}, successRate="1000", successRateReal="1000", successRateMax="3500"},
	{id=10022, productId={{1254004299,1,100}}, type=9, typeName="神鹰之羽", name="神鹰之羽", descriptiondefault="2代翅膀(+9以上且z4以上)\n套装品质装备（+7以上且z4以上）\n灵魂宝石\n创造宝石\n玛雅之石", consumeItem={{3,9,1,0,2,4,0,1},{3,7,1,2,0,6,0,1},{1,1253000199,1},{1,1253000399,10},{1,1253000599,1}}, successRate="1000", successRateReal="1000", successRateMax="6000", coin=local_coin.coin_3},
	{id=10023, productId={{1254001599,1,100}}, type=10, typeName="加鲁达之羽", name="加鲁达之羽", descriptiondefault="3代翅膀(+13以上且z4以上)\n套装品质装备（+7以上且z4以上）\n灵魂宝石\n创造宝石\n玛雅之石", consumeItem={{3,13,1,0,3,5,0,1},{3,7,1,2,0,6,0,1},{1,1253000199,1},{1,1253000399,10},{1,1253000599,1}}, successRate="1000", successRateReal="1000", successRateMax="3500"},
	{id=10024, productId={{101999,1,20},{112499,1,20},{109899,1,20},{114499,1,20},{105899,1,20}}, type=11, typeName="大天使武器", name="大天使武器", descriptiondefault="3代翅膀（+4以上）\n卓越品质装备（+13以上）", consumeItem={{2,4,0,0,3,0,1},{2,13,0,1,0,0,1}}, successRate="1000", successRateReal="1000", successRateMax="3500", coin=local_coin.coin_5},
	{id=10025, type=12, typeName="卓越大天使武器", name="卓越大天使武器", descriptiondefault="大天使合成物碎片\n大天使合成物\n大天使武器（+13以上）\n祝福宝石\n灵魂宝石\n玛雅之石", consumeItem={{1,50040102,1},{1,1253000299,30},{1,1253000399,30},{1,1253000199,1}}, successRate="500", successRateReal="500", successRateMax="3500", coin=local_coin.coin_5},
	{id=10026, type=12, typeName="卓越大天使武器", name="卓越大天使武器", descriptiondefault="大天使合成物碎片\n大天使合成物\n大天使武器（+13以上）\n祝福宝石\n灵魂宝石\n玛雅之石", consumeItem={{1,50040103,1},{2,13,0,99,8,0,1},{1,1253000299,30},{1,1253000399,30},{1,1253000199,1}}, successRate="500", successRateReal="500", successRateMax="3500", coin=local_coin.coin_5},
	{id=10027, productId={{103599,1,20},{114799,1,20},{1098299,1,20},{114899,1,20},{1058299,1,20}}, type=13, typeName="祝福大天使武器", name="祝福大天使武器", descriptiondefault="大天使武器（+13以上且z16以上）\n大天使铁锤\n祝福宝石\n灵魂宝石\n玛雅之石", consumeItem={{2,13,4,99,8,0,1},{1,1254003799,10},{1,1253000299,30},{1,1253000399,30},{1,1253000199,1}}, successRate="500", successRateReal="500", successRateMax="3500", coin={10040001,1800}},
	{id=10028, productId={{1254003799,1,100}}, type=14, typeName="大天使铁锤", name="大天使铁锤", descriptiondefault="天界之钢\n祝福宝石\n灵魂宝石\n玛雅宝石\n创造宝石\n守护宝石", consumeItem={{1,50040098,1},{1,1253000299,10},{1,1253000399,10},{1,1253000199,10},{1,1253000599,1},{1,1253000699,1}}, successRate="500", successRateReal="500", successRateMax="3500", coin=local_coin.coin_6},
	{id=10029, productId={{1233030199,1,100},{1233030299,1,100},{1233030399,1,100},{1233030499,1,100}}, type=15, typeName="果实合成", name="果实合成", descriptiondefault="创造宝石\n玛雅宝石", consumeItem={{1,1253000199,1},{1,1253000599,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, coin=local_coin.coin_7, luckyItem=local_luckyItem.luckyItem_1},
	{id=10030, productId={{1253000899,1,100}}, type=16, typeName="再生合成", name="再生合成", descriptiondefault="再生原石", consumeItem={{1,1253000799,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, coin=local_coin.coin_7, luckyItem=local_luckyItem.luckyItem_1},
	{id=10031, productId={{105199,1,33},{112199,1,33},{108699,1,33}}, type=17, typeName="玛雅武器", name="玛雅龙斧", descriptiondefault="普通品质装备 （+4以上）z4以上\n玛雅之石", consumeItem={{2,4,1,0,0,0,1},{1,1253000199,5}}, consumeItem2={{1,1253000199,200}}, successRate="500", successRateReal="500", successRateMax="8000", coin=local_coin.coin_7},
	{id=10032, productId={{1254004899,1,100}}, type=18, typeName="碎角片", name="碎角片", descriptiondefault="破烂的铠甲片\n女神的灵智\n玛雅之石", consumeItem={{1,50040045,20},{1,50040046,20},{1,1253000199,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, npcid=100120, coin=local_coin.coin_7},
	{id=10033, productId={{1254004999,1,100}}, type=34, typeName="折断的角", name="折断的角", descriptiondefault="猛兽的脚甲\n碎角片\n玛雅之石", consumeItem={{1,1254004799,10},{1,1254004899,5},{1,1253000199,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, npcid=100120, coin=local_coin.coin_7},
	{id=10034, productId={{1160000399,1,100}}, type=35, typeName="炎狼兽之角", name="炎狼兽之角", descriptiondefault="折断的角\n生命宝石\n玛雅之石", consumeItem={{1,1254004999,1},{1,1253000499,3},{1,1253000199,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, npcid=100120, coin=local_coin.coin_8, protect=local_protect.protect_2},
	{id=10035, productId={{1160000499,1,100}}, type=19, typeName="雷刃炎狼兽之角", name="雷刃炎狼兽之角", descriptiondefault="炎狼兽之角\n创造宝石\n玛雅之石", consumeItem={{1,1160000399,1},{1,1253000599,5},{1,1253000199,5}}, consumeItem2=local_consumeItem2.consumeItem2_1, npcid=100120, coin=local_coin.coin_6, protect=local_protect.protect_2},
	{id=10036, productId={{1160010599,1,100}}, type=20, typeName="炎狼兽破坏", name="炎狼兽破坏", descriptiondefault="雷刃炎狼兽之角\n创造宝石\n玛雅宝石\n任意品质武器（+4以上且z4以上）\n任意品质武器（+4以上且z4以上）", consumeItem2=local_consumeItem2.consumeItem2_1, npcid=100120, coin=local_coin.coin_3, protect=local_protect.protect_2},
	{id=10037, productId={{1160010699,1,100}}, type=20, typeName="炎狼兽守护", name="炎狼兽守护", descriptiondefault="雷刃炎狼兽之角\n创造宝石\n玛雅宝石\n任意品质武器（+4以上且z4以上）\n任意品质防具（+4以上且z4以上）", consumeItem2=local_consumeItem2.consumeItem2_1, npcid=100120, coin=local_coin.coin_9, protect=local_protect.protect_2},
	{id=10038, productId=local_productId.productId_3, type=21, typeName="白毛狮王", name="白毛狮王", descriptiondefault="守护/破坏炎狼兽之角\n祝福宝石\n灵魂宝石\n玛雅之石", consumeItem={{1,1160010599,1},{1,1253000299,66},{1,1253000399,66},{1,1253000199,5}}, consumeItem2=local_consumeItem2.consumeItem2_1, successRate="3500", successRateReal="3500", successRateMax="3500", npcid=100120, protect=local_protect.protect_2},
	{id=10039, productId=local_productId.productId_3, type=21, typeName="白毛狮王", name="白毛狮王", descriptiondefault="守护/破坏炎狼兽之角\n祝福宝石\n灵魂宝石\n玛雅之石", consumeItem={{1,1160010699,1},{1,1253000299,66},{1,1253000399,66},{1,1253000199,5}}, consumeItem2=local_consumeItem2.consumeItem2_1, successRate="3500", successRateReal="3500", successRateMax="3500", npcid=100120, protect=local_protect.protect_2},
	{id=10040, productId={{1160001999,1,100}}, type=23, typeName="金龙", name="金龙", descriptiondefault="白毛狮王\n祝福宝石\n灵魂宝石\n玛雅之石\n生命宝石", consumeItem={{1,1160004399,1},{1,1253000299,99},{1,1253000399,99},{1,1253000199,20},{1,1253000499,5}}, consumeItem2=local_consumeItem2.consumeItem2_1, successRate="3500", successRateReal="3500", successRateMax="3500", npcid=100120, coin={10040001,1500}, protect=local_protect.protect_2},
	{id=10041, productId={{1160003099,1,100}}, type=24, typeName="星冥龙", name="星冥龙", descriptiondefault="金龙爪\n祝福宝石\n灵魂宝石\n玛雅之石\n生命宝石", consumeItem={{1,1160001999,1},{1,1253000299,99},{1,1253000399,99},{1,1253000199,50},{1,1253000499,10}}, consumeItem2=local_consumeItem2.consumeItem2_1, successRate="3500", successRateReal="3500", successRateMax="3500", npcid=100120, coin=local_coin.coin_11, protect=local_protect.protect_2},
	{id=10042, productId={{2132006199,1,100}}, type=25, typeName="王者披风", name="王者披风", descriptiondefault="1代翅膀\n国王卷轴\n玛雅之石", consumeItem={{3,0,0,99,1,7,0,1},{1,1254001399,1},{1,1253000199,1}}, successRate="1000", successRateReal="1000", successRateMax="5500", coin=local_coin.coin_6},
	{id=10043, productId=local_productId.productId_4, type=26, typeName="死亡披风", name="死亡披风", descriptiondefault="2代翅膀（+9以上且z4以上）\n王者披风（+9以上且z4以上）\n创造宝石\n玛雅之石\n骷髅王的骨头", consumeItem={{3,9,1,99,2,8,0,1},{1,1253000599,1},{1,1253000199,1}}, successRate="1000", successRateReal="1000", successRateMax="4500", coin=local_coin.coin_3},
	{id=10044, productId=local_productId.productId_4, type=26, typeName="死亡披风", name="死亡披风", descriptiondefault="2代翅膀（+9以上且z4以上）\n王者披风（+9以上且z4以上）\n创造宝石\n玛雅之石\n骷髅王的骨头", consumeItem={{3,9,1,99,0,8,2132006199,1},{1,1253000599,1},{1,1253000199,1}}, successRate="1000", successRateReal="1000", successRateMax="4500", coin=local_coin.coin_3},
	{id=10045, productId={{2133006199,1,100}}, type=27, typeName="帝王披风", name="帝王披风", descriptiondefault="死亡披风（+9以上且z9以上）\n神鹰火种\n祝福宝石\n灵魂宝石\n创造宝石\n玛雅之石", consumeItem={{2,9,1,99,0,2132506199,1},{1,1253000599,30},{1,1253000199,30},{1,1253000299,30},{1,1253000399,30},{1,1254004199,1}}, successRate="1000", successRateReal="1000", successRateMax="3500", coin=local_coin.coin_9},
	{id=10046, productId=local_productId.productId_5, type=28, typeName="主宰披风", name="主宰披风", descriptiondefault="3代翅膀（+13以上且z4以上）\n帝王披风（+13以上且z4以上）\n加鲁达火种\n黄金纹章\n祝福宝石\n灵魂宝石\n创造宝石\n玛雅之石", consumeItem={{2,13,1,99,3,0,1},{1,1253000599,60},{1,1253000199,60},{1,1253000299,60},{1,1253000399,60},{1,1254010199,1},{1,600076116,50}}, successRate="1000", successRateReal="1000", successRateMax="3500"},
	{id=10047, productId=local_productId.productId_5, type=28, typeName="主宰披风", name="主宰披风", descriptiondefault="3代翅膀（+13以上且z4以上）\n帝王披风（+13以上且z4以上）\n加鲁达火种\n黄金纹章\n祝福宝石\n灵魂宝石\n创造宝石\n玛雅之石", consumeItem={{2,13,1,99,3,2133006199,1},{1,1253000599,60},{1,1253000199,60},{1,1253000299,60},{1,1253000399,60},{1,1254010199,1},{1,600076116,50}}, successRate="1000", successRateReal="1000", successRateMax="3500"},
	{id=10048, productId={{1201102399,1,100}}, type=29, typeName="耳环宝箱", name="耳环宝箱", descriptiondefault="\n祝福宝石\n灵魂宝石\n玛雅之石", consumeItem={{1,1253000399,1},{1,1253000299,1},{1,1253000199,1}}, consumeItem2=local_consumeItem2.consumeItem2_1, successRate="10000", successRateReal="10000", successRateMax="10000", coin=local_coin.coin_7, luckyItem=local_luckyItem.luckyItem_1},
	{id=10049, productId={{2120020199,1,100}}, type=30, typeName="二代耳环", name="斯提克斯之灵", descriptiondefault="斯提克斯精工模具\n一代耳环\n祝福宝石\n灵魂宝石\n创造宝石\n玛雅之石", consumeItem={{3,0,0,99,0,9,2120010199,1},{1,1253000199,10},{1,1253000299,20},{1,1253000399,20},{1,1253000599,5},{1254010499,1}}, successRate="500", successRateReal="500", npcid=100120, coin=local_coin.coin_3, protect=local_protect.protect_2},
	{id=10050, productId={{2120021199,1,100}}, type=30, typeName="二代耳环", name="斯提克斯之泪", descriptiondefault="斯提克斯精工模具\n一代耳环\n祝福宝石\n灵魂宝石\n创造宝石\n玛雅之石", consumeItem={{3,0,0,99,0,9,2120011199,1},{1,1253000199,10},{1,1253000299,20},{1,1253000399,20},{1,1253000599,5},{1254010499,1}}, successRate="500", successRateReal="500", npcid=100120, coin=local_coin.coin_3, protect=local_protect.protect_2},
	{id=10051, productId={{2120030199,1,100}}, type=31, typeName="三代耳环", name="赫鲁斯之痕", descriptiondefault="斯提克斯精工模具\n二代耳环\n祝福宝石\n灵魂宝石\n创造宝石\n玛雅之石", consumeItem={{3,0,0,99,0,9,2120020199,1},{1,1253000199,200},{1,1253000299,66},{1,1253000399,66},{1,1253000599,200},{1254010499,5}}, successRate="500", successRateReal="500", successRateMax="4000", npcid=100120, protect=local_protect.protect_2},
	{id=10052, productId={{2120031199,1,100}}, type=31, typeName="三代耳环", name="赫鲁斯之耀", descriptiondefault="斯提克斯精工模具\n二代耳环\n祝福宝石\n灵魂宝石\n创造宝石\n玛雅之石", consumeItem={{3,0,0,99,0,9,2120021199,1},{1,1253000199,200},{1,1253000299,66},{1,1253000399,66},{1,1253000599,200},{1254010499,5}}, successRate="500", successRateReal="500", successRateMax="4000", npcid=100120, protect=local_protect.protect_2},
	{id=10053, productId={{1180000199,1,40}}, type=32, typeName="天鹰合成", name="天鹰兽之灵魂", descriptiondefault="天鹰兽之灵魂\n祝福宝石\n灵魂宝石\n玛雅之石\n创造宝石\n生命宝石", consumeItem={{1,1254005099,1},{1,1253000299,99},{1,1253000399,99},{1,1253000199,666},{1,1253000599,666},{1,1253000499,6}}, consumeItem2=local_consumeItem2.consumeItem2_1, successRate="9000", successRateReal="9000", successRateMax="10000", npcid=100120, coin=local_coin.coin_10, protect=local_protect.protect_2},
	{id=10054, productId={{1190000199,1,40}}, type=33, typeName="黑王马合成", name="黑王马兽之灵魂", descriptiondefault="黑王马兽之灵魂\n祝福宝石\n灵魂宝石\n玛雅之石\n创造宝石\n生命宝石", consumeItem={{1,1254005199,1},{1,1253000299,1},{1,1253000399,1},{1,1253000199,1},{1,1253000599,1},{1,1253000499,2}}, successRate="500", successRateReal="500", successRateMax="3000", npcid=100120, coin=local_coin.coin_10, protect=local_protect.protect_2},
	{id=10055, productId={{2000000299,1,100}}, type=36, typeName="葬月战旗", name="葬月战旗", descriptiondefault="奔雷战旗\n祝福宝石\n灵魂宝石\n玛雅之石\n生命宝石", consumeItem={{1,2000000199,2},{1,1253000299,66},{1,1253000399,66},{1,1253000199,66},{1,1253000499,3}}, consumeItem2=local_consumeItem2.consumeItem2_1, successRate="3500", successRateReal="3500", successRateMax="3500", npcid=100120, coin=local_coin.coin_3, protect=local_protect.protect_2},
	{id=10056, productId={{2000000399,1,100}}, type=37, typeName="凌乾战旗", name="凌乾战旗", descriptiondefault="葬月战旗\n祝福宝石\n灵魂宝石\n玛雅之石\n生命宝石", consumeItem={{1,2000000299,2},{1,1253000299,88},{1,1253000399,88},{1,1253000199,88},{1,1253000499,5}}, consumeItem2=local_consumeItem2.consumeItem2_1, successRate="3500", successRateReal="3500", successRateMax="3500", npcid=100120, protect=local_protect.protect_2},
	{id=10057, productId={{2000000499,1,100}}, type=38, typeName="御荒战旗", name="御荒战旗", descriptiondefault="凌乾战旗\n祝福宝石\n灵魂宝石\n玛雅之石\n生命宝石", consumeItem={{1,2000000399,2},{1,1253000299,99},{1,1253000399,99},{1,1253000199,99},{1,1253000499,10}}, consumeItem2=local_consumeItem2.consumeItem2_1, successRate="3500", successRateReal="3500", successRateMax="3500", npcid=100120, coin=local_coin.coin_11, protect=local_protect.protect_2},
}

local defaults = {productId={{1019199,1,20},{1124199,1,20},{1098199,1,20},{1144199,1,20},{1058199,1,20}}, synthesisType={1}, type=3, typeName="门票", subType=0, subTypeName="", descriptiondefault="玛雅之石\n血色门票材料\n恶魔门票材料", composeTime="1000", level=1, career={}, consumeItem={{1,1160000499,1},{1,1253000599,10},{1,1253000199,5},{2,4,1,99,0,0,1}}, consumeItem2={{1,1253000299,500},{1,1253000399,300}}, reduceitemrate=0, specialConsumeRate={}, specialConsumeRateMax=0, arbitrarily={}, timesOpen=2, successRate="5000", successRateReal="5000", successRateMax="5000", successOpen=0, transfer=0, inheritEntry=0, guarantees=0, showCondition="", synthesisCondition="", npcid=100404, checkType=0, checkParam={}, coin={10040001,1000}, fail={}, protect={}, luckyItem={1254004099,1000}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_synthesis) do
	setmetatable(v, mt)
end

return cfg_synthesis