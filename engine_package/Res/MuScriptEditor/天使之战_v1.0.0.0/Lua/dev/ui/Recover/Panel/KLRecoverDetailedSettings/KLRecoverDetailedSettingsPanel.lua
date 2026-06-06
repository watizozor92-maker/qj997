---@class KLRecoverDetailedSettingsPanel:UIKmlLuaPanelBase
---@field view KLRecoverDetailedSettingsPanelView
---@field typeList cfg_recovery_column[]
---@field goodsItem table<KingML.KmlControl,KLRecycleIncomeItemItem>
---@field getList  table<number,{count:number,cfgId:number}>

local KLRecoverDetailedSettingsPanel = class(UIKmlLuaPanelBase)
local this = KLRecoverDetailedSettingsPanel
---创建时调用一次
function this:Init()
    self.lastData = nil
end

function this:RefreshData(data)
    self.data = data
    if data and data.id == 103 then
        GUI:setVisible(self.view.tipTxt2, true)
        GUI:setVisible(self.view.tipTxt, false)
        return
    else
        GUI:setVisible(self.view.tipTxt2, false)
    end
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_RECYCLING_TYPE, self.RES_GET_RECYCLING_TYPE, self)
    
    ---回收所得列表
    self.getList = {}
    ---回收所得道具展示
    self.goodsItem = {}
    ---回收类型列表
    self.typeList = {}
    self.selectItemList = {}

    self.typeList = self.data.typeList
    
    -- 按类型分组的通用结构
    self.type_groups = {}
    for i, v in ipairs(self.typeList) do
        if not self.type_groups[v.type] then
            self.type_groups[v.type] = {}
        end
        table.insert(self.type_groups[v.type], v)
    end
    
    self.recover_all_item = {}
    
    -- 先对type_groups进行排序，确保按顺序处理
    local sorted_type_groups = {}
    for type_id, type_items in pairs(self.type_groups) do
        table.insert(sorted_type_groups, { type_id = type_id, items = type_items })
    end
    table.sort(sorted_type_groups, function(a, b)
        return a.type_id < b.type_id
    end)
    for _, type_data in ipairs(sorted_type_groups) do
        local type_id = type_data.type_id
        local type_items = type_data.items

        -- 创建或获取对应类型的容器
        local container = self:createOrGetContainer(type_id)
        local title_obj = self:createOrGetTitle(type_id)

        -- 控制标题显示
        if #type_items > 0 then
            -- 为该类型创建UI项
            for k, v in ipairs(type_items) do
                local id = v.id
                ---@type KLRecoverTypeItem
                local homeTab = GUI:UIPanel_Open("dev/ui/Recover/Item/KLRecoverType/KLRecoverTypeItem",
                    container.view.content, self, v, true, function(homeTab)
                        GUI:SetOnPrefabControlLoaded(homeTab.view.prefab_11, function()
                            GUI:SetToggleOnValueChange(homeTab.view.KmlRecycleTypeItemTemplate, self, self.ToggleChange,
                                v.id)
                            GUI:Text_setString(title_obj, v.typeName or "请检查配置typeName")
                        end)
                    end)
                self.recover_all_item[tostring(id)] = homeTab
            end
            container:RefreshData(type_id)
        else
            GUI:setVisible(container, false)
        end
    end

    if data.type == 2 then
        GUI:setVisible(self.view.tipTxt, true)
    else
        GUI:setVisible(self.view.tipTxt, false)
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_RECYCLING_TYPE)
end


-- 创建或获取指定类型的容器对象
---@return KLRecoverNodeItem
function this:createOrGetContainer(type_id)
    if not self.generic_content_container then
        self.generic_content_container = {}
    end
    if not self.generic_content_container[type_id] then
        self.generic_content_container[type_id] = GUI:UIPanel_Open("dev/outui/Recover/Item/KLRecoverNode/KLRecoverNodeItem", self.view.base_info, self, nil, true)
    end
    return self.generic_content_container[type_id]
end

-- 创建或获取指定类型的标题对象
function this:createOrGetTitle(type_id)
    return self:createOrGetContainer(type_id).view.titleTxt
end

---创建或者刷新界面数据时调用
function this:Refresh()
   
    SL.HideMainPanel()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.BtnCloseOnClick)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_RECYCLING_TYPE, self.RES_GET_RECYCLING_TYPE, self)
end

function this:UnRegistEvents()
    SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_RECYCLING_TYPE, self.RES_GET_RECYCLING_TYPE, self)
end

function this:Close()
    self:UnRegistEvents()
end

function this:Recycle()
    -- if not self.recover_all_item then
    --     return
    -- end
    -- for _, v in pairs(self.recover_all_item) do
    --     GUI:UIPanel_Close(nil, v)
    -- end
    -- table.clear(self.recover_all_item)
end

---关闭页面
function this:BtnCloseOnClick()
    local panel = GUI:GetUI("dev/ui/Recover/Panel/KLRecover/KLRecoverPanel")
    if panel then
        panel:SetDetailBtn()
    end
    GUI:UIPanel_Close("dev/ui/Recover/Panel/KLRecoverDetailedSettings/KLRecoverDetailedSettingsPanel")
