-- 此文件工具自动生成，不要修改
---@class cfg_card_shapeshift_column
---填写变身卡牌道具id
---@field id number @唯一id column=1 A
---卡牌等级
---@field level number @卡牌等级 column=2 B
---1：蓝
---2：金
---3：红
---@field quality number @卡牌品质 column=3 C
---卡牌组id，同卡牌组升级消耗自身卡牌
---@field group number @卡牌组 column=4 D
---卡牌评分
---@field score number @卡牌评分 column=5 E
---消耗同卡牌id数量进行升级
---升到下一级的消耗的卡牌应该读当前卡牌的配置
---满级时配置为0
---@field upAmount number @升级数量 column=6 F
---变身怪物模型
---读取model_monster/id
---填0或空表示无变身功能
---@field model number @变身模型 column=7 G
---变身怪物名称
---@field name string @变身怪物名称 column=8 H
---格式：中心图
---@field img strin @卡牌图片 column=9 I
---根据unity Transform 组件position参数x，y轴进行偏移
---格式：X坐标#Y坐标
---不填不生效
---@field position IntList @图片偏移 column=10 J
---根据unity Transform 组件scale参数进行缩放
---不填不生效
---@field scale number @图片缩放 column=11 K
---格式：属性id#数值|属性id#数值
---@field attribute IntListList @基础属性 column=12 L
---格式：词条库组id#词条库组id
---读取cfg_card_att表组id，配置数量表示生成词条数量，每级词条累加
---@field specialAtt IntList @特殊词条 column=13 M
---变身所获取的技能
---格式：技能id#技能等级|技能id#技能等级
---@field skill IntListList @变身技能 column=14 N
---单位为毫秒
---@field time number @变身时间 column=15 O
---单位为毫秒
---不填表示0
---@field cd number @变身冷却 column=16 P
---单位为毫秒
---不填表示0
---@field commonCd number @变身公共冷却 column=17 Q
---[[客户端不使用]]@field   @ column=18 R
---[[客户端不使用]]@field   @ column=19 S

local local_position = {
    position_1={},
    position_2={0,5},

}

local local_attribute = {
    attribute_1={{200011,2},{200021,3},{206011,2},{207011,52}},
    attribute_2={{200011,5},{200021,8},{206011,6},{207011,143}},
    attribute_3={{200011,9},{200021,15},{206011,11},{207011,289}},
    attribute_4={{200011,14},{200021,23},{206011,16},{207011,471}},
    attribute_5={{200011,20},{200021,33},{206011,23},{207011,703}},
    attribute_6={{200011,27},{200021,44},{206011,31},{207011,1006}},
    attribute_7={{200011,34},{200021,57},{206011,40},{207011,1370}},
    attribute_8={{200011,43},{200021,71},{206011,50},{207011,1809}},
    attribute_9={{200011,53},{200021,88},{206011,61},{207011,2354}},
    attribute_10={{200011,63},{200021,106},{206011,73},{207011,2975}},
    attribute_11={{200011,75},{200021,124},{206011,87},{207011,3686}},
    attribute_12={{200011,87},{200021,144},{206011,101},{207011,4501}},
    attribute_13={{200011,98},{200021,164},{206011,114},{207011,5348}},
    attribute_14={{200011,110},{200021,184},{206011,128},{207011,6282}},
    attribute_15={{200011,124},{200021,207},{206011,144},{207011,7416}},
    attribute_16={{200011,157},{200021,261},{206011,161},{207011,10417}},
    attribute_17={{200011,192},{200021,320},{206011,191},{207011,15019}},
    attribute_18={{200011,232},{200021,387},{206011,227},{207011,20127}},
    attribute_19={{200011,276},{200021,460},{206011,270},{207011,26793}},
    attribute_20={{200011,335},{200021,558},{206011,322},{207011,35275}},
    attribute_21={{200011,1},{200021,2},{206011,1},{207011,26}},
    attribute_22={{200011,2},{200021,4},{206011,3},{207011,71}},
    attribute_23={{200011,5},{200021,8},{206011,5},{207011,144}},
    attribute_24={{200011,7},{200021,12},{206011,8},{207011,235}},
    attribute_25={{200011,10},{200021,16},{206011,11},{207011,351}},
    attribute_26={{200011,13},{200021,22},{206011,15},{207011,503}},
    attribute_27={{200011,17},{200021,29},{206011,20},{207011,685}},
    attribute_28={{200011,21},{200021,36},{206011,25},{207011,904}},
    attribute_29={{200011,26},{200021,44},{206011,31},{207011,1177}},
    attribute_30={{200011,32},{200021,53},{206011,37},{207011,1488}},
    attribute_31={{200011,37},{200021,62},{206011,43},{207011,1843}},
    attribute_32={{200011,43},{200021,72},{206011,50},{207011,2250}},
    attribute_33={{200011,49},{200021,82},{206011,57},{207011,2674}},
    attribute_34={{200011,55},{200021,92},{206011,64},{207011,3141}},
    attribute_35={{200011,62},{200021,104},{206011,72},{207011,3708}},
    attribute_36={{200011,78},{200021,131},{206011,81},{207011,5208}},
    attribute_37={{200011,96},{200021,160},{206011,96},{207011,7510}},
    attribute_38={{200011,116},{200021,193},{206011,114},{207011,10064}},
    attribute_39={{200011,138},{200021,230},{206011,135},{207011,13485}},
    attribute_40={{200011,167},{200021,279},{206011,161},{207011,17637}},

}

