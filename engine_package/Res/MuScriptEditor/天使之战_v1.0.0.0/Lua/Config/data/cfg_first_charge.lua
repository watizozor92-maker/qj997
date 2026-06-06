-- 此文件工具自动生成，不要修改
---@class cfg_first_charge_column
---根据同一个页签内的唯一id 顺序排序 ，id越小越靠前
---@field id number @唯一id column=1 A
---[[客户端不使用]]@field text string @策划备注 column=2 B
---天数#等级
---两者都满足才会显示，不填则无条件
---@field needDayLevel IntList @开启天数及等级 column=3 C
---
---格式为：职业ID#图片名称|职业ID#图片名称
---@field popUpsPicture StringList @弹窗图片 column=4 D
---格式：几级出现弹窗#弹窗倒计时|几级出现弹窗#弹窗倒计时
---@field popUpsRule IntListList @弹窗规则 column=5 E
---首次充值赠送的道具
---格式：职业id#道具id#数量|职业id#道具id#数量|职业id#道具id#数量|职业id#道具id#数量
---职业id关联career表
---道具id关联item表
---@field firstReward IntListList @首充奖励 column=6 F
---不配则不显示这句话
---配置则显示对应数额
---@field count number @钻石数量显示 column=7 G
---不配则不显示这句话
---配置则显示对应数额
---@field count2 number @返利数值 column=8 H
---礼包图片，填图片名称
---@field name string @背景图 column=9 I
---1是
---0或不配 否
---@field takeEffect number @是否仅在本页面充值才计算 column=10 J
---1是，不显示
---0或不配 否
---@field showSwitch number @是否不在本页面中显示 column=11 K
---模型路径#描述#职业
---@field model StringListList @大奖模型 column=12 L
---x#y#z#缩放大小#职业id
---@field modelCondition IntListList @模型调整 column=13 M
---x#y#z#职业
---@field modelRevolve IntListList @模型旋转 column=14 N
---坐骑模型时填
---动画路径#职业
---@field modelBehavior StringListList @模型动画 column=15 O

local local_needDayLevel = {
    needDayLevel_1={1,1},

}

local local_popUpsPicture = {
    popUpsPicture_1={""},

}

local local_popUpsRule = {
    popUpsRule_1={},

}

local local_firstReward = {
    firstReward_1={},

}

local local_model = {
    model_1={},

}

local local_modelCondition = {
    modelCondition_1={},

}

local local_modelRevolve = {
    modelRevolve_1={},

}

local local_modelBehavior = {
    modelBehavior_1={},

}

local cfg_first_charge =
{
	{id=301, firstReward={{1,21600001,1},{1,30030201,1},{1,30031013,1},{1,21400002,1},{1,10020001,1500},{2,21600001,1},{2,30030201,1},{2,30031013,1},{2,21400002,1},{2,10020001,1500},{3,21600001,1},{3,30030201,1},{3,30031013,1},{3,21400002,1},{3,10020001,1500}}, count=60, count2=600, showSwitch=0},
	{id=302, popUpsRule=local_popUpsRule.popUpsRule_1, count=480, count2=480, showSwitch=0, model={{"Model/Charactor/Sword/Sword40","即买即穿！三极品词条高攻主武！","1"},{"Model/Charactor/Mace/Mace13","即买即穿！三极品词条高攻主武！","2"},{"Model/Charactor/Bow/Bow36_0","即买即穿！三极品词条高攻主武！","3"}}, modelCondition={{-35,40,200,250,1},{0,-10,200,230,2},{15,-15,200,220,3}}, modelRevolve={{60,90,0,1},{315,270,0,2},{45,270,0,3}}, modelBehavior=local_modelBehavior.modelBehavior_1},
	{id=303, popUpsRule=local_popUpsRule.popUpsRule_1, firstReward={{1,21320011,1},{1,30031034,1},{1,50030002,10},{1,50030003,5},{1,50030004,3},{1,10020001,12000},{2,21320021,1},{2,30031034,1},{2,50030002,10},{2,50030003,5},{2,50030004,3},{2,10020001,12000},{3,21320031,1},{3,30031034,1},{3,50030002,10},{3,50030003,5},{3,50030004,3},{3,10020001,12000}}, count=980, count2=980, showSwitch=0, model={{"Model/Charactor/Wing/Wing06","二代翅膀！提升巨额属性！","1"},{"Model/Charactor/Wing/Wing05","二代翅膀！提升巨额属性！","2"},{"Model/Charactor/Wing/Wing04","二代翅膀！提升巨额属性！","3"}}, modelCondition={{0,-20,200,200,1},{0,10,200,180,2},{0,5,200,180,3}}, modelRevolve={{0,0,0,1},{0,0,0,2},{0,180,0,3}}, modelBehavior=local_modelBehavior.modelBehavior_1},
	{id=304, popUpsRule=local_popUpsRule.popUpsRule_1, firstReward=local_firstReward.firstReward_1, count=480, count2=480, showSwitch=1, model=local_model.model_1, modelCondition=local_modelCondition.modelCondition_1, modelRevolve=local_modelRevolve.modelRevolve_1, modelBehavior=local_modelBehavior.modelBehavior_1},
	{id=305, popUpsRule=local_popUpsRule.popUpsRule_1, firstReward=local_firstReward.firstReward_1, count=500, count2=980, showSwitch=1, model=local_model.model_1, modelCondition=local_modelCondition.modelCondition_1, modelRevolve=local_modelRevolve.modelRevolve_1, modelBehavior=local_modelBehavior.modelBehavior_1},
	{id=306, popUpsRule=local_popUpsRule.popUpsRule_1, firstReward=local_firstReward.firstReward_1, count=980, count2=980, showSwitch=1, model=local_model.model_1, modelCondition=local_modelCondition.modelCondition_1, modelRevolve=local_modelRevolve.modelRevolve_1, modelBehavior=local_modelBehavior.modelBehavior_1},
}

local defaults = {needDayLevel={1,1}, popUpsPicture={""}, popUpsRule={{30,120},{50,120}}, firstReward={{1,28810531,1},{1,30031025,1},{1,50010005,1},{1,50010003,1},{1,50030003,3},{1,10020001,4500},{2,28820531,1},{2,30031025,1},{2,50010005,1},{2,50010003,1},{2,50030003,3},{2,10020001,4500},{3,28830531,1},{3,30031025,1},{3,50010005,1},{3,50010003,1},{3,50030003,3},{3,10020001,4500}}, name="", takeEffect=1, model={{"Model/Mount/Rider01","首充即送精品坐骑","1"},{"Model/Mount/Rider01","首充即送精品坐骑","2"},{"Model/Mount/Rider01","首充即送精品坐骑","3"}}, modelCondition={{-5,-50,200,5,1},{-5,-50,200,5,2},{-5,-50,200,5,3}}, modelRevolve={{0,135,0,1},{0,135,0,2},{0,135,0,3}}, modelBehavior={{"712Fenril_idle","1"},{"712Fenril_idle","2"},{"712Fenril_idle","3"}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_first_charge) do
	setmetatable(v, mt)
end

return cfg_first_charge