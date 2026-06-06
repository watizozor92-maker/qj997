---@class KLRecoverPanel:UIKmlLuaPanelBase
---@field view KLRecoverPanelView
---@field typeList cfg_recovery_column[]
---@field goodsItem table<KingML.KmlControl,KLRecycleIncomeItemItem>
---@field getList  table<number,{count:number,cfgId:number}>
---@field curSelectId number 当前选择的道具

local KLRecoverPanel = class(UIKmlLuaPanelBase) 
local this = KLRecoverPanel
---创建时调用一次
function this:Init()
    self.cfgNameStr = "cfg_recovery"
    self.recoverBagPanel = nil
    ---回收所得列表
    self.getList = {}
    ---回收所得道具展示
    self.goodsItem = {}
    ---回收类型列表
    self.typeList = {}
    self.selectItemList = {}
    self.isReq = true
    self.recover_group = {}
    ---回收所得列表
    GUI:DataListInitData(self.view.loopscrollviewData, function()
        return self:ItemCountFunc()
    end, function(realIndex)
        return self:ItemGetFunc(realIndex)
    end, function(realIndex, kmlCtrl)
        return self:ItemInitFunc(realIndex, kmlCtrl)
    end, function(realIndex, kmlCtrl)
        return self:ItemUpdateFunc(realIndex, kmlCtrl)
    end)

    ---获取类型列表
    self:GetTypeList()
    self.cfg_recovery_screen = SL:GetConfigTable("cfg_recovery_screen")
    self.recover_all_item = {}
    self.recover_data = nil
    for k, v in ipairs(self.typeList) do
        local id = v.id
        local _typeList = {}
        for ii, one in ipairs(self.cfg_recovery_screen) do
            if one.groupLevel == v.id then
                one.groupName1 = one.screenName
                table.insert(_typeList, one)
            end
        end
        local content = v.type == 2 and self.view.ScoreContent or self.view.TypeContent

        v.typeList = _typeList
        ---@param homeTab KLRecoverTypeItem
        GUI:UIPanel_Open("dev/ui/Recover/Item/KLRecoverType/KLRecoverTypeItem", content, self, v, true,
            function(homeTab)
                GUI:SetToggleOnValueChange(homeTab.view.KmlRecycleTypeItemTemplate, self, self.ToggleChange, v.id)
                self.recover_all_item[tostring(id)] = homeTab
                if not table.isNullOrEmpty(self.recover_group) then
                    if table.contains(self.recover_group,tostring(id)) then
                        GUI:Toggle_setIsOn(homeTab.view.KmlRecycleTypeItemTemplate, true)
                    else
                        GUI:Toggle_setIsOn(homeTab.view.KmlRecycleTypeItemTemplate, false)
                    end
                end
            end)
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL.HideMainPanel()
    ---刷新特权展示
    self:RefreshPrivilegeInfo()
    ---刷新自动拾取勾选显示
    local isOpenPick = SL:GetPlayerAutoPickIsOpen()
    if isOpenPick then
        --isOpenPick = PrivilegeCardManager.isautoPotion()
        isOpenPick = InfoManager.monthCardInfo:IsHaveMonthCardRights("pickUp")
    end

    --GUI:Toggle_setIsOn(self.view.AutoPickToggle, isOpenPick)
    local isOpenRecover = SL:GetPlayerAutoRecoverIsOpen()
    if isOpenRecover then
        isOpenRecover = PrivilegeCardManager.isautoRecovery()
    end

    ---刷新自动回收勾选
    GUI:Toggle_setIsOn(self.view.AutoRecoverToggle, isOpenRecover)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_RECYCLING_TYPE)
end

function this:InitConfig()
    local cfgs = SL:GetConfigTable(self.cfgNameStr)
    self.recover_data = {}
    self.recover_group = {}
    ---@param v cfg_recovery_column
    for i, v in ipairs(cfgs) do
        local _typeList = {}
        -- 一级页签直接勾选的时候，二级页签全部选中
        local index = 1
        for ii, one in ipairs(self.cfg_recovery_screen) do
            if one.groupLevel == v.id then
                if one.DefaultTick == 1 then
                    _typeList[tostring(index)] = one.id
                    index = index + 1
                end
            end
        end
        if v.default == 1 then
            self.recover_group[tostring(table.count(self.recover_group ) + 1 )] = tostring(v.id)
        end
        self.recover_data[tostring(v.id)] = _typeList
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SETTING_RECYCLING_TYPE, {subType = self.recover_data, groupId = self.recover_group,initInfo = true})
end

---获取回收材料列表
---@param recycleCfg cfg_recovery_column
---@param item CommonProtos.Item
function this:GetMaterialList(recycleCfg,item)
    local isBind = EquipFunc.GetItemIsBind(nil,item)
    local materialList = {}
    for index, value in ipairs(recycleCfg.material) do
        local cfgIsBind = value[1] == 2
        if cfgIsBind == isBind  then
            table.insert(materialList, value)
        end
    end
    return materialList
end

