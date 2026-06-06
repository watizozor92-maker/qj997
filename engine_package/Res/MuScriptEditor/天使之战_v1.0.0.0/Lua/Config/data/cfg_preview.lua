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
    icon_1={"Atlas/KmlPreviewUI.spriteatlas","icon_xuesechengbao"},
    icon_2={"Atlas/KmlPreviewUI.spriteatlas","icon_zhanmengboss"},

}

local local_item = {
    item_1={10010002,1000},

}

local local_openPanel = {
    openPanel_1={},

}

local cfg_preview =
{
	{id=7, icon=local_icon.icon_1, name={{"血色城堡"}}, describe={{{"开启时间","全天开启"},{"游戏玩法","1.消耗1[透明披风]，根据自身等级，选择进入的层数。帮助受伤的大天使获取大天使之剑，即可获得奖励。\n2.在副本内击杀怪物有大量经验可以获得。\n3.每天限制次数4次，限制次数共享恶魔广场。"}}}, showLevel=9999, completionLevel=9999, openPanel={{"dev/outui/Activity/Panel/KLActivityDetail/KLActivityDetailPanel","11001"}}},
	{id=8, icon={"Atlas/KmlPreviewUI.spriteatlas","icon_emoguangchang"}, name={{"恶魔广场"}}, describe={{{"开启时间","全天开启"},{"游戏玩法","1.消耗[恶魔广场通行证]进入副本，根据自身等级选择进入的层数，经验极高。\n2.每天限制次数4次，限制次数共享恶魔广场。"}}}, showLevel=9999, completionLevel=9999, openPanel={{"dev/outui/Activity/Panel/KLActivityDetail/KLActivityDetailPanel","10001"}}},
	{id=9, name={{"游戏攻略"}}, describe={{{"版本介绍：1.03H版本！5/6/7点 一切靠打，经典设置！"},{"线路规划：和平线路（不可PK）；PK线路（杀人不加杀气）"},{"装备设置：强化最高+15，全身强7以上额外增加强化大师属性，追加最高16，另外卓越最高6词条"},{"技能设置：战士-生命之光最高30%，法师-守护之魂最高30%，弓手BUFF最高120点攻击和120点防御"},{"回收设置：装备回收得金币，卓越装备/宝石/马魂/羽毛/套装/卓越套装/回收得积分，"},{"回收设置：宝石/白装/幸运装/强化装/支持自动回收，贵重物品手动回收。仔细阅读回收面板"}}}},
	{id=11, icon={"Atlas/KmlPreviewUI.spriteatlas","icon_langhunyaosai"}, name={{"狼魂要塞"}}, describe={{{"开启时间","每周一晚上8点30分"},{"游戏玩法","1.所有拥有战盟的玩家都可进入副本进行战斗。\n2.盟主及副盟主可消耗战盟资金召唤守护者共同战斗。\n3.战斗开始时，会在副本随机刷新出怪物朝狼神护台进攻，玩家需要将怪物在击败狼神护台前进行击杀。\n4.成功守护狼神护台后，获得奖励"}}}},
	{id=12, icon=local_icon.icon_1, name={{"强化大师"}}},
	{id=13, name={{"宝石掉落"}}, describe={{{"宝石掉落：小怪和BOSS均可掉落宝石"},{"冰风谷-Lv.20：祝福宝石。"},{"地下城-Lv.30：祝福宝石、灵魂宝石。"},{"失落之塔-Lv.40：祝福宝石、灵魂宝石、玛雅之石。"},{"亚特兰蒂斯-Lv.70：祝福宝石、灵魂宝石、玛雅之石、生命宝石。"},{"死亡沙漠以上-Lv.130：祝福宝石、灵魂宝石、玛雅之石、生命宝石、创造宝石。"}}}, showLevel=9999, completionLevel=9999},
	{id=14, name={{"自由交易"}}, describe={{{"开通畅玩卡：玩家自由交易需双方均畅玩卡。"},{"建议玩家前往勇者大陆交易专线进行交易。"},{"交易限制：交易双方必须在本服、非副本、同地图内，不超过3格距离，建议选择安全区。"},{"交易税：交易货币存在10%交易税。"},{"交易失败：离线、死亡等异常状况会导致交易失败。 "},{"交易过程中，任何一方关闭界面，交易停止"}}}},
	{id=15, name={{"红名PK系统"}}, describe={{{"PK值：游戏PK线外击杀玩家会增加PK值；击杀非白名玩家不增加PK值。"},{"PK阶段：PK值根据大小对应PK阶段，PK阶段对应不同的死亡惩罚，副本内死亡没有死亡惩罚","白名：一位良民，PVP极小概率掉落宝石道具；死亡掉落4%金币(优先绑金)\n无赖：黄名，PVP有概率掉落宝石道具；死亡掉落4%金币，PVP额外扣除1%金币。\n恶人：红名，PVP较大概率掉落宝石道具；死亡掉落4%金币，PVP额外扣除2%金币；小概率掉落穿戴的装备\n恶魔：红名，PVP死亡极大概率掉落多个宝石道具；死亡掉落4%金币，PVP死亡额外扣除4%金币；PVE小概率掉落穿戴的装备，PVP极大概率掉落穿戴的装备。"},{"其他限制：PK值超过一定值时无法对其他玩家造成伤害，限制交易行使用与和平线路传送"},{"PK值减少：","打怪：玩家可以通过击杀怪物来减少PK值，等级越高减少越多\n免罪符：积分商城内购买，可用于快速清除全部PK点数。"},{"补充：","当掉落的道具为非绑定状态时才可拾取，PVP击杀掉落道具归属与击杀者，PVE无归属。"}}}, showLevel=9999, completionLevel=9999},
	{id=16, name={{"萤石系统"}}, describe={{{"萤石玩法详解：幻术园：47 242 可用套装抽取荧之石"},{" 荧之石加光之石可合成荧光宝石"},{" 相同的荧光宝石（属性可不一样）且相同级别的荧光宝石+光之石强化符文可合成高等级荧光宝石"}}}},
	{id=17, name={{"耳环系统"}}, describe={{{"耳环获取详解：幻术园：23 226 可用灵魂/祝福/玛雅/各一个合成饰品箱子"},{" 可以开出卓越装备/套装/耳环"},{"耳环唯一产出的地方"}}}},
}

