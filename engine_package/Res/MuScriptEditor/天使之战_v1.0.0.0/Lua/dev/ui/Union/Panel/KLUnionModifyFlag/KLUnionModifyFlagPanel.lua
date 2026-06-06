---@class KLUnionModifyFlagPanel:UIKmlLuaPanelBase
---@field view KLUnionModifyFlagPanelView
---@field unionInfo UnionProto.UnionInfo
local KLUnionModifyFlagPanel = class(UIKmlLuaPanelBase)
local this =KLUnionModifyFlagPanel
---创建时调用一次
function this:Init()
    self.unionInfo = self.args.unionInfo
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:Text_setString(self.view.input_union_name, self.unionInfo.unionName)
    if not self.flagIndex then
        self.flagIndex = 1
    end
    
    local needItemInfo = string.split(SL:GetConfig('cfg_global', 1600).value,'|')[2]
    local needItemInfo1 = string.split(needItemInfo, '#')
    local itemId = tonumber(needItemInfo1[1])
    local needCount = tonumber(needItemInfo1[2])
    GUI:Item_setItemId(self.view.cost_item_id, itemId)
    GUI:Text_setString(self.view.cost_item_count, tostring(needCount))
    if needCount <= SL:GetBagItemCount(itemId) then
        GUI:Text_setTextColor(self.view.cost_item_count, "#FFFFFF")
    else
        GUI:Text_setTextColor(self.view.cost_item_count, "#FF0000")
    end
    GUI:setVisible(self.view["union_log" .. self.flagIndex .. "_select" ], true)
end

function this:closeBtn()
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionModifyFlag/KLUnionModifyFlagPanel")
    GUI:UIPanel_Open("dev/ui/Union/Panel/KLUnionMemberList/KLUnionMemberListPanel")
end

function this:cancle_btn()
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionModifyFlag/KLUnionModifyFlagPanel")
    GUI:UIPanel_Open("dev/ui/Union/Panel/KLUnionMemberList/KLUnionMemberListPanel")
end

function this:enter_btn()
    SL:ReqUpdateUnionInfoMessage("", self.flagIndex)
    self:cancle_btn()
end

function this:log_list_bg1()
    self.flagIndex=1
    self:Hide_log_select()
    GUI:setVisible(self.view.union_log1_select, true)
    GUI:Image_loadTexture(self.view.union_log, "Texture/log1.png")
end

function this:log_list_bg2()
    self.flagIndex=2
    self:Hide_log_select()
    GUI:setVisible(self.view.union_log2_select, true)
    GUI:Image_loadTexture(self.view.union_log, "Texture/log2.png")
end

function this:log_list_bg3()
    self.flagIndex=3
    self:Hide_log_select()
    GUI:setVisible(self.view.union_log3_select, true)
    GUI:Image_loadTexture(self.view.union_log, "Texture/log3.png")
end

function this:log_list_bg4()
    self.flagIndex=4
    self:Hide_log_select()
    GUI:setVisible(self.view.union_log4_select, true)
    GUI:Image_loadTexture(self.view.union_log, "Texture/log4.png")
end

function this:log_list_bg5()
    self.flagIndex=5
    self:Hide_log_select()
    GUI:setVisible(self.view.union_log5_select, true)
    GUI:Image_loadTexture(self.view.union_log, "Texture/log5.png")
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.closeBtn)
    GUI:AddOnClickEvent(self.view.cancle_btn, self, self.cancle_btn)
    GUI:AddOnClickEvent(self.view.enter_btn, self, self.enter_btn)

    GUI:AddOnClickEvent(self.view.log_list_bg1, self, self.log_list_bg1)
    GUI:AddOnClickEvent(self.view.log_list_bg2, self, self.log_list_bg2)
    GUI:AddOnClickEvent(self.view.log_list_bg3, self, self.log_list_bg3)
    GUI:AddOnClickEvent(self.view.log_list_bg4, self, self.log_list_bg4)
    GUI:AddOnClickEvent(self.view.log_list_bg5, self, self.log_list_bg5)
end

function this:Hide_log_select()
    GUI:setVisible(self.view.union_log1_select, false)
    GUI:setVisible(self.view.union_log2_select, false)
    GUI:setVisible(self.view.union_log3_select, false)
    GUI:setVisible(self.view.union_log4_select, false)
    GUI:setVisible(self.view.union_log5_select, false)
end

function this:Close()
end

return this
