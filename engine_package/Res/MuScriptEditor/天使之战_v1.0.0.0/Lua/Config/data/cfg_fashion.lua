-- 此文件工具自动生成，不要修改
---@class cfg_fashion_column
---item表道具id
---@field id number @道具id column=1 A
---备注，策划用
---@field note string @备注，策划用 column=2 B
---1.外观
---2.称号
---3.首饰盒
---4.幻化
---
---同时在多个界面显示即类型#类型
---@field type IntList @子页签类型 column=3 C
---读career表根职业id，不填则默认全职业解锁，填了后即只有填写职业能解锁，其他职业隐藏
---格式  根职业id#根职业id
---
---@field job IntList @对应职业解锁 column=4 D
---4类型用，等级不足时，隐藏该装备的模型
---@field level number @等级解锁 column=5 E
---读item表rank字段
---type字段类型4时使用
---@field grade number @品阶字段 column=6 F
---1不限时 
---2限时 
---3持续到下次该活动开启
---4 排行榜实时刷新
---变身戒指和守护皮肤持续时间通过item表控制 不读这里
---@field timeType number @时间类型 column=7 G
---看timeType字段
---永久不填
---2类型填：时#分#秒
---3类型填活动id
---4类型填排行榜id
---@field time IntList @时长 column=8 H
---1角色归属
---2账号归属
---@field vestedType number @归属类型 column=9 I
---解锁该道具后获得的属性加成
---格式：属性id#数值|属性id#数值
---@field att IntListList @属性加成 column=10 J
---type=4时生效
---格式：道具id#数量|道具id#数量
---@field deplete IntListList @消耗材料 column=11 K
---1、type=3时，改变变身后的模型大小 填模型百分比
---2、称号填空时默认300
---@field modelScale number @模型大小缩放 column=12 L
---填空时默认为100
---@field tipsScale number @tips模型大小缩放 column=13 M
---[[客户端不使用]]@field   @ column=14 N
---[[客户端不使用]]@field   @ column=15 O
---[[客户端不使用]]@field   @ column=16 P
---[[客户端不使用]]@field   @ column=17 Q
---[[客户端不使用]]@field   @ column=18 R
---[[客户端不使用]]@field   @ column=19 S
---[[客户端不使用]]@field   @ column=20 T
---[[客户端不使用]]@field   @ column=21 U
---[[客户端不使用]]@field   @ column=22 V
---[[客户端不使用]]@field   @ column=23 W
---[[客户端不使用]]@field   @ column=24 X
---[[客户端不使用]]@field   @ column=25 Y

local local_type = {
    type_1={1},
    type_2={2},
    type_3={3},
    type_4={4},

}

local local_job = {
    job_1={},
    job_2={1},
    job_3={2},
    job_4={3},

}

local local_time = {
    time_1={},
    time_2={72,0,0},
    time_3={24,0,0},
    time_4={168,0,0},

}

local local_att = {
    att_1={{201011,10},{201021,6},{207011,500},{311212,200},{312212,200}},
    att_2={{201011,10},{201021,6},{206011,250},{311012,100},{313012,100}},
    att_3={{201011,10},{201021,6},{207011,500},{311112,200},{312112,200}},
    att_4={{200011,32},{200021,32}},
    att_5={{200011,6},{200021,10},{207021,500}},
    att_6={},
    att_7={{200011,3},{200021,5},{207021,200}},
    att_8={{206011,20},{213021,7},{207011,50}},
    att_9={{201011,20},{201021,12},{207011,600},{311112,300},{312112,300}},
    att_10={{201011,20},{201021,12},{207011,600},{311212,300},{312212,300}},
    att_11={{201011,20},{201021,12},{206011,300},{311012,200},{313012,200}},

}

