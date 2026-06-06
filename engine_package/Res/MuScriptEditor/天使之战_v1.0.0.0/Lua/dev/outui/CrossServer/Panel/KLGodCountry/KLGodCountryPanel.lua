---@class  KLGodCountryPanel:UIKmlLuaPanelBase
---@field view  KLGodCountryPanelView
local  KLGodCountryPanel = class(UIKmlLuaPanelBase)
local this =  KLGodCountryPanel
---创建时调用一次
function this:Init()
    local mapid = SL:GetConfig("cfg_activity_rule",20001).mapid[1]
    local message = ""
    self.level_lock = false
    self.strength_lock = false
    self.append_lock = false
    self.open_level = 0
    
    local tab = SL:GetConfig("cfg_map_info",mapid)
    if tab.condition and #tab.condition > 0 then
        local condition = tab.condition
        local level = condition[1]
        local strength_level = condition[2]
        local append_level = condition[3]
        local player_level = SL:GetMetaValue("LEVEL")
        local all_strength_level = EquipFunc.GetAllStrengthLevel()
        local all_append_level = EquipFunc.GetAllAppendLevel()
        if player_level < level then
            message = message .. "等级" .. level .. "级"
            self.level_lock = true
            self.open_level = level
        end
        if all_strength_level < strength_level then
            if not string.isNullOrEmpty(message) then
                message = message .. "，"
            end
            message = message .. "强化总等级" .. strength_level
            self.strength_lock = true

        end
        if all_append_level < append_level then
            if not string.isNullOrEmpty(message) then
                message = message .. "，"
            end
            message = message .. "追加总等级" .. append_level
            self.append_lock = true
        end
        if not string.isNullOrEmpty(message) then
            message = message .. "可进入"
        end
    end
    GUI:Text_setString(self.view.tishi,message)
    -- SL:LogTable(condition,true)
end


---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.join_btn,self,self.JoinOnclick)
end

function this:JoinOnclick()
    if self.level_lock then
        SL:TipMessage( self.open_level.."级开启，无法进入", 1, NoticeType.NoticeMid )
        return
    end
    if self.strength_lock then
        SL:TipMessage( SL:GetConfig('cfg_string',257).text,1, NoticeType.NoticeMid )--"全身强化等级不足，无法进入", 
        return
    end
    if self.append_lock then
        SL:TipMessage(SL:GetConfig('cfg_string',257).text,  1, NoticeType.NoticeMid )--"全身追加等级不足，无法进入",
        return
    end
    -- if not self:IsHavePrivilege() then
    --     SL:TipMessage({ SL:GetConfig('cfg_string',258).text, 1, NoticeType.NoticeLeftBottom })--"<color=#426ECC>月卡时间不足，无法使用地图传送功能</color>",
    --     return
    -- end
    GUI:UIPanel_Close("dev/outui/CrossServer/Panel/KLCrossServerMain/KLCrossServerPanel")
    GUI:UIPanel_Close("dev/outui/CrossServer/Panel/KLGodCountry/KLGodCountryPanel")
    SL.ShowMainPanel()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GOTO_CROSS_MAP,{})
end

function this:IsHavePrivilege()
    if InfoManager.monthCardInfo.IsGetMonthCard or InfoManager.monthCardInfo.IsGetDailyCard then
        --有月卡或是日卡
        return true
    end
    return false
end


function this:Close()
    
end


return this
