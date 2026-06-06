-- 此文件工具自动生成，不要修改
---@class cfg_bindtransform_column
---排序
---@field id number @唯一ID column=1 A
---物品表的ID
---[[客户端不使用]]@field itemid number @物品ID column=2 B
---策划用
---[[客户端不使用]]@field name string @名称 column=3 C
---策划用
---[[客户端不使用]]@field desc string @绑定的 column=4 D
---绑定和非绑定通过这个字段关联
---[[客户端不使用]]@field transform number @转化为非绑定 column=5 E
local cfg_bindtransform =
{
	{id=1},
	{id=2},
}
return cfg_bindtransform