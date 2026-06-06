--工具自动生成
---@class StoreProto.StoreInfoRes
---@field maxGridCount number @格子数量
---@field sumLockGridCount string 
---@field itemList BagProtos.BagItem[] 
---@field maxPage number @目前可使用的最大页数

---@class StoreProto.storeToBagReq
---@field storeIndex number 
---@field BagIndex number 

---@class StoreProto.StoreTakeButtonReq
---@field storeIndex number 

---@class StoreProto.BagToStoreReq
---@field BagIndex number 
---@field storeIndex number 

---@class StoreProto.BagPutStoreButtonReq
---@field BagIndex number 
---@field StorePage number @仓库页码

---@class StoreProto.StoreChangeRes
---@field sumLockGridCount number 
---@field itemList BagProtos.BagItem[] 

---@class StoreProto.TidyStoreItemReq
---@field storePage number 

---@class StoreProto.SwapStoreItemReq
---@field fromIndex number 
---@field toIndex number 

---@class StoreProto.SwapStoreItemRes
---@field fromIndex number 
---@field toIndex number 

---@class StoreProto.LockStoreGridRes
---@field lockCount string @锁格子数量
---@field maxPage number @当前仓库的最大页数

---@class StoreProto.StoreGiveUpItemReq
---@field index number @仓库索引

---@class StoreProto.StoreAddCapacityReq
---@field useItem number @是否使用道具
---@field curStorePage number @当前仓库页码

---@class StoreProto.StoreAddPageReq
---@field useItem number @是否使用道具

---@class StoreProto.TidyStoreItemRes
---@field itemList BagProtos.BagItem[] @仓库道具列表

