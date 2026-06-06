---@class MainActivityInfo
MainActivityInfo = class()
local this = MainActivityInfo

function this:ctor()
end

function this:Reset()
    self.mainActivityRedsTbl = {}
end

function this:Init()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    self.mainActivityRedsTbl = {}
    local togDataList = SL:GetConfigTable("sub_mainActivity")
    table.sort(togDataList,function(a,b)
        return a.sortId < b.sortId
    end)
    for _, v in pairs(togDataList) do
        self.mainActivityRedsTbl[v.togName] = false
    end
end

---刷新活动主界面按钮红点以及子页签红点
---togName sub_mainActivity表内字段
---isShow是否展示红点 true展示
function this:RefreshMainActivityRedPoint(togName,isShow)
    InfoManager.mainActivityInfo.mainActivityRedsTbl[togName] = isShow
    SL:RefreshPanelALLRedStateKmlByCondition("checkMainActivityRed")
    local panel = GUI:GetUI("dev/outui/MainActivity/Panel/KLMainActivity/KLMainActivityPanel")
    if panel then
        panel:RefreshTogRedPointShow()
    end
end

function this:RegistMessages()
    
end

---@param data table sub表数据
---获取活动结束开服天数
function this:GetActivityEndDay(data)
    local condition = data.showCondition
    local conditionTbl = string.split(condition,"&")
    for _, v in pairs(conditionTbl) do
        local conditions = string.split(v,"#")
        if tonumber(conditions[1]) == 903 then
            return tonumber(conditions[2])
        end
    end
    return 0
end

---@param days number 开服第几天 活动结束的开服天数
---@param hour number 第几个小时 0代表0点
---获取活动结束倒计时 秒
function this:ShowActivityDJSFunc(days,hour)
    local endTime = SL:GetEndTimeStamp(days,hour)
    local nowTime = Time.GetServerTime()
    local countdown = (endTime - nowTime) / 1000
    countdown = Mathf.Max(0, countdown)
    countdown = math.floor(countdown)
    return countdown
end
