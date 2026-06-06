---@class KLDepotsPanel:UIKmlLuaPanelBase
---@field view KLDepotsPanelView
---@field CurPage number
local KLDepotsPanel = class(UIKmlLuaPanelBase)
local this = KLDepotsPanel
---创建时调用一次
function this:Init()
    ---@type KLDepotsSelectItem[]
    self.KLDepotsSelectItemList = {}
    this.curSelectTemp = nil
    this.storeText = self.view.storeText
    this.UnLockGridPage = 0
    local cfg = string.split(SL:GetConfig("cfg_global", 8).value, '|')
    this.privilegeDepots_info = {}
    for i, v in ipairs(cfg) do
        this.privilegeDepots_info[#this.privilegeDepots_info + 1] = string.split(v, '#')
    end
    this.maxPrivilegePages = #this.privilegeDepots_info
    this.unlockPrivilegePages = PrivilegeCardManager.GetDepotUp()
    this.LockList = {}
    ---初始化数据
    local itemList = SL:GetMetaValue("STORAGE_DATA", 1)
    local forbidCount = SL:GetMetaValue("STORAGE_FORBID_COUNT", 1)
    self.Depots_info = string.split(SL:GetConfig("cfg_global", 7).value, '|')
    for _, v in pairs(self.Depots_info) do
        local info = string.split(v, '#')
        if info[4] == "0" then
            this.UnLockGridPage = this.UnLockGridPage + 1
        end
        this.LockList[tonumber(info[3])] = info
    end
    this.maxDepotsPages = #self.Depots_info
    if SL:GetMetaValue("GET_STORAGE_MAX_PAGE") ~= 1 then
        this.UnLockGridPage = SL:GetMetaValue("GET_STORAGE_MAX_PAGE")
    end
    ---@type KLUIBagTileScrollViewItem
    ---@param panel KLUIBagTileScrollViewItem
     GUI:UIPanel_Open("dev/ui/Common/Item/KLUIBagTileScrollView/KLUIBagTileScrollViewItem",
            self.view.sv_frame, self, { itemList = itemList, id = EBagTileScrollViewId.Storage, forbidCount = forbidCount,
                                    hor = tonumber(this.LockList[1][1]), vet = tonumber(this.LockList[1][2]), forbidClickCallback = self.forbidClick, x = 4, y = -2.5,contentScale = 1.32, page = 1,
                                    dragEndCallback = self.dragEnd, parent = self },nil,function(panel)
                 this.StoreBagUI = panel
                 GUI:setContentSize(panel.view.BagTileScrollViewPrefab, 360, 506)
                 GUI:setPosition(panel.view.BagTileScrollViewPrefab, 0, 0)
                 GUI:setContentSize(panel.view.prefabBagTileScrollView_, 360, 506)
            end)
    
    GUI:SetActive(self.view.edit_panel, false)
    GUI:SetActive(self.view.forbid_red_panel, false)
    this.bagType = "depots"
end
function this:forbidClick(_, _, eventData)
    if this.bagType == "privilege" then
        SL:TipMessage( "未开放", 1, NoticeType.NoticeMid )
        return
    end
    local bag_unlock_info = SL:GetConfig('cfg_global', 159).value
    local bag_unlock_split = string.split(bag_unlock_info, '#')
    local itemId = tonumber(bag_unlock_split[1])
    local needCount = tonumber(bag_unlock_split[2])
    local addCount = tonumber(bag_unlock_split[3])
    local maxAddCount = tonumber(bag_unlock_split[4])
    local itemName = SL:GetConfig("cfg_item", itemId).name

    SL:CommonTipsMessage({ stringTblID = 602, stringTblFormat={itemName, addCount}, ui = self,
                           cfgId = itemId,
                           needCount = needCount,
                           callback = self.UnlockGrid, callbackData = needCount })
end
function this:UnlockGrid()
   return SL:ReqStoreAddCapacityMessage(1, this.CurPage)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local x = 0
    local y = 0
    if self.args then
        x = self.args.x or -344
        y = self.args.y or 0
    else
        SL:HideMainPanel()
    end

    --GUI:setPosition(self.view.root, x, y)
    for i, v in pairs(self.Depots_info) do
        ---@type KLDepotsSelectItem
        local item = GUI:UIPanel_Open("dev/ui/Bag/Item/KLDepotsSelect/KLDepotsSelectItem", self.view.ItemContent, self, nil, true,function(item)

            item:SetClickDelegate(self.ButtonSelectOnClick, i)
            table.insert(self.KLDepotsSelectItemList, item)
            if i == 1 then
                this.CurPage = 1
                self:SetPageBtnSelect(this.CurPage)
            end
        end)

    end

end
----刷新仓库数据
function this:RefreshPageUI(page)
    if this.bagType == "privilege" then
        local itemList = SL:GetMetaValue("STORAGE_DATA", page + this.maxDepotsPages)
        local hor = tonumber(this.privilegeDepots_info[page][1])
        local vet = tonumber(this.privilegeDepots_info[page][2])
        local forbidCount = 0
        
        this.StoreBagUI.itemList = itemList
        this.StoreBagUI.forbidCount = forbidCount
        this.StoreBagUI.hor = hor
        this.StoreBagUI.vet = vet
        this.StoreBagUI.id = EBagTileScrollViewId.Storage
        this.StoreBagUI.page = this.CurPage
        this.StoreBagUI.contentScale = 1.21
        this.StoreBagUI:RefreshItemByItem(itemList)
        this.StoreBagUI:RefreshForbidGrid(forbidCount)
    else
        local itemList = SL:GetMetaValue("STORAGE_DATA", page)
        local forbidCount = SL:GetMetaValue("STORAGE_FORBID_COUNT", page)
        local hor = tonumber(this.LockList[page][1])
        local vet = tonumber(this.LockList[page][2])

        this.StoreBagUI.itemList = itemList
        this.StoreBagUI.forbidCount = forbidCount
        this.StoreBagUI.hor = hor
        this.StoreBagUI.vet = vet
        this.StoreBagUI.id = EBagTileScrollViewId.Storage
        this.StoreBagUI.page = this.CurPage
        this.StoreBagUI:RefreshItemByItem(itemList)
        this.StoreBagUI:RefreshForbidGrid(forbidCount)
    end
    GUI:setContentSize(this.StoreBagUI.view.BagTileScrollViewPrefab, 360, 506)
    GUI:setPosition(this.StoreBagUI.view.BagTileScrollViewPrefab, 0, 0)
    GUI:setContentSize(this.StoreBagUI.view.prefabBagTileScrollView_, 360, 506)
end
function this:ButtonSelectOnClick(SelectTemp, index, needRefresh)
    local depotsName = ""
    if this.bagType == "privilege" then
        depotsName = "privilege_storage_Name"
    elseif this.bagType == "depots" then
        depotsName = "storage_Name"
    end
    if this.bagType == "depots" and index > this.UnLockGridPage then
        local bag_unlock_info = SL:GetConfig('cfg_global', 195).value
        local bag_unlock_split = string.split(bag_unlock_info, '#')
        local itemId = tonumber(bag_unlock_split[1])
        local needCount = tonumber(bag_unlock_split[2])
        local addPage = tonumber(bag_unlock_split[3])
        local itemName = SL:GetConfig("cfg_item", itemId).name
        SL:CommonTipsMessage({stringTblID=206, stringTblFormat={tostring(itemName), tostring(addPage)},
                              ui = self,
                              cfgId = itemId,
                              needCount = needCount,
                              callback = self.UnlockPage, callbackData = needCount,NotSureCloseSelf = true })
        return
    end
    if this.bagType == "privilege" then
        if index > this.unlockPrivilegePages then
            if this.lockButShowMaxPage and index <= this.lockButShowMaxPage then
                GUI:setVisible(self.view.forbid_red_panel, true)
            else
                SL:TipMessage( "未开放！", 1, NoticeType.NoticeMid )
                return
            end
        else
            GUI:setVisible(self.view.forbid_red_panel,false)
        end
    end
    if index ~= this.CurPage or needRefresh then
        this:RefreshPageUI(index)
    end

    this.CurPage = index
    SL:SetMetaValue(EMetaVarSetKey.SET_STORAGE_CURPAGE,this.CurPage)
    if SL:MeData_Check() then
        if self.bagType == "depots" then
            local name = PlayerPrefs.GetString(SL:GetMetaValue(EMetaVarGetKey.UID) .. depotsName .. this.CurPage, "仓库" .. index)
            GUI:Text_setString(this.storeText, name)
        elseif self.bagType == "privilege" then
            local name = PlayerPrefs.GetString(SL:GetMetaValue(EMetaVarGetKey.UID) .. depotsName .. this.CurPage, "特权仓库" .. index)
            GUI:Text_setString(this.storeText, name)
        end
    else
        GUI:Text_setString(this.storeText, "仓库" .. index)
    end
    if this.curSelectTemp then
        GUI:SetActive(this.curSelectTemp.view.DotRed, false)
    end
    GUI:SetActive(SelectTemp.view.DotRed, true)
    this.curSelectTemp = SelectTemp


end

---仓库页数
---@param index number @第几页
function this:SetPageBtnSelect(index, needRefresh)
    for i, v in pairs(self.KLDepotsSelectItemList) do
        if i == index then
            self:ButtonSelectOnClick(v, index, needRefresh)
        end
    end
end
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.closeBtn)
    GUI:AddOnClickEvent(self.view.pageLeft_btn, self, self.pageLeft_btn)
    GUI:AddOnClickEvent(self.view.pageRight_btn, self, self.pageRight_btn)
    GUI:AddOnClickEvent(self.view.add_btn, self, self.add_btn)
    GUI:AddOnClickEvent(self.view.tidy_btn, self, self.tidy_btn)
    GUI:AddOnClickEvent(self.view.priv_btn, self, self.priv_btn)
    GUI:AddOnClickEvent(self.view.storage_btn, self, self.storage_btn)

    GUI:AddOnClickEvent(self.view.edit_btn, self, self.edit_btn)
    GUI:AddOnClickEvent(self.view.edit_CloseBtn, self, self.edit_CloseBtn)
    GUI:AddOnClickEvent(self.view.edit_Cancel, self, self.edit_CloseBtn)
    GUI:AddOnClickEvent(self.view.edit_Enter, self, self.edit_Enter)

    SL:RegisterLUAEvent(LUA_EVENT_STORAGE_UNLOCK, self.RefreshPageUIChange, self)
    SL:RegisterLUAEvent(LUA_EVENT_STORE_HOUSE_INFO_CHANGE, self.RefreshPageUIChange, self)
    SL:RegisterLUAEvent(LUA_EVENT_STORE_HOUSE_PAGE, self.LUA_EVENT_STORE_HOUSE_PAGE, self)

    GUI:Input_SetOnValueChange(self.view.store_Name_Input, self, self.Input_SetOnValueChange)
