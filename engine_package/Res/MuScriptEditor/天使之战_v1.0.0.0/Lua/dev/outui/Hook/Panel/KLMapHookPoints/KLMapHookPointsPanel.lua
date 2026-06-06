---@class KLMapHookPointsPanel:UIKmlLuaPanelBase
---@field view KLMapHookPointsPanelView
local KLMapHookPointsPanel = class(UIKmlLuaPanelBase)
local this =KLMapHookPointsPanel

local maxHeight = 400
local indexList = {
    "①","②","③","④","⑤","⑥","⑦","⑧","⑨","⑩", "⑪", "⑫", "⑬", "⑭", "⑮", "⑯", "⑰", "⑱", "⑲", "⑳"
}
local itemY = 30
local spacing = 5
---创建时调用一次
function this:Init()
    SL:KeepOpenPanel("KLMapHookPointsPanelKml",true)
    self.mapId = self.args.mapId
    self.points = self.args.points
    local count = 0
    for k, v in pairs(self.points) do
        GUI:UIPanel_Open("dev/outui/Hook/Item/KLMapHookPoint/KLMapHookPointItem", self.view.layout4, self,
                {index=indexList[k] or tostring(k), pos=v, mapId = self.mapId, monsterId = self.args.monsterId}, true)
        count = count + 1
    end
    --根据item的数量计算出总高度
    local size = count * itemY + (count - 1) * spacing
    if size > maxHeight then
        size = maxHeight
    end
    GUI:setContentSize(self.view.scroll, GUI:GetControlWidth(self.view.scroll), size)
    GUI:setContentSize(self.view.Bg, GUI:GetControlWidth(self.view.Bg), size + 10)
    ----------------------------------------------------------------------
    local kmlcontrol = self.args.kmlcontrol
    local x, y, z = GUI:GetWorldPosition(kmlcontrol)
    --获取滚动条上下范围的极限坐标
    ---@type KLHookPointItem
    local hookPointsItem = GUI:GetUI("dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel").hookPointsItem
    local x_, y_, z_ = GUI:GetWorldPosition(hookPointsItem.view.scrollview2)
    local scrPoint_ = SL:ConvertWorldPos2Screen(x_, y_)
    local bool_, endPos_ = GUI:ScreenPointToLocalPointInRectangle(self.view.btnBG,scrPoint_)
    local maxY = endPos_.y + 415/2
    local minY = endPos_.y - 415/2
    --获取点击按钮的屏幕坐标
    local scrPoint = SL:ConvertWorldPos2Screen(x, y)
    --将该屏幕坐标转换为基于背景的相对坐标
    local bool, endPos = GUI:ScreenPointToLocalPointInRectangle(self.view.btnBG,scrPoint)
    if bool then
        GUI:setPositionY(self.view.Bg, endPos.y)
        local size_ = size + 10
        local halfSize_ = size_ / 2
        if size_ >= maxHeight then
            --达到最大高度了就显示在中间
            GUI:setPositionY(self.view.Bg, endPos_.y)
        elseif endPos.y >= endPos_.y and halfSize_ + endPos.y > maxY then
            --点击的item在上半，往上不能超过最大高度
            local resY = maxY - halfSize_
            GUI:setPositionY(self.view.Bg, resY)
        elseif endPos.y <= endPos_.y and endPos.y - halfSize_ < minY then
            --点击的item在下半，往下不能低于最低高度
            local resY = minY + halfSize_
            GUI:setPositionY(self.view.Bg, resY)
        end
    end
    GUI:SetScrollView_scrollpos(self.view.scroll, "0")
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnBG, self, self.CloseSelf)
end

function this:CloseSelf()
    GUI:UIPanel_Close(self.filePath)
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Close()
    GUI:UIPanel_Close("dev/outui/Hook/Item/KLMapHookPoint/KLMapHookPointItem")
    SL:onLUAEvent(LUA_EVENT_UI_HOOK_POINTS_PANEL_HIDE)
    SL:KeepOpenPanel("KLMapHookPointsPanelKml",false)
end

return this
