---@class KLShortcutUseItemPanel:UIKmlLuaPanelBase
---@field view KLShortcutUseItemPanelView
local KLShortcutUseItemPanel = class(UIKmlLuaPanelBase)
local this =KLShortcutUseItemPanel

---创建时调用一次
function this:Init()
    self.fastData_all_item = {}
    GUI:DataListInitData(self.view.fast_data_list, function()
        return self:FastDataListItemCountFunc()
    end, function(realIndex)
        return self:FastDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:FastDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:FastDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    
    self.level = SL:GetMetaValue("LEVEL")
    local fastItemList = SL:GetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST)
    self.fastData = table.copyFrom({},fastItemList)
    if not SL:HasConfig("cfg_item",self.fastData[1]) then
        self.fastData[1] = InfoManager.mainUIInfo.mpShowModeItemId
    end
    if not SL:HasConfig("cfg_item",self.fastData[2]) then
        self.fastData[2] = InfoManager.mainUIInfo.hpShowModeItemId
    end
    --if InfoManager.mainUIInfo.guardId then
    --    self.fastData[5] = InfoManager.mainUIInfo.guardId
    --end
    
end


function this:InitShortcutAfter()
    local fastItemList = SL:GetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST)
    self.fastData = table.copyFrom({},fastItemList)
    if not SL:HasConfig("cfg_item",self.fastData[1]) then
        self.fastData[1] = InfoManager.mainUIInfo.mpShowModeItemId
    end
    if not SL:HasConfig("cfg_item",self.fastData[2]) then
        self.fastData[2] = InfoManager.mainUIInfo.hpShowModeItemId
    end
    --if InfoManager.mainUIInfo.guardId then
    --    self.fastData[5] = InfoManager.mainUIInfo.guardId
    --end
    GUI:DataListUpdateData(self.view.fast_data_list)
end


function this:FastDataListItemCountFunc()
    local count = #self.fastData
    GUI:setContentSize(self.view.fast_grid, count * 53 + (count - 1), 54)
    ---策划限制只显示4个
    if count > 3 then
        count = 3
    end
    return count
end

function this:FastDataListItemGetFunc(realIndex)
    local data = self.fastData[realIndex + 1]
    local message = { cfgId = data, itemIndex = realIndex + 1 }
    local item = GUI:UIPanel_Open("dev/ui/MainUI/Item/KLFast/KLFastItem", self.view.fast_data_list, self, message, true,function(_item)
        self.fastData_all_item[_item.view.root] = _item
        self:FastDataListItemUpdateFunc(realIndex,_item.view.root)
    end)
    return item.view.root
end

function this:FastDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:FastDataListItemUpdateFunc(realIndex, kmlcontrol)
    if self.fastData_all_item[kmlcontrol] then
        local data = self.fastData[realIndex + 1]
        local message = { cfgId = data, itemIndex = realIndex + 1 }
        self.fastData_all_item[kmlcontrol]:RefreshItem(message)
    end
end


---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE, self.LUA_EVENT_LEVELCHANGE, self)--主角等级改变事件
    SL:RegisterLUAEvent(LUA_EVENT_INIT_SHORT_CUT, self.InitShortcutAfter, self)
    SL:RegisterLUAEvent(LUA_EVENT_GUARD_FAST_ITEM_CHANGE, self.LUA_EVENT_GUARD_FAST_ITEM_CHANGE, self)

    SL:RegisterLuaNetMsg(MessageDef.ResBagChangeMessage, self.ResBagChangeMessage,self)
end

function this:LUA_EVENT_GUARD_FAST_ITEM_CHANGE()
    local fastItemList = SL:GetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST)
    self.fastData = table.copyFrom({},fastItemList)
    if not SL:HasConfig("cfg_item",self.fastData[1]) then
        self.fastData[1] = InfoManager.mainUIInfo.mpShowModeItemId
    end
    if not SL:HasConfig("cfg_item",self.fastData[2]) then
        self.fastData[2] = InfoManager.mainUIInfo.hpShowModeItemId
    end
    --if InfoManager.mainUIInfo.guardId then
    --    self.fastData[5] = InfoManager.mainUIInfo.guardId
    --end
    GUI:DataListUpdateData(self.view.fast_data_list)
end