---获取回收所得道具展示
function this:GetRecoverGetItem()
    ---选中道具列表
    ---@type table<number,boolean>
    self.selectItemList = {}
    self.selectItemCount = {}
    ---选中道具索引列表
    self.SelectItemIndexList = {}
    self.SelectItemCfgId = {}
    ---@type table<number,{count:number,cfgId:number}>
    self.getList = {}
    ---@type number[]
    local typeList = SL:GetAutoRecoverTypeSetData(self.cfgNameStr)
    ---@param v CommonProtos.Item
    for i, v in pairs(SL:GetCanRecycleItemList(self.cfgNameStr)) do
        local configData = SL:GetConfig("cfg_item", v.cfgId)
        if table.contains(typeList, configData.recoveryGroup) then
            local recycleCfg = SL:GetConfig(self.cfgNameStr, configData.recoveryGroup)
            local materialList = self:GetMaterialList(recycleCfg, v)
            for k = 1, table.count(materialList) do
                if not self:CheckExsit(materialList[k], self.getList, configData.recoveryUp, v.count) then
                    ---@type {count:number,cfgId:number}
                    local getType = {}
                    getType.cfgId = materialList[k][2]
                    getType.count = materialList[k][3] * (1 + configData.recoveryUp / 100) *
                        (1 + self.privilegeUp / 100)
                    getType.count = getType.count * v.count
                    table.insert(self.getList, getType)
                end
            end
            table.insert(self.SelectItemIndexList,
                { idxOfBags = SL:MeData_GetIndexBaseOnItemId(v.id), count = v.count ,_id=v.id})
            self.selectItemList[v.id] = true
            if not table.contains(self.SelectItemCfgId, v.cfgId) then
                table.insert(self.SelectItemCfgId, v.cfgId)
            end
        end
    end
    self:ShowGetItemList()
end

---获取勾选的最大强化和追击等级
function this:GetMaxLevel(recover_group_data)
    local strengLv = -1
    local appendLv = -1
    for i, group_id in pairs(recover_group_data) do
        ---@type cfg_recovery_screen_column
        local one_tab = SL:GetConfig("cfg_recovery_screen", group_id)
        if one_tab.type == 5 then
            strengLv = math.max(strengLv,one_tab.strengthlevel)
        elseif one_tab.type == 6 then
            appendLv = math.max(appendLv,one_tab.appendlevel)
        end
    end
    return strengLv,appendLv
end

---获取是否符合幸运,技能，无视装备提升
function this:GetMeetLuckAndSkillAndUp(recover_group_data,item)
    local isOpenSkill = false
    local isOpenLuck = false
    local isOpenUp = false
    for i, group_id in pairs(recover_group_data) do
        ---@type cfg_recovery_screen_column
        local one_tab = SL:GetConfig("cfg_recovery_screen", group_id)
        if one_tab.type == 7 then
            isOpenSkill = true
        elseif one_tab.type == 8 then
            isOpenLuck = true
        elseif one_tab.type == 11 then
            isOpenUp = true
        end
    end
    
    if not isOpenSkill then
        local skillStr = EquipFunc.GetEquipSkillShow(item)
        if not string.isNullOrEmpty(skillStr) then
            return false
        end
    end
    if not isOpenLuck then
        local luncky = EquipFunc.GetEquipLuckyAttr(item) or SL:GetEquipValue(EMetaVarGetKey.EQUIP_LUCK_ATTR, "bag", item.cfgId, item.id)
        if luncky and #luncky > 0 then
            return false
        end
    end

    if not isOpenUp then
        local up =EquipFunc.CheckBagEquipIsBetter(item) 
        if up then
            return false
        end
    else

    end
    return true
end

function this:MeetCareer(recover_group_data,cfgItem)
    local data = {}
    for i, group_id in pairs(recover_group_data) do
        ---@type cfg_recovery_screen_column
        local one_tab = SL:GetConfig("cfg_recovery_screen", group_id)
        if one_tab.type == 3 then
            table.insert(data,one_tab)
        end
    end
    
    ---没勾选职业
    if table.isNullOrEmpty(data) then
        return false
    end
    local jobCount = #cfgItem.job
    for i, one_tab in ipairs(data) do
        local career = one_tab.career
        local equip_job = cfgItem.job
       
        for jjj, job_list in ipairs(equip_job) do
            for iii, one_list in ipairs(career) do
                if one_list[1] == job_list[1] and one_list[2] == job_list[2] then
                    jobCount = jobCount - 1
                    break
                end
            end
        end
        
        if jobCount <= 0 then
            return true
        end
    end
    if jobCount > 0 then
        return false
    end
    return true
end