local local_specialAtt = {
    specialAtt_1={},
    specialAtt_2={1},
    specialAtt_3={3},
    specialAtt_4={6},
    specialAtt_5={7},
    specialAtt_6={9},
    specialAtt_7={12},

}

local local_skill = {
    skill_1={{2040051,3},{2200052,1},{2200051,2},{2000051,1},{2000052,1}},
    skill_2={{2040051,4},{2200052,1},{2200051,2},{2000051,1},{2000052,1}},
    skill_3={{2040051,5},{2200052,1},{2200051,2},{2000051,1},{2000052,1}},
    skill_4={{2040061,3},{2200062,1},{2200061,2},{2000061,1},{2000062,1}},
    skill_5={{2040061,4},{2200062,1},{2200061,2},{2000061,1},{2000062,1}},
    skill_6={{2040061,5},{2200062,1},{2200061,2},{2000061,1},{2000062,1}},
    skill_7={},

}

local cfg_card_shapeshift =
{
	{id=80010111, quality=1, group=1, score=560, model=49001, name="地狱角魔", img="card_dyjm", skill={{2040011,1}}},
	{id=80010112, level=2, quality=1, group=1, score=1461, model=49001, name="地狱角魔", img="card_dyjm", attribute=local_attribute.attribute_2, skill={{2040011,1},{2200011,1}}},
	{id=80010113, level=3, quality=1, group=1, score=2812, model=49001, name="地狱角魔", img="card_dyjm", attribute=local_attribute.attribute_3, skill={{2040011,2},{2200011,1},{2000011,1}}},
	{id=80010114, level=4, quality=1, group=1, score=4374, model=49001, name="地狱角魔", img="card_dyjm", attribute=local_attribute.attribute_4, skill={{2040011,2},{2200011,2},{2000011,1}}},
	{id=80010115, level=5, quality=1, group=1, score=6240, upAmount=0, model=49001, name="地狱角魔", img="card_dyjm", attribute=local_attribute.attribute_5, skill={{2040011,3},{2200011,2},{2000011,1}}},
	{id=80010121, quality=1, group=2, score=560, model=49002, name="水晶鹿", img="card_sjl", skill={{2040021,1}}},
	{id=80010122, level=2, quality=1, group=2, score=1461, model=49002, name="水晶鹿", img="card_sjl", attribute=local_attribute.attribute_2, skill={{2040021,1},{2200021,1}}},
	{id=80010123, level=3, quality=1, group=2, score=2812, model=49002, name="水晶鹿", img="card_sjl", attribute=local_attribute.attribute_3, skill={{2040021,2},{2200021,1},{2000021,1}}},
	{id=80010124, level=4, quality=1, group=2, score=4374, model=49002, name="水晶鹿", img="card_sjl", attribute=local_attribute.attribute_4, skill={{2040021,2},{2200021,2},{2000021,1}}},
	{id=80010125, level=5, quality=1, group=2, score=6240, upAmount=0, model=49002, name="水晶鹿", img="card_sjl", attribute=local_attribute.attribute_5, skill={{2040021,3},{2200021,2},{2000021,1}}},
	{id=80010211, quality=2, group=3, score=8545, model=49003, name="泰克图斯", img="card_tkts", attribute=local_attribute.attribute_6, skill={{2040031,1}}},
	{id=80010212, level=2, quality=2, group=3, score=11161, model=49003, name="泰克图斯", img="card_tkts", attribute=local_attribute.attribute_7, skill={{2040031,1},{2200031,1}}},
	{id=80010213, level=3, quality=2, group=3, score=14158, model=49003, name="泰克图斯", img="card_tkts", attribute=local_attribute.attribute_8, skill={{2040031,2},{2200031,1},{2000031,1}}},
	{id=80010214, level=4, quality=2, group=3, score=17711, model=49003, name="泰克图斯", img="card_tkts", attribute=local_attribute.attribute_9, skill={{2040031,2},{2200032,1},{2200031,2},{2000031,1}}},
	{id=80010215, level=5, quality=2, group=3, score=21590, upAmount=0, model=49003, name="泰克图斯", img="card_tkts", attribute=local_attribute.attribute_10, skill={{2040031,3},{2200032,1},{2200031,2},{2000031,1}}},
	{id=80010221, quality=2, group=4, score=8545, model=49004, name="丛林召唤者", img="card_clzhz", attribute=local_attribute.attribute_6, skill={{2040041,1}}},
	{id=80010222, level=2, quality=2, group=4, score=11161, model=49004, name="丛林召唤者", img="card_clzhz", attribute=local_attribute.attribute_7, skill={{2040041,1},{2200041,1}}},
	{id=80010223, level=3, quality=2, group=4, score=14158, model=49004, name="丛林召唤者", img="card_clzhz", attribute=local_attribute.attribute_8, skill={{2040041,2},{2200041,1},{2000041,1}}},
	{id=80010224, level=4, quality=2, group=4, score=17711, model=49004, name="丛林召唤者", img="card_clzhz", attribute=local_attribute.attribute_9, skill={{2040041,2},{2200042,1},{2200041,2},{2000041,1}}},
	{id=80010225, level=5, quality=2, group=4, score=21590, upAmount=0, model=49004, name="丛林召唤者", img="card_clzhz", attribute=local_attribute.attribute_10, skill={{2040041,3},{2200042,1},{2200041,2},{2000041,1}}},
	{id=80010311, score=25835, model=49005, attribute=local_attribute.attribute_11, skill={{2040051,1}}},
	{id=80010312, level=2, score=30484, model=49005, attribute=local_attribute.attribute_12, skill={{2040051,1},{2200051,1}}},
	{id=80010313, level=3, score=35095, model=49005, attribute=local_attribute.attribute_13, skill={{2040051,2},{2200051,1},{2000051,1}}},
	{id=80010314, level=4, score=40004, model=49005, attribute=local_attribute.attribute_14, skill={{2040051,2},{2200052,1},{2200051,2},{2000051,1}}},
	{id=80010315, level=5, score=45852, model=49005, attribute=local_attribute.attribute_15, skill=local_skill.skill_1},
	{id=80010316, level=6, score=88461, model=49005, attribute=local_attribute.attribute_16, skill=local_skill.skill_1},
	{id=80010317, level=7, score=115324, model=49005, attribute=local_attribute.attribute_17, skill=local_skill.skill_2},
	{id=80010318, level=8, score=145551, model=49005, attribute=local_attribute.attribute_18, skill=local_skill.skill_2},
	{id=80010319, level=9, score=183230, model=49005, attribute=local_attribute.attribute_19, skill=local_skill.skill_3},
	{id=80010320, level=10, score=230236, upAmount=0, model=49005, attribute=local_attribute.attribute_20, skill=local_skill.skill_3},
	{id=80010321, group=6, score=25835, model=49006, name="大天使", img="card_tsspz", attribute=local_attribute.attribute_11, skill={{2040061,1}}},
	{id=80010322, level=2, group=6, score=30484, model=49006, name="大天使", img="card_tsspz", attribute=local_attribute.attribute_12, skill={{2040061,1},{2200061,1}}},
	{id=80010323, level=3, group=6, score=35095, model=49006, name="大天使", img="card_tsspz", attribute=local_attribute.attribute_13, skill={{2040061,2},{2200061,1},{2000061,1}}},
	{id=80010324, level=4, group=6, score=40004, model=49006, name="大天使", img="card_tsspz", attribute=local_attribute.attribute_14, skill={{2040061,2},{2200062,1},{2200061,2},{2000061,1}}},
	{id=80010325, level=5, group=6, score=45852, model=49006, name="大天使", img="card_tsspz", attribute=local_attribute.attribute_15, skill=local_skill.skill_4},
	{id=80010326, level=6, group=6, score=88461, model=49006, name="大天使", img="card_tsspz", attribute=local_attribute.attribute_16, skill=local_skill.skill_4},
	{id=80010327, level=7, group=6, score=115324, model=49006, name="大天使", img="card_tsspz", attribute=local_attribute.attribute_17, skill=local_skill.skill_5},
	{id=80010328, level=8, group=6, score=145551, model=49006, name="大天使", img="card_tsspz", attribute=local_attribute.attribute_18, skill=local_skill.skill_5},
	{id=80010329, level=9, group=6, score=183230, model=49006, name="大天使", img="card_tsspz", attribute=local_attribute.attribute_19, skill=local_skill.skill_6},
	{id=80010330, level=10, group=6, score=230236, upAmount=0, model=49006, name="大天使", img="card_tsspz", attribute=local_attribute.attribute_20, skill=local_skill.skill_6},
	{id=80020111, quality=1, group=7, score=280, name="碧蓝·赋能泰坦", img="card_blueArmor", attribute=local_attribute.attribute_21, specialAtt=local_specialAtt.specialAtt_2, time=0, cd=0},
	{id=80020112, level=2, quality=1, group=7, score=730, name="碧蓝·赋能泰坦", img="card_blueArmor", attribute=local_attribute.attribute_22, specialAtt=local_specialAtt.specialAtt_2, time=0, cd=0},
	{id=80020113, level=3, quality=1, group=7, score=1406, name="碧蓝·赋能泰坦", img="card_blueArmor", attribute=local_attribute.attribute_23, specialAtt=local_specialAtt.specialAtt_2, time=0, cd=0},
	{id=80020114, level=4, quality=1, group=7, score=2187, name="碧蓝·赋能泰坦", img="card_blueArmor", attribute=local_attribute.attribute_24, specialAtt=local_specialAtt.specialAtt_2, time=0, cd=0},
	{id=80020115, level=5, quality=1, group=7, score=3120, upAmount=0, name="碧蓝·赋能泰坦", img="card_blueArmor", attribute=local_attribute.attribute_25, specialAtt=local_specialAtt.specialAtt_2, time=0, cd=0},
	{id=80020211, quality=2, group=17, score=4273, name="耀金·赋能泰坦", img="card_goldenArmor", attribute=local_attribute.attribute_26, specialAtt={2,2,2,2,2}, time=0, cd=0},
	{id=80020212, level=2, quality=2, group=17, score=5581, name="耀金·赋能泰坦", img="card_goldenArmor", attribute=local_attribute.attribute_27, time=0, cd=0},
	{id=80020213, level=3, quality=2, group=17, score=7079, name="耀金·赋能泰坦", img="card_goldenArmor", attribute=local_attribute.attribute_28, specialAtt=local_specialAtt.specialAtt_3, time=0, cd=0},
	{id=80020214, level=4, quality=2, group=17, score=8855, name="耀金·赋能泰坦", img="card_goldenArmor", attribute=local_attribute.attribute_29, specialAtt=local_specialAtt.specialAtt_3, time=0, cd=0},
	{id=80020215, level=5, quality=2, group=17, score=10795, upAmount=0, name="耀金·赋能泰坦", img="card_goldenArmor", attribute=local_attribute.attribute_30, specialAtt=local_specialAtt.specialAtt_3, time=0, cd=0},
	{id=80020311, group=27, score=12918, name="赤炎·赋能泰坦", img="card_redArmor", attribute=local_attribute.attribute_31, specialAtt={4,4,4,4,4,5,5,5}, time=0, cd=0},
	{id=80020312, level=2, group=27, score=15242, name="赤炎·赋能泰坦", img="card_redArmor", attribute=local_attribute.attribute_32, time=0, cd=0},
	{id=80020313, level=3, group=27, score=17547, name="赤炎·赋能泰坦", img="card_redArmor", attribute=local_attribute.attribute_33, time=0, cd=0},
	{id=80020314, level=4, group=27, score=20002, name="赤炎·赋能泰坦", img="card_redArmor", attribute=local_attribute.attribute_34, time=0, cd=0},
	{id=80020315, level=5, group=27, score=22926, name="赤炎·赋能泰坦", img="card_redArmor", attribute=local_attribute.attribute_35, specialAtt=local_specialAtt.specialAtt_4, time=0, cd=0},
	{id=80020316, level=6, group=27, score=44231, name="赤炎·赋能泰坦", img="card_redArmor", attribute=local_attribute.attribute_36, specialAtt=local_specialAtt.specialAtt_4, time=0, cd=0},
	{id=80020317, level=7, group=27, score=57662, name="赤炎·赋能泰坦", img="card_redArmor", attribute=local_attribute.attribute_37, specialAtt=local_specialAtt.specialAtt_4, time=0, cd=0},
	{id=80020318, level=8, group=27, score=72776, name="赤炎·赋能泰坦", img="card_redArmor", attribute=local_attribute.attribute_38, specialAtt=local_specialAtt.specialAtt_4, time=0, cd=0},
	{id=80020319, level=9, group=27, score=91615, name="赤炎·赋能泰坦", img="card_redArmor", attribute=local_attribute.attribute_39, time=0, cd=0},
	{id=80020320, level=10, group=27, score=115118, upAmount=0, name="赤炎·赋能泰坦", img="card_redArmor", attribute=local_attribute.attribute_40, time=0, cd=0},
	{id=80030111, quality=1, group=8, score=280, name="碧蓝·神赋泰坦", img="card_blueWeapon", scale=1.6, attribute=local_attribute.attribute_21, specialAtt=local_specialAtt.specialAtt_5, time=0, cd=0},
	{id=80030112, level=2, quality=1, group=8, score=730, name="碧蓝·神赋泰坦", img="card_blueWeapon", scale=1.6, attribute=local_attribute.attribute_22, specialAtt=local_specialAtt.specialAtt_5, time=0, cd=0},
	{id=80030113, level=3, quality=1, group=8, score=1406, name="碧蓝·神赋泰坦", img="card_blueWeapon", scale=1.6, attribute=local_attribute.attribute_23, specialAtt=local_specialAtt.specialAtt_5, time=0, cd=0},
	{id=80030114, level=4, quality=1, group=8, score=2187, name="碧蓝·神赋泰坦", img="card_blueWeapon", scale=1.6, attribute=local_attribute.attribute_24, specialAtt=local_specialAtt.specialAtt_5, time=0, cd=0},
	{id=80030115, level=5, quality=1, group=8, score=3120, upAmount=0, name="碧蓝·神赋泰坦", img="card_blueWeapon", scale=1.6, attribute=local_attribute.attribute_25, specialAtt=local_specialAtt.specialAtt_5, time=0, cd=0},
	{id=80030211, quality=2, group=18, score=4273, name="耀金·神赋泰坦", img="card_goldenWeapon", position=local_position.position_2, scale=1.5, attribute=local_attribute.attribute_26, specialAtt={8,8,8,8,8}, time=0, cd=0},
	{id=80030212, level=2, quality=2, group=18, score=5581, name="耀金·神赋泰坦", img="card_goldenWeapon", position=local_position.position_2, scale=1.5, attribute=local_attribute.attribute_27, time=0, cd=0},
	{id=80030213, level=3, quality=2, group=18, score=7079, name="耀金·神赋泰坦", img="card_goldenWeapon", position=local_position.position_2, scale=1.5, attribute=local_attribute.attribute_28, specialAtt=local_specialAtt.specialAtt_6, time=0, cd=0},
	{id=80030214, level=4, quality=2, group=18, score=8855, name="耀金·神赋泰坦", img="card_goldenWeapon", position=local_position.position_2, scale=1.5, attribute=local_attribute.attribute_29, specialAtt=local_specialAtt.specialAtt_6, time=0, cd=0},
	{id=80030215, level=5, quality=2, group=18, score=10795, upAmount=0, name="耀金·神赋泰坦", img="card_goldenWeapon", position=local_position.position_2, scale=1.5, attribute=local_attribute.attribute_30, specialAtt=local_specialAtt.specialAtt_6, time=0, cd=0},
	{id=80030311, group=28, score=12918, name="赤炎·神赋泰坦", img="card_redWeapon", position=local_position.position_2, scale=1.5, attribute=local_attribute.attribute_31, specialAtt={10,10,10,10,10,11,11,11}, time=0, cd=0},
	{id=80030312, level=2, group=28, score=15242, name="赤炎·神赋泰坦", img="card_redWeapon", position=local_position.position_2, scale=1.5, attribute=local_attribute.attribute_32, time=0, cd=0},
	{id=80030313, level=3, group=28, score=17547, name="赤炎·神赋泰坦", img="card_redWeapon", position=local_position.position_2, scale=1.5, attribute=local_attribute.attribute_33, time=0, cd=0},
	{id=80030314, level=4, group=28, score=20002, name="赤炎·神赋泰坦", img="card_redWeapon", position=local_position.position_2, scale=1.5, attribute=local_attribute.attribute_34, time=0, cd=0},
	{id=80030315, level=5, group=28, score=22926, name="赤炎·神赋泰坦", img="card_redWeapon", position=local_position.position_2, scale=1.5, attribute=local_attribute.attribute_35, specialAtt=local_specialAtt.specialAtt_7, time=0, cd=0},
	{id=80030316, level=6, group=28, score=44231, name="赤炎·神赋泰坦", img="card_redWeapon", position=local_position.position_2, scale=1.5, attribute=local_attribute.attribute_36, specialAtt=local_specialAtt.specialAtt_7, time=0, cd=0},
	{id=80030317, level=7, group=28, score=57662, name="赤炎·神赋泰坦", img="card_redWeapon", position=local_position.position_2, scale=1.5, attribute=local_attribute.attribute_37, specialAtt=local_specialAtt.specialAtt_7, time=0, cd=0},
	{id=80030318, level=8, group=28, score=72776, name="赤炎·神赋泰坦", img="card_redWeapon", position=local_position.position_2, scale=1.5, attribute=local_attribute.attribute_38, specialAtt=local_specialAtt.specialAtt_7, time=0, cd=0},
	{id=80030319, level=9, group=28, score=91615, name="赤炎·神赋泰坦", img="card_redWeapon", position=local_position.position_2, scale=1.5, attribute=local_attribute.attribute_39, time=0, cd=0},
	{id=80030320, level=10, group=28, score=115118, upAmount=0, name="赤炎·神赋泰坦", img="card_redWeapon", position=local_position.position_2, scale=1.5, attribute=local_attribute.attribute_40, time=0, cd=0},
}

local defaults = {level=1, quality=3, group=5, upAmount=2, model=0, name="大恶魔", img="card_dem", position={}, scale=0, attribute={{200011,2},{200021,3},{206011,2},{207011,52}}, specialAtt={}, skill={}, time=40000, cd=240000, commonCd=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_card_shapeshift) do
	setmetatable(v, mt)
end

return cfg_card_shapeshift