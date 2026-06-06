---@class KLActivityPreviewItem:UIKmlLuaPanelBase
---@field view KLActivityPreviewItemView
---@field data {leftTime:number,id:number,open:boolean,cfg:cfg_activity_rule_column,isPreview:boolean}
local KLActivityPreviewItem = class(UIKmlLuaPanelBase)
local this = KLActivityPreviewItem
---创建时调用一次
function this:Init()
    local rect = GUI:GetRectTransform(self.view.textTime)
    rect.sizeDelta = Vector2.New(14, 20)
    --[[self.stationaryTextList = { self.view.activityName, self.view.textTime }
    self.staTextColor = "#6FFF3D"]]
end

function this:InitData(index, data)
    self.index = index
    self.data = data 
end
---创建或者刷新界面数据时调用
function this:Refresh()
    
end

function this:Show()
    local grayColors = "#7F621A"
    if SL:HasConfig("cfg_global", 580001, "id") then
        grayColors = SL:GetConfig("cfg_global", 580001, "id").value
    end
    InfoManager.activityPreviewInfo:AddBlink(self.view.activityName, "#6FFF3D", grayColors)
    InfoManager.activityPreviewInfo:AddBlink(self.view.textTime, "#6FFF3D", grayColors)
end

function this:Hide()
    InfoManager.activityPreviewInfo:RemoveBlink(self.view.activityName)
    InfoManager.activityPreviewInfo:RemoveBlink(self.view.textTime)
end

function this:RefreshItem()
    local str = "恶魔广场 — ⭐⭐01:59:59⭐⭐ — >>立即前往<<,恶魔广场 — 【即将开放】  — ⭐⭐⭐09:59⭐⭐⭐"
    if self.data and self.data.cfg then
        if not self.timer then
            self.timer = SL:Schedule(self.timer,0,1,-1,function()
                local activeName = self.data.cfg.name

                local showTime = self.data.leftTime - Time.GetServerTime()
                if showTime < 0 then
                    if not self.isShowTimeOver then
                        self.isShowTimeOver = true
                        if self.timer then
                            --Timer.Stop(self.timer)
                            SL:UnSchedule(self.timer)
                            self.timer = nil
                        end
                        SL:onLUAEvent(LUA_EVENT_ACTIVITYPREVIEW_CHANGE)
                        self.isShowTimeOver = false
                    end
                    return
                end
                if self.data.open then
                    GUI:SetActive(self.view.btnGoNpc,true)
                    GUI:Text_setString(self.view.activityName, activeName.." -★★★"..Time.FormatTimeMS(math.ceil(showTime)).."★★★- >>立即前往<<")
                else
                    GUI:SetActive(self.view.btnGoNpc,false)
                    GUI:Text_setString(self.view.activityName, activeName.." - 【即将开放】 -★★"..Time.FormatTimeMS(math.ceil(showTime)).."★★")
                end
                GUI:ForceRebuildLayoutImmediate(self.view.activityName)
                local w = GUI:GetWidth(self.view.activityName)
                GUI:setContentSize(self.view.Bg, w, 20)
            end,self)
        end
    end
    
end

function this:RefreshTimeText()
    if not self.data then
        return
    end

    local showTime = self.data.leftTime - Time.GetServerTime()
    if showTime < 0 then
        if not self.isShowTimeOver then
            self.isShowTimeOver = true
            if self.timer then
                --Timer.Stop(self.timer)
                SL:UnSchedule(self.timer)
                self.timer = nil
            end
            SL:onLUAEvent(LUA_EVENT_ACTIVITYPREVIEW_CHANGE)
            self.isShowTimeOver = false 
        end
        return
    end
    return showTime
    --GUI:Text_setString(self.view.textTime, Time.FormatTimeHMS(math.ceil(showTime)))
end

function this:SetActiveUI(val)
    GUI:SetActive(self.view.root, val)
end

----@return boolean
function this:GetActiveUI(val)
    return GUI:getVisible(self.view.root)
end
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnGoNpc, self, self.OnClickGoNpc)
end

function this:OnClickGoNpc()

    local tbl = SL:GetConfig("cfg_activity_rule", self.data.cfg.id)
    SL:ShortcutDO(tbl.activitypanel)
    --GUI:UIPanel_Open("dev/ui/Preview/Panel/KLPreview/KLPreviewPanel",nil,nil,{togType=2})
--[[    if self.data and self.data.cfg then
        --狼魂要塞
        if self.data.cfg.id == EActivityType.WolfSoulFortress then
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
            local cond, message = InfoManager.godsDescendInfo.CheckActivityCondition(self.data.cfg.id)
            if cond then
                ---@type cfg_activity_rule_column
                local tbl = SL:GetConfig("cfg_activity_rule", self.data.cfg.id)
                if tbl.mapid and table.count(tbl.mapid) >0 then
                    if tbl.mapid[1] == 21000 then
                        local cond, message = InfoManager.godsDescendInfo.CheckActivityConditionMapId(self.data.cfg.id)
                        if cond then
                            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GOTO_CROSS_MAP,{})
                        else
                            SL:TipMessage(message, 1, NoticeType.NoticeMid)
                        end
                        return
                    end
                end
                SL:ShortcutDO(tbl.panel)
            else
                SL:TipMessage( message, 1, NoticeType.NoticeMid )
            end
            --SL:ShortcutDO(self.data.cfg.panel)
        end
    end]]
end

function this:Close()
    if self.timer then
        --Timer.Stop(self.timer)
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    InfoManager.activityPreviewInfo:RemoveBlink(self.view.activityName)
    InfoManager.activityPreviewInfo:RemoveBlink(self.view.textTime)
end

return this
