---@class KLArchangelBreakthroughPanel:UIKmlLuaPanelBase
---@field view KLArchangelBreakthroughPanelView
---@field costList table<number,table<number,number>> @ 消耗道具数量
---@field tbl cfg_equip_angelAtt_column[]
---@field isCanBreak boolean
local KLArchangelBreakthroughPanel = class(UIKmlLuaPanelBase)
local this = KLArchangelBreakthroughPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    local equipPanel = GUI:GetUI("dev/outui/Equip/Panel/KLEquipUI3/KLEquipUI3Panel")
    if equipPanel then
        self.equipPanel = equipPanel
        self.equipPanel:SetSelfWearBarType(EEquipWearBarType.Archange)
    else 
        GUI:UIPanel_Open("dev/outui/Equip/Panel/KLEquipUI3/KLEquipUI3Panel", nil, nil,
                { x = -465, hideTips = true, callBack = self.ClosePanel, forgeGroupType = EForgeGroupType.Breakthrough },true,function(equipPanelView)
                    self.equipPanel =equipPanelView
                    self.equipPanel:SetSelfWearBarType(EEquipWearBarType.Archange)
                end)
    end
    self.selectEquipCfgId = self.args and self.args.selectId or nil
    GUI:DataListInitData(self.view.cost_list, function()
        return #self.costList
    end, function(realIndex)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:CostUpdateItem(realIndex, kmlcontrol)
    end)
end

function this:CostUpdateItem(realIndex, kmlcontrol)
    local data = self.costList[realIndex + 1]
    local cost_item = GUI:GetChildControl(self.view.cost_list,realIndex, "cost_item")
    GUI:Item_setItemId(cost_item, data[1])
    local itemCfg = SL:GetConfig("cfg_item", data[1], "id")
    local cost_name = GUI:GetChildControl(self.view.cost_list,realIndex, "cost_name")
    GUI:Text_setString(cost_name, itemCfg.name)
    local costNumStr = ""
    local bagCount = SL:GetBagItemCount(data[1])

    if bagCount >= data[2] then
        costNumStr = "<color='#00ff00'>" .. tostring(bagCount) .. "</color>/" .. tostring(data[2])
    else
        costNumStr = "<color='#ff2323'>" .. tostring(bagCount) .. "</color>/" .. tostring(data[2])
        self.isCost = false
    end
    local cost_num = GUI:GetChildControl(self.view.cost_list,realIndex, "cost_num")
    
    GUI:Text_setString(cost_num, costNumStr)
    local costAddBtn = GUI:GetChildControl(self.view.cost_list,realIndex, "costAddBtn")
    
    GUI:AddOnClickEvent(costAddBtn, self, function()
        --获取途径
        SL:CommonItemGetPath(nil, data[1])
    end)
end

---注册UI事件和服务器消息w
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_EQUIP_GRID_CLICK, self.LUA_EVENT_EQUIP_GRID_CLICK, self)
    GUI:AddOnClickEvent(self.view.CloseButton, self, self.CloseButton)
    GUI:AddOnClickEvent(self.view.BreakthroughBtn, self, self.Breakthrough)
    GUI:AddOnClickEvent(self.view.btn_tips, self, self.BtnHelpOnClick)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ANGEL_EQUIPMENT_BREAK_RESULT, self.RES_ANGEL_EQUIPMENT_BREAK_RESULT, self)
end
---界面显示时调用一次
function this:Show()

