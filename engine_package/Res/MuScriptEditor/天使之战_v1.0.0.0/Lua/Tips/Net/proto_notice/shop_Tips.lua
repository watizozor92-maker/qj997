--工具自动生成
---@class ShopProto.Shop
---@field rid number @roleID
---@field name string @商店名称
---@field roleName string @ 店主名称
---@field openTime number @开业时间
---@field allCount number @总数
---@field sellCount number @销售总数
---@field online number 
---@field makeCount number @关注数量,进入一次 关注数量+1

---@class ShopProto.ShopListReq

---@class ShopProto.ShopListRes
---@field maxCount number @总数量；从1开始
---@field shop ShopProto.Shop[] 

---@class ShopProto.ItemListReq

---@class ShopProto.ItemListRes
---@field maxCount number @总数量；从1开始
---@field goods ShopProto.ShopGoods[] @商品内容

---@class ShopProto.ShopGoods
---@field item CommonProtos.Item @道具
---@field sell number @售价
---@field createTime number @添加时间
---@field shopName string @商店名称
---@field roleName string @ 店主名称
---@field coinItemId number @货币类型

---@class ShopProto.GoodsListReq
---@field rid number @roleID
---@field shopGoodsPos number @道具所在位置

---@class ShopProto.GoodsListRes
---@field maxCount number @总数量；从1开始
---@field shopGoodsPos number @道具所在位置
---@field goods ShopProto.ShopGoods[] @商品内容

---@class ShopProto.CreateShopReq
---@field name string @商店名称

---@class ShopProto.CreateShopRes
---@field shop ShopProto.Shop 

---@class ShopProto.BagItemPutOnReq
---@field indexInBag number @背包索引
---@field shopGoodsPos number @上架位置
---@field price number @价格
---@field coinItemId number @货币类型

---@class ShopProto.BagItemPutOnRes
---@field indexInBag number @背包索引
---@field shopGoodsPos number @上架位置
---@field shopGoods ShopProto.ShopGoods 

---@class ShopProto.BuyItemReq
---@field itemId number 
---@field otherRid number 

---@class ShopProto.BuyItemRes
---@field sellItemId number 
---@field otherRid number 

---@class ShopProto.GoodsPosChangeReq
---@field itemId number 
---@field fromPos number @位置信息
---@field toPos number @位置信息

---@class ShopProto.GoodsPosChangeRes
---@field itemId number 
---@field fromPos number @位置信息
---@field toPos number @位置信息

---@class ShopProto.DeleteSoldRecordReq
---@field itemId number 

---@class ShopProto.DeleteSoldRecordRes
---@field itemId number 

---@class ShopProto.UpdateItemPutOnReq
---@field itemId number 
---@field shopGoodsPos number @上架位置
---@field price number @价格
---@field coinItemId number @货币类型

---@class ShopProto.UpdateItemPutOnRes
---@field itemId number 
---@field shopGoodsPos number @上架位置
---@field price number @价格
---@field coinItemId number @货币类型

---@class ShopProto.MakeCountReq
---@field otherRid number 

---@class ShopProto.MakeCountRes
---@field otherRid number 

