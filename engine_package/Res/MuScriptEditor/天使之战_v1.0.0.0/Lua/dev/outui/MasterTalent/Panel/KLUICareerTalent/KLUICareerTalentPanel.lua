---@class KLUICareerTalentPanel:UIKmlLuaPanelBase
---@field view KLUICareerTalentPanelView
local KLUICareerTalentPanel = class(UIKmlLuaPanelBase)
local this =KLUICareerTalentPanel
---创建时调用一次
function this:Init()
    
    self.SkillDataList = {}
    self.SkillItemList = {}
    
    ---最大兑换次数
    self.maxNum = InfoManager.masterTalentInfo:GetTalentMaxCount(EMasterTalentType.CAREER)
    ---剩余兑换次数
    self.surplusNum = 0
    ---当前经验
    self.nowExp = 0
    ---最大经验
    self.maxExp = 0
    ---当前天赋等级
    self.nowLevel = 0
    ---点数
    self.points = {}
    self.nowSeries = 0
    self.severSeries = 0
    
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
    self:SetLeftButton()
    self:GetMaxExp()
end

---获取天赋信息
function this:GetAllTalentInfo()
    self.AllTalentInfoList = {}
    local cfg = SL:GetConfigTable("cfg_master_protalent")
    ---@param v cfg_master_protalent_column
    for i, v in pairs(cfg) do
        --筛选自己职业或者全职业（0为全职业）
        if table.contains(v.career,SL:MeData_GetCareer().baseCareer) or table.contains(v.career,0) then
            if not self.AllTalentInfoList[v.series] then
                self.AllTalentInfoList[v.series] = {}
            end
            if not self.AllTalentInfoList[v.series][v.tier] then
                self.AllTalentInfoList[v.series][v.tier] = {}
            end
            table.insert(self.AllTalentInfoList[v.series][v.tier],v)
        end
    end
    for i, v in pairs(self.AllTalentInfoList) do
        for z, q in pairs(v) do
            table.sort(q,function(a, b)
                return a.place < b.place
            end)
        end
        
    end
end

---设置左侧按钮信息
function this:SetLeftButton()
    self.FactionsCfg = InfoManager.masterTalentInfo:GetFactionsCfg(1)
    GUI:Image_loadTexture(self.view.LeftButton1_Icon,self.FactionsCfg[1].iconUi,"Atlas/UIMasterTalent.spriteatlas")
    GUI:SetImageNativeSize(self.view.LeftButton1_Icon)
    GUI:Image_loadTexture(self.view.LeftButton1_Title,self.FactionsCfg[1].textUi,"Atlas/UIMasterTalent.spriteatlas")
    GUI:Button_loadTextureNormal(self.view.LeftButton1,"D_noselect","Atlas/UIMasterTalent.spriteatlas")
    GUI:SetActive(self.view.LeftButton1_EnableText,false)
    GUI:Image_loadTexture(self.view.LeftButton2_Icon,self.FactionsCfg[2].iconUi,"Atlas/UIMasterTalent.spriteatlas")
    GUI:SetImageNativeSize(self.view.LeftButton2_Icon)
    GUI:Image_loadTexture(self.view.LeftButton2_Title,self.FactionsCfg[2].textUi,"Atlas/UIMasterTalent.spriteatlas")
    GUI:Button_loadTextureNormal(self.view.LeftButton2,"D_noselect","Atlas/UIMasterTalent.spriteatlas")
    GUI:SetActive(self.view.LeftButton2_EnableText,false)

