---@class MainRechargeInfo
---@field roleTotalMoney number 角色充值总金额
MainRechargeInfo = class()
local this = MainRechargeInfo

this.roleTotalMoney = 0
function this:ctor()
end

function this:Reset()
    self.mainRechargeRedsTbl = {}
end

function this:Init()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    self.mainRechargeRedsTbl = {}
    local togDataList = SL:GetConfigTable("sub_mainRecharge")
    table.sort(togDataList,function(a,b)
        return a.sortId < b.sortId
    end)
    for _, v in pairs(togDataList) do
        self.mainRechargeRedsTbl[v.togName] = false
    end
end

---刷新福利主界面按钮红点以及子页签红点
---togName sub_mainRecharge表内字段
---isShow是否展示红点 true展示
function this:RefreshMainRechargeRedPoint(togName,isShow)
    -- InfoManager.mainRechargeInfo.mainRechargeRedsTbl[togName] = isShow
    -- SL:RefreshPanelALLRedStateKmlByCondition("checkMainRechargeRed")
    -- local panel = GUI:GetUI("dev/outui/MainRecharge/Panel/KLMainRecharge/KLMainRechargePanel")
    -- if panel then
    --     panel:RefreshTogRedPointShow()
    -- end
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RECHARGE_ACTION,self.RefreshRoleMoney,self)
end

function this:RefreshRoleMoney(_,msg)
    if not table.isNullOrEmpty(msg) then
        if msg.type == "0" and msg.action == "record" then --通用协议内后端给的标识
                self.roleTotalMoney = msg.data.totalMoney or 0
        end 
    end
end
