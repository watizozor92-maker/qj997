Equip_TaoZhuang = {}
local this = Equip_TaoZhuang
local filename = "Equip_TaoZhuang"

function this.getData(actor)
    local tab = {}
    local data = this.tData

    return tab
end

--刷新套装装备额外属性
function this.sendAttr(actor,itemId,cfgId)
    local tab = {}
    local tTaoZhuangEWai = API.GetItemData(actor,itemId, "tTaoZhuangEWai") or {}
    if not next(tTaoZhuangEWai) then
        return tab
    end

    local pct = EquipDurability.getNowDurabilityPct(actor,itemId,cfgId)
    if pct <= 0 then
        return tab
    end
    
    for _, v in pairs(tTaoZhuangEWai) do
        local att = string.split(v, "#")
        local attId = att[1]
        local val = att[2]
        if tab[attId] then
            tab[attId] = tab[attId] + val
        else
            tab[attId] = val
        end
    end
    
    return tab
end

--设置装备套装额外属性
function this.setEquipTaoZhuangEWaiAtt(actor, itemId, itemCfgId, suitAtt)
     --10000#10004#5#10#15|10002#10005#10
    local tab = {}
    local data = string.split(suitAtt, "|")
    for _, info in ipairs(data) do
        local value = string.split(info, "#")
        local r = math.random(1, 10000)
        if r < tonumber(value[1]) then
            local attId = value[2]
            local valueRIndex = math.random(1, #value - 2)
            local valueNum = value[valueRIndex + 2]
            table.insert(tab, attId .. "#" .. valueNum)
        end
    end
    API.SetItemData(actor,itemId,"tTaoZhuangEWai", tab)
end

--物品进入背包后
GameEvent.add(EventCfg.addbag,function(actor, itemId, itemCfgId, index)
    local suitAtt = ConfigDataManager.getTableValue("cfg_equip_entryLib", "suitAtt", "id", itemCfgId) or ""

    local IsSetTaoZhuangEWai = API.GetItemData(actor,itemId,"IsSetTaoZhuangEWai") or 0
    IsSetTaoZhuangEWai = tonumber(IsSetTaoZhuangEWai)
    if IsSetTaoZhuangEWai == 0 and not string.isNullOrEmpty(suitAtt) then
        this.setEquipTaoZhuangEWaiAtt(actor, itemId, itemCfgId, suitAtt)
        API.SetItemData(actor,itemId,"IsSetTaoZhuangEWai", 1)
    end
end,filename)