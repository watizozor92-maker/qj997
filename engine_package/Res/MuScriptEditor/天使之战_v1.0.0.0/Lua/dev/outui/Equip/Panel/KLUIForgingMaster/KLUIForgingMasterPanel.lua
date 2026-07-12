---@class KLUIForgingMasterPanel:UIKmlLuaPanelBase
---@field view KLUIForgingMasterPanelView
local KLUIForgingMasterPanel = class(UIKmlLuaPanelBase)
local this =KLUIForgingMasterPanel
---创建时调用一次
function this:Init()
    ---1 锻造， 2 追加
    self.uiType = self.args.uiType
    self.cfgId = self.args.cfgId
    ---0计算部位总和等级，1计算每个部位等级
    self.count = 1
    self.items = {}
    GUI:DataListInitData(self.view.DataList_Condition, function()
        return table.count(self.datas)
    end, function(realIndex)  
        return self:DataListItemGet(realIndex)
    end, function(realIndex, kmlControl)
        return self:DataListItemInit(realIndex)
    end, function(realIndex, kmlControl)
        return self:DataListItemUpdate(realIndex)
    end)       
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close, self, self.CloseSelf)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    ---@type cfg_item_column
    local item = SL:GetConfig("cfg_item", self.cfgId)
    local tbl_id = tonumber(item.strPart[1] .. "0" .. self.uiType)
    local tbl = SL:GetConfigTable("cfg_equip_master")
    self.datas = {}
    local strPartIds = tbl[1].strPartId
    -- 孔位装备等级
    local strPartEquipLvs = {}
    local equips = SL:GetWearBarsData(1)
    -- 获取目标等级
    local targetLevel = self.count == 0 and 0 or 999
    for i, v in pairs(strPartIds) do
        if equips[v] then
            local level = self.uiType == 1 and EquipFunc.GetEquipStrengthLevel(equips[v]) or EquipFunc.GetEquipAppendLevel(equips[v])
            strPartEquipLvs[v] = level
        else
            strPartEquipLvs[v] = 0
        end
    end
    
    -- 额外处理双手武器
    if equips[EEquipSlotType.TwoHandWeapon] then
        local level = self.uiType == 1 and EquipFunc.GetEquipStrengthLevel(equips[EEquipSlotType.TwoHandWeapon]) or EquipFunc.GetEquipAppendLevel(equips[EEquipSlotType.TwoHandWeapon])
        strPartEquipLvs[EEquipSlotType.Weapon] = level
        if self.count == 1 then
            strPartEquipLvs[EEquipSlotType.OffHandWeapon] = level
        end
    end

    --- 计算当前等级
    for i, v in pairs(strPartEquipLvs) do
        if self.count == 0 then
            targetLevel = targetLevel + v
        else
            targetLevel = targetLevel > v and v or targetLevel
        end
    end
    -- targetLevel = 0
    local tempDatas = {}
    local cfg
    local max_level = 0
    ---@param v cfg_equip_master_column
    for i, v in pairs(tbl) do
        if v.type == self.uiType and v.count == self.count then
            table.insert(tempDatas, v)
        end
        if v.lv > max_level then
            max_level = v.lv
        end
    end

    -- 从小到大排序
    table.sort(tempDatas, function(a, b)
        return a.lv < b.lv
    end )
    --全部满级时单独判断
    if max_level == targetLevel then
        for i, v in pairs(tempDatas) do
            if targetLevel == v.lv then
               self:AddData(v, targetLevel, strPartEquipLvs)
               break
            end
        end
    else
        ---@param v cfg_equip_master_column
        for i, v in pairs(tempDatas) do
            if targetLevel >= v.lv then
                cfg = v
            else
                if cfg then
                    self:AddData(cfg, targetLevel, strPartEquipLvs)
                    cfg = nil
                end
                self:AddData(v, targetLevel, strPartEquipLvs)
            end
        end
    end
    GUI:DataListUpdateData(self.view.DataList_Condition)
end

---@param cfg cfg_equip_master_column
function this:AddData(cfg, targetLevel, levels)
    local data = {
        cfg = cfg
    }
    if self.count == 0 then
        data.current = targetLevel
        if SL:MeData_GetCareer().baseCareer == 4 then
            data.total = 6
        else            
            data.total = 7
        end   
    else
        local current = 0
        for i, v in pairs(cfg.strPartId) do
            if levels[v] >= cfg.lv then
                current = current + 1
            end
        end
        data.current = current
        --data.total = table.count(cfg.strPartId)
        if SL:MeData_GetCareer().baseCareer == 4 then            
            data.total = 6
        else            
            data.total = 7
        end    
    end
    
    table.insert(self.datas, data)
end

function this:DataListItemGet(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/Equip/Item/KLForgingMaster/KLForgingMasterItem", self.view.DataList_Condition, self, nil, true, 
                                  function(uiitem)
                                      self.items[uiitem.view.root] = uiitem
                                      self:DataListItemUpdate(realIndex, uiitem.view.root)
                                  end)
    
    return item.view.root
end

function this:DataListItemInit(realIndex, kmlControl)
    
end

function this:DataListItemUpdate(realIndex, kmlControl)
    ---@type KLForgingMasterItem
    local item = self.items[kmlControl]
    if item == nil then
        return
    end
    local data = self.datas[realIndex + 1]
    item:UpdateItem(data)
end

function this:CloseSelf()
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLUIForgingMaster/KLUIForgingMasterPanel")
end

function this:Close()
end

return this