end
function this:Input_SetOnValueChange()
    local textName = GUI:GetInputText(self.view.store_Name_Input)
    if string.isNullOrEmpty(textName) then
        return
    elseif string.find(textName, "%s") ~= nil then
        SL:TipMessage(SL:GetConfig('cfg_string',276).text,  1, NoticeType.NoticeMid )--"名称中不能包含空格",
    elseif self:GetStrLen(textName) >= 10 then
        SL:TipMessage( SL:GetConfig('cfg_string',277).text, 1, NoticeType.NoticeMid )--"名称过长",
        GUI:SetInputText(self.view.store_Name_Input, "")
    end
end
function this:add_btn()
    local bag_unlock_info = SL:GetConfig('cfg_global', 195).value
    local bag_unlock_split = string.split(bag_unlock_info, '#')
    local itemId = tonumber(bag_unlock_split[1])
    local needCount = tonumber(bag_unlock_split[2])
    local addPage = tonumber(bag_unlock_split[3])
    local itemName = SL:GetConfig("cfg_item", itemId).name
    SL:CommonTipsMessage({stringTblID=206, stringTblFormat={tostring(itemName), tostring(addPage)},
                          ui = self,
                          cfgId = itemId,
                          needCount = needCount,
                          callback = self.UnlockPage, callbackData = needCount,NotSureCloseSelf = true })