---获得药品后快捷栏自动选择
function this:ResBagChangeMessage(id, message)
    if not message.itemList or #message.itemList <= 0 then
        return
    end
    ---@type number[]
    local fastItems = SL:GetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST)
    local fast_list = {}
    local hp_pill_itemId = 0
    local mp_pill_itemId = 0
    for i, v in ipairs(message.itemList) do
        if v.item and v.item.cfgId and v.item.count and v.item.count > 0 then
            ---@type cfg_item_column
            local tbl1 = SL:GetConfig("cfg_item",v.item.cfgId)
            if tbl1.isFast and tbl1.isFast == 1 then
                local isInsert = true
                --蓝药
                if tbl1.type==InfoManager.mainUIInfo.mpType and tbl1.subType==InfoManager.mainUIInfo.mpSubType and InfoManager.mainUIInfo.mpPillIdList[tbl1.id] then
                    if not SL:HasConfig("cfg_item",fastItems[1]) then
                        mp_pill_itemId = v.item.cfgId
                    else
                        local tbl2 = SL:GetConfig("cfg_item", fastItems[1])
                        if tbl1.rank > tbl2.rank then
                            mp_pill_itemId = v.item.cfgId
                        end
                    end
                    isInsert = false
                end
                --血药
                if tbl1.type==InfoManager.mainUIInfo.hpType and tbl1.subType==InfoManager.mainUIInfo.hpSubType and InfoManager.mainUIInfo.hpPillIdList[tbl1.id] then
                    if not SL:HasConfig("cfg_item",fastItems[2]) then
                        hp_pill_itemId = v.item.cfgId
                    else
                        local tbl2 = SL:GetConfig("cfg_item", fastItems[2])
                        if tbl1.rank > tbl2.rank then
                            hp_pill_itemId = v.item.cfgId
                        end
                    end
                    isInsert = false
                end
                if isInsert then
                    table.insert(fast_list,{cfgId=v.item.cfgId,index=v.index,id=v.item.id,isJoin = 0})
                end
            end
        end
    end
    if #fast_list > 0 then
        local current_fast_list = {}
        for i=1,#self.fastData,1 do
            table.insert(current_fast_list,{cfgId=self.fastData[i],idx=i,is_new=false})
        end
        for i=1,#current_fast_list,1 do
            local current_cfgId = current_fast_list[i].cfgId
            if current_cfgId ~= 0 then
                local tbl1 = SL:GetConfig("cfg_item", current_cfgId)
                current_fast_list[i].Group = tbl1.Group
                current_fast_list[i].rank = tbl1.rank
            else
                current_fast_list[i].Group = 0
                current_fast_list[i].rank = 0
            end
        end
        table.sort(current_fast_list, function(a, b)
            if a.Group ~= b.Group then
                return a.Group < b.Group
            else
                return a.rank < b.rank
            end
        end)
        for i=1,#fast_list,1 do
            local current_cfgId = fast_list[i].cfgId
            local tbl1 = SL:GetConfig("cfg_item", current_cfgId)
            fast_list[i].Group = tbl1.Group
            fast_list[i].rank = tbl1.rank
        end
        table.sort(fast_list, function(a, b)
            if a.Group ~= b.Group then
                return a.Group < b.Group
            else
                return a.rank > b.rank
            end
        end)
        for i=1,#current_fast_list,1 do
            local current_cfgId = current_fast_list[i].cfgId
            if current_cfgId ~= 0 then
                for j=1,#fast_list,1 do
                    local data = fast_list[j]
                    if current_cfgId == data.cfgId then
                        fast_list[j].isJoin = 2
                    end
                end
            end
        end
        for i=1,#current_fast_list,1 do
            if not current_fast_list[i].is_new then
                local current_cfgId = current_fast_list[i].cfgId
                if current_cfgId ~= 0 then
                    for j=1,#fast_list,1 do
                        local data = fast_list[j]
                        if data.isJoin == 0 and current_fast_list[i].Group == data.Group then
                            if data.rank > current_fast_list[i].rank then
                                current_fast_list[i].cfgId = data.cfgId
                                current_fast_list[i].is_new = true
                                fast_list[j].isJoin = 1
                                break
                            end
                        end
                    end
                end
            end
        end
        table.sort(current_fast_list, function(a, b)
            return a.idx < b.idx
        end)
        for i=1,#current_fast_list,1 do
            if not current_fast_list[i].is_new then
                local current_cfgId = current_fast_list[i].cfgId
                if current_cfgId == 0 then
                    for j=1,#fast_list,1 do
                        local data = fast_list[j]
                        if data.isJoin == 0 then
                            current_fast_list[i].cfgId = data.cfgId
                            current_fast_list[i].is_new = true
                            fast_list[j].isJoin = 1
                            break
                        end
                    end
                end
            end
        end
        for i=1,#current_fast_list,1 do
            if current_fast_list[i].is_new and current_fast_list[i].idx >2 then
                SL:SetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST, current_fast_list[i].idx, current_fast_list[i].cfgId, 0)
            end
        end
    end
    if mp_pill_itemId ~= 0 then
        SL:SetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST, 1, mp_pill_itemId, 0)
    end
    if hp_pill_itemId ~= 0 then
        SL:SetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST, 2, hp_pill_itemId, 0)
    end
end



function this:LUA_EVENT_LEVELCHANGE()
    self:RefreshPlayerLevel()
end


---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:DataListUpdateData(self.view.fast_data_list)
end

--刷新等级
---@param data RoleChangeData
function this:RefreshPlayerLevel(data)
    local tbl = SL:GetConfig("cfg_global", 10000, "id")
    local level = SL:GetMetaValue("LEVEL")
    if tbl and self.level ~= level and level == tonumber(tbl.value) then
        GUI:DataListUpdateData(self.view.fast_data_list)
    end
end

function this:Hide()
end

function this:Close()
end

return this
