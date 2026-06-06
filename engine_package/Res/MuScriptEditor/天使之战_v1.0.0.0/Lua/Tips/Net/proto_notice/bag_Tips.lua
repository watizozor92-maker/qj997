--工具自动生成
---@class BagProtos.BagItem
---@field index number @背包格子索引
---@field item CommonProtos.Item 

---@class BagProtos.BagInfoRes
---@field maxGridCount number @格子数量
---@field sumLockGridCount number @锁的格子总数量
---@field itemList BagProtos.BagItem[] 
---@field weight number @负重
---@field coinList BagProtos.CoinInfo[] @货币列表

---@class BagProtos.BagExpansionRes
---@field maxGridCount number @格子数量

---@class BagProtos.SwapItemReq
---@field toIndex number 
---@field fromIndex number 

---@class BagProtos.SwapItemRes
---@field toIndex number 
---@field fromIndex number 

---@class BagProtos.GiveUpItemReq
---@field index number 

---@class BagProtos.UseItemReq
---@field useItem BagProtos.UseItem[] 

---@class BagProtos.UseItem
---@field index number @格子ID
---@field count number @使用数量

---@class BagProtos.CoinInfo
---@field itemId number @货币ID
---@field count number @货币数量

---@class BagProtos.BagChangeRes
---@field emptyGridCount number 
---@field itemList BagProtos.BagItem[] 
---@field coinList BagProtos.CoinInfo[] @货币列表

---@class BagProtos.TidyItemReq

---@class BagProtos.TidyItemRes
---@field itemList BagProtos.BagItem[] 

---@class BagProtos.DestroyItemReq
---@field index number 

---@class BagProtos.SynthesisItemReq
---@field id number @合成公式表ID
---@field count number @合成的数量
---@field bagIndexs number[] @辅助材料
---@field specialIdx number[] @特殊材料

---@class BagProtos.SynthesisItemRes
---@field id number @合成公式表ID
---@field item CommonProtos.Item[] 

---@class BagProtos.RecoveryItemReq
---@field recoveryInfo BagProtos.RecoveryInfo[] @回收道具信息

---@class BagProtos.RecoveryInfo
---@field idxOfBags number @道具索引
---@field count number @道具数量

---@class BagProtos.RecoveryItemRes
---@field itemList CommonProtos.Item[] @回收获得的道具

---@class BagProtos.ResolveItemReq
---@field idxOfBags number[] @道具索引

---@class BagProtos.ResolveItemRes
---@field itemList CommonProtos.Item[] @分解获得的道具

---@class BagProtos.LockBagGridRes
---@field lockCount number @锁格子数量

---@class BagProtos.ReceiveItemRes
---@field itemList CommonProtos.Item[] @领取道具

---@class BagProtos.UseFruitReq
---@field cfgId number @item表id
---@field count number @使用数量

---@class BagProtos.ResetFruitPointReq
---@field fruitAttrPoint BagProtos.FruitAttrPoint[] @果实属性点数

---@class BagProtos.FruitAttrPoint
---@field type number @果实属性类型
---@field point number @点数

---@class BagProtos.OpenFruitResetPageRes
---@field resetCount number @重置次数

---@class BagProtos.JudgeUseItem
---@field materialIndex number @使用材料Index
---@field theTargetIndex number @目标物品Index

---@class BagProtos.JudgeUseItemRes
---@field materialIndex number @使用材料Index
---@field theTargetIndex number @目标物品Index
---@field canUse boolean 

---@class BagProtos.UseItemGM
---@field materialIndex number @使用材料Index
---@field theTargetIndex number @目标物品Index

---@class BagProtos.UseTransferItemReq
---@field cfgId number 
---@field x number 
---@field y number 

---@class BagProtos.QuickBuyReq
---@field coinId number @购买所使用的货币cfgId
---@field count number @购买所需要的货币的数量
---@field cfgId number @所购买物品的cfgId

---@class BagProtos.ReqSelfChoiceBox
---@field boxIndex number @使用的宝箱ID
---@field info BagProtos.SelfChoiceBoxInfo[] @自选道具

---@class BagProtos.SelfChoiceBoxInfo
---@field itemId number @道具ID
---@field count number @道具数量

---@class BagProtos.OpenBoxStrategy
---@field items BagProtos.OpenItems[] 

---@class BagProtos.OpenItems
---@field boxId number 
---@field item CommonProtos.Item[] 

---@class BagProtos.BagAddCapacityReq
---@field useItem number @是否使用道具

---@class BagProtos.ResAutoPickupInfo
---@field rid number @角色id
---@field speed string 
---@field itemId number[] @道具id

---@class BagProtos.ReqAutoPickUpRangeItems
---@field autoPick string 

