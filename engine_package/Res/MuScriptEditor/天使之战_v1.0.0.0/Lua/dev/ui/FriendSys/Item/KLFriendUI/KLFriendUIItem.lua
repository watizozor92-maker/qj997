---@class KLFriendUIItem:UIKmlLuaPanelBase
---@field view KLFriendUIItemView
---@field infoItems KLFriendInfoItem[]
---@field data FriendProto.FriendInfo[] @好友列表or黑名单列表
---@field friendMax number @好友上限数量
---@field blackMax number @黑名单上限数量
---@field chatPanel KLFriendChatItem
local KLFriendUIItem = class(UIKmlLuaPanelBase)
local this =KLFriendUIItem
---创建时调用一次
function this:Init()
    self.infoItems = {} 
    ---@type cfg_global_column
    local tbl = SL:GetConfig("cfg_global", 45)
    local split = string.split(tbl.value, "#")
    self.friendMax = tonumber(split[1])
    self.blackMax = tonumber(split[2])
    self.enemyLogList = {}
    GUI:DataListInitData(self.view.enemy_log_data_list,function()
        return self:EnemyLogDataListItemCountFunc()
    end,function(realIndex)
        return self:EnemyLogDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:EnemyLogDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:EnemyLogDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.logItem = {}
end

function this:EnemyLogDataListItemCountFunc()
    return #self.enemyLogList
end

function this:EnemyLogDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/FriendSys/Item/KLFriendEnemyLogText/KLFriendEnemyLogTextItem",
            self.view.enemy_log_data_list, self, {}, true)
    self.logItem[item.view.root] = item
    return item.view.root
end

function this:EnemyLogDataListItemInitFunc(realIndex, kmlcontrol)
    
end

function this:EnemyLogDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.enemyLogList[realIndex + 1]
    self.logItem[kmlcontrol]:SetLog(data)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

function this:SetType(type)
    if self.type and self.type == type then
        return false
    end
    self.type = type
    GUI:setVisible(self.view.BtnAdd, false)
    self:Recycle()
    return true
end

---@param data FriendProto.FriendInfo[]
function this:UpdateData(data)
    self.data = data
    local filePath = "dev/ui/FriendSys/Item/KLFriendInfo/KLFriendInfoItem"
    self:Recycle()
    local count = 0
    local firstFlag = true
    local is_select = false
    if InfoManager.friend_senderId then
        for _, v in pairs(self.data) do
            if v.rid == InfoManager.friend_senderId then
                is_select = true
            end
        end
    end
    for _, v in pairs(self.data) do
        ---@type KLFriendInfoItem
        GUI:UIPanel_Open(filePath, self.view.friend_layout, self, {info = v, toggleGroup = self.view.friend_layout, type=self.type}, true, function(item)
            GUI:SetToggleOnValueChange(item.view.KmlFriendListItem, self, self.OnClickPlayer, v)
            --默认选中
            if not is_select then
                if firstFlag then
                    item:SetChoose()
                    firstFlag = false
                end
            else
                if firstFlag and v.rid == InfoManager.friend_senderId then
                    item:SetChoose()
                    firstFlag = false
                end
            end
        end)
        count = count + 1
    end
    InfoManager.friend_senderId = nil
    GUI:setVisible(self.view.BtnAdd, self.type == EFriendRelation.Friend and count == 0)
    GUI:setVisible(self.view.friendimg, false)
    GUI:setVisible(self.view.friendimg1, self.type == EFriendRelation.Friend and count == 0)
    GUI:setVisible(self.view.friendimg2, self.type == EFriendRelation.Enemy and count == 0)
    GUI:setVisible(self.view.friendimg3, self.type == EFriendRelation.BlackList and count == 0)
    if count == 0 then
        GUI:setVisible(self.view.friend_line, false)
        GUI:Text_setString(self.view.friend_count, "")
    else
        GUI:setVisible(self.view.friend_line, true)
        GUI:Text_setString(self.view.friend_count, string.format("人数：%d/%d", count, self.type == EFriendRelation.Friend and self.friendMax or self.blackMax))
    end
end

---@param eventData FriendProto.FriendInfo
function this:OnClickPlayer(control, eventData, callBackData)
    if callBackData[1] then
        self.nowSelect = eventData

        GUI:setVisible(self.view.ChatContent, self.type == EFriendRelation.Friend)
        GUI:setVisible(self.view.BlackListContent, self.type == EFriendRelation.BlackList)
        GUI:setVisible(self.view.EnemyContent, self.type == EFriendRelation.Enemy)
        if self.type == EFriendRelation.Friend then
            if not self.chatPanel then
                GUI:UIPanel_Open("dev/ui/FriendSys/Item/KLFriendChat/KLFriendChatItem", self.view.ChatContent, self,nil,false, function(chatPanel)
                    self.chatPanel = chatPanel
                    chatPanel:SetFriend(eventData.rid)
                end)
            else
                if not GUI:IsUILoading(self.chatPanel) then
                    self.chatPanel:SetFriend(eventData.rid)
                end
            end
        else
            if self.chatPanel then
                GUI:UIPanel_Close(nil, self.chatPanel)
                self.chatPanel = nil
            end
            SL.Friend:ReqFriendLogsMessage(self.type, self.nowSelect.rid)
        end
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_FRIEND_LIST_CHANGE, self.FriendChange, self)
    GUI:AddOnClickEvent(self.view.BtnCancelForbid, self, self.RemoveForbid)
    SL:RegisterLuaNetMsg(MessageDef.ResFriendLogsMessage, self.ResFriendLogsMessage, self)
    GUI:AddOnClickEvent(self.view.BtnAdd, self, self.GoAddFriendPage)
    SL:RegisterLUAEvent(FRIEND_LIKE_ZERO_EVENT, self.FRIEND_LIKE_ZERO_EVENT, self)
end

function this:FRIEND_LIKE_ZERO_EVENT(id, type)
    if self.type == type then
        SL.Friend:ReqOpenFriendPanelMessage(type)
    end
end

function this:GoAddFriendPage()
    GUI:UIPanel_Open("dev/ui/FriendSys/Panel/KLFriendAdd/KLFriendAddPanel")
end

---@param message FriendProto.FriendLogsRes
function this:ResFriendLogsMessage(id, message)
    if message.type == EFriendRelation.BlackList then
        local res = ""
        for _, v in pairs(message.FriendLog) do
            local str = Time.FormatTimeYMDHMS(v.time//1000)
            res = res..string.format("在%s拉黑了他", str)
        end
        GUI:Text_setString(self.view.TextBlackInfo, res)
    elseif message.type == EFriendRelation.Enemy then
        self.enemyLogList = message.FriendLog
        GUI:DataListUpdateData(self.view.enemy_log_data_list)
    end
end

function this:RemoveForbid()
    if self.nowSelect then
        SL:DelBlackList(self.nowSelect.rid)
    end
end

--更新好友列表
function this:FriendChange(_, type)
    if type == self.type then
        local friends = SL:GetFriendData(type)
        self:UpdateData(friends)
    end
end

function this:Recycle()
    GUI:UIPanel_Close("dev/ui/FriendSys/Item/KLFriendInfo/KLFriendInfoItem")
    GUI:setVisible(self.view.EnemyContent, false)
    GUI:setVisible(self.view.ChatContent, false)
    GUI:setVisible(self.view.BlackListContent, false)
end

function this:Close()
end

return this
