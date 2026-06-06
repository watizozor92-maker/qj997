---@class KLBigMapTransferItemItem:UIKmlLuaPanelBase
---@field view KLBigMapTransferItemItemView
local KLBigMapTransferItemItem = class(UIKmlLuaPanelBase)
local this = KLBigMapTransferItemItem
---创建时调用一次
function this:Init()
    self.hight = GUI:GetControlHeight(self.view.ButtonCommon)
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---@param itemData MapMoveListItemData
function this:RefreshUI(itemData, clickCallback, MapBtnPointTempList)
    local mapMoveTbl = itemData.data
    self.MapBtnPointTempList = MapBtnPointTempList
    self.clickCallback = clickCallback
    self.itemData = itemData
    self.mapMoveTbl = mapMoveTbl
    GUI:Text_setString(self.view.Label, itemData.isGroup and mapMoveTbl.groupName or mapMoveTbl.mapName)
    --GUI:Text_setTextAlignment(self.view.Label,itemData.isRoot and "01" or "11")
    if mapMoveTbl.level == 0 then
        GUI:Text_setString(self.view.TextLevel, "")
    else
        GUI:Text_setString(self.view.TextLevel, itemData.isRoot and mapMoveTbl.level .. "" or "")
    end
    self.conditionCheck = mapMoveTbl.level <= SL:MeData_GetLevel()
    GUI:Text_setTextColor(self.view.TextLevel, self.conditionCheck and "#E6E600" or "#FF2323")
    if not SL:CheckCondition(self.mapMoveTbl.conditions) then
        GUI:Text_setString(self.view.TextLevel, "需要穿戴翅膀")
        GUI:Text_setTextColor(self.view.TextLevel, "#FF2323")
        GUI:setPosition(self.view.TextLevel,80,0)
        GUI:SetActive(self.view.TextCost,false)
    else
        GUI:setPosition(self.view.TextLevel,0,0)
        GUI:SetActive(self.view.TextCost,true)
    end
    
    self.equipConditionCheck, _, self.conditionInfo = SL:CheckCalculateConditionGroup(mapMoveTbl.conditions)
    local map_info = SL:GetConfig("cfg_map_info", self.mapMoveTbl.mapID)
    self.cost = map_info.transferCost
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)

    if self.cost and self.cost[1] and self.cost[1][2] then
        
        local transmissionCost = InfoManager.redNameInfo:GetMapTransmissionCost()
        self.conditionCheck2 = self.cost[1][2] * transmissionCost <= SL:GetBagItemCount(self.cost[1][1])
        GUI:Text_setString(self.view.TextCost, itemData.isRoot and self.cost[1][2] * transmissionCost  .. "" or "")
        GUI:Text_setTextColor(self.view.TextCost, self.conditionCheck2 and "#E6E600" or "#FF2323")
    else
        self.conditionCheck2 = true
        GUI:Text_setString(self.view.TextCost, "0")
        GUI:Text_setTextColor(self.view.TextCost, self.conditionCheck2 and "#E6E600" or "#FF2323")
    end
    GUI:Text_setTextColor(self.view.Label, (self.conditionCheck and self.conditionCheck2) and "#FFFFFF" or "#FF2323")
    
    self.isGoldmap = map_info.goldmap == 1
    GUI:setVisible(self.view.ImgVip, false)
    local width = GUI:GetControlWidth(self.view.ButtonCommon)
    GUI:setContentSize(self.view.ButtonCommon, width, self.hight)
    if self.isGoldmap then
        if itemData.isRoot then
            --GUI:Image_loadTexture(self.view.ButtonCommon,"btn_1","Atlas/FG_MapPanel.spriteatlas")
            GUI:Image_loadTexture(self.view.ButtonCommon, "btn_cs1", "Atlas/FG_MapPanel.spriteatlas")
            GUI:setVisible(self.view.ImgVip, true)
            GUI:SetActive(self.view.TextCost, false)
            --GUI:setContentSize(self.view.ButtonCommon,width,30)
        else
            GUI:Image_loadTexture(self.view.ButtonCommon, "btn_cs1", "Atlas/FG_MapPanel.spriteatlas")
            GUI:setVisible(self.view.ImgVip, true)
            GUI:SetActive(self.view.TextCost, false)
            --GUI:setContentSize(self.view.ButtonCommon,width,30)
        end
    else
        if self.itemData.isGroup then
            GUI:Text_setFontSize(self.view.Label, 20)
        else
            GUI:Text_setFontSize(self.view.Label, 16)
        end
        GUI:Image_loadTexture(self.view.ButtonCommon, self.itemData.groupExpand and "btn_cs1" or "btn_cs1", "Atlas/FG_MapPanel.spriteatlas")
        --GUI:Image_loadTexture(self.view.ButtonCommon,itemData.isRoot and "btn_1" or "btn_1","Atlas/FG_MapPanel.spriteatlas")    
    end

    GUI:SetID(self.view.ButtonCommon, (itemData.isGroup and "btn_transfer_group_" or "btn_transfer_") .. itemData.data.id)
    self.itemData.Select = false
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.ButtonCommon, self, self.ButtonCommonOnClick)
end

