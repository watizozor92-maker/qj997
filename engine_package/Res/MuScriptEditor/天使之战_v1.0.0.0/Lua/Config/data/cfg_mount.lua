-- 此文件工具自动生成，不要修改
---@class cfg_mount_column
---@field id number @坐骑id column=1 A
---@field name string @坐骑名称 column=2 B
---通过品质对坐骑进行分类处理
---@field type number @品质 column=3 C
---模型id
---@field icon string @坐骑头像 column=4 D
---道具id
---@field itemId number @道具id column=5 E
---移速加成，万分比1=10000
---关联cfg_global表id222
---@field speed number @移动速度加成 column=6 F
---属性id#数值|属性id#数值|属性id#数值cfg_att_info
---@field attribute IntListList @附加属性 column=7 G
---skill表id字段，技能表现，范围，
---@field skillID number @坐骑技能 column=8 H
---skill_info表skillLevel字段，技能说明，技能伤害
---@field skillLevel number @坐骑技能等级 column=9 I
---配1有装备，配0无装备
---@field mountEquip number @坐骑装备 column=10 J
---cfg_mount_model表id
---@field mountId number @模型id column=11 K
---卓越词条数量#坐骑ID
---@field replaceMount IntListList @根据卓越词条数替换模型 column=12 L
---缩放倍率
---@field scale number @场景模型缩放 column=13 M
---缩放倍率
---@field scale2 number @界面模型缩放 column=14 N
---距离
---@field horizontal number @模型挂点修正X column=15 O
---距离，两位小数
---@field height number @模型挂点修正Y column=16 P
---距离，两位小数
---@field around number @模型挂点修正Z column=17 Q
---cfg_mount_behaviour表id
---@field motion number @坐骑动画 column=18 R
---0：通用
---1：陆地
---2：水中
---3：空中
---@field area number @骑乘区域 column=19 S
---Y轴值
---@field hpp number @血条名称位置 column=20 T
---配1是为限时坐骑，到期坐骑消失，空或0为永久坐骑
---@field limitedtype number @是否为限时坐骑 column=21 U
---1、限时坐骑配置该字段，坐骑消失的时间
---2、单位为小时
---@field limitedtime number @限时时间 column=22 V
---控制角色骑乘坐骑时模型旋转
---格式：x#y#z
---@field rotation IntList @角色挂点旋转 column=23 W
---骑行时挂载坐骑上的特效
---格式：cfg_model_effect表id
---@field ridingEffect number @坐骑骑行特效 column=24 X
---0-显示
---1-不显示
---@field display number @是否显示在坐骑图鉴中 column=25 Y

local local_attribute = {
    attribute_1={},

}

local local_replaceMount = {
    replaceMount_1={},

}

local local_rotation = {
    rotation_1={0,-90,180},

}