end

function this:GetRecoverTypeSet()
    return false
end

-- 返回回收类型
function this:RES_GET_RECYCLING_TYPE(_id, message)
    if table.isNullOrEmpty(self.recover_all_item) then
        return
    end
    if message then
        self.recover_data = message.subType or {}
        self.recover_group = message.groupId or {}
        self.recover_initInfo = message.initInfo or false
    else
        self.recover_data = {}
        self.recover_group = {}
        self.recover_initInfo = false
    end
    local one_list = self.recover_data[tostring(self.data.id)]
    if not one_list or not one_list["1"] then
        for k, v in pairs(self.recover_all_item) do
            GUI:SetOnPrefabControlLoaded(v.view.prefab_11, function()
                GUI:Toggle_setIsOn(v.view.KmlRecycleTypeItemTemplate, false)
            end)
        end
        return
    end

    local all_true = {}
    if one_list then
        for i = 1, 100, 1 do
            local key = tostring(i)
            if not one_list[key] then
                break
            end
            local id_str = one_list[key]
            if id_str then
                if type(id_str) == "number" then
                    id_str = tostring(id_str)
                    if self.recover_all_item[id_str] and self.recover_all_item[id_str].view then
                        GUI:SetOnPrefabControlLoaded(self.recover_all_item[id_str].view.prefab_11, function()
                            GUI:SetIsOnWithoutNotify(self.recover_all_item[id_str].view.KmlRecycleTypeItemTemplate, true)
                        end)
                        table.insert(all_true, id_str)
                    end
                else
                    for _, str in pairs(id_str) do
                        str = tostring(str)
                        if self.recover_all_item[str] and self.recover_all_item[str].view then
                            GUI:SetOnPrefabControlLoaded(self.recover_all_item[str].view.prefab_11, function()
                                GUI:SetIsOnWithoutNotify(self.recover_all_item[str].view.KmlRecycleTypeItemTemplate, true)
                            end)
                            table.insert(all_true, str)
                        end
                    end
                end
            end
            
           
        end
    end
    for k, v in pairs(self.recover_all_item) do
        if table.contains(all_true, k) then
        else
             GUI:SetOnPrefabControlLoaded(v.view.prefab_11, function()
                GUI:Toggle_setIsOn(v.view.KmlRecycleTypeItemTemplate, false)
            end)
        end
    end
end

function this:contain_bg_value(tab, value)
    for k, v in pairs(tab) do
        if v == value then
            return true
        end
    end
    return false
end

function this:get_remove_value(tab, value)
    local all_list = {}
    --强化 or 追加
    local find = {}
    for group, v in pairs(self.type_groups) do
        if group == 5 or group == 6 then
            local add = false
            for k, data in pairs(v) do
                if data.id == value then
                    add = true
                end
                if add then
                    table.insert(find, data.id)
                end
            end
        end
    end
    local index = 1
    for k, v in pairs(tab) do
        if v ~= value and not table.contains(find, v) then
            all_list[tostring(index)] = v
            index = index + 1
        end
    end
    return all_list
end

function this:get_add_value(tab, value)
    local all_list = {}
    local index = 0
    for k = 1, 100, 1 do
        if tab[tostring(k)] then
            index = k
            all_list[tostring(index)] = tab[tostring(k)]
        else
            break
        end
    end
    all_list[tostring(index + 1)] = value
    for group, v in pairs(self.type_groups) do
        if group == 5 or group == 6 then
            --强化 or 追加
            local find
            for k, data in pairs(v) do
                if data.id == value then
                    find = k
                    break
                end
            end
            if find then
                for i = 1, find - 1 do
                    index = index + 1
                    all_list[tostring(index + 1)] = v[i].id
                end
                break
            end
        end
    end
    return all_list
end

---勾选类型变更 二级页签
---@param customData number @cfg_recovery表id
function this:ToggleChange(_, customData, eventData)
    if not self.recover_data then
        return
    end
    if not self.data then
        return
    end

    local current_id = tostring(self.data.id)
    if eventData[1] then

        if not self.recover_data[current_id] then
            self.recover_data[current_id] = {}
        end
        if self:contain_bg_value(self.recover_data[current_id], customData) then
            return
        else
            self.recover_data[current_id] = self:get_add_value(self.recover_data[current_id], customData)
        end
    else
        if not self.recover_data[current_id] then
            return
        end
        if self:contain_bg_value(self.recover_data[current_id], customData) then
            local target_list = self:get_remove_value(self.recover_data[current_id], customData)
            if target_list["1"] then
                self.recover_data[current_id] = target_list
            else
                self.recover_data[current_id] = nil
            end
        else
            return
        end
    end

    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SETTING_RECYCLING_TYPE, {subType = self.recover_data, groupId = self.recover_group,initInfo = true})
end

function this:DeepCompare(t1, t2)
    if type(t1) ~= "table" or type(t2) ~= "table" then
        return t1 == t2
    end

    for k, v in pairs(t1) do
        if not self:DeepCompare(t2[k], v) then
            return false
        end
    end

    for k, v in pairs(t2) do
        if not self:DeepCompare(t1[k], v) then
            return false
        end
    end

    return true
end

return this