---获取回收所得道具展示 --多级页签选择的回收
function this:GetRecoverGetItemMultistage()
    ---选中道具列表
    ---@type table<number,boolean>
    self.selectItemList = {}
    self.selectItemCount = {}
    ---选中道具索引列表
    self.SelectItemIndexList = {}
    self.SelectItemCfgId = {}
    ---@type table<number,{count:number,cfgId:number}>
    self.getList = {}
    ---@type number[]
    local typeList = {}
    if self.recover_data and next(self.recover_data) then
        for key, v in pairs(self.recover_data) do
            table.insert(typeList, tonumber(key))
        end
    end
    local allItem = self:GetCanRecover()
    ---@param v CommonProtos.Item
    for i, v in ipairs(allItem) do
        --(not自身职业的武器or评分不高于自身武器)and 强化等级==0 and 追加等级==0
        local configData = SL:GetConfig("cfg_item", v.cfgId)
        if table.contains(typeList, configData.recoveryGroup) and table.contains(self.recover_group,tostring(configData.recoveryGroup)) then
            local group_str = tostring(configData.recoveryGroup)
            local is_add = false
            --如果是白装这种没有子页签的直接添加
            if self.recover_data[group_str] and self.recover_data[group_str]["1"] then
                local strengthMaxLv, appendMaxLv = self:GetMaxLevel(self.recover_data[group_str])
                for kk, group_id in pairs(self.recover_data[group_str]) do
                    local one_tab = SL:GetConfig("cfg_recovery_screen", group_id)
                    if tonumber(group_str) == 101 then
                        if not self:GetMeetLuckAndSkillAndUp(self.recover_data[group_str], v) then
                            is_add = false
                            break
                        end
                        if not self:MeetCareer(self.recover_data[group_str],configData) then
                            is_add = false
                            break
                        else
                            is_add = true
                        end
                    end
                    --比较阶数是否相等
                    if one_tab.type == 1 then
                        if configData.rank == one_tab.rank then
                            is_add = true
                        else
                            is_add = false
                            break
                        end
                        --比较词条数是否相等
                    elseif one_tab.type == 2 then
                        local entryAttr = SL:GetEquipValue(EMetaVarGetKey.EQUIP_ENTRY_ATTR, "bag", v.cfgId, v.id)
                        if entryAttr and #entryAttr == one_tab.count then
                            is_add = true
                        else
                            is_add = false
                            break
                        end
                        --比较职业等级是否相等
                    elseif one_tab.type == 3 then
                        local career = one_tab.career
                        local equip_job = configData.job
                        for iii, one_list in ipairs(career) do
                            for jjj, job_list in ipairs(equip_job) do
                                if one_list[1] == job_list[1] and one_list[2] == job_list[2] then
                                    is_add = true
                                    break
                                end
                            end
                        end
                        if not is_add then
                            break
                        end
                    elseif one_tab.type == 5 then
                        local item = SL:GetItemInfoByItemId(v.id)
                        ---@type table
                        local strengthlevel = EquipFunc.GetEquipStrengthLevel(item)
                        if strengthlevel <= strengthMaxLv then
                            is_add = true
                        else
                            is_add = false
                            break
                        end
                    elseif one_tab.type == 6 then
                        local item = SL:GetItemInfoByItemId(v.id)
                        local appendlevel = EquipFunc.GetEquipAppendLevel(item)
                        if appendlevel <= appendMaxLv then
                            is_add = true
                        else
                            is_add = false
                            break
                        end
                    elseif one_tab.type == 9 then
                        if v.cfgId == one_tab.gem then
                            is_add = true
                        end
                    end
                end
            else
                is_add = true
            end
            if is_add then
                local recycleCfg = SL:GetConfig(self.cfgNameStr, configData.recoveryGroup)
                local materialList = self:GetMaterialList(recycleCfg, v)
                for k = 1, table.count(materialList) do
                    if not self:CheckExsit(materialList[k], self.getList, configData.recoveryUp, v.count) then
                        ---@type {count:number,cfgId:number}
                        local getType = {}
                        getType.cfgId = materialList[k][2]
                        getType.count = materialList[k][3] * (1 + configData.recoveryUp / 100) *
                        (1 + self.privilegeUp / 100)
                        getType.count = getType.count * v.count
                        table.insert(self.getList, getType)
                    end
                end
                table.insert(self.SelectItemIndexList,
                    { idxOfBags = SL:MeData_GetIndexBaseOnItemId(v.id), count = v.count ,_id=v.id})
                if not table.contains(self.SelectItemCfgId, v.cfgId) then
                    table.insert(self.SelectItemCfgId, v.cfgId)
                end
                self.selectItemList[v.id] = true
            end
        end
    end
    self:ShowGetItemList()
end

function this:GetCanRecover()
    local list = {}
    local bagData = SL:GetMetaValue(EMetaVarGetKey.BAG_DATA)
    local items = bagData[1]
    for i, v in pairs(items) do
        if SL:HasConfig("cfg_item", v.cfgId) then
            local item = SL:GetConfig("cfg_item", v.cfgId)
            if SL:HasConfig(self.cfgNameStr, item.recoveryGroup) then
                if self:FilterMedicine(v.cfgId) then
                    table.insert(list, v)
                end
            end
        end
    end
    return list
end

local medicineLevel
function this:CalculateMedicineLevelIfNeed()
    if medicineLevel then
        return
    end
    medicineLevel = {}
    ---@type cfg_npcShop_column[]
    local table = SL:GetConfigTable("cfg_npcShop")
    for _, v in pairs(table) do
        if v.shopId == 1 and not string.isNullOrEmpty(v.conditions) then --药水分类
            local itemId = v.itemId
            local hightestLevel = tonumber(string.match(v.conditions, "checkLevel<=*(%d+)"))
            if not string.contains(v.conditions, "<=") then
                hightestLevel = hightestLevel - 1
            end
            medicineLevel[itemId] = hightestLevel
        end
    end
end

---@药水回收规则：根据等级动态划分低级药水
function this:FilterMedicine(itemId)
    self:CalculateMedicineLevelIfNeed()
    local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    if medicineLevel[itemId] then
        return medicineLevel[itemId] < level
    end
    return true
end

