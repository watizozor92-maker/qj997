---@class QJAcademyInfo @攻略玩法红点
---@field gamePlayRedDot @玩法红点
QJAcademyInfo = class()
local this = QJAcademyInfo

function this:ctor()

end

function this:Init()
    self:Reset()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    ---预览红点
    self.previewRedDot = false
end

function this:RegistMessages()
    SL:RegisterLUAEvent(LUA_EVENT_ME_CREATE_SUCCESS, self.LUA_EVENT_ME_CREATE_SUCCESS, self)
end

function this:Reset()
    self.gamePlayRedDot = nil
end

function this:LUA_EVENT_ME_CREATE_SUCCESS()
    self:LoadPreviewRedDot()
end


--[[function this:SetKingOfRoadRedDot(show)
    self.kingOfRoadRedDot = show
    SL:RefreshPanelALLRedStateKmlByCondition("checkKingOfRoad")
end]]

function this:GetPreviewRedDotRedDot()
    return self.previewRedDot
end

---获取攻略红点
function this:GetGuideRedDot()
    local cfgInfo = SL:GetConfigTable("cfg_preview")
    local info
    --第一个大于等级的
    if cfgInfo then
        local tempCfgInfo = SL:CopyData(cfgInfo)
        table.sort(tempCfgInfo, function(a, b)
            return a.completionLevel > b.completionLevel
        end)
        for k, v in pairs(tempCfgInfo) do
            if SL:MeData_GetLevel() >= v.completionLevel and not SL:TaskInfo_GetPreviewRewardInfo()[v.id] then
                SL:onLUAEvent(LUA_EVENT_PREVIEW_OPEN, v.id)
            end
            if SL:MeData_GetLevel() >= v.showLevel and (SL:MeData_GetLevel() < v.hideLevel or not SL:TaskInfo_GetPreviewRewardInfo()[v.id]) then
                info = v
                break
            end
        end

        for i, v in pairs(tempCfgInfo) do
            if SL:MeData_GetLevel() >= v.showLevel and SL:MeData_GetLevel() >= v.completionLevel and not SL:TaskInfo_GetPreviewRewardInfo()[v.id] then
                return true, info
            end
        end
    end
    return false, info
end

---获取游戏玩法红点
function this:GetGamePlayRedDot()
    local tbl = SL:GetConfigTable("cfg_gamePlay")
    ---@param  v cfg_gameplay_column
    for i, v in pairs(tbl) do
        if SL:MeData_GetLevel() >= v.showLevel and SL:MeData_GetLevel() < v.hideLevel then -- 已解锁
            if self.gamePlayRedDot[v.id] == nil then --没有这个红点记录
                return true
            end
        end
    end

    return false
end

function this:SetPreviewRedDot(id)
    if self.gamePlayRedDot[id] then
        return
    end
    self.gamePlayRedDot[id] = id
    SL:RefreshPanelALLRedStateKmlByCondition("checkGamePlay")
end

function this:HasPreviewRedDotById(id)
    return self.gamePlayRedDot[id] == nil
end

function this:LoadPreviewRedDot()
    if self.gamePlayRedDot then
        return
    end
    ---预览红点
    self.gamePlayRedDot = {}
    local redDotStr = PlayerPrefs.GetString("GamePlayRedDot".. SL:MeData_GetId(), "")
    local redDots = string.split(redDotStr, ',')
    for i = 1, #redDots do
        local cfgid = tonumber(redDots[i])
        self.gamePlayRedDot[cfgid] = cfgid
    end
end

function this:SavePreviewRedDot()
    local temp = {}
    for i, v in pairs(self.gamePlayRedDot) do
        table.insert(temp, v)
    end
    local redDotStr = table.concat(temp, ',')
    PlayerPrefs.SetString("GamePlayRedDot".. SL:MeData_GetId(), redDotStr)
    PlayerPrefs.Save()
end