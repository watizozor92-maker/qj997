--工具自动生成
---@class TitleProto.TitleInfo
---@field confId number @策划表id
---@field isEquip number @是否装备, 0:未装备 1:装备
---@field timeType number @ 0：永久 1：截止到某一时刻 2：剩余时间
---@field time number @ 根据上述值表示(毫秒数)
---@field dynamic number @ 0：静态的 1：动态的
---@field showName string @ (静态称号客户端读取配置表,动态称号客户端读取服务器传来的此值)

---@class TitleProto.TitleInfo2
---@field confId number @策划表id
---@field isEquip number @是否装备, 0:未装备 1:装备
---@field gotTime number 
---@field lv number @称号等级

---@class TitleProto.TitleList
---@field titleInfos TitleProto.TitleInfo[] 

---@class TitleProto.TitleList2
---@field titleInfos TitleProto.TitleInfo2[] 
---@field hidden TitleProto.Hidden @是否隐藏称号外观

---@class TitleProto.Hidden
---@field hidden boolean @是否隐藏称号外观

---@class TitleProto.TitleId
---@field titleId number 

---@class TitleProto.EquipTitleReq
---@field titleId number 
---@field putOn boolean @表示穿上