---展示回收所得道具
function this:ShowGetItemList()
    GUI:DataListUpdateData(self.view.loopscrollviewData)
end

---点击背包item回调
---@param itemControl KLBagItemItemView
---@param itemData CommonProtos.Item
function this:ClickItemCallBack(itemControl, itemData, itemSelf)
    if itemData.count > 1 and not self.selectItemList[itemData.id] then
        self.itemControl = itemControl
        self.itemSelf = itemSelf
        GUI:UIPanel_Open("dev/outui/SelectCount/Panel/KLSelectCount/KLSelectCountPanel", _, _,
            {
                itemid = itemData.cfgId,
                callbackUI = self,
                max = itemData.count,
                sure = self.CountSelect,
                id = itemData.id
            })
        return
    end
    
    
    
    self.selectItemList[itemData.id] = not self.selectItemList[itemData.id]
    
    
    if self.selectItemList[itemData.id] then
        self:SetSelectDeal(itemData.id)
        SL:OpenTips("recover", itemData.cfgId, itemData.id,nil,itemData,{hideBtn = true,hideMask = true,hideComparsion= true})
    else
        self:CloseTips(itemData.id)
    end
    self:SetSelectState(itemControl, itemSelf, self.selectItemList[itemData.id])
    ---根据背包内勾选刷新回收收益
    self:ShowGetItemListBySelect()


end

function this:SetSelectDeal(id)
    self:SetRotate(id)
    self.curSelectId = id
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel")
end

function this:CloseTips(id)
    if self.curSelectId and self.curSelectId == id then
        GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel")
        GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
        self:CloseRotate(id)
        self.curSelectId = nil
    end
    
end

function this:SetRotate(id)
    local item = self.recoverBagPanel:GetBagItem(id)
    if item then
        item:SetRotate()
    end
end

function this:CloseRotate(id)
    local item = self.recoverBagPanel:GetBagItem(id)
    if item then
        item:CloseRotate()
    end
end

function this:CountSelect(id, count,cfgId)
    self.selectItemCount[id] = count
    self.selectItemList[id] = not self.selectItemList[id]
    if self.selectItemList[id] then
        self:SetSelectDeal(id)
        SL:OpenTips("recover", cfgId, id,nil,nil,{hideBtn = true,hideMask = true,hideComparsion= true})
    else
        self:CloseTips(id)
    end
    
    self:SetSelectState(self.itemControl, self.itemSelf, self.selectItemList[id])
    
    self:ShowGetItemListBySelect()
end

---设置选中状态
function this:SetSelectState(itemControl, itemSelf, isShow)
    itemSelf:SetSelectEffect(isShow, true)
end

---根据背包内勾选刷新回收收益
function this:ShowGetItemListBySelect()
    ---选中道具索引列表
    self.SelectItemIndexList = {}
    self.SelectItemCfgId = {}
    ---@type table<number,{count:number,cfgId:number}>
    self.getList = {}
    ---@type number[]
    -- local typeList=SL:GetAutoRecoverTypeSetData()
    ---@param v CommonProtos.Item
    for i, v in pairs(SL:GetCanRecycleItemList(self.cfgNameStr)) do
        local configData = SL:GetConfig("cfg_item", v.cfgId)

        local count = v.count
        ---主动勾选列表中为true
        if self.selectItemList[v.id] then
            local recycleCfg = SL:GetConfig(self.cfgNameStr, configData.recoveryGroup)
            local materialList = self:GetMaterialList(recycleCfg, v)
            for k = 1, table.count(materialList) do
                count = self.selectItemCount[v.id] and self.selectItemCount[v.id] or v.count
                if not self:CheckExsit(materialList[k], self.getList, configData.recoveryUp, count) then
                    ---@type {count:number,cfgId:number}
                    local getType = {}
                    getType.cfgId = materialList[k][2]
                    getType.count = materialList[k][3] * (1 + configData.recoveryUp / 100) *
                        (1 + self.privilegeUp / 100)
                    getType.count = getType.count * count
                    table.insert(self.getList, getType)
                end
            end
            table.insert(self.SelectItemIndexList, { idxOfBags = SL:MeData_GetIndexBaseOnItemId(v.id), count = count ,_id=v.id})
            if not table.contains(self.SelectItemCfgId, v.cfgId) then
                table.insert(self.SelectItemCfgId, v.cfgId)
            end
        end
    end

    self:ShowGetItemList()
end

---@param list table<number,{count:number,cfgId:number}>
function this:CheckExsit(data, list, addUpNum, itemCount)
    for i, v in pairs(list) do
        if v.cfgId == data[2] then
            v.count = v.count + data[3] * (1 + addUpNum / 100) * (1 + self.privilegeUp / 100) * itemCount
            return true
        end
    end
    return false
end

function this:RefreshPrivilegeInfo()
    self.privilegeUp = PrivilegeCardManager.GetReclaimUp()
    if self.privilegeUp > 0 then
        GUI:setVisible(self.view.privilege_tip, false)
        GUI:Text_setString(self.view.privilege_tip, "已激活钻石特权：回收收益增加" .. self.privilegeUp .. "%")
    else
        GUI:setVisible(self.view.privilege_tip, false)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.BtnCloseOnClick)
    GUI:AddOnClickEvent(self.view.BtnRecover, self, self.BtnRecover)
    --GUI:SetToggleOnValueChange(self.view.AutoPickToggle, self, self.AutoPickToggleChaneg)
    GUI:SetToggleOnValueChange(self.view.AutoRecoverToggle, self, self.AutoRecoverToggleChaneg)
    SL:RegisterLUAEvent(LUA_EVENT_Item_Recover, self.LUA_EVENT_Item_Recover, self)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_RECYCLING_TYPE, self.RES_GET_RECYCLING_TYPE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RECOVERY_REWARD, self.RES_RECOVERY_REWARD, self)
