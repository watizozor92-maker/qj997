---@class KLEquipJewelryActivePanel:UIKmlLuaPanelBase
---@field view KLEquipJewelryActivePanelView
local KLEquipJewelryActivePanel = class(UIKmlLuaPanelBase)
local this = KLEquipJewelryActivePanel
---创建时调用一次
function this:Init()
    self.ExceAttTextList = {}
    GUI:DataListInitData(self.view.cost_list, function()
        return table.count(self.ExceAttTextList)
    end, function()
    end, function()
    end, function(realIndex)
        local strengthInfo = self.ExceAttTextList[realIndex + 1]
        local attrName = strengthInfo['attrName']
        local attrValue = strengthInfo['attrValue']
        local lv = strengthInfo['lv']
        local isActive = strengthInfo['isActive']
        local attShow =strengthInfo['attShow']
        local nameControl = GUI:GetChildControl(self.view.cost_list, realIndex, 'ExceAttrName')
        local textControl = GUI:GetChildControl(self.view.cost_list, realIndex, 'ExceActiveText')
        if isActive then
            if attShow == 0 then
                GUI:Text_setString(nameControl, string.format('<color="#4BA7E8">%s</color>', attrName))
            else
                GUI:Text_setString(nameControl, string.format('<color="#4BA7E8">%s</color>', attrName .. " +" .. attrValue))
            end
            --GUI:Text_setString(nameControl, string.format('<color="#4BA7E8">%s</color>', attrName .. " +" .. attrValue))
            GUI:Text_setString(textControl, string.format('<color="#2a8430">%s</color>', ""))
        else
            if attShow == 0 then
                GUI:Text_setString(nameControl, string.format('<color="#9b9b9b">%s</color>', attrName))
            else
                GUI:Text_setString(nameControl, string.format('<color="#9b9b9b">%s</color>', attrName .. " +" .. attrValue))
            end

            if self.preLevel < lv then
                GUI:Text_setString(textControl, string.format('<color="#FF2323">%s</color>', lv .. "级可激活"))
            else
                GUI:Text_setString(textControl, string.format('<color="#00ff00">%s</color>', "可激活"))
            end
        end
    end)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:setPositionZ(self.view.root, -500)
    if self.args then
        self.ExceAttTextList = self.args.ExceAttTextList
        self.preLevel = self.args.preLevel
        self.equipInfo = self.args.equipInfo

        if self:IsAllActive() then
            GUI:SetActive(self.view.ActiveBtn, false)
            GUI:SetActive(self.view.activeIcon, true)
            self.needLv=tonumber(self.preLevel)
        else
            self.needLv, self.unlockDeplete = self:GetFirstUnlockDeplete()
            GUI:SetActive(self.view.ActiveBtn, true)
            GUI:SetActive(self.view.activeIcon, false)
        end
        GUI:DataListUpdateData(self.view.cost_list)
        self.ItemCfgId = tonumber(self.unlockDeplete[1][1])
        self:SetEquipModel(self.ItemCfgId)
        local haveCount = SL:GetBagItemCount(self.ItemCfgId)
        local needCount = tonumber(self.unlockDeplete[1][2])
        if haveCount < needCount then
            GUI:Text_setString(self.view.count, string.format('<color="#9b1818">%d</color>/%d', haveCount, needCount))
        else
            GUI:Text_setString(self.view.count, string.format('<color="#00ff00">%d</color>/%d', haveCount, needCount))
        end

        if self.preLevel < self.needLv then
            GUI:Text_setString(self.view.Level, string.format('<color="#9b1818">%d</color>/%d', self.preLevel, self.needLv))
        else
            GUI:Text_setString(self.view.Level, string.format('<color="#00ff00">%d</color>/%d', self.preLevel, self.needLv))
        end


    end
end
function this:GetFirstUnlockDeplete()
    for _, v in pairs(self.ExceAttTextList) do
        if v.isActive == false then
            return v.lv, v.unlockDeplete
        end
    end
    return nil,nil
end
function this:SetEquipModel(cfgId)
    GUI:setVisible(self.view.itemModel, true)
    GUI:Item_setItemId(self.view.itemModel, cfgId)
end
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseBtn, self, self.CloseBtn)
    GUI:AddOnClickEvent(self.view.Add, self, self.AddBtn)
    GUI:AddOnClickEvent(self.view.ActiveBtn, self, self.ActiveBtn)
    GUI:AddOnClickEvent(self.view.maskBtn, self, self.CloseBtn)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ACT_EQUIP_ORNAMENTS, self.RES_ACT_EQUIP_ORNAMENTS, self)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
end
function this:LUA_EVENT_BAG_CHANGE_AFTER()
    local haveCount = SL:GetBagItemCount(self.ItemCfgId)
    local needCount = tonumber(self.unlockDeplete[1][2])
    if haveCount < needCount then
        GUI:Text_setString(self.view.count, string.format('<color="#9b1818">%d</color>/%d', haveCount, needCount))
    else
        GUI:Text_setString(self.view.count, string.format('<color="#5CE366FF">%d</color>/%d', haveCount, needCount))
    end
end
---@param message RES_UPDATE_EQUIP_ORNAMENTS
function this:RES_ACT_EQUIP_ORNAMENTS(_, message)
    if message then
        for _, v in pairs(message.ssactlv) do
            for _, j in pairs(self.ExceAttTextList) do
                if tonumber(v) == j.lv then
                    j.isActive = true
                end
            end
        end
        self:Refresh()
    end
end
function this:IsAllActive()
    ---是否全部激活
    for _, j in pairs(self.ExceAttTextList) do
        if j.isActive == false then
            return false
        end

    end
    return true
end
function this:CloseBtn()
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipJewelryActive/KLEquipJewelryActivePanel")
end
function this:AddBtn()
    SL:CommonItemGetPath(nil, self.ItemCfgId)
end
function this:ActiveBtn()
    if self.needLv then
        if tonumber(self.preLevel) < tonumber(self.needLv)then
            SL:TipMessage( SL:GetConfig('cfg_string',249).text, 1, NoticeType.NoticeMid )--"等级不足！",
        else
            local haveCount = SL:GetBagItemCount(self.ItemCfgId)
            local needCount = tonumber(self.unlockDeplete[1][2])
            if haveCount < needCount then
                SL:TipMessage(SL:GetConfig('cfg_string',260).text, 1, NoticeType.NoticeMid )--"材料不足！", 
                SL:CommonItemGetPath(nil, self.ItemCfgId)
            else
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ACT_EQUIP_ORNAMENTS, { itemId = self.equipInfo.id, lv = tonumber(self.needLv) })
            end

        end
    end
end
function this:Close()
end

return this