end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.LeftButton1,self,self.OnClickSwitchTalent,1)
    GUI:AddOnClickEvent(self.view.LeftButton2,self,self.OnClickSwitchTalent,2)
    
    GUI:AddOnClickEvent(self.view.ResetButton,self,self.OnClickResetButton)
    GUI:AddOnClickEvent(self.view.ExchangeExpButton,self,self.OnClickExchangeExpButton)
    GUI:AddOnClickEvent(self.view.LeftButton1_Enable,self,self.OnClickLeftButtonEnable,1)
    GUI:AddOnClickEvent(self.view.LeftButton2_Enable,self,self.OnClickLeftButtonEnable,2)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_EXCHANGE_MASTER_EXP,self.RES_EXCHANGE_MASTER_EXP,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_OPEN_MASTER_TYPE,self.RES_OPEN_MASTER_TYPE,self)

    SL:RegisterLUAEvent(LUA_EVENT_MASTER_RED_DOT_CHANGE, self.LUA_EVENT_MASTER_RED_DOT_CHANGE, self)

    SL:RegisterLUAEvent(LUA_EVENT_MASTER_SKILL_DATA_CHANGE, self.RES_MASTER_CHANGE_INFO, self)
    SL:RegisterLUAEvent(LUA_EVENT_MASTER_DATA_CHANGE, self.RES_MASTER_INFO, self)

end

---启用按钮
function this:OnClickLeftButtonEnable(control,eventData)
    if self.isFree then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_OPEN_MASTER_TYPE,{series = self.FactionsCfg[eventData].series,type = EMasterTalentType.CAREER})
        return
    end
    local isFirst = false
    ---没有系列或者服务器发的系列数0为第一次启用
    if not self.severSeries or self.severSeries == 0 then
        isFirst = true
    end
    GUI:UIPanel_Open("dev/outui/MasterTalent/Panel/KLUIMasterTalentCareerSwitch/KLUIMasterTalentCareerSwitchPanel",_,_,
    {isFirst = isFirst,series = self.FactionsCfg[eventData].series,type = EMasterTalentType.CAREER})
end

---点击重置
function this:OnClickResetButton()
    GUI:UIPanel_Open("dev/outui/MasterTalent/Panel/KLUIMasterTalentWashUp/KLUIMasterTalentWashUpPanel",_,_,
            {
                type = EMasterTalentType.CAREER,
                series = self.nowSeries
            })
end

---点击兑换经验
function this:OnClickExchangeExpButton()
    GUI:UIPanel_Open("dev/outui/MasterTalent/Panel/KLUIMasterTalentExchangeExp/KLUIMasterTalentExchangeExpPanel",_,_,
            {type = EMasterTalentType.CAREER,maxNum = self.maxNum,count = self.surplusNum})
end

function this:OnClickSwitchTalent(_,eventData)
    local selectSeries = eventData
    if selectSeries == 0 then
        selectSeries = 1
    end
    if self.nowSeries == selectSeries then
        self:SetPointText()
        return
    end
    self.nowSeries = selectSeries
    self.SkillDataList = self.AllTalentInfoList[self.FactionsCfg[self.nowSeries].series]
    GUI:DataListUpdateData(self.view.SkillDataList)
    if self.nowSeries == 1 then
        GUI:Button_loadTextureNormal(self.view.LeftButton1,"D_select","Atlas/UIMasterTalent.spriteatlas")
        GUI:Button_loadTextureNormal(self.view.LeftButton2,"D_noselect","Atlas/UIMasterTalent.spriteatlas")
    elseif self.nowSeries == 2 then
        GUI:Button_loadTextureNormal(self.view.LeftButton2,"D_select","Atlas/UIMasterTalent.spriteatlas")
        GUI:Button_loadTextureNormal(self.view.LeftButton1,"D_noselect","Atlas/UIMasterTalent.spriteatlas")
    end
    self:SetPointText()
end

---设置选中按钮的文本和按钮显隐
function this:SetSelectSeriesButton()
    if self.severSeries == 0 then
        GUI:SetActive(self.view.LeftButton1_Enable,true)
        GUI:SetActive(self.view.LeftButton1_EnableText,false)
        GUI:SetActive(self.view.LeftButton2_Enable,true)
        GUI:SetActive(self.view.LeftButton2_EnableText,false)
        return
    end
    GUI:SetActive(self.view.LeftButton1_Enable,self.severSeries == 2)
    GUI:SetActive(self.view.LeftButton1_EnableText,self.severSeries == 1)
    GUI:SetActive(self.view.LeftButton2_Enable,self.severSeries == 1)
    GUI:SetActive(self.view.LeftButton2_EnableText,self.severSeries == 2)
end