end

function this:UnRegistEvents()
    SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_RECYCLING_TYPE, self.RES_GET_RECYCLING_TYPE, self)
    SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.RES_RECOVERY_REWARD, self.RES_RECOVERY_REWARD, self)
end

function this:Close()
    self:UnRegistEvents()
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel")
    SL.ShowMainPanel()
end

---关闭页面
function this:BtnCloseOnClick()
    if SL:GetIsWebGL() then
        self:StopRefreshTimer()
    end
    GUI:UIPanel_Close("dev/ui/Recover/Panel/KLRecover/KLRecoverPanel")
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLRecoverBag/KLRecoverBagPanel")
    GUI:UIPanel_Close("dev/ui/Recover/Panel/KLRecoverDetailedSettings/KLRecoverDetailedSettingsPanel")
end

---请求回收
function this:BtnRecover()
    --SL:SendRecoverItem(self.SelectItemIndexList)
    if not self.SelectItemIndexList or not next(self.SelectItemIndexList) then
        return
    end

    --新的回收逻辑
    local list = {}
    for i, v in ipairs(self.SelectItemIndexList) do
        list[tostring(v.idxOfBags)] = v.count
    end
    if self.testTimer then
        SL:UnSchedule(self.testTimer)
        self.testTimer = nil
    end

    for k, v in pairs(self.SelectItemCfgId) do
        local cfgTbl = SL:GetConfig("cfg_item", v)
        if cfgTbl.type == 6 and cfgTbl.subType == 3 then
            SL:CommonTipsMessage({
                ui = self,
                showTips = "<color=#00ff00>技能书</color>即将被回收，是否确定？",
                callback = function()
                    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ITEM_RECOVERY, list)
                end,
            })
            return
        end
    end
    if self:TipLoopTaskItem(list) then
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ITEM_RECOVERY, list)
end

function this:TipLoopTaskItem(list)
    local taskList = SL:TaskInfo_GetAllTasks()
    local is_have = false
    for taskId, v in pairs(taskList) do
        local uititletype = SL:GetConfig('cfg_task', taskId).uiTitleType
        if uititletype == 5 then
            is_have = true
            break
        end
    end
    if not is_have then
        return
    end
    local currentLoopNum = InfoManager.taskLoopInfo.currentLoopNum + 1
    local taskinfo = SL:GetConfig('cfg_taskline', currentLoopNum)
    self.taskInfo = taskinfo
    local str_list = {}
    for k, v in ipairs(self.SelectItemIndexList) do
        local itemInfo = SL:GetItemInfoByItemId(v._id)
        if self:CheckItem(itemInfo) then
            local name = SL:GetConfig("cfg_item",itemInfo.cfgId).name
            table.insert(str_list,name)
        end
    end
    if table.count(str_list) > 0 then
        local str_text = SL:GetConfig("cfg_string",70001).text
        local str = ""
        for i, v in ipairs(str_list) do
            if 1 < table.count(str_list) then
                str = str .. v..","
            else
                str = str .. v
            end
        end
        str = string.format(str_text,str)
         SL:CommonTipsMessage({
                ui = self,
                showTips = str,
                callback = function()
                    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ITEM_RECOVERY, list)
                end,
            })
        return true
    end
end


---检查道具是否符合要求
function this:CheckItem(item)
    local itemTable = SL:GetConfig('cfg_item', item.cfgId) or {}
    if itemTable.type ~= 2 then
        return false
    end

    if next(self.taskInfo.itemId) then
        if not GUIUtil.ItemEquals(item.cfgId, InfoManager.taskLoopInfo.currentCfgId) then
            return false
        end
    end

    if next(self.taskInfo.strPart) then
        local fuhe = false
        for _, value in pairs(itemTable.strPart) do
            if table.contains(self.taskInfo.strPart, value) then
                fuhe = true
                break
            end
        end
        if not fuhe then
            return false
        end
    end

    if self.taskInfo.qianghua > 0 then
        if EquipFunc.GetEquipStrengthLevel(item) < self.taskInfo.qianghua then
            return false
        end
    end
    if self.taskInfo.zhuijia > 0 then
        if EquipFunc.GetEquipAppendLevel(item) < self.taskInfo.zhuijia then
            return false
        end
    end
    if self.taskInfo.zuoyue > 0 then
        local entryAttr = SL:GetEquipEntrys(item)
        local count = entryAttr and table.count(entryAttr) or 0
        if count < self.taskInfo.zuoyue then
            return false
        end
    end
    if self.taskInfo.xingyun > 0 then
        local entryAttr = EquipFunc.GetEquipLuckyAttr(item)
        if table.isNullOrEmpty(entryAttr) then
            return false
        end
    end
    return true
end

