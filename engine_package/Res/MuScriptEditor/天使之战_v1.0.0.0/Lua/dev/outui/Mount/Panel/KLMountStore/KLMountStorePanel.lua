---@class KLMountStorePanel:UIKmlLuaPanelBase
---@field view KLMountStorePanelView
---@field mountInfo_all_item KLMountInfoItem[]
local KLMountStorePanel = class(UIKmlLuaPanelBase)
local this =KLMountStorePanel
---创建时调用一次
function this:Init()
    self.mountInfo_all_item = {}
    self.mountInfoData = {}
    self.mountInfoItems = {}
    local temp = {}
    -- local skins = SL:GetConfigTable("cfg_mount_skin")
    -- ---@param v cfg_mount_skin_column
    -- for _, v in pairs(skins) do
    --     temp[v.skinid] = 1
    -- end 
    local tbl = SL:GetConfigTable("cfg_mount")
    ---@param v cfg_mount_column
    for _, v in pairs(tbl) do
        if not temp[v.id] and v.display == 0 then
            table.insert(self.mountInfoData, {mountId = v.id, mountName = v.name, isWear = false})
        end
    end
    self.size = Vector2(254, 90)
    GUI:DataListInitData(self.view.rideDatalist,function()
        return self:MountDataListItemCountFunc()
    end,function(realIndex)
        return self:MountDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:MountDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:MountDataListItemUpdateFunc(realIndex, kmlcontrol)
    end,
        function(realIndex)
        return self.size 
    end)
    self.attTxtList = {}
    GUI:DataListInitData(self.view.dataList_att,function()
        return table.count(self.attTxtList)
    end,function(realIndex)
        
    end,function(realIndex, kmlcontrol)
        
    end, function(realIndex, kmlcontrol)
        local att = self.attTxtList[realIndex + 1]
        local name = GUI:GetChildControl(self.view.dataList_att, realIndex, 'name')
        local num = GUI:GetChildControl(self.view.dataList_att, realIndex, 'num')
        local strList = string.split(att,"#")
        GUI:Text_setString(name, strList[1])
        GUI:Text_setString(num, strList[2])
    end)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if SL:GetIsWebGL() then
        GUI:setPositionX(self.view.closeBtn,-138)
    end
    SL.HideMainPanel()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_ALL_MOUNT)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_TOTAL_MOUNTS_INFO_INIT,self.RES_GET_ALL_MOUNT,self)
    SL:RegisterLUAEvent(LUA_EVENT_MOUNT_LEVEL_CHANGE, self.LUA_EVENT_MOUNT_LEVEL_CHANGE, self)
    GUI:AddOnClickEvent(self.view.closeBtn,self,self.OnClickCloseBtn)
end

function  this:OnClickCloseBtn()
    GUI:UIPanel_Close("dev/outui/Mount/Panel/KLMountStore/KLMountStorePanel")
    GUI:UIPanel_Close("dev/outui/Mount/Panel/KLMountDisplay/KLMountDisplayPanel")
    GUI:UIPanel_Close("dev/outui/Mount/Panel/KLMountSkins/KLMountSkinsPanel")
end

function this:RES_GET_ALL_MOUNT(_, message)
    self.curSelectMount = message.curRideId
    self.curSelectIndex = -1
    local index = 1
    for i, v in pairs(self.mountInfoData) do
        local mountId = v.mountId
        if self.curSelectMount == 0 then
            if index == 1 then
                self.curSelectIndex = 1
                self.curSelectMount = mountId
            end
        else
            if mountId == self.curSelectMount then
                self.curSelectIndex = index
            end    
        end
        v.isWear = mountId == message.curRideId
        index = index + 1
    end
    local data = {mountId=self.mountInfoData[self.curSelectIndex].mountId}
    local displayPanel = GUI:GetUI("dev/outui/Mount/Panel/KLMountDisplay/KLMountDisplayPanel")
    if not displayPanel then
        GUI:UIPanel_Open("dev/outui/Mount/Panel/KLMountDisplay/KLMountDisplayPanel",nil,nil,data)
    else
        displayPanel.args = data
        displayPanel:Refresh()
    end
    

    self.mountInfoItems = {}
    table.sort(self.mountInfoData, function(a, b) 
        local infoA = InfoManager.mountInfo:GetMountData(a.mountId) and 1 or 0
        local infoB = InfoManager.mountInfo:GetMountData(b.mountId) and 1 or 0
        if infoA ~= infoB then
            return infoA > infoB
        end
        ---@type cfg_mount_column
        local tbl = SL:GetConfig("cfg_mount", a.mountId)
        ---@type cfg_mount_column
        local tblB = SL:GetConfig("cfg_mount", b.mountId)
        if infoA == 0 then
            local itemCount = SL:GetBagItemCount(tbl.itemId)
            local itemCount2 = SL:GetBagItemCount(tblB.itemId)
            if itemCount ~= itemCount2 then
                return itemCount > itemCount2
            end
        end
        return tbl.id < tblB.id
    end)
    GUI:DataListUpdateData(self.view.rideDatalist, true)
    self:ShowAtts()
end

---切换选中坐骑
function this:SelectMount(mountId,index)
    if self.curSelectMount == mountId then return end
    if self.mountInfoItems[self.curSelectMount] then
        self.mountInfoItems[self.curSelectMount]:UpdateSelect(mountId)
    end
    self.curSelectMount = mountId
    self.curSelectIndex = index
    self.mountInfoItems[self.curSelectMount]:UpdateSelect(mountId)
    ---@type cfg_mount_column
    local tbl = SL:GetConfig("cfg_mount",mountId,"id")
    ---@type KLMountDisplayPanel
    local panel = GUI:GetUI("dev/outui/Mount/Panel/KLMountDisplay/KLMountDisplayPanel")
    if panel then
        panel.args.mountId = self.curSelectMount
        panel:Refresh()
    end

