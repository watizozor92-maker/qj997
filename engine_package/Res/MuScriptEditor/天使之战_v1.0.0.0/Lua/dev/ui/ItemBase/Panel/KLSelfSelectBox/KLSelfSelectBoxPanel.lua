---@class KLSelfSelectBoxPanel:UIKmlLuaPanelBase
---@field view KLSelfSelectBoxPanelView
---@field item cfg_item_column @道具宝箱
---@field box cfg_box_column @道具宝箱
---@field curCount number @已选个数
---@field totleCount number @总共可选个数
---@field useItems BagProtos.SelfChoiceBoxInfo[]
local KLSelfSelectBoxPanel = class(UIKmlLuaPanelBase)
local this = KLSelfSelectBoxPanel
---创建时调用一次
function this:Init()
    self.item = nil
    self.curCount = 0
    self.curCountList = {}
    self.totleCount = 0
    self.BoxTemplateList = {}
    self.useItems = {}
    self.itemCount = {}
    GUI:DataListInitData(self.view.loopscrollviewData,
            function()
                return self:LoopDataListItemCountFunc()
            end,
            function(realIndex)
                return self:LoopDataListItemGetFunc(realIndex)
            end,
            nil,
            function(realIndex, kmlcontrol)
                return self:LoopDataListItemUpdateFunc(realIndex, kmlcontrol)
            end)

    self.BoxTemplateList = {}
end

function this:LoopDataListItemCountFunc()
    return #self.groupList
end

function this:LoopDataListItemGetFunc()
    local item = GUI:UIPanel_Open("dev/ui/ItemBase/Item/KLSelfSelectBox/KLSelfSelectBoxItem", self.view.loopscrollviewData, self, nil, true)

    

    local kmlControl = item.view.root
    self.BoxTemplateList[kmlControl] = item
    return kmlControl
end

function this:LoopDataListItemUpdateFunc(realIndex, kmlcontrol)
    ---@type KLSelfSelectBoxItem
    local item = self.BoxTemplateList[kmlcontrol]
    item:InitData(self.groupList[realIndex + 1], self, self.itemCount[self.groupList[realIndex + 1]])
    --local test = GUI:GetChildControl(self.view.equipzhiyeNeedData,realIndex,'test')
    --GUI:Text_setString(test,"dddddddd")
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.itemIndex = self.args.gridIndex
    self.item = SL:GetConfig("cfg_item", self.args.item.cfgId)
    if self.item == nil then
        return
    end
    local titleColor = SL:GetColorCfg(self.item.color)
    if titleColor then
        GUI:Text_setTextColor(self.view.text4, titleColor.color)
    end
    GUI:Text_setString(self.view.text4, self.item.name)
    self.groupList = self:GetAllGroupList()
    GUI:DataListUpdateData(self.view.loopscrollviewData)

    --SL:ScheduleOnce(0.15,function()
    --    local layoutW, _ = GUI:getSizeDelta(self.view.ItemLayout)
    --    local scrollW, _ = GUI:getSizeDelta(self.view.scrollview)
    --    GUI:setPositionX(self.view.ItemLayout, layoutW / 2 - scrollW)
    --end)
end

function this:GetAllGroupList()
    if string.isNullOrEmpty(self.item.useParam) then
        SL:LogError('self.item.useParam is nil')
    end

    self.curCountList = {}
    self.useItems = {}

    local boxgroupList = {}
    self:GetGroupList(boxgroupList, self.item.useParam)
    self.totleCount = SL:GetBagItemCount(self.item.id)
    self:SetNumText()
    --for _, v in ipairs(self.box.groupId) do
    --	---@type cfg_box_group_column
    --	local boxgroup = SL:GetConfig("cfg_box_group",v)
    --	if boxgroup ~= nil then
    --		
    --		self:GetGroupList(boxgroupList, boxgroup.item1)
    --		self:GetGroupList(boxgroupList, boxgroup.item2)
    --		self:GetGroupList(boxgroupList, boxgroup.item3)
    --		self:GetGroupList(boxgroupList, boxgroup.item4)
    --		self:GetGroupList(boxgroupList, boxgroup.item5)
    --	end
    --end
    return boxgroupList
end

---@param originBoxGroupList table
---@param groupList IntListList
function this:GetGroupList(originBoxGroupList, groupList)
    local tbl = SL:Split(groupList, "|")
    for _, v in pairs(tbl) do
        local item = SL:Split(v, "#")
        local id = tonumber(item[1])
        if not table.contains(originBoxGroupList, id) then
            table.insert(originBoxGroupList, id)
            if item[2] then
                self.itemCount[id] = tonumber(item[2])
            else
                self.itemCount[id] = 1
            end

        end
    end
    return originBoxGroupList
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnclose, self, self.CloseBtnClick)
    GUI:AddOnClickEvent(self.view.btnopen, self, self.OpenBtnClick)
end

function this:CloseBtnClick()
    GUI:UIPanel_Close("dev/ui/ItemBase/Panel/KLSelfSelectBox/KLSelfSelectBoxPanel")
end

function this:SetItemCount(itemId, num)
    if not self.curCountList[itemId] then
        self.curCountList[itemId] = 0
    end
    self.curCountList[itemId] = self.curCountList[itemId] + num
    self:SetNumText()
    self:SetItemInfo()
end

function this:InputItemCount(itemId, num)
    if not self.curCountList[itemId] then
        self.curCountList[itemId] = 0
    end
    self.curCountList[itemId] = num
    self:SetNumText()
    self:SetItemInfo()
end

function this:SetNumText()
    self.curCount = 0
    for i, v in pairs(self.curCountList) do
        self.curCount = self.curCount + v
    end
    GUI:Text_setString(self.view.NumText, "当前持有数量:  <color=#00ff00>" .. tostring(self.curCount) .. '/' .. tostring(self.totleCount) .. "</color>")
end

function this:SetItemInfo()
    self.useItems = {}
    for i, v in pairs(self.curCountList) do
        for z = 1, v do
            table.insert(self.useItems, { itemId = i, count = self.itemCount[i] })
        end
    end
end

function this:OpenBtnClick()
    if table.count(self.useItems) == 0 then
        return
    end
    --SL:ReqUseSelfChoiceBoxMessage(self.itemIndex, self.useItems)
    InfoManager.selfSelectBoxInfo.useItems = {}
    table.copyFrom(InfoManager.selfSelectBoxInfo.useItems, self.useItems)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_USE_SELF_CHOICE_BOX, { boxItemId = self.item.id, items = self.useItems })
    self:CloseBtnClick()
end

function this:Close()
end

return this