---自动回收勾选修改
function this:AutoRecoverToggleChaneg(_, customData, eventData)

    if eventData[1] and not PrivilegeCardManager.isautoRecovery() then
        GUI:Toggle_setIsOn(self.view.AutoRecoverToggle, false)
        self:TipCardRecover()
        return
    end

    if eventData[1] == SL:GetPlayerAutoRecoverIsOpen() then
        return
    end
    ---设置一下数据
    -- SL:SetPlayerAutoRecover(eventData[1])
    ---发给服务器
    SL:SendPlayerAutoRecoverChange(eventData[1])
end

function this:TipCardRecover()
    SL:OpenCommonTipPanelById(17)
end

---自动拾取勾选修改
function this:AutoPickToggleChaneg(_, customData, eventData)

    if eventData[1] and not PrivilegeCardManager.isautoPick() then
        GUI:Toggle_setIsOn(self.view.AutoPickToggle, false)
        self:TipCardPick()
        return
    end

    if eventData[1] == SL:GetPlayerAutoPickIsOpen() then
        return
    end
    ---设置一下数据
    SL:SetPlayerAutoPick(eventData[1])
    ---发给服务器
    SL:SendPlayerAutoPickChange(eventData[1])
end

function this:TipCardPick()
    -- SL:CommonTipsMessage({
    --     stringTblID = 479,
    --     showTips = "",
    --     ui = self,
    --     sureBtnText = "确定",
    --     cancelBtnText = "取消",
    --     callback = self.OpenFirsh
    -- })

    SL:OpenCommonTipPanelById(16)
end

function this:SetAutoRecover(val)
    GUI:Toggle_setIsOn(self.view.AutoRecoverToggle, val)
end

function this:OpenFirsh()
    --SL:TipMessage({ "首充还未开通", 1, NoticeType.NoticeMid })
    GUI:UIPanel_Close("dev/ui/Recover/Panel/KLRecover/KLRecoverPanel")
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLRecoverBag/KLRecoverBagPanel")

    --GUI:UIPanel_Open("dev/ui/ShopMall/Panel/KLShopMall/KLShopMallPanel")
    --GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
    GUI:UIPanel_Open("dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel", nil, nil, 2)
end

---获取勾选类型列表
function this:GetTypeList()
    ---@param v cfg_recovery_column
    for i, v in pairs(SL:GetConfigTable(self.cfgNameStr)) do
        if v.group == 1 and v.recoverType ~= 0 then
            table.insert(self.typeList, v)
        end
    end
    table.sort(self.typeList, function(a, b)
        return a.id < b.id
    end)
end

---回收获得列表数量
function this:ItemCountFunc()
    return table.count(self.getList)
end

function this:ItemGetFunc()
    ---@type KLRecycleIncomeItemItem
    local item = GUI:UIPanel_Open("dev/ui/Recover/Item/KLRecycleIncomeItem/KLRecycleIncomeItemItem",
        self.view.loopscrollviewData, self, nil, true)

    self.goodsItem[item.view.root] = item
    return item.view.root
end

---回收获得数据初始化
function this:ItemInitFunc(realIndex, kmlcontrol)

end

---回收获得数据刷新
function this:ItemUpdateFunc(realIndex, kmlCtrl)
    local data = self.getList[realIndex + 1]
    ---@type KLRecycleIncomeItemItem
    local goodsItem = self.goodsItem[kmlCtrl]
    goodsItem:RefreshItem(data)
end

---勾选类型变更
---@param customData number @cfg_recovery表id
function this:TypeToggleChange(_, customData, eventData)
    ---刷新勾选装备

    ---设置玩家当前勾选数据
    SL:SetAutoRecoverType(customData, eventData[1], self.cfgNameStr)
    ---发给服务器
    SL:SendPlayerAutoRecoverTypeChange({ customData }, { eventData[1] }, self.cfgNameStr)
    self:RefreshSelect()
end

function this:RefreshSelect_Old()
    ---刷新回收所得道具
    self:GetRecoverGetItem()
    ---刷新勾选
    --EventManager.Dispatch(Event.RecoverSelectChange, self.selectItemList)
    SL:onLUAEvent(Event.RecoverSelectChange, self.selectItemList)
end

function this:RefreshSelect()
    ---刷新回收所得道具
    self:GetRecoverGetItemMultistage()
    ---刷新勾选
    --EventManager.Dispatch(Event.RecoverSelectChange, self.selectItemList)
    SL:onLUAEvent(Event.RecoverSelectChange, self.selectItemList)
end

function this:LUA_EVENT_Item_Recover(id, itemList)
    SL:OpenRewardTipsByItemList(itemList, 0)
    ---刷新回收所得道具
    --self:GetRecoverGetItem()
    ---@type table<number,boolean>
    --self.selectItemList = {}
    --
    --self.selectItemCount = {}
    -----选中道具索引列表
    --self.SelectItemIndexList = {}
    -----@type table<number,{count:number,cfgId:number}>
    --self.getList = {}

    --self:ShowGetItemList()
    self:RefreshSelect()
end

function this:ShowTips()
    SL:CommonStrTipsMessage({ str = "1.道具回收后将返回对应的资源\n2.道具被回收后将从背包中移除\n3.道具被移除后将无法找回" })
end

