---@class KLPickupSettingPanel:UIKmlLuaPanelBase
---@field view KLPickupSettingPanelView
local KLPickupSettingPanel = class(UIKmlLuaPanelBase)
local this = KLPickupSettingPanel
local pickUpRangeList = {}
---创建时调用一次
function this:Init()
    self.pickUpTemplateList = {}
    self.pickUpData = {}
    self.ItemTextList = {}
    if SL:HasConfig("cfg_global", 700001) then
        local list = string.split(SL:GetConfig("cfg_global", 700001).value, '#')
        for i, v in pairs(list) do
            pickUpRangeList[i] = tonumber(v)
        end
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()

    if InfoManager.uiHookInfo.autoPickUpText ~= "" then
        GUI:SetInputText(self.view.TextInput,"")
        GUI:Toggle_setIsOn(self.view.MyAutoPickUpToggle,true)
    end
    --  if not PrivilegeCardManager.isautoPick() then
    --     GUI:Toggle_setIsOn(self.view.AutoPickToggle, false)
    --     self:TipCardPick()
    --     return
    -- end

    if SL:GetPlayerAutoPickIsOpen() then
        GUI:SetTogDefaultThis(self.view.AutoPickToggle)
    else
        
    end

    local pickUpInfo = SL:GetMetaValue(EMetaVarGetKey.GET_ATUO_PICKUP_ITEM)
    local tblList = SL:GetConfigTable("cfg_pickdrop_condition")
    local sortList = {}
    local count = 0
    for _, v in pairs(tblList) do
        sortList[v.sort] = v.id
        count = count + 1
    end
    for i=1, count do
        local v = SL:GetConfig("cfg_pickdrop_condition", sortList[i])
        if v then
           local data = { name = v.groupName[1], pickUpId = v.id, isPickUp = pickUpInfo[v.id] }
            ---@type KLPickUpItem
            local pickUpTemplate = self.pickUpTemplateList[v.id]
            if not pickUpTemplate then
                pickUpTemplate = GUI:UIPanel_Open("dev/ui/Setting/Item/KLPickUp/KLPickUpItem", self.view.pickItemList, self,
                data, true)
            else
                pickUpTemplate.args = data
                pickUpTemplate:Refresh()
            end
            self.pickUpTemplateList[v.id] = pickUpTemplate 
        end
    end
    -- ---@param v cfg_pickdrop_condition_column
    -- for i, v in pairs(tblList) do
    --     local data = { name = v.groupName[1], pickUpId = v.id, isPickUp = pickUpInfo[v.id] }
    --     ---@type KLPickUpItem
    --     local pickUpTemplate = self.pickUpTemplateList[v.id]
    --     if not pickUpTemplate then
    --         pickUpTemplate = GUI:UIPanel_Open("dev/ui/Setting/Item/KLPickUp/KLPickUpItem", self.view.pickItemList, self,
    --             data, true)
    --     else
    --         pickUpTemplate.args = data
    --         pickUpTemplate:Refresh()
    --     end
    --     self.pickUpTemplateList[v.id] = pickUpTemplate
    -- end

    

    
    if InfoManager.uiHookInfo.autoPickUpText and InfoManager.uiHookInfo.autoPickUpText ~= "" then
        self.ItemTextList = string.split(InfoManager.uiHookInfo.autoPickUpText,"，")
    end
    self.range = pickUpRangeList[1]
    if InfoManager.uiHookInfo.playerPickRange then
        for i, v in pairs(pickUpRangeList) do
            if v == InfoManager.uiHookInfo.playerPickRange then
                self.range = i
                break
            end
        end
    end
    
    GUI:DataListInitData(self.view.ItemDataList, function()
        return table.count(self.ItemTextList)
    end, function()
    end, function()
    end, function(realIndex)
        local dataInfo = self.ItemTextList[realIndex + 1]
        local DeleteBtn = GUI:GetChildControl(self.view.ItemDataList, realIndex, 'DeleteBtn')
        local NameItem = GUI:GetChildControl(self.view.ItemDataList, realIndex, 'NameItem')
        if dataInfo then
            GUI:Text_setText(NameItem,dataInfo)
        end
        GUI:AddOnClickEvent(DeleteBtn, self, self.OnClickDeleteBtn,dataInfo)
    end)
    GUI:SetTogDefaultThis(self.view["toggle_pos_" .. self.range])
    GUI:DataListUpdateData(self.view.ItemDataList,true)
