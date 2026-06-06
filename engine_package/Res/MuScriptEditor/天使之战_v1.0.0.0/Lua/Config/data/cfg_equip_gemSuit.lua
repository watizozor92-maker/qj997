-- 此文件工具自动生成，不要修改
---@class cfg_equip_gemSuit_column
---@field id number @id column=1 A
---宝石组#个数丨宝石组#个数
---@field gemCondition IntListList @达成条件 column=2 B
---1=幸运荧光属性
---2=套装属性
---@field atttype string @属性类型 column=3 C
---策划备注
---@field title string @备注 column=4 D
---属性id#数值丨属性id#数值
---@field suitAtt IntListList @套装属性 column=5 E

local local_suitAtt = {
    suitAtt_1={{314023,50},{213021,10}},

}

local cfg_equip_gemSuit =
{
	{id=1, gemCondition={{1,1},{5,1},{3,1}}, title="幸运荧光属性1"},
	{id=2, gemCondition={{5,1},{3,1},{1,1}}, title="幸运荧光属性2"},
	{id=3, gemCondition={{2,1},{6,1},{4,1}}, title="幸运荧光属性3", suitAtt={{206011,24}}},
	{id=4, gemCondition={{6,1},{4,1},{2,1}}, title="幸运荧光属性4", suitAtt={{207011,29}}},
	{id=5, atttype="2", title="荧光套装属性1", suitAtt={{304012,300}}},
	{id=6, gemCondition={{1,1},{2,3},{3,1},{4,3},{5,1},{6,2}}, atttype="2", title="荧光套装属性2", suitAtt={{314019,100}}},
}

local defaults = {gemCondition={{1,1},{2,1},{3,1},{4,1},{5,1},{6,1}}, atttype="1", suitAtt={{314023,50},{213021,10}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_gemSuit) do
	setmetatable(v, mt)
end

return cfg_equip_gemSuit