-- 此文件工具自动生成，不要修改
---@class cfg_wolf_soul_column
---@field id number @id column=1 A
---@field name string @活动名称 column=2 B
---@field repId number @副本ID column=3 C
---根据服务器开服天数，开启进入不同得副本ID。格式：开服最小天数|开服最大天数
---开服最大天数=0时，代表这个区间是以上都是。
---@field numberDay IntList @服务器天数 column=4 D
---参考monster表id
---@field platformID number @神狼雕像怪物ID column=5 E
---坐标X#坐标Y#面向角度
---@field platformPosition IntList @神狼雕像位置 column=6 F
---关联战盟职位表
---@field post IntList @守护召唤资格 column=7 G
---可以召唤得守护找最大数量
---@field guardians number @守护者数量 column=8 H
---坐标X#坐标Y#面向角度
---有几个配几个，|分隔
---召唤顺序按照配置顺序一次摆放
---@field guardiansPosition IntListList @守护者初始位置 column=9 I
---守护者类型及对应支付的货币及数量
---守护者关联monster表ID，
---货币关联item表
---格式：类型#货币#数量|类型#货币#数量
---@field guardiansType IntListList @守护者类型 column=10 J
---普通的没说明，精英|传说|传说。
---@field text StringListList @守护者说明 column=11 K
---最多可获取的卡片的数量
---@field maxBuff number @最大卡片数量 column=12 L
---每次重置，最多能选择卡片的数量
---@field randomBuff number @重置卡片的数量 column=13 M
---每次刷新卡片时消耗道具及数量
---@field rebornTime IntList @卡片消耗 column=14 N
---进入副本后，卡片等级刷新的初始权重
---格式：卡片等级#权重|卡片等级#权重|卡片等级#权重
---@field buff IntListList @卡片刷新权重 column=15 O
---第X波~Y波，卡片发生权重变化。
---格式:X1#Y1|X2Y2
---@field buffWeight IntListList @卡片权重变动波次区间 column=16 P
---与区间一一对应
---数据内容为 区间内，每进入下一波次发生变化的卡片等级
---格式：卡片等级#卡片等级#卡片等级|卡片等级#卡片等级#卡片等级
---@field buffWeightLevel IntListList @波次区间内变动等级 column=17 Q
---与变动等级一一对应
---数据内容为，区间内，每进入下一波次 发生变化的卡片权重是增加还是减少。
---1=增加
---2=减少
---@field buffWeightChange IntListList @波次区间内变动增减 column=18 R
---与变动等级一一对应
---数据内容为，区间内，每进入下一波次 发生变化的卡片权重变化的数值
---@field buffWeightNum IntListList @波次区间内增减的数值 column=19 S
---怪物ID#点数
---|分隔
---击杀对应怪物获得的奖励点数
---@field killPoint IntListList @击杀积分 column=20 T
---守护成功的奖励，根据名次，获得奖励
---格式：名次上限#名次上限#道具id#道具数量#道具id#道具数量|
---道具id引用cfg_item表id
---@field victoryReward IntListList @活动胜利奖励 column=21 U
---守护失败的奖励，根据名次，获得奖励
---格式：名次上限#名次上限#道具id#道具数量#道具id#道具数量|
---道具id引用cfg_item表id
---@field defeatReward IntListList @活动失败奖励 column=22 V
local cfg_wolf_soul =
{
	{id=15001, name="狼魂要塞", repId=15001, numberDay={1,9999}, platformID=17016, post={1,2}, guardians=5, maxBuff=3, randomBuff=3, rebornTime={10005000,1}, killPoint={}, victoryReward={}, defeatReward={}},
}

local defaults = {platformPosition={120,32,0}, guardiansPosition={{115,35,0},{120,38,0},{125,27,0},{126,35,0},{117,27,0}}, guardiansType={{15001051,10100001,1000},{15001052,10100001,3000},{15001053,10100001,5000}}, text={{"最多可同时攻击3个单位"},{"最多可同时攻击5个单位","额外造成5%生命上限伤害"}}, buff={{1,100},{2,0},{3,0},{4,0},{5,0}}, buffWeight={{1,3},{4,6},{7,10},{11,15},{16,20}}, buffWeightLevel={{1,2,3},{1,2,3},{1,4},{1,2,3,4,5},{2,3,4,5}}, buffWeightChange={{2,1,1},{2,1,1},{2,1},{2,2,2,1,1},{2,2,1,1}}, buffWeightNum={{15,10,5},{10,5,5},{5,5},{4,6,4,2,4},{1,7,2,6}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_wolf_soul) do
	setmetatable(v, mt)
end

return cfg_wolf_soul