--工具自动生成
---@class NpcShopProto.NpcShopGoodsInfoReq
---@field shopId number 

---@class NpcShopProto.NpcShopGoodsInfoRes
---@field goodsList NpcShopProto.NpcShopGoods[] 

---@class NpcShopProto.NpcShopGoods
---@field goodsId number @商品Id
---@field correctId number 
---@field coinType number @ 支付货币类型
---@field unitPrice number @ 价格
---@field associate number @关联
---@field limitCount number @限购数量
---@field limitType number @限购类型
---@field level number @购买等级要求
---@field count number @商品数量
---@field discount number @折扣
---@field id number @商品表主键

---@class NpcShopProto.BuyShopGoodsReq
---@field shopId number @商店Id
---@field goodsId number @ 商品id
---@field count number @ 购买数量

---@class NpcShopProto.BuyShopGoodsRes
---@field shopId number @商店Id
---@field goodsId number @ 商品id
---@field count number @ 购买数量

---@class NpcShopProto.BagItemTradeReq
---@field shopId number @npc商店Id
---@field indexList number[] @背包索引

---@class NpcShopProto.BagItemTradeRes
---@field itemList CommonProtos.Item[] 

---@class NpcShopProto.RefreshNpcShopGoodsReq
---@field shopId number @商店id
---@field cfgId number @使用的刷新道具配置id，若没有使用传递0
---@field count number @使用的刷新道具对应的数量
---@field remainRefreshCount number @剩余刷新次数
---@field maxRefreshCount number @刷新次数上限

---@class NpcShopProto.RefreshNpcShopGoodsRes
---@field remainRefreshCount number @剩余刷新次数
---@field endTime number @倒计时结束的时间对应时间戳