---与当前身上穿戴装备比较评分
---@param equip CommonProtos.Item
function this:CompareInitGrage(equip)
    ---@type cfg_item_column
    local itemCfg = SL:GetConfig("cfg_item", equip.cfgId)
    ---@type cfg_equip_entryLib_column
    local entryLib = SL:GetConfig("cfg_equip_entryLib", equip.cfgId)
    local wearBars = SL:GetMetaValue(EMetaVarGetKey.GET_OPEN_WEARBARS)
    local wearBar = itemCfg.wearBarID[1]
    if wearBars and table.count(itemCfg.wearBarID) > 0 then
        for _, v in pairs(itemCfg.wearBarID) do
            if table.contains(wearBars, v) then
                wearBar = v
                break
            end
        end
    end
--[[    local targetGrade
    --如果有多个穿戴位置
    --如果有位置没穿装备则算作该评分大于身上装备评分
    --如果都穿装备了，则与评分最低的装备做比较
    for _, pos in pairs(itemCfg.strPart) do
        local target = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, pos)
        if target then
            ---@type cfg_equip_entryLib_column
            local targetEntryLib = SL:GetConfig("cfg_equip_entryLib", target.cfgId)
            if not targetGrade then
                targetGrade = targetEntryLib.replaceRating[2]
            else
                if targetEntryLib.replaceRating[2] < targetGrade then
                    targetGrade = targetEntryLib.replaceRating[2]
                end
            end
        else
            targetGrade = -1
            break
        end
    end
    targetGrade = targetGrade or -1
    if #entryLib.replaceRating >= 2 then
        if entryLib.replaceRating[2] < targetGrade then
            return false
        elseif entryLib.replaceRating[2] == targetGrade then
            return false
        end
    else
        SL:LogError("cfg_equip_entryLib", entryLib.id, "评分数不足2")
        return false
    end]]

    
    local targetGrade
    local targetEquip
    local targetPos
    local show = false
    --如果有多个穿戴位置 
    --如果有位置没穿装备则算作该评分大于身上装备评分
    --如果都穿装备了，则与评分最低的装备做比较
    if #itemCfg.strPart == 2 then
        if itemCfg.strPart[1] == EEquipSlotType.OffHandWeapon or itemCfg.strPart[1] == EEquipSlotType.Weapon  then
            local target_1 = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, EEquipSlotType.TwoHandWeapon)
            local target_2 = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, EEquipSlotType.Weapon)
            local target_3 = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, EEquipSlotType.OffHandWeapon)
            ---没有穿戴武器
            if not target_1 and (not target_2 and target_3)  then
                show = true
            else
                ---穿戴的双手武器
                if target_1  then
                    if InfoManager.exBoxTipsInfo:CompareItemGradeAndEntrys(target_1, equip) then
                        show = true
                    end
                else
                    ---同时穿了两件单手
                    if target_2 and target_3 then
                        if InfoManager.exBoxTipsInfo:CompareItemGradeAndEntrys(target_2, equip) then
                            show = true
                        end

                        if InfoManager.exBoxTipsInfo:CompareItemGradeAndEntrys(target_3, equip) then
                            show = true
                        end
                    else
                        show = true
                    end
                end
            end
        end
    else
        for _, pos in pairs(itemCfg.strPart) do
            local target = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, pos)
            if target then
                ---@type cfg_equip_entryLib_column
                local targetEntryLib = SL:GetConfig("cfg_equip_entryLib", target.cfgId)
                if entryLib and entryLib.replaceRating[1] and targetEntryLib and targetEntryLib.replaceRating[1] and targetEntryLib.replaceRating[1] == entryLib.replaceRating[1] then
                    if not targetGrade then
                        targetGrade = targetEntryLib.replaceRating[2]
                        targetEquip = target
                        targetPos = pos
                    else
                        if targetEntryLib.replaceRating[2] < targetGrade then
                            targetGrade = targetEntryLib.replaceRating[2]
                            targetEquip = target
                            targetPos = pos
                        end
                    end
                end
            else
                if pos == EEquipSlotType.OffHandWeapon then
                    show = self:CheckOffHandEquipWearLimit(equip)
                elseif pos == EEquipSlotType.Weapon then
                    local target = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, EEquipSlotType.TwoHandWeapon)
                    if not target or InfoManager.exBoxTipsInfo:CompareItemGradeAndEntrys(target, equip) then
                        show = true
                        break
                    end
                elseif pos == EEquipSlotType.TwoHandWeapon then
                    local target = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, EEquipSlotType.Weapon)
                    if not target or InfoManager.exBoxTipsInfo:CompareItemGradeAndEntrys(target, equip) then
                        show = true
                        break
                    end
                else
                    show = true
                    break
                end
            end
        end
    end

    --评分高则显示箭头
    --评分相同则词条数量多的显示箭头
    if not show and targetGrade then
        if entryLib.replaceRating[2] > targetGrade then
            show = true
        elseif entryLib.replaceRating[2] == targetGrade and targetEquip then
            local entryCount = table.count(SL:GetEquipEntrys(equip))
            local entryCount_ = table.count(SL:GetEquipEntrys(targetEquip))
            if entryCount > entryCount_ then
                show = true
            end
        end
        if show and targetPos and targetPos == EEquipSlotType.OffHandWeapon then
            show = self:CheckOffHandEquipWearLimit(equip)
        end
    end
    if show then
        return true
    end
    
    return false
