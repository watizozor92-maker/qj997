LianJi = {}
local this = LianJi;
local filename = "LianJi";
this.msgId = 90001025 --data [1]类型 0数据通知 l领取 2投资
this.TotalConfig = {
    unlockItemName = ""; --解锁连击功能道具名字
    addLianJi ={        --连击加成道具配置
        itemName = "SD果实";--连击加成道具
        attr_id = 310012;    --增加的属性id
        add_value = 10; --使用一个增加的属性值
        max_count = 6000; --最大使用数量
    }; 
    addSD ={    --增加SD护盾道具配置
        itemName = "SD果实";--增加SD护盾道具
        attr_id = 301011;        --增加的属性id
        add_value = 100;    --增加的属性值
        max_count = 9000;
    };

    time = 3; --触发时间（秒）
    lianji_skill = 0;--最终的连击技能id
}

LianJi.comboType = {
    qishou = 1,
    xianjie = 2,
    zhongjie = 3
}

this.charge_type = 21;--投资

---以下是实现逻辑 非程序误擅自改动
local DBVar = VarCfg.ZC_LianJi; -- 连击
local OpenVar = VarCfg.ZC_LianJiOpenFlag; -- 连击开启标记
local AutoLianJiVar = VarCfg.AutoLianJiVar; -- 自动连击状态
local LianJiRateItemVar = VarCfg.ZC_LianJiRateItemVar; -- 连击开启标记
local SDHuDunItemVar = VarCfg.ZC_SDHuDunItemVar; -- 连击开启标记
; --连击db变量
--[[
    DBVar={
        index顺序:首发技能名
        index顺序:衔接技能名 (可为nil)
            ...
            ...
        index顺序:释放技能名
        first_skill_time:起手技能释放时间/上一阶段技能释放时间
        jieduan：当前释放阶段
    }
]]

--获取数据
function LianJi.getdata(actor)
    local dbdata = API.GetTable(actor,DBVar)
    return dbdata;
end

--检查开启
function LianJi.checkOpen(actor)
    return API.GetInt(actor,OpenVar) == 1
    -- return true
end

--刷新属性 
function LianJi.RefreshAttr(actor)
    if not LianJi.checkOpen(actor) then
        return
    end
    local lianji_count = API.GetInt(actor,LianJiRateItemVar)
    local sd_count = API.GetInt(actor,SDHuDunItemVar)
    local attr_tab = {}
    if lianji_count > 0 then
        attr_tab[this.TotalConfig.addLianJi.attr_id] = this.TotalConfig.addLianJi.add_value*lianji_count
    end
    if sd_count > 0 then
        attr_tab[this.TotalConfig.addSD.attr_id] = this.TotalConfig.addSD.add_value*sd_count
    end
    addrolekmlattributes(actor,RoleAttrKey.LIAN_JI_GUO_SHI_ATT, attr_tab)
end

--数据通知
function LianJi.DataNotify(actor)
    if LianJi.checkOpen(actor) then
        local data = LianJi.getdata(actor)
        if data == nil then
            data = {}
            API.SetTable(actor, DBVar, data)
        end
        local conf = this.TotalConfig;
        local auto_state = API.GetInt(actor,AutoLianJiVar)
        local rate_count = API.GetInt(actor,LianJiRateItemVar)
        local sd_count = API.GetInt(actor,SDHuDunItemVar)
        sendluamsg(actor, this.msgId ,{0,conf,data,auto_state = auto_state,rate_count=rate_count,sd_count=sd_count})
    else
        sendluamsg(actor, this.msgId , {6})
    end
end

--自动连击状态变化请求
function LianJi.AutoLianJiChange(actor)
    if not LianJi.checkOpen(actor) then
        API.SendCenterMsg(actor,"连击未解锁，请使用"..this.TotalConfig.unlockItemName.."解锁")
        return
    end
    local data = LianJi.getdata(actor)
    if data == nil then
        API.SendCenterMsg(actor,"开启自动连击失败，未设置连击")
        return
    end

    local auto_state = API.GetInt(actor,AutoLianJiVar)
    auto_state = auto_state == 1 and 0 or 1;
    API.SetInt(actor,AutoLianJiVar,auto_state)
    API.SendCenterMsg(actor,auto_state == 1 and "已开启自动连击" or "已关闭自动连击","#00ff00")
    sendluamsg(actor, this.msgId ,{2,auto_state})
