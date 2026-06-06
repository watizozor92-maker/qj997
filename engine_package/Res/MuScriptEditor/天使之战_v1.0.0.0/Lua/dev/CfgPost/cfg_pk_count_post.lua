---@class cfg_pk_count_post @注释
cfg_pk_count_post = class()
local this = cfg_pk_count_post
this.isInit = false
this.pkInfo = {}
---@return void @使用时才调用
--- 存储需要展示的人物属性l
function this.InitOnUse()
    if this.isInit then
        return
    end
    this.isInit = true
    local cfg = SL:GetConfigTable('cfg_pk_count')
    if cfg then
        ---@param v cfg_pk_count_column
        for k, v in pairs(cfg) do
            local minCount = v.nameColor[1]
            local maxCount = v.nameColor[2]
            local nameColor = v.nameColor[3]
            this.pkInfo[v.id] = {minCount=minCount,maxCount=maxCount,nameColor=nameColor,level=v.id,label=v.label,
                                 displayColor=v.displayColor,redNameNeed=v.redNameNeed,shopPurchase = v.shopPurchase,mapTransmission = v.mapTransmission,tbl =v}
        end 
    end
end

---通过pk值获取pk数据
function this.GetPkInfoByPkValue(pkValue)
    if not pkValue then
        SL:Log("pkvalue is nil")
        return nil
    end
    
    local level = 0
    local data = nil
    for i, v in pairs(this.pkInfo) do
        if v and v.minCount and v.level then
            if tonumber(v.minCount) <= tonumber(pkValue) and v.level > level then
                level = v.level
                data = v
            end
        end
    end
    return data
end

---通过pk值，红名阈值获取对应信息
---@return cfg_pk_count_column
function this.GetInfoByRedNamePkValue(pkValue)
    if not pkValue then
        SL:Log("pkvalue is nil")
        return nil
    end
    local len = #this.pkInfo
    for i = len, 1,-1 do
        if tonumber(pkValue) >= this.pkInfo[i].redNameNeed  then
            return SL:GetConfig('cfg_pk_count',i)
        end
    end
end

function this.GetPkValueNameColor(value)
    if not value then
        SL:Log("pkvalue is nil")
        return nil
    end
    local data = this.GetPkInfoByPkValue(value)
    local nameColor = data and data.nameColor
    local color
    if nameColor then
        local colorTabl = SL:GetConfig("cfg_color",nameColor)
        color = SL:ConvertColorFromHexString(colorTabl.color)
    end
    return color
end

function this.GetPkValueRedNameColor(value)
    if not value then
        SL:Log("pkvalue is nil")
        return nil
    end
    local data = this.GetPkInfoByPkValue(value)
    local displayColor = data and data.displayColor
    local color
    if displayColor and displayColor ~= 0 then
        ---@type cfg_color_column
        local colorTabl = SL:GetConfig("cfg_color",displayColor)
        color = SL:ConvertColorFromHexString(colorTabl.color)
    end
    return color
end


this.InitOnUse()