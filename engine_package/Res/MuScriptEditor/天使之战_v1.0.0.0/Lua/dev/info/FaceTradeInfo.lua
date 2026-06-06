---@class FaceTradeInfo 面对面交易info
FaceTradeInfo = class()
local this = FaceTradeInfo

function this:ctor()

end

function this:Reset()
    self.applyRoleData = nil
    self.tradeTargetRoleId = nil
end

function this:Init()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    local Global = SL:GetConfig("cfg_global", 690002)
    self.applyCd = tonumber(Global.value) * 1000
    local Global2 = SL:GetConfig("cfg_global", 690003)
    self.applyCountDown = tonumber(Global.value) * 1000
end

---判断申请交易CD 及更新CD
function this:CheckApplyCD()
    local now = Time.GetServerTime()
    if not self.lastApplyTime then
        self.lastApplyTime = now
        return false
    elseif self.lastApplyTime + self.applyCd <= now then
        self.lastApplyTime = now
        return false
    end
    return true, self.applyCd - (now - self.lastApplyTime)
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_FACE_TRADE_APPLY, self.RES_FACE_TRADE_APPLY, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_FACE_TRADE_START, self.RES_FACE_TRADE_START, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_FACE_TRADE_SUCCESS, self.RES_FACE_TRADE_SUCCESS, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_FACE_TRADE_CANCEL, self.RES_FACE_TRADE_CANCEL, self)
end
--交易申请
function this:RES_FACE_TRADE_APPLY(_, message)
    self.applyRoleData = {}
    self.applyRoleData.roleId =  tonumber(message.rid)
    self.applyRoleData.name = message.name
    self.applyRoleData.time = Time.GetServerTime() + self.applyCountDown
    SL:onLUAEvent(LUA_EVENT_BUBBLETIPS_ADD, {id = PopoverType.Tip_FaceTrade})
end
--获取交易提示弹窗文本
function this:GetApplyTipText()
    local str = SL:GetConfig("cfg_string", 59002).text
    local result = string.format(str, self.applyRoleData and self.applyRoleData.name or "")
    return result
end
--判断能否与当前申请交易的玩家交易
function this:CheckTradeApplyCondition()
    if self.applyRoleData then
       local role = SL:GetRoleById(self.applyRoleData.roleId)
       return self:CheckRoleDisCanTrade(role)
    end
    return false
end
--获取当前申请的自动结束时间
function this:GetApplyCountDown()
    if self.applyRoleData then
       return self.applyRoleData.time
    end
end
--获取当前状态是否能交易（对方位置）
function this:CheckRoleDisCanTrade(role)
    if role then
        local targetPos = role.data.OldCoord
        local mePos = SL:GetMetaValue(EMetaVarGetKey.MAP_PLAYER_POS)
        local dis = SL:GetPointDistance(mePos, targetPos)
        local need = tonumber(SL:GetConfig("cfg_global", 690001).value)
        if dis <= need then
            return true 
        end
    end
    return false
end
--交易开始
function this:RES_FACE_TRADE_START(_, message)
    self.tradeTargetRoleId = message.targetRid
    local role = SL:GetRoleById(tonumber(SL:GetMetaValue(EMetaVarGetKey.USER_ID)))
    if role then
        role.onArrive = nil
    end
    SL:StopOnHook(true)
    SL:Me_StopMove(true, true)
    GUI:UIPanel_Close("dev/ui/FriendSys/Panel/KLFriendMain/KLFriendMainPanel")
    GUI:UIPanel_Close("dev/ui/Chat/Panel/KLUIChatPanel/KLUIChatPanel")
    GUI:UIPanel_Open("dev/outui/FaceTrade/Panel/KLFaceTrade/KLFaceTradePanel")
end
--获取交易对象名字
function this:GetTradeTargetName()
    if self.tradeTargetRoleId then
        local role = SL:GetRoleById(self.tradeTargetRoleId)
       if role then
            return role.data.name
       end
    end
    return ""
end
--交易成功
function this:RES_FACE_TRADE_SUCCESS(_, message)
    GUI:UIPanel_Close("dev/outui/FaceTrade/Panel/KLFaceTrade/KLFaceTradePanel")
    self.applyRoleData = nil
    self.tradeTargetRoleId = nil
    SL:TipMessage("交易成功！", 1, NoticeType.NoticeMid)
end
local CALCEL_TYPE = {
    DEFAULT = -1,           -- 交易状态异常
    TARGET_NOT_EXIST = 0,   -- 对方玩家不存在
    PLAYER_DEAD = 1,        -- 交易参与方已死亡
    TIMEOUT = 2,            -- 交易超时
    NO_TRADE_ITEM = 3,      -- 没有可交易的物品
    INVALID_TRADE_ITEM = 4, -- 交易物品异常
    TRADE_FAILED = 5,       -- 交易失败
    CANCELLED = 6,          -- 主动交易取消
    OFFLINE = 7,            -- 对方玩家已下线
    DISTANCE_TOO_FAR = 8,   -- 交易距离过远
}
--交易取消
function this:RES_FACE_TRADE_CANCEL(_, message)
    GUI:UIPanel_Close("dev/outui/FaceTrade/Panel/KLFaceTrade/KLFaceTradePanel")
    self.applyRoleData = nil
    self.tradeTargetRoleId = nil
    local reason = message.reason
    if reason == CALCEL_TYPE.DEFAULT or reason == CALCEL_TYPE.TARGET_NOT_EXIST or reason == CALCEL_TYPE.PLAYER_DEAD
        or reason == CALCEL_TYPE.INVALID_TRADE_ITEM or reason == CALCEL_TYPE.TRADE_FAILED or reason == CALCEL_TYPE.CANCELLED
            or reason == CALCEL_TYPE.OFFLINE then
        local txt = SL:GetConfig("cfg_string", 59007).text
        SL:TipMessage(txt, 1, NoticeType.NoticeMid) 
    elseif reason == CALCEL_TYPE.TIMEOUT then
        SL:CommonTipsMessage({stringTblID = 59006, title = "提示"})
    elseif reason == CALCEL_TYPE.DISTANCE_TOO_FAR then
        local txt = SL:GetConfig("cfg_string", 59001).text
        SL:TipMessage(txt, 1, NoticeType.NoticeMid) 
    elseif reason == CALCEL_TYPE.NO_TRADE_ITEM then
        SL:TipMessage("没有可交易的物品", 1, NoticeType.NoticeMid)
    end
end

---@param data KLTradeGoodsItemData
function this.SetTradeTime(data, nowTime)
    -- 公示结束时间 = 商品上架时间 + 公示时间段
    local publicityEndTime = data.listingTime + data.publicityTime
    -- 下架结束时间 = 公示结束时间 + 竞拍时间段
    local offShelfEndTime = publicityEndTime + data.upShelfDuration
    -- 如果公示时间段未结束，则显示公示时间
    if publicityEndTime > nowTime then
        data.time = math.ceil((publicityEndTime - nowTime) / 1000)
    elseif publicityEndTime < nowTime and offShelfEndTime > nowTime then -- 如果过了公示期，则显示下架时间
        data.time = math.ceil((offShelfEndTime - nowTime) / 1000)
    end
end