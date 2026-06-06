---@class KLMountEquipPanel:UIKmlLuaPanelBase
---@field view KLMountEquipPanelView
local KLMountEquipPanel = class(UIKmlLuaPanelBase)
local this =KLMountEquipPanel
---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_helment, self, self.btnClickCallBack, 51)
    GUI:AddOnClickEvent(self.view.btn_foot, self, self.btnClickCallBack, 54)
    GUI:AddOnClickEvent(self.view.btn_saddle, self, self.btnClickCallBack, 52)
    GUI:AddOnClickEvent(self.view.btn_rein, self, self.btnClickCallBack, 53)
    GUI:AddOnClickEvent(self.view.oneKeyPutOn, self, self.OneKeyPutOn)
    GUI:AddOnClickEvent(self.view.oneKeyTakeOff, self, self.OneKeyTakeOff)
    GUI:AddOnClickEvent(self.view.btn_recycle, self, self.GoToRecyclePage)
    SL:RegisterLUAEvent(LUA_EVENT_MOUNT_EQUIP_CHANGE, self.LUA_EVENT_MOUNT_EQUIP_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_MOUNT_BAG_CHANGE, self.LUA_EVENT_MOUNT_BAG_CHANGE, self)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.posToItem = {
        [51] = {btn = self.view.btn_helment, item = self.view.item_helment, red = self.view.red_helment},
        [54] = {btn = self.view.btn_foot, item = self.view.item_foot, red = self.view.red_foot},
        [52] = {btn = self.view.btn_saddle, item = self.view.item_saddle, red = self.view.red_saddle},
        [53] = {btn = self.view.btn_rein, item = self.view.item_rein, red = self.view.red_rein},
    }
    self.pos = nil
    self.mountId = self.args.mountId
    local mountData = InfoManager.mountInfo:GetMountData(self.mountId)
    local isActive = mountData ~= nil
    GUI:setVisible(self.view.ownerMountRoot, isActive and mountData.endTime == -1)
    GUI:setVisible(self.view.notActive, not isActive)
    GUI:setVisible(self.view.img_notForever, isActive and mountData.endTime > 0)
    if isActive and mountData.endTime > 0 then
        return
    end

    local needLevel = SL:GetConfig("cfg_system_switch", 1061).needLevel
    local myLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    local levelSatisfy = myLevel >= needLevel
    GUI:setVisible(self.view.ownerMountRoot, levelSatisfy and mountData.endTime == -1)

    if not levelSatisfy then
        return
    end
    self:UpdateEquips()
    local bag_info = string.split(SL:GetConfig("cfg_global", 6).value, '#')
    if self.bagTileScrollView then
        GUI:UIPanel_Close(nil, self.bagTileScrollView)
    end
    GUI:UIPanel_Open("dev/ui/Common/Item/KLUIBagTileScrollView/KLUIBagTileScrollViewItem", self.view.bagItemRoot, self,
            {
                isShowEffect = true,
                forbidCount = 40,
                id = EBagTileScrollViewId.Mount,
                hor = tonumber(bag_info[1]),
                vet = tonumber(bag_info[2]),
                canDrag = false,
                itemClick = self.itemClickCallBack,
                selectList = self.selectList,
                callBackUI = self
            },
            true,
            function(bagTileScrollView)
                ---@type KLUIBagTileScrollViewItem
                self.bagTileScrollView = bagTileScrollView
                GUI:setScaleX(self.bagTileScrollView.view.root, 0.8)
                GUI:setScaleY(self.bagTileScrollView.view.root, 0.8)
                GUI:setPosition(self.bagTileScrollView.view.root, -25, 70)
                GUI:setContentSize(self.bagTileScrollView.view.prefabBagTileScrollView_, 365, 720)
                self:SetSelect(51)
                --bagTileScrollView:RefreshItemByItem(itemList)
            end
    )
end

---刷新装备显示
function this:UpdateEquips()
    local bagItems = InfoManager.mountInfo:GetBagItems()
    local itemList = {}
    for _, v in pairs(bagItems) do
        ---@type cfg_item_column
        local tbl = SL:GetConfig("cfg_item", v.cfgId)
        if not itemList[tbl.subType] then
            itemList[tbl.subType] = {}
        end
        table.insert(itemList[tbl.subType], v)
    end
    for k, v in pairs(self.posToItem) do
        local pos = InfoManager.mountInfo:GetPosBySubType(k)
        local equip = InfoManager.mountInfo:GetMountEquipByPos(self.mountId, pos)
        if equip then
            GUI:setVisible(v.item, true)
            GUI:Item_UpdataData(v.item, {
                itemid = equip.cfgId
            })
            GUI:setVisible(v.red, false)
            if itemList[k] then
                local nowGrade = SL:GetConfig("cfg_equip_entryLib", equip.cfgId).initialRating
                for _, item in pairs(itemList[k]) do
                    local grade = SL:GetConfig("cfg_equip_entryLib", item.cfgId).initialRating
                    if grade > nowGrade then
                        GUI:setVisible(v.red, true)
                        break
                    end
                end
            end
        else
            GUI:setVisible(v.item, false)
            GUI:setVisible(v.red, itemList[k] and itemList[k][1])
        end
    end
