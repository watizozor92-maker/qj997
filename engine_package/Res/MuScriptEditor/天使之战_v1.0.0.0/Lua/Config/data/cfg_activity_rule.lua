-- 此文件工具自动生成，不要修改
---@class cfg_activity_rule_column
---活动编号
---@field id number @编号 column=1 A
---活动的名字
---@field name string @活动名字 column=2 B
---活动界面显示开启条件限制，填空则不做限制（内置condition非外置condition）
---@field condition string @显示条件限制 column=3 C
---使用cron表达式，表达式为6位数，1：秒，2：分，3：时，4：日，5：月，6：周；不指定用？；周和日只能指定一个,且另一个填成问号；csv文件格式原因，填表需将，替换为&；符号填写英文格式
---为空则表示只开服开启一次
---填1，就代表服务器开启后这个活动就会一直开启 不会重启或者中断，且会一直记录数据，不重置，（或者随便乱填，只要不是按照cron的表达式，也会导致活动不关闭，）
---全天一直开放：alltime，配置此格式 活动一直开放，服务器重启也不会重置数据
---注意：周日配1，依次递增，周六是7（6位数一定要匹配）
---@field time string @开启时间 column=4 D
---副本开启后持续的时间 单位：分
---@field duration number @持续时间 column=5 E
---共享活动次数的活动，用同一个次数类型
---共享次数时，次数限制需要填成一样
---填0=不限次数
---[[客户端不使用]]@field numberType number @次数类型 column=6 F
---每日增加次数#次数上限
---[[客户端不使用]]@field numberAdd IntList @次数限制 column=7 G
---活动每日增加次数的时间
---类型#时间
---1：每天#x   每天x点刷新
---2：每周#x#x  每周x 的x 点刷新
---[[客户端不使用]]@field numberTime IntList @重置时间 column=8 H
---活动入口：
---1=活动，
---2=战盟活动
---3=主界面活动 关联主界面表格
---4=跨服活动
---@field initType number @初始大类 column=9 I
---到达改等级时，前往按钮才会有
---到达等级时，预告才会有
---@field level number @活动开启等级 column=10 J
---用于显示活动面；
---1=开启
---0=隐藏显示
---@field targetOpen number @活动界面开关 column=11 K
---id小的在前
---@field rank number @活动界面排序 column=12 L
---活动的默认底图，不可以不填，用于活动页面
---@field uiBg string @活动界面底图 column=13 M
---活动规则
---@field uiTextRule string @活动规则文本 column=14 N
---活动条件
---@field uiTextSynopsis string @活动条件文本 column=15 O
---活动奖励道具ID
---最多三个道具
---例：道具id#道具id
---@field uiReward IntList @奖励显示 column=16 P
---活动标题的图标，用于活动列表中活动名称的显示
---@field titleIcon string @活动标题图标 column=17 Q
---用于活动列表中展示图标
---@field Icon string @活动图标 column=18 R
---0=不在活动的提示弹窗内显示
---1=在活动的提示弹窗内显示
---@field open number @提示弹窗开关 column=19 S
---活动开始前一定时间内预告；
---单位（秒），若不配置则不会预告
---@field specialOpen number @活动预告 column=20 T
---各功能上的开启时间描写
---@field timeText string @开启时间文本注释 column=21 U
---1、打开某个界面  
---openUIpanel#UI名#[0,1] 0=不关闭界面 1=关闭界面 
---  
---2、前往某个NPC 并对话  
---transferNPC#NPCID  
---传送到NPC位置，并交互  
---NPCID参考npc_list表ID  
---  
---3、前往某个传送点（填写多个传送点时，随机进行一个传送进行传送）  
---moveTo#传送ID  
---传送ID参考mapMove表id  
---
---4.特殊定义： ToDragon 传送前往当前火龙王存活的地图
---
---不填则没有快捷跳转功能
---@field panel StringList @快捷指令 column=22 V
---@field monsterid number @活动怪物id column=23 W
---战盟活动界面中显示的背景图
---@field unionUiBg string @战盟活动界面背景图 column=24 X
---1、跨服地图可通过地图id索引mapinfo读地图限制条件
---@field mapid IntList @活动地图 column=25 Y
---打开某个界面  
---openUIpanel#UI名#[0,1] 0=不关闭界面 1=关闭界面
---@field activitypanel StringList @活动开启屏闪跳转 column=26 A

local local_uiReward = {
    uiReward_1={40010207,40010208,40010209},
    uiReward_2={},

}

local local_panel = {
    panel_1={""},
    panel_2={"ToDragon","1001","1003","1004"},

}

local local_mapid = {
    mapid_1={},

}

local local_activitypanel = {
    activitypanel_1={""},

}

