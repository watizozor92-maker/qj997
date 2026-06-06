---@class KLUISkillUpTips2Panel:UIKmlLuaPanelBase
---@field view KLUISkillUpTips2PanelView
---@field SkillInfoDataList table<number,cfg_master_info_column>
local KLUISkillUpTips2Panel = class(UIKmlLuaPanelBase)
local this =KLUISkillUpTips2Panel
---创建时调用一次
function this:Init()
    self.SkillInfoDataList = {}
    GUI:DataListInitData(self.view.SkillInfoDataList,function()
        return self:SkillInfoDataListItemCountFunc()
    end,function(realIndex)
        return self:SkillInfoDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:SkillInfoDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:SkillInfoDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    --天赋
    if self.args and self.args.masterID and self.args.type then
        self.masterID = self.args.masterID
        self.type = self.args.type
        self:ShowMasterInfo()
    end
end

---显示天赋信息
function this:ShowMasterInfo()
    ---@type cfg_master_skilltalent_column
    local masterSkilltalentCfg = SL:GetConfig('cfg_master_skilltalent',self.masterID)

    self.masterLevel = InfoManager.masterTalentInfo:GetMasterLevel(self.type,masterSkilltalentCfg.series,masterSkilltalentCfg.id)
    GUI:Text_setString(self.view.SkillLv,self.masterLevel.."/"..masterSkilltalentCfg.minMaxLevel[2])
    GUI:Image_loadTexture(self.view.SkillIcon,masterSkilltalentCfg.icon,"Atlas/UIOutSkillIcon.spriteatlas")
    GUI:Text_setString(self.view.SkillName,masterSkilltalentCfg.name)

    local infoCfg = InfoManager.masterTalentInfo:GetMasterCfg(self.masterID,self.masterLevel + 1)
    self.totalNum = infoCfg and infoCfg.frontNum or 0
    --前置点数不足显示红色
    if not InfoManager.masterTalentInfo:IsCanUpLevel(masterSkilltalentCfg.id,masterSkilltalentCfg.series,masterSkilltalentCfg.steps,self.type) then
        --"#00ff00" or "#ff2323"
        GUI:Text_setString(self.view.NeedPoint,"<color=#ff2323>"..self.totalNum.."</color>")
    else
        GUI:Text_setString(self.view.NeedPoint,tostring(self.totalNum))
    end
    self.SkillInfoDataList = {}
    for i = 1, masterSkilltalentCfg.minMaxLevel[2] do
        local cfg = InfoManager.masterTalentInfo:GetMasterCfg(self.masterID,i)
        if cfg then
            table.insert(self.SkillInfoDataList,cfg)
        end
    end
    local isMaxLevel = self.masterLevel >= masterSkilltalentCfg.minMaxLevel[2]
    GUI:SetActive(self.view.UpButton,not isMaxLevel)
    GUI:SetActive(self.view.NeedPoint,not isMaxLevel)
    GUI:DataListUpdateData(self.view.SkillInfoDataList)
end

--------------------------------技能描述-------------------------------------------------------
function this:SkillInfoDataListItemCountFunc()
    return #self.SkillInfoDataList
end

function this:SkillInfoDataListItemGetFunc(realIndex)

end

function this:SkillInfoDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:SkillInfoDataListItemUpdateFunc(realIndex, kmlcontrol)
    ---有天赋ID说明是打开的天赋tips
    if self.masterID then
        local data = self.SkillInfoDataList[realIndex + 1]
        local strInfo = "LV."..data.level..":"..data.description
        local _text = GUI:GetChildControl(self.view.SkillInfoDataList,realIndex,'SkillInfo')
        if self.masterLevel == data.level then
            GUI:Text_setString(_text,"<color=#00ff00>"..strInfo.."</color>")
        elseif self.masterLevel < data.level then
            GUI:Text_setString(_text,"<color=#999999>"..strInfo.."</color>")
        else
            GUI:Text_setString(_text,strInfo)
        end
    end
end
------------------------------------------------------------------------------------------------

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.UpButton,self,self.OnClickUpButton)
    GUI:AddOnClickEvent(self.view.MaskCloseButton,self,self.OnClickCloseButton)
    
    SL:RegisterLUAEvent(LUA_EVENT_MASTER_SKILL_DATA_CHANGE, self.LUA_EVENT_MASTER_SKILL_DATA_CHANGE, self)
end

---响应：大师变化信息
function this:LUA_EVENT_MASTER_SKILL_DATA_CHANGE(id,message)
    if message and message["type"] then
        local type = tonumber(message["type"])
        if type == self.type then
            self:ShowMasterInfo()
        end
    end
end

function this:OnClickCloseButton()
    GUI:UIPanel_Close("dev/outui/SkillTips/Panel/KLUISkillUpTips2/KLUISkillUpTips2Panel")
end

function this:OnClickUpButton()
    if self.args and self.args.callBack then
        self.args.callBack()
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Close()
end

return this
