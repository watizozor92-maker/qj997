---@class AppearInfoTest
AppearInfoTest = class()
local this = AppearInfoTest

---@type table<EEquipSlotType,number>
local serverAppear = {}

---变身戒指缓存，在变身卡牌结束后再切回变身戒指变身
---@type table<number,number>
local cacheMonsterId = {}