end
---创建或者刷新界面数据时调用
function this:Refresh()
    self:EquipNull()
    local select = {
        EEquipSlotType.ArchangelWeapon, -- 天使武器
        EEquipSlotType.ArchangelTwoHandWeapon,
        EEquipSlotType.ArchangelGlove, -- 天使手套
        EEquipSlotType.ArchangelHelmet, -- 天使头盔
        EEquipSlotType.ArchangelArmor, -- 天使衣服
        EEquipSlotType.ArchangelPant, -- 天使裤子
        EEquipSlotType.ArchangelOffHandWeapon, -- 天使副手
        EEquipSlotType.ArchangelBoot, -- 天使鞋子
        --ArchangelTwoHandWeapon = enum(73), -- 天使双手武器       
    }
    --local equips = SL:GetWearBarsData(EEquipWearBarType.BaseEquip)
    -- if #equips == 0 then
    --     self:EquipNull()
    --     return
    -- end
    self.isCanBreak = false
    local equip
    local index
    for i, v in pairs(select) do
        equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 9, v)
        if equip then
            if self.selectEquipCfgId then
                if equip.cfgId == self.selectEquipCfgId then
                    index = v
                    break
                end
            else
                index = v
                break 
            end
        end
    end
    if not equip then
        self:EquipNull()
        return
    end
    --self:LUA_EVENT_EQUIP_GRID_CLICK(equip)
    self.selectEquip = equip
    --self.equipPanel:SetSelectIndex(index)
    self:SetEquip()
    SL:RefreshPanelALLRedPoint("KLArchangelGroupPanel")
end

function this:LUA_EVENT_EQUIP_GRID_CLICK(_, pos)
    local equip = SL:GetMetaValue("EQUIP_DATA_LIST", pos)[1]
    if pos == EEquipSlotType.ArchangelWeapon and not equip then
        equip = SL:GetMetaValue("EQUIP_DATA_LIST", EEquipSlotType.ArchangelTwoHandWeapon)[1]
    end
    if pos == EEquipSlotType.ArchangelTwoHandWeapon and not equip then
        equip = SL:GetMetaValue("EQUIP_DATA_LIST", EEquipSlotType.ArchangelWeapon)[1]
    end
    if not equip then
        return
    end
    self.isCanBreak = false
    self.selectEquip = equip
    ---@type cfg_item_column
    local itemCfg = SL:GetConfig("cfg_item", self.selectEquip.cfgId, "id")
    if itemCfg.wearBarID[1] ~= 9 then
        self:EquipNull()
        return
    end
    local group = SL:GetConfig("cfg_equip_angelGroup", self.selectEquip.cfgId, "id").angelEquipGroup
    ---@type cfg_equip_angelAtt_column[]
    --self.tbl = SL:FindConfigs("cfg_equip_angelAtt", "ornamentsGroup", group)
    self.equipPanel:SetSelectIndex(pos)
    self:SetEquip()
end

function this:SetEquip()
    self.isCanBreak = false
    --GUI:setVisible(self.view.effectSucceed, false)
    --GUI:setVisible(self.view.effectfail, false)
    ---@type cfg_item_column
    local itemCfg = SL:GetConfig("cfg_item", self.selectEquip.cfgId, "id")
    if not itemCfg then
        self:EquipNull()
        return
    end
    GUI:setVisible(self.view.noselect_img, false)
    GUI:setVisible(self.view.noselect, true)
    local textColor = SL:GetConfig("cfg_color", itemCfg.color, "id").color
    GUI:Text_setTextColor(self.view.equipName, textColor)
    GUI:Text_setString(self.view.equipName, itemCfg.name)
    GUI:Item_setItemId(self.view.item_model, itemCfg.id)

    local info = InfoManager.archangeEquipInfo:GetEquipLevelInfo(self.selectEquip.id)
    if info == nil then
        return
    end
    local level = info.level
    local rank = info.rank
    local maxLv = InfoManager.archangeEquipInfo:GetMaxLevel(rank, self.selectEquip.cfgId)
    local nextMaxLv = InfoManager.archangeEquipInfo:GetMaxLevel(rank + 1, self.selectEquip.cfgId)
    local nextRank = rank + 1
    GUI:Text_setString(self.view.preLevel, tostring(rank))
    GUI:Text_setString(self.view.nextLevel, tostring(nextRank))
    
    --消耗材料
    local group = SL:GetConfig("cfg_equip_angelGroup", self.selectEquip.cfgId, "id").angelEquipGroup
    ---@type cfg_equip_angelAtt_column
    local localtbl = SL:GetConfigTwoKeys("cfg_equip_angelAtt", group, maxLv, "ornamentsGroup", "lv")
    self.costList = localtbl.breakMaterial
    self.isCost = true
    -- 更新datalist
    GUI:DataListUpdateData(self.view.cost_list)
    
    
    if rank == InfoManager.archangeEquipInfo:GetMaxRank(self.selectEquip.cfgId) then
        GUI:setVisible(self.view.hidepanel, false)
        GUI:setVisible(self.view.noticeText, false)
        GUI:setVisible(self.view.maxLevelTips, true)
        GUI:setVisible(self.view.nextLevel, false)
        GUI:setVisible(self.view.arrow, false)
        GUI:setVisible(self.view.BreakthroughBtn, false)
        return
    end
    GUI:setVisible(self.view.nextLevel, true)
    GUI:setVisible(self.view.hidepanel, true)
    GUI:setVisible(self.view.arrow, true)
    GUI:setVisible(self.view.BreakthroughBtn, true)
    GUI:setVisible(self.view.maxLevelTips, false)
    if level < maxLv then
        GUI:setVisible(self.view.hidepanel, false)
        GUI:setVisible(self.view.noticeText, true)
        GUI:Button_setGrey(self.view.BreakthroughBtn, true)
        self.isGray = true
        return
    end
    self.isCanBreak = true
    self.isGray = false
    GUI:Button_setGrey(self.view.BreakthroughBtn, false)
    GUI:setVisible(self.view.noticeText, false)
    GUI:Text_setString(self.view.preValue, tostring(maxLv))
    GUI:Text_setString(self.view.nextValue, tostring(nextMaxLv))
    
