-- 此文件工具自动生成，不要修改
---@class cfg_npclist_column
---所处地图id+两位编号
---@field id number @npcid column=1 A
---NPC名称
---@field name string @npc名字 column=2 B
---NPC布置地图，读取cfg_map_info表id
---@field mapId number @所在地图 column=3 C
--- 
---@field showInMinimap string @小地图用名称 column=4 D
---NPC小地图显示图标，填写文件名称；不填则不显示图标
---@field icon string @NPC图标 column=5 E
---NPC所在X轴坐标
---@field x number @X坐标 column=6 F
---NPC所在Y轴坐标
---@field y number @Y坐标 column=7 G
---NPC模型
---读取cfg_model_npc表id
---@field appr number @外观代码 column=8 H
---0：右上
---1：右
---2：右下
---3：下
---4：左下
---5：左
---6：左上
---7：上
---{右上=0|右=1|右下=2|下=3|左下=4|左=5|左上=6|上=7}
---@field direction number @NPC方向#客户端#C column=9 I
---NPC对话文本
---<color=#9b39cc>颜色部分</color> 
---\n换行
---@field content string @对话面板文字 column=10 J
---跳转功能面板的等级，大于等于设定等级后才可以弹，否则只弹出对话面板
---填空时，不显示
---[大于等于设定等级后才可以弹，否则只弹出对话面板；填空时不显示]
---@field limitLv number @功能面板等级限制 column=11 K
---对应面板名称
---格式：路径#参数 无参数可不填
---如果需要使用的面板无变化，如合成面板UISyntheticPanel，则直接填写面板id即可。
---如果需要使用的面板会变化，如NPC商店面板UINpcShopPanel，会根据商店编号，显示商品类型，这时就需要填写参数。
---有需要填写参数的地方，需要与对应面板制作程序沟通，进行填写[格式：面板名#参数 无参数可不填]
---@field openPanel StringListList @功能面板#客户端#C column=12 L
---不填默认0[不填默认0]
---@field namey IntList @npc名字垂直偏移 column=13 M
---调整模型的大小比例
---单位：百分比
---@field size number @模型大小 column=14 N
---填写cfg_audio表对应的音效id
---空为不播放
---点击模型时，播放音效[填写cfg_audio表对应的音效id]
---@field speak number @互动音效 column=15 O
---场景模型的音效播放方式
---1=点击模型触发音效
---2=进入模型配置的声音范围内开始播放，退出范围后停止播放
---3=持续播放
---为空时不播放
---编辑器读取
---{不播放=0|点击模型触发音效=1|进入模型配置的声音范围内开始播放，退出范围后停止播放=2|持续播放=3}[不播放=0|点击模型触发音效=1|进入模型配置的声音范围内开始播放，退出范围后停止播放=2|持续播放=3]
---@field time number @触发时机 column=16 P
---小于这个距离时显示对话按钮
---@field talkdistance number @对话按钮距离 column=17 Q

local local_openPanel = {
    openPanel_1={},
    openPanel_2={{"dev/outui/NPC/Panel/KLNPCPhantomMentor/KLNPCPhantomMentorPanel"}},
    openPanel_3={{"dev/ui/Bag/Panel/KLDepots/KLDepotsPanel","table:x=-415;y=0"},{"dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel"}},
    openPanel_4={{"dev/outui/Tips/Panel/KLClickNPCTransferTips/KLClickNPCTransferTipsPanel","33"}},

}

local local_namey = {
    namey_1={0,0,0},

}

local cfg_npclist =
{
	{id=100101, name="酒吧老板娘·莉亚", showInMinimap="酒吧老板娘", icon="img_minimap__npc", x=123, y=135, appr=9, content="", openPanel={{"dev/ui/NPC/Panel/KLNPCShop/KLNPCShopPanel","1"}}},
	{id=100102, name="铁匠·汉斯", x=116, y=141, appr=2, direction=2, content="", openPanel={{"dev/ui/NPC/Panel/KLNPCShop/KLNPCShopPanel","2"}}, speak=20018},
	{id=100103, name="魔导师·帕希", x=118, y=113, appr=3, direction=2, content="", openPanel={{"dev/ui/NPC/Panel/KLNPCShop/KLNPCShopPanel","3"}}},
	{id=100104, showInMinimap="BUFF", x=131, y=128, direction=2, openPanel=local_openPanel.openPanel_1},
	{id=100105, name="流浪商人·海罗德", showInMinimap="流浪商人", icon="img_minimap__npc", x=183, y=136, appr=7, content="", openPanel=local_openPanel.openPanel_1},
	{id=100106, name="少女·安娜", x=127, y=86, appr=15, content="", openPanel=local_openPanel.openPanel_1},
	{id=100107, name="仓库使者·塞弗特", showInMinimap="仓库", icon="img_minimap__npc", x=147, y=145, appr=1, content=""},
	{id=100108, showInMinimap="BUFF", x=172, y=129, openPanel=local_openPanel.openPanel_2},
	{id=100109, showInMinimap="BUFF", x=132, y=166, direction=2, openPanel=local_openPanel.openPanel_2},
	{id=100110, showInMinimap="BUFF", x=132, y=90, direction=2, openPanel=local_openPanel.openPanel_2},
	{id=100111, showInMinimap="BUFF", icon="img_minimap__npc", x=97, y=129, openPanel=local_openPanel.openPanel_2},
	{id=100112, name="仓库使者·塞弗特", showInMinimap="仓库", icon="img_minimap__npc", x=145, y=109, appr=1, direction=2, content=""},
	{id=100113, name="赤色要塞报名官", showInMinimap="赤色要塞", icon="img_minimap__npc", x=130, y=134, appr=17, direction=3, openPanel={{"dev/outui/Activity/Panel/KLRedFort/KLRedFortPanel"}}},
	{id=100114, name="警卫队长摩伦", icon="img_minimap__npc", x=107, y=86, appr=57, openPanel={{"dev/outui/Task/Panel/KLTaskAccept/KLTaskAcceptPanel","table:1=666605;2=666607"}}},
	{id=100401, name="精灵·安吉拉", mapId=1004, x=173, y=125, appr=22, content="", openPanel={{"dev/ui/NPC/Panel/KLNPCShop/KLNPCShopPanel","5"}}, speak=20021},
	{id=100402, mapId=1004, showInMinimap="BUFF", x=167, y=118, openPanel=local_openPanel.openPanel_2},
	{id=100403, name="工匠·尤达", mapId=1004, x=195, y=124, appr=21, content="", openPanel={{"dev/ui/NPC/Panel/KLNPCShop/KLNPCShopPanel","4"}}},
	{id=100404, name="合成·玛雅哥布林", mapId=1004, showInMinimap="合成", icon="img_minimap__npc", x=180, y=103, appr=31, content="", limitLv=1, openPanel={{"dev/outui/Synthesis/Panel/KLSynthesisMenu/KLSynthesisMenuPanel","table:1=1;2=2;3=3;4=4;5=5;6=6;7=7;8=8;9=9"}}, speak=20020},
	{id=100405, name="仓库使者·塞弗特", mapId=1004, showInMinimap="仓库", icon="img_minimap__npc", x=172, y=96, appr=1, direction=2, content=""},
	{id=100406, name="恶魔广场守卫·卡隆", mapId=1004, showInMinimap="恶魔广场", icon="img_minimap__npc", x=171, y=105, appr=19, direction=2, content="", openPanel={{"dev/outui/Activity/Panel/KLActivityDetail/KLActivityDetailPanel","10001"}}},
	{id=100407, mapId=1004, showInMinimap="BUFF", x=165, y=84, direction=3, openPanel=local_openPanel.openPanel_2},
	{id=100408, mapId=1004, showInMinimap="BUFF", x=202, y=130, direction=3, openPanel=local_openPanel.openPanel_2},
	{id=105201, name="仓库使者·塞弗特", mapId=1052, x=50, y=229, appr=1, content=""},
	{id=105202, name="流浪商人·塞尔维亚", mapId=1052, x=44, y=229, appr=44, content="", openPanel=local_openPanel.openPanel_1},
	{id=105203, name="召唤师·摩尔塞", mapId=1052, x=36, y=216, appr=28, direction=3, content="", openPanel=local_openPanel.openPanel_1},
	{id=105204, mapId=1052, showInMinimap="BUFF", x=57, y=232, direction=3, openPanel=local_openPanel.openPanel_2},
	{id=105205, mapId=1052, showInMinimap="BUFF", x=97, y=219, openPanel=local_openPanel.openPanel_2},
	{id=105206, mapId=1052, showInMinimap="BUFF", x=44, y=167, direction=2, openPanel=local_openPanel.openPanel_2},
	{id=100301, name="战盟使者·罗斯", mapId=1003, showInMinimap="战盟", icon="img_minimap__npc", x=215, y=45, appr=29, openPanel=local_openPanel.openPanel_1},
	{id=100302, name="仓库使者·塞弗特", mapId=1003, showInMinimap="仓库", icon="img_minimap__npc", x=218, y=63, appr=1, content=""},
	{id=100303, name="武器商人·苏菲", mapId=1003, x=186, y=47, appr=45, direction=2, content="", openPanel=local_openPanel.openPanel_1},
	{id=100304, name="魔导师·露茜", mapId=1003, x=225, y=41, appr=46, direction=2, content="", openPanel=local_openPanel.openPanel_4},
	{id=100305, name="老板娘·莉娜", mapId=1003, x=226, y=25, appr=11, direction=2, openPanel=local_openPanel.openPanel_4, size=200},
	{id=100306, name="血色城堡守卫·大天使的使者", mapId=1003, showInMinimap="血色城堡", icon="img_minimap__npc", x=209, y=29, appr=51, content="", openPanel={{"dev/outui/Activity/Panel/KLActivityDetail/KLActivityDetailPanel","11001"}}, namey={0,-6,0}},
	{id=100307, name="圣导士塞维娜", mapId=1003, x=184, y=32, appr=43, direction=3, openPanel={{"dev/outui/Task/Panel/KLTaskAccept/KLTaskAcceptPanel","table:1=666601;2=666603"}}, time=0, talkdistance=0},
	{id=100308, name="警卫队长", mapId=1003, x=198, y=46, appr=57, direction=3, openPanel=local_openPanel.openPanel_1, time=0, talkdistance=0},
	{id=100309, mapId=1003, showInMinimap="BUFF", x=178, y=43, openPanel=local_openPanel.openPanel_2},
	{id=100310, mapId=1003, showInMinimap="BUFF", x=219, y=72, direction=2, openPanel=local_openPanel.openPanel_2},
	{id=100201, mapId=1002, showInMinimap="BUFF", x=105, y=240, direction=2, openPanel=local_openPanel.openPanel_2},
	{id=100501, mapId=1005, showInMinimap="BUFF", x=211, y=81, openPanel=local_openPanel.openPanel_2},
	{id=100801, mapId=1008, showInMinimap="BUFF", x=17, y=25, direction=2, openPanel=local_openPanel.openPanel_2},
	{id=101201, name="受伤的大天使", mapId=1012, showInMinimap="受伤的大天使", icon="img_minimap__npc", x=10, y=9, appr=50, direction=2, openPanel={{"dev/outui/Activity/Panel/KLBloodTip/KLBloodTipPanel","101201"}}},
	{id=100901, name="艾德·萤之石管理员", mapId=1052, showInMinimap="萤石管理", icon="img_minimap__npc", x=46, y=243, appr=24, content="", limitLv=1, openPanel={{"dev/outui/Synthesis/Panel/KLGemSynthesis/KLGemSynthesisPanel"}}},
	{id=100902, name="弟子黛彬", mapId=1035, x=228, y=48, appr=20, openPanel={{"dev/outui/Task/Panel/KLTaskAccept/KLTaskAcceptPanel","table:1=666609;2=666611;3=666613;4=6666091"}}},
	{id=100903, name="摩斯", mapId=1052, showInMinimap="合成", x=22, y=225, appr=28, direction=2, openPanel={{"dev/outui/Synthesis/Panel/KLSynthesisMenu/KLSynthesisMenuPanel","table:1=8"}}},
	{id=100904, name="暗黑血狼人扩雷", mapId=1035, x=62, y=239, appr=49, openPanel={{"dev/outui/Tips/Panel/KLClickNPCTransferTips/KLClickNPCTransferTipsPanel","70001"}}},
	{id=100905, name="守卫", mapId=1042, x=119, y=168, appr=14, direction=3, openPanel={{"dev/outui/Tips/Panel/KLClickNPCTransferTips/KLClickNPCTransferTipsPanel","70002"}}},
	{id=100120, name="驯兽师", showInMinimap="合成", x=122, y=114, appr=28, direction=2, openPanel={{"dev/outui/Synthesis/Panel/KLSynthesisMenu/KLSynthesisMenuPanel","table:1=10;2=11;3=12"}}},
}

local defaults = {name="幻影导师·凯蒂", mapId=1001, showInMinimap="", icon="", appr=12, direction=4, content="你好，勇士！我能为你提供些帮助", limitLv=0, openPanel={{"dev/ui/Bag/Panel/KLDepots/KLDepotsPanel","table:x=-415;y=0"},{"dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel"}}, namey={0,0,0}, size=100, speak=0, time=1, talkdistance=2}
local mt = {__index = defaults}
for _, v in ipairs(cfg_npclist) do
	setmetatable(v, mt)
end

return cfg_npclist