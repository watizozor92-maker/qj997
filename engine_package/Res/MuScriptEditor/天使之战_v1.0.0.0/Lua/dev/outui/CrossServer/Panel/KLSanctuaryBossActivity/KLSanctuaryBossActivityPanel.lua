---@class KLSanctuaryBossActivityPanel:UIKmlLuaPanelBase
---@field view KLSanctuaryBossActivityPanelView
local KLSanctuaryBossActivityPanel = class(UIKmlLuaPanelBase)
local this = KLSanctuaryBossActivityPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    ---@type cfg_activity_rule_column
    local tab = SL:GetConfig("cfg_activity_rule", 25001)
    if tab then
        ---@type cfg_map_info_column
        local mapTab = SL:GetConfig("cfg_map_info", tab.mapid[1])
        local message = ""
        self.level_lock = false
        self.strength_lock = false
        self.append_lock = false
        self.open_level = 0
        if mapTab and #mapTab.condition > 0 then
            local condition = mapTab.condition
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
        GUI:Text_setString(self.view.tishi, message)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.join_btn, self, self.JoinOnclick)
end

function this:JoinOnclick()
    if self.level_lock then
        SL:TipMessage(self.open_level .. "级开启，无法进入", 1, NoticeType.NoticeMid)
        return
    end
    if self.strength_lock then
        SL:TipMessage(SL:GetConfig('cfg_string', 257).text, 1, NoticeType.NoticeMid)--"全身强化等级不足，无法进入", 
        return
    end
    if self.append_lock then
        SL:TipMessage(SL:GetConfig('cfg_string', 257).text, 1, NoticeType.NoticeMid)--"全身追加等级不足，无法进入",
        return
    end
    GUI:UIPanel_Close("dev/outui/CrossServer/Panel/KLCrossServerMain/KLCrossServerPanel")
    GUI:UIPanel_Close("dev/outui/CrossServer/Panel/KLSanctuaryBossActivity/KLSanctuaryBossActivityPanel")
    SL.ShowMainPanel()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GOTO_CROSS_MAP, {})
end

function this:Close()
end

return this