function this:ButtonCommonOnClick()
    if self.itemData.isGroup then
        self:ExpandGroup()
    else
        if not SL:CheckCondition(self.mapMoveTbl.conditions) then
            SL:TipMessage("需要穿戴翅膀", 1, NoticeType.NoticeMid)
            return
        end
        if not self.conditionCheck then
            SL:TipMessage(string.format("等级不满足，%s等级后可传送", self.mapMoveTbl.level), 1, NoticeType.NoticeMid)
            return
        end
        if not self.conditionCheck2 then
            SL:CommonItemGetPath(nil, self.cost[1][1])
            SL:TipMessage("消耗金币不满足，无法传送", 1, NoticeType.NoticeMid)
            return
        end
        
        local tips,pkLine = InfoManager.redNameInfo:IsLimitTransferById(SL:GetMetaValue("MAIN_ACTOR_ID"),self.mapMoveTbl.mapID,1)
        if not pkLine then
            if tips then
                SL:TipMessage(tips, 1, NoticeType.NoticeMid)
                return
            end
        end
        
        if self.isGoldmap then
            if self.itemData.isRoot and not PrivilegeCardManager.isGoldLine() then
                SL:OpenCommonTipPanelById(26)
                return
            end
        end
        
        if not self.equipConditionCheck then
            if #self.conditionInfo.childs > 0 then
                SL:TipMessage(self.conditionInfo.childs[1].errorMsg, 1, NoticeType.NoticeMid)
            end
            return
        end
        if self.MapBtnPointTempList then
            for _, v in pairs(self.MapBtnPointTempList) do
                if not v.itemData.isGroup then
                    if v.isGoldmap then
                        GUI:Image_loadTexture(self.view.ButtonCommon, "btn_c3", "Atlas/FG_MapPanel.spriteatlas")
                    else
                        GUI:Image_loadTexture(v.view.ButtonCommon, "btn_c1", "Atlas/FG_MapPanel.spriteatlas")
                    end

                end
            end
        end
        if self.isGoldmap then
            GUI:Image_loadTexture(self.view.ButtonCommon, self.itemData.Select and "btn_cs1" or "btn_cs2", "Atlas/FG_MapPanel.spriteatlas")
        else
            GUI:Image_loadTexture(self.view.ButtonCommon, self.itemData.Select and "btn_cs1" or "btn_cs2", "Atlas/FG_MapPanel.spriteatlas")
        end
        self.itemData.Select = not self.itemData.Select
        self:MapMove(pkLine)
    end
end

function this:ExpandGroup()
    self.itemData.groupExpand = not self.itemData.groupExpand
    self.clickCallback()
end

function this:MapMove(pkLine)
    
    SL.ShowMainPanel()
    SL:ClearOnArriveCallBack()
    local curMapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    local curLineGroup = SL:GetConfigMultiKeys("cfg_mapMove",curMapId,"mapID").linegroup
    if curLineGroup == self.mapMoveTbl.linegroup and self.mapMoveTbl.linegroup ~= 0 then
        pkLine = SL:GetMetaValue(EMetaVarGetKey.MAP_LINE)
        if GUI:IsWebGLAsync() then
            SL:MapTransfer(nil, pkLine or 1, self.mapMoveTbl.id,{type = 1},1)
        else
            SL:showTransferAnimation()
            local id = self.mapMoveTbl.id
            SL:ScheduleOnce(0.8, function()
                SL:MapTransfer(nil, pkLine or 1, id,{type = 1},1)
            end)
        end
    else
        if GUI:IsWebGLAsync() then
            SL:MapTransfer(nil, pkLine or 1, self.mapMoveTbl.id)
        else
            SL:showTransferAnimation()
            local id = self.mapMoveTbl.id
            SL:ScheduleOnce(0.8, function()
                SL:MapTransfer(nil, pkLine or 1, id)
            end)
        end
    end
    self.baseUI:CloseTransferPanel()
    -- GUI:UIPanel_Close("dev/ui/Map/Panel/KLBigMap/KLBigMapPanel")
    SL:HideBigMap()
end

function this:Close()
end

return this
