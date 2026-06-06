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
    gift_1={{50040015,1,1},{50040015,1,2},{50040015,1,3}},
    gift_2={{50040042,1,1},{50040042,1,2},{50040042,1,3}},
    gift_3={{40011104,1,1},{40011104,1,2},{40011104,1,3}},
    gift_4={{40011103,1,1},{40011103,1,2},{40011103,1,3}},
    gift_5={{50040097,30,1},{50040097,30,2},{50040097,30,3}},
    gift_6={{50010010,300,1},{50010010,300,2},{50010010,300,3}},
    gift_7={{50030005,5,1},{50030005,5,2},{50030005,5,3}},
    gift_8={{50040076,30,1},{50040076,30,2},{50040076,30,3}},
    gift_9={{50040059,50,1},{50040059,50,2},{50040059,50,3}},
    gift_10={{50044101,1,1},{50044101,1,2},{50044101,1,3}},
    gift_11={{40011105,1,1},{40011105,1,2},{40011105,1,3}},
    gift_12={{50040097,50,1},{50040097,50,2},{50040097,50,3}},
    gift_13={{50010010,500,1},{50010010,500,2},{50010010,500,3}},
    gift_14={{40010211,30,1},{40010211,30,2},{40010211,30,3}},
    gift_15={{50040100,30,1},{50040100,30,2},{50040100,30,3}},
    gift_16={{50030005,2,1},{50030005,2,2},{50030005,2,3}},
    gift_17={{50044102,1,1},{50044102,1,2},{50044102,1,3}},
    gift_18={{40011106,1,1},{40011106,1,2},{40011106,1,3}},

}

local local_mail = {
    mail_1={{50040015,1,1},{50040015,1,2},{50040015,1,3}},
    mail_2={{50040042,1,1},{50040042,1,2},{50040042,1,3}},
    mail_3={{40011104,1,1},{40011104,1,2},{40011104,1,3}},
    mail_4={{40011103,1,1},{40011103,1,2},{40011103,1,3}},
    mail_5={{50040097,30,1},{50040097,30,2},{50040097,30,3}},
    mail_6={{50010010,300,1},{50010010,300,2},{50010010,300,3}},
    mail_7={{50030005,5,1},{50030005,5,2},{50030005,5,3}},
    mail_8={{50040076,30,1},{50040076,30,2},{50040076,30,3}},
    mail_9={{50040059,50,1},{50040059,50,2},{50040059,50,3}},
    mail_10={{50044101,1,1},{50044101,1,2},{50044101,1,3}},
    mail_11={{40011105,1,1},{40011105,1,2},{40011105,1,3}},
    mail_12={{50040097,50,1},{50040097,50,2},{50040097,50,3}},
    mail_13={{50010010,500,1},{50010010,500,2},{50010010,500,3}},
    mail_14={{40010211,30,1},{40010211,30,2},{40010211,30,3}},
    mail_15={{50040100,30,1},{50040100,30,2},{50040100,30,3}},
    mail_16={{50030005,2,1},{50030005,2,2},{50030005,2,3}},
    mail_17={{50044102,1,1},{50044102,1,2},{50044102,1,3}},
    mail_18={{40011106,1,1},{40011106,1,2},{40011106,1,3}},

}

