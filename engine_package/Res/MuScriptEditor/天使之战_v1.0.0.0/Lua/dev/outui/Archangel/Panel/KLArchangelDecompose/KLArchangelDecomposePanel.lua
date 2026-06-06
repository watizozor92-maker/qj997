---@class KLArchangelDecomposePanel:UIKmlLuaPanelBase
---@field view KLArchangelDecomposePanelView
---@field grailList CommonProtos.Item[]
---@field selectGrailList number[]
---@field grailItemList KLGrailDecomposeItem[]
local KLArchangelDecomposePanel = class(UIKmlLuaPanelBase)
local this = KLArchangelDecomposePanel
function this:AsyncLoadUI()
end

---创建时调用一次
function this:Init()
    SL.HideMainPanel()
    self.grailList = {}
    self.grailItemList = {}
    GUI:DataListInitData(self.view.DecomposeGetDataList, function()
        return #self.getList
    end, function(realIndex)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GetDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)

    GUI:DataListInitData(self.view.DecomposeCustomDataList, function()
        return #self.costList
    end, function(realIndex)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:CustomDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)

    GUI:DataListInitData(self.view.grail_list, function()
        return #self.grailList
    end, function(realIndex)
        return self:GrailDecomposeItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GrailDecomposeItemUpdateFunc(realIndex, kmlcontrol)
    end)

    GUI:UIPanel_Open("dev/outui/Archangel/Panel/KLGrailDecomposeOption/KLGrailDecomposeOptionPanel", nil, nil,
        { x = 482, y = 0 }, false, function()
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseButton, self, self.ClosePanel)
    GUI:AddOnClickEvent(self.view.DecomposeButton, self, self.Decompose)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GRAIL_DECOMPOSE_RESULT, self.RES_GRAIL_DECOMPOSE_RESULT, self)
    SL:RegisterLUAEvent(LUA_EVENT_GRAIL_DECOMPOSE_SETTING_CHANGE, self.AutoSelect, self)
end

---界面显示时调用一次
function this:Show()

end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.isClick = false
    GUI:setVisible(self.view.hide_panel, false)
    GUI:setVisible(self.view.NoInfo, true)
    self.grailList = {}
    self.selectGrailList = {}
    if not self.bagUI then
        self:AutoSelect()
        GUI:UIPanel_Open("dev/outui/Archangel/Panel/KLFusionBag/KLFusionBagPanel", nil, nil,
            { x = -482, y = 0, selectList = self.selectGrailShow, itemClick = self.BagItemClick, callBackUI = self },
            false, function(bagUI)
            ---@type KLFusionBagPanel
            self.bagUI = bagUI
            self.bagUI:RefreshItem(self:GetBagList())
            -- self:AutoSelect()
        end)
    else
        -- self.bagUI:RefreshGrailSelect({})
        self.bagUI:RefreshItem(self:GetBagList(), self, function()
            self:AutoSelect()
        end)
    end
end

function this:AutoSelect()
    self.selectGrailList = {}
    self.grailList = {}
    self.selectGrailShow = {}
    local data = self:GetBagList()
    for i, v in pairs(data) do
        local grailQuality = SL:GetConfig("cfg_equip_angelGrail", v.cfgId, "id").grailQuality
        if InfoManager.archangeEquipInfo:GetDecomposeSetting(grailQuality) then
            table.insert(self.selectGrailList, v.id)
            local pos = table.getKey(self.selectGrailList, v.id)
            self.grailList[pos] = v
            self.selectGrailShow[v.id] = true
        else
            self.selectGrailShow[v.id] = false
        end
    end
    if self.bagUI then
        self.bagUI:RefreshGrailSelect(self.selectGrailShow)
    end
    self:RefreshCostandGet()
end

function this:BagItemClick(itemControl, itemData, itemSelf)
    if table.contains(self.selectGrailList, itemData.id) then
        itemSelf:SetSelectEffect(false, true)
        local pos = table.getKey(self.selectGrailList, itemData.id)
        table.remove(self.grailList, pos)
        table.removeByValue(self.selectGrailList, itemData.id)
    else
        table.insert(self.selectGrailList, itemData.id)
        local pos = table.getKey(self.selectGrailList, itemData.id)
        self.grailList[pos] = itemData
        itemSelf:SetSelectEffect(true, true)
    end
    self:RefreshCostandGet()
end

