---@class KLUICommonTalentPanel:UIKmlLuaPanelBase
---@field view KLUICommonTalentPanelView
local KLUICommonTalentPanel = class(UIKmlLuaPanelBase)
local this =KLUICommonTalentPanel
---创建时调用一次
function this:Init()
    self.SkillItemList = {}
    ---点数
    self.points = 0

    GUI:DataListInitData(self.view.SkillDataList,function()
        return self:SkillDataListItemCountFunc()
    end,function(realIndex)
        return self:SkillDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:SkillDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:SkillDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self:GetAllTalentInfo()
end

---获取天赋信息
function this:GetAllTalentInfo()
    self.AllTalentInfoList = {}
    local cfg = SL:GetConfigTable("cfg_master_commontalent")
    ---@param v cfg_master_commontalent_column
    for i, v in pairs(cfg) do
        --筛选自己职业或者全职业（0为全职业）
        if table.contains(v.career,SL:MeData_GetCareer().baseCareer) or table.contains(v.career,0) then
            if not self.AllTalentInfoList[v.arrange] then
                self.AllTalentInfoList[v.arrange] = {}
                for z = 1, 3 do
                    self.AllTalentInfoList[v.arrange][z] = {}
                end
            end
            self.AllTalentInfoList[v.arrange][v.row] = v
        end
    end
    GUI:DataListUpdateData(self.view.SkillDataList)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.ResetButton,self,self.OnClickResetButton)

    SL:RegisterLUAEvent(LUA_EVENT_MASTER_SKILL_DATA_CHANGE, self.RES_MASTER_CHANGE_INFO, self)
    SL:RegisterLUAEvent(LUA_EVENT_MASTER_DATA_CHANGE, self.RES_MASTER_INFO, self)

end

---点击重置
function this:OnClickResetButton()
    GUI:UIPanel_Open("dev/outui/MasterTalent/Panel/KLUIMasterTalentWashUp/KLUIMasterTalentWashUpPanel",_,_,
            {type = EMasterTalentType.COMMON})
end

---响应：大师信息 
---{type = 类型, 
---series = 系列, 
---points = 天赋点数, 
---exchangedExpTimes = 已兑换次数, 
---level = 等级, 
---exp= 当前经验, 
---isFree = 是否免费, 
---talent = 天赋信息有多个{{id = 配置id, level， series系列}，{id = 配置id, level， series系列}}}
function this:RES_MASTER_INFO(id,message)
    if message and message["type"] == EMasterTalentType.COMMON then
        self.points = message["points"]
        self:SetPointText()
        GUI:DataListUpdateData(self.view.SkillDataList)

    end
end

---响应：大师变化信息
function this:RES_MASTER_CHANGE_INFO(id,message)
    if message then
        self.points = message["points"]
        self:SetPointText()
        GUI:DataListUpdateData(self.view.SkillDataList)
    end
end

---设置天赋点数文本
function this:SetPointText()
    GUI:Text_setString(self.view.PointText,tostring(self.points))
end

--------------------------------天赋列-------------------------------------------------------
function this:SkillDataListItemCountFunc()
    return #self.AllTalentInfoList
end

function this:SkillDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/MasterTalent/Item/KLUIMasterTalentColumn/KLUIMasterTalentColumnItem",
            self.view.SkillDataList, self, {}, true)
    
    self.SkillItemList[item.view.root] = item
    return item.view.root
end

function this:SkillDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:SkillDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.AllTalentInfoList[realIndex + 1]
    local item = self.SkillItemList[kmlcontrol]
    item:SetSkillData(data,EMasterTalentType.COMMON)
end

------------------------------------------------------------------------------------------------

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MASTER_INFO,{type = EMasterTalentType.COMMON})
end

function this:Close()
end

return this
