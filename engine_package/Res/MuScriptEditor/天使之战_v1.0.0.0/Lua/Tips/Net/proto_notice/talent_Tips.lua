--工具自动生成
---@class TalentProtos.TalentInfoReq

---@class TalentProtos.TalentInfoResp
---@field talentPoints number @天赋点数
---@field talentItemList TalentProtos.TalentItem[] @这个是全量的.
---@field exchangedExpTimes number @已经兑换经验的次数,当天.

---@class TalentProtos.TalentInfoUpdateSyn
---@field talentPoints number @天赋点数.
---@field talentItemList TalentProtos.TalentItem[] @天赋列表，变化部分.
---@field exchangedExpTimes number @兑换经验的次数.
---@field op number @操作来源.

---@class TalentProtos.TalentItem
---@field talentId number @天赋id
---@field level number @可能会为0.
---@field state number @天赋状态.

---@class TalentProtos.TalentExpExchangeReq
---@field exchangeId number @兑换id
---@field exhcageNum number @兑换次数.

---@class TalentProtos.TalentUpgradeReq
---@field talentId number @天赋学习.

---@class TalentProtos.TalentResetReq

