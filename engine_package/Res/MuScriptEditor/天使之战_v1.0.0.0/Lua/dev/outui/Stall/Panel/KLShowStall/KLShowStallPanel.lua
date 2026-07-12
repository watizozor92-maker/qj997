---@class KLShowStallPanel:UIKmlLuaPanelBase
---@field view KLShowStallPanelView
local KLShowStallPanel = class(UIKmlLuaPanelBase)
local this = KLShowStallPanel
local MeSrollH = 398
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.itemPanelList = {}
    local capacity = SL:GetConfig("cfg_global", 8001, "id").value
    self.is_tips = false
    self.is_FirstTips = true
    --self:CreateItem(capacity)
    self.tickTimer = SL:Schedule(self.tickTimer, 0, 2, -1, function()
        self:RefreshUI()
    end)
    self.startW, self.view.startH = GUI:getSizeDelta(self.view.sales_scroll)
end

---注册UI事件和服务器消息
function this:RegistEvents()
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    --self:RefreshUI()
    SL:HideMainPanel()
end
function this:RefreshUI()
    for _, v in pairs(self.itemPanelList) do
        v:Remove()
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_STALL_GOODS, self.args.id)
end

function this:Close()
    if self.once then
        SL:UnSchedule(self.once)
        self.once = nil
    end
    if self.tickTimer then
        SL:UnSchedule(self.tickTimer)
        self.tickTimer = nil
    end
    for _, v in pairs(self.itemPanelList) do
        GUI:UIPanel_Close(nil, v)
    end
    self.itemPanelList = {}
    SL:ShowMainPanel()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close, self, self.ClosePanel)
    GUI:AddOnClickEvent(self.view.stop_stall, self, self.StopStall)
    GUI:AddOnClickEvent(self.view.add_stall, self, self.AddStall)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_STALL_GOODS, self.RES_STALL_GOODS, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_END_STALL, self.RES_END_STALL, self)
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/outui/Stall/Panel/KLShowStall/KLShowStallPanel")
end

function this:CreateItem(capacity)
    for i = 1, capacity do
        if not GUI:IsWebGLAsync() then
            ---@type KLTradeSalesItem
            local item = GUI:UIPanel_Open("dev/outui/Stall/Item/KLShowStallItem/KLShowStallItem", self.view.sales_grid, self, nil, true)
            table.insert(self.itemPanelList, item)
        else
            GUI:UIPanel_Open("dev/outui/Stall/Item/KLShowStallItem/KLShowStallItem", self.view.sales_grid, self, nil, true,
                    function(tempUI)
                        table.insert(self.itemPanelList, tempUI)
                    end)
        end
    end
    GUI:SetScrollView_scrollpos(self.view.sales_scroll, 0)
end

---@param message GoodsData
function this:RES_STALL_GOODS(_, message)
    --if message.title then
    --    local title_list = string.split(message.title,'#')
    --    GUI:Text_setString(self.view.title,title_list[2])
    --end
    self:ShowGoodsInfo(message.allgoods)
    local userid = SL:GetMetaValue("USER_ID")
    if message.rid and tonumber(message.rid) == tonumber(userid) then
        GUI:setVisible(self.view.stop_stall, true)
        GUI:setVisible(self.view.add_stall, true)
        GUI:setContentSize(self.view.sales_scroll, self.startW, MeSrollH)
    else
        GUI:setVisible(self.view.stop_stall, false)
        GUI:setVisible(self.view.add_stall, false)
        GUI:setContentSize(self.view.sales_scroll, self.startW, self.view.startH)
    end
    GUI:SetActive(self.view.zanwushanping,false)
    if not message.allgoods or not message.allgoods["1"] then
        GUI:SetActive(self.view.zanwushanping,true)
--[[        if self.is_FirstTips then
            return
        end
        if not self.is_tips and userid ~= tostring(message.rid) then
            SL:CommonTipsMessage({ showTips = "摊位物品被抢购空了",
                                   ui = self,
                                   sureBtnText = "确定",
                                   cancelBtnText = "取消"
            })
            self.is_tips = true
            return
        end
    else
        self.is_FirstTips = false]]
    end
end

function this:ShowGoodsInfo(data)
    if not data or not data["1"] then
        self:HideAll()
        return
    end
    for _, v in ipairs(self.itemPanelList) do
        v.is_new = false
    end
    local old_num = table.count(self.itemPanelList)
    local all_num = 0
    local now = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
    for i = 1, 100, 1 do
        if data[tostring(i)] then
            all_num = all_num + 1
            local v = data[tostring(i)]
            InfoManager.faceTradeInfo.SetTradeTime(v, now)
            if self.itemPanelList and self.itemPanelList[i] then
                if not self.itemPanelList[i]:IsGoods() then
                    ---@type KLTradeGoodsItemData
                    --local goods = {}
                    --goods["itemname"] = v.item
                    --goods["count"] = v.count
                    --goods.price = math.floor(v.price / v.count)
                    --goods.time = v.time and v.time or 0
                    --goods.itemcfgid = v.cfgid
                    --goods.cointype = v.cointype
                    --goods.itemid = v.itemid
                    --goods.timename = "公示时间:"
                    --goods.type = 1
                    --goods["itemname"] = v.itemname
                    --goods["count"] = v.count
                    --goods.price = math.floor(v.totalprice / v.count)
                    --goods.totalprice
                    --goods.time = v.time and v.time or 0
                    --goods.itemcfgid = v.itemcfgid
                    --goods.cointype = v.cointype
                    --goods.itemid = v.itemid
                    --goods.timename = "公示时间:"
                    --goods.type = 1
                    
                    self.itemPanelList[i]:UpdateUI(v)
                    self.itemPanelList[i].is_new = true
                end
            else
                local index = i
                GUI:UIPanel_Open("dev/outui/Stall/Item/KLShowStallItem/KLShowStallItem", self.view.sales_grid, self, nil, true,
                        function(tempUI)
                            tempUI:UpdateUI(v)
                            tempUI.is_new = true
                            self.itemPanelList[index] = tempUI
                        end)
            end
        else
            break
        end
    end
    if all_num < old_num then
        for i = all_num + 1, old_num, 1 do
            local v = self.itemPanelList[i]
            v:Remove()
            v:HideItem()
        end
    end
end

function this:HideAll()
    for _, v in pairs(self.itemPanelList) do
        v:HideItem()
    end
end

function this:StopStall()
    SL:CommonTipsMessage({ showTips = "是否取消摆摊？",
                           ui = self,
                           sureBtnText = "确定",
                           cancelBtnText = "取消",
                           callback = self.closeStall
    })
end

function this:closeStall()
    local userid = SL:GetMetaValue("USER_ID")
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_END_STALL, userid)
end

function this:RES_END_STALL(_, message)
    if message then
        self:ClosePanel()
    end
end

function this:AddStall()
    self:ClosePanel()
    GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeMain/KLTradeMainPanel", nil, nil, "toggle_trade_my_up")
end

return this
