-- 此文件工具自动生成，不要修改
---@class cfg_recharge_singleItem_column
---recharge主表id
---@field id number @Id column=1 A
---出现条件
---@field condition string @出现条件 column=2 B
---对应工程中图片名称
---@field btn string @主界面按钮 column=3 C
---对应工程中图片名称
---@field bg string @背景图 column=4 D
---对应工程中图片名称
---@field checkBtn string @查看按钮 column=5 E
---礼包持续多久，单位毫秒
---@field time number @倒计时 column=6 F
---1#坐骑表id，2#item表id
---@field showItem IntList @展示物品item column=7 G
---item表id#数量
---@field item IntList @道具 column=8 H
---商城原价
---@field orgPrice item @原价 column=9 I
---限时返利XX%
---@field profit string @限时返利 column=10 J
local cfg_recharge_singleItem =
{
	{id=501, btn="mount_pre_buy", bg="Texture/mount_pre_bg.png", checkBtn="mount_pre_button", time=72000000, showItem={1,4}, item={21600004,1}, orgPrice="328", profit="mount_pre_fnali"},
}

local defaults = {condition="901#2&101#100"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_recharge_singleItem) do
	setmetatable(v, mt)
end

return cfg_recharge_singleItem