---兑换经验红点改变
function this:LUA_EVENT_MASTER_RED_DOT_CHANGE()
    GUI:SetActive(self.view.ExchangeExpRedDot,InfoManager.masterTalentInfo.RedDataList[EMasterTalentType.CAREER])
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
    if message and message["type"] == EMasterTalentType.CAREER then
        self.severSeries = message["series"]
        self.isFree = message["isFree"]
        self.surplusNum = message["exchangedExpTimes"]
        self.nowLevel = message["level"]
        self.nowExp = message["exp"]

        local seriesPoints = message["seriesPoints"]
        self:RefreshPointInfo(seriesPoints)
        self:GetMaxExp()
        self:OnClickSwitchTalent(_,self.severSeries)
        GUI:DataListUpdateData(self.view.SkillDataList)
        self:SetSelectSeriesButton()
    end
end

---响应：兑换大师经验  回包 类型   等级与经验 次数
function this:RES_EXCHANGE_MASTER_EXP(id,message)
    if message then
        self.surplusNum = message["exchangedExpTimes"]
        self.nowLevel = message["level"]
        self.nowExp = message["exp"]
        local seriesPoints = message["seriesPoints"]
        self:RefreshPointInfo(seriesPoints)
        self:SetPointText()
        self:GetMaxExp()
        GUI:DataListUpdateData(self.view.SkillDataList)

    end
end

---响应：大师变化信息
function this:RES_MASTER_CHANGE_INFO(id,message)
    if message then
        local seriesPoints = message["seriesPoints"]
        self:RefreshPointInfo(seriesPoints)
        self:SetPointText()
        GUI:DataListUpdateData(self.view.SkillDataList)
    end
end

---响应：启用大师系列   回 ： type  series：选中启用的系列 
function this:RES_OPEN_MASTER_TYPE(id,message)
    if message and message["type"] == EMasterTalentType.CAREER then
        self.severSeries = message["series"]
        self:OnClickSwitchTalent(_,self.severSeries)

        self:SetSelectSeriesButton()
    end
end

---刷新天赋点数据
function this:RefreshPointInfo(seriesPoints)
    for i, v in pairs(seriesPoints) do
        local series = tonumber(v["series"])
        local points = tonumber(v["points"])
        if not self.points[series] then
            self.points[series] = 0
        end
        self.points[series] = points
    end
end

---设置天赋点数文本
function this:SetPointText()
    GUI:Text_setString(self.view.PointText,tostring(self.points[self.nowSeries] or 0))
end

---设置等级和经验
function this:SetLvAndExp()
    self:LUA_EVENT_MASTER_RED_DOT_CHANGE()
    GUI:Text_setString(self.view.Lv,tostring(self.nowLevel))
    if self.isMaxLevel then
        GUI:SetLoadingbar_startper(self.view.loadingbar,0)
        GUI:Text_setString(self.view.ExpText,"0/0")
        return
    end
    local value = 0
    if self.nowExp > 0 then
        value = Mathf.Ceil(self.nowExp/self.maxExp*100)
    end
    GUI:SetLoadingbar_startper(self.view.loadingbar,value)
    GUI:Text_setString(self.view.ExpText,self.nowExp.."/"..self.maxExp)
end

---获取最大经验值
function this:GetMaxExp()
    self.isMaxLevel = true
    local cfg = InfoManager.masterTalentInfo:GetProLevelCfg(self.nowLevel)
    if cfg and cfg.exp > 0 then--未满级
        self.isMaxLevel = false
        self.maxExp = cfg.exp
    end
    GUI:SetActive(self.view.ExchangeExpButton,not self.isMaxLevel)
    self:SetLvAndExp()
end

--------------------------------天赋列-------------------------------------------------------
function this:SkillDataListItemCountFunc()
    return #self.SkillDataList
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
    local data = self.SkillDataList[realIndex + 1]
    local item = self.SkillItemList[kmlcontrol]
    item:SetSkillData(data,EMasterTalentType.CAREER)
end

------------------------------------------------------------------------------------------------

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MASTER_INFO,{type = EMasterTalentType.CAREER})
end

function this:Close()
end

return this
