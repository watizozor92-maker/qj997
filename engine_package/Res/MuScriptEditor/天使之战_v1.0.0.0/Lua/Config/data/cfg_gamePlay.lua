-- 此文件工具自动生成，不要修改
---@class cfg_gamePlay_column
---@field id number @编号 column=1 A
---填图标文件名称
---@field icon StringList @玩法图标 column=2 B
---@field name StringListList @玩法名称 column=3 C
---1、各系统玩法介绍文本
---2、如果是Texture 的图片，就 img#Texture/图片名.后缀##图片宽#图片高，与文字区域连接用&号
---@field describe StringListListList @玩法介绍文本 column=4 D
---显示该玩法介绍的最小等级
---@field showLevel number @显示等级 column=5 E
---@field completionLevel number @完成任务等级 column=6 F
---达到该等级且奖励已领取则功能预告隐藏，若隐藏等级大于任务完成等级则领取奖励后出现前往按钮
---@field hideLevel number @任务隐藏等级 column=7 G
---通过显示的玩法能够获得的道具
---格式：道具id#道具数量|道具id#道具数量
---@field item IntListList @奖励道具 column=8 H
---对应面板名称
---格式：路径#参数 无参数可不填
---
---如果需要使用的面板无变化，如合成面板UISyntheticPanel，则直接填写面板id即可。
---如果需要使用的面板会变化，如NPC商店面板UINpcShopPanel，会根据商店编号，显示商品类型，这时就需要填写参数。
---有需要填写参数的地方，需要与对应面板制作程序沟通，进行填写[格式：面板名#参数 无参数可不填]
---@field openPanel StringListList @对应面板 column=9 I

local local_icon = {
    icon_1={"Atlas/KmlPreviewUI.spriteatlas","icon_emoguangchang"},
    icon_2={"Atlas/KmlPreviewUI.spriteatlas","icon_xuesechengbao"},

}

local local_item = {
    item_1={{10080001},{50030002},{50030003},{50030004},{50030005},{50030001}},

}

local local_openPanel = {
    openPanel_1={{"dev/outui/Activity/Panel/KLActivityDetail/KLActivityDetailPanel","11001"}},

}

local cfg_gamePlay =
{
	{id=7, name={{"血色城堡"}}, completionLevel=40},
	{id=8, icon=local_icon.icon_1, name={{"恶魔广场"}}, describe={{{"开启时间","14：00，16：00，18：00，20:00，22:00，0:00"},{"游戏玩法","1.消耗[恶魔广场通行证]进入副本，根据自身等级选择进入的层数，经验极高。\n2.每天限制次数3次。"},{"img","Texture/bg_img_emo.png","","300","370"}}}, completionLevel=60, openPanel={{"dev/outui/Activity/Panel/KLActivityDetail/KLActivityDetailPanel","10001"}}},
	{id=10, icon={"Atlas/KmlPreviewUI.spriteatlas","icon_zhanmengboss"}, name={{"赤色要塞"}}, describe={{{"开启时间","每周二、周五晚上8点"},{"游戏玩法","1.将所有人击杀或打下台子，自己存活到最后，即可获得胜利。\n2.根据存活排名发放奖励。"},{"img","Texture/compass_chiseyaosai.jpg","","300","370"}}}, completionLevel=100, item={{50030002},{50030003},{50030004},{50030005},{50030001}}, openPanel={{"dev/outui/Activity/Panel/KLRedFort/KLRedFortPanel"}}},
	{id=13, icon=local_icon.icon_1, name={{"冰风堡攻城战"}}, describe={{{"开启时间","每周五20:00-21:00"},{"游戏玩法","1.对冰风谷右上角城堡中得王座进行占领，坚持占领到最后的战盟将获得胜利！\n2.进入占领状态后，角色将无法行动直至死亡或主动取消占领。\n3.当一名角色持续占领时间≥180s，则视为该角色所属战盟完成占领。\n4.整场活动中击杀玩家数量最多的前5名玩家将获得额外的MVP奖励。"},{"img","Texture/banner_bingfenbao.png","","700","156"}}}, completionLevel=100, item={{21500028,1},{40011019,1},{40011020,1},{40011021,1},{10240001,20000},{10010002,300000}}, openPanel={{"dev/outui/Activity/Panel/KLBingFengBao/KLBingFengBaoPanel"}}},
	{id=20, name={{"介绍示例"}}, describe={{{"开启时间","玩法的时间"},{"游戏玩法","1.游戏玩法规则详情1\n2.游戏玩法规则详情2\n3.游戏玩法规则详情3"}}}, showLevel=1, completionLevel=1},
}

local defaults = {icon={"Atlas/KmlPreviewUI.spriteatlas","icon_xuesechengbao"}, describe={{{"开启时间","13：00，15：00，17：00，19:00，21:00，23:00"},{"游戏玩法","1.消耗[透明披风]，根据自身等级，选择进入的层数。帮助受伤的大天使获取大天使之剑，即可获得奖励。\n2.在副本内击杀怪物有大量经验可以获得。\n3.每天限制次数3次。"},{"img","Texture/bg_img_blond.png","","300","370"}}}, showLevel=9999, hideLevel=9999, item={{10080001},{50030002},{50030003},{50030004},{50030005},{50030001}}, openPanel={{"dev/outui/Activity/Panel/KLActivityDetail/KLActivityDetailPanel","11001"}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_gamePlay) do
	setmetatable(v, mt)
end

return cfg_gamePlay