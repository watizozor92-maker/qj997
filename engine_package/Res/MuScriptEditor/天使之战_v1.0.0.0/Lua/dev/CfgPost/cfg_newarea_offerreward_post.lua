---@class cfg_newarea_offerreward_post @注释
---@field groupInfo table<number,cfg_newarea_offerreward_column[]>
cfg_newarea_offerreward_post = class()
local this = cfg_newarea_offerreward_post
this.isInit = false
this.levelInfo = {}
this.groupRewardInfo = {}
this.groupInfo = {}
---@return void @使用时才调用
--- 存储需要展示的人物属性l
function this.InitOnUse()
    if this.isInit then
        return
    end
    this.isInit = true
    local cfg = SL:GetConfigTable('cfg_newarea_offerreward')
    if cfg then
        ---@param v cfg_newarea_offerreward_column
        for k, v in pairs(cfg) do
            if not table.contains(this.levelInfo,v.level) then
                table.insert(this.levelInfo,v.level)
            end
            if not this.groupRewardInfo[v.level] then
                this.groupRewardInfo[v.level] = v.groupReward
            end
            if not this.groupInfo[v.level] then
                this.groupInfo[v.level] = {}
            end
            table.insert(this.groupInfo[v.level],v)
        end 
    end
end

function this.GetLevelInfo()
    return this.levelInfo
end

function this.GetGroupRewardInfo()
    return this.groupRewardInfo
end

function this.GetGroupInfo()
    return this.groupInfo
end

---@return cfg_newarea_offerreward_column
function this.GetCfgByMonsterId(id)
    return SL:GetConfig("cfg_newarea_offerreward",id,"monsterId")
end

function this.GetGroupIdByLevel(level)
    if not this.groupInfo[level][1] then
        SL:LogError("cfg_newarea_offerreward level="..level.."没有数据")
        return
    end
    return this.groupInfo[level][1].group
end

---@return cfg_newarea_offerreward_column[]
function this.GetLevelMonsterInfo(level)
    if not this.groupInfo[level] then
        SL:LogError("cfg_newarea_offerreward level="..level.."没有数据")
        return
    end
    return this.groupInfo[level]
end

this.InitOnUse()