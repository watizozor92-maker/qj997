--工具自动生成
---@class MallProtos.MallGoodsInfoReq
---@field tabId number @ 页签Id

---@class MallProtos.MallGoodsInfoRes
---@field goodsList MallProtos.MallGoods[] 

---@class MallProtos.MallGoods
---@field goodsId number @商品Id
---@field cfgId number 
---@field coinType number @ 支付货币类型
---@field unitPrice number @ 价格
---@field associate number @关联
---@field limitCount number @限购数量
---@field limitType number @限购类型
---@field correctId number @修正Id
---@field count number 

---@class MallProtos.BuyMallGoodsReq
---@field goodsId number @ 商品id
---@field count number @ 购买数量

---@class MallProtos.BuyMallGoodsRes
---@field goodsId number @ 商品id
---@field count number @ 购买数量

---@class MallProtos.BuyPotionReq
---@field cfgId number @随身商店表id
---@field count number @购买数量

