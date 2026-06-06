-- 此文件工具自动生成，不要修改
---@class cfg_equip_angelGrailSuit_column
---@field id number @id column=1 A
---套装名称，套装名称会显示在装备tips上
---@field name string @套装名称 column=2 B
---会显示在圣杯总览的套装名字处
---@field mainName string @套装组名称 column=3 C
---同1组的套装，圣杯品质向下兼容，且只生效最高级套装
---@field group number @套装组 column=4 D
---同1组的套装，圣杯品质向下兼容，且只生效最高级套装
---@field level number @套装等级 column=5 E
---所需穿戴的圣杯ID
---@field suitGrailId IntList @圣杯部件 column=6 F
---@field SuitMaxCount number @套装最大数量 column=7 G
---套装属性加成
---格式：穿戴套装部件数#属性id#属性值&属性id#属性值|穿戴套装部件数#属性id#属性值&属性id#属性值
---
---不同套装组的套装属性加成叠加
---@field suitEffect IntListList @套装效果 column=8 H
local cfg_equip_angelGrailSuit =
{
	{id=1, name="优秀傲慢套装"},
	{id=2, name="精良傲慢套装", level=2, suitGrailId={93000121,93001121,93002121}, suitEffect={{3,207022,80},{5,304022,70},{7,304012,70}}},
	{id=3, name="史诗傲慢套装", level=3, suitGrailId={93000131,93001131,93002131}, suitEffect={{3,207022,100},{5,304022,100},{7,304012,100}}},
	{id=4, name="传说傲慢套装", level=4, suitGrailId={93000141,93001141,93002141}, suitEffect={{3,207022,120},{5,304022,200},{7,304012,200}}},
	{id=5, name="优秀嫉妒套装", mainName="嫉妒套装", group=2, suitGrailId={93000211,93001211,93002211}, suitEffect={{3,207022,90},{5,304022,80},{7,304012,80}}},
	{id=6, name="精良嫉妒套装", mainName="嫉妒套装", group=2, level=2, suitGrailId={93000221,93001221,93002221}, suitEffect={{3,207022,120},{5,304022,120},{7,304012,120}}},
	{id=7, name="史诗嫉妒套装", mainName="嫉妒套装", group=2, level=3, suitGrailId={93000231,93001231,93002231}, suitEffect={{3,207022,150},{5,304022,150},{7,304012,150}}},
	{id=8, name="传说嫉妒套装", mainName="嫉妒套装", group=2, level=4, suitGrailId={93000241,93001241,93002241}, suitEffect={{3,207022,180},{5,304022,300},{7,304012,300}}},
	{id=9, name="优秀暴怒套装", mainName="暴怒套装", group=3, suitGrailId={93000311,93001311,93002311}, suitEffect={{3,207022,120},{5,304022,100},{7,304012,100}}},
	{id=10, name="精良暴怒套装", mainName="暴怒套装", group=3, level=2, suitGrailId={93000321,93001321,93002321}, suitEffect={{3,207022,160},{5,304022,150},{7,304012,150}}},
	{id=11, name="史诗暴怒套装", mainName="暴怒套装", group=3, level=3, suitGrailId={93000331,93001331,93002331}, suitEffect={{3,207022,200},{5,304022,200},{7,304012,200}}},
	{id=12, name="传说暴怒套装", mainName="暴怒套装", group=3, level=4, suitGrailId={93000341,93001341,93002341}, suitEffect={{3,207022,240},{5,304022,400},{7,304012,400}}},
	{id=13, name="优秀怠惰套装", mainName="怠惰套装", group=4, suitGrailId={93000411,93001411,93002411}, suitEffect={{3,207022,150},{5,303022,50},{7,303012,50}}},
	{id=14, name="精良怠惰套装", mainName="怠惰套装", group=4, level=2, suitGrailId={93000421,93001421,93002421}, suitEffect={{3,207022,200},{5,303022,70},{7,303012,70}}},
	{id=15, name="史诗怠惰套装", mainName="怠惰套装", group=4, level=3, suitGrailId={93000431,93001431,93002431}, suitEffect={{3,207022,250},{5,303022,100},{7,303012,100}}},
	{id=16, name="传说怠惰套装", mainName="怠惰套装", group=4, level=4, suitGrailId={93000441,93001441,93002441}, suitEffect={{3,207022,300},{5,303022,200},{7,303012,200}}},
	{id=17, name="优秀贪婪套装", mainName="贪婪套装", group=5, suitGrailId={93000511,93001511,93002511}, suitEffect={{3,207022,180},{5,303022,80},{7,303012,80}}},
	{id=18, name="精良贪婪套装", mainName="贪婪套装", group=5, level=2, suitGrailId={93000521,93001521,93002521}, suitEffect={{3,207022,240},{5,303022,120},{7,303012,120}}},
	{id=19, name="史诗贪婪套装", mainName="贪婪套装", group=5, level=3, suitGrailId={93000531,93001531,93002531}, suitEffect={{3,207022,300},{5,303022,150},{7,303012,150}}},
	{id=20, name="传说贪婪套装", mainName="贪婪套装", group=5, level=4, suitGrailId={93000541,93001541,93002541}, suitEffect={{3,207022,360},{5,303022,300},{7,303012,300}}},
	{id=21, name="优秀暴食套装", mainName="暴食套装", group=6, suitGrailId={93000611,93001611,93002611}, suitEffect={{3,207022,210},{5,303022,100},{7,303012,100}}},
	{id=22, name="精良暴食套装", mainName="暴食套装", group=6, level=2, suitGrailId={93000621,93001621,93002621}, suitEffect={{3,207022,280},{5,303022,150},{7,303012,150}}},
	{id=23, name="史诗暴食套装", mainName="暴食套装", group=6, level=3, suitGrailId={93000631,93001631,93002631}, suitEffect={{3,207022,350},{5,303022,200},{7,303012,200}}},
	{id=24, name="传说暴食套装", mainName="暴食套装", group=6, level=4, suitGrailId={93000641,93001641,93002641}, suitEffect={{3,207022,420},{5,303022,400},{7,303012,400}}},
	{id=25, name="优秀欲望套装", mainName="欲望套装", group=7, suitGrailId={93000711,93001711,93002711}, suitEffect={{3,207022,240},{5,305022,50},{7,305012,50}}},
	{id=26, name="精良欲望套装", mainName="欲望套装", group=7, level=2, suitGrailId={93000721,93001721,93002721}, suitEffect={{3,207022,320},{5,305022,70},{7,305012,70}}},
	{id=27, name="史诗欲望套装", mainName="欲望套装", group=7, level=3, suitGrailId={93000731,93001731,93002731}, suitEffect={{3,207022,400},{5,305022,100},{7,305012,100}}},
	{id=28, name="传说欲望套装", mainName="欲望套装", group=7, level=4, suitGrailId={93000741,93001741,93002741}, suitEffect={{3,207022,480},{5,305022,200},{7,305012,200}}},
	{id=29, name="优秀纯洁套装", mainName="纯洁套装", group=8, suitGrailId={93000811,93001811,93002811}, suitEffect={{3,207022,270},{5,305022,80},{7,305012,80}}},
	{id=30, name="精良纯洁套装", mainName="纯洁套装", group=8, level=2, suitGrailId={93000821,93001821,93002821}, suitEffect={{3,207022,360},{5,305022,120},{7,305012,120}}},
	{id=31, name="史诗纯洁套装", mainName="纯洁套装", group=8, level=3, suitGrailId={93000831,93001831,93002831}, suitEffect={{3,207022,450},{5,305022,150},{7,305012,150}}},
	{id=32, name="传说纯洁套装", mainName="纯洁套装", group=8, level=4, suitGrailId={93000841,93001841,93002841}, suitEffect={{3,207022,540},{5,305022,300},{7,305012,300}}},
	{id=33, name="优秀大天使套装", mainName="大天使套装", group=9, suitGrailId={93000911,93001911,93002911}, suitEffect={{3,207022,300},{5,305022,100},{7,305012,100}}},
	{id=34, name="精良大天使套装", mainName="大天使套装", group=9, level=2, suitGrailId={93000921,93001921,93002921}, suitEffect={{3,207022,400},{5,305022,150},{7,305012,150}}},
	{id=35, name="史诗大天使套装", mainName="大天使套装", group=9, level=3, suitGrailId={93000931,93001931,93002931}, suitEffect={{3,207022,500},{5,305022,200},{7,305012,200}}},
	{id=36, name="传说大天使套装", mainName="大天使套装", group=9, level=4, suitGrailId={93000941,93001941,93002941}, suitEffect={{3,207022,600},{5,305022,400},{7,305012,400}}},
	{id=37, name="优秀智天使套装", mainName="智天使套装", group=10, suitGrailId={930001011,930011011,930021011}, suitEffect={{3,207022,330},{5,304022,75},{7,304012,75}}},
	{id=38, name="精良智天使套装", mainName="智天使套装", group=10, level=2, suitGrailId={930001021,930011021,930021021}, suitEffect={{3,207022,440},{5,304022,105},{7,304012,105}}},
	{id=39, name="史诗智天使套装", mainName="智天使套装", group=10, level=3, suitGrailId={930001031,930011031,930021031}, suitEffect={{3,207022,550},{5,304022,150},{7,304012,150}}},
	{id=40, name="传说智天使套装", mainName="智天使套装", group=10, level=4, suitGrailId={930001041,930011041,930021041}, suitEffect={{3,207022,660},{5,304022,300},{7,304012,300}}},
	{id=41, name="优秀座天使套装", mainName="座天使套装", group=11, suitGrailId={930001111,930011111,930021111}, suitEffect={{3,207022,360},{5,304022,120},{7,304012,120}}},
	{id=42, name="精良座天使套装", mainName="座天使套装", group=11, level=2, suitGrailId={930001121,930011121,930021121}, suitEffect={{3,207022,480},{5,304022,180},{7,304012,180}}},
	{id=43, name="史诗座天使套装", mainName="座天使套装", group=11, level=3, suitGrailId={930001131,930011131,930021131}, suitEffect={{3,207022,600},{5,304022,225},{7,304012,225}}},
	{id=44, name="传说座天使套装", mainName="座天使套装", group=11, level=4, suitGrailId={930001141,930011141,930021141}, suitEffect={{3,207022,720},{5,304022,450},{7,304012,450}}},
	{id=45, name="优秀主天使套装", mainName="主天使套装", group=12, suitGrailId={930001211,930011211,930021211}, suitEffect={{3,207022,390},{5,304022,150},{7,304012,150}}},
	{id=46, name="精良主天使套装", mainName="主天使套装", group=12, level=2, suitGrailId={930001221,930011221,930021221}, suitEffect={{3,207022,520},{5,304022,225},{7,304012,225}}},
	{id=47, name="史诗主天使套装", mainName="主天使套装", group=12, level=3, suitGrailId={930001231,930011231,930021231}, suitEffect={{3,207022,650},{5,304022,300},{7,304012,300}}},
	{id=48, name="传说主天使套装", mainName="主天使套装", group=12, level=4, suitGrailId={930001241,930011241,930021241}, suitEffect={{3,207022,780},{5,304022,600},{7,304012,600}}},
	{id=49, name="优秀力天使套装", mainName="力天使套装", group=13, suitGrailId={930001311,930011311,930021311}, suitEffect={{3,207022,420},{5,303022,75},{7,303012,75}}},
	{id=50, name="精良力天使套装", mainName="力天使套装", group=13, level=2, suitGrailId={930001321,930011321,930021321}, suitEffect={{3,207022,560},{5,303022,105},{7,303012,105}}},
	{id=51, name="史诗力天使套装", mainName="力天使套装", group=13, level=3, suitGrailId={930001331,930011331,930021331}, suitEffect={{3,207022,700},{5,303022,150},{7,303012,150}}},
	{id=52, name="传说力天使套装", mainName="力天使套装", group=13, level=4, suitGrailId={930001341,930011341,930021341}, suitEffect={{3,207022,840},{5,303022,300},{7,303012,300}}},
	{id=53, name="优秀能天使套装", mainName="能天使套装", group=14, suitGrailId={930001411,930011411,930021411}, suitEffect={{3,207022,450},{5,303022,120},{7,303012,120}}},
	{id=54, name="精良能天使套装", mainName="能天使套装", group=14, level=2, suitGrailId={930001421,930011421,930021421}, suitEffect={{3,207022,600},{5,303022,180},{7,303012,180}}},
	{id=55, name="史诗能天使套装", mainName="能天使套装", group=14, level=3, suitGrailId={930001431,930011431,930021431}, suitEffect={{3,207022,750},{5,303022,225},{7,303012,225}}},
	{id=56, name="传说能天使套装", mainName="能天使套装", group=14, level=4, suitGrailId={930001441,930011441,930021441}, suitEffect={{3,207022,900},{5,303022,450},{7,303012,450}}},
	{id=57, name="优秀权天使套装", mainName="权天使套装", group=15, suitGrailId={930001511,930011511,930021511}, suitEffect={{3,207022,480},{5,303022,150},{7,303012,150}}},
	{id=58, name="精良权天使套装", mainName="权天使套装", group=15, level=2, suitGrailId={930001521,930011521,930021521}, suitEffect={{3,207022,640},{5,303022,225},{7,303012,225}}},
	{id=59, name="史诗权天使套装", mainName="权天使套装", group=15, level=3, suitGrailId={930001531,930011531,930021531}, suitEffect={{3,207022,800},{5,303022,300},{7,303012,300}}},
	{id=60, name="传说权天使套装", mainName="权天使套装", group=15, level=4, suitGrailId={930001541,930011541,930021541}, suitEffect={{3,207022,960},{5,303022,600},{7,303012,600}}},
	{id=61, name="优秀天使长套装", mainName="天使长套装", group=16, suitGrailId={930001611,930011611,930021611}, suitEffect={{3,207022,510},{5,305022,75},{7,305012,75}}},
	{id=62, name="精良天使长套装", mainName="天使长套装", group=16, level=2, suitGrailId={930001621,930011621,930021621}, suitEffect={{3,207022,680},{5,305022,105},{7,305012,105}}},
	{id=63, name="史诗天使长套装", mainName="天使长套装", group=16, level=3, suitGrailId={930001631,930011631,930021631}, suitEffect={{3,207022,850},{5,305022,150},{7,305012,150}}},
	{id=64, name="传说天使长套装", mainName="天使长套装", group=16, level=4, suitGrailId={930001641,930011641,930021641}, suitEffect={{3,207022,1020},{5,305022,300},{7,305012,300}}},
	{id=65, name="优秀星界套装", mainName="星界套装", group=17, suitGrailId={930001711,930011711,930021711}, suitEffect={{3,207022,540},{5,305022,120},{7,305012,120}}},
	{id=66, name="精良星界套装", mainName="星界套装", group=17, level=2, suitGrailId={930001721,930011721,930021721}, suitEffect={{3,207022,720},{5,305022,180},{7,305012,180}}},
	{id=67, name="史诗星界套装", mainName="星界套装", group=17, level=3, suitGrailId={930001731,930011731,930021731}, suitEffect={{3,207022,900},{5,305022,225},{7,305012,225}}},
	{id=68, name="传说星界套装", mainName="星界套装", group=17, level=4, suitGrailId={930001741,930011741,930021741}, suitEffect={{3,207022,1080},{5,305022,450},{7,305012,450}}},
	{id=69, name="优秀神性套装", mainName="神性套装", group=18, suitGrailId={930001811,930011811,930021811}, suitEffect={{3,207022,570},{5,305022,150},{7,305012,150}}},
	{id=70, name="精良神性套装", mainName="神性套装", group=18, level=2, suitGrailId={930001821,930011821,930021821}, suitEffect={{3,207022,760},{5,305022,225},{7,305012,225}}},
	{id=71, name="史诗神性套装", mainName="神性套装", group=18, level=3, suitGrailId={930001831,930011831,930021831}, suitEffect={{3,207022,950},{5,305022,300},{7,305012,300}}},
	{id=72, name="传说神性套装", mainName="神性套装", group=18, level=4, suitGrailId={930001841,930011841,930021841}, suitEffect={{3,207022,1140},{5,305022,600},{7,305012,600}}},
}

local defaults = {mainName="傲慢套装", group=1, level=1, suitGrailId={93000111,93001111,93002111}, SuitMaxCount=7, suitEffect={{3,207022,60},{5,304022,50},{7,304012,50}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_angelGrailSuit) do
	setmetatable(v, mt)
end

return cfg_equip_angelGrailSuit