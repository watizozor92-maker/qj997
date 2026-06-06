---@class KLGrailItem:UIKmlLuaPanelBase
---@field view KLGrailItemView
---@field baseUI KLArchangelGrailPanel
local KLGrailItem = class(UIKmlLuaPanelBase)
local this = KLGrailItem

---创建时调用一次
function this:Init()
    --self.isGray = self.args.isGray
    --self.itemCfgId = self.args and self.args.itemCfgId or nil
    --self.id = self.args and self.args.id or nil
    --self.holeIndex = self.args and self.args.holeIndex or -1
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.bg, self, self.SelectItem)
    GUI:AddOnClickEvent(self.view.xie_btn, self, self.Unload)
    
    SL:RegisterLUAEvent(LUA_EVENT_GRAIL_STRENGTH_SUCCESS_REFRESH_REDPOINT, self.RefreshRedPoint, self)
end
---界面显示时调用一次
function this:Show()
    --GUI:setVisible(self.view.select, false)
end
---创建或者刷新界面数据时调用
function this:Refresh()

end

function this:UpdateUI(data,isHideSelect)
    if isHideSelect then
        GUI:setVisible(self.view.select, false)
    end
    self.isGray = data.isGray
    self.itemCfgId = data.itemCfgId
    self.id = data.id
    self.holeIndex = data.holeIndex
    self:RefreshUI()
end

function this:RefreshUI()
    GUI:setVisible(self.view.img_red, false)
    GUI:Text_setString(self.view.add, "可融合" .. self.holeIndex .. "阶圣杯")
    if self.isGray then
        -- 置灰
        GUI:setVisible(self.view.gray, true)
        GUI:setVisible(self.view.xie_btn, false)
        GUI:setVisible(self.view.scroll_text_template, false)
        GUI:setVisible(self.view.add, false)
        return
    end
    GUI:setVisible(self.view.gray, false)
    if self.itemCfgId then
        GUI:setVisible(self.view.scroll_text_template, true)
        GUI:setVisible(self.view.add, false)
        local itemCfg = SL:GetConfig("cfg_item", self.itemCfgId, "id")
        GUI:SetOnPrefabControlLoaded(self.view.scroll_text_template, function()
            GUI:Text_setTextColor(self.view.txt_item_name, SL:GetConfig("cfg_color", tonumber(itemCfg.color), "id").color)
            GUI:Text_setString(self.view.txt_item_name, itemCfg.name)
        end)
       
        GUI:setVisible(self.view.xie_btn, true)
        self:RefreshRedPoint()
    else
        GUI:setVisible(self.view.xie_btn, false)
        GUI:setVisible(self.view.scroll_text_template, false)
        GUI:setVisible(self.view.add, true)
        local show = self.baseUI:GetGrailByHoleIndex(self.holeIndex)
        GUI:setVisible(self.view.img_red, show)
    end
end

function this:RefreshRedPoint()
    if self.holeIndex and self.itemCfgId then
        local isShow = self.baseUI:GetGrailItemShowRedPoint(self.holeIndex, self.itemCfgId)
        if isShow then
            isShow = self.baseUI:IsGrailEntryMax(self.holeIndex)
            isShow = not isShow
        end
        GUI:setVisible(self.view.img_red, isShow)
    end
end

function this:SelectItem()
    if self.isGray then
        SL:MessageTip({ id = 500 })
        return
    end
    self.baseUI:GrailSelect(self.holeIndex, self.itemCfgId, self.id)
end

function this:FusionPanel()
    if self.isGray then
        SL:MessageTip({ id = 500 })
        return
    end

end

function this:SelectItemUIChange(holeIndex)
    if holeIndex == self.holeIndex then
        GUI:setVisible(self.view.select, true)
    else
        GUI:setVisible(self.view.select, false)
    end
end

function this:Unload()
    self.baseUI:UnFusion(self.id, self.itemCfgId, self.holeIndex)
end

function this:Hide()
end

function this:Close()
end

return this
