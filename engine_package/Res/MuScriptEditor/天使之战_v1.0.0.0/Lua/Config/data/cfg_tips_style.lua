-- 此文件工具自动生成，不要修改
---@class cfg_tips_style_column
---被item表tips字段引用
---@field id number @id column=1 A
---策划备注用
---@field remarks string @备注 column=2 B
---tips背景图资源名称
---不填读取默认样式
---@field background string @背景图 column=3 C
---tips边框图片资源名称
---不填则不显示
---@field border string @背景图边框图 column=4 D
---引用cfg_model_effect/id
---不填则不显示
---@field borderEffect number @背景图边框特效 column=5 E
---tips内道具背景图资源名称
---不填则不显示
---@field itemBg string @模型背景图 column=6 F
---tips内道具边框图片资源名称
---不填则不显示
---@field itemBorder string @模型背景图边框图 column=7 G
---引用cfg_model_effect/id
---不填则不显示
---@field itemBorderEffect number @模型背景图边框特效 column=8 H
local cfg_tips_style =
{
	{id=111, remarks="太酷辣测试数据", background="", border="", borderEffect=30002, itemBg="", itemBorder="ty_equipicon", itemBorderEffect=30001},
}
return cfg_tips_style