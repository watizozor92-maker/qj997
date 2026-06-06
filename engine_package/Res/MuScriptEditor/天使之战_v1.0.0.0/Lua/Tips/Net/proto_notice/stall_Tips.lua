--工具自动生成
---@class StallProto.BeginStallReq
---@field x number 
---@field y number 

---@class StallProto.BeginStallRes
---@field x number 
---@field y number 
---@field stallId number @ 摊位id
---@field holderId number @ 摊主rid

---@class StallProto.StallInfoRes
---@field stallId number @ 摊位id
---@field holderId number @ 摊主rid
---@field holderName string @ 摊主名称
---@field career CommonProtos.Career @ 摊主职业
---@field totalSales number @ 累计销售总额
---@field advertising string @ 广告
---@field stallGoods StallProto.StallGoods[] @ 摊位商品列表

---@class StallProto.StallGoods
---@field goodsId number @ 商品id
---@field item CommonProtos.Item @ 道具
---@field unitPrice number @ 单价
---@field moneyType number @ 货币类型

---@class StallProto.OpenStallReq
---@field stallId number @ 摊位id

---@class StallProto.CloseStallReq
---@field stallHolderId number @ 摊主rid

---@class StallProto.AddStallItemReq
---@field unitPrice number @ 单价
---@field count number @ 数量
---@field moneyType number @ 货币类型
---@field bagIndexOfItem number @ 背包格子索引

---@class StallProto.RemoveStallItemReq
---@field goodsId number @ 下架商品id

---@class StallProto.UpdateStallInfoReq
---@field advertising string @ 广告

---@class StallProto.BuyStallItemReq
---@field holderRid number @ 摊主rid
---@field goodsId number @ 商品id

---@class StallProto.StallSalesRecordRes
---@field recordResList StallProto.StallSalesRecord[] 

---@class StallProto.StallSalesRecord
---@field time number @ 售出时间
---@field itemCfgId number @ 物品configId
---@field count number @ 数量
---@field totalMoney number @ 总金额
---@field tax number @ 税费

