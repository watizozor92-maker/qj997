--工具自动生成
---@class BoxStallProto.BoxStallServerReq
---@field type number @交易行大类型  0、角色截图类型；1、角色类型；2、道具类型；4、货币类型
---@field jsonData string @转发至盒子交易行服务器的json串

---@class BoxStallProto.BoxStallRuleRes
---@field switchState number @交易行开关状态 0:关闭 1:开启
---@field maxStallCount number @单角色交易行最大上架数量
---@field feesRate number @交易行手续费比例(万分比,如设置费率10%则该值为1000)
---@field jsonRule string @盒子交易行具体上架规则json串

---@class BoxStallProto.BoxStallInfoRes
---@field jsonData string @盒子交易行服务器转发的json串

