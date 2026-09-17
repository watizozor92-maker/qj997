-- 此文件工具自动生成，不要修改
---@class cfg_damage_number_column
---普通
---普通掉血：101
---特殊
---未命中：108
---反弹伤害：109
---@field id number @id column=1 A
---名称备注
---[[客户端不使用]]@field name string @name column=2 B
---仅供策划读
---[[客户端不使用]]@field attackRelationship string @攻击关系 column=3 C
---飘字使用的艺术字图集配置，程序处理后给予图集名称在此处配置
---不填使用默认艺术字图集
---@field Atlas string @使用图集 column=4 D
---伤害数字的显示前缀，有文本、图标两种，文本直接配置文字，使用图标配置“t”，同时使用则配置“t+文本”，不配置则不显示
---@field prefix string @显示前缀 column=5 E
---飘字的尺寸缩放，填缩放倍数，默认100，填整数
---@field size number @显示尺寸 column=6 F
---控制自身飘血字体颜色，即自身被攻击所显示的飘字
---读cfg_color中id
---@field fontColor number @自身飘血字体颜色 column=7 G
---控制其他玩家飘血字体颜色，即攻击到其他目标所显示的飘字
---读cfg_color中id
---@field OtherFontColors number @其他目标飘字颜色 column=8 H
---判断伤害数字显示几重
---@field damageWeight number @伤害显示重数 column=9 I
---0或空为不可用
---1为可用
---@field enable number @开关 column=10 J
---1普通飘血(现在用的这种)
---2飘血方向为左上，到一定高度下坠，下坠速度略快
---3飘血方向为左上，越往上越大，越透明
---4飘血方向为右上，一直往上飘，直到消失
---5飘血方向为正上方，飘到一半放大展示，然后缩小，渐渐消失
---6飘血方向为正上方（位置比5高），飘到一半放大展示，然后缩小，渐渐消失
---11元素飘血（普通飘血，右下方一点，距离差一行的距离）
---对应：类别数字对应工程中DamageConfigNumber，此文件的数字
---@field type number @飘血效果 column=11 K
---文字的偏移量(s)|计算符的偏移量(o)|数值的偏移量(n)
---参数说明:
---文字的偏移量(s): s#x#y#z
---计算符的偏移量(s): o#x#y#z
---文字的偏移量(s): n#x#y#z
---@field typeParams StringListList @飘血效果参数 column=12 L
---不同id飘血的效果覆盖叠加的凭据值
---数值大的效果遮盖效果小的
---同数值效果后来的遮盖先出的
---@field Order number @层级 column=13 M
---最小透明度
---0到100，数值越大越透明，100完全透明
---@field miniumFadeto number @透明度 column=14 N

local local_typeParams = {
    typeParams_1={{"s","0","0","0"},{"o","0","0","0"},{"n","20","0","0"}},
    typeParams_2={{"s","-53","0","0"},{"o","0","0","0"},{"n","20","0","0"}},

}

local cfg_damage_number =
{
	{id=101, prefix="普通", OtherFontColors=10005, typeParams=local_typeParams.typeParams_1, miniumFadeto=20},
	{id=102, prefix="幸运", size=70, OtherFontColors=3012, type=5, typeParams=local_typeParams.typeParams_1, Order=2},
	{id=104, prefix="卓越", size=80, OtherFontColors=3013, type=5, typeParams=local_typeParams.typeParams_1},
	{id=104, prefix="卓越", size=80, fontColor=10001, OtherFontColors=3013, type=5, typeParams=local_typeParams.typeParams_1},
	{id=106, prefix="无视", size=90, OtherFontColors=10002, type=5, Order=4, miniumFadeto=30},
	{id=108, Atlas="DamageMissAtlas", prefix="", fontColor=3015, OtherFontColors=3014, Order=6},
	{id=109, prefix="反射", OtherFontColors=3017, Order=8},
	{id=116, prefix="燃烧", OtherFontColors=3019, Order=6},
	{id=117, prefix="中毒", fontColor=250, OtherFontColors=250, Order=6},
	{id=118, prefix="", fontColor=263, OtherFontColors=263, damageWeight=0, enable=0, typeParams=local_typeParams.typeParams_1, Order=2},
	{id=119, prefix="回蓝", fontColor=285, OtherFontColors=285, damageWeight=0, enable=0, typeParams=local_typeParams.typeParams_1, Order=2},
	{id=501, prefix="反弹", OtherFontColors=3017, Order=8},
	{id=601, prefix="普通-双倍", size=70, OtherFontColors=3011, damageWeight=2, typeParams=local_typeParams.typeParams_1, miniumFadeto=20},
	{id=602, prefix="幸运-双倍", size=70, OtherFontColors=3012, damageWeight=2, type=5, typeParams={{"s","0","0","0"},{"o","-5.74","8","0"},{"n","20","0","0"}}, Order=2},
	{id=603, prefix="卓越-双倍", size=80, OtherFontColors=3013, damageWeight=2, type=5, typeParams=local_typeParams.typeParams_1},
	{id=604, prefix="无视-双倍", size=90, OtherFontColors=254, damageWeight=2, type=5, Order=4, miniumFadeto=30},
	{id=605, prefix="致命-双倍", size=70, fontColor=287, OtherFontColors=287, damageWeight=2, type=5, Order=4, miniumFadeto=30},
	{id=301, prefix="连击", size=70, fontColor=180, OtherFontColors=180, damageWeight=2, type=5, Order=4, miniumFadeto=30},
}

local defaults = {Atlas="", size=60, fontColor=259, damageWeight=1, enable=1, type=1, typeParams={{"s","-53","0","0"},{"o","0","0","0"},{"n","20","0","0"}}, Order=1, miniumFadeto=40}
local mt = {__index = defaults}
for _, v in ipairs(cfg_damage_number) do
	setmetatable(v, mt)
end

return cfg_damage_number