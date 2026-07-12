-- 此文件工具自动生成，不要修改
---@class cfg_wearing_bar_column
---必须按照顺序
---@field id number @穿戴栏id column=1 A
---备注字段
---@field name string @穿戴栏名称 column=2 B
---用于标识穿戴栏类别；新增特殊作用标签需要额外处理
---@field tag string @穿戴栏标签 column=3 C
---填写引用文件名称，不填则不显示
---格式：穿戴栏图标#穿戴栏文本
---@field icon string @穿戴栏图标 column=4 D
---穿戴栏部位根据界面显示开放，填写穿戴栏要隐藏的部位；读取cfg_item表strPart部位
---@field hideArea IntList @穿戴栏隐藏部位 column=5 E

local local_hideArea = {
    hideArea_1={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,71,72,73,74,75,76,77,78},
    hideArea_2={16,17,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,71,72,73,74,75,76,77,78},

}

local cfg_wearing_bar =
{
	{id=1, name="基本穿戴栏", tag="职业穿戴栏#基础穿戴栏", icon="zb_01", hideArea=local_hideArea.hideArea_2},
	{id=2, name="时装穿戴栏", icon="sz_01"},
	{id=3, name="大天使时装", icon="dts_01"},
	{id=4, name="时空跃迁者", icon="skyqz_01"},
	{id=5, name="次元之新星", icon="cyzxx_01"},
	{id=6, name="冰霜之永冻", icon="bszyd_01"},
	{id=7, name="蔷薇之恋人", icon="qwzlr_01"},
	{id=8, name="荣誉之英勇", icon="ryzyy_01"},
	{id=9, name="大天使装备", tag="天使穿戴栏", icon="dts_01", hideArea={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116}},
	{id=10, name="星芒", icon="xmzjx_01"},
	{id=11, name="皇家", icon="hjjw_01"},
	{id=12, name="圣导师穿戴栏", tag="基础穿戴栏", icon="", hideArea=local_hideArea.hideArea_2},
}

local defaults = {tag="时装穿戴栏", hideArea={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,71,72,73,74,75,76,77,78}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_wearing_bar) do
	setmetatable(v, mt)
end

return cfg_wearing_bar