end
function this:CheckOffHandEquipWearLimit(item)
    --穿戴主副手武器时， 有些职业的副手装备需要单独做检测
    ---@type cfg_equip_entryLib_column
    local entryLib = SL:GetConfig("cfg_equip_entryLib", item.cfgId)
    local result = true
    if not table.isNullOrEmpty(entryLib.assistantJob) and entryLib.assistantJob[1][1] ~= 0 then
        local canEquip = false
        ---@type cfg_career_column
        local careerTbl = SL:GetMetaValue("ME_CAREER_TAB_COLUMN")
        for _, jobInfo in pairs(entryLib.assistantJob) do
            local baseCareer = jobInfo[1]
            local careerRank = jobInfo[2]
            if careerTbl.baseCareer == baseCareer and careerTbl.careerRank >= careerRank then
                canEquip = true
                break
            end
        end
        if canEquip == false then
            result = false
        end
    end
    return result
end
-- 返回回收类型
function this:RES_GET_RECYCLING_TYPE(_id, message)
    if message then
        self.recover_data = message.subType or {}
        self.recover_group = message.groupId or {}
        self.recover_initInfo = message.initInfo or false
    else
        self.recover_data = {}
        self.recover_group = {}
        self.recover_initInfo = false
    end
    
    local all_true = {}
    for _, id in pairs(self.recover_group) do
        if self.recover_all_item[id] then
            GUI:Toggle_setIsOn(self.recover_all_item[id].view.KmlRecycleTypeItemTemplate, true)
            table.insert(all_true, id)
        end
    end
    for k, v in pairs(self.recover_all_item) do
        if table.contains(all_true, k) then
        else
            GUI:Toggle_setIsOn(v.view.KmlRecycleTypeItemTemplate, false)
        end
    end
    self:RefreshSelect()
    if not self.recoverBagPanel then
        ---显示背包
        self.recoverBagPanel = GUI:UIPanel_Open("dev/ui/Bag/Panel/KLRecoverBag/KLRecoverBagPanel", nil, nil,
            {
                y = 45,
                bagType = EBagShowType.Recycle,
                itemClickCallBack = self.ClickItemCallBack,
                selectList = self.selectItemList,
                callBackUI = self
            })
    end
    
    if not self.recover_initInfo then
        self:InitConfig()
    end
end

---勾选类型变更 一级页签
---@param customData number @cfg_recovery表id
function this:ToggleChange(_, customData, eventData)
   
    local key_str = tostring(customData)

    if not table.contains(self.recover_group,key_str) then
        if not eventData[1] then
            return
        end
    else
        if eventData[1] then
            return
        end
    end

    if not table.contains(self.recover_group,key_str) then
        if not eventData[1] then
            return
        end
        
        self.recover_group[tostring(table.count(self.recover_group ) + 1 )] = key_str
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SETTING_RECYCLING_TYPE, {subType = self.recover_data, groupId = self.recover_group,initInfo = true})
    else
        if eventData[1] then
            return
        end
        
        local temp = {}
        local index = 1
        for key, value in pairs(self.recover_group) do
            if key_str ~= value then
                temp[tostring(index)] = value
                index = index + 1
            end
        end
        self.recover_group = temp
        -- 一级页签直接取消的时候，二级页签取消
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SETTING_RECYCLING_TYPE, {subType = self.recover_data, groupId = self.recover_group,initInfo = true})
    end
end



function this:ToggleChangeTips()

end

function this:RES_RECOVERY_REWARD(_id, message)
    if message then
        GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
        GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel")
        self:RefreshSelect()
        if SL:GetIsWebGL() then
            self:StopRefreshTimer()
            self.refreshTimer = SL:ScheduleOnce(0.1, function()
                GUI:UIPanel_Close("dev/ui/Bag/Panel/KLRecoverBag/KLRecoverBagPanel")
                self.recoverBagPanel = GUI:UIPanel_Open("dev/ui/Bag/Panel/KLRecoverBag/KLRecoverBagPanel", nil, nil,
                    {
                        bagType = EBagShowType.Recycle,
                        itemClickCallBack = self.ClickItemCallBack,
                        selectList =
                            self.selectItemList,
                        callBackUI = self
                    })
            end)
        end
    end
end

function this:StopRefreshTimer()
    if self.refreshTimer then
        SL:UnSchedule(self.refreshTimer)
        self.refreshTimer = nil
    end
end

function this:SetDetailBtn(btn)
    if not btn and self.lastDeatail then
        GUI:Image_loadTexture(self.lastDeatail,"btn_down","Atlas/FG_Common.spriteatlas")
        return
    end
    
    if self.lastDeatail and self.lastDeatail == btn then
        local name = GUI:GetAttr(self.lastDeatail,"src")
        if name == "btn_down" then
            name = "btn_up"
        else
            name = "btn_down"
        end
        GUI:Image_loadTexture(self.lastDeatail,name,"Atlas/FG_Common.spriteatlas")
    else
        if self.lastDeatail then
            GUI:Image_loadTexture(self.lastDeatail,"btn_down","Atlas/FG_Common.spriteatlas")
        end
        self.lastDeatail = btn
        GUI:Image_loadTexture(btn,"btn_up","Atlas/FG_Common.spriteatlas")
    end

end

return this
