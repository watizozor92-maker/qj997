-- 此文件工具自动生成，不要修改
---@class cfg_equip_stoneBoard_column
---道具id
---@field id number @id column=1 A
---策划用
---@field stoneName string @石板名称 column=2 B
---石板等级
---@field stoneBoardLevel number @石板等级 column=3 C
---石板提升镶嵌部位的萤石加成
---宝石组#数值（万分比）
---@field stoneAtt2 IntListList @提升该部位已镶嵌宝石的属性（万分比） column=4 D
---引用strpart
---@field pos IntList @可镶嵌的穿戴部位 column=5 E

local local_stoneAtt2 = {
    stoneAtt2_1={{1,10000}},

}

local local_pos = {
    pos_1={1,2,3,4,5,6,7,8,9,10},

}

local cfg_equip_stoneBoard =
{
	{id=50031616, stoneName="石板1级（火）", stoneAtt2={{1,10000},{2,10000}}},
	{id=50031617, stoneName="石板2级（火）", stoneBoardLevel=2},
	{id=50031618, stoneName="石板3级（火）", stoneBoardLevel=3},
	{id=50031619, stoneName="石板4级（火）", stoneBoardLevel=4},
	{id=50031620, stoneName="石板5级（火）", stoneBoardLevel=5},
	{id=50031621, stoneName="石板6级（火）", stoneBoardLevel=6},
	{id=50031622, stoneName="石板7级（火）", stoneBoardLevel=7},
	{id=50031623, stoneName="石板8级（火）", stoneBoardLevel=8},
	{id=50031624, stoneName="石板9级（火）", stoneBoardLevel=9},
	{id=50031625, stoneName="石板10级（火）", stoneBoardLevel=10},
	{id=50031626, stoneName="石板11级（火）", stoneBoardLevel=11},
	{id=50031627, stoneName="石板12级（火）", stoneBoardLevel=12},
	{id=50031628, stoneName="石板13级（火）", stoneBoardLevel=13},
	{id=50031629, stoneName="石板14级（火）", stoneBoardLevel=14},
	{id=50031630, stoneName="石板15级（火）", stoneBoardLevel=15},
	{id=50031631, stoneName="石板1级（水）"},
	{id=50031632, stoneName="石板2级（水）", stoneBoardLevel=2},
	{id=50031633, stoneName="石板3级（水）", stoneBoardLevel=3},
	{id=50031634, stoneName="石板4级（水）", stoneBoardLevel=4},
	{id=50031635, stoneName="石板5级（水）", stoneBoardLevel=5},
	{id=50031636, stoneName="石板6级（水）", stoneBoardLevel=6},
	{id=50031637, stoneName="石板7级（水）", stoneBoardLevel=7},
	{id=50031638, stoneName="石板8级（水）", stoneBoardLevel=8},
	{id=50031639, stoneName="石板9级（水）", stoneBoardLevel=9},
	{id=50031640, stoneName="石板10级（水）", stoneBoardLevel=10},
	{id=50031641, stoneName="石板11级（水）", stoneBoardLevel=11},
	{id=50031642, stoneName="石板12级（水）", stoneBoardLevel=12},
	{id=50031643, stoneName="石板13级（水）", stoneBoardLevel=13},
	{id=50031644, stoneName="石板14级（水）", stoneBoardLevel=14},
	{id=50031645, stoneName="石板15级（水）", stoneBoardLevel=15},
	{id=50031646, stoneName="石板1级（冰）"},
	{id=50031647, stoneName="石板2级（冰）", stoneBoardLevel=2},
	{id=50031648, stoneName="石板3级（冰）", stoneBoardLevel=3},
	{id=50031649, stoneName="石板4级（冰）", stoneBoardLevel=4},
	{id=50031650, stoneName="石板5级（冰）", stoneBoardLevel=5},
	{id=50031651, stoneName="石板6级（冰）", stoneBoardLevel=6},
	{id=50031652, stoneName="石板7级（冰）", stoneBoardLevel=7},
	{id=50031653, stoneName="石板8级（冰）", stoneBoardLevel=8},
	{id=50031654, stoneName="石板9级（冰）", stoneBoardLevel=9},
	{id=50031655, stoneName="石板10级（冰）", stoneBoardLevel=10},
	{id=50031656, stoneName="石板11级（冰）", stoneBoardLevel=11},
	{id=50031657, stoneName="石板12级（冰）", stoneBoardLevel=12},
	{id=50031658, stoneName="石板13级（冰）", stoneBoardLevel=13},
	{id=50031659, stoneName="石板14级（冰）", stoneBoardLevel=14},
	{id=50031660, stoneName="石板15级（冰）", stoneBoardLevel=15},
	{id=50031661, stoneName="石板1级（风）"},
	{id=50031662, stoneName="石板2级（风）", stoneBoardLevel=2},
	{id=50031663, stoneName="石板3级（风）", stoneBoardLevel=3},
	{id=50031664, stoneName="石板4级（风）", stoneBoardLevel=4},
	{id=50031665, stoneName="石板5级（风）", stoneBoardLevel=5},
	{id=50031666, stoneName="石板6级（风）", stoneBoardLevel=6},
	{id=50031667, stoneName="石板7级（风）", stoneBoardLevel=7},
	{id=50031668, stoneName="石板8级（风）", stoneBoardLevel=8},
	{id=50031669, stoneName="石板9级（风）", stoneBoardLevel=9},
	{id=50031670, stoneName="石板10级（风）", stoneBoardLevel=10},
	{id=50031671, stoneName="石板11级（风）", stoneBoardLevel=11},
	{id=50031672, stoneName="石板12级（风）", stoneBoardLevel=12},
	{id=50031673, stoneName="石板13级（风）", stoneBoardLevel=13},
	{id=50031674, stoneName="石板14级（风）", stoneBoardLevel=14},
	{id=50031675, stoneName="石板15级（风）", stoneBoardLevel=15, pos={1,2,3,4,5}},
}

local defaults = {stoneBoardLevel=1, stoneAtt2={{1,10000}}, pos={1,2,3,4,5,6,7,8,9,10}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_stoneBoard) do
	setmetatable(v, mt)
end

return cfg_equip_stoneBoard