--[[    GUI:UIPanel_Open("dev/ui/Common/Panel/KLCommonItemTips/KLCommonItemTipsPanel", nil, nil,
            { showTips = string.format("是否消耗%s扩充%s页仓库？", itemName, addPage), ui = self,
              cfgId = itemId,
              needCount = needCount,
              callback = self.UnlockPage, callbackData = needCount })]]
end
function this:UnlockPage()
    local bag_unlock_info = SL:GetConfig('cfg_global', 195).value
    local bag_unlock_split = string.split(bag_unlock_info, '#')
    local itemId = tonumber(bag_unlock_split[1])
    local needCount = tonumber(bag_unlock_split[2])
    if needCount > SL:GetBagItemCount(itemId) then
        SL:CommonItemGetPath(nil, itemId)
        SL:TipMessage("消耗道具不足", 1, NoticeType.NoticeMid)
        return
    end
    SL:ReqStoreAddPageMessage(1)
    GUI:UIPanel_Close("dev/ui/Common/Panel/KLUICommonTips/KLUICommonTipsPanel")
end

function this:LUA_EVENT_STORE_HOUSE_PAGE(_, maxPage)
    if this.UnLockGridPage ~= maxPage then
        this.UnLockGridPage = maxPage
        self:SetPageBtnSelect(maxPage)

    end
