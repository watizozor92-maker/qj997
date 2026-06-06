-- 此文件工具自动生成，不要修改
---@class Element_column
---@field  number @ column=1 A
---@field  number @ column=2 B
---@field  number @ column=3 C
---@field  string @ column=4 D
---@field  IntListList @ column=5 E
---@field  number @ column=6 F
---@field  number @ column=7 G
---@field  IntListList @ column=8 H
---@field  string @ column=9 I
---@field  string @ column=10 J
---@field  string @ column=11 K
---@field  string @ column=12 L
---@field  number @ column=13 M
---transfer#传送ID#X坐标#Y坐标
---未填坐标则传送到该地图的默认传送点
---传送ID参考mapMove表id
---
---transferNPC#NPCID
---传送到NPC位置，并交互
---NPCID参考npc_list表ID
---
---moveTo#传送ID#X坐标#Y坐标
---寻路，并将坐标设为主动目标
---传送ID参考mapMove表id
---
---moveToNPC#NPCID
---寻路至该NPC位置，并交互
---NPCID参考npc_list表ID
---
---openUI#UI名#[0,1] 0=不关闭界面 1=关闭界面   任务界面专用
---
---openUIpanel#UI名#[0,1] 0=不关闭界面 1=关闭界面   通用（任务界面+每日目标）
---@field  number @快捷指令按钮2 column=14 N
---[[客户端不使用]]@field   @ column=15 O
local Element =
{
}
return Element