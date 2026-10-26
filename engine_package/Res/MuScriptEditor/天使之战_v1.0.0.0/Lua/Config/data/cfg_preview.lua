-- 此文件工具自动生成，不要修改
---@class cfg_preview_column
---@field id number @编号 column=1 A
---填图标文件名称
---@field icon StringList @功能图标 column=2 B
---@field name StringListList @预告名称 column=3 C
---功能开启时间
---@field describe StringListListList @预告描述 column=4 D
---显示该预告的最小等级
---@field showLevel number @显示等级 column=5 E
---@field completionLevel number @完成任务等级 column=6 F
---达到该等级且奖励已领取则功能预告隐藏，若隐藏等级大于任务完成等级则领取奖励后出现前往按钮
---@field hideLevel number @任务隐藏等级 column=7 G
---格式：道具id#道具数量|道具id#道具数量
---@field item IntList @奖励道具 column=8 H
---对应面板名称
---格式：路径#参数 无参数可不填
---
---如果需要使用的面板无变化，如合成面板UISyntheticPanel，则直接填写面板id即可。
---如果需要使用的面板会变化，如NPC商店面板UINpcShopPanel，会根据商店编号，显示商品类型，这时就需要填写参数。
---有需要填写参数的地方，需要与对应面板制作程序沟通，进行填写[格式：面板名#参数 无参数可不填]
---@field openPanel StringListList @对应面板 column=9 I

local local_icon = {
    icon_1={"Atlas/KmlPreviewUI.spriteatlas","icon_zhanmengboss"},

}

local local_item = {
    item_1={10010002,10000},

}

local local_openPanel = {
    openPanel_1={},

}

local cfg_preview =
{
	{id=7, icon={"Atlas/KmlPreviewUI.spriteatlas","icon_xuesechengbao"}, name={{"血色城堡"}}, describe={{{"开启时间","全天开启"},{"游戏玩法","1.消耗1[透明披风]，根据自身等级，选择进入的层数。帮助受伤的大天使获取大天使之剑，即可获得奖励。\n2.在副本内击杀怪物有大量经验可以获得。\n3.每天限制次数4次，限制次数共享恶魔广场。"}}}, showLevel=9999, completionLevel=9999, openPanel={{"dev/outui/Activity/Panel/KLActivityDetail/KLActivityDetailPanel","11001"}}},
	{id=8, icon={"Atlas/KmlPreviewUI.spriteatlas","icon_emoguangchang"}, name={{"恶魔广场"}}, describe={{{"开启时间","全天开启"},{"游戏玩法","1.消耗[恶魔广场通行证]进入副本，根据自身等级选择进入的层数，经验极高。\n2.每天限制次数4次，限制次数共享恶魔广场。"}}}, showLevel=9999, completionLevel=9999, openPanel={{"dev/outui/Activity/Panel/KLActivityDetail/KLActivityDetailPanel","10001"}}},
	{id=9, name={{"游戏攻略"}}, describe={{{"版本介绍：所有人统一起跑线 一切靠打！"},{"装备设置：强化最高+15，全身强7以上额外增加强化大师属性，追加最高16，卓越最高6词条"},{"回收设置：装备回收得金币，卓越装备/宝石/羽毛/套装/卓越套装/回收得积分，"},{"回收设置：宝石/白装/幸运装/强化装/支持自动回收，贵重物品手动回收。仔细阅读回收面板/积分只能在游戏里面打怪回收装备获取。"}}}},
	{id=10, name={{"游戏玩法设定"}}, describe={{{"版本介绍：","1.无任何游戏数值道具氪点\n2.无自由交易系统，藏宝阁系统只要开通（畅玩卡）可以自由使用藏宝阁。\n3.本游戏没有特殊设置。\n4.全部免费，只要用时间去打一切皆有可能\n5.所有玩家统一起跑线/所有玩家氪点一样"}}}},
	{id=11, icon={"Atlas/KmlPreviewUI.spriteatlas","icon_langhunyaosai"}, name={{"狼魂要塞"}}, describe={{{"开启时间","每周一/四/日晚上8点30分"},{"游戏玩法","1.所有拥有战盟的玩家都可进入副本进行战斗。\n2.盟主及副盟主可消耗战盟资金召唤守护者共同战斗。\n3.战斗开始时，会在副本随机刷新出怪物朝狼神护台进攻，玩家需要将怪物在击败狼神护台前进行击杀"},{"狼魂要塞产出：稀有装备，极品套装（非洞装）坐骑材料。"},{"狼魂要塞为行会战盟副本/增加BOSS阶段"}}}},
	{id=13, name={{"宝石掉落"}}, describe={{{"宝石掉落：小怪和BOSS均可掉落宝石"},{"冰风谷-Lv.20：祝福宝石。"},{"地下城-Lv.30：祝福宝石、灵魂宝石。"},{"失落之塔-Lv.40：祝福宝石、灵魂宝石、玛雅之石。"},{"亚特兰蒂斯-Lv.70：祝福宝石、灵魂宝石、玛雅之石、生命宝石。"},{"死亡沙漠以上-Lv.130：祝福宝石、灵魂宝石、玛雅之石、生命宝石、创造宝石。"}}}, showLevel=9999, completionLevel=9999},
	{id=14, name={{"交易系统"}}, describe={{{"开通畅玩卡：玩家自由使用藏宝阁系统需。"},{"交易税：交易货币存在10%交易税。本服没有自由交易。一切靠打。"}}}},
	{id=15, name={{"红名PK系统"}}, showLevel=9999, completionLevel=9999},
	{id=16, name={{"萤石系统"}}, describe={{{"萤石玩法详解：","幻术园：47 242 可用套装抽取荧之石：\n荧之石加光之石可合成荧光宝石\n相同的荧光宝石（属性可不一样）且相同级别的荧光宝石+光之石强化符文可合成高等级荧光宝石\n光之石，在安宁池产出，光之石强化符文冰霜地图后面BOSS产出"}}}},
	{id=17, name={{"耳环系统"}}, describe={{{"耳环获取详解：","仙踪林合成，可用灵魂/祝福/玛雅/各一个合成饰品宝箱\n可以开出卓越装备/套装/耳环/技能书/积分/金币/一切看脸。搏一搏单车变摩托。一切皆有可能。"}}}},
	{id=18, name={{"挂机玩法"}}, describe={{{"挂机点说明：","每张大地图/有几个多怪物点。需玩家自由摸索。"}}}},
	{id=19, name={{"合成系统"}}, describe={{{"坐骑合成：","越高等级坐骑出现卓越词条几率越大"},{"满卓越6词条"},{"高等级坐骑增加移动速度"},{"在PVP,PVE中更有优势"},{"翅膀合成：","合成逻辑严格按照1.03H版本支持拔毛\n合成成功率所溢出的材料将会退回到背包不计算在内，保证材料避免丢失"}}}},
	{id=21, name={{"重要提示"}}, describe={{{"AG/SD详解：","战斗数值复刻国际副.Ag值，各职业增加对应的属性点，会有对应的AG/SD值加成。\n具体数值需玩家自行摸索。\nSD值，除基础属性提升，属性加成提升，高等级装备也会增加SD值。"},{"重要货币提醒：所有货币均为单角色储存，同账号多职业/角色不通用。"}}}},
}

local defaults = {icon={"Atlas/KmlPreviewUI.spriteatlas","icon_zhanmengboss"}, describe={{{"PK值：游戏PK线外击杀玩家会增加PK值；击杀非白名玩家不增加PK值。"},{"PK阶段：PK值根据大小对应PK阶段，PK阶段对应不同的死亡惩罚，副本内死亡没有死亡惩罚","白名：一位良民，PVP极小概率掉落宝石道具；死亡掉落4%金币(优先绑金)\n无赖：黄名，PVP有概率掉落宝石道具；死亡掉落4%金币，PVP额外扣除1%金币。\n恶人：红名，PVP较大概率掉落宝石道具；死亡掉落4%金币，PVP额外扣除2%金币；小概率掉落穿戴的装备\n恶魔：红名，PVP死亡极大概率掉落多个宝石道具；死亡掉落4%金币，PVP死亡额外扣除4%金币；PVE小概率掉落穿戴的装备，PVP极大概率掉落穿戴的装备。"},{"其他限制：PK值超过一定值时无法对其他玩家造成伤害，限制交易行使用与和平线路传送"},{"PK值减少：","打怪：玩家可以通过击杀怪物来减少PK值，等级越高减少越多\n免罪符：积分商城内购买，可用于快速清除全部PK点数。"},{"补充：","掉落的道具直接消失。"}}}, showLevel=1, completionLevel=1, hideLevel=9999, item={10010002,10000}, openPanel={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_preview) do
	setmetatable(v, mt)
end

return cfg_preview