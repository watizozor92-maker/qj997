---@class KLTitleItem:UIKmlLuaPanelBase
---@field view KLTitleItemView
---@field baseUI KLTitlePanel
---@field titleId number
local KLTitleItem = class(UIKmlLuaPanelBase)
local this = KLTitleItem
---创建时调用一次
function this:Init()
    self.lastClick = 0
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---@param dt TitleData
function this:UpdateUI(dt, isSelect)

    self.titleId = dt.confId

    ---@type cfg_item_column
    local itemTbl = SL:GetConfig("cfg_item", self.titleId)

    ---@type cfg_model_charactor_column
    local modelTbl = SL:GetConfig('cfg_model_charactor', itemTbl.shape[1])

    ---@type cfg_fashion_column
    local fashionTbl = SL:GetConfig("cfg_fashion", dt.confId)
    local scale = "300,300,300"
    if fashionTbl.modelScale > 0 then
        scale = string.replace(scale, "300", tostring(fashionTbl.modelScale))
    end

    GUI:Model_setSrc(self.view.TitleModel, modelTbl.path, scale,"0,0,0")

    if fashionTbl.timeType == E_TitleTimeType.Limit then
        --限时

        GUI:SetActive(self.view.TimeDown, true)
        GUI:SetActive(self.view.TxtTime, false)

        local svTime = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
        local countdown = dt.expiresTime - svTime / 1000
        countdown = math.floor(countdown)

        GUI:SetControl_time(self.view.TimeDown, countdown)

    else

        GUI:SetActive(self.view.TxtTime, true)
        GUI:SetActive(self.view.TimeDown, false)
        if fashionTbl.timeType == E_TitleTimeType.NotLimit then
            GUI:Text_setString(self.view.TxtTime, "永久生效")
        elseif fashionTbl.timeType == E_TitleTimeType.UntilNext then
            GUI:Text_setString(self.view.TxtTime, "下次活动移除")
        else
            GUI:Text_setString(self.view.TxtTime, "排行榜实时刷新")
        end
    end

    if fashionTbl.vestedType == E_TitleBelong.Role then
        GUI:Text_setString(self.view.TxtType, "角色生效")
    else
        GUI:Text_setString(self.view.TxtType, "账号生效")
    end

    if isSelect then
        self:TitleItemOnClick()
    else
        self:SetIsSelect(false)
    end

end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Bg, self, self.TitleItemOnClick)
end

function this:TitleItemOnClick()
    if self.lastClick and Time.frameCount - self.lastClick < 3 then
        return
    end

    self.lastClick = Time.frameCount
    return self.baseUI:TitleItemOnClick(self, self.titleId)
end

function this:SetIsSelect(isSelect)
    local spName = isSelect and "tab_title_selected" or "tab_title_unselect"
    GUI:Image_loadTexture(self.view.SpState, spName, "Atlas/AppearGroup.spriteatlas")
end

function this:Close()
end

return this
