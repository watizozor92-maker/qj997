---@class KLHookPointMonsterItem:UIKmlLuaPanelBase
---@field view KLHookPointMonsterItemView
local KLHookPointMonsterItem = class(UIKmlLuaPanelBase)
local this =KLHookPointMonsterItem
---创建时调用一次
function this:Init()
    SL:KeepOpenPanel("KLHookPointMonsterItemKml",true)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnGo, self, self.OnBtnGoClicked)
    GUI:AddOnClickEvent(self.view.btn_tips, self, function()
        local helpCfg = SL:GetConfig("cfg_rule_text", 34001, "id")
        if helpCfg then
            GUI:UIPanel_Open("dev/outui/Hook/Panel/KLHookTips/KLHookTipsPanel",nil,nil,{title = helpCfg.menutxt, str = helpCfg.location})
        end
    end)
    SL:RegisterLUAEvent(LUA_EVENT_UI_HOOK_POINTS_PANEL_HIDE, self.LUA_EVENT_UI_HOOK_POINTS_PANEL_HIDE, self)
end

function this:OnBtnGoClicked()
    GUI:UIPanel_Open("dev/outui/Hook/Panel/KLMapHookPoints/KLMapHookPointsPanel", _, _, {
        points = self.posData,
        kmlcontrol = self.view.btnGo,
        mapId = self.mapId,
        monsterId = self.args.id
    })
    GUI:setVisible(self.view.imgArrow, true)
end

function this:LUA_EVENT_UI_HOOK_POINTS_PANEL_HIDE()
    GUI:setVisible(self.view.imgArrow, false)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local id = self.args.id 
    local playerLv = self.args.level 
    self.posData = self.args.posData
    self.mapId = self.args.mapId
    ---@type cfg_monster_column
    local cfg = SL:GetConfig("cfg_monster", id)
    -- GUI:Text_setString(self.view.txtName, cfg.name)
    local definse = SL:GetHookRealDefense(id)--SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.armor)
    --local maxDC = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.maxDC)
    local minAttack = 0
    local maxAttack = 0
    local baseCareer = SL:GetMetaValue(EMetaVarGetKey.JOB)
    if baseCareer == 1 or baseCareer == 3 or baseCareer == 5 then
        minAttack = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.minDC)
        maxAttack = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.maxDC)
    else
        minAttack = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.minMC)
        maxAttack = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.maxMC)
    end
    local maxDC = maxAttack
    -- GUI:Text_setString(self.view.txtLevel, string.format( "<color=%s>LV.%s</color>",definse >= cfg.sword and "#EFEFEF" or "#FF2323", cfg.level))
    --local level_str = string.format( "<color=%s>LV.%s</color>",definse >= cfg.sword and "#EFEFEF" or "#FF2323", cfg.level)
    local level_str = "LV." .. cfg.level
    GUI:Text_setString(self.view.txtName, level_str.."\n"..cfg.name)
    GUI:Text_setTextColor(self.view.txtName, definse >= cfg.sword and "#EFEFEF" or "#FF2323")
    GUI:Text_setString(self.view.txtLevel, "")
    GUI:Text_setString(self.view.txtExp, string.format("经验%s/只", cfg.exp))
    GUI:Image_loadTexture(self.view.imgHead, cfg.icon,"Atlas/Monster_icon.spriteatlas")
    local color1 = "<color=#00FF00>"
    if cfg.RecommendedDef > definse then
        color1 = "<color=#FF2323>"
    end
    local color2 = "<color=#00FF00>"
    if cfg.RecommendedAtk > maxDC then
        color2 = "<color=#FF2323>"
    end
    GUI:Text_setString(self.view.txt_suggestion, string.format("推荐防御：%s%s</color>\n推荐攻击：%s%s</color>",color1, cfg.RecommendedDef,color2, cfg.RecommendedAtk))
end

function this:Close()
    SL:KeepOpenPanel("KLHookPointMonsterItemKml",false)
    self:CloseTimer()
end

function this:CloseTimer()
    if self.effectTimer then
        SL:UnSchedule(self.effectTimer)
        self.effectTimer = nil
    end
end

function this:SetSelectEffect()
    self:CloseTimer()
    GUI:setVisible(self.view.HighlightGo,true)
    self.effectTimer =  SL:ScheduleOnce(2,function()
        GUI:setVisible(self.view.HighlightGo,false)
    end)
end

return this