local cfg_activity_rule =
{
	{id=10001, name="恶魔广场", duration=15, rank=2, uiTextRule="全天开放，限制3次", uiTextSynopsis="00:00:00-23:59:59", uiReward={10080001,50030002,50030003}, Icon="UI_zy_huolong", timeText="全天开放，限制3次", panel=local_panel.panel_1, activitypanel={"openUIPanel","dev/ui/Preview/Panel/KLPreview/KLPreviewPanel","1","togType=2&subType=2"}},
	{id=11001, name="血色城堡", duration=15, rank=3, uiTextRule="全天开放，限制3次", uiTextSynopsis="00:00:00-23:59:59", uiReward={10080001,10010001,50030003}, Icon="UI_zy_huolong", timeText="全天开放，限制3次", panel=local_panel.panel_1, activitypanel={"openUIPanel","dev/ui/Preview/Panel/KLPreview/KLPreviewPanel","1","togType=2&subType=1"}},
	{id=16001, name="1.03罗兰攻城战", time="0 0 20 ? * 7", duration=60, initType=2, level=15, rank=8, uiBg="img_activity_blood", uiTextRule="每周六晚20.00开启", uiTextSynopsis="加入战盟，80级", uiReward=local_uiReward.uiReward_2, titleIcon="", Icon="roland_siege_icon", specialOpen=600, timeText="每周六晚20.00开启", panel={"openUIPanel","dev/outui/LoranSiege/Panel/KLSiegeMain/KLSiegeMainPanel","1"}, unionUiBg="luolangongchengzhan"},
	{id=17001, name="赤色要塞", time="0 0 20 ? * 6", duration=5, rank=9, uiReward={10020001,50040056}, Icon="red_fortress_icon", open=1, specialOpen=300, timeText="20:00:00-20:05:00|20:00:00-20:30:00", panel={"transferNPC","100113"}, activitypanel={"openUIPanel","dev/ui/Preview/Panel/KLPreview/KLPreviewPanel","1","togType=2&subType=3"}},
	{id=27001, name="昆顿入侵", time="0 0 21 ? * 6", duration=120, rank=5, Icon="world_boss_icon", open=1, specialOpen=300, timeText="每天10：30、13：30、16：30、21：30勇者大陆、冰风谷、仙踪林出现", monsterid=10008},
	{id=13001, name="黄金部队", time="0 0 19 ? * 6", duration=59, rank=5, Icon="world_boss_icon", open=1, specialOpen=300, timeText="每天10：30、13：30、16：30、21：30勇者大陆、冰风谷、仙踪林出现", monsterid=10008},
	{id=28001, name="冰风堡攻城战", condition="checkRunDay>99999", time="0 0 20 ? * 6 2100", duration=60, initType=2, rank=8, uiTextSynopsis="加入战盟，80级", uiReward=local_uiReward.uiReward_2, titleIcon="", Icon="roland_siege_icon", open=1, specialOpen=300, timeText="每周五晚20：00开启", panel={"transferMapAndLine","4","6"}, unionUiBg="guildActivity_bg_gcz", activitypanel={"openUIPanel","dev/ui/Preview/Panel/KLPreview/KLPreviewPanel","1","togType=2&subType=4"}},
	{id=14001, name="战盟BOSS", condition="checkRunDay>1", time="0 30 19 ? * 6 2100", initType=2, rank=6, uiBg="img_activity_default", uiReward={50040026,50030004,50040056}, titleIcon="", Icon="", open=0, timeText="每日11:30、19:30开启", panel={"openUIPanel","dev/outui/Union/Panel/KLUnionBossMain/KLUnionBossMainPanel","1"}, unionUiBg="zhanmengboss"},
	{id=15001, name="狼魂要塞", condition="checkRunDay>1", time="0 30 20 ? * 1&2&5", initType=2, level=1, rank=7, uiTextRule="每周一、四、日20：30开启", uiTextSynopsis="加入战盟，180级", uiReward={10020001,10120001}, Icon="blood_icon", open=1, specialOpen=300, timeText="每周一、四、日20:30开启", panel=local_panel.panel_1, unionUiBg="langhunyaosai"},
	{id=12001, name="勇气试炼", condition="checkRunDay>99999", targetOpen=0, rank=4, uiReward={10080001}, Icon="txt_title_huoYue", timeText="每日11:30、19:30开启", panel=local_panel.panel_1},
	{id=24001, name="连击试炼", condition="checkRunDay>99999", rank=1, uiReward={50040098}, titleIcon="", Icon="", timeText="全天开放，限制5次", panel={"transferNPC","100114"}},
	{id=25001, name="卡利玛神庙", duration=60, initType=3, level=1, targetOpen=0, rank=0, uiTextRule="全天开放，限制5次", uiTextSynopsis="00:00:00-23:59:59", uiReward=local_uiReward.uiReward_2, titleIcon="", Icon="", timeText="", panel=local_panel.panel_1},
}

local defaults = {condition="", time="alltime", duration=30, initType=1, level=9999, targetOpen=1, uiBg="img_activity_demon", uiTextRule="后续开放", uiTextSynopsis="后续开放", uiReward={40010207,40010208,40010209}, titleIcon="txt_title_huoYue", open=0, specialOpen=0, panel={"ToDragon","1001","1003","1004"}, monsterid=0, unionUiBg="", mapid={}, activitypanel={""}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_activity_rule) do
	setmetatable(v, mt)
end

return cfg_activity_rule