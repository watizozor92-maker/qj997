---@class KLUIChatSmallPanel:UIKmlLuaPanelBase
---@field view KLUIChatSmallPanelView
local KLUIChatSmallPanel = class(UIKmlLuaPanelBase)
local this = KLUIChatSmallPanel
---创建时调用一次
function this:Init()
    SL:SetCloseChatType({})
    GUI:UIPanel_Open("dev/ui/Chat/Item/KLUIChatSmallItem/KLUIChatSmallItem",self.view.templateRoot,self,{},nil,
            function (tempUI)
                self.calculationUI = tempUI
                GUI:setPositionX(self.calculationUI.view.root,2000)
                GUI:setPositionY(self.calculationUI.view.root,2000)
                GUI:DataListInitData(self.view.chat_small_data_list,function()
                    return self:ChatDataListItemCountFunc()
                end,function(realIndex)
                    return self:ChatDataListItemGetFunc(realIndex)
                end,function(realIndex, kmlcontrol)
                    return self:ChatDataListItemInitFunc(realIndex, kmlcontrol)
                end, function(realIndex, kmlcontrol)
                    return self:ChatDataListItemUpdateFunc(realIndex, kmlcontrol)
                end, function(realIndex, kmlcontrol)
                    return self:ChatDataItemSizeGetFunc(realIndex, kmlcontrol)
                end)
                self.chat_all_item = {}
                self:UpdateChanInfo()
                self.updateID = SL:Schedule(self.updateID,0,Time.deltaTime,-1,function()
                    self:Update()
                end)
            end)
end

function this:Update()
    if not self.nextDoRevTime then
        return
    end
    if Time.time>self.nextDoRevTime then
        self.nextDoRevTime = nil
        self:UpdateChanInfo()
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()

end


---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_RECEIVE, self.ChatReceive, self)
    GUI:AddOnClickEvent(self.view.viewport_attach, self, self.OpenChatPanel)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_LINK_POS, self.ChatLinlk,self)
    SL:RegisterLUAEvent(Event.FriendChatReceiveEvent, self.FriendChatReceiveEvent, self)
end


function this:ClosePanel()
    SL:CloseChatUI()
    SL.ShowMainPanel()
end

function this:Close()
    SL:UnSchedule(self.updateID)
end

function this:UpdateChanInfo()
    self.chat_list = {}
    self.chat_list = SL:ChatInfo_GetChatInfo(EChatChannelType.ALL,4)
    self:RefreshData(self.chat_list)
    
end