function this:RefreshCostandGet()
    if table.count(self.selectGrailList) == 0 then
        GUI:setVisible(self.view.hide_panel, false)
        GUI:setVisible(self.view.NoInfo, true)
        return
    end
    GUI:setVisible(self.view.hide_panel, true)
    GUI:setVisible(self.view.NoInfo, false)
    --刷新道具显示
    GUI:DataListUpdateData(self.view.grail_list)
    --刷新所得
    local getListData = {}
    local costListData = {}
    self.getList = {}
    self.costList = {}
    for i, v in pairs(self.grailList) do
        local angelstrengthenLv = InfoManager.archangeEquipInfo:GetGrailStrengthLv(v.id)
        local strengthenTbl = SL:GetConfig("cfg_equip_angelStrengthen", v.cfgId, "id")
        local costTbl = SL:GetConfigTwoKeys("cfg_equip_angelStrengthenCost", strengthenTbl.SplitGroup, angelstrengthenLv,
            "AngelstrengthenGroup", "AngelstrengthenLv")
        for _, j in pairs(costTbl.AngelstrengthenGet) do
            if getListData[j[1]] then
                getListData[j[1]] = getListData[j[1]] + j[2]
            else
                getListData[j[1]] = j[2]
            end
        end
        for _, j in pairs(costTbl.RecoVeryCost) do
            if costListData[j[1]] then
                costListData[j[1]] = costListData[j[1]] + j[2]
            else
                costListData[j[1]] = j[2]
            end
        end
    end
    for i, v in pairs(getListData) do
        table.insert(self.getList, { itemId = i, count = v })
    end
    for i, v in pairs(costListData) do
        table.insert(self.costList, { itemId = i, count = v })
    end
    GUI:DataListUpdateData(self.view.DecomposeGetDataList)
    GUI:DataListUpdateData(self.view.DecomposeCustomDataList)
end

function this:GrailDecomposeItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/Archangel/Item/KLGrailDecompose/KLGrailDecomposeItem", self.view.grail_list,
        self, nil, true)
    self.grailItemList[item.view.root] = item
    return item.view.root
end

function this:GrailDecomposeItemUpdateFunc(realIndex, kmlcontrol)
    self.grailItemList[kmlcontrol]:RefeshData(self.grailList[realIndex + 1].cfgId, self.grailList[realIndex + 1].id)
end

function this:GetDataListItemUpdateFunc(realIndex, kmlcontrol)
    local GetItem = GUI:GetChildControl(self.view.DecomposeGetDataList, realIndex, "GetItem")
    GUI:Item_setItemId(GetItem, self.getList[realIndex + 1].itemId)
    GUI:Item_setItemCount(GetItem, tostring(self.getList[realIndex + 1].count))
end

function this:CustomDataListItemUpdateFunc(realIndex, kmlcontrol)
    local cost_item = GUI:GetChildControl(self.view.DecomposeCustomDataList, realIndex, "cost_item")
    local cost_name = GUI:GetChildControl(self.view.DecomposeCustomDataList, realIndex, "cost_name")
    local cost_num = GUI:GetChildControl(self.view.DecomposeCustomDataList, realIndex, "cost_num")
    local costAddBtn = GUI:GetChildControl(self.view.DecomposeCustomDataList, realIndex, "costAddBtn")
    local data = self.costList[realIndex + 1]
    GUI:Item_setItemId(cost_item, data.itemId)
    ---@type cfg_item_column
    local itemTbl = SL:GetConfig("cfg_item", data.itemId, "id")
    GUI:Text_setString(cost_name, itemTbl.name)
    local costNumStr = ""
    local bagCount = SL:GetBagItemCount(data.itemId)

    if bagCount >= data.count then
        costNumStr = "<color='#00ff00'>" .. tostring(bagCount) .. "</color>/" .. tostring(data.count)
        --self.isCost = true
    else
        costNumStr = "<color='#ff2323'>" .. tostring(bagCount) .. "</color>/" .. tostring(data.count)
        --self.isCost = false
    end
    GUI:Text_setString(cost_num, costNumStr)
    GUI:AddOnClickEvent(costAddBtn, self, function()
        SL:CommonItemGetPath(nil, data.itemId)
    end)
end

function this:GetBagList()
    local data = {}
    local bagItemTabl = SL:GetMetaValue("BAG_DATA")[1]
    if bagItemTabl then
        for _, v in pairs(bagItemTabl) do
            local tbl = nil
            if SL:HasConfig("cfg_equip_angelGrail", v.cfgId, "id") then
                table.insert(data, v)
            end
        end
    end
    return data
end

function this:Decompose()
    if self.isClick then
       return 
    end
    local indexlist = {}
    for i, v in pairs(self.selectGrailList) do
        table.insert(indexlist, SL:GetBagIndex(v))
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ANGEL_GRAIL_DECOMPOSE,
        { indexList = indexlist, grailIds = self.selectGrailList })
    self.isClick = true
end

function this:RES_GRAIL_DECOMPOSE_RESULT(_, message)
    self.isClick = false
    if message then
        for i, v in pairs(self.selectGrailList) do
            InfoManager.archangeEquipInfo:GrailInfoChange(v)
        end
        InfoManager.archangeEquipInfo:CheckEquipRed()
        local group = GUI:GetUI("dev/outui/Archangel/Panel/KLArchangelGroup/KLArchangelGroupPanel")
        if group then
            group:RefreshRed()
        end
        self:Refresh()
    end
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLArchangelDecompose/KLArchangelDecomposePanel")
    GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLArchangelGroup/KLArchangelGroupPanel")
end

function this:Hide()
end

function this:Close()
    GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLFusionBag/KLFusionBagPanel")
    GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLGrailDecomposeOption/KLGrailDecomposeOptionPanel")
end

return this
