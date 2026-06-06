--工具自动生成
---@class BoxTradeProto.BoxTradeServerReq
---@field source number @来源，1：端内，2：端外，发起请求的位置
---@field clientOS string @客户端类型,android（安卓），ios（苹果），wap（PC）
---@field cmd number @接口编号
---@field jsonData string @转发至盒子交易行服务器的json串

---@class BoxTradeProto.BoxTradeRuleRes
---@field switchState number @交易行开关状态 0:关闭 1:开启
---@field maxTradeCount number @单角色交易行最大上架数量
---@field feesRate number @交易行手续费比例(万分比,如设置费率10%则该值为1000)
---@field jsonRule string @盒子交易行具体上架规则json串

---@class BoxTradeProto.BoxTradeInfoRes
---@field jsonData string @盒子交易行服务器转发的json串

---@class BoxTradeProto.BoxTradeLockRoleChangeRes
---@field roleId number @角色id
---@field boxTradeTime number @交易行上架时间，未上架锁定默认为0
---@field goodsId string @商品id

---@class BoxTradeProto.UnlockRoleReq
---@field roleId number @角色id
---@field source number @来源，1：端内，2：端外，发起请求的位置
---@field clientOS string @客户端类型,android（安卓），ios（苹果），wap（PC）
---@field cmd number @接口编号
---@field jsonData string @转发至盒子交易行服务器的json串

---@class BoxTradeProto.BoxTradeItemsInfoRes
---@field gameGoodsId number @盒子商品id
---@field item CommonProtos.Item @商品信息

---@class BoxTradeProto.BoxTradeItemsInfoReq
---@field gameGoodsId number @盒子商品id
---@field ownerId number @商品归属玩家id