end
function this:OnClickDeleteBtn(_,dataInfo)
    if dataInfo then
        local infoList = {}
        for _,v in pairs(self.ItemTextList) do
            if dataInfo ~= v then
                table.insert(infoList,v)
            end
        end
        self.ItemTextList = infoList
        if self.ItemTextList then
            local str = ""
            for _,v in pairs(self.ItemTextList) do
                str = str.."，"..v
            end
            if str then
                InfoManager.uiHookInfo.autoPickUpText = str
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_PICK_UP_NAMES, {filterNames = str, playerPickRange = pickUpRangeList[self.range]})
            end
        end
        GUI:DataListUpdateData(self.view.ItemDataList,true)
    end
end
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.AutoPickToggle, self, self.AutoPickToggleChaneg)
    GUI:SetToggleOnValueChange(self.view.MyAutoPickUpToggle, self, self.MyAutoPickUpToggle)
    GUI:AddOnClickEvent(self.view.addBtn, self, self.addBtnOnClick)
    GUI:SetToggleOnValueChange(self.view.toggle_pos_1,self,self.SelectPickRangeOnToggleValueChange,1)
    GUI:SetToggleOnValueChange(self.view.toggle_pos_2,self,self.SelectPickRangeOnToggleValueChange,2)
    GUI:SetToggleOnValueChange(self.view.toggle_pos_3,self,self.SelectPickRangeOnToggleValueChange,3)
    GUI:SetToggleOnValueChange(self.view.toggle_pos_4,self,self.SelectPickRangeOnToggleValueChange,4)
    GUI:SetToggleOnValueChange(self.view.toggle_pos_5,self,self.SelectPickRangeOnToggleValueChange,5)
    GUI:SetToggleOnValueChange(self.view.toggle_pos_6,self,self.SelectPickRangeOnToggleValueChange,6)
    GUI:SetToggleOnValueChange(self.view.toggle_pos_7,self,self.SelectPickRangeOnToggleValueChange,7)
    GUI:SetToggleOnValueChange(self.view.toggle_pos_8,self,self.SelectPickRangeOnToggleValueChange,8)
end

function this:SelectPickRangeOnToggleValueChange(control,data,eventData)
    local isOn = eventData[1]
    if isOn then
        self.range = data
    end
end

function this:addBtnOnClick()
    local IsOpen = GUI:Toggle_getIsOn(self.view.MyAutoPickUpToggle)
    if IsOpen == "0" then
        SL:TipMessage("请先勾选指定拾取", 1, NoticeType.NoticeMid)
        return
    end
    local str = GUI:GetInputText(self.view.TextInput)
    if str ~= "" then
        if GUIUtil.GetStrLen(str) > 24 then
            SL:TipMessage("名称过长", 1, NoticeType.NoticeMid)
            return
        end
        if table.contains(self.ItemTextList,str) then
            SL:TipMessage("已包含当前关键词", 1, NoticeType.NoticeMid)
        else
            SL:TipMessage("添加成功", 1, NoticeType.NoticeMid)
            table.insert(self.ItemTextList,str)
            GUI:DataListUpdateData(self.view.ItemDataList,true)
        end
        if self.ItemTextList then
            local str1 = ""
            for _,v in pairs(self.ItemTextList) do
                str1 = str1.."，"..v
            end
            if str1 then
                InfoManager.uiHookInfo.autoPickUpText = str1
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_PICK_UP_NAMES, {filterNames = str1, playerPickRange = pickUpRangeList[self.range]})
            end
        end
    else
        SL:TipMessage("关键词不能为空", 1, NoticeType.NoticeMid)
    end

end
function this:MyAutoPickUpToggle(_, customData, eventData)
    if eventData[1] then
--[[        local str = GUI:GetInputText(self.view.TextInput)
        if str then
            InfoManager.uiHookInfo.autoPickUpText = str
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_PICK_UP_NAMES, str)
        end]]
    else
        self.ItemTextList = {}
        InfoManager.uiHookInfo.autoPickUpText = ""
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_PICK_UP_NAMES, {filterNames = "", playerPickRange = pickUpRangeList[self.range]})
        GUI:DataListUpdateData(self.view.ItemDataList,true)
    end
end
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

function this:SetData(pickUpId,value)
    self.pickUpData[pickUpId] = value
end

function this:Save()
    for key, value in pairs(self.pickUpData) do
        SL:SetMetaValue(EMetaVarSetKey.SET_ATUO_PICKUP_ITEM,key,value)
    end
    if self.ItemTextList then
        local str = ""
        for _,v in pairs(self.ItemTextList) do
            str = str.."，"..v
        end
        if str then
            InfoManager.uiHookInfo.autoPickUpText = str
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_PICK_UP_NAMES, {filterNames = str, playerPickRange = pickUpRangeList[self.range]})
        end
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_PICK_UP_SETTINGS)

end

function this:ReDefaultOnClick()
    SL:ReplyDefaultPickUpSetting()
    self:Refresh()
end

function this:TipCardPick()
    SL:OpenCommonTipPanelById(16)
end

function this:Close()
    self:Save()
end

return this
