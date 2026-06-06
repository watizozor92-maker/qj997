--工具自动生成
---@class PartnerLayProto.DispatchPartnerInfo
---@field pos number @占据位置从0开始
---@field partnerCfgId number @伙伴配置表id
---@field partnerId number @ 伙伴id

---@class PartnerLayProto.PartnerDispatchTaskInfoVo
---@field taskCfgId number @任务配置
---@field partners PartnerLayProto.DispatchPartnerInfo[] @伙伴
---@field state number @任务状态：【0 新建】， 【1 已接受】，【2 开始工作】
---@field startMills number @开始时间
---@field offsetSeconds number @已抵消时间【秒】
---@field canReward boolean @是否可领奖

---@class PartnerLayProto.PartnerDispatchTaskVo
---@field index number @索引
---@field task PartnerLayProto.PartnerDispatchTaskInfoVo 

---@class PartnerLayProto.PartnerDispatchChangeRes
---@field tasks PartnerLayProto.PartnerDispatchTaskVo[] 

---@class PartnerLayProto.PartnerDispatchFlushReq
---@field autoBuy boolean @自动购买

---@class PartnerLayProto.PartnerDispatchAcceptReq
---@field taskId number 

---@class PartnerLayProto.PartnerDispatchUpSpeedReq
---@field taskId number 

---@class PartnerLayProto.PartnerDispatchStartInfo
---@field pos number @占据位置0
---@field partnerId number @伙伴id

---@class PartnerLayProto.PartnerDispatchStartReq
---@field taskId number 
---@field infos PartnerLayProto.PartnerDispatchStartInfo[] 

---@class PartnerLayProto.PartnerDispatchRewardReq
---@field taskId number 

---@class PartnerLayProto.PartnerDispatchRewardRes
---@field taskId number 
---@field partnerId number[] @ 返还伙伴

---@class PartnerLayProto.PartnerDispatchResultRes
---@field success boolean 

---@class PartnerLayProto.DispatchFlushVipFreeCountRes
---@field flushCount number @每日vip已使用免费次数

