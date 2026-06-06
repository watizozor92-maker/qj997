-- 此文件工具自动生成，不要修改
---@class cfg_url_column
---1：服务器列表地址
---2:登录地址
---3：注册地址
---4：日志服务器地址
---@field type number @类型 column=1 A
---0：通用
---1：SDK
---2:其他
---@field subType number @子类型 column=2 B
---0：通用
---1：内网
---2：外网
---@field netType number @内外网 column=3 C
---Url
---@field adrUrl string @地址 column=4 D
local cfg_url =
{
	{subType=1, netType=1, adrUrl="http://192.168.10.134:8888/dev2.json"},
	{subType=1, adrUrl="http://120.27.195.85:8080/xw.json"},
	{netType=1, adrUrl="http://192.168.10.134:8888/dev2.json"},
	{adrUrl="https://yq-list.kq-game.com/serverlist.json"},
	{type=2, subType=1, netType=1, adrUrl="http://192.168.10.134:8888/user/login"},
	{type=2, subType=1, adrUrl="http://120.27.195.85:10686/user/login"},
	{type=2, netType=1, adrUrl="http://192.168.10.134:8888/user/login"},
	{type=2, adrUrl="https://login.yq712.shengaowl.com/user/login"},
	{type=3, subType=0, adrUrl="http://120.27.195.85:10686/user/register"},
	{type=3, subType=1, adrUrl="http://120.27.195.85:10686/user/register"},
	{type=3, netType=1, adrUrl="http://192.168.10.134:8888/user/register"},
	{type=3, adrUrl="https://login.yq712.shengaowl.com/user/register"},
	{type=4, subType=1, netType=1, adrUrl="http://192.168.10.173:3001"},
	{type=4, subType=1, adrUrl="http://47.96.137.30:8080"},
	{type=4, netType=1, adrUrl="http://192.168.10.173:3001"},
	{type=4, adrUrl="http://47.96.137.30:8080"},
}

local defaults = {type=1, subType=2, netType=2}
local mt = {__index = defaults}
for _, v in ipairs(cfg_url) do
	setmetatable(v, mt)
end

return cfg_url