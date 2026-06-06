-- 此文件工具自动生成，不要修改
---@class cfg_newServerGIft_column
---组唯一id
---@field id number @id column=1 A
---充值达到此数额可领奖，单位元
---@field needRecharge number @目标充值数 column=2 B
---职业#物品id#数量|职业#物品id#数量
---@field reward IntListList @奖品 column=3 C
---职业#模型路径|职业#模型路径
---@field showModel StringListList @展示模型 column=4 D
---x#y#z#缩放大小#职业id
---@field modelCondition IntListList @模型调整 column=5 E
---x#y#z#职业
---@field modelRevolve IntListList @模型旋转 column=6 F
---坐骑模型时填
---动画路径#职业
---@field modelBehavior StringListList @模型动画 column=7 G
---职业#视频标题#视频路径
---@field previewVedio StringListList @预览视频 column=8 H
---mail表id
---@field mail number @邮件 column=9 I
---配对应界面路径的快捷指令，和前面背景图的顺序一样 快捷指令#快捷指令
---@field Jump StringList @跳转 column=10 J

local local_showModel = {
    showModel_1={},

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

local local_previewVedio = {
    previewVedio_1={},

}

local local_Jump = {
    Jump_1={"openUIPanel","dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel","1","2"},

}

local cfg_newServerGIft =
{
	{id=1, modelCondition=local_modelCondition.modelCondition_1, modelRevolve=local_modelRevolve.modelRevolve_1},
	{id=2, reward={{0,50010010,150}}, modelCondition=local_modelCondition.modelCondition_1, modelRevolve=local_modelRevolve.modelRevolve_1},
	{id=3, reward={{0,40030002,50}}, modelCondition=local_modelCondition.modelCondition_1, modelRevolve=local_modelRevolve.modelRevolve_1},
	{id=4, reward={{0,10040001,1280}}, modelCondition=local_modelCondition.modelCondition_1, modelRevolve=local_modelRevolve.modelRevolve_1},
	{id=5, reward={{0,50040097,40}}, modelCondition=local_modelCondition.modelCondition_1, modelRevolve=local_modelRevolve.modelRevolve_1},
	{id=6, reward={{0,10040001,1680}}, modelCondition=local_modelCondition.modelCondition_1, modelRevolve=local_modelRevolve.modelRevolve_1},
	{id=7, reward={{0,21400009,1}}, showModel={{"0","Model/Pet/superpandaPlus"}}},
}

local defaults = {needRecharge=100, reward={{0,10040001,1080}}, showModel={}, modelCondition={{0,-50,0,50,1},{0,-50,0,50,2},{0,-50,0,50,3}}, modelRevolve={{20,-90,90,1},{20,-90,90,2},{20,-90,90,3}}, modelBehavior={}, previewVedio={}, mail=800004, Jump={"openUIPanel","dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel","1","2"}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_newServerGIft) do
	setmetatable(v, mt)
end

return cfg_newServerGIft