end

--增加连击加成
function LianJi.addLianJiRate(actor,count)
    local add_count = API.GetInt(actor,LianJiRateItemVar)
    local conf = this.TotalConfig.addLianJi
    if add_count >= conf.max_count then
        API.SendCenterMsg(actor,conf.itemName.."使用已达上限")
        return
    end
    count = math.min(count,conf.max_count-add_count)
    if not API.takeItem(actor,{{conf.itemName,count}}) then
        return
    end
    API.SetInt(actor,LianJiRateItemVar,add_count+count)
    LianJi.RefreshAttr(actor)
    API.SendCenterMsg(actor,conf.itemName.."使用成功，连击加成增加"..(count*conf.add_value/100).."%","#00ff00")
    sendluamsg(actor, this.msgId ,{3,add_count+count})
end

--增加sd护盾
function LianJi.addSDHuDun(actor,count)
    local add_count = API.GetInt(actor,SDHuDunItemVar)
    local conf = this.TotalConfig.addSD
    if add_count >= conf.max_count then
        API.SendCenterMsg(actor,conf.itemName.."使用已达上限")
        return
    end
    count = math.min(count,conf.max_count-add_count)
    if not API.takeItem(actor,{{conf.itemName,count}}) then
        return
    end
    API.SetInt(actor,SDHuDunItemVar,add_count+count)
    LianJi.RefreshAttr(actor)
    API.SendCenterMsg(actor,conf.itemName.."使用成功，SD护盾值增加"..count*conf.add_value,"#00ff00")
    sendluamsg(actor, this.msgId ,{4,add_count+count})
end

function LianJi.onHandlereQuest(actor, sMsg)
    if sMsg[1] == 0 then
        LianJi.DataNotify(actor)
    elseif sMsg[1] == 2 then
        LianJi.AutoLianJiChange(actor)
    elseif sMsg[1] == 3 then
        LianJi.addLianJiRate(actor, sMsg[2])
    elseif sMsg[1] == 4 then
        LianJi.addSDHuDun(actor, sMsg[2])
    end
end





-- GameEvent.add(EventCfg.onHandlereQuest,function(actor,msgid,sMsg)
--     --登录奖励领取
--     if msgid == this.msgId then
--         if sMsg[1] == 0 then
--             --数据请求
--             LianJi.DataNotify(actor)
--         elseif sMsg[1] == 1 then
--             --连击技能替换
--             LianJi.LianJiChange(actor,sMsg[2],sMsg[3],sMsg[4])
--         elseif sMsg[1] == 2 then
--             --自动连击状态变化
--             LianJi.AutoLianJiChange(actor)
--         elseif sMsg[1] == 3 then
--             --增加连击加成
--             LianJi.addLianJiRate(actor,sMsg[2])
--         elseif sMsg[1] == 4 then
--             --增加sd护盾
--             LianJi.addSDHuDun(actor,sMsg[2])
--         elseif sMsg[1] == 5 then
--             --方案替换
--             LianJi.FangAnChange(actor,sMsg[2])
--         end
--         return true
--     end
-- end
-- ,filename)

--重载配置
GameEvent.add(EventCfg.onReloadScript,function(actor)
    if LianJi.checkOpen(actor) then
        sendluamsg(actor, this.msgId,{-1,this.TotalConfig})
    end
end,filename)

