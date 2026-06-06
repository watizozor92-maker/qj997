--工具自动生成
---@class MailProto.MailInfo
---@field mailId number 
---@field title string @标题
---@field content string @内容
---@field from string @发件人
---@field sendTime number @发件时间戳
---@field items CommonProtos.Item[] @附件内容
---@field state number @0未读 1已读 2已提取物品
---@field overdueTime number @截止时间戳
---@field tradeMailType number @九九交易行邮件类型  0：直接发货，1：确认收货邮件发送  2：拒绝收货  3：更改状态确认收货
---@field tradeOtherInfo string @九九交易行转发信息 json 格式 other:{"orderId":1,"operationcode":"AgFs3e5K2"

---@class MailProto.MailList
---@field mails MailProto.MailInfo[] 

---@class MailProto.MailIdMsg
---@field mailIds number[] 

---@class MailProto.MsgRemind
---@field type number @ 1：邮件 2：社交

---@class MailProto.MailChangeRes
---@field record MailProto.MailRecord[] 

---@class MailProto.MailRecord
---@field mailId number @邮件ID，
---@field info MailProto.MailInfo @邮件改变内容，为空则需要删除

