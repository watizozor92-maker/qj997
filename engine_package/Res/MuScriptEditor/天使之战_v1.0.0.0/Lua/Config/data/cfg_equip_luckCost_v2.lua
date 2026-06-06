-- 此文件工具自动生成，不要修改
---@class cfg_equip_luckCost_v2_column
---@field id number @id column=1 A
---@field costGroupId number @消耗组 column=2 B
---描写装备信息，方便查看
---@field description string @描述 column=3 C
---追加等级
---@field level number @追加等级 column=4 D
---追加等级
---@field successLevel number @追加等级 column=5 E
---万分比
---@field rate number @激活成功率（服务端） column=6 F
---(前端被100整除)万分比
---@field rateClient number @激活成功率（客户端） column=7 G
---追加失败后的等级
---@field failLevel number @追加失败后的等级 column=8 H
---格式：0（否）/ 1（是）
---备注：当玩家此装备首次强化到该等级时，全服展示跑马灯
---@field firstRate number @是否开启跑马灯 column=9 I
---备注：不填表示该强化等级不显示文字提示
---@field tips string @下一阶段文字提示(前端) column=10 J
---消耗道具：道具id#数量|道具id#数量
---@field costTag IntList @消耗道具 column=11 K
local cfg_equip_luckCost_v2 =
{
	{id=1, costGroupId=1, description="幸运宝石+1", level=0, successLevel=1, rate=10000, rateClient=10000, failLevel=0, firstRate=0, tips="用于激活幸运属性", costTag={1254006799,1}},
}
return cfg_equip_luckCost_v2