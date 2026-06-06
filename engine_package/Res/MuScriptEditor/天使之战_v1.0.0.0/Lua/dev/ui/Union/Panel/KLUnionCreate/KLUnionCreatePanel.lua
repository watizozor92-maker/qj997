---@class KLUnionCreatePanel:UIKmlLuaPanelBase
---@field view KLUnionCreatePanelView
local KLUnionCreatePanel = class(UIKmlLuaPanelBase)
local this =KLUnionCreatePanel
---创建时调用一次
function this:Init()
    self:Hide_log_select()
    self.flagIndex=1
    GUI:setVisible(self.view.union_log1_select, true)
    self:ShowCoin()
    GUI:SetMaxTextCount(self.view.input_union_name, 10)
end

function this:ShowCoin()
    local coinSplit = string.split(SL:GetConfig('cfg_global',43).value, '#')
    self.conditions = coinSplit
    local coinId = tonumber(coinSplit[1])
    local coinCount = tonumber(coinSplit[2])
    GUI:Item_setItemId(self.view.cost_item_id, coinId)
    GUI:Text_setString(self.view.cost_item_count, tostring(coinCount))
    local haveCount = SL:GetBagItemCount(coinId)
    if haveCount < coinCount then
        GUI:Text_setTextColor(self.view.cost_item_count, '#ff0000')
    else
        GUI:Text_setTextColor(self.view.cost_item_count, '#00ff00')
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.log_list_bg1, self, self.log_list_bg1)
    GUI:AddOnClickEvent(self.view.log_list_bg2, self, self.log_list_bg2)
    GUI:AddOnClickEvent(self.view.log_list_bg3, self, self.log_list_bg3)
    GUI:AddOnClickEvent(self.view.log_list_bg4, self, self.log_list_bg4)
    GUI:AddOnClickEvent(self.view.log_list_bg5, self, self.log_list_bg5)
    
    GUI:AddOnClickEvent(self.view.enter_btn, self, self.enter_btn)
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.closeBtn)
    GUI:AddOnClickEvent(self.view.cancle_btn, self, self.cancle_btn)
    SL:RegisterLuaNetMsg(MessageDef.ResCreateUnionMessage, self.ResCreateUnionMessage, self)
end

function this:ResCreateUnionMessage(_, message)
    SL:ScheduleOnce(Time.deltaTime,function()
        self:closeBtn()
        GUI:UIPanel_Open("dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel",nil,nil,{unionId = message.unionInfo.unionId})
    end)
end

function this:Hide_log_select()
    GUI:setVisible(self.view.union_log1_select, false)
    GUI:setVisible(self.view.union_log2_select, false)
    GUI:setVisible(self.view.union_log3_select, false)
    GUI:setVisible(self.view.union_log4_select, false)
    GUI:setVisible(self.view.union_log5_select, false)
end

function this:log_list_bg2()
    self:Hide_log_select()
    self.flagIndex=2
    GUI:setVisible(self.view.union_log2_select, true)
    GUI:Image_loadTexture(self.view.union_log, "Texture/log2.png")    
end

function this:log_list_bg1()
    self:Hide_log_select()
    self.flagIndex=1
    GUI:setVisible(self.view.union_log1_select, true)
    GUI:Image_loadTexture(self.view.union_log, "Texture/log1.png")
end

function this:log_list_bg3()
    self:Hide_log_select()
    self.flagIndex=3
    GUI:setVisible(self.view.union_log3_select, true)
    GUI:Image_loadTexture(self.view.union_log, "Texture/log3.png")
end

function this:log_list_bg4()
    self:Hide_log_select()
    self.flagIndex=4
    GUI:setVisible(self.view.union_log4_select, true)
    GUI:Image_loadTexture(self.view.union_log, "Texture/log4.png")
end

function this:log_list_bg5()
    self:Hide_log_select()
    self.flagIndex=5
    GUI:setVisible(self.view.union_log5_select, true)
    GUI:Image_loadTexture(self.view.union_log, "Texture/log5.png")
end

function this:Close()
end

function this:enter_btn()
    if InfoManager.loranSiegeInfo:GetIsOpen() then
        SL:TipMessage(SL:GetConfig("cfg_string",16003).text ,1, NoticeType.NoticeMid)
        return
    end
    
    if not SL:CheckIsAllCN(GUI:Button_getTitleText(self.view.input_union_name)) then
        SL:TipMessage("战盟名称为中文字符，请重新输入" ,1, NoticeType.NoticeMid)
        return
    end
    -- 检查等级，道具
    if SL:GetBagItemCount(tonumber(self.conditions[1])) < tonumber(self.conditions[2]) then
        SL:CommonItemGetPath(nil, tonumber(self.conditions[1]))
        SL:TipMessage("道具不足" ,1, NoticeType.NoticeMid)
        return
    end
    if SL:MeData_GetLevel() < tonumber(self.conditions[3]) then
        SL:TipMessage(string.format("等级不足%s级", self.conditions[3]) ,1, NoticeType.NoticeMid)
        return
    end
    
    SL:ReqCreateUnionMessage(GUI:Button_getTitleText(self.view.input_union_name), self.flagIndex)
end

function this:closeBtn()
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionCreate/KLUnionCreatePanel")
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel")
end

function this:cancle_btn()
    self:closeBtn()
end

return this