end

---显示所有属性
function this:ShowAtts()
    local mounts = InfoManager.mountInfo:GetTotalMounts()
    if mounts then
        local totalAtts = {}
        local supAtts = {}
        for _, v in pairs(mounts) do
            ---@type cfg_mount_column
            local tbl = SL:GetConfig("cfg_mount", v.mountId)
            ---@type cfg_mount_levelUp_column
            local lvTbl = SL:GetConfigTwoKeys("cfg_mount_levelUp", tbl.type, v.level, "type", "level")
            local containLevelAttId = false
            for _, att in pairs(tbl.attribute) do
                local attId = att[1]
                if attId == lvTbl.att[1] then
                    containLevelAttId = true
                    break
                end
            end
            if not containLevelAttId then
                table.insert(tbl.attribute, {lvTbl.att[1], 0})
            end
            for _, att in pairs(tbl.attribute) do
                if not totalAtts[att[1]] then
                    totalAtts[att[1]] = {att[1], 0}
                    table.insert(supAtts, totalAtts[att[1]])
                end
                local nowAtt = totalAtts[att[1]]
                nowAtt[2] = nowAtt[2] + att[2]
                if lvTbl and lvTbl.att and lvTbl.att[1] == att[1] then
                    nowAtt[2] = nowAtt[2] + lvTbl.att[2]
                end
            end
            if v.mountId == InfoManager.mountInfo:GetDefaultMountId() then
                table.insert(supAtts, {318011, tbl.speed})
            end
        end
        table.sort(supAtts, function(a, b)
            ---@type cfg_att_info_column
            local tblA = SL:GetConfig("cfg_att_info",a[1])
            ---@type cfg_att_info_column
            local tblB = SL:GetConfig("cfg_att_info",b[1])
            return tblA.sort < tblB.sort
        end)
        self:RefreshAttInfoList(supAtts)
    end
end

function this:RefreshAttInfoList(attribute)
    local attInfo = {}
    self.attTxtList = {}
    for i, v in pairs(attribute) do
        local isSkip = false
        local attId = v[1]
        local attNum = v[2]
        ---@type cfg_att_info_column
        local tbl = SL:GetConfig("cfg_att_info",attId,"id")
        local attTxt
        if tbl.remarks ~= EAttrRemarkType.Number then
            attTxt = attNum/100 .."%"
        else
            attTxt = attNum
        end
        if attId == 200011 then--最小
            attInfo[1] = "攻击力#"..attTxt.."~"
        elseif attId == 200021 then--最大
            attInfo[2] = attTxt
        elseif attId == 202021 then--最小
            attInfo[3] = "魔法攻击力#"..attTxt.."~"
        elseif attId == 202011 then--最大
            attInfo[4] = attTxt
        elseif attId == 205011 then--最小
            attInfo[5] = "诅咒攻击力#"..attTxt.."~"
        elseif attId == 205021 then--最大
            attInfo[6] = attTxt
        else
            attTxt = tbl.name.."#" ..attTxt
            table.insert(self.attTxtList,attTxt)
            isSkip = true
        end

        if not isSkip then
            if attInfo[1] and attInfo[2] then
                table.insert(self.attTxtList,attInfo[1]..attInfo[2])
                attInfo[1] = nil
                attInfo[2] = nil
            elseif attInfo[3] and attInfo[4] then
                table.insert(self.attTxtList,attInfo[3]..attInfo[4])
                attInfo[3] = nil
                attInfo[4] = nil
            elseif attInfo[5] and attInfo[6] then
                table.insert(self.attTxtList,attInfo[5]..attInfo[6])
                attInfo[5] = nil
                attInfo[6] = nil
            end
        end
    end
    GUI:SetActive(self.view.wujihuo,false)
    if table.isNullOrEmpty(self.attTxtList) then
        GUI:SetActive(self.view.wujihuo,true)
    end
    GUI:DataListUpdateData(self.view.dataList_att, true)
end

function this:MountDataListItemCountFunc()
    return #self.mountInfoData
end

function this:MountDataListItemGetFunc(realIndex)
    local data = self.mountInfoData[realIndex + 1]
    data.index = realIndex + 1
    local item = GUI:UIPanel_Open("dev/outui/Mount/Item/KLMountInfo/KLMountInfoItem",self.view.rideDatalist,self,data,true,function (item)
        self.mountInfo_all_item[item.view.root] = item
        self:MountDataListItemUpdateFunc(realIndex, item.view.root)
        return item.view.root
    end)
   
    return item.view.root
end

function this:MountDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:MountDataListItemUpdateFunc(realIndex, kmlcontrol)
    if self.mountInfo_all_item[kmlcontrol] then
        local data = self.mountInfoData[realIndex + 1]
        self.mountInfoItems[data.mountId] = self.mountInfo_all_item[kmlcontrol]
        self.mountInfo_all_item[kmlcontrol].args = data
        self.mountInfo_all_item[kmlcontrol]:Refresh(self.curSelectMount)
    end
end
---坐骑升级响应
function this:LUA_EVENT_MOUNT_LEVEL_CHANGE(_, id)
    GUI:DataListUpdateData(self.view.rideDatalist,true)
    self:ShowAtts()
end

function this:Close()
    SL.ShowMainPanel()
end

return this
