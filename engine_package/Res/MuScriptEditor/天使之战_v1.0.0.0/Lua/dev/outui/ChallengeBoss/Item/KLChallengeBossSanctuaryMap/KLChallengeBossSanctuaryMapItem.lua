---@class KLChallengeBossSanctuaryMapItem:UIKmlLuaPanelBase
---@field view KLChallengeBossSanctuaryMapItemView
---@field data cfg_mapMove_column
---@field panel KLChallengeBossSanctuaryMapPanel
---@field isSelected boolean @是否选中
---@field isLevel boolean @等级是否满足
local KLChallengeBossSanctuaryMapItem = class(UIKmlLuaPanelBase)
local this = KLChallengeBossSanctuaryMapItem

---创建时调用一次
function this:Init()
end

function this:InitData(index, data,panel)
    self.index = index
    self.data = data
    self.panel = panel
    self.isSelected = false
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnSelect, self, self.BtnSelectOnClick)
end

function this:BtnSelectOnClick()
    if self.panel then
        self.panel:ItemSelectOnClick(self)
    end
end

function this:SetSelected(isSelected)
    GUI:SetActive(self.view.select,isSelected)
    self.isSelected = isSelected
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:RefreshUI()
    if self.data then
        GUI:Text_setString(self.view.textMapName,self.data.mapName)
        GUI:Text_setString(self.view.textLevel,self.data.level.."级开启")
        local playerLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
        if playerLevel >= self.data.level then
            GUI:Text_setTextColor(self.view.textLevel,"#00FF00")
            self.isLevel = true
        else
            GUI:Text_setTextColor(self.view.textLevel,"#FF0000")
            self.isLevel = false
        end
    end
end
function this:Hide()
end

function this:Close()
end

return this
