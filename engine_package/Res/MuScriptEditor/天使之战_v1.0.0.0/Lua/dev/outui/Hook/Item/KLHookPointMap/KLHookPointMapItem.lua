---@class KLHookPointMapItem:UIKmlLuaPanelBase
---@field view KLHookPointMapItemView
local KLHookPointMapItem = class(UIKmlLuaPanelBase)
local this =KLHookPointMapItem
---创建时调用一次
function this:Init()
    self.isSelect = false
    SL:KeepOpenPanel("KLHookPointMapItemKml",true)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnItem2, self, self.OnSelectTog)
    GUI:AddOnClickEvent(self.view.btnItem, self, self.ShowLevelTips)
    GUI:AddOnClickEvent(self.view.noClick, self, self.noClick)
end

function this:OnSelectTog(_,data)
    if not self.isSelect then
        SL:onLUAEvent(LUA_EVENT_UI_HOOK_MAP_CLICK, {selectItem=self,data=self.data})
    end
end

function this:ShowLevelTips()
    SL:TipMessage(SL:GetConfig('cfg_string',272).text, 1, NoticeType.NoticeLeftBottom)---"角色等级不足",
end

function this:noClick()
    SL:TipMessage("当前VIP等级不足",1,NoticeType.NoticeMid)
end

---创建或者刷新界面数据时调用
function this:Refresh()

end

function this:SetData(data)
    self.data = data
    self:SetOff()
    GUI:setVisible(self.view.imgRecommend, false)
    ---@type cfg_mapMove_column
    local cfg = SL:GetConfig("cfg_mapMove", data.mapMoveId)
    local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    --local isOk = level >= cfg.level
    local isOk = true
    GUI:setVisible(self.view.btnItem2, isOk)
    GUI:setVisible(self.view.btnItem, not isOk)
    GUI:setVisible(self.view.noClick, not data.isMove)
    GUI:Text_setString(self.view.txtMapName, cfg.mapName)
    -- GUI:Text_setTextColor(self.view.txtMapName, isOk and "#EFEFEF" or "#5E5E5D")
    GUI:Text_setTextColor(self.view.txtMapName, "#EFEFEF")
    GUI:Text_setString(self.view.txtLevel, string.format( "<color=%s>%s级</color>",level >= cfg.level and "#EFEFEF" or "#FF2323", cfg.level))
end

function this:SetOn()
    self.isSelect = true
    --GUI:Button_loadTextureNormal(self.view.btnItem2, "btn_cebian1","Atlas/FG_Common.spriteatlas")
    GUI:Button_loadTextureNormal(self.view.btnItem2, "img_btnBuy","Atlas/QJ5_UITreasureHunt.spriteatlas")
end

function this:SetOff()
    self.isSelect = false
    GUI:Button_loadTextureNormal(self.view.btnItem2, "buttom_treasure","Atlas/QJ5_UITreasureHunt.spriteatlas")
end

function this:SetIsRecommended()
    GUI:setVisible(self.view.imgRecommend, true)
end

function this:Close()
    SL:KeepOpenPanel("KLHookPointMapItemKml",false)
end

return this
