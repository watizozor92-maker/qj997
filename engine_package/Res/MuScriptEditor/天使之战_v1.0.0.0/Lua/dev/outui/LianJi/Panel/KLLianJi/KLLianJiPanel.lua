---@class KLLianJiPanel:UIKmlLuaPanelBase
---@field view KLLianJiPanelView
local KLLianJiPanel = class(UIKmlLuaPanelBase)
local this =KLLianJiPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.path = "dev/outui/LianJi/Panel/KLLianJi/KLLianJiPanel"
    self.childPath = "dev/outui/LianJi/Panel/GuoShi/KLGuoShiPanel"
    SL.HideMainPanel()  --隐藏主界面
    GUI:setPositionX(self.view.root,-416)
    GUI:UIPanel_Open(self.childPath)
    GUI:Toggle_setIsOn(self.view[("fangan"..InfoManager.LianJiInfo.data.fangan)],true)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.close,self,self.Close1)
    GUI:SetToggleOnValueChange(self.view.fangan1, self, self.TogFanganValueChange)
    GUI:SetToggleOnValueChange(self.view.fangan2, self, self.TogFanganValueChange)
    GUI:AddOnClickEvent(self.view.close_change,self,function()
       GUI:setVisible(self.view.can_change,false)
       self.openchange_index = 0;
       GUI:DataListUpdateData(self.view.datalist4);
    end)
    GUI:AddOnClickEvent(self.view.use_fangan,self,function()
       SL:SendLuaNetMsg(LuaMessageIdToSever.LianJi_MsgID, {5,self.show_list})
    end)


    SL:RegisterLUAEvent(LUA_EVENT_LIANJI_DATACHANGE, function()
        self:Refresh()
    end,self)

    GUI:DataListInitData(self.view.datalist4,function()
        return self:DataListItemCountFunc(1)
    end,function(realIndex)
        return self:DataListItemGetFunc(realIndex,1)
    end,function(realIndex, kmlcontrol)
        return self:DataListItemInitFunc(realIndex, kmlcontrol,1)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemUpdateFunc(realIndex, kmlcontrol,1)
    end)

    GUI:DataListInitData(self.view.datalist5,function()
        return self:DataListItemCountFunc(2)
    end,function(realIndex)
        return self:DataListItemGetFunc(realIndex,2)
    end,function(realIndex, kmlcontrol)
        return self:DataListItemInitFunc(realIndex, kmlcontrol,2)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemUpdateFunc(realIndex, kmlcontrol,2)
    end)
end

function this:TogFanganValueChange(_, _, args)
    if args[1] then
        GUI:setVisible(self.view.can_change,false)
        self.openchange_index = 0;
        self:ToggleChange()
    end
end

function this:DataListItemCountFunc(wndType)
    if wndType == 1 then
        return #self.show_list;
    end
    return #self.change_list
end

function this:DataListItemGetFunc(realIndex,wndType)
    
end
function this:DataListItemInitFunc(realIndex, kmlcontrol,wndType)

