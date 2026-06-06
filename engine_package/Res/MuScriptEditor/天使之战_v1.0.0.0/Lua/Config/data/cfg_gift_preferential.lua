-- 此文件工具自动生成，不要修改
---@class cfg_gift_preferential_column
---填recharge表对应礼包ID
---@field id number @唯一id column=1 A
---满足时弹出在主界面
---@field conditions string @满足条件 column=2 B
---当前的页签显示名称
---@field name string @页签名称 column=3 C
---模型路径#描述#职业
---@field model StringListList @大奖模型 column=4 D
---x#y#z#缩放大小#职业id
---@field modelCondition IntListList @模型调整 column=5 E
---x#y#z#职业
---@field modelRevolve IntListList @模型旋转 column=6 F
---大奖右侧的描述#职业id|大奖右侧的描述#职业id
---@field tips StringListList @大奖描述 column=7 G
---职业id#道具id#数量|职业id#道具id#数量
---满足职业才有该道具，不然没有对应道具
---@field item IntListList @礼包道具 column=8 H
---小时
---@field time number @限时时间 column=9 I
---@field buttonTips string @按钮上显示内容 column=10 J
---配对应界面路径的快捷指令，和前面背景图的顺序一样 快捷指令#快捷指令
---@field Jump StringList @该页签下按钮跳转路径 column=11 K

local local_model = {
    model_1={{"Effect/UI/Eff_UI_anniutishi05","1"},{"Effect/UI/Eff_UI_anniutishi05","2"},{"Effect/UI/Eff_UI_anniutishi05","3"}},

}

local local_modelCondition = {
    modelCondition_1={{0,0,0,1,1},{0,0,0,2,2},{0,0,0,3,3}},

}

local local_modelRevolve = {
    modelRevolve_1={{0,0,0,1},{0,0,0,2},{0,0,0,3}},

}

local local_item = {
    item_1={{1,10020001,100},{2,10020001,100},{3,10020001,100}},

}

local local_Jump = {
    Jump_1={"openUIPanel","dev/outui/MainRecharge/Panel/KLMainRecharge/KLMainRechargePanel","1","mainRechargeId=5"},

}

local cfg_gift_preferential =
{
	{id=701, name="技能礼包", modelCondition={{0,0,0,15,1},{0,0,0,15,2},{0,0,0,15,3}}, time=24, buttonTips="18元"},
	{id=702, name="连击进阶", tips={{"真·连击","1"},{"真·连击","2"},{"真·连击","3"}}, time=48, buttonTips="128元"},
	{id=703, name="boss礼包", tips={{"极·boss","1"},{"极·boss","2"},{"极·boss","3"}}, time=72, buttonTips="128元"},
}

local defaults = {conditions="101#8888", model={{"Effect/UI/Eff_UI_anniutishi05","1"},{"Effect/UI/Eff_UI_anniutishi05","2"},{"Effect/UI/Eff_UI_anniutishi05","3"}}, modelCondition={{0,0,0,1,1},{0,0,0,2,2},{0,0,0,3,3}}, modelRevolve={{0,0,0,1},{0,0,0,2},{0,0,0,3}}, tips={{"真·霹雳回旋斩","1"},{"真·黑龙波","2"},{"真·五重箭","3"}}, item={{1,10020001,100},{2,10020001,100},{3,10020001,100}}, Jump={"openUIPanel","dev/outui/MainRecharge/Panel/KLMainRecharge/KLMainRechargePanel","1","mainRechargeId=5"}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_gift_preferential) do
	setmetatable(v, mt)
end

return cfg_gift_preferential