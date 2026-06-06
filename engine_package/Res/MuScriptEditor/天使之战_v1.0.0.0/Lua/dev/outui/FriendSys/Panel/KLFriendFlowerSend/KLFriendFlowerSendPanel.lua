---@class KLFriendFlowerSendPanel:UIKmlLuaPanelBase
---@field view KLFriendFlowerSendPanelView
local KLFriendFlowerSendPanel = class(UIKmlLuaPanelBase)
local this =KLFriendFlowerSendPanel

local FlowerTypeName = {"1朵鲜花","9朵鲜花","99朵鲜花","999朵鲜花"}

---创建时调用一次
function this:Init()
    self.rid = self.args.rid
    
    local tbl = SL:GetConfigTable("cfg_item")
    local index = 0
    self.cfgTbl = {}
    ---@param v cfg_item_column
    for _, v in pairs(tbl) do
        if v.type == EItemType.TriggerItem and v.subType == E_OutTriggerItemType.FriendLikeItem then
            self.cfgTbl[index] = v.id
            index = index + 1
        end
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self:SetIndex(0)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.BtnSend, self, self.OnClickSendFlower)
    GUI:AddOnClickEvent(self.view.BtnClose, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.BtnMask, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.BtnTipDown, self, self.OnClickFlower)
    for i = 0, 3 do
        GUI:AddOnClickEvent(self.view["btn_flower_".. i],self,self.BtnFlowerItemOnClick,i)
    end

    --GUI:SetDropDownOnValueChange(self.view.flowerOptions, self, self.DropDownChange)
    SL:RegisterLuaNetMsg(LuaMessageIdToSever.SET_FRIEND_DEGREE, self.ON_FRIEND_LIKE_CHANGE, self)
end

function this:ON_FRIEND_LIKE_CHANGE()
    local count = SL:GetBagItemCount(self.nowCfgId)
    GUI:Item_UpdataData(self.view.Item, {
        ["itemcount"] = count
    })
    SL:TipMessage(SL:GetConfig('cfg_string',271).text,1, NoticeType.NoticeMid)--"赠送成功", 
end

--function this:DropDownChange()
--    local index = GUI:GetDropDownValue(self.view.flowerOptions)
--    self:SetIndex(index)
--end

function this:OnClickFlower()
    local visible = GUI:getVisible(self.view.dropdown_list_flower)
    GUI:setVisible(self.view.dropdown_list_flower,not visible)
end
function this:BtnFlowerItemOnClick(item,index)
    local flowerName = FlowerTypeName[index+1]
    GUI:Button_setTitleText(self.view.btn_flower,flowerName)
    GUI:setVisible(self.view.dropdown_list_flower,false)
    self:SetIndex(index)
end
function this:SetIndex(index)
    self.index = index
    self.nowCfgId = self.cfgTbl[index]
    ---@type cfg_item_column
    local tbl = SL:GetConfig("cfg_item", self.nowCfgId)
    GUI:Text_setString(self.view.desc, tbl.topDesc)
    local count = SL:GetBagItemCount(self.nowCfgId)
    GUI:Item_UpdataData(self.view.Item, {
        ["itemid"] = self.nowCfgId,
        ["itemcount"] = count
    })
end

function this:CloseSelf()
    GUI:UIPanel_Close(self.filePath)
end

function this:OnClickSendFlower()
    SL:SendLuaNetMsg(LuaMessageIdToSever.SET_FRIEND_DEGREE, {self.nowCfgId, self.rid})
end

function this:Close()
end

return this
