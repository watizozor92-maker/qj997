-- 此文件工具自动生成，不要修改
---@class cfg_FashionGuide_column
---时装图鉴界面id
---@field id number @id column=1 A
---套装名称
---@field name string @套装名称 column=2 B
---索引Cfg_wearing_bar表
---@field wearing number @穿戴栏id column=3 C
---穿戴时装需要的职业，索引cfg_career的baseCareer字段
---@field career number @职业 column=4 D
---一套时装的部件总数
---@field quantity number @时装总数 column=5 E
---时装的道具id，索引cfg_item
---@field fashionId IntList @时装 column=6 F
---套装图标，配置文件名称
---@field icon string @套装图标 column=7 G

local local_fashionId = {
    fashionId_1={20301051,20401051,20601051,20801051,20701051,20901051},
    fashionId_2={21010301,21040301,21060301,21070301,21080301,21090301},
    fashionId_3={21010201,21040201,21060201,21070201,21080201,21090201},
    fashionId_4={21010101,21040101,21060101,21070101,21080101,21090101},

}

local cfg_FashionGuide =
{
	{id=1},
	{id=2, name="霜魄之凝殇", wearing=6, fashionId=local_fashionId.fashionId_2, icon="bszyd"},
	{id=3, name="星墟之耀芒", wearing=5, fashionId=local_fashionId.fashionId_3, icon="cyzxx"},
	{id=4, name="星穹撕裂者", wearing=4, fashionId=local_fashionId.fashionId_4, icon="skyqz"},
	{id=5, career=2, quantity=7},
	{id=6, name="霜魄之凝殇", wearing=6, career=2, quantity=7, fashionId={21010302,21020302,21040302,21060302,21070302,21080302,21090302}, icon="bszyd"},
	{id=7, name="星墟之耀芒", wearing=5, career=2, quantity=7, fashionId={21010202,21020202,21040202,21060202,21070202,21080202,21090202}, icon="cyzxx"},
	{id=8, name="星穹撕裂者", wearing=4, career=2, quantity=7, fashionId={21010102,21020102,21040102,21060102,21070102,21080102,21090102}, icon="skyqz"},
	{id=9, career=3, quantity=7, fashionId={20103051,20203051,20403051,20603051,20803051,20703051,20903051}},
	{id=10, name="霜魄之凝殇", wearing=6, career=3, quantity=7, fashionId={21010303,21020301,21040303,21060303,21070303,21080303,21090303}, icon="bszyd"},
	{id=11, name="星墟之耀芒", wearing=5, career=3, quantity=7, fashionId={21010203,21020201,21040203,21060203,21070203,21080203,21090203}, icon="cyzxx"},
	{id=12, name="星穹撕裂者", wearing=4, career=3, quantity=7, fashionId={21010103,21020101,21040103,21060103,21070103,21080103,21090103}, icon="skyqz"},
	{id=13, career=4},
	{id=14, name="霜魄之凝殇", wearing=6, career=4, fashionId=local_fashionId.fashionId_2, icon="bszyd"},
	{id=15, name="星墟之耀芒", wearing=5, career=4, fashionId=local_fashionId.fashionId_3, icon="cyzxx"},
	{id=16, name="星穹撕裂者", wearing=4, career=4, fashionId=local_fashionId.fashionId_4, icon="skyqz"},
	{id=17, career=5},
	{id=18, name="霜魄之凝殇", wearing=6, career=5, fashionId=local_fashionId.fashionId_2, icon="bszyd"},
	{id=19, name="星墟之耀芒", wearing=5, career=5, fashionId=local_fashionId.fashionId_3, icon="cyzxx"},
	{id=20, name="星穹撕裂者", wearing=4, career=5, fashionId=local_fashionId.fashionId_4, icon="skyqz"},
	{id=21, career=6},
	{id=22, name="霜魄之凝殇", wearing=6, career=6, fashionId=local_fashionId.fashionId_2, icon="bszyd"},
	{id=23, name="星墟之耀芒", wearing=5, career=6, fashionId=local_fashionId.fashionId_3, icon="cyzxx"},
	{id=24, name="星穹撕裂者", wearing=4, career=6, fashionId=local_fashionId.fashionId_4, icon="skyqz"},
	{id=25, career=7},
	{id=26, name="霜魄之凝殇", wearing=6, career=7, fashionId=local_fashionId.fashionId_2, icon="bszyd"},
	{id=27, name="星墟之耀芒", wearing=5, career=7, fashionId=local_fashionId.fashionId_3, icon="cyzxx"},
	{id=28, name="星穹撕裂者", wearing=4, career=7, fashionId=local_fashionId.fashionId_4, icon="skyqz"},
}

local defaults = {name="焚天之烬灭", wearing=11, career=1, quantity=6, fashionId={20301051,20401051,20601051,20801051,20701051,20901051}, icon="hjjw"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_FashionGuide) do
	setmetatable(v, mt)
end

return cfg_FashionGuide