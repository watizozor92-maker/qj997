---@class KLTaskGuidePanel:UIKmlLuaPanelBase
---@field view KLTaskGuidePanelView
local KLTaskGuidePanel = class(UIKmlLuaPanelBase)
local this =KLTaskGuidePanel
---创建时调用一次
function this:Init()
    self.goalId = self.args.goalId
    
    self.args.position.z = 100 --Canvas Plane Distance
    local localPos = GUI:ConvertToNodeSpace(self.view.root, self.args.position.x, self.args.position.y)
    GUI:SetAnchoredPosition(self.view.Content, Vector2.New(localPos.x - 370, localPos.y))
    --self.view.root.rectTransform.position = self.args.position
    --GUI:setAnchorPoint(self.view.root, localPoint.x, localPoint.y)
    
    GUI:DataListInitData(self.view.task_guide_list, function(realIndex)
        return #self.guideInfos
    end, function(realIndex)
        
    end, function(realIndex, kmlcontrol)
        
    end, function(realIndex, kmlcontrol)
        local info = self.guideInfos[realIndex+1]
        local guide_name = info.name
        local guide_text = GUI:GetChildControl(self.view.task_guide_list, realIndex, 'guide_text')
        GUI:Text_setString(guide_text, guide_name)

        local guide_button = GUI:GetChildControl(self.view.task_guide_list, realIndex, 'guide_button')
        GUI:AddOnClickEvent(guide_button, self, function()
            local instruction = info.instruction
            local autoFight = self.cfg.autoFight
            local autoTask = self.cfg.autoTask
            local moveToArriveCallBack
            if autoFight == EAutoFight.AutoFight and string.contains(instruction[1],"transfer") then
                if not SL:GetMetaValue(EMetaVarGetKey.GET_IS_SAFEAREA) then
                    SL:SetBattleState(true)
                end
            elseif autoFight == EAutoFight.AutoFight and string.contains(instruction[1],"moveTo") then
                SL:SetBattleState(false)
                moveToArriveCallBack = function()
                    if not SL:GetMetaValue(EMetaVarGetKey.GET_IS_SAFEAREA) then
                        SL:SetBattleState(true)
                    end
                end
            end
            if autoTask == EAutoTalk.AutoTalk  and string.contains(instruction[1],"moveToNPC") then
                SL:SetBattleState(false)
                moveToArriveCallBack = function()
                    SL:TalkToNpc(tonumber(instruction[2]), true)
                end
            end
            --ShortcutMgr.Do(instruction,nil,nil,moveToArriveCallBack)
            SL:ShortcutDO(instruction,nil,nil,moveToArriveCallBack)
            self:ClosePanel()
        end)
    end)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    ---@type cfg_task_target_column
    self.cfg = SL:GetConfig('cfg_task_target', self.goalId)
    self.guideInfos = {}
    for i, v in pairs(self.cfg.extraControlName) do
        if SL:CheckCondition(self.cfg.extraControlConditions[i]) and not table.isNullOrEmpty(self.cfg.instruction[i]) then
            table.insert(self.guideInfos, { name = v, instruction = self.cfg.instruction[i] })
        end
    end
    local count = #self.guideInfos
    GUI:setContentSize(self.view.Content, GUI:GetWidth(self.view.Content), 38 * count + 7 * (count + 1) )
    GUI:DataListUpdateData(self.view.task_guide_list)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeMask, self, self.ClosePanel)
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/ui/Task/Panel/KLTaskGuide/KLTaskGuidePanel")
end

function this:Close()
end

return this
