-- 此文件工具自动生成，不要修改
---@class cfg_lineNotice_column
---@field id number @id column=1 A
---1右往左滚动公告
---2左往右滚动公告
---3下往上淡出公告
---4上往下淡出公告
---5静止淡出公告
---6倒计时消息
---7聊天框消息
---@field messageType IntList @消息类型 column=2 B
---索引cfg_color表中id对应的颜色值
---@field backgroundColor string @背景颜色 column=3 C
---背景显示的透明度，单位为百分比，取值范围0~100，0为完全不透明，100为完全透明
---@field transparencyB number @背景透明度 column=4 D
---索引cfg_color表中id对应的颜色值
---@field textColor string @文字颜色 column=5 E
---背景显示的透明度，单位为百分比，取值范围0~100，0为完全不透明，100为完全透明
---@field transparencyT number @文字透明度 column=6 F
---文字字号
---@field textSize number @文字大小 column=7 G
---屏幕X偏移
---仅messageType=6时有效
---@field offsetX number @X偏移 column=8 H
---屏幕Y偏移
---@field offsetY number @Y偏移 column=9 I
---仅messageType=1-5时有效
---格式:毫秒  
---@field rollSpeed number @滚动速度 column=10 J
---@field rollCount number @滚动次数 column=11 K
---0，不开启
---1，开启
---@field active number @是否开启 column=12 L
---信息内容
---倒计时格式：count<X>秒：X/1000秒
---@field text string @内容 column=13 M

local local_messageType = {
    messageType_1={1},
    messageType_2={2},
    messageType_3={3},
    messageType_4={4},
    messageType_5={5},
    messageType_6={6},

}

local cfg_lineNotice =
{
	{id=1, messageType=local_messageType.messageType_1, textSize=20, offsetY=20, text="亲爱的勇士，欢迎来到比奇大陆！"},
	{id=2, messageType=local_messageType.messageType_2, offsetY=20, rollCount=2, text="本服为长期服，欢迎常驻！"},
	{id=3, messageType=local_messageType.messageType_3, textSize=40, offsetY=20, text="点击“攻略”查看新手引导"},
	{id=4, messageType=local_messageType.messageType_4, textSize=20, offsetY=20, text="点击“微信”图标关注微信公众号并领取豪华新手礼包！"},
	{id=5, messageType=local_messageType.messageType_5, offsetY=20, text="生死看淡，不服就干！祝您玩得愉快！"},
	{id=6, messageType=local_messageType.messageType_6, offsetX=0, offsetY=0, rollSpeed=0, text="新手活动将于count<30000>秒后结束，请大家及时领取奖励！"},
	{id=7, messageType=local_messageType.messageType_1, backgroundColor="249", transparencyB=50, textColor="0", transparencyT=50, rollCount=3, text="id不断表格隔行test右往左刷三遍"},
	{id=8, messageType=local_messageType.messageType_2, backgroundColor="249", transparencyB=50, textColor="50", transparencyT=50, textSize=20, rollCount=2, text="id为9左往右半透明刷两遍test"},
	{id=9, messageType=local_messageType.messageType_3, backgroundColor="255", textColor="0", text="id为8下往上接近透明刷两遍test"},
	{id=10, messageType=local_messageType.messageType_4, backgroundColor="249", transparencyB=50, textColor="251", transparencyT=0, rollSpeed=2000, rollCount=2, text="上往下西红柿炒鸡蛋颜色刷两遍test"},
	{id=11, messageType=local_messageType.messageType_5, backgroundColor="250", transparencyB=50, textColor="251", transparencyT=0, rollSpeed=6000, rollCount=3, text="隔id测试万恶的黄配绿刷三遍test"},
	{id=12, messageType=local_messageType.messageType_6, backgroundColor="209", transparencyB=50, textColor="216", transparencyT=50, offsetX=1000, offsetY=1000, rollSpeed=0, rollCount=2, text="本服已启动自毁程序，倒计时count<10000>秒后原地爆炸！！！"},
	{id=13, messageType=local_messageType.messageType_5, backgroundColor="252", transparencyB=40, textColor="255", transparencyT=50, textSize=120, rollSpeed=3000, text="逗你玩的😄O(∩_∩)O"},
	{id=14, messageType={7}, backgroundColor="252", transparencyB=0, textColor="255", transparencyT=0, textSize=150, rollSpeed=0, rollCount=3, text="公告库聊天窗口测试。。。"},
}

local defaults = {backgroundColor="0", transparencyB=20, textColor="1", transparencyT=20, textSize=30, offsetX=0, offsetY=0, rollSpeed=1000, rollCount=1, active=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_lineNotice) do
	setmetatable(v, mt)
end

return cfg_lineNotice