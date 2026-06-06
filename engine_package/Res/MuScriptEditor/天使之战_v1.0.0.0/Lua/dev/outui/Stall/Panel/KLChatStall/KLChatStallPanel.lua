---@class KLChatStallPanel:UIKmlLuaPanelBase
---@field view KLChatStallPanelView
local KLChatnStallPanel = class(UIKmlLuaPanelBase)
local this =KLChatnStallPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()

    self.all_items = {}
    table.insert(self.all_items,{name = "无物品",id=1})
    if self.args and self.args.data and self.args.data.allgoods then
        for i=2, 50,1 do
            if self.args.data.allgoods[tostring(i-1)] then
                local goods = self.args.data.allgoods[tostring(i-1)]
                table.insert(self.all_items,{cfgid=goods.itemcfgid,name = goods.itemname,itemid=goods.itemid,id=i})
            end
        end
    end
    self.select_list = {}

    GUI:DataListInitData(self.view.data_list_1,function()
        return self:FirstDataListItemCountFunc()
    end,function(realIndex)
        return self:FirstDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:FirstDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:FirstDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.all_item_1 = {}
    self.select_1 = 0

    GUI:DataListInitData(self.view.data_list_2,function()
        return self:TwoDataListItemCountFunc()
    end,function(realIndex)
        return self:TwoDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:TwoDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:TwoDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.all_item_2 = {}
    self.select_2 = 0

    GUI:DataListInitData(self.view.data_list_3,function()
        return self:ThreeDataListItemCountFunc()
    end,function(realIndex)
        return self:ThreeDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:ThreeDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:ThreeDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.all_item_3 = {}
    self.select_3 = 0

    local map_name = SL:GetConfig("cfg_map_info",self.args.pos.mapId,"id").mapname
    local pos_str = "摊位坐标<color=#EC8000>" .. map_name .. ":" .. self.args.pos.pointX .. "," .. self.args.pos.pointY .. "</color>"
    GUI:Text_setString(self.view.pos_text,pos_str)
    local cost_str = SL:GetConfig("cfg_global",13004,"id").value
    local cost_list = string.split(cost_str,'#')
    self.cost_cfg_id = tonumber(cost_list[1])
    self.cost_num = tonumber(cost_list[2])
    GUI:Item_setItemId(self.view.cost_item, self.cost_cfg_id)
    --GUI:Text_setString(self.view.cost_text, tostring(self.cost_num))
    GUI:SetZIndex(self.view.cost_item,400)
    local haveCount = SL:GetBagItemCount(self.cost_cfg_id)
    if haveCount < self.cost_num then
        GUI:Text_setString(self.view.cost_text, string.format('<color="#9b1818">%d</color>', tostring(self.cost_num) ))
    else
        GUI:Text_setString(self.view.cost_text, string.format('<color="#00ff00">%d</color>', tostring(self.cost_num)))
    end
    
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Close()
    self:UnRegistEvents()
end


---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close, self, self.ClosePanel)
    GUI:AddOnClickEvent(self.view.open1, self, self.OpenFirst)
    GUI:AddOnClickEvent(self.view.close1, self, self.CloseFirst)  
    GUI:AddOnClickEvent(self.view.open2, self, self.OpenTwo)
    GUI:AddOnClickEvent(self.view.close2, self, self.CloseTwo)  
    GUI:AddOnClickEvent(self.view.open3, self, self.OpenThree)
    GUI:AddOnClickEvent(self.view.close3, self, self.CloseThree)  
    GUI:AddOnClickEvent(self.view.btn_send, self, self.SendChat) 
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WORLD_CHAT_SUCCESS,self.RES_WORLD_CHAT_SUCCESS,self)
end

function this:UnRegistEvents()
    SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.RES_WORLD_CHAT_SUCCESS,self.RES_WORLD_CHAT_SUCCESS,self)
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/outui/Stall/Panel/KLChatStall/KLChatStallPanel")
end

