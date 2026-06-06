-- 此文件工具自动生成，不要修改
---@class cfg_efficiency_column
---@field id number @唯一id column=1 A
---相同组在同一个页签下显示
---@field group number @组 column=2 B
---2101 使用道具 1201 开通会员 2102 开通特权
---满足时显示已激活
---@field conditions string @是否激活的条件 column=3 C
---当前的页签显示名称
---@field name string @页签名称 column=4 D
---背景图的名称#背景图名称
---@field backgroundImg string @该页签下背景图 column=5 E
---道具id#道具id
---和前面背景图的顺序一样
---若无道具则不配置
---@field item IntListList @该背景图下显示的道具 column=6 F
---数值读取
---@field text string @背景图上的数字 column=7 G
---百分比
---@field Scale number @模型大小缩放 column=8 H
---和jump一一对应
---不配条件则为不满足其他条件时跳转
---@field jumpCondition string @跳转条件 column=9 I
---配对应界面路径的快捷指令，和前面背景图的顺序一样 快捷指令#快捷指令
---@field Jump StringListList @该页签下按钮跳转路径 column=10 J
---达到该等级时才显示对应页签
---@field level number @显示等级 column=11 K

local local_item = {
    item_1={},

}

local local_Jump = {
    Jump_1={{"openUIPanel","dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel","1","2"}},

}

local cfg_efficiency =
{
	{id=1001, group=1, conditions="2101#30030201/2101#30030202/2101#30030203", name="经验倍率", backgroundImg="recharge01", item={{30030201}}, text="50", Scale=125},
	{id=1002, group=1, conditions="1201#1", name="经验倍率", backgroundImg="recharge04", item=local_item.item_1, text="10", Scale=0, jumpCondition="", Jump={{"openUIPanel","dev/outui/VIP/Panel/KLNewVIPMain/KLNewVIPMainPanel"}}},
	{id=1004, group=2, name="快捷拾取", backgroundImg="recharge03_2", item=local_item.item_1, text="", Scale=0, jumpCondition="", Jump=local_Jump.Jump_1},
	{id=1005, group=3, name="自动回收", backgroundImg="recharge02_2", item=local_item.item_1, text="", Scale=0, jumpCondition="", Jump=local_Jump.Jump_1},
}

local defaults = {conditions="2102#30/2102#31/2102#32/2102#33", jumpCondition="2301#30030201/2301#30030202/2301#30030203|903#1|", Jump={{"openUIPanel","dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel","1","JumpSelectItem_1=30030201&JumpSelectItem_2=30030202&JumpSelectItem_3=30030203"},{"openUIPanel","dev/outui/FirstCharge/Panel/KLFirstCharge/KLFirstChargePanel"},{"openUIPanel","dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel","1","1&3011"}}, level=30}
local mt = {__index = defaults}
for _, v in ipairs(cfg_efficiency) do
	setmetatable(v, mt)
end

return cfg_efficiency