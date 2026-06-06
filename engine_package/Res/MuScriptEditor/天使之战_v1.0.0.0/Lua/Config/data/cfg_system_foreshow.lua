-- 此文件工具自动生成，不要修改
---@class cfg_system_foreshow_column
---唯一id
---@field id number @id column=1 A
---策划备注
---[[客户端不使用]]@field remark string @ column=2 B
---填写界面名称
---@field screenName string @界面名称 column=3 C
---角色到达该等级后开启
---填0表示该不开启
---@field needLevel number @开启等级 column=4 D
---角色到达该等级后关闭
---不填表示无此限制
---@field offLevel number @关闭等级 column=5 E
---开服天数到达后开启
---填0表示该不开启
---@field needDay number @开服天数 column=6 F
---玩家在线将任务完成领取奖励时触发
---填写任务表id，配置多个任务时，满足其中一个就弹出
---格式：任务id#任务id
---不填表示无此限制
---@field needTask IntList @触发任务 column=7 G
---关闭时间格式为：开服天数
---例：9(该天0点关闭）
---@field endTime number @关闭时间 column=8 H
---格式：按钮序号#跳转指令|按钮序号#跳转指令
---跳转指令调用快捷指令格式
---@field btnSkip StringListList @按钮跳转 column=9 I
---角色到达该等级后开启
---格式：按钮序号#等级|按钮序号#等级
---填0表示该不开启
---@field btnNeedLevel IntListList @按钮开启等级 column=10 J
---开服天数到达后开启
---格式：按钮序号#开服天数|按钮序号#开服天数
---填0表示该不开启
---@field btnNeedDay IntListList @按钮开服天数 column=11 K
---按未开启时文本显示
---按钮序号#文本内容|按钮序号#文本内容
---填空则不显示
---@field btnText StringListList @按钮未开启文本 column=12 L
local cfg_system_foreshow =
{
	{id=101, screenName="dev/outui/CardShapeShift/Panel/KLCardShapeShift/KLCardShapeShiftPanel", needLevel=0, offLevel=100, needDay=1, endTime=8, btnText={{"1","野外战斗体验超级连击"}}},
	{id=102, screenName="dev/outui/CardShapeShift/Panel/KLCardShapeShift/KLCardShapeShiftPanel", needLevel=0, offLevel=0, needDay=2, needTask={210037}, endTime=7, btnSkip={{"1","openUIPanel","dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel","1","monsterType=1"},{"2","openUIPanel","dev/outui/ShapeShiftCard/Panel/KLShapeShiftCardMain/KLShapeShiftCardMainPanel","3"}}, btnNeedLevel={{1,10},{2,150}}, btnNeedDay={{1,3},{2,3}}},
	{id=103, screenName="dev/outui/CardShapeShift/Panel/KLCardShapeArchangel/KLCardShapeArchangelPanel", needLevel=0, offLevel=100, needDay=1, needTask={10093,20093,30093}, endTime=15, btnSkip={{"1","openUIPanel","dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel"}}, btnNeedLevel={}, btnNeedDay={}, btnText={}},
}

local defaults = {needTask={10001,20001,30001}, btnSkip={{"1","openUIPanel","dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel","1","monsterType=1"},{"2","openUIPanel","dev/outui/DragonSoulCombo/Panel/KLDragonSoulCombo/KLDragonSoulComboPanel","1"}}, btnNeedLevel={{1,10},{2,1}}, btnNeedDay={{1,1},{2,1}}, btnText={{"1","等级达到10级开启"},{"2","等级达到150级且开服第3天开启"}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_system_foreshow) do
	setmetatable(v, mt)
end

return cfg_system_foreshow