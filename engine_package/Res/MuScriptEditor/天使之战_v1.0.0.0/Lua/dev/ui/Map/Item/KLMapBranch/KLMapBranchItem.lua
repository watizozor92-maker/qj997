---@class KLMapBranchItem:UIKmlLuaPanelBase
---@field view KLMapBranchItemView
local KLMapBranchItem = class(UIKmlLuaPanelBase)
local this = KLMapBranchItem
---创建时调用一次
function this:Init()

end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

function this:RefreshUI(line, count, limit, isGold,pkLine,MapId,entryCondition,lineName)
    self.entryCondition = entryCondition
    GUI:setVisible(self.view.root,true) 
    self.mapLine = tonumber(line[2])
    self.MapId = MapId
    self.isGoldMap = isGold
    local map_info = SL:GetConfig("cfg_map_info", self.MapId)
    self.CostCondition = true
    self.cost = map_info.transferCost

    if self.cost and self.cost[1] and self.cost[1][2] then
        self.CostCondition = self.cost[1][2] * InfoManager.redNameInfo:GetMapTransmissionCost() <= SL:GetBagItemCount(self.cost[1][1])
        GUI:Text_setString(self.view.costText, "切线消耗："..self.cost[1][2] * InfoManager.redNameInfo:GetMapTransmissionCost() .. "金币" or "")
        GUI:Text_setTextColor(self.view.costText, self.CostCondition and "#FFFFFF" or "#FF2323")
    end
    GUI:Text_setString(self.view.costText, "")
    GUI:Text_setString(self.view.line_name, line[1]..lineName)
    if not ConditionManager.Check4D(self.entryCondition) then
        GUI:Text_setTextColor(self.view.line_name, "#FF2323")
        
    else
        GUI:Text_setTextColor(self.view.line_name, "#FFFFFF")
    end
    GUI:SetLoadingbar_startper(self.view.line_state,count/limit*100)
    
    if self.mapLine == SL:GetMetaValue(EMetaVarGetKey.MAP_LINE) and ((not isGold and not self:CurrentIsInGoldMap()) or (isGold and self:CurrentIsInGoldMap())) then
        GUI:Toggle_setIsOn(self.view.branch_toggle, true)
        GUI:setVisible(self.view.btn_switch, true)
    else
        GUI:setVisible(self.view.btn_switch, false)
        GUI:Toggle_setIsOn(self.view.branch_toggle, false)
    end
    pkLine = string.split(pkLine,"|")
    if table.contains(pkLine,line[2]) then
        GUI:Toggle_setSrc(self.view.branch_toggle,nil,"Texture/branchMap_new_button_3.png","Texture/branchMap_new_button_2.png")
        GUI:setVisible(self.view.img_pk,true)
    else
        GUI:setVisible(self.view.img_pk,false) 
        GUI:Toggle_setSrc(self.view.branch_toggle,"Atlas/FG_qiexian.spriteatlas","bg_1","bg_2")
    end
    if count/limit >= 1 then
        GUI:Toggle_setSrc(self.view.branch_toggle,"Atlas/FG_qiexian.spriteatlas","bg_3")
    end
    if self.entryCondition and string.contains(self.entryCondition,"2103#27") then ---黄金分线
        GUI:Toggle_setSrc(self.view.branch_toggle,"Atlas/FG_qiexian.spriteatlas","bg_huangjin","bg_2")
        GUI:Text_setTextColor(self.view.line_name, "#E6E600")
    end
end

function this:SetOnValueChange(func, ui)
    GUI:SetToggleOnValueChange(self.view.branch_toggle, ui, function(_,_,eventData,value)
        func(ui,_,eventData)
        if value[1] then
            GUI:setVisible(self.view.btn_switch, true)
        else
            GUI:setVisible(self.view.btn_switch, false)
        end
    end, { data = self.mapLine })
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_switch,self,self.SwitchBranchClick)
end

function this:SwitchBranchClick()
    if not ConditionManager.Check4D(self.entryCondition) then
        if not string.contains(self.entryCondition,"2103#27") then
            SL:TipMessage("线路条件不满足", 1, NoticeType.NoticeMid)
            return
        else
            if not PrivilegeCardManager.isGoldLine2() and not self.isGoldMap then
                SL:OpenCommonTipPanelById(27)
                return
            end
        end
    end
    if not PrivilegeCardManager.isGoldLine() and  self.isGoldMap then
        SL:OpenCommonTipPanelById(26)
        return
    end
    if not PrivilegeCardManager.iswithLine() and  not self.isGoldMap then
        SL:OpenCommonTipPanelById(22)
        return
    end
    
    local tips = InfoManager.redNameInfo:IsLimitTransferById(SL:GetMetaValue("MAIN_ACTOR_ID"),nil,self.mapLine)
    if tips then
        SL:TipMessage(tips, 1, NoticeType.NoticeMid)
        return
    end

    if self.MapId then
        if not self.CostCondition and not table.isNullOrEmpty(self.cost) then
            SL:CommonItemGetPath(nil, self.cost[1][1])
            SL:TipMessage("消耗金币不满足，无法传送", 1, NoticeType.NoticeMid)
            return
        end
        ---@type KLUIMapBranchPanel
        local panel = GUI:GetUI("dev/ui/Map/Panel/KLUIMapBranch/KLUIMapBranchPanel")
        panel:SwitchBranchClick(self.isGoldMap)
    end



end

function this:CurrentIsInGoldMap()
    ---@type cfg_map_info_column
    local infoCfg = SL:GetConfig("cfg_map_info",tonumber(SL:GetMetaValue(EMetaVarGetKey.MAP_ID)))
    return infoCfg.goldmap == 1
end

function this:Close()
end

function this:HideItemUI()
    GUI:setVisible(self.view.root,false) 
end

return this
