---@class KLUIChatView:UIKmlLuaPanelBase
---@field view KLUIChatViewView
local KLUIChatView = class(UIKmlLuaPanelBase)
local this = KLUIChatView
---创建时调用一次
function this:Init()
    --GUI:Button_setTitleText(self.view.button_id,self.args.nameStr)
    if self.args.width and self.args.height then
        GUI:setContentSize(self.view.root,self.args.width,self.args.height)
        GUI:setContentSize(self.view.chat_view,self.args.width,self.args.height)
        --GUI:setContentSize(self.view.all_list_layout,self.args.width,self.args.height)
    end
    if self.args.x and self.args.y then
        GUI:setPositionX(self.view.root,self.args.x)
        GUI:setPositionY(self.view.root,self.args.y)
    end
    self.calculationUI = nil
    GUI:UIPanel_Open("dev/ui/Chat/Item/KLUIChatItem/KLUIChatItem",self.view.root,self,{},true,function (item)
        self.calculationUI = item
        GUI:setPositionX(self.calculationUI.view.root,2000)
        GUI:setPositionY(self.calculationUI.view.root,2000)
    end)
    GUI:DataListInitData(self.view.chat_data_list,function()
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
end

function this:isLoadEnd()
    if self.calculationUI then
        return true
    end
    return false
end

---创建或者刷新界面数据时调用
function this:Refresh()
end


function this:RefreshData(chat_list)
    self.chat_list = chat_list
    GUI:DataListUpdateData(self.view.chat_data_list)
    GUI:SetScrollView_scrollpos(self.view.chat_view,#self.chat_list-1)
end


---注册UI事件和服务器消息
function this:RegistEvents()
    --GUI:AddOnClickEvent(self.view.button_id,self,self.BtnOnClick)
end


function this:ChatDataListItemCountFunc()
    return #self.chat_list
end
function this:ChatDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/ui/Chat/Item/KLUIChatItem/KLUIChatItem",self.view.chat_data_list,self,{},true)
    
    self.chat_all_item[item.view.root] = item
    return item.view.root
end
function this:ChatDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:ChatDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.chat_list[realIndex + 1]
    local mess = {message=data,itemIndex=realIndex + 1}
    self.chat_all_item[kmlcontrol]:RefreshItem(mess)
end
function this:ChatDataItemSizeGetFunc(realIndex)
    local data = self.chat_list[realIndex + 1]
    if not data.itemSize then
        local mess = {message=data,itemIndex=realIndex + 1}
        self.calculationUI:RefreshItem(mess)
        local xx,yy = GUI:getSizeDelta(self.calculationUI.view.root)
        data.itemSize = Vector2(xx, yy)
    end
    return data.itemSize
end

function this:Close()
end

return this
