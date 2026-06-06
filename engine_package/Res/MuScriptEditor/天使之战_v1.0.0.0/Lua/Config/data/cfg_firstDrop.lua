-- 此文件工具自动生成，不要修改
---@class cfg_firstDrop_column
---唯一id
---
---@field id number @id column=1 A
---策划备注
---@field text string @策划备注 column=2 B
---前端文本显示
---@field muneText string @前端文本显示 column=3 C
---装备掉落计数，根据全服装备掉落次数计数判断奖励组，每次判断时均判断最高掉落计数，例如：如某装备type=3，则同时进入首爆、二爆、三爆界面
---1——首爆
---2——二爆
---3——三爆
---@field type number @掉落计数 column=4 D
---卓越词条数量检测
---@field excellenceAtt number @卓越词条数量检测 column=5 E
---幸运词条数量检测
---@field luckyAtt number @幸运词条数量检测 column=6 F
---完成目标后，玩家可以获取的奖励
---配置格式：道具id#数量&道具id#数量|道具id#数量&道具id#数量，根绝type判断，进入相同界面的装备、其奖励如果多个用&隔开，不进入相同界面的装备其奖励用|隔开
---若为空则不显示
---@field reward intListListList @奖励 column=7 G

local local_reward = {
    reward_1={{{10040001,1600}},{{10040001,960}},{{10040001,320}}},
    reward_2={{{10040001,1200}},{{10040001,720}},{{10040001,240}}},
    reward_3={{{10040001,1000}},{{10040001,600}},{{10040001,200}}},
    reward_4={{{10040001,800}},{{10040001,480}},{{10040001,160}}},
    reward_5={{{10040001,700}},{{10040001,420}},{{10040001,140}}},
    reward_6={{{10040001,500}},{{10040001,300}},{{10040001,100}}},
    reward_7={{{10040001,400}},{{10040001,240}},{{10040001,80}}},

}

