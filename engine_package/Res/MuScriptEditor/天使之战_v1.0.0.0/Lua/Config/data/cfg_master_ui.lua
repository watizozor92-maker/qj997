-- 此文件工具自动生成，不要修改
---@class cfg_master_ui_column
---第1位：1占位符
---第23位：根职业
---第4位：类
---第5位：系
---@field id number @唯一id column=1 A
---默认职业归属
---引援career职业表
---格式：所属根职业
---0为全职业
---多职业之间用#分割
---@field career IntList @所属职业 column=2 B
---1职业天赋；2技能天赋
---@field class number @天赋类别 column=3 C
---天赋所属的天赋系
---@field series number @所属天赋系 column=4 D
---文本ui路径
---@field textUi string @文本UI column=5 E
---图标UI路径
---@field iconUi string @图标UI column=6 F

local local_career = {
    career_1={1},
    career_2={2},
    career_3={3},

}

local cfg_master_ui =
{
	{id=10111, textUi="text_YMblue", iconUi="icon_YMjs"},
	{id=10112, series=2, textUi="text_SHgreen", iconUi="icon_SHjs"},
	{id=10121, class=2, textUi="text_YMblue", iconUi="icon_YMjs"},
	{id=10122, class=2, series=2, textUi="text_SHgreen", iconUi="icon_SHjs"},
	{id=10211, career=local_career.career_2, textUi="text_XJblue", iconUi="icon_XJfs"},
	{id=10212, career=local_career.career_2, series=2, textUi="text_ZHgreen", iconUi="icon_ZHfs"},
	{id=10221, career=local_career.career_2, class=2, textUi="text_XJblue", iconUi="icon_XJfs"},
	{id=10222, career=local_career.career_2, class=2, series=2, textUi="text_ZHgreen", iconUi="icon_ZHfs"},
	{id=10311, career=local_career.career_3, textUi="text_ZHblue", iconUi="icon_ZHgs"},
	{id=10312, career=local_career.career_3, series=2, textUi="text_XJgreen", iconUi="icon_XJgs"},
	{id=10321, career=local_career.career_3, class=2, textUi="text_ZHblue", iconUi="icon_ZHgs"},
	{id=10322, career=local_career.career_3, class=2, series=2, textUi="text_XJgreen", iconUi="icon_XJgs"},
}

local defaults = {career={1}, class=1, series=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_master_ui) do
	setmetatable(v, mt)
end

return cfg_master_ui