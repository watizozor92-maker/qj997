--工具自动生成
---@class DupChoiceRoadProtos.ChoiceRoadPlane
---@field actId number 
---@field leftCount number @剩余次数
---@field currentLevelId number @当前层级
---@field vipUseTimes number @使用VIP添加次数
---@field rank DupChoiceRoadProtos.ChoiceRoadRank 
---@field flag number 

---@class DupChoiceRoadProtos.ChoiceRoadRank
---@field rid number 
---@field myRank number @我的排名
---@field myScore number @我的积分
---@field rankId number @排行表配置id
---@field totalNum number @一共参与了多少人
---@field rank DupChoiceRoadProtos.OthersRank[] @ 只发送显示展示名称区间

---@class DupChoiceRoadProtos.OthersRank
---@field rid number 
---@field rank number @排名
---@field name string @名字
---@field score number @积分
---@field career number @跟职业
---@field rankId number @rank表Id

---@class DupChoiceRoadProtos.ChallengeChoiceRoad
---@field actId number @活动ID
---@field dupLevelId number @挑战等级ID

---@class DupChoiceRoadProtos.ChoiceRoadLevelInfoReq
---@field actId number 
---@field dupLevelId number 

---@class DupChoiceRoadProtos.ChoiceRoadLevelInfoRes
---@field dupLevelId number 
---@field monsterId number 
---@field buffId number 

---@class DupChoiceRoadProtos.ChoiceRoadResult
---@field dupLevelId number 
---@field result boolean 
---@field quitTime number 
---@field item CommonProtos.Item[] 

---@class DupChoiceRoadProtos.ChoiceRoadOpenPlaneReq
---@field flag number 

---@class DupChoiceRoadProtos.ChoiceRoadByTimes
---@field actId number 
---@field leftCount number 
---@field vipUseTimes number 

