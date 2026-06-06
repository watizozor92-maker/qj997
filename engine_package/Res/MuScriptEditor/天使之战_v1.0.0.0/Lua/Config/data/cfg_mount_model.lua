-- 此文件工具自动生成，不要修改
---@class cfg_mount_model_column
---@field id number @point column=1 A
---@field name string @模型名称 column=2 B
---1：两足怪-独角
---2：两足怪-彩云
---3：四足怪-爬行
---4：四足怪-马
---5：其他
---@field bone string @模型骨骼 column=3 C
---坐骑模型资源路径
---@field path string @模型路径 column=4 D
---填写骨骼名称
---@field hang string @骑乘挂点 column=5 E
---填写cfg_audio表对应的音效id
---空为不播放
---@field walkSound number @移动音效 column=6 F
---填写cfg_audio表对应的音效id
---空为不播放
---@field runSound number @快速移动音效 column=7 G
---填写cfg_audio表对应的音效id
---空为不播放
---@field trackSound number @移动追踪音效 column=8 H
---填写cfg_audio表对应的音效id
---空为不播放
---@field fastTrack number @快速追踪音效 column=9 I
local cfg_mount_model =
{
	{id=1, name="兽角", bone="1", path="Model/Mount/Rider01", hang="Bip01"},
	{id=2, name="彩云兽", bone="2", path="Model/Mount/Rider02"},
	{id=3, path="Model/Mount/Fenrilred"},
	{id=4, name="蓝狼", path="Model/Mount/Fenrilblue_03"},
	{id=5, name="黑狼", path="Model/Mount/Fenrilblack_03"},
	{id=6, name="金狼", path="Model/Mount/Fenrilgold_03"},
	{id=7, name="黑王马", bone="4", path="Model/Mount/DarkHorse"},
	{id=8, name="幽灵马", bone="4", path="Model/Mount/DarkHorse_02"},
	{id=9, name="黄金马", bone="4", path="Model/Mount/DarkHorse_03"},
	{id=10, name="白焰马", bone="4", path="Model/Mount/DarkHorse_03"},
	{id=11, name="西方龙", bone="5", path="Model/Mount/Xifanglong", hang="Bip001 Spine1"},
	{id=12, name="白虎", path="Model/Mount/Baihu_05", hang="Bip001 Spine1"},
	{id=13, name="熊猫", path="Model/Mount/Panda", hang="Bip01 Spine"},
	{id=14, name="星冥龙", bone="5", path="Model/Mount/51Long_04", hang="Bip001 Spine"},
	{id=15, name="雪鹿", bone="1", path="Model/Mount/Xianlu", hang="Bip001 Spine1"},
	{id=16, name="白毛狮王", path="Model/Mount/Shiwang", hang="Bip001 Spine1"},
	{id=17, name="冥焰马", bone="4", path="Model/Mount/Lanma"},
	{id=18, name="草泥马", path="Model/Mount/Conima02", hang="Bip001 Spine1"},
	{id=19, name="大蝎子", path="Model/Mount/HeisemoxieRed_02", hang="Bip001 Spine"},
	{id=20, name="黄金天马", path="Model/Mount/Tianma_221614", hang="Bip001 Spine1"},
	{id=21, name="狮鹫", path="Model/Mount/Chengseshijiu_01", hang="Bip001 Spine1"},
	{id=22, name="水乌龟", path="Model/Mount/Xuangui_02", hang="Bip001 Spine"},
	{id=23, name="午夜", path="Model/Mount/DarkHorse"},
	{id=24, name="绿林狂蝎", path="Model/Mount/Kuangxie_01", hang="Bip001 Spine"},
	{id=25, name="冻土冰狼", path="Model/Mount/Binglang", hang="Bip001 Spine"},
	{id=26, name="星穹泽风", bone="4", path="Model/Monster/Tianma_luo", hang="Bip001 Spine1"},
	{id=27, name="灵珀蜗天", bone="5", path="Model/Monster/Woniumanman", hang="Bone001"},
	{id=28, name="碧霄瑶光", bone="5", path="Model/Monster/Jinyu", hang="Bone002"},
	{id=29, path="Model/Mount/Fenrilred_02"},
	{id=30, path="Model/Mount/Fenrilred_03"},
	{id=31, path="Model/Mount/Fenrilred"},
}

local defaults = {name="红狼", bone="3", hang="Bip01 Spine1", walkSound=20, runSound=21, trackSound=20, fastTrack=21}
local mt = {__index = defaults}
for _, v in ipairs(cfg_mount_model) do
	setmetatable(v, mt)
end

return cfg_mount_model