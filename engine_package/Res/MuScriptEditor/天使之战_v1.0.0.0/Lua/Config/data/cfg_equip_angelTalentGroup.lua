-- 此文件工具自动生成，不要修改
---@class cfg_equip_angelTalentGroup_column
---@field id number @id column=1 A
---careerid
---@field Career number @职业归属 column=2 B
---@field talentGroup number @天赋组 column=3 C
---@field talentGroupName string @天赋组名 column=4 D
---图标名称#图片名称（icon图片和描述图片）
---@field talentGroupIcon StringList @天赋组图标 column=5 E
---图片名称
---Texture/图片名.扩展名
---例如：Texture/bg_CareerTalent.png
---@field talentGroupMenuIcon string @天赋组背景图 column=6 F

local local_talentGroupIcon = {
    talentGroupIcon_1={"icon_gongsu","text_gongsu"},
    talentGroupIcon_2={"icon_baoji","text_baoji"},
    talentGroupIcon_3={"icon_jianshang","text_jianshang"},

}

local cfg_equip_angelTalentGroup =
{
	{id=1, Career=1, talentGroup=1, talentGroupName="攻速", talentGroupMenuIcon="Texture/img_lizhan.png"},
	{id=2, Career=1, talentGroup=2, talentGroupName="暴击", talentGroupIcon=local_talentGroupIcon.talentGroupIcon_2, talentGroupMenuIcon="Texture/img_zhigong.png"},
	{id=3, Career=1, talentGroup=3, talentGroupName="减伤", talentGroupIcon=local_talentGroupIcon.talentGroupIcon_3, talentGroupMenuIcon="Texture/img_fangzhan.png"},
	{id=4, Career=2, talentGroup=4, talentGroupName="攻速", talentGroupMenuIcon="Texture/img_lizhan.png"},
	{id=5, Career=2, talentGroup=5, talentGroupName="暴击", talentGroupIcon=local_talentGroupIcon.talentGroupIcon_2, talentGroupMenuIcon="Texture/img_zhigong.png"},
	{id=6, Career=2, talentGroup=6, talentGroupName="减伤", talentGroupIcon=local_talentGroupIcon.talentGroupIcon_3, talentGroupMenuIcon="Texture/img_fangzhan.png"},
	{id=7, Career=3, talentGroup=7, talentGroupName="攻速", talentGroupMenuIcon="Texture/img_lizhan.png"},
	{id=8, Career=3, talentGroup=8, talentGroupName="暴击", talentGroupIcon=local_talentGroupIcon.talentGroupIcon_2, talentGroupMenuIcon="Texture/img_zhigong.png"},
	{id=9, Career=3, talentGroup=9, talentGroupName="减伤", talentGroupIcon=local_talentGroupIcon.talentGroupIcon_3, talentGroupMenuIcon="Texture/img_fangzhan.png"},
}

local defaults = {talentGroupIcon={"icon_gongsu","text_gongsu"}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_angelTalentGroup) do
	setmetatable(v, mt)
end

return cfg_equip_angelTalentGroup