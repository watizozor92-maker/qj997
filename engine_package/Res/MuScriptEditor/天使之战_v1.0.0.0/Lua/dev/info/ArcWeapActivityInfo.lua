---@class ArcWeapActivityInfo
ArcWeapActivityInfo = class()
local this = ArcWeapActivityInfo

function this:ctor()
end

function this:Reset()
end

function this:Init()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    self.arcWeapGroup = 0 --当前大天使武器轮数
    self.arcWeapSmallGiftDataTbl = {} --大天使武器任务数据
    self.arcWeapBigGiftDataTbl = {} --大天使武器大奖数据
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ANGEL_WEAPON_TASK_CHANGE,self.RefreshArcWeapData,self)
end

function this:RefreshArcWeapData(_,msg)
    self.arcWeapSmallGiftDataTbl = {}
    self.arcWeapBigGiftDataTbl = {}
    local data = msg
    self.arcWeapGroup = data.taskGroup
    for _, v in pairs(data.taskList) do
        v.weapCdgData = SL:GetConfig("cfg_activity_angelWeapon",v.id)
        if not table.isNullOrEmpty(v.weapCdgData) then
            if v.weapCdgData.angelWeaponType == 1 then --小奖
                table.insert(self.arcWeapSmallGiftDataTbl,v)
            elseif v.weapCdgData.angelWeaponType == 2 then --大奖
                table.insert(self.arcWeapBigGiftDataTbl,v)
            end
        end
    end
    this:JudgeIsShowArcWeapRedPoint(data.taskList)
    SL:onLUAEvent(LUA_ARCWEAPON_ACTIVITY_CHANGE)
end

--判断是否展示大天使武器红点
function this:JudgeIsShowArcWeapRedPoint(msg)
    local isShowRedPoint = false
    local data = msg
    for _, v in pairs(data) do
        if v.giftState == E_RechargeState.CanGet then
            isShowRedPoint = true
            break
        end
    end
    InfoManager.mainActivityInfo:RefreshMainActivityRedPoint("tog_ArcWeapActivity",isShowRedPoint)
end
