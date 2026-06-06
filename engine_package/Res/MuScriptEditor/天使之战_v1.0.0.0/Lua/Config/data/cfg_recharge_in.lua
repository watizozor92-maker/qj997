-- 此文件工具自动生成，不要修改
---@class cfg_recharge_in_column
---@field id number @编号 column=1 A
---[[客户端不使用]]@field name string @充值说明 column=2 B
---1：废弃 不填：不废弃
---@field departed number @标识礼包废弃 column=3 C
---礼包名称
---[[客户端不使用]]@field giftName string @礼包名称 column=4 D
---1常规充值（首次购买可领取附赠商品）2月卡 3首充礼包 4用户充值 
---@field type number @充值类型 column=5 E
---购买需要满足的条件
---[[客户端不使用]]@field buyCondition IntList @购买条件 column=6 F
---Android 跟 iOS 不填 通用
---@field channelControl number @渠道控制 column=7 G
---0：安卓 1：通用 2：iOS
---@field Webpage number @是否允许网页充值（1和2允许网页充值） column=8 H
---[[客户端不使用]]@field webcondition IntList @iOS网页充值的条件 column=9 I
---[[客户端不使用]]@field infiniteCountKey IntList @充值计数刷新key(不限制，无限大) column=10 J
---@field countKey number @购买次数刷新key column=11 K
---单位是分不是元
---@field rmb number @礼包购买需花费金额 column=12 L
---1：计入；不填：不计入
---@field directpurchase number @是否计入直购回馈 column=13 M
---充值档位用，填1领完首充奖励后第二天刷新附赠钻石 不填或填0当天即领取，决定一个充值轮回后当日首充是否会触发每日双倍首充
---@field Refresh number @是否首次触发每日首充 column=14 N
local cfg_recharge_in =
{
}
return cfg_recharge_in