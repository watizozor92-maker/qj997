---@class KLUnionActivityItem:UIKmlLuaPanelBase
---@field view KLUnionActivityItemView
local KLUnionActivityItem = class(UIKmlLuaPanelBase)
local this =KLUnionActivityItem
---创建时调用一次
function this:Init()
    self.activityId = self.args.activityId
    self.isOpen = false
    GUI:setVisible(self.view.ImgOpen, false)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    ---@type cfg_activity_rule_column
    local tbl = SL:GetConfig("cfg_activity_rule", self.activityId)
    GUI:Text_setText(self.view.Text_Name, tbl.name)
    GUI:Text_setString(self.view.TxtOpenTime, tbl.timeText)
    GUI:Text_setString(self.view.TxtLimit, tbl.uiTextSynopsis)
    --GUI:Image_loadTexture(self.view.Bg, tbl.unionUiBg,"Atlas/FG_Union.spriteatlas")
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Bg, self, self.ActivityOnClick)
end

function this:SetOpen(isOpen)
    self.isOpen = isOpen
    GUI:setVisible(self.view.ImgOpen, isOpen)
    GUI:setVisible(self.view.OpenTips, not isOpen)
end

function this:ActivityOnClick()
    if not self.isOpen then
        SL:TipMessage(SL:GetConfig('cfg_string',250).text, 1, NoticeType.NoticeMid)--"活动未开启",
        return
    end
    ---@type cfg_activity_rule_column
    local tbl = SL:GetConfig("cfg_activity_rule", self.activityId)
    ---狼魂要塞
    if tbl.id == EActivityType.WolfSoulFortress then

        ---没有公会
        if SL:MeData_GetUnionId() == 0 then
            SL:TipMessage( SL:GetConfig('cfg_string', 433).text, 1, NoticeType.NoticeMid )
            return
        end
        ---@type cfg_rep_column
        local tempTbl = InfoManager.wolfSoulFortressInfo:GetCfgByOpenServerDay()
        if tempTbl then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ENTER_DUPLICATE, tempTbl.id)
        end
    else
        if tbl.panel[1] == "transferMapAndLine" then
            local mapMoveId = tonumber(tbl.panel[2])
            local mapMoveTbl = SL:GetConfig("cfg_mapMove", mapMoveId)
            local map_info = SL:GetConfig("cfg_map_info", mapMoveTbl.mapID)
            local cost = map_info.transferCost
            local conditionCheck2
            if cost and cost[1] and cost[1][2] then
                local transmissionCost = InfoManager.redNameInfo:GetMapTransmissionCost()
                conditionCheck2 = cost[1][2] * transmissionCost <= SL:GetBagItemCount(cost[1][1])
            else
                conditionCheck2 = true
            end
            if not conditionCheck2 and not table.isNullOrEmpty(cost) then
                SL:CommonItemGetPath(nil, cost[1][1])
                SL:TipMessage("消耗金币不满足，无法传送", 1, NoticeType.NoticeMid)
                return
            end
        end
        shortcutOutMgr.DO(tbl.panel)
        --SL:ShortcutDO(tbl.panel)
    end
end

function this:Close()
end

return this