end

function this:btnClickCallBack(_, pos)
    self:SetSelect(pos)
    local slot = InfoManager.mountInfo:GetPosBySubType(pos)
    local equip = InfoManager.mountInfo:GetMountEquipByPos(self.mountId, slot)
    if equip then
        SL.OpenTips_item = equip
        SL:OpenEquipTips("mountEquip", equip.cfgId, equip.id)
    end
end

function this:SetSelect(pos)
    if self.pos and self.pos == pos then
        return
    end
    self.pos = pos
    GUI:SetParent(self.view.selectPic, GUI:GetRectTransform(self.posToItem[pos].btn))
    GUI:setPosition(self.view.selectPic, 0, 4)
    local items = InfoManager.mountInfo:GetBagItems()
    local itemList = {}
    for k, v in pairs(items) do
        local item = SL:GetConfig("cfg_item", v.cfgId)
        if item and item.subType == pos then
            itemList[k - 10000] = v
        end
    end
    local finalList =  SL.Bag:SortItemList(itemList)
    self.bagTileScrollView:RefreshItemByItem(finalList)
end

---@return boolean equip2 > equip1
local function CompareGrade(equip1, equip2)
    ---@type cfg_equip_entryLib_column
    local entryLibColumn = SL:GetConfig("cfg_equip_entryLib", equip1)
    ---@type cfg_equip_entryLib_column
    local entryLibColumn2 = SL:GetConfig("cfg_equip_entryLib", equip2)
    return entryLibColumn2.initialRating > entryLibColumn.initialRating
end

---一键穿戴
function this:OneKeyPutOn()
    local mountData = InfoManager.mountInfo:GetMountData(self.mountId)
    if mountData then
        local items = InfoManager.mountInfo:GetBagItems()
        local infoList = {}
        for index, v in pairs(items) do
            local tbl = SL:GetConfig("cfg_item", v.cfgId)
            local pos = InfoManager.mountInfo:GetPosBySubType(tbl.subType)
            local nowEquip = InfoManager.mountInfo:GetMountEquipByPos(self.mountId, pos)
            if infoList[pos] == nil then
                if not nowEquip or CompareGrade(nowEquip.cfgId, v.cfgId) then
                    infoList[pos] = {id = self.mountId, idxOfBag = tonumber(index), cellidx = pos}
                end
            else
                if CompareGrade(InfoManager.mountInfo:GetBagItem(infoList[pos].idxOfBag).cfgId, v.cfgId) then
                    infoList[pos].idxOfBag = tonumber(index)
                end
            end
        end
        local reqList = {}
        for _, v in pairs(infoList) do
            table.insert(reqList, v)
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_PUT_ON_EQUIPS_MOUNT, reqList)
    end
end

---一键卸下
function this:OneKeyTakeOff()
    local mountData = InfoManager.mountInfo:GetMountData(self.mountId)
    if mountData then
        local infoList = {}
        for k, v in pairs(mountData.equips) do
            table.insert(infoList, {
              id = self.mountId, cellidx = tonumber(k)  
            })
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TAKE_OFF_EQUIPS_MOUNT, infoList)
    end
end

---跳往回收界面
function this:GoToRecyclePage()

    GUI:UIPanel_Close("dev/outui/Mount/Panel/KLMountStore/KLMountStorePanel")
    GUI:UIPanel_Close("dev/outui/Mount/Panel/KLMountDisplay/KLMountDisplayPanel")
    GUI:UIPanel_Close("dev/outui/Mount/Panel/KLMountSkins/KLMountSkinsPanel")
    GUI:UIPanel_Open("dev/outui/Mount/Panel/KLMountEquipRecover/KLMountEquipRecoverPanel")
end

---坐骑穿戴/脱下装备响应
function this:LUA_EVENT_MOUNT_EQUIP_CHANGE(_, id)
    if id == self.mountId then
        self:UpdateEquips()
    end
end

---坐骑背包数据变化响应
function this:LUA_EVENT_MOUNT_BAG_CHANGE()
    if self.bagTileScrollView then
        local items = InfoManager.mountInfo:GetBagItems()
        local itemList = {}
        for k, v in pairs(items) do
            local item = SL:GetConfig("cfg_item", v.cfgId)
            if item and item.subType == self.pos then
                itemList[k - 10000] = v
            end
        end
        local finalList =  SL.Bag:SortItemList(itemList)
        self.bagTileScrollView:RefreshItemByItem(finalList)
    end
end

function this:Close()
    self.selectEquipPos = nil
end

return this