function this:SendChat()
    if not self.args or not self.args.data or not self.args.data.allgoods or not self.args.data.allgoods["1"] then
        SL:TipMessage("上架物品后才能发送喊话", 1, NoticeType.NoticeMid )
        return
    end

    local IsNeedAndActiveMonthCard = InfoManager.monthCardInfo:IsHaveMonthCardRights("chat")
    if not IsNeedAndActiveMonthCard then
        SL:TipMessage(SL:GetConfig('cfg_string',289).text, 1, NoticeType.NoticeMid )--"购买并使用月卡或日卡后解锁聊天系统",
        return
    end
    local chat_type = EChatChannelType.WORLD
    if chat_type == EChatChannelType.WORLD then
        local level = tonumber(SL:GetConfig("cfg_global", 125).value)

        local playLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
        if level > playLevel then
            SL:TipMessage(level.."级解锁世界发言", 1, NoticeType.NoticeMid )
            return
        end
    end

    local send_str = SL:GetConfig("cfg_global",13003,"id").value
    local map_name = SL:GetConfig("cfg_map_info",self.args.pos.mapId,"id").mapname
    local posStr = string.format("pos@%s,%s,%s,%s@",self.args.pos.pointX,self.args.pos.pointY,self.args.pos.mapId,self.args.pos.line)
    local str = string.replace(send_str,'[4]',posStr)
    local ChatItem = {}
    if #self.select_list > 0 then
        local num = 0
        local item_str = ""
        for i=1,#self.select_list do
            local curr_id = self.select_list[i]
            if curr_id > 1 then
                num = num + 1
                local itemid = self.all_items[curr_id].itemid
                table.insert(ChatItem,{lid=itemid,type=3})
                local emojiStr = string.format("item@%s:%s@",num,3)
                item_str = item_str .. emojiStr .. ","
            end
        end
        if not string.isNullOrEmpty(item_str) then
            str = item_str..str
        end
    end
    local my_num = SL:GetBagItemCount(self.cost_cfg_id)
    if my_num < self.cost_num then
        SL:TipMessage("道具不足", 1, NoticeType.NoticeMid )
            return
    end
    SL:SendChat(chat_type,str,nil,ChatItem)
end

function this:RES_WORLD_CHAT_SUCCESS(_,message)
    if message then
        if self.cost_cfg_id and self.cost_num then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_DELETE_BAG_ITEM,{self.cost_cfg_id,self.cost_num})
            self:ClosePanel()
        end
    end
end

function this:OpenFirst()
    GUI:setVisible(self.view.open1,false)
    GUI:setVisible(self.view.close1,true)
    GUI:setVisible(self.view.select_view_1,true)
    GUI:DataListUpdateData(self.view.data_list_1)
end

function this:CloseFirst()
    GUI:setVisible(self.view.open1,true)
    GUI:setVisible(self.view.close1,false)
    GUI:setVisible(self.view.select_view_1,false)
end

