--工具自动生成
---@class TradeLineProto.GoodsInfoReq

---@class TradeLineProto.GoodsInfoRes
---@field goodsList TradeLineProto.Goods[] 
---@field isEnd boolean @ 分包发送，标识是否结束

---@class TradeLineProto.GardBossVaild
---@field gardBossValid boolean @战盟boss攻击是否有效，为false的话，战盟拍卖的竞价和购买变灰

---@class TradeLineProto.Goods
---@field goodsId number 
---@field item CommonProtos.Item 
---@field publicityTime number @ 公示期时间
---@field maxUpShelfTime number @ 最大上架时长,为0代表无限制
---@field upShelfTime number @ 上架时间
---@field coinType number @ 支付货币类型
---@field unitPrice number @ 价格
---@field preorderCount number @ 商品的预购人数，初始值为0
---@field ownerId number @ 物品卖家的id,卖家是系统则为0(服务器用)
---@field auctionMinUnitPrice number @ 竞拍最低价
---@field tabType number @ 展示不同页签 0公共页签，1战盟页签
---@field unionId number @ 战盟ID
---@field activityId number @战盟活动id
---@field preorderMan number[] @预购人员
---@field bidderRid number @竞拍者id
---@field bidderMan number[] @竞拍人员

---@class TradeLineProto.MyShelvesRes
---@field shelvesCapacity number @ 货架最大容量
---@field goods TradeLineProto.Goods[] @ 寄售物品

---@class TradeLineProto.UpShelfGoodsReq
---@field itemId number 
---@field count number @ 上架数量
---@field unitPrice number @ 单价
---@field auctionMinUnitPrice number @竞拍最低单价
---@field tabType number @ 上架页签

---@class TradeLineProto.DownShelfGoodsReq
---@field goodsId number 

---@class TradeLineProto.BuyGoodsReq
---@field goodsId number @ 商品id
---@field ownerId number @ 卖家id

---@class TradeLineProto.TradeLineRecordRes
---@field tradeRecord TradeLineProto.TradeRecord[] @个人交易日志
---@field unionRecord TradeLineProto.TradeRecord[] @战盟交易日志

---@class TradeLineProto.TradeRecord
---@field itemName string @ 物品名称
---@field tradeTime number @ 交易时间
---@field tradeType number @ 交易类型 : TradeLogType
---@field totalMoney number @ 总金额
---@field coinType number @ 货币类型
---@field sourceType number @ 0 表示个人， 1表示战盟
---@field buyRoleName string @FromType == UNION， 显示购买者名字
---@field itemCfgId number @道具id
---@field itemCount number @数量
---@field inUnion number @当sourceType是战盟， 0表示公共区，1 表示本战盟内
---@field QJ5tradeType number @奇迹5交易类型

---@class TradeLineProto.AuctionGoodsReq
---@field goodsId number @ 商品id
---@field ownerId number @ 卖家id
---@field auctionUnitPrice number @出价价格

---@class TradeLineProto.TradeLineGoodsUpdateRes
---@field updateType number @ 0:更新/新增 1:删除
---@field goodsId number[] @ 删除时读这个
---@field goods TradeLineProto.Goods[] 

---@class TradeLineProto.PreOrderGoodsListRes
---@field goodsId number[] 

---@class TradeLineProto.BiddingGoodsListRes
---@field goodsId number[] 

---@class TradeLineProto.PreorderGoodsInfoReq
---@field type number @ 0 表示所有的， 1 表示玩家自身的

---@class TradeLineProto.BiddingFailRes
---@field name string 

---@class TradeLineProto.BiddingResultRes
---@field isSuc boolean 

