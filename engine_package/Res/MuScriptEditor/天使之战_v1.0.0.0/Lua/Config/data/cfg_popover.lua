-- 此文件工具自动生成，不要修改
---@class cfg_popover_column
---气泡提示ID
---@field id number @id column=1 A
---策划自用
---@field description string @备注 column=2 B
---@field name string @名称 column=3 C
---气泡提示图标
---资源文件名
---@field icon string @icon column=4 D
---0或空=已读消失
---1=已读不消失
---@field disappeartype number @气泡是否已读消失 column=5 E
---0或空=开启显示
---1=关闭显示
---@field switch number @气泡显示开关按钮 column=6 F
local cfg_popover =
{
	{id=1, description="效率", name="efficiency", icon="xiaolv"},
	{id=2, description="拍卖", name="auction", icon="qp_jiaoyihang"},
	{id=3, description="邮件", name="mail", icon="qp_youjian", switch=0},
	{id=4, description="感谢信", name="testimonial", icon="ganxiexin"},
	{id=5, description="勇者试炼", name="brave_trials", icon="yongzheshilian"},
	{id=6, description="伙伴孵化", name="partner_incubation"},
	{id=7, description="伙伴派遣", name="partner_dispatch"},
	{id=8, description="时装", name="fashion"},
	{id=9, description="属性", name="attribute", icon="qp_jineng"},
	{id=10, description="协助", name="assist"},
	{id=11, description="装备替换", name="equipment_replacement"},
	{id=12, description="背包", name="inventory", icon="qp_beibao", disappeartype=1, switch=0},
	{id=13, description="伙伴派遣可领任务", name="partner_dispatch"},
	{id=14, description="活动（活动结束时汽包也会消失）", name="activity", icon="qp_xuesechengbao"},
	{id=15, description="进队申请", name="joinTeam", icon="qp_jinduishenqing", switch=0},
	{id=16, description="战盟申请", name="unionAdd", icon="qp_jinduishenqing"},
	{id=17, description="战盟拍卖", name="group_auction", icon="qp_jiaoyihang"},
	{id=18, description="组队邀请", name="maketeam", icon="qp_zuduiyaoqing", switch=0},
	{id=19, description="好友", name="friends", icon="qp_haoyou", switch=0},
	{id=20, description="月卡", name="MonthCard", icon="qp_yueka"},
	{id=21, description="黄金特权", name="goldprivilege", icon="qp_gold", disappeartype=1},
	{id=22, description="钻石特权", name="diamondprivilege", icon="qp_diamond", disappeartype=1},
	{id=23, description="额度档位", name="lines", icon="qp_yueka", disappeartype=1},
	{id=24, description="修理", name="repair", icon="qp_weixiu", disappeartype=1, switch=0},
	{id=25, description="面对面交易", name="tradeFaceToFace", icon="qp_jiaoyihang", disappeartype=0, switch=0},
	{id=26, description="BUFF消失", name="buffdisappear", icon="qp_buff", disappeartype=0},
	{id=27, description="好友添加", name="friendsAdd", icon="qp_haoyou", switch=0},
}

local defaults = {icon="common", disappeartype=0, switch=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_popover) do
	setmetatable(v, mt)
end

return cfg_popover