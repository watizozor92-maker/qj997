Equip_XingYun = {}
local this = Equip_XingYun

function this.XingYun(actor,msgData)
    local itemId = msgData.itemId
     local cfgId = msgData.cfgId

    local lv = API.GetItemData(actor,itemId,"IsLuck") or 0
    local equip = getequipinfo(actor, itemId, 1)
    if equip == nil then
        messagebox(actor,"道具不存在")
        return
    end

    -- 查找的追加配置
    info("this.XingYun start1 cfgId:",tostring(cfgId))
    local groupId = ConfigDataManager.getTableValue("cfg_equip_luck","costId","id",cfgId)
     if groupId==nil or groupId=="" then
        messagebox(actor,"当前不支持幸运属性")
        return
    end
    local costValue = ConfigDataManager.getTableFirst("cfg_equip_luckCost_v2","costGroupId",groupId,"level",lv)

    if lv == 1 then
        messagebox(actor,"已激活幸运！")
        return
    end

      if table.isNullOrEmpty(costValue) then
        messagebox(actor,"当前装备无幸运属性")
        return
    end


    --消耗
    local cost = string.toIntIntMap(costValue.costtag, "#", "|")
    local enough = Bag.checkCostMap(actor, cost)
     --info("this.XingYun enough:",tostring(enough))
    if enough == false then
        messagebox(actor,"材料不足！")
        return
    end

        --扣材料
    Bag.costMap(actor, cost, "激活装备幸运属性")

    --概率
     local gailv =tonumber( costValue.rate)
     local result=0
    if math.random(1,10000) > gailv then
        --    info("this.XingYun result:",tostring(result),"lv:",tostring(gailv))
        -- messagebox(actor,"激活装备幸运属性失败！")
        sendluamsg(actor, LuaMessageIdToClient.RES_ACTIVATE_EQUIP_LUCKY_RESULT, { issuccess = false })
        return 
    end
    if not equip.isbind and EquipAndAppear.isBindCost(cost) then
        EquipAndAppear.updateBindState(actor, itemId, cfgId)
    end
    local att = ConfigDataManager.getTableValue("cfg_equip_luckGroup", "att", "group", groupId, "lv", lv + 1)
    local tAttr = string.toIntIntMap(att, "#", "|")
    this.setEquipXingYunAttr(actor, itemId, tAttr)

    --刷新幸运装备属性
    EquipAndAppear.updateluaextattr(actor)
    sendluamsg(actor, LuaMessageIdToClient.RES_ACTIVATE_EQUIP_LUCKY_RESULT, { issuccess = true })
    --Equip_AllExtAtt.sendAttr(actor, itemId, cfgId)
end

-- 设置幸运属性
function this.setEquipXingYunAttr(actor,itemId, tAttr)
    API.SetItemData(actor,itemId,"IsLuck",1)
    if tAttr then
        API.SetItemData(actor, itemId, "luckAttr", tAttr)
    end
    --通知客户端更新
    --this.RefreshLevel(actor)
end

--刷新幸运装备属性
function this.sendAttr(actor,itemId,cfgId)
    local tab = {}
    
    local lv = API.GetItemData(actor,itemId,"IsLuck") or 0 
    if lv <= 0 then
        return tab
    end

    local pct = EquipDurability.getNowDurabilityPct(actor,itemId,cfgId)
    if pct <= 0 then
        return tab
    end

    local equipInfo = getequipinfo(actor,itemId,1)
    local cfgId= equipInfo.cfgid
    -- 查找的追加配置
    local groupId = ConfigDataManager.getTableValue("cfg_equip_luck","groupId","id",cfgId)
    local att = ConfigDataManager.getTableValue("cfg_equip_luckGroup","att","group",groupId,"lv",tonumber(lv))
    local tAttr = string.toIntIntMap(att, "#", "|")

    for k,v in pairs(tAttr) do 
        local attId = k
        local val =v
        if tab[attId] then
            tab[attId] = tab[attId] + val 
        else
            tab[attId] = val 
        end
    end
    
    return tab
end

function Equip_XingYun.getRate(cfgId, IsLuck, costTag)
    if IsLuck ~= 1 then
        return 0
    end
    local groupId = ConfigDataManager.getTableValue("cfg_equip_luck", "groupId", "id", cfgId)
    local luckrate = ConfigDataManager.getTableValue("cfg_equip_luckGroup", "luckrate", "group", groupId, "lv", IsLuck)
    local str1 = string.split(luckrate, "|")
    local itemIds = string.splitInt(str1[1])
    local rate = tonumber(str1[2])
    for id, count in pairs(costTag) do
        if table.contains(itemIds, id) then
            return rate
        end
    end
    return 0
end

function this.isXingYunEquip(actor, itemId)
    local lv = API.GetItemData(actor, itemId, "IsLuck") or "0"
    lv = tonumber(lv)
    return lv >= 1
end