local cfg_mount =
{
	{id=1, name="独角兽", type=1, icon="21600001", itemId=21600001, speed=500, mountId=1, scale=0.04, scale2=1, horizontal=-15, height=0.2, around=-35, motion=1, rotation={0,-90,270}},
	{id=2, name="彩云兽", type=1, icon="21600002", itemId=21600002, speed=600, mountId=2, scale=1.4, scale2=40, horizontal=0, height=1.4, motion=2},
	{id=3, type=2, itemId=21600003, speed=500, mountId=3, replaceMount={{1,32},{2,30},{3,31},{4,4},{5,5},{6,6}}},
	{id=4, name="雷刃炎狼兽", type=2, icon="21600012", itemId=21600004, speed=800, mountId=4},
	{id=5, name="乌狼兽", type=2, icon="21600013", itemId=21600005, mountId=5, motion=13},
	{id=6, name="金狼兽", type=2, icon="21600014", itemId=21600006, mountId=6},
	{id=7, name="黑王马", icon="21600015", itemId=21900001, speed=500, mountId=7, horizontal=-1, height=2.7, motion=4},
	{id=8, name="幽灵马", icon="21600016", itemId=21900002, speed=500, mountId=8, scale2=1, horizontal=-0.5, height=4.2, motion=4},
	{id=9, name="黄金马", icon="21600017", itemId=21900003, speed=500, mountId=9, scale2=1, horizontal=-0.5, height=4.2, motion=4},
	{id=10, name="白焰马", icon="21600018", itemId=21900004, speed=500, mountId=8, scale2=1, horizontal=-0.5, height=4.2, motion=4},
	{id=11, name="皇家铠马", icon="21600016", itemId=21600015, speed=600, mountId=8, horizontal=-1.5, height=4.2, motion=4, limitedtype=1, limitedtime=24},
	{id=12, name="金龙", icon="21600020", itemId=21600019, speed=1300, mountId=11, scale2=24, horizontal=0, height=2.6, motion=113},
	{id=13, name="白虎", icon="21600020", itemId=21600007, speed=600, mountId=12, horizontal=0, height=2.2, motion=114},
	{id=14, name="熊猫", icon="21600023", itemId=21600023, mountId=13, horizontal=-1.6, height=2.2, motion=114},
	{id=15, name="星冥龙", icon="21600030", itemId=21600030, speed=1500, mountId=14, scale2=24, horizontal=-0.5, height=3.4, motion=113},
	{id=16, name="雪鹿", icon="21600041", itemId=21600041, speed=800, mountId=15, horizontal=-0.5, height=2.6, motion=114},
	{id=17, name="白毛狮王", icon="21600043", itemId=21600043, speed=1200, mountId=16, horizontal=-0.7, height=1.6, motion=114, display=1},
	{id=18, name="冥焰马", icon="21600045", itemId=21600045, speed=800, mountId=17, horizontal=-0.5, height=3, motion=114},
	{id=19, name="草泥马", icon="21600047", itemId=21600047, speed=1200, mountId=18, horizontal=-0.8, motion=115, display=1},
	{id=20, name="大蝎子", icon="21600049", itemId=21600049, speed=1200, mountId=19, scale2=25, horizontal=-1.5, height=2.2, motion=115},
	{id=21, name="黄金天马", type=2, icon="21600051", itemId=21600051, speed=1200, mountId=20, horizontal=-0.8, height=3.2, motion=114, display=1},
	{id=22, name="狮鹫", icon="21600053", itemId=21600053, speed=1200, mountId=21, horizontal=0, height=2.8, motion=114, display=1},
	{id=23, name="水乌龟", icon="21600055", itemId=21600055, speed=1200, mountId=22, horizontal=-1, height=1.2, motion=115, display=1},
	{id=24, name="午夜", icon="21600057", itemId=21600057, mountId=7, horizontal=-1.5, height=3.4, motion=4, limitedtype=1, limitedtime=168, display=1},
	{id=25, name="绿林狂蝎", icon="21600059", itemId=21600059, mountId=24, horizontal=0.7, height=2.8, motion=115},
	{id=26, name="冻土冰狼", icon="21600060", itemId=21600060, mountId=25, horizontal=-1.5, height=2.8, motion=119},
	{id=27, name="星穹泽风", type=2, icon="21600061", itemId=21600061, mountId=26, horizontal=-0.75, height=3.8, motion=121},
	{id=28, name="灵珀蜗天", type=2, icon="21600062", itemId=21600062, speed=1200, mountId=27, horizontal=0, height=-1.8, motion=122, rotation={90,-270,180}},
	{id=29, name="碧霄瑶光", icon="21600063", itemId=21600063, speed=1200, mountId=28, horizontal=-1, height=-2.6, motion=123, rotation={180,-270,180}, display=1},
	{id=30, itemId=0, speed=500, mountId=29},
	{id=31, itemId=0, speed=800, mountId=30},
	{id=32, itemId=0, speed=800, mountId=31},
	{id=33, name="破坏炎狼兽", type=2, icon="21600013", itemId=21600105, mountId=5, motion=13},
	{id=34, name="守护炎狼兽", type=2, icon="21600014", itemId=21600106, mountId=6},
}

local defaults = {name="炎狼兽", type=3, icon="21600011", speed=1000, attribute={}, skillID=0, skillLevel=0, mountEquip=0, replaceMount={}, scale=1, scale2=30, horizontal=-1.3, height=2.5, around=0, motion=60004, area=0, hpp=2.5, limitedtype=0, limitedtime=0, rotation={0,-90,180}, ridingEffect=60001, display=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_mount) do
	setmetatable(v, mt)
end

return cfg_mount