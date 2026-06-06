-- 此文件工具自动生成，不要修改
---@class cfg_unionmember_column
---唯一id
---@field id number @唯一id column=1 A
---前端并不显示
---@field level number @权限等级 column=2 B
---前端显示名称
---@field desc StringList @职阶名称 column=3 C
---只能踢权限等级低于自己的
---@field hr number @人事权限（收人和踢人） column=4 D
---设定招人时的条件
---@field reg number @招人条件权限 column=5 E
---包括战盟公告和收人公告（前端用）
---@field post number @编辑公告（两种） column=6 F
---付费修改（前端用）
---@field changeName number @修改战盟名字/臂章 column=7 G
---禅让盟主
---@field leader number @禅让盟主 column=8 H
---只能任命比自己权限等级低的职位
---@field newjob number @任命职位 column=9 I
---职位上限人数
---@field limit number @职位上限人数 column=10 J
---是否可以弹劾盟主
---@field impeach number @弹劾盟主 column=11 K
---1是
---@field makeEnemy IntListList @是否可发起宣战 column=12 L
---[[客户端不使用]]@field   @ column=13 M

local local_makeEnemy = {
    makeEnemy_1={{1}},

}

local cfg_unionmember =
{
	{id=1, level=5, desc={"盟主"}, hr=1, reg=1, post=1, changeName=1, leader=1, newjob=1, limit=1, impeach=0, makeEnemy=local_makeEnemy.makeEnemy_1},
	{id=2, level=4, desc={"副盟主"}, hr=1, reg=1, post=1, changeName=0, leader=0, newjob=1, limit=2, impeach=1, makeEnemy=local_makeEnemy.makeEnemy_1},
}
return cfg_unionmember