end

function this:RefreshPageUIChange()
    this:RefreshPageUI(this.CurPage)
end

function this:tidy_btn()
    return SL:ReqTidyStoreItemMessage(this.CurPage)
end

function this:priv_btn()
    --if this.unlockPrivilegePages == 0 then
    self:CheckPrivilegeDepotsHaveItem()
    if this.lockButShowMaxPage == 0 then
        if not PrivilegeCardManager.goldPrivilege and not PrivilegeCardManager.diamondPrivilege then
            SL:TipMessage( "请先解锁特权", 1, NoticeType.NoticeMid )
            return
        end
    end
    GUI:setVisible(self.view.priv_btn, false)
    GUI:setVisible(self.view.add_btn, false)
    GUI:setVisible(self.view.storage_btn, true)
    this.bagType = "privilege"  
    this.CurPage = 1
    self:RefreshSelectItemList(this.maxPrivilegePages)
    self:SetPageBtnSelect(this.CurPage, true)
end

function this:CheckPrivilegeDepotsHaveItem()
    this.lockButShowMaxPage = 0
    for i = this.unlockPrivilegePages + 1, this.maxPrivilegePages do
        local item = SL:GetMetaValue("STORAGE_DATA", i + this.maxDepotsPages)
        if item and next(item) then
            this.lockButShowMaxPage = i
        end
    end 
end

