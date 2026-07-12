-- 此文件工具自动生成，不要修改
---@class cfg_Activity_costRank_column
---可被调用的唯一id
---@field id number @唯一id column=1 A
---角色排名
---@field ranking number @排名 column=2 B
---备注
---@field CHtext string @策划备注 column=3 C
---用于读取cfg_OperateActivity_all中的mainGroup字段
---@field mainGroup number @活动组id column=4 D
---展示在排名界面的精品奖励                                                      格式：id#数量#领取职业id|道具id#数量#领取职业id，不填职业就是没有限制（道具id在cfg_item中查找）
---@field gift IntListList @展示奖励 column=5 E
---实际发放给玩家的奖励                                              格式：id#数量#领取职业id|道具id#数量#领取职业id，不填职业就是没有限制（道具id在cfg_item中查找）
---@field mail IntListList @邮件奖励 column=6 F
---没有玩家上榜是显示的文本
---@field text string @未上榜显示文本 column=7 G

local local_gift = {
    gift_1={},

}

local local_mail = {
    mail_1={},

}

local cfg_Activity_costRank =
{
	{id=100001},
	{id=100002, ranking=2},
	{id=100003, ranking=3},
	{id=100004, ranking=4},
	{id=100005, ranking=5},
	{id=100006, ranking=6},
	{id=100007, ranking=7},
	{id=100008, ranking=8},
	{id=100009, ranking=9},
	{id=100010, ranking=10},
	{id=100011, mainGroup=5},
	{id=100012, ranking=2, mainGroup=5},
	{id=100013, ranking=3, mainGroup=5},
	{id=100014, ranking=4, mainGroup=5},
	{id=100015, ranking=5, mainGroup=5},
	{id=100016, ranking=6, mainGroup=5},
	{id=100017, ranking=7, mainGroup=5},
	{id=100018, ranking=8, mainGroup=5},
	{id=100019, ranking=9, mainGroup=5},
	{id=100020, ranking=10, mainGroup=5},
	{id=100021, mainGroup=7},
	{id=100022, ranking=2, mainGroup=7},
	{id=100023, ranking=3, mainGroup=7},
	{id=100024, ranking=4, mainGroup=7},
	{id=100025, ranking=5, mainGroup=7},
	{id=100026, ranking=6, mainGroup=7},
	{id=100027, ranking=7, mainGroup=7},
	{id=100028, ranking=8, mainGroup=7},
	{id=100029, ranking=9, mainGroup=7},
	{id=100030, ranking=10, mainGroup=7},
	{id=100031, mainGroup=9},
	{id=100032, ranking=2, mainGroup=9},
	{id=100033, ranking=3, mainGroup=9},
	{id=100034, ranking=4, mainGroup=9},
	{id=100035, ranking=5, mainGroup=9},
	{id=100036, ranking=6, mainGroup=9},
	{id=100037, ranking=7, mainGroup=9},
	{id=100038, ranking=8, mainGroup=9},
	{id=100039, ranking=9, mainGroup=9},
	{id=100040, ranking=10, mainGroup=9},
	{id=100041, mainGroup=11},
	{id=100042, ranking=2, mainGroup=11},
	{id=100043, ranking=3, mainGroup=11},
	{id=100044, ranking=4, mainGroup=11},
	{id=100045, ranking=5, mainGroup=11},
	{id=100046, ranking=6, mainGroup=11},
	{id=100047, ranking=7, mainGroup=11},
	{id=100048, ranking=8, mainGroup=11},
	{id=100049, ranking=9, mainGroup=11},
	{id=100050, ranking=10, mainGroup=11},
	{id=100051, mainGroup=13},
	{id=100052, ranking=2, mainGroup=13},
	{id=100053, ranking=3, mainGroup=13},
	{id=100054, ranking=4, mainGroup=13},
	{id=100055, ranking=5, mainGroup=13},
	{id=100056, ranking=6, mainGroup=13},
	{id=100057, ranking=7, mainGroup=13},
	{id=100058, ranking=8, mainGroup=13},
	{id=100059, ranking=9, mainGroup=13},
	{id=100060, ranking=10, mainGroup=13},
}

local defaults = {ranking=1, CHtext="消费排行", mainGroup=3, gift={}, mail={}, text="充值300可上榜"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Activity_costRank) do
	setmetatable(v, mt)
end

return cfg_Activity_costRank