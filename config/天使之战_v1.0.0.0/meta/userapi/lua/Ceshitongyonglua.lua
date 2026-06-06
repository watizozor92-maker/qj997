---后端接口测试模板
---注意自定义名称不能重复，跨文件也不行

--获取系统(全局)变量
function    getsysvartest(actor,add)                                       --function 接口名称+test （默认参数【自定义名称】，参数1，参数2）
    local result =  getsysvar(actor,add)                                      --1ocal 自定义变量 = 接口事件名称(默认参数【自定义名称】，参数1,参数2...)
    print(result,"获取系统(全局)变量1")--打印返回数据

end

--获取系统(全局)变量
function    setsysvartest(actor,add,number)                                       --function 接口名称+test （默认参数【自定义名称】，参数1，参数2）
    local result = setsysvar(actor,add,number)                                       --1ocal 自定义变量 = 接口事件名称(默认参数【自定义名称】，参数1,参数2...)
    print(result,"获取系统(全局)变量2")--打印返回数据
end

--获取玩家变量
function    getplaydeftest(actor,add)                                       --function 接口名称+test （默认参数【自定义名称】，参数1，参数2）
    local result1 =  getplaydef(actor,add)                               --1ocal 自定义变量 = 接口事件名称(默认参数【自定义名称】，参数1,参数2...)
    print(result1,"获取系统(全局)变量3")--打印返回数据
end
--设置玩家变量
function    setplaydeftest(actor,add,number)                                       --function 接口名称+test （默认参数【自定义名称】，参数1，参数2）
    local result1= setplaydef(actor,add,number)                         --1ocal 自定义变量 = 接口事件名称(默认参数【自定义名称】，参数1,参数2...)
    print(result1,"获取系统(全局)变量4")--打印返回数据
end

--初始化自定义系统变量
function    inisysvartest(actor,type1,name)                                       --function 接口名称+test （默认参数【自定义名称】，参数1，参数2）
    local result1= inisysvar(actor,type1,name)                               --1ocal 自定义变量 = 接口事件名称(默认参数【自定义名称】，参数1,参数2...)
    print(result1,"获取系统(全局)变量5")--打印返回数据
end

--获得自定义系统变量
function    getsysvarextest(actor,add)                                       --function 接口名称+test （默认参数【自定义名称】，参数1，参数2）
    local result12 = getsysvarex(actor,add)                              --1ocal 自定义变量 = 接口事件名称(默认参数【自定义名称】，参数1,参数2...)
    print(result12,"获取系统(全局)变量6")--打印返回数据
end


--设置自定义系统变量     actor,变量名字、值、是否保存(0和1)
function    getsysvarextest(actor,addname,value,type1)                                       --function 接口名称+test （默认参数【自定义名称】，参数1，参数2）
    local result1=setsysvarex(actor,addname,value,type1)                            --1ocal 自定义变量 = 接口事件名称(默认参数【自定义名称】，参数1,参数2...)
    print(result1,"获取系统(全局)变量7")--打印返回数据
end

--初始化自定义玩家变量   actor,类型(string、integer)，变量名称

function    iniplayvartest(actor,string,addname)                                       --function 接口名称+test （默认参数【自定义名称】，参数1，参数2）
    local result1=iniplayvar(actor,string,addname)                       --1ocal 自定义变量 = 接口事件名称(默认参数【自定义名称】，参数1,参数2...)
    print(result1,"获取系统(全局)变量8")--打印返回数据
end

--获得自定义玩家变量   

function    getplayvartest(actor,addname)                                       --function 接口名称+test （默认参数【自定义名称】，参数1，参数2）
    local result = getplayvar(actor,addname)                    --1ocal 自定义变量 = 接口事件名称(默认参数【自定义名称】，参数1,参数2...)
    print(result,"获取系统(全局)变量9")--打印返回数据
end

 --设置自定义玩家变量  actor,变量名字、值、是否保存(0和1)

 function    getplayvartest(actor,addname,value,type)                                       --function 接口名称+test （默认参数【自定义名称】，参数1，参数2）
    local result1=setplayvar(actor,addname,value,type)                   --1ocal 自定义变量 = 接口事件名称(默认参数【自定义名称】，参数1,参数2...)
    print(result1,"获取系统(全局)变量10")--打印返回数据
end


 --初始化自定义战盟变量   guild,类型(string、integer)，变量名称

 function    iniguildvartest(actor,string,addname)                                       --function 接口名称+test （默认参数【自定义名称】，参数1，参数2）
    local result1=iniguildvar(actor,string,addname)                    --1ocal 自定义变量 = 接口事件名称(默认参数【自定义名称】，参数1,参数2...)
    print(result1,"获取系统(全局)变量11")--打印返回数据
end

--获得自定义战盟变量     guild,变量名字
function    getguildvartest(guild,addname)                                       --function 接口名称+test （默认参数【自定义名称】，参数1，参数2）
    local result = getguildvar(guild,addname)                 --1ocal 自定义变量 = 接口事件名称(默认参数【自定义名称】，参数1,参数2...)
    print(result,"获取系统(全局)变量12")--打印返回数据
end

--设置自定义战盟变量   getguildvar

function    getguildvartest(guild,value,type1)                                       --function 接口名称+test （默认参数【自定义名称】，参数1，参数2）
    local result1=setguildvar(getmyguild(actor),value,type1)                 --1ocal 自定义变量 = 接口事件名称(默认参数【自定义名称】，参数1,参数2...)
    print(result1,"获取系统(全局)变量13")--打印返回数据
end

--获得玩家的战盟  getmyguild

function    getguildvartest(actor)                                       --function 接口名称+test （默认参数【自定义名称】，参数1，参数2）
    local guildid = getmyguild(actor)                --1ocal 自定义变量 = 接口事件名称(默认参数【自定义名称】，参数1,参数2...)
    print(guildid,"获取系统(全局)变量15")--打印返回数据
end


--获得玩家基本信息（常量） getbaseinfo

function    getguildvartest(actor,addname)                                       --function 接口名称+test （默认参数【自定义名称】，参数1，参数2）
    local result = getbaseinfo(actor,addname)               --1ocal 自定义变量 = 接口事件名称(默认参数【自定义名称】，参数1,参数2...)
    print(result,"获取系统(全局)变量14")--打印返回数据
end

--获得玩家属性值  getattrinfo


function    getguildvartest(actor,addname)                                       --function 接口名称+test （默认参数【自定义名称】，参数1，参数2）
    local result = getattrinfo(actor,addname)            --1ocal 自定义变量 = 接口事件名称(默认参数【自定义名称】，参数1,参数2...)
    print(result,"获取系统(全局)变量16")--打印返回数据
end