function this:Select(type,id)
    if type == 1 then
        if self.select_1 == id then
            return
        end
        if self:CheckHave(id) then
            SL:TipMessage("该道具已进入喊话列表，请选择其他道具",1, NoticeType.NoticeMid)
            GUI:setVisible(self.view.select_view_1,false)
            return
        end
        if id == 1 and self.select_1 ~= 1 then
            table.removeByValue(self.select_list,self.select_1)
        elseif id ~= 1 and self.select_1 == 1 then
            table.insert(self.select_list,id)
        else
            table.removeByValue(self.select_list,self.select_1)
            table.insert(self.select_list,id)
        end
        self.select_1 = id
        local name = self.all_items[self.select_1].name
        GUI:Text_setString(self.view.notice_text_1,name)
        self:CloseFirst()
    elseif type == 2 then
        if self.select_2 == id then
            return
        end
        if self:CheckHave(id) then
            SL:TipMessage("该道具已进入喊话列表，请选择其他道具",1, NoticeType.NoticeMid)
            GUI:setVisible(self.view.select_view_2,false)
            return
        end
        if id == 1 and self.select_2 ~= 1 then
            table.removeByValue(self.select_list,self.select_2)
        elseif id ~= 1 and self.select_2 == 1 then
            table.insert(self.select_list,id)
        else
            table.removeByValue(self.select_list,self.select_2)
            table.insert(self.select_list,id)
        end
        self.select_2 = id
        local name = self.all_items[self.select_2].name
        GUI:Text_setString(self.view.notice_text_2,name)
        self:CloseTwo()

    elseif type == 3 then
        if self.select_3 == id then
            return
        end
        if self:CheckHave(id) then
            SL:TipMessage("该道具已进入喊话列表，请选择其他道具",1, NoticeType.NoticeMid)
            GUI:setVisible(self.view.select_view_3,false)
            return
        end
        if id == 1 and self.select_3 ~= 1 then
            table.removeByValue(self.select_list,self.select_3)
        elseif id ~= 1 and self.select_3 == 1 then
            table.insert(self.select_list,id)
        else
            table.removeByValue(self.select_list,self.select_3)
            table.insert(self.select_list,id)
        end
        self.select_3 = id
        local name = self.all_items[self.select_3].name
        GUI:Text_setString(self.view.notice_text_3,name)
        self:CloseThree()

    end
    
end

function this:CheckHave(id)
    for i, v in ipairs(self.select_list) do
        if v == id then
            return true
        end
    end
    return false
end


function this:FirstDataListItemCountFunc()
    return #self.all_items
end

function this:FirstDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/Stall/Item/KLStallChatSelectItem/KLStallChatSelectItem",self.view.data_list_1,self,{},true)
    self.all_item_1[realIndex+1] = item
    return item.view.root
end

function this:FirstDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:FirstDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.all_items[realIndex + 1]
    self.all_item_1[realIndex+1]:RefreshItem({message=data,type=1},self.select_1,self)
end


--第二个物品
function this:OpenTwo()
    GUI:setVisible(self.view.open2,false)
    GUI:setVisible(self.view.close2,true)
    GUI:setVisible(self.view.select_view_2,true)
    GUI:DataListUpdateData(self.view.data_list_2)
end

function this:CloseTwo()
    GUI:setVisible(self.view.open2,true)
    GUI:setVisible(self.view.close2,false)
    GUI:setVisible(self.view.select_view_2,false)
end


function this:TwoDataListItemCountFunc()
    return #self.all_items
end

function this:TwoDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/Stall/Item/KLStallChatSelectItem/KLStallChatSelectItem",self.view.data_list_2,self,{},true)
    self.all_item_1[realIndex+1] = item
    return item.view.root
end

function this:TwoDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:TwoDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.all_items[realIndex + 1]
    self.all_item_1[realIndex+1]:RefreshItem({message=data,type=2},self.select_2,self)
end


--第3个物品
function this:OpenThree()
    GUI:setVisible(self.view.open3,false)
    GUI:setVisible(self.view.close3,true)
    GUI:setVisible(self.view.select_view_3,true)
    GUI:DataListUpdateData(self.view.data_list_3)
end

function this:CloseThree()
    GUI:setVisible(self.view.open3,true)
    GUI:setVisible(self.view.close3,false)
    GUI:setVisible(self.view.select_view_3,false)
end


function this:ThreeDataListItemCountFunc()
    return #self.all_items
end

function this:ThreeDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/Stall/Item/KLStallChatSelectItem/KLStallChatSelectItem",self.view.data_list_3,self,{},true)
    self.all_item_1[realIndex+1] = item
    return item.view.root
end

function this:ThreeDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:ThreeDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.all_items[realIndex + 1]
    self.all_item_1[realIndex+1]:RefreshItem({message=data,type=3},self.select_3,self)
end

return this