local local_deplete = {
    deplete_1={},
    deplete_2={{10010001,300000}},
    deplete_3={{10010001,330000}},
    deplete_4={{10010001,360000}},
    deplete_5={{10010001,390000}},
    deplete_6={{10010001,420000}},
    deplete_7={{10010001,450000}},
    deplete_8={{10010001,480000}},
    deplete_9={{10010001,510000}},
    deplete_10={{10010001,540000}},
    deplete_11={{10010001,570000}},

}

local cfg_fashion =
{
	{id=61300001, note="魔界幻龙皮肤", type=local_type.type_1, job=local_job.job_1, att=local_att.att_1, deplete=local_deplete.deplete_1, tipsScale=30},
	{id=61300004, note="小麋鹿皮肤", type=local_type.type_1, job=local_job.job_1, att=local_att.att_2, deplete=local_deplete.deplete_1, tipsScale=50},
	{id=61300005, note="独角天马皮肤", type=local_type.type_1, job=local_job.job_1, att=local_att.att_3, deplete=local_deplete.deplete_1, tipsScale=50},
	{id=61300006, note="幽冥蛛皮肤", type=local_type.type_1, job=local_job.job_1, att=local_att.att_1, deplete=local_deplete.deplete_1},
	{id=61300007, note="苍翼虎皮肤", type=local_type.type_1, job=local_job.job_1, att=local_att.att_2, deplete=local_deplete.deplete_1},
	{id=61300008, note="炎烈鸟皮肤", type=local_type.type_1, job=local_job.job_1, att=local_att.att_3, deplete=local_deplete.deplete_1},
	{id=21500002, note="称号：第一剑士", type=local_type.type_2, job=local_job.job_1, timeType=2, time=local_time.time_2, att=local_att.att_4, deplete=local_deplete.deplete_1},
	{id=21500003, note="称号：杀戮之王", type=local_type.type_2, job=local_job.job_1, timeType=2, time=local_time.time_2, vestedType=2, att=local_att.att_4, deplete=local_deplete.deplete_1},
	{id=21500007, note="称号：君临天下", type=local_type.type_2, job=local_job.job_1, timeType=2, time=local_time.time_4, att=local_att.att_8, deplete=local_deplete.deplete_1, modelScale=400},
	{id=21500009, note="称号：叱咤风云", type=local_type.type_2, job=local_job.job_1, att=local_att.att_5, deplete=local_deplete.deplete_1, modelScale=500},
	{id=21500010, note="称号：大人物", type=local_type.type_2, job=local_job.job_1, att=local_att.att_5, deplete=local_deplete.deplete_1, modelScale=500},
	{id=21500004, note="称号：罗兰城主", type=local_type.type_2, job=local_job.job_1, timeType=2, time={167,0,0}, deplete=local_deplete.deplete_1, modelScale=500},
	{id=21500020, note="称号：奇乐特权", type=local_type.type_2, job=local_job.job_1, deplete=local_deplete.deplete_1, modelScale=100},
	{id=21500021, note="称号：奇迹归来", type=local_type.type_2, job=local_job.job_1, att={{200011,50},{200021,50},{207021,200}}, deplete=local_deplete.deplete_1, modelScale=100},
	{id=21500022, note="称号：奇迹探险家", type=local_type.type_2, job=local_job.job_1, att=local_att.att_7, deplete=local_deplete.deplete_1, modelScale=100},
	{id=21500023, note="称号：奇迹征服者", type=local_type.type_2, job=local_job.job_1, att=local_att.att_7, deplete=local_deplete.deplete_1, modelScale=100},
	{id=21500024, note="称号：无敌好寂寞", type=local_type.type_2, job=local_job.job_1, timeType=2, time=local_time.time_3, att={{200011,3},{200021,5},{206011,3},{311112,500}}, deplete=local_deplete.deplete_1, modelScale=0.35},
	{id=21500025, note="称号：睥睨万物", type=local_type.type_2, job=local_job.job_1, timeType=2, time=local_time.time_3, att={{200011,6},{200021,10},{206011,5},{311112,1000}}, deplete=local_deplete.deplete_1, modelScale=0.35},
	{id=21500026, note="称号：金玉满堂", type=local_type.type_2, job=local_job.job_1, att={{200011,6},{200021,10},{305042,1000},{305062,1000},{325012,500}}, deplete=local_deplete.deplete_1, modelScale=100},
	{id=21500027, note="称号：次元新星", type=local_type.type_2, job=local_job.job_1, att={{200011,6},{200021,10},{305042,1000},{303062,1000},{306012,500}}, deplete=local_deplete.deplete_1, modelScale=100},
	{id=21500028, note="称号：冰封王座", type=local_type.type_2, job=local_job.job_1, timeType=2, time=local_time.time_4, att=local_att.att_8, deplete=local_deplete.deplete_1, modelScale=100},
	{id=61400001, note="半兽人变身指环", type=local_type.type_3, job=local_job.job_1, deplete=local_deplete.deplete_1, modelScale=100},
	{id=61400002, note="屠夫变身指环", type=local_type.type_3, job=local_job.job_1, vestedType=2, deplete=local_deplete.deplete_1, modelScale=100},
	{id=61400003, note="昆顿变身指环", type=local_type.type_3, job=local_job.job_1, att={{200041,50},{207021,1000}}, deplete=local_deplete.deplete_1, modelScale=100},
	{id=61400004, note="炼狱魔王变身指环", type=local_type.type_3, job=local_job.job_1, att=local_att.att_9, deplete=local_deplete.deplete_1, modelScale=100},
	{id=61400005, note="帝国粉碎者变身指环", type=local_type.type_3, job=local_job.job_1, att=local_att.att_10, deplete=local_deplete.deplete_1, modelScale=100},
	{id=61400006, note="汲魂者变身戒指", type=local_type.type_3, job=local_job.job_1, att=local_att.att_11, deplete=local_deplete.deplete_1, modelScale=75},
	{id=61400007, note="刀刃猎手变身戒指", type=local_type.type_3, job=local_job.job_1, att=local_att.att_9, deplete=local_deplete.deplete_1, modelScale=100},
	{id=61400008, note="帝国骑士团长变身戒指", type=local_type.type_3, job=local_job.job_1, att=local_att.att_10, deplete=local_deplete.deplete_1, modelScale=100},
	{id=61400009, note="帝国第四军团长变身戒指", type=local_type.type_3, job=local_job.job_1, att=local_att.att_11, deplete=local_deplete.deplete_1, modelScale=100},
	{id=20410121, level=1, grade=1, deplete=local_deplete.deplete_2},
	{id=20610121, level=1, grade=1, deplete=local_deplete.deplete_2},
	{id=20710121, level=1, grade=1, deplete=local_deplete.deplete_2},
	{id=20810121, level=1, grade=1, deplete=local_deplete.deplete_2},
	{id=20910121, level=1, grade=1, deplete=local_deplete.deplete_2},
	{id=20410221, note="2阶战士", level=20, grade=2, deplete=local_deplete.deplete_3},
	{id=20610221, note="2阶战士", level=20, grade=2, deplete=local_deplete.deplete_3},
	{id=20710221, note="2阶战士", level=20, grade=2, deplete=local_deplete.deplete_3},
	{id=20810221, note="2阶战士", level=20, grade=2, deplete=local_deplete.deplete_3},
	{id=20910221, note="2阶战士", level=20, grade=2, deplete=local_deplete.deplete_3},
	{id=20410321, note="3阶战士", level=40, grade=3, deplete=local_deplete.deplete_4},
	{id=20610321, note="3阶战士", level=40, grade=3, deplete=local_deplete.deplete_4},
	{id=20710321, note="3阶战士", level=40, grade=3, deplete=local_deplete.deplete_4},
	{id=20810321, note="3阶战士", level=40, grade=3, deplete=local_deplete.deplete_4},
	{id=20910321, note="3阶战士", level=40, grade=3, deplete=local_deplete.deplete_4},
	{id=20410421, note="4阶战士", level=60, grade=4, deplete=local_deplete.deplete_5},
	{id=20610421, note="4阶战士", level=60, grade=4, deplete=local_deplete.deplete_5},
	{id=20710421, note="4阶战士", level=60, grade=4, deplete=local_deplete.deplete_5},
	{id=20810421, note="4阶战士", level=60, grade=4, deplete=local_deplete.deplete_5},
	{id=20910421, note="4阶战士", level=60, grade=4, deplete=local_deplete.deplete_5},
	{id=20410521, note="5阶战士", level=100, grade=5, deplete=local_deplete.deplete_6},
	{id=20610521, note="5阶战士", level=100, grade=5, deplete=local_deplete.deplete_6},
	{id=20710521, note="5阶战士", level=100, grade=5, deplete=local_deplete.deplete_6},
	{id=20810521, note="5阶战士", level=100, grade=5, deplete=local_deplete.deplete_6},
	{id=20910521, note="5阶战士", level=100, grade=5, deplete=local_deplete.deplete_6},
	{id=20410621, note="6阶战士", level=150, grade=6, deplete=local_deplete.deplete_7},
	{id=20610621, note="6阶战士", level=150, grade=6, deplete=local_deplete.deplete_7},
	{id=20710621, note="6阶战士", level=150, grade=6, deplete=local_deplete.deplete_7},
	{id=20810621, note="6阶战士", level=150, grade=6, deplete=local_deplete.deplete_7},
	{id=20910621, note="6阶战士", level=150, grade=6, deplete=local_deplete.deplete_7},
	{id=20410721, note="7阶战士", level=200, grade=7, deplete=local_deplete.deplete_8},
	{id=20610721, note="7阶战士", level=200, grade=7, deplete=local_deplete.deplete_8},
	{id=20710721, note="7阶战士", level=200, grade=7, deplete=local_deplete.deplete_8},
	{id=20810721, note="7阶战士", level=200, grade=7, deplete=local_deplete.deplete_8},
	{id=20910721, note="7阶战士", level=200, grade=7, deplete=local_deplete.deplete_8},
	{id=20410821, note="8阶战士", level=250, grade=8, deplete=local_deplete.deplete_9},
	{id=20610821, note="8阶战士", level=250, grade=8, deplete=local_deplete.deplete_9},
	{id=20710821, note="8阶战士", level=250, grade=8, deplete=local_deplete.deplete_9},
	{id=20810821, note="8阶战士", level=250, grade=8, deplete=local_deplete.deplete_9},
	{id=20910821, note="8阶战士", level=250, grade=8, deplete=local_deplete.deplete_9},
	{id=20410921, note="9阶战士", level=300, grade=9, deplete=local_deplete.deplete_10},
	{id=20610921, note="9阶战士", level=300, grade=9, deplete=local_deplete.deplete_10},
	{id=20710921, note="9阶战士", level=300, grade=9, deplete=local_deplete.deplete_10},
	{id=20810921, note="9阶战士", level=300, grade=9, deplete=local_deplete.deplete_10},
	{id=20910921, note="9阶战士", level=300, grade=9, deplete=local_deplete.deplete_10},
	{id=20411021, note="10阶战士", level=350, grade=10},
	{id=20611021, note="10阶战士", level=350, grade=10},
	{id=20711021, note="10阶战士", level=350, grade=10},
	{id=20811021, note="10阶战士", level=350, grade=10},
	{id=20911021, note="10阶战士", level=350, grade=10},
	{id=20411121, note="11阶战士", level=400, grade=11},
	{id=20611121, note="11阶战士", level=400, grade=11},
	{id=20711121, note="11阶战士", level=400, grade=11},
	{id=20811121, note="11阶战士", level=400, grade=11},
	{id=20911121, note="11阶战士", level=400, grade=11},
	{id=20411221, note="12阶战士", level=450, grade=12},
	{id=20611221, note="12阶战士", level=450, grade=12},
	{id=20711221, note="12阶战士", level=450, grade=12},
	{id=20811221, note="12阶战士", level=450, grade=12},
	{id=20911221, note="12阶战士", level=450, grade=12},
	{id=20420121, note="1阶法师", job=local_job.job_3, level=1, grade=1, deplete=local_deplete.deplete_2},
	{id=20620121, note="1阶法师", job=local_job.job_3, level=1, grade=1, deplete=local_deplete.deplete_2},
	{id=20720121, note="1阶法师", job=local_job.job_3, level=1, grade=1, deplete=local_deplete.deplete_2},
	{id=20820121, note="1阶法师", job=local_job.job_3, level=1, grade=1, deplete=local_deplete.deplete_2},
	{id=20920121, note="1阶法师", job=local_job.job_3, level=1, grade=1, deplete=local_deplete.deplete_2},
	{id=20420221, note="2阶法师", job=local_job.job_3, level=20, grade=2, deplete=local_deplete.deplete_3},
	{id=20620221, note="2阶法师", job=local_job.job_3, level=20, grade=2, deplete=local_deplete.deplete_3},
	{id=20720221, note="2阶法师", job=local_job.job_3, level=20, grade=2, deplete=local_deplete.deplete_3},
	{id=20820221, note="2阶法师", job=local_job.job_3, level=20, grade=2, deplete=local_deplete.deplete_3},
	{id=20920221, note="2阶法师", job=local_job.job_3, level=20, grade=2, deplete=local_deplete.deplete_3},
	{id=20420321, note="3阶法师", job=local_job.job_3, level=40, grade=3, deplete=local_deplete.deplete_4},
	{id=20620321, note="3阶法师", job=local_job.job_3, level=40, grade=3, deplete=local_deplete.deplete_4},
	{id=20720321, note="3阶法师", job=local_job.job_3, level=40, grade=3, deplete=local_deplete.deplete_4},
	{id=20820321, note="3阶法师", job=local_job.job_3, level=40, grade=3, deplete=local_deplete.deplete_4},
	{id=20920321, note="3阶法师", job=local_job.job_3, level=40, grade=3, deplete=local_deplete.deplete_4},
	{id=20420421, note="4阶法师", job=local_job.job_3, level=60, grade=4, deplete=local_deplete.deplete_5},
	{id=20620421, note="4阶法师", job=local_job.job_3, level=60, grade=4, deplete=local_deplete.deplete_5},
	{id=20720421, note="4阶法师", job=local_job.job_3, level=60, grade=4, deplete=local_deplete.deplete_5},
	{id=20820421, note="4阶法师", job=local_job.job_3, level=60, grade=4, deplete=local_deplete.deplete_5},
	{id=20920421, note="4阶法师", job=local_job.job_3, level=60, grade=4, deplete=local_deplete.deplete_5},
	{id=20420521, note="5阶法师", job=local_job.job_3, level=100, grade=5, deplete=local_deplete.deplete_6},
	{id=20620521, note="5阶法师", job=local_job.job_3, level=100, grade=5, deplete=local_deplete.deplete_6},
	{id=20720521, note="5阶法师", job=local_job.job_3, level=100, grade=5, deplete=local_deplete.deplete_6},
	{id=20820521, note="5阶法师", job=local_job.job_3, level=100, grade=5, deplete=local_deplete.deplete_6},
	{id=20920521, note="5阶法师", job=local_job.job_3, level=100, grade=5, deplete=local_deplete.deplete_6},
	{id=20420621, note="6阶法师", job=local_job.job_3, level=150, grade=6, deplete=local_deplete.deplete_7},
	{id=20620621, note="6阶法师", job=local_job.job_3, level=150, grade=6, deplete=local_deplete.deplete_7},
	{id=20720621, note="6阶法师", job=local_job.job_3, level=150, grade=6, deplete=local_deplete.deplete_7},
	{id=20820621, note="6阶法师", job=local_job.job_3, level=150, grade=6, deplete=local_deplete.deplete_7},
	{id=20920621, note="6阶法师", job=local_job.job_3, level=150, grade=6, deplete=local_deplete.deplete_7},
	{id=20420721, note="7阶法师", job=local_job.job_3, level=200, grade=7, deplete=local_deplete.deplete_8},
	{id=20620721, note="7阶法师", job=local_job.job_3, level=200, grade=7, deplete=local_deplete.deplete_8},
	{id=20720721, note="7阶法师", job=local_job.job_3, level=200, grade=7, deplete=local_deplete.deplete_8},
	{id=20820721, note="7阶法师", job=local_job.job_3, level=200, grade=7, deplete=local_deplete.deplete_8},
	{id=20920721, note="7阶法师", job=local_job.job_3, level=200, grade=7, deplete=local_deplete.deplete_8},
	{id=20420821, note="8阶法师", job=local_job.job_3, level=250, grade=8, deplete=local_deplete.deplete_9},
	{id=20620821, note="8阶法师", job=local_job.job_3, level=250, grade=8, deplete=local_deplete.deplete_9},
	{id=20720821, note="8阶法师", job=local_job.job_3, level=250, grade=8, deplete=local_deplete.deplete_9},
	{id=20820821, note="8阶法师", job=local_job.job_3, level=250, grade=8, deplete=local_deplete.deplete_9},
	{id=20920821, note="8阶法师", job=local_job.job_3, level=250, grade=8, deplete=local_deplete.deplete_9},
	{id=20420921, note="9阶法师", job=local_job.job_3, level=300, grade=9, deplete=local_deplete.deplete_10},
	{id=20620921, note="9阶法师", job=local_job.job_3, level=300, grade=9, deplete=local_deplete.deplete_10},
	{id=20720921, note="9阶法师", job=local_job.job_3, level=300, grade=9, deplete=local_deplete.deplete_10},
	{id=20820921, note="9阶法师", job=local_job.job_3, level=300, grade=9, deplete=local_deplete.deplete_10},
	{id=20920921, note="9阶法师", job=local_job.job_3, level=300, grade=9, deplete=local_deplete.deplete_10},
	{id=20421021, note="10阶法师", job=local_job.job_3, level=350, grade=10},
	{id=20621021, note="10阶法师", job=local_job.job_3, level=350, grade=10},
	{id=20721021, note="10阶法师", job=local_job.job_3, level=350, grade=10},
	{id=20821021, note="10阶法师", job=local_job.job_3, level=350, grade=10},
	{id=20921021, note="10阶法师", job=local_job.job_3, level=350, grade=10},
	{id=20421121, note="11阶法师", job=local_job.job_3, level=400, grade=11},
	{id=20621121, note="11阶法师", job=local_job.job_3, level=400, grade=11},
	{id=20721121, note="11阶法师", job=local_job.job_3, level=400, grade=11},
	{id=20821121, note="11阶法师", job=local_job.job_3, level=400, grade=11},
	{id=20921121, note="11阶法师", job=local_job.job_3, level=400, grade=11},
	{id=20421221, note="12阶法师", job=local_job.job_3, level=450, grade=12},
	{id=20621221, note="12阶法师", job=local_job.job_3, level=450, grade=12},
	{id=20721221, note="12阶法师", job=local_job.job_3, level=450, grade=12},
	{id=20821221, note="12阶法师", job=local_job.job_3, level=450, grade=12},
	{id=20921221, note="12阶法师", job=local_job.job_3, level=450, grade=12},
	{id=20430121, note="1阶弓箭手", job=local_job.job_4, level=1, grade=1, deplete=local_deplete.deplete_2},
	{id=20630121, note="1阶弓箭手", job=local_job.job_4, level=1, grade=1, deplete=local_deplete.deplete_2},
	{id=20730121, note="1阶弓箭手", job=local_job.job_4, level=1, grade=1, deplete=local_deplete.deplete_2},
	{id=20830121, note="1阶弓箭手", job=local_job.job_4, level=1, grade=1, deplete=local_deplete.deplete_2},
	{id=20930121, note="1阶弓箭手", job=local_job.job_4, level=1, grade=1, deplete=local_deplete.deplete_2},
	{id=20430221, note="2阶弓箭手", job=local_job.job_4, level=20, grade=2, deplete=local_deplete.deplete_3},
	{id=20630221, note="2阶弓箭手", job=local_job.job_4, level=20, grade=2, deplete=local_deplete.deplete_3},
	{id=20730221, note="2阶弓箭手", job=local_job.job_4, level=20, grade=2, deplete=local_deplete.deplete_3},
	{id=20830221, note="2阶弓箭手", job=local_job.job_4, level=20, grade=2, deplete=local_deplete.deplete_3},
	{id=20930221, note="2阶弓箭手", job=local_job.job_4, level=20, grade=2, deplete=local_deplete.deplete_3},
	{id=20430321, note="3阶弓箭手", job=local_job.job_4, level=40, grade=3, deplete=local_deplete.deplete_4},
	{id=20630321, note="3阶弓箭手", job=local_job.job_4, level=40, grade=3, deplete=local_deplete.deplete_4},
	{id=20730321, note="3阶弓箭手", job=local_job.job_4, level=40, grade=3, deplete=local_deplete.deplete_4},
	{id=20830321, note="3阶弓箭手", job=local_job.job_4, level=40, grade=3, deplete=local_deplete.deplete_4},
	{id=20930321, note="3阶弓箭手", job=local_job.job_4, level=40, grade=3, deplete=local_deplete.deplete_4},
	{id=20430421, note="4阶弓箭手", job=local_job.job_4, level=60, grade=4, deplete=local_deplete.deplete_5},
	{id=20630421, note="4阶弓箭手", job=local_job.job_4, level=60, grade=4, deplete=local_deplete.deplete_5},
	{id=20730421, note="4阶弓箭手", job=local_job.job_4, level=60, grade=4, deplete=local_deplete.deplete_5},
	{id=20830421, note="4阶弓箭手", job=local_job.job_4, level=60, grade=4, deplete=local_deplete.deplete_5},
	{id=20930421, note="4阶弓箭手", job=local_job.job_4, level=60, grade=4, deplete=local_deplete.deplete_5},
	{id=20430521, note="5阶弓箭手", job=local_job.job_4, level=100, grade=5, deplete=local_deplete.deplete_6},
	{id=20630521, note="5阶弓箭手", job=local_job.job_4, level=100, grade=5, deplete=local_deplete.deplete_6},
	{id=20730521, note="5阶弓箭手", job=local_job.job_4, level=100, grade=5, deplete=local_deplete.deplete_6},
	{id=20830521, note="5阶弓箭手", job=local_job.job_4, level=100, grade=5, deplete=local_deplete.deplete_6},
	{id=20930521, note="5阶弓箭手", job=local_job.job_4, level=100, grade=5, deplete=local_deplete.deplete_6},
	{id=20430621, note="6阶弓箭手", job=local_job.job_4, level=150, grade=6, deplete=local_deplete.deplete_7},
	{id=20630621, note="6阶弓箭手", job=local_job.job_4, level=150, grade=6, deplete=local_deplete.deplete_7},
	{id=20730621, note="6阶弓箭手", job=local_job.job_4, level=150, grade=6, deplete=local_deplete.deplete_7},
	{id=20830621, note="6阶弓箭手", job=local_job.job_4, level=150, grade=6, deplete=local_deplete.deplete_7},
	{id=20930621, note="6阶弓箭手", job=local_job.job_4, level=150, grade=6, deplete=local_deplete.deplete_7},
	{id=20430721, note="7阶弓箭手", job=local_job.job_4, level=200, grade=7, deplete=local_deplete.deplete_8},
	{id=20630721, note="7阶弓箭手", job=local_job.job_4, level=200, grade=7, deplete=local_deplete.deplete_8},
	{id=20730721, note="7阶弓箭手", job=local_job.job_4, level=200, grade=7, deplete=local_deplete.deplete_8},
	{id=20830721, note="7阶弓箭手", job=local_job.job_4, level=200, grade=7, deplete=local_deplete.deplete_8},
	{id=20930721, note="7阶弓箭手", job=local_job.job_4, level=200, grade=7, deplete=local_deplete.deplete_8},
	{id=20430821, note="8阶弓箭手", job=local_job.job_4, level=250, grade=8, deplete=local_deplete.deplete_9},
	{id=20630821, note="8阶弓箭手", job=local_job.job_4, level=250, grade=8, deplete=local_deplete.deplete_9},
	{id=20730821, note="8阶弓箭手", job=local_job.job_4, level=250, grade=8, deplete=local_deplete.deplete_9},
	{id=20830821, note="8阶弓箭手", job=local_job.job_4, level=250, grade=8, deplete=local_deplete.deplete_9},
	{id=20930821, note="8阶弓箭手", job=local_job.job_4, level=250, grade=8, deplete=local_deplete.deplete_9},
	{id=20430921, note="9阶弓箭手", job=local_job.job_4, level=300, grade=9, deplete=local_deplete.deplete_10},
	{id=20630921, note="9阶弓箭手", job=local_job.job_4, level=300, grade=9, deplete=local_deplete.deplete_10},
	{id=20730921, note="9阶弓箭手", job=local_job.job_4, level=300, grade=9, deplete=local_deplete.deplete_10},
	{id=20830921, note="9阶弓箭手", job=local_job.job_4, level=300, grade=9, deplete=local_deplete.deplete_10},
	{id=20930921, note="9阶弓箭手", job=local_job.job_4, level=300, grade=9, deplete=local_deplete.deplete_10},
	{id=20431021, note="10阶弓箭手", job=local_job.job_4, level=350, grade=10},
	{id=20631021, note="10阶弓箭手", job=local_job.job_4, level=350, grade=10},
	{id=20731021, note="10阶弓箭手", job=local_job.job_4, level=350, grade=10},
	{id=20831021, note="10阶弓箭手", job=local_job.job_4, level=350, grade=10},
	{id=20931021, note="10阶弓箭手", job=local_job.job_4, level=350, grade=10},
	{id=20431121, note="11阶弓箭手", job=local_job.job_4, level=400, grade=11},
	{id=20631121, note="11阶弓箭手", job=local_job.job_4, level=400, grade=11},
	{id=20731121, note="11阶弓箭手", job=local_job.job_4, level=400, grade=11},
	{id=20831121, note="11阶弓箭手", job=local_job.job_4, level=400, grade=11},
	{id=20931121, note="11阶弓箭手", job=local_job.job_4, level=400, grade=11},
	{id=20431221, note="12阶弓箭手", job=local_job.job_4, level=450, grade=12},
	{id=20631221, note="12阶弓箭手", job=local_job.job_4, level=450, grade=12},
	{id=20731221, note="12阶弓箭手", job=local_job.job_4, level=450, grade=12},
	{id=20831221, note="12阶弓箭手", job=local_job.job_4, level=450, grade=12},
	{id=20931221, note="12阶弓箭手", job=local_job.job_4, level=450, grade=12},
}

local defaults = {note="1阶战士", type={4}, job={1}, level=0, grade=0, timeType=1, time={}, vestedType=1, att={}, deplete={{10010001,570000}}, modelScale=0, tipsScale=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_fashion) do
	setmetatable(v, mt)
end

return cfg_fashion