end

function this:Breakthrough()
    if self.isGray then
        return
    end
    if self.selectEquip and self.isCanBreak and self.isCost then
        GUI:setVisible(self.view.effectSucceed, false)
        GUI:setVisible(self.view.effectfail, false)
        local data = {
            itemConfigId = self.selectEquip.cfgId,
            itemId = self.selectEquip.id,
            groupId = SL:GetConfig("cfg_equip_angelGroup", self.selectEquip.cfgId, "id").angelEquipGroup
        }
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_BREAK_ANGEL_EQUIP, data)
    else
        SL:MessageTip({ id = 253 })
    end
end

function this:BtnHelpOnClick()
    local helpCfg = SL:GetConfig("cfg_rule_text", 28001)
    if helpCfg then
        SL:CommonStrTipsMessage({ title = helpCfg.menutxt, str = helpCfg.location })
    end
end

function this:EquipNull()
    GUI:Text_setString(self.view.equipName, "")
    GUI:Item_setItemId(self.view.item_model, "")
    GUI:setVisible(self.view.noticeText, false)
    GUI:setVisible(self.view.hidepanel, false)
    GUI:Text_setString(self.view.nextLevel, "")
    GUI:Text_setString(self.view.preLevel, "")
    GUI:setVisible(self.view.noselect_img, true)
    GUI:setVisible(self.view.noselect, false)
end

function this:CloseButton()
    self.equipPanel:CloseOnClick()
end

function this.ClosePanel()
    GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLArchangelBreakthrough/KLArchangelBreakthroughPanel")
    GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLArchangelGroup/KLArchangelGroupPanel")
end

function this:Close()
    SL:RefreshPanelALLRedPoint("KLUISystemLeftPanel")
    if self.refreshSchedule then
        SL:UnSchedule(self.refreshSchedule)
    end
    GUI:UIPanel_Close(nil, self.equipPanel)
end

function this:RES_ANGEL_EQUIPMENT_BREAK_RESULT(_, message)
    if message then
        if table.contains(InfoManager.archangeEquipInfo.canBreakthrough, self.selectEquip.id) then
            table.removeByValue(InfoManager.archangeEquipInfo.canBreakthrough, self.selectEquip.id)
        end
        GUI:setVisible(self.view.effectSucceed, true)
        local group = GUI:GetUI("dev/outui/Archangel/Panel/KLArchangelGroup/KLArchangelGroupPanel")
        if group then
            group:RefreshRed()
        end
    else
        GUI:setVisible(self.view.effectfail, true)
    end
    self.equipPanel:SetSelfWearBarType(EEquipWearBarType.Archange)
    self:SetEquip()
    SL:RefreshPanelALLRedPoint("KLArchangelGroupPanel")
end

return this