local cfg_Activity_costRank =
{
	{id=100001, gift={{61400004,1,1},{61400004,1,2},{61400004,1,3}}, mail={{61400004,1,1},{61400004,1,2},{61400004,1,3}}},
	{id=100002, ranking=2},
	{id=100003, ranking=3, gift=local_gift.gift_2, mail=local_mail.mail_2},
	{id=100004, ranking=4, gift=local_gift.gift_3, mail=local_mail.mail_3},
	{id=100005, ranking=5, gift=local_gift.gift_4, mail=local_mail.mail_4},
	{id=100006, ranking=6, gift=local_gift.gift_5, mail=local_mail.mail_5},
	{id=100007, ranking=7, gift=local_gift.gift_6, mail=local_mail.mail_6},
	{id=100008, ranking=8, gift=local_gift.gift_7, mail=local_mail.mail_7},
	{id=100009, ranking=9, gift=local_gift.gift_8, mail=local_mail.mail_8},
	{id=100010, ranking=10, gift=local_gift.gift_9, mail=local_mail.mail_9},
	{id=100011, mainGroup=5, gift={{61300001,1,1},{61300001,1,2},{61300001,1,3}}, mail={{61300001,1,1},{61300001,1,2},{61300001,1,3}}},
	{id=100012, ranking=2, mainGroup=5},
	{id=100013, ranking=3, mainGroup=5, gift=local_gift.gift_2, mail=local_mail.mail_2},
	{id=100014, ranking=4, mainGroup=5, gift=local_gift.gift_3, mail=local_mail.mail_3},
	{id=100015, ranking=5, mainGroup=5, gift=local_gift.gift_4, mail=local_mail.mail_4},
	{id=100016, ranking=6, mainGroup=5, gift=local_gift.gift_5, mail=local_mail.mail_5},
	{id=100017, ranking=7, mainGroup=5, gift=local_gift.gift_6, mail=local_mail.mail_6},
	{id=100018, ranking=8, mainGroup=5, gift=local_gift.gift_7, mail=local_mail.mail_7},
	{id=100019, ranking=9, mainGroup=5, gift=local_gift.gift_8, mail=local_mail.mail_8},
	{id=100020, ranking=10, mainGroup=5, gift=local_gift.gift_9, mail=local_mail.mail_9},
	{id=100021, mainGroup=7, gift={{61400005,1,1},{61400005,1,2},{61400005,1,3}}, mail={{61400005,1,1},{61400005,1,2},{61400005,1,3}}},
	{id=100022, ranking=2, mainGroup=7, gift=local_gift.gift_10, mail=local_mail.mail_10},
	{id=100023, ranking=3, mainGroup=7},
	{id=100024, ranking=4, mainGroup=7, gift=local_gift.gift_11, mail=local_mail.mail_11},
	{id=100025, ranking=5, mainGroup=7, gift=local_gift.gift_3, mail=local_mail.mail_3},
	{id=100026, ranking=6, mainGroup=7, gift=local_gift.gift_12, mail=local_mail.mail_12},
	{id=100027, ranking=7, mainGroup=7, gift=local_gift.gift_13, mail=local_mail.mail_13},
	{id=100028, ranking=8, mainGroup=7, gift=local_gift.gift_14, mail=local_mail.mail_14},
	{id=100029, ranking=9, mainGroup=7, gift=local_gift.gift_15, mail=local_mail.mail_15},
	{id=100030, ranking=10, mainGroup=7, gift=local_gift.gift_16, mail=local_mail.mail_16},
	{id=100031, mainGroup=9, gift={{61300004,1,1},{61300004,2,2},{61300004,1,3}}, mail={{61300004,1,1},{61300004,2,2},{61300004,1,3}}},
	{id=100032, ranking=2, mainGroup=9, gift=local_gift.gift_10, mail=local_mail.mail_10},
	{id=100033, ranking=3, mainGroup=9},
	{id=100034, ranking=4, mainGroup=9, gift=local_gift.gift_11, mail=local_mail.mail_11},
	{id=100035, ranking=5, mainGroup=9, gift=local_gift.gift_3, mail=local_mail.mail_3},
	{id=100036, ranking=6, mainGroup=9, gift=local_gift.gift_12, mail=local_mail.mail_12},
	{id=100037, ranking=7, mainGroup=9, gift=local_gift.gift_13, mail=local_mail.mail_13},
	{id=100038, ranking=8, mainGroup=9, gift=local_gift.gift_14, mail=local_mail.mail_14},
	{id=100039, ranking=9, mainGroup=9, gift=local_gift.gift_15, mail=local_mail.mail_15},
	{id=100040, ranking=10, mainGroup=9, gift=local_gift.gift_16, mail=local_mail.mail_16},
	{id=100041, mainGroup=11, gift={{61400006,1,1},{61400006,1,2},{61400006,1,3}}, mail={{61400006,1,1},{61400006,1,2},{61400006,1,3}}},
	{id=100042, ranking=2, mainGroup=11, gift=local_gift.gift_17, mail=local_mail.mail_17},
	{id=100043, ranking=3, mainGroup=11, gift=local_gift.gift_10, mail=local_mail.mail_10},
	{id=100044, ranking=4, mainGroup=11, gift=local_gift.gift_18, mail=local_mail.mail_18},
	{id=100045, ranking=5, mainGroup=11, gift=local_gift.gift_11, mail=local_mail.mail_11},
	{id=100046, ranking=6, mainGroup=11, gift=local_gift.gift_12, mail=local_mail.mail_12},
	{id=100047, ranking=7, mainGroup=11, gift=local_gift.gift_13, mail=local_mail.mail_13},
	{id=100048, ranking=8, mainGroup=11, gift=local_gift.gift_14, mail=local_mail.mail_14},
	{id=100049, ranking=9, mainGroup=11, gift=local_gift.gift_15, mail=local_mail.mail_15},
	{id=100050, ranking=10, mainGroup=11, gift=local_gift.gift_16, mail=local_mail.mail_16},
	{id=100051, mainGroup=13, gift={{61300005,1,1},{61300005,1,2},{61300005,1,3}}, mail={{61300005,1,1},{61300005,1,2},{61300005,1,3}}},
	{id=100052, ranking=2, mainGroup=13, gift=local_gift.gift_17, mail=local_mail.mail_17},
	{id=100053, ranking=3, mainGroup=13, gift=local_gift.gift_10, mail=local_mail.mail_10},
	{id=100054, ranking=4, mainGroup=13, gift=local_gift.gift_18, mail=local_mail.mail_18},
	{id=100055, ranking=5, mainGroup=13, gift=local_gift.gift_11, mail=local_mail.mail_11},
	{id=100056, ranking=6, mainGroup=13, gift=local_gift.gift_12, mail=local_mail.mail_12},
	{id=100057, ranking=7, mainGroup=13, gift=local_gift.gift_13, mail=local_mail.mail_13},
	{id=100058, ranking=8, mainGroup=13, gift=local_gift.gift_14, mail=local_mail.mail_14},
	{id=100059, ranking=9, mainGroup=13, gift=local_gift.gift_15, mail=local_mail.mail_15},
	{id=100060, ranking=10, mainGroup=13, gift=local_gift.gift_16, mail=local_mail.mail_16},
}

local defaults = {ranking=1, CHtext="消费排行", mainGroup=3, gift={{50040015,1,1},{50040015,1,2},{50040015,1,3}}, mail={{50040015,1,1},{50040015,1,2},{50040015,1,3}}, text="充值300可上榜"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Activity_costRank) do
	setmetatable(v, mt)
end

return cfg_Activity_costRank