end
function this:DataListItemUpdateFunc(realIndex, kmlcontrol,wndType)
    -- SL:LogError("realIndex",realIndex)
    if wndType == 1 then
        local icon = GUI:GetChildControl(self.view.datalist4, realIndex, "icon",kmlcontrol)
        local name = GUI:GetChildControl(self.view.datalist4, realIndex, "name",kmlcontrol)
        local jiantou = GUI:GetChildControl(self.view.datalist4, realIndex, "jiantou",kmlcontrol)
        local change_btn = GUI:GetChildControl(self.view.datalist4, realIndex, "change_btn",kmlcontrol)
        GUI:setVisible(change_btn,self.openchange_index ~= realIndex+1)
        local skill_id = tonumber(self.show_list[realIndex+1]);
        -- SL:LogTable(self.show_list,true)
        local skill_level = 1
        local skillInfo = SL:MeData_GetSkill(skill_id)
        if skillInfo then
            skill_level = skillInfo.level
        end
        -- SL:LogError(skill_id,skill_level,self.show_list[realIndex+1],realIndex)
        local skill_cfg = SL:GetConfigMultiKeys('cfg_skill_info', skill_id, skill_level, 'skillID', 'skillLevel')
        GUI:SetAttr(icon,"src",skill_cfg.icon)
        local str_name = (realIndex == 0 and "启动技") or (realIndex+1 == #self.show_list and "迸发技") or "衔接技"
        GUI:SetAttr(name,"text",string.format("%s：%s",str_name,skill_cfg.name))
        GUI:setVisible(jiantou,realIndex+1 ~= #self.show_list)
        GUI:AddOnClickEvent(icon,self,function ()
            SL:ShowSkillTip(skill_id,skill_level)
        end)
        GUI:AddOnClickEvent(change_btn,self,function ()
            GUI:setVisible(change_btn,false)
            GUI:setVisible(self.view.can_change,true)
            GUI:setPositionY(self.view.can_change,-150-realIndex*180)
            self.openchange_index = realIndex+1
            self.change_list = self.conf[realIndex+1];
            -- SL:LogTable(self.change_list,true)
            GUI:DataListUpdateData(self.view.datalist4);
            GUI:DataListUpdateData(self.view.datalist5);
        end)
        return
    end
    local icon = GUI:GetChildControl(self.view.datalist5, realIndex, "Skill_icon",kmlcontrol)
    local name = GUI:GetChildControl(self.view.datalist5, realIndex, "skill_name",kmlcontrol)
    local skill_id = SL:GetConfigMultiKeys('cfg_skill',  self.change_list[realIndex+1], 'name').id
    local skill_level = 1
    local skillInfo = SL:MeData_GetSkill(skill_id)
    if skillInfo then
        skill_level = skillInfo.level
    end
    local skill_cfg = SL:GetConfigMultiKeys('cfg_skill_info',  skill_id, skill_level, 'skillID', 'skillLevel')
    GUI:SetAttr(icon,"src",skill_cfg.icon)
    GUI:SetAttr(name,"text",string.format("%s",self.change_list[realIndex+1]))
    GUI:AddOnClickEvent(icon,self,function ()
        SL:SendLuaNetMsg(LuaMessageIdToSever.LianJi_MsgID, {1,self.openchange_index,self.change_list[realIndex+1],self.select_fangan})
    end)
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:setVisible(self.view.can_change,false)
    self.openchange_index = 0
    self.data = InfoManager.LianJiInfo.data
    
    -- SL:LogTable(self.conf,true)
    local baseCareer = SL:GetMetaValue("JOB");
    local conf = InfoManager.LianJiInfo.conf.list
    if table.count(conf[baseCareer]) > 1 then
        GUI:setVisible(self.view.ShowTypes,true)
        self:ToggleChange()
    else
        GUI:setVisible(self.view.ShowTypes,false)
        -- SL:LogTable(conf[baseCareer],true)
        self.conf = conf[baseCareer][1]
        self.show_list = self.data
        GUI:DataListUpdateData(self.view.datalist4);
    end
end

function this:ToggleChange()
    local baseCareer = SL:GetMetaValue("JOB");
    local career_name = SL:CfgCareerPost_GetCfgCareerName(baseCareer)
    local conf = InfoManager.LianJiInfo.conf.list[baseCareer]
    for i=1,2 do
        -- SL:LogError("fangan"..i,GUI:Toggle_getIsOn(self.view[("fangan"..i)]))
        if GUI:Toggle_getIsOn(self.view[("fangan"..i)]) == "1" then
            self.select_fangan = i
            self.conf = conf[i]
            if self.data.fangan == i then
                self.show_list = self.data
            else
                self.show_list = {}
                self.show_list.fangan = i;
                for j=1,#conf[i] do 
                    local skill_id = SL:GetConfigMultiKeys('cfg_skill',  conf[i][j][1], 'name').id
                    self.show_list[j] = skill_id
                end
            end
        end
        local str = ""
        if conf[i].attr_name == "strength" then
            str = "力"
        elseif conf[i].attr_name == "agility" then
            str = "敏"
        elseif conf[i].attr_name == "intelligence" then
            str = "智"
        elseif conf[i].attr_name == "stamina" then
            str = "体"
        end
        GUI:Text_setString(self.view[("fangan_text"..i)],str..career_name)
    end
    GUI:setVisible(self.view.use_fangan,self.data.fangan ~= self.select_fangan)
    GUI:setVisible(self.view.use_text,self.data.fangan == self.select_fangan)
    GUI:DataListUpdateData(self.view.datalist4);
end

function this:Hide()
end

function this:Close()
    SL:ShowMainPanel()  --显示主界面
end
function this:Close1()
    GUI:UIPanel_Close(self.childPath)
    GUI:UIPanel_Close(self.path) 

end


return this
