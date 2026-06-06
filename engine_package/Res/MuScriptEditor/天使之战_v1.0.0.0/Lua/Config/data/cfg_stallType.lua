-- 此文件工具自动生成，不要修改
---@class cfg_stallType_column
---@field id number @id column=1 A
---
---0.角色截图类型
---1.角色类型
---2.道具类型
---4.货币类型
---@field stallType number @交易类型 column=2 B
---与stallType共同决定一个类型名称
---
---@field stallSubType number @交易子类型 column=3 C
---@field stallTypeName string @子类型名称 column=4 D
---当stallType=0时，填 按钮所在的面板路径#按钮名称|按钮所在的面板路径#按钮名称 直到打开所需要的面板为止
---当stallType=1时，填职业根ID
---当stallType=2时，填item表Type字段#subType字段
---多个用 | 分割
---当stallType=4时，填item表Type=1的道具ID
---多个用#号分割
---
---@field parameters1 StringListList @交易参数1 column=5 E
---当stallType=0时，填所需要截图的UI路径
---当
---@field parameters2 StringList @交易参数2 column=6 F
---[[客户端不使用]]@field   @ column=7 G
---[[客户端不使用]]@field   @ column=8 H
---[[客户端不使用]]@field   @ column=9 I
---[[客户端不使用]]@field   @ column=10 J
---[[客户端不使用]]@field   @ column=11 K
---[[客户端不使用]]@field   @ column=12 L

local local_parameters2 = {
    parameters2_1={""},

}

local cfg_stallType =
{
	{id=1, stallType=0, stallTypeName="加点", parameters1={{"dev/ui/MainUI/Panel/KLUISystemLeft/KLUISystemLeftPanel","BtnRole"}}, parameters2={"dev/ui/Role/Panel/KLAttr/KLAttrPanel&AttrInfo&0&-9","dev/ui/Role/Panel/KLAttr/KLAttrPanel&AttrEffect"}},
	{id=2, stallType=0, stallSubType=2, stallTypeName="回收", parameters1={{"dev/ui/MainUI/Panel/KLUISystemLeft/KLUISystemLeftPanel","bagBtn"},{"dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel","recycle_btn"}}, parameters2={"dev/ui/Recover/Panel/KLRecover/KLRecoverPanel","dev/ui/Bag/Panel/KLRecoverBag/KLRecoverBagPanel&img_250"}},
	{id=3, stallType=0, stallSubType=3, stallTypeName="技能", parameters1={{"dev/ui/MainUI/Panel/KLUISystemLeft/KLUISystemLeftPanel","button_jineng"}}, parameters2={"dev/ui/Skill/Panel/KLUISkillInfo/KLUISkillInfoPanel&KmlXWSkillInfoUI","dev/ui/Skill/Panel/KLUISkillDescribe/KLUISkillDescribePanel&BgWnd"}},
	{id=4, stallType=1, stallTypeName="战士", parameters1={{"1"}}},
	{id=5, stallType=1, stallSubType=2, stallTypeName="法师", parameters1={{"2"}}},
	{id=6, stallType=1, stallSubType=3, stallTypeName="弓箭手", parameters1={{"3"}}},
	{id=7, stallType=2, stallTypeName="装备"},
	{id=8, stallType=2, stallSubType=2, stallTypeName="材料", parameters1={{"5","1"},{"5","2"},{"5","3"},{"5","4"},{"6","1"},{"6","2"},{"6","3"},{"6","10"},{"6","11"},{"6","12"},{"6","13"},{"6","14"}}},
	{id=9, stallType=2, stallSubType=3, stallTypeName="宝箱", parameters1={{"4","1"},{"4","2"}}},
	{id=10, stallType=4, stallTypeName="金币", parameters1={{"10010001"}}},
	{id=11, stallType=4, stallSubType=2, stallTypeName="奇迹币", parameters1={{"10020001"}}},
	{id=12, stallType=4, stallSubType=3, stallTypeName="钻石", parameters1={{"10040001"}}},
}

local defaults = {stallSubType=1, parameters1={{"2","1"},{"2","2"},{"2","3"},{"2","4"},{"2","6"},{"2","7"},{"2","8"},{"2","9"},{"2","10"},{"2","11"},{"2","12"},{"2","13"},{"2","14"},{"2","15"},{"2","16"}}, parameters2={""}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_stallType) do
	setmetatable(v, mt)
end

return cfg_stallType