local defaults = {icon={"Atlas/KmlPreviewUI.spriteatlas","icon_zhanmengboss"}, describe={{{"强化介绍：为提升强化收益，特推出全身7件强化+7以上赠送强悍属性！"},{"全身7件强化+7：","攻击力/魔法攻击力/诅咒力：3\n防御力：3"},{"全身7件强化+8：","攻击力/魔法攻击力/诅咒力：6\n防御力：6"},{"全身7件强化+9：","攻击力/魔法攻击力/诅咒力：10\n防御力：10"},{"全身7件强化+10：","攻击力/魔法攻击力/诅咒力：15\n防御力：15\n攻击力/魔力/诅咒百分比提升：2.5%\n防具基础防御力提升：5%"},{"全身7件强化+11：","攻击力/魔法攻击力/诅咒力：23\n防御力：23\n攻击力/魔力/诅咒百分比提升：5%\n防具基础防御力提升：10%"},{"全身7件强化+12：","攻击力/魔法攻击力/诅咒力：34\n防御力：34\n攻击力/魔力/诅咒百分比提升：10%\n防具基础防御力提升：18%"},{"全身7件强化+13：","攻击力/魔法攻击力/诅咒力：49\n防御力：49\n攻击力/魔力/诅咒百分比提升：15%\n防具基础防御力提升：28%"},{"全身7件强化+14：","攻击力/魔法攻击力/诅咒力：70\n防御力：70\n攻击力/魔力/诅咒百分比提升：20%\n防具基础防御力提升：40%"},{"全身7件强化+15：","攻击力/魔法攻击力/诅咒力：100\n防御力：100\n攻击力/魔力/诅咒百分比提升：25%\n防具基础防御力提升：55%"}}}, showLevel=1, completionLevel=1, hideLevel=9999, item={10010002,1000}, openPanel={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_preview) do
	setmetatable(v, mt)
end

return cfg_preview