-- 此文件工具自动生成，不要修改
---@class cfg_shopMall_column
---//序号 
---前4位子页签id，后三位序号
---@field id number @id column=1 A
---道具id
---@field itemId number @道具id column=2 B
---@field itemName string @道具名称 column=3 C
---货币类型#价格
---货币类型：货币ID
---例：钻石#价格
---@field price IntList @ column=4 D
---@field priceText string @价格文本 column=5 E
---商品归属的页签id
---取自cfg_menu_layer表
---@field subTab IntList @子页签 column=6 F
---限购数量
---0为不设上限
---其余数字为对应限购次数
---[[客户端不使用]]@field purchasing number @限购数量 column=7 G
---限购设定
---0=不限购 1=每日限购        2=每周限购 
---3=每月限购
---4=永久限购
---@field limitBuy number @限购类型 column=8 H
---达到此等级 才能购买
---不填=没有等级限制 直接展示
---@field level IntList @限购等级 column=9 I
---达到此职业 才能购买
---不填=没有职业限制 直接展示
---@field occupation IntListList @限购职业 column=10 J
---数量
---@field count number @道具数量 column=11 K
---不填为不隐藏 填1为隐藏
---@field show number @不满足条件时是否隐藏 column=12 L
---猎魔积分争霸赛赛季限购，引用cfg_global表27006字段，不配或配0为没有限购条件
---@field lieMoSeason number @限购赛季 column=13 M
---@field hot number @热销标记 column=14 N

local local_price = {
    price_1={10250001,90},
    price_2={10250001,60},
    price_3={10250001,980},
    price_4={10250001,600},
    price_5={10250001,100},
    price_6={10250001,80},
    price_7={10250001,480},
    price_8={10250001,880},
    price_9={10250001,380},
    price_10={10250001,88},
    price_11={10250001,99},
    price_12={10250001,50},
    price_13={10250001,200},
    price_14={10040001,1880},
    price_15={10040001,580},
    price_16={10040001,2980},

}

local local_subTab = {
    subTab_1={1030},
    subTab_2={1031},
    subTab_3={1032},
    subTab_4={3012},
    subTab_5={3014},
    subTab_6={5001},
    subTab_7={5002},
    subTab_8={5003},

}

local local_level = {
    level_1={},

}

local local_occupation = {
    occupation_1={{8,1}},
    occupation_2={},

}

