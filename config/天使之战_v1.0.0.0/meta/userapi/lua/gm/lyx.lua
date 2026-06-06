--- lyx测试用的gm命令
--- 生成自定义强化追加的装备
function makeequipbystrengthandappend(actor,param)
    local str = string.split(param,"|")
    for i = 1,#str do
        local equip = string.split(str[i],"#")
        local cfgId = equip[1]
        local strength = equip[2]
        local append = equip[3]
        --先校验强化追加等级是否正确
        local maxLevel = ConfigDataManager.getTableValue("cfg_equip_strengthen","maxLevel","id",cfgId)
        if maxLevel and maxLevel ~= "" then
            if tonumber(strength) > tonumber(maxLevel) then
                sendluamsg(actor,LuaMessageIdToClient.TIPS,"请输入正确装备强化数,cfgId->".. cfgId .."强化数".. strength)
                return
            end
        else
            sendluamsg(actor,LuaMessageIdToClient.TIPS,"请输入正确的道具id")
            return
        end
        local maxLv = ConfigDataManager.getTableValue("cfg_equip_appends","maxLevel","id",cfgId)
        if maxLv and maxLv ~= "" then
            if tonumber(append) > tonumber(maxLv) then
                sendluamsg(actor,LuaMessageIdToClient.TIPS,"请输入正确装备追加数,cfgId->".. cfgId .."追加数".. append)
                return
            end
        else
            sendluamsg(actor,LuaMessageIdToClient.TIPS,"请输入正确的道具id")
            return
        end
    end
    --生成装备
    for i = 1,#str do
        local equip = string.split(str[i],"#")
        local cfgId = equip[1]
        local strength = equip[2]
        local append = equip[3]
        local newItemId = additemtobag(actor,cfgId,1)
        --赋值属性
        local equipData = EquipAndAppear.getItemExtData(actor, newItemId)
        if tonumber(strength) > 0 then
            local groupId = ConfigDataManager.getTableValue("cfg_equip_strengthen","groupId","id",cfgId)
            local att = ConfigDataManager.getTableValue("cfg_equip_strengthenGroup","att","group",groupId,"lv",strength)
            if att and att ~= "" then
                local attr = string.putStringStringMap({}, att, "#", "|")
                equipData.strengthattr = attr
                equipData.originalStrengthattr = attr
                equipData.strengthlv = tonumber(strength)
            end
        end
        if tonumber(append) > 0 then
            local groupId = ConfigDataManager.getTableValue("cfg_equip_appends","groupId","id",cfgId)
            local att = ConfigDataManager.getTableValue("cfg_equip_appendsGroup","att","group",groupId,"lv",append)
            if att and att ~= "" then
                local attr = string.putStringStringMap({}, att, "#", "|")
                equipData.appendattr = attr
                equipData.originalAppendattr = attr
                equipData.appendlv = tonumber(append)
            end
        end
        EquipAndAppear.SetItemExtData(actor, newItemId, equipData)
        info(actor,"生成自定义强化追加的装备成功,cfgId->",cfgId,",强化数strengthLv->",strength,",追加数appendLv->",append)
    end
end