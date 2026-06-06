---@class KLSkillSelectPanel:UIKmlLuaPanelBase
---@field view KLSkillSelectPanelView
---@field skillData number[]
---@field skillItems table<KingML.KmlControl,KLUISkillItem>
local KLSkillSelectPanel = class(UIKmlLuaPanelBase)
local this =KLSkillSelectPanel
function this:AsyncLoadUI()
        end
---创建时调用一次
function this:Init()
        GUI:DataListInitData(self.view.loopscrollviewData, function()
                return self:ItemCountFunc()
        end, function(realIndex)
                return self:ItemGetFunc(realIndex)
        end, function(realIndex, kmlCtrl)
                return self:ItemInitFunc(realIndex, kmlCtrl)
        end, function(realIndex, kmlCtrl)
                return self:ItemUpdateFunc(realIndex, kmlCtrl)
        end)
        self.skillData = {}
end






function this:ItemCountFunc()
        return #self.skillData
end

function this:ItemGetFunc(realIndex)
        ---@type KLSkillSelectItem
        local item = GUI:UIPanel_Open("dev/outui/Skill/Item/KLSkillSelect/KLSkillSelectItem", self.view.loopscrollviewData, self, nil, true)
        if not self.skillItems then
                ---@type table<KingML.KmlControl,KLSkillSelectItem>
                self.skillItems = {}
        end

        local kmlCtrl = item.view.root
        self.skillItems[kmlCtrl] = item

        return kmlCtrl
end


---@param kmlCtrl KingML.KmlControl
function this:ItemInitFunc(realIndex, kmlCtrl)

end

---@param kmlCtrl KingML.KmlControl
function this:ItemUpdateFunc(realIndex, kmlCtrl)
        local item = self.skillItems[kmlCtrl]

        local luaIndex = realIndex + 1
        item:UpdateUI(self.skillData[luaIndex],luaIndex)
end


---@param skillList number[]
function this:UpdateUI(skillList)
        self.skillData = skillList
        GUI:DataListUpdateData(self.view.loopscrollviewData)
end



---注册UI事件和服务器消息
function this:RegistEvents()
        GUI:AddOnClickEvent(self.view.Close, self, self.Close)
        SL:RegisterLUAEvent(LUA_EVENT_SelectSkill_Change,self.ChangeSelectSkill,self)
        
end

function this:ChangeSelectSkill(_, message)
        for i, v in pairs(self.skillItems) do
                v:ChangeSelectSkill()
        end
end
---界面显示时调用一次
function this:Show()
        self.nowSelectSkill=0
        table.clear(self.skillData)
        
        local skillList = SL:GetMetaValue(EMetaVarGetKey.SKILL_ID_LIST_DATA)
        for i, v in ipairs(skillList) do
                ---取出没锁的
                if  SL:GetMetaValue(EMetaVarGetKey.SKILL_DATA, v) and SL:GetMetaValue(EMetaVarGetKey.SKILL_CHECK_IS_UNLOCK,v)     then
                        
                     table.insert(self.skillData,v)   
                end   
        end
        self:UpdateUI(self.skillData)
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Hide()
end

function this:Close()
        --self.lastSelect=nil
        GUI:UIPanel_Close("dev/outui/Skill/Panel/KLSkillSelect/KLSkillSelectPanel")
end


---@param kmlCtrl UIKmlLuaControl
---@param eventType EUIEventName
function this:OnTouchEvent(kmlCtrl, eventType, args,skillId)
        if eventType == EUIEventName.OnPointerEnter then
                self.nowSelectSkill=skillId
        elseif eventType== EUIEventName.OnPointerExit  then
                if self.nowSelectSkill==skillId then
                        self.nowSelectSkill=0
                end
        end   
end


return this