function LianJi.Unlock(actor)
    API.SetInt(actor,OpenVar,1)
    API.SendCenterMsg(actor,"恭喜解锁连击功能","#00ff00")
    local comboSkill = getrolefield(actor,"role.roleskill.comboskill")
    local skillLv =  comboSkill.skillLv
    local skillCfgId =  comboSkill.skillCfgId
    if skillCfgId == 0 then
        local comboSkillInfo = ConfigDataManager.getTableValue("cfg_global","value","id",1501)
        local baseCareer = getbaseinfo(actor, "getbasecareer")
        local comboSkillTable = string.split(comboSkillInfo,"|")
        for index, careerComboSkill in pairs(comboSkillTable) do
            local careerComboSkillInfo = string.split(careerComboSkill,"#")
            if tonumber(careerComboSkillInfo[1]) == tonumber(baseCareer) then
                skillCfgId = tonumber(careerComboSkillInfo[2])
            end
        end
        addcomboskill(actor,skillCfgId,1)
    end
    API.SetTable(actor, DBVar, {})
    LianJi.DataNotify(actor)
end

--道具使用后触发
GameEvent.add(EventCfg.OnGmUnlockLianji,function(actor,career_name)
    LianJi.Unlock(actor)
    return true
end,filename)

--玩家登录
GameEvent.add(EventCfg.onLoginEnd,function(actor)
    LianJi.DataNotify(actor)
end,filename)

--道具使用后触发
GameEvent.add(EventCfg.onUseItem,function(actor,itemConfigId,count,item_name)
    if 100000001 ~= itemConfigId then
        return
    end
    LianJi.Unlock(actor)
    return true
end,filename)


function setcombovaluebefore(actor, skillCfgId, skillLevel, skill)
    if not LianJi.checkOpen(actor) then
        return 0
    end
    
    local data = LianJi.getdata(actor)
    if not data then
        data = {}
        API.SetTable(actor, DBVar, data)
    end
    
    local now = getbaseinfo("nowsec")
    local comboCount = 3
    local currentStage = (data.jieduan or 0) + 1
    local lastSkillTime = data.first_skill_time or 0
    
    if now > lastSkillTime + this.TotalConfig.time then
        currentStage = 0
    end
    
    if currentStage == 0 then
        currentStage = 1
        data.skillIdSet = {}
        sendluamsg(actor, this.msgId, {5})
    end
    
    if data.skillIdSet and data.skillIdSet[skill] then
        return 0
    end
    
    data.jieduan = currentStage
    data.first_skill_time = now
    data.skillIdSet = data.skillIdSet or {}
    data.skillIdSet[skill] = true
    API.SetTable(actor, DBVar, data)
    
    if currentStage == comboCount then
        data.jieduan = 0
        data.skillIdSet = {}
        API.SetTable(actor, DBVar, data)
        return 10000
    end
    return 0
end