function this:RefreshData(chat_list)
    self.chat_list = chat_list
    GUI:DataListUpdateData(self.view.chat_small_data_list)
    GUI:SetScrollView_scrollpos(self.view.chat_small_view,#self.chat_list-1)
end


function this:ChatReceive(_id,message)
    self.nextDoRevTime = Time.time+Time.deltaTime
end

function this:OpenChatPanel()
    SL:OpenChatUI()
end


function this:ChatDataListItemCountFunc()
    return #self.chat_list
end
function this:ChatDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/ui/Chat/Item/KLUIChatSmallItem/KLUIChatSmallItem",self.view.chat_small_data_list,self,{},true)
    
    self.chat_all_item[item.view.root] = item
    return item.view.root
end
function this:ChatDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:ChatDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.chat_list[realIndex + 1]
    if not data.itemSizeSmall then
        local sss = {message=data,itemIndex=realIndex + 1}
        self.calculationUI:RefreshItem(sss)
        local xx,yy = GUI:getSizeDelta(self.calculationUI.view.controls.richSmall)
        data.itemSizeSmall = Vector2(xx, yy+6)
    end
    local mess = {message=data,itemIndex=realIndex + 1}
    self.chat_all_item[kmlcontrol]:RefreshItem(mess)
end
function this:ChatDataItemSizeGetFunc(realIndex)
    local data = self.chat_list[realIndex + 1]
    if not data.itemSizeSmall then
        local mess = {message=data,itemIndex=realIndex + 1}
        self.calculationUI:RefreshItem(mess)
        local xx,yy = GUI:getSizeDelta(self.calculationUI.view.controls.richSmall)
        data.itemSizeSmall = Vector2(xx, yy+6)
    end
    return data.itemSizeSmall
end

function this:ChatLinlk(id,params)

    local linkType = tonumber(params[2])
    local message = params[3]
    local player_id = nil
    if params.Length >= 5 then
        player_id = params[4]
    end
    --位置链接
    if linkType == 1 then
        local data = string.split(message,"#")
        local x = tonumber(data[1])
        local y = tonumber(data[2])
        local mapId = tonumber(data[3])
        local line = tonumber(data[4])
        local tab = SL:GetConfig("cfg_map_info",mapId,"id")
        local serverType = tab.serverType
        if serverType == 2 then
            if not self:CrossServerStall() then
                return
            end
        end
        if tab.nopositionmove == 1 then
            SL:TipMessage( SL:GetConfig('cfg_string',35004).text,1, NoticeType.NoticeMid )--聊天不能传送副本
            return
        end
        SL:Pathfinding(mapId, line, x, y,nil,nil,true)
        SL:CloseChatUI()
        GUI:UIPanel_Close("dev/ui/FriendSys/Panel/KLFriendMain/KLFriendMainPanel")
        SL.ShowMainPanel()
        --道具装备链接
    elseif linkType == 10 then
        local data = string.split(message,"#")
        local id = tonumber(data[1])
        local cfgId = tonumber(data[2])
        EquipFunc.otherRid = tostring(player_id)
        SL.Friend:ReqOtherRoleInfoMessage(player_id, 4)
        SL:OpenTips("chat", cfgId, id,nil,nil,{otherRid = player_id})
    elseif linkType == 3 then
        local data = string.split(message,"#")
        local teamId = tonumber(data[6])
        SL:RequestApplyAgree(teamId)
    end
end


function this:CrossServerStall()
    local mapid = SL:GetConfig("cfg_activity_rule",20001).mapid[1]
    local tab = SL:GetConfig("cfg_map_info",mapid)
    local message = ""
    self.level_lock = false
    self.strength_lock = false
    self.append_lock = false
    self.open_level = 0
    if tab.condition and #tab.condition>0 then
        local condition = tab.condition
        local level = condition[1]
        local strength_level = condition[2]
        local append_level = condition[3]
        local player_level = SL:GetMetaValue("LEVEL")
        local all_strength_level = EquipFunc.GetAllStrengthLevel()
        local all_append_level = EquipFunc.GetAllAppendLevel()
        if player_level < level then
            message = message .. "等级" .. level .. "级"
            self.level_lock = true
            self.open_level = level
        end
        if all_strength_level < strength_level then
            if not string.isNullOrEmpty(message) then
                message = message .. "，"
            end
            message = message .. "强化总等级" .. strength_level
            self.strength_lock = true

        end
        if all_append_level < append_level then
            if not string.isNullOrEmpty(message) then
                message = message .. "，"
            end
            message = message .. "追加总等级" .. append_level
            self.append_lock = true
        end
        if not string.isNullOrEmpty(message) then
            message = message .. "可进入"
        end
    end
    if self.level_lock then
        SL:TipMessage( self.open_level.."级开启，无法进入", 1, NoticeType.NoticeMid )
        return
    end
    if self.strength_lock then
        SL:TipMessage( SL:GetConfig('cfg_string',257).text,1, NoticeType.NoticeMid )--"全身强化等级不足，无法进入", 
        return
    end
    if self.append_lock then
        SL:TipMessage(SL:GetConfig('cfg_string',257).text,  1, NoticeType.NoticeMid )--"全身追加等级不足，无法进入",
        return
    end
--[[    if not self:IsHavePrivilege() then
        SL:TipMessage( SL:GetConfig('cfg_string',258).text, 1, NoticeType.NoticeLeftBottom )--"<color=#426ECC>月卡时间不足，无法使用地图传送功能</color>",
        return
    end]]

    return true
end


function this:IsHavePrivilege()
    if InfoManager.monthCardInfo.IsGetMonthCard or InfoManager.monthCardInfo.IsGetDailyCard then
        --有月卡或是日卡
        return true
    end
    return false
end


---好友聊天信息变化
function this:FriendChatReceiveEvent(_, _senderId)
    if SL:GetMetaValue(EMetaVarGetKey.UID) == _senderId then
        return
    end
    InfoManager.friend_senderId = _senderId
    SL:onLUAEvent(LUA_EVENT_BUBBLETIPS_ADD,{id=PopoverType.Tip_friends})
end

return this
