---@class KLUISkillPageItem:UIKmlLuaPanelBase
---@field view KLUISkillPageItemView
---@field baseUI KLUISkillInfoPanel
local KLUISkillPageItem = class(UIKmlLuaPanelBase)
local this = KLUISkillPageItem
---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.skillItemGrid, function()
        return self:ItemCountFunc()
    end, function(realIndex)
        return self:ItemGetFunc(realIndex)
    end, function(realIndex, kmlCtrl)
        return self:ItemInitFunc(realIndex, kmlCtrl)
    end, function(realIndex, kmlCtrl)
        return self:ItemUpdateFunc(realIndex, kmlCtrl)
    end)

    ---@type table<KingML.KmlControl,KLUISkillItem>
    self.skillItems = {}
end

function this:ItemCountFunc()
    return #self.skillListData
end

function this:ItemGetFunc()
    ---@type KLUISkillItem
    local item = GUI:UIPanel_Open("dev/ui/Skill/Item/KLUISkill/KLUISkillItem", self.view.skillItemGrid, self, nil, true)
    

    local kmlCtrl = item.view.root
    self.skillItems[kmlCtrl] = item
    return kmlCtrl
end

function this:ItemInitFunc()

end

---@param kmlCtrl KingML.KmlControl
function this:ItemUpdateFunc(realIndex, kmlCtrl)
    local item = self.skillItems[kmlCtrl]

    local luaIndex = realIndex + 1
    item:UpdateUI(self.skillListData[luaIndex], luaIndex)
end

---创建或者刷新界面数据时调用
function this:Refresh()

end

---@param skillList number[]
function this:UpdateUI(skillList)
    self.waitUpdt = SL:Schedule(self.waitUpdt, 0, Time.deltaTime, -1, function()
        if self.isLoading then
            return
        end
        SL:UnSchedule(self.waitUpdt)
        self.skillListData = skillList
        GUI:DataListUpdateData(self.view.skillItemGrid)
        
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:Close()
    if self.waitUpdt then
        SL:UnSchedule(self.waitUpdt)
        self.waitUpdt = nil
    end
end

return this