--[[
--以下为基于list配置的旧连击逻辑，当前连击校验已不再使用list，保留备用

--list配置（原TotalConfig内）
    --配置说明
    --key(int)：职业id
    --    key(int)：连击方案index
    --        key(int):技能阶段 通常为【启动技】(StringList)-【衔接技】(StringList ,可为nil 或有多个衔接技) .... -【迸发技】(StringList)
    --            各阶段[1]：为初始默认设置
    --            attr_name:方案对应cfg_att_info attribute值 只有1项时不分分支 属性值最高的生效          
    list = {        --连击表
        [1]={
            {
                {"旋风斩"};
                {"霹雳回旋斩","雷霆裂闪"};
                {"袭风刺","致命一击"};
                attr_name = "strength";
            };
        };
        [2]={
            {
                {"冰封"};
                {"黑龙波术","血龙波术"};
                {"爆炎术","爆裂炎术"};
            };
        };
        [3]={
            {
                {"冰封箭","冰封冽箭"};
                {"多重箭"};
                {"穿透箭","穿透刺箭"};
            };
        };
        [4]={
            {
                {"天雷闪"};
                {"霹雳回旋斩"};
                {"玄月斩"};
                attr_name = "strength";
            };
            {
                {"掌心雷"};
                {"闪电轰顶"};
                attr_name = "intelligence";
            };
        };
    };

--初始化默认连击
function LianJi.InitLianJi(actor)
    local data = {}
    local baseCareer = getbaseinfo(actor,"getbasecareer")
    local conf = this.TotalConfig.list[baseCareer];
    if conf == nil then
        gameDebug.print("连击初始化错误，对应职业配置为nil,baseCareer="..baseCareer)
        return
    end
    if #conf > 1 then
        local max_key = ""
        local max_value = 0;
        for k,v in pairs(conf) do
            if v.attr_name then
                local value = getattrinfo(actor,v.attr_name)
                if value > max_value then
                    max_key = k
                    max_value = value
                end
            end
        end
        conf = conf[max_key]
        data.fangan = max_key
    else
        conf = conf[1]
        data.fangan = 1
    end
    if conf == nil then
        gameDebug.print("连击初始化错误2，对应职业配置为nil,baseCareer="..baseCareer)
        return
    end
    for i=1,#conf do 
        local skill_id = ConfigDataManager.getTableValue("cfg_skill", "id", "name", conf[i][1]);
        data[i] = skill_id
    end
    API.SetTable(actor,DBVar,data)
    return data
end

--连击设置变化请求
function LianJi.LianJiChange(actor,jieduan,skillName,fangan)
    if not LianJi.checkOpen(actor) then
        API.SendCenterMsg(actor,"连击未解锁，请使用"..this.TotalConfig.unlockItemName.."解锁")
        return
    end
    local data = LianJi.getdata(actor)
    if data == nil then
        data = LianJi.InitLianJi(actor)
    end
    fangan = fangan or 1
    if fangan ~= data.fangan then
        API.SendCenterMsg(actor,"此方案未使用，不能设置")
        return
    end
    local skill_id = ConfigDataManager.getTableValue("cfg_skill", "id", "name", skillName);
    if data[jieduan] == skill_id then
        API.SendCenterMsg(actor,"请勿重复设置")
        return
    end
    local skill_level = getskilllevel(actor,skill_id)
    if skill_level <= 0 then
        API.SendCenterMsg(actor,"连击设置失败，未解锁"..skillName)
        return
    end

    local baseCareer = getbaseinfo(actor,"getbasecareer")
    local conf = this.TotalConfig.list[baseCareer][data.fangan][jieduan];
    if conf == nil then
        API.SendCenterMsg(actor,"连击配置为nil，请联系管理员，basecareer="..baseCareer.." fangan="..data.fangan,nil,true)
        return
    end
    if not table.hasValue(conf,skillName) then
        API.SendCenterMsg(actor,skillName.."不能设置")
        return
    end
    data[jieduan] = skill_id;
    API.SetTable(actor,DBVar,data)
    API.SendCenterMsg(actor,"连击"..jieduan.."阶段，"..skillName.."设置成功","#00ff00")
    sendluamsg(actor, this.msgId ,{1,data})
end

function LianJi.FangAnChange(actor,data)
    if not LianJi.checkOpen(actor) then
        API.SendCenterMsg(actor,"连击未解锁，请使用"..this.TotalConfig.unlockItemName.."解锁")
        return
    end
    data = API.tblkeytonumber(data)
    local baseCareer = getbaseinfo(actor,"getbasecareer")
    local conf = this.TotalConfig.list[baseCareer][data.fangan];
    if conf == nil then
        API.SendCenterMsg(actor,"连击配置为nil，请联系管理员，basecareer="..baseCareer.." fangan="..data.fangan,nil,true)
        return
    end
    for i=1,#data do 
        local skillName = ConfigDataManager.getTableValue("cfg_skill", "name", "id", data[i]);
        if not table.hasValue(conf[i],skillName) then
            API.SendCenterMsg(actor,skillName.."不能设置")
            return
        end
    end
    API.SetTable(actor,DBVar,data)
    API.SendCenterMsg(actor,"连击方案替换成功","#00ff00")
    sendluamsg(actor, this.msgId ,{1,data})
end

--onHandlereQuest中已移除的请求处理
    -- elseif sMsg[1] == 1 then
    --     LianJi.LianJiChange(actor, sMsg[2], sMsg[3], sMsg[4])
    -- elseif sMsg[1] == 5 then
    --     LianJi.FangAnChange(actor, sMsg[2])

--]]
