-- 此文件工具自动生成，不要修改
---@class cfg_onhook_column
---唯一序号
---@field id number @条目序号 column=1 A
---回复类型
---1=血量
---2=蓝量
---@field group number @分类 column=2 B
---选择可使用的道具id
---#分隔
---@field itemId IntList @道具id column=3 C
---显示的文字
---@field theText string @文字 column=4 D
---数据显示类型
---1数值，2百分比
---@field type number @类型 column=5 E
---默认回复
---百分比
---@field default number @默认 column=6 F
local cfg_onhook =
{
	{id=1, group=1, theText="血瓶", type=2, default=70},
	{id=2, group=2, itemId={30010015,30010014,30010013,30010012}, theText="蓝瓶", type=2, default=70},
}

local defaults = {itemId={30010009,30010008,30010007,30010006,30010005,30010004,30010003,30010002,30010001}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_onhook) do
	setmetatable(v, mt)
end

return cfg_onhook