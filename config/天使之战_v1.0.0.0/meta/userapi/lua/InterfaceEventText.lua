--后端接口测试模板
--注意自定义名称不能重名，跨文件也不行

--角色登录，获取当前用户下的角色列表
function getrolelisttest(actor)
    --function 自定义名称（默认参数【自定义名称】，参数1，参数2...）
    local info = getrolelist(actor, getbaseinfo(actor, "uid"))--local 自定义变量 = 接口事件名称（默认参数【自定义名称】，参数1，参数2...）
    print(info)--打印返回数据
end
--后端事件测试模板

-- --角色登录，每天登录触发
-- function setday(actor)
--     --function 事件名称（默认参数【自定义名称】，参数1，参数2...）
--     local info = getrolelist(play, getbaseinfo(actor, "uid"))--local 自定义变量 = 接口事件名称（默认参数【自定义名称】，参数1，参数2...）
--     print(info)--打印返回数据
--     print("每天登录触发")--打印返回标识
-- end

--接口测试

--角色登录，创建角色
function createroletest(actor)
    local info = createrole(actor, getbaseinfo(actor, "uid"), "无敌小牛马1", 1, 1)
    print(info)--打印返回数据
end

--角色登录，删除角色
function deleteroletest(actor)
    local info = deleterole(actor, getbaseinfo(actor, "uid"), 29670807827996672)
    print(info)--打印返回数据
end

--角色登录，随机名称
function gainrandomrolenametest(actor)
    local info = gainrandomrolename(actor, 1, "韦恩法温")
    print(info)--打印返回数据
end

--角色登录，解锁职业
function unlockusercareertest(actor)
    local info = unlockusercareer(actor, 4, getbaseinfo(actor, "uid"))
    print(info)--打印返回数据
end

--角色登录，获取职业解锁状态
function getusercareerlockstatetest(actor)
    local info = getusercareerlockstate(actor, 4, getbaseinfo(actor, "uid"))
    print(info)--打印返回数据
end

--角色登录，获得充值金额信息
function getrechargeinfotest(actor)
    local info = getrechargeinfo(actor, getbaseinfo(actor, "rid"))
    print(info)--打印返回数据
end

--自定义表格，读取表字段值
function gettablevaluetest(actor)
    local info = ConfigDataManager.getTableValue("cfg_item", "name", "id", 10010001)
    print(info)--打印返回数据
end

--自定义表格，读取表行
function gettabletest(actor)
    local info = ConfigDataManager.getTable("cfg_item", "id", 10010001)
    print(info)--打印返回数据
end

--事件测试

