--工具自动生成
---@class TradeProto.TradeReq
---@field roleId number @玩家ID

---@class TradeProto.TradeRes
---@field roleId number @玩家ID
---@field name string @玩家名
---@field endTime number @倒计时结束时间戳

---@class TradeProto.AgreeTradeReq
---@field roleId number @玩家ID
---@field agree number @ 0.拒绝1.同意 

---@class TradeProto.SetTradeProgressReq
---@field operation number @锁定，1锁定，2取消锁定，3确认交易，4取消交易

---@class TradeProto.TradeStateChangeRes
---@field roleId number 
---@field state number @状态，1交易成功状态，2交易取消状态

---@class TradeProto.TradePartyInfo
---@field roleId number 
---@field name string 
---@field items CommonProtos.Item[] 
---@field locked number @是否锁定 1是 0 否
---@field submit number @确认交易 1是 0 否
---@field maxCount number @最大交易数量

---@class TradeProto.TradeInfo
---@field parties TradeProto.TradePartyInfo[] 

---@class TradeProto.AddItemToTradeReq
---@field bagIndex number 
---@field count number 

---@class TradeProto.RemoveItemFromTradeReq
---@field lid number 

---@class TradeProto.TradeGoodInfoRes
---@field items CommonProtos.Item[] 