function this:storage_btn()
    GUI:setVisible(self.view.forbid_red_panel, false)
    GUI:setVisible(self.view.priv_btn, true)
    GUI:setVisible(self.view.add_btn, true)
    GUI:setVisible(self.view.storage_btn, false)
    this.bagType = "depots"
    this.CurPage = 1
    self:RefreshSelectItemList(#self.Depots_info)
    self:SetPageBtnSelect(this.CurPage, true)
end

function this:RefreshSelectItemList(num)
    if #self.KLDepotsSelectItemList > num then
        for i = num + 1, #self.KLDepotsSelectItemList do
            GUI:UIPanel_Close(nil, self.KLDepotsSelectItemList[i])
            self.KLDepotsSelectItemList[i] = nil
        end
    elseif #self.KLDepotsSelectItemList < num then
        for i = #self.KLDepotsSelectItemList + 1, num do
            ---@type KLDepotsSelectItem
            local item = GUI:UIPanel_Open("dev/ui/Bag/Item/KLDepotsSelect/KLDepotsSelectItem", self.view.ItemContent, self, nil, true)
            item:SetClickDelegate(self.ButtonSelectOnClick, i)
            table.insert(self.KLDepotsSelectItemList, item)
        end
    end
end

function this:edit_Enter()
    local depotsName = ""
    if this.bagType == "privilege" then
        depotsName = "privilege_storage_Name"
    elseif this.bagType == "depots" then
        depotsName = "storage_Name"
    end
    local textName = GUI:GetInputText(self.view.store_Name_Input)
    if string.isNullOrEmpty(textName) then
        SL:TipMessage( SL:GetConfig('cfg_string',275).text, 1, NoticeType.NoticeMid )--"名称不能为空",
    elseif string.find(textName, "%s") ~= nil then
        SL:TipMessage( SL:GetConfig('cfg_string',276).text, 1, NoticeType.NoticeMid )--"名称中不能包含空格",
    elseif self:GetStrLen(textName) >= 10 then
        SL:TipMessage( SL:GetConfig('cfg_string',277).text, 1, NoticeType.NoticeMid )--"名称过长",
    else
        GUI:SetActive(self.view.edit_panel, false)
        GUI:Text_setString(self.view.storeText, textName)
        if SL:MeData_Check() then
            PlayerPrefs.SetString(SL:GetMetaValue(EMetaVarGetKey.UID) .. depotsName .. this.CurPage, textName)
        end
    end
end

function this:edit_btn()
    GUI:SetInputText(self.view.store_Name_Input,"")
    GUI:SetActive(self.view.edit_panel, true)
    GUI:Text_setString(self.view.old_Store_Name, "仓库" .. this.CurPage)
end
function this:edit_CloseBtn()
    GUI:SetActive(self.view.edit_panel, false)
end

function this:pageLeft_btn()
    if this.CurPage - 1 >= 1 then
        self:SetPageBtnSelect(this.CurPage - 1)
    end
end
function this:pageRight_btn()
    if this.bagType == "depots" then
        if this.CurPage + 1 <= self.UnLockGridPage then
            self:SetPageBtnSelect(this.CurPage + 1)
        else
            if this.CurPage == #self.Depots_info then
                SL:TipMessage( "扩容已达上限", 1, NoticeType.NoticeMid )
                return
            end
            local bag_unlock_info = SL:GetConfig('cfg_global', 195).value
            local bag_unlock_split = string.split(bag_unlock_info, '#')
            local itemId = tonumber(bag_unlock_split[1])
            local needCount = tonumber(bag_unlock_split[2])
            local addPage = tonumber(bag_unlock_split[3])
            local itemName = SL:GetConfig("cfg_item", itemId).name
            SL:CommonTipsMessage({stringTblID=206, stringTblFormat={tostring(itemName), tostring(addPage)},
                                  ui = self,
                                  cfgId = itemId,
                                  needCount = needCount,
                                  callback = self.UnlockPage, callbackData = needCount,NotSureCloseSelf = true  })
        end
    elseif this.bagType == "privilege" then
        if this.CurPage + 1 <= this.unlockPrivilegePages then
            self:SetPageBtnSelect(this.CurPage + 1)
        else
            if this.CurPage + 1 <= this.lockButShowMaxPage then
                self:SetPageBtnSelect(this.CurPage + 1)
            else
                SL:TipMessage( "未开放", 1, NoticeType.NoticeMid )
            end
        end
    end
end

function this:closeBtn()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel")

end
function this:Close()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    SL:ShowMainPanel()
end

function this:dragEnd(eventData)
    local bagHor = eventData.bagPutHor
    local bagVet = eventData.bagPutVet
    local raycastObj = eventData.raycastObj
    local dragItem = eventData.dragItem
    local storageHor = eventData.storageHor
    local storageVet = eventData.storageVet

    -- 丢弃道具
    if raycastObj == nil then
        local canDrop = self:GetItemCanDrop(dragItem)
        if canDrop then
            local article = SL:GetConfig('cfg_item', dragItem.item.cfgId).article
            local name = SL:GetConfig('cfg_item', dragItem.item.cfgId).name
            local isDestroy = table.contains(article, 3)
            if isDestroy then
                GUI:UIPanel_Open("dev/ui/Common/Panel/KLUICommonTips/KLUICommonTipsPanel", nil, nil, { showTips = string.format("是否摧毁%s", name), callback = self.DropItem, callbackData = { item = dragItem.item }, ui = self })
            else
                GUI:UIPanel_Open("dev/ui/Common/Panel/KLUICommonTips/KLUICommonTipsPanel", nil, nil, { showTips = string.format("是否丢弃%s", name), callback = self.DropItem, callbackData = { item = dragItem.item }, ui = self })
            end
        else
            SL:TipMessage( "该道具不可被丢弃", 1, NoticeType.NoticeMid )
        end
        return
    end

    local bagMaxHor, bagMaxVet = SL:GetMetaValue(EMetaVarGetKey.GET_BAG_MAX_HOR_VERT)
    if bagHor <= bagMaxHor and bagHor > 0 and bagVet <= bagMaxVet and bagVet > 0 then
        ---@type CommonProtos.Item
        --local dragItem = eventData.dragItem
        local oldIndex = eventData.index
        local newIndex = SL.Bag:GetIndexWithPageHorAndVet(1, bagHor, bagVet)
        if self.bagType == "privilege" then
            SL:ReqStoreToBagMessage((this.CurPage + this.maxDepotsPages) * 10000 + oldIndex, newIndex)
        elseif self.bagType == "depots" then
            SL:ReqStoreToBagMessage(this.CurPage * 10000 + oldIndex, newIndex)
        end
    else
        --local maxHor, maxVet = RoleManager.meData.storeHouseInfo:GetMaxHorAndVet()
        local maxHor,maxVet = SL:GetMetaValue(EMetaVarGetKey.GET_STORE_HOUSE_MAX_HV)
        if storageHor and storageHor <= maxHor and storageHor > 0 and storageVet <= maxVet and storageVet > 0 then
            local oldIndex = eventData.index
            if self.bagType == "privilege" then
                local newIndex = SL.StoreHouse:GetIndexWithPageHorAndVet(this.CurPage + this.maxDepotsPages, storageHor, storageVet)
                SL:ReqSwapStoreItemMessage((this.CurPage + this.maxDepotsPages) * 10000 + oldIndex, newIndex)
            elseif self.bagType == "depots" then
                local newIndex = SL.StoreHouse:GetIndexWithPageHorAndVet(this.CurPage, storageHor, storageVet)
                SL:ReqSwapStoreItemMessage(this.CurPage * 10000 + oldIndex, newIndex)
            end
        end
    end
end

---@param item KLBagItemItem
function this:GetItemCanDrop(item)
    local article = SL:GetConfig('cfg_item', item.item.cfgId).article
    local cantDrop = table.contains(article, 2)
    if cantDrop then
        return false
    end

    return not item.item.bind
end

function this.DropItem(data)
    local item = data.callbackData.item
    --local index = RoleManager.meData.storeHouseInfo:GetIndexBaseOnItemId(item.id)
    local index = SL:GetDepotsIndex(item.id)
    if index then
        SL:ReqStoreGiveUpItemMessage(index)
    end

end

function this:GetStrLen(inputstr)
    if not inputstr or type(inputstr) ~= "string" or #inputstr <= 0 then
        return nil
    end
    local length = 0  -- 字符的个数
    local i = 1
    while true do
        local lengthCount = 1
        local curByte = string.byte(inputstr, i)
        local byteCount = 1
        if curByte > 239 then
            byteCount = 4  -- 4字节字符
            lengthCount = 2
        elseif curByte > 223 then
            lengthCount = 2
            byteCount = 3  -- 汉字
        elseif curByte > 128 then
            byteCount = 2  -- 双字节字符
        else
            byteCount = 1  -- 单字节字符
        end
        i = i + byteCount
        length = length + lengthCount
        if i > #inputstr then
            break
        end
    end
    return length
end
return this