local cfg_firstDrop =
{
	{id=2013052199, text="卓越的 紫焰之弓", muneText="卓越的 紫焰之弓 +幸运 +双卓越"},
	{id=1280036699, text="卓越的 天魔斗神之铠", muneText="卓越的 天魔斗神之铠 +幸运 +双卓越"},
	{id=2012092199, text="卓越的 死神之杖", muneText="卓越的 死神之杖 +幸运 +双卓越"},
	{id=207699, text="卓越的 铰刀", muneText="卓越的 铰刀 +幸运 +双卓越"},
	{id=202499, text="卓越的 暴风锯齿", muneText="卓越的 暴风锯齿 +幸运 +双卓越"},
	{id=202399, text="卓越的 傲天魔剑", muneText="卓越的 傲天魔剑 +幸运 +双卓越"},
	{id=2013102199, text="卓越的 傲视魔弓", muneText="卓越的 傲视魔弓 +幸运 +双卓越"},
	{id=2063052199, text="卓越的 紫灵之铠", muneText="卓越的 紫灵之铠 +幸运 +双卓越"},
	{id=2062092199, text="卓越的 法魂玄灵之铠", muneText="卓越的 法魂玄灵之铠 +幸运 +双卓越"},
	{id=202199, text="卓越的 魔神剑", muneText="卓越的 魔神剑 +幸运 +双卓越"},
	{id=2031072199, text="卓越的 龙骨巨晶剑", muneText="卓越的 龙骨巨晶剑 +幸运 +双卓越"},
	{id=2061092199, text="卓越的 暗黑斗神之铠", muneText="卓越的 暗黑斗神之铠 +幸运 +双卓越"},
	{id=2013072199, text="卓越的 红羽之弓", muneText="卓越的 红羽之弓 +幸运 +双卓越", reward=local_reward.reward_2},
	{id=1280035699, text="卓越的 魔神之铠", muneText="卓越的 魔神之铠 +幸运 +双卓越", reward=local_reward.reward_2},
	{id=2061072199, text="卓越的 龙炎之铠", muneText="卓越的 龙炎之铠 +幸运 +双卓越", reward=local_reward.reward_2},
	{id=2062072199, text="卓越的 黑炎之铠", muneText="卓越的 黑炎之铠 +幸运 +双卓越", reward=local_reward.reward_2},
	{id=202599, text="卓越的 烈火巨刃", muneText="卓越的 烈火巨刃 +幸运 +双卓越", reward=local_reward.reward_2},
	{id=2012082199, text="卓越的 幻月雷杖", muneText="卓越的 幻月雷杖 +幸运 +双卓越", reward=local_reward.reward_3},
	{id=2013092199, text="卓越的 碧影魔弓", muneText="卓越的 碧影魔弓 +幸运 +双卓越", reward=local_reward.reward_3},
	{id=2063072199, text="卓越的 红羽之铠", muneText="卓越的 红羽之铠 +幸运 +双卓越", reward=local_reward.reward_3},
	{id=1280035199, text="卓越的 奔雷之铠", muneText="卓越的 奔雷之铠 +幸运 +双卓越", reward=local_reward.reward_3},
	{id=1280025199, text="卓越的 烈火之铠", muneText="卓越的 烈火之铠 +幸运 +双卓越", reward=local_reward.reward_3},
	{id=203199, text="卓越的 天雷剑", muneText="卓越的 天雷剑 +幸运 +双卓越", reward=local_reward.reward_3},
	{id=201899, text="卓越的 奔雷剑", muneText="卓越的 奔雷剑 +幸运 +双卓越", reward=local_reward.reward_3},
	{id=201799, text="卓越的 屠龙刀", muneText="卓越的 屠龙刀 +幸运 +双卓越", reward=local_reward.reward_3},
	{id=209799, text="卓越的 追月神弩", muneText="卓越的 追月神弩 +幸运 +双卓越", reward=local_reward.reward_4},
	{id=2012062199, text="卓越的 麒麟之杖", muneText="卓越的 麒麟之杖 +幸运 +双卓越", reward=local_reward.reward_4},
	{id=2061062199, text="卓越的 黑凤凰之铠", muneText="卓越的 黑凤凰之铠 +幸运 +双卓越", reward=local_reward.reward_4},
	{id=2031062199, text="卓越的 断月之光", muneText="卓越的 断月之光 +幸运 +双卓越", reward=local_reward.reward_4},
	{id=2063062199, text="卓越的 圣灵之铠", muneText="卓越的 圣灵之铠 +幸运 +双卓越", reward=local_reward.reward_5},
	{id=2013062199, text="卓越的 圣灵之弓", muneText="卓越的 圣灵之弓 +幸运 +双卓越", reward=local_reward.reward_5},
	{id=207599, text="卓越的 青龙刀", muneText="卓越的 青龙刀 +幸运 +双卓越", reward=local_reward.reward_5},
	{id=2062062199, text="卓越的 火麒麟之铠", muneText="卓越的 火麒麟之铠 +幸运 +双卓越", reward=local_reward.reward_5},
	{id=211999, text="卓越的 毁灭之杖", muneText="卓越的 毁灭之杖 +幸运 +双卓越", reward=local_reward.reward_5},
	{id=209499, text="卓越的 圣者之弩", muneText="卓越的 圣者之弩 +幸运 +双卓越", reward=local_reward.reward_5},
	{id=2031052199, text="卓越的 破坏之剑", muneText="卓越的 破坏之剑 +幸运 +双卓越", reward=local_reward.reward_5},
	{id=1280034199, text="卓越的 亚特兰蒂斯之铠", muneText="卓越的 亚特兰蒂斯之铠 +幸运 +双卓越", reward=local_reward.reward_5},
	{id=2062052199, text="卓越的 幻月之铠", muneText="卓越的 幻月之铠 +幸运 +双卓越", reward=local_reward.reward_5},
	{id=226599, text="卓越的 碧影之铠", muneText="卓越的 碧影之铠 +幸运 +双卓越", reward=local_reward.reward_5},
	{id=204999, text="卓越的 玄冰剑", muneText="卓越的 玄冰剑 +幸运 +双卓越", reward=local_reward.reward_6},
	{id=209299, text="卓越的 温蒂妮", muneText="卓越的 温蒂妮 +幸运 +双卓越", reward=local_reward.reward_6},
	{id=2012052199, text="卓越的 复活之杖", muneText="卓越的 复活之杖 +幸运 +双卓越", reward=local_reward.reward_6},
	{id=209199, text="卓越的 蓝翎弩", muneText="卓越的 蓝翎弩 +幸运 +双卓越", reward=local_reward.reward_6},
	{id=204899, text="卓越的 水晶流星", muneText="卓越的 水晶流星 +幸运 +双卓越", reward=local_reward.reward_6},
	{id=207499, text="卓越的 死神镰刀", muneText="卓越的 死神镰刀 +幸运 +双卓越", reward=local_reward.reward_6},
	{id=2061042199, text="卓越的 龙王之铠", muneText="卓越的 龙王之铠 +幸运 +双卓越", reward=local_reward.reward_7},
	{id=2031042199, text="卓越的 雷神之剑", muneText="卓越的 雷神之剑 +幸运 +双卓越", reward=local_reward.reward_7},
	{id=2012042199, text="卓越的 传说之杖", muneText="卓越的 传说之杖 +幸运 +双卓越", reward=local_reward.reward_7},
	{id=2063042199, text="卓越的 女神之铠", muneText="卓越的 女神之铠 +幸运 +双卓越", reward=local_reward.reward_7},
	{id=2013042199, text="卓越的 银翼之弓", muneText="卓越的 银翼之弓 +幸运 +双卓越", reward=local_reward.reward_7},
	{id=201299, text="卓越的 太阳之剑", muneText="卓越的 太阳之剑 +幸运 +双卓越", reward=local_reward.reward_7},
	{id=2062042199, text="卓越的 传说之铠", muneText="卓越的 传说之铠 +幸运 +双卓越", reward=local_reward.reward_7},
	{id=215799, text="卓越的 布朗司", muneText="卓越的 布朗司 +幸运 +双卓越", reward=local_reward.reward_7},
	{id=2031032199, text="卓越的 真红之剑", muneText="卓越的 真红之剑 +幸运 +双卓越", reward=local_reward.reward_7},
}

local defaults = {type=3, excellenceAtt=2, luckyAtt=1, reward={{{10040001,1600}},{{10040001,960}},{{10040001,320}}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_firstDrop) do
	setmetatable(v, mt)
end

return cfg_firstDrop