local cfg_shopMall =
{
	{id=1030027, itemId=101507099, itemName="加速卷轴", price=local_price.price_1, subTab=local_subTab.subTab_1},
	{id=1030028, itemId=101507199, itemName="防御卷轴", price=local_price.price_2, subTab=local_subTab.subTab_1},
	{id=1030029, itemId=101507299, itemName="愤怒卷轴", price=local_price.price_1, subTab=local_subTab.subTab_1},
	{id=1030030, itemId=101507399, itemName="魔力卷轴", price=local_price.price_2, subTab=local_subTab.subTab_1},
	{id=1030031, itemId=101507499, itemName="体力卷轴", price=local_price.price_2, subTab=local_subTab.subTab_1},
	{id=1030033, itemId=100000009, itemName="大型防护药水*99", price={10250001,98}, subTab=local_subTab.subTab_1, occupation=local_occupation.occupation_2},
	{id=1031001, itemId=1253001799, itemName="还原宝石", price={10250001,680}},
	{id=1031002, itemId=31020002, itemName="大师天赋洗点果实", price=local_price.price_4},
	{id=1031003, itemId=2120010199, itemName="艾利尼斯之殇", price=local_price.price_8, occupation=local_occupation.occupation_2},
	{id=1031004, itemId=2120011199, itemName="艾利尼斯之怒", price={10250001,1580}, occupation=local_occupation.occupation_2},
	{id=1031005, itemId=1160000399, itemName="炎狼兽(可交易)", price={10250001,2800}, occupation=local_occupation.occupation_2},
	{id=1031006, itemId=1254006799, itemName="幸运宝石"},
	{id=1031007, itemId=210010399, itemName="光之石强化符文", price=local_price.price_9},
	{id=1031008, itemId=1254003899, itemName="合成保护符咒"},
	{id=1031009, itemId=1254004099, itemName="幸运符咒"},
	{id=1031010, itemId=1269000199, itemName="洗点药水", price=local_price.price_4},
	{id=1031011, itemId=1270002999, itemName="免罪符", price={10250001,180}, hot=1},
	{id=1031012, itemId=200002999, itemName="恶魔广场自由入场券", price=local_price.price_5},
	{id=1031013, itemId=101404799, itemName="血色城堡自由入场券", price=local_price.price_5},
	{id=1031014, itemId=1254000299, itemName="仓库扩展书", price=local_price.price_6},
	{id=1031015, itemId=1254000199, itemName="背包石", price=local_price.price_6},
	{id=1031016, itemId=1269000299, itemName="角色改名卡", price=local_price.price_7},
	{id=1031017, itemId=1269000399, itemName="战盟改名卡", price=local_price.price_7},
	{id=1032016, itemId=60080001, itemName="魔剑士角色卡片", subTab=local_subTab.subTab_3, occupation=local_occupation.occupation_2},
	{id=1032017, itemId=60080002, itemName="圣导师角色卡片", price={10250001,1280}, subTab=local_subTab.subTab_3, occupation=local_occupation.occupation_2},
	{id=1032018, itemId=60080003, itemName="召唤师角色卡片", price={10250001,2580}, subTab=local_subTab.subTab_3, occupation=local_occupation.occupation_2},
	{id=3012003, itemId=31020002, itemName="大师天赋洗点果实", price={10250001,500}, subTab=local_subTab.subTab_4, occupation=local_occupation.occupation_2},
	{id=3012004, itemId=1254006799, itemName="幸运宝石", price=local_price.price_8, subTab=local_subTab.subTab_4, occupation=local_occupation.occupation_2},
	{id=3012005, itemId=1269000199, itemName="洗点药水", price={10250001,588}, subTab=local_subTab.subTab_4, occupation=local_occupation.occupation_2},
	{id=3012006, itemId=1270002999, itemName="免罪符", price=local_price.price_10, subTab=local_subTab.subTab_4, occupation=local_occupation.occupation_2},
	{id=3012007, itemId=1269000299, itemName="角色改名卡", price=local_price.price_9, subTab=local_subTab.subTab_4, occupation=local_occupation.occupation_2},
	{id=3012008, itemId=1269000399, itemName="战盟改名卡", price={10250001,580}, subTab=local_subTab.subTab_4, occupation=local_occupation.occupation_2},
	{id=3012009, itemId=1254000199, itemName="背包石", price=local_price.price_10, subTab=local_subTab.subTab_4, occupation=local_occupation.occupation_2},
	{id=3012010, itemId=200002999, itemName="恶魔广场自由入场券", price=local_price.price_11, subTab=local_subTab.subTab_4, occupation=local_occupation.occupation_2},
	{id=3012011, itemId=101404799, itemName="血色城堡自由入场券", price=local_price.price_11, subTab=local_subTab.subTab_4, occupation=local_occupation.occupation_2},
	{id=3014020, itemId=1252000499, itemName="帝王之书", price=local_price.price_12, subTab=local_subTab.subTab_5, occupation=local_occupation.occupation_2},
	{id=3014021, itemId=1252000599, itemName="先知之魂", price=local_price.price_12, subTab=local_subTab.subTab_5, occupation=local_occupation.occupation_2},
	{id=3014022, itemId=1252000699, itemName="断魂之剑", price=local_price.price_12, subTab=local_subTab.subTab_5, occupation=local_occupation.occupation_2},
	{id=3014023, itemId=1252000799, itemName="精灵之泪", price=local_price.price_12, subTab=local_subTab.subTab_5, occupation=local_occupation.occupation_2},
	{id=3014024, itemId=1252001299, itemName="荣誉戒指", price=local_price.price_5, subTab=local_subTab.subTab_5, occupation=local_occupation.occupation_2},
	{id=3014025, itemId=1252001399, itemName="暗黑之石", price=local_price.price_5, subTab=local_subTab.subTab_5, occupation=local_occupation.occupation_2},
	{id=3014026, itemId=1252000999, itemName="炽炎魔的火种", price=local_price.price_13, subTab=local_subTab.subTab_5, occupation=local_occupation.occupation_2},
	{id=3014027, itemId=1252001099, itemName="丛林召唤者的角", price=local_price.price_13, subTab=local_subTab.subTab_5, occupation=local_occupation.occupation_2},
	{id=3014028, itemId=1252001199, itemName="天魔菲尼斯的羽毛", price=local_price.price_13, subTab=local_subTab.subTab_5, occupation=local_occupation.occupation_2},
	{id=5001001, itemId=10101001, itemName="称号：叱咤风云", price={10040001,58}, priceText="瑞币", subTab=local_subTab.subTab_6, occupation=local_occupation.occupation_2},
	{id=5001002, itemId=10101002, itemName="称号：杀戮之王", price={10040001,128}, priceText="瑞币", subTab=local_subTab.subTab_6, occupation=local_occupation.occupation_2},
	{id=5001003, itemId=10101003, itemName="称号：君临天下", price={10040001,328}, priceText="瑞币", subTab=local_subTab.subTab_6, occupation=local_occupation.occupation_2},
	{id=5001004, itemId=10101004, itemName="称号：恶魔猎人", price={10040001,588}, priceText="瑞币", subTab=local_subTab.subTab_6, occupation=local_occupation.occupation_2},
	{id=5002001, itemId=2140000899, itemName="强化天使", price=local_price.price_14, priceText="瑞币", subTab=local_subTab.subTab_7, occupation=local_occupation.occupation_2},
	{id=5002002, itemId=2140000799, itemName="强化恶魔", price=local_price.price_14, priceText="瑞币", subTab=local_subTab.subTab_7, occupation=local_occupation.occupation_2},
	{id=5002003, itemId=2000000199, itemName="奔雷战旗", price=local_price.price_16, priceText="瑞币", subTab=local_subTab.subTab_7, occupation=local_occupation.occupation_2},
	{id=5002004, itemId=1254003899, itemName="合成保护符咒", price=local_price.price_15, priceText="瑞币", subTab=local_subTab.subTab_8, occupation=local_occupation.occupation_2},
	{id=5002005, itemId=1254004099, itemName="幸运符咒", price=local_price.price_15, priceText="瑞币", subTab=local_subTab.subTab_8, occupation=local_occupation.occupation_2},
	{id=5004001, itemId=1268000499, itemName="光明法师角色卡片", price=local_price.price_16, priceText="瑞币", subTab={5004}, occupation=local_occupation.occupation_2},
}

local defaults = {price={10250001,980}, priceText="积分", subTab={1031}, limitBuy=0, level={}, occupation={{8,1}}, count=1, show=1, lieMoSeason=0, hot=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_shopMall) do
	setmetatable(v, mt)
end

return cfg_shopMall