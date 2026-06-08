---@class KLDisplayPanel:UIKmlLuaPanelBase
---@field view KLDisplayPanelView
local KLDisplayPanel = class(UIKmlLuaPanelBase)
local this =KLDisplayPanel
local hideTypeStr = {
    [1] = "不隐藏",
    [2] = "全部玩家",
    [3] = "同盟玩家",
    [4] = "敌对玩家",
    [5] = "中立玩家",
}

local EHideModeType = {
    None = enum(0),
    EHidePlayerModel = enum(1),
    EHidePlayerSkillEffect = enum(),
    EHidePlayerWing = enum(),
    EHideMeWing = enum(),
    EHidePlayerFootprint = enum(),
}
---创建时调用一次
function this:Init()
    self.curHideType = EHideModeType.None
--[[    local slider_playerNum_rect = GUI:GetRectTransform(self.view.slider_playerNum)
    GUI:GetAttachRectTransform(self.view.slider_playerNum,"fill_attach")]]
    local bg_attach = GUI:GetAttachRectTransform(self.view.slider_playerNum,"bg_attach"):GetComponent(typeof(CS.UnityEngine.RectTransform))
    local fillArea_attach = GUI:GetAttachRectTransform(self.view.slider_playerNum,"fillArea_attach"):GetComponent(typeof(CS.UnityEngine.RectTransform))
    local fill_attach = GUI:GetAttachRectTransform(self.view.slider_playerNum,"fill_attach"):GetComponent(typeof(CS.UnityEngine.RectTransform))
    self:SetRectTrans(bg_attach, Vector2.New(0, 0), Vector2.New(1, 1), Vector2.New(0, 0))
    self:SetRectTrans(fillArea_attach, Vector2.New(0, 0.25), Vector2.New(1, 0.75), Vector2.New(0, 1))
    self:SetRectTrans(fill_attach, Vector2.New(0, 0), Vector2.New(1, 1), Vector2.New(0, 0))
    self.selectMenuType = {
        [EHideType.ENoHide] = self.view.noHideBtn,
        [EHideType.EAllHide] = self.view.hideAllBtn,
        [EHideType.ELeaguePlayerHide] = self.view.hideUnioBtn,
        [EHideType.ERivalryPlayerHide] = self.view.hideEnemyBtn,
    }
    self.hideTypeDic = {}
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local hidePlayerModel = SL:GetMetaValue(EMetaVarGetKey.GET_HIDE_PLAYER_MODEL_TYPE)
    local hidePlayerSkillEffect = SL:GetMetaValue(EMetaVarGetKey.GET_HIDE_PLAYER_SKILL_EFFECT_TYPE)
    local hidePlayerWing = SL:GetMetaValue(EMetaVarGetKey.GET_HIDE_PLAYER_WING_TYPE)
    local hideMeWing = SL:GetMetaValue(EMetaVarGetKey.GET_HIDE_ME_WING_TYPE)
    local hidePlayerFootprint = SL:GetMetaValue(EMetaVarGetKey.GET_HIDE_PLAYER_FOOTPRINT_TYPE)
    local isHideCalMonster = SL:GetMetaValue(EMetaVarGetKey.GET_IS_HIDE_CALL_MONSTER)
    local isHideMonsterModel = SL:GetMetaValue(EMetaVarGetKey.GET_IS_HID_MONSTER_MODEL)
    local isHideMonsterSkillEffect = SL:GetMetaValue(EMetaVarGetKey.GET_IS_HID_MONSTER_SKILL_EFFECT)
    local isLimitShowCount = SL:GetMetaValue(EMetaVarGetKey.GET_IS_LIMIT_PLAYER_SHOW_COUNT)
    local limitShowCount = SL:GetMetaValue(EMetaVarGetKey.GET_LIMIT_PLAYER_SHOW_COUNT)
    local powerSaveMode = SL:GetMetaValue(EMetaVarGetKey.GET_POWER_SAVING_MODE)
    local cameraDistance = tonumber(SL:GetLocalString("GET_CAMERA_DISTANCE")) or 13
    local isHideDragonSoulSkillShow = InfoManager.dragonSoulSkillInfo.dragonSoulSkillCheck
    local isHideVIPHead = InfoManager.newVipInfo.isHideVIPHeadShow

    GUI:Text_setString(self.view.hidePlayerModelTxt,hideTypeStr[hidePlayerModel])
    GUI:Text_setString(self.view.hidePlayerSkillEffectTxt,hideTypeStr[hidePlayerSkillEffect])
    GUI:Text_setString(self.view.hidePlayerWingTxt,hideTypeStr[hidePlayerWing])
    GUI:Text_setString(self.view.hideMeWingTxt,hideTypeStr[hideMeWing])
    GUI:Text_setString(self.view.hidePlayerFootprintTxt,hideTypeStr[hidePlayerFootprint])
    GUI:SetIsOnWithoutNotify(self.view.hidePetModel,isHideCalMonster)
    GUI:SetIsOnWithoutNotify(self.view.hideMonsterModel,isHideMonsterModel)
    GUI:SetIsOnWithoutNotify(self.view.hideMonsterSkillEffect,isHideMonsterSkillEffect)
    --GUI:SetIsOnWithoutNotify(self.view.hideDragonSkillEffect,isHideDragonSoulSkillShow)
    --GUI:SetIsOnWithoutNotify(self.view.hideVIPHead,isHideVIPHead)
    GUI:SetIsOnWithoutNotify(self.view.tog_limitPlayeNum,isLimitShowCount)
    
    GUI:Text_setString(self.view.playerCount,tostring(limitShowCount))
    GUI:Slider_setPercent(self.view.slider_playerNum,limitShowCount)
    GUI:Slider_setPercent(self.view.slider_camera,cameraDistance)
    GUI:Text_setString(self.view.txtCamera,tostring(cameraDistance))
    GUI:SetIsOnWithoutNotify(self.view["tog_powerSaving"..powerSaveMode],true)
    self.hideTypeDic = {
        [EHideModeType.EHidePlayerModel] = hidePlayerModel,
        [EHideModeType.EHidePlayerSkillEffect] = hidePlayerSkillEffect,
        [EHideModeType.EHidePlayerWing] = hidePlayerWing,
        [EHideModeType.EHideMeWing] = hideMeWing,
        [EHideModeType.EHidePlayerFootprint] = hidePlayerFootprint,
    }

    self.barWidth = GUI:GetControlWidth(self.view.slider_playerNum)
    self.sliderStartPosX = -(self.barWidth / 2)
    self.barWidthCamera = GUI:GetControlWidth(self.view.slider_camera)
    self.sliderStartPosXCamera = -(self.barWidthCamera / 2)
    local sliderPointerPosX = self.sliderStartPosX + self.barWidth * limitShowCount / 40
    GUI:setPositionX(self.view.barPointer, sliderPointerPosX)

    sliderPointerPosX = self.sliderStartPosXCamera + self.barWidthCamera * cameraDistance / 40
    GUI:setPositionX(self.view.barCamera, sliderPointerPosX)

end
    
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.hidePlayerModelToggle,self,self.HidePlayerModelToggleOnValueChange)
    GUI:SetToggleOnValueChange(self.view.hidePlayerSkillEffectToggle,self,self.HidePlayerSkillEffectToggleOnValueChange)
    GUI:SetToggleOnValueChange(self.view.hidePlayerWingToggle,self,self.HidePlayerWingToggleOnValueChange)
    GUI:SetToggleOnValueChange(self.view.hideMeWingToggle,self,self.HideMeWingToggleOnValueChange)
    GUI:SetToggleOnValueChange(self.view.hidePlayerFootprintToggle,self,self.HidePlayerFootprintToggleOnValueChange)
    GUI:SetToggleOnValueChange(self.view.hidePetModel,self,self.HidePetModelOnValueChange)
    GUI:SetToggleOnValueChange(self.view.hideMonsterModel,self,self.HideMonsterModelOnValueChange)
    GUI:SetToggleOnValueChange(self.view.hideMonsterSkillEffect,self,self.HideMonsterSkillEffectOnValueChange)
    --GUI:SetToggleOnValueChange(self.view.hideDragonSkillEffect,self,self.HideDragonSkillEffectOnValueChange)
    --GUI:SetToggleOnValueChange(self.view.hideVIPHead,self,self.HideVIPHeadOnValueChange)
    GUI:SetToggleOnValueChange(self.view.tog_limitPlayeNum,self,self.IsPlayerNumOnValueChange)
    GUI:Slider_addOnEvent(self.view.slider_playerNum,self,self.SliderShowPlayerOnValueChange)
    GUI:Slider_addOnEvent(self.view.slider_camera,self,self.SliderCameraDistance)
    for i = 1, 3 do
        GUI:SetToggleOnValueChange(self.view["tog_powerSaving"..i],self,self.SelectPowerMode, i)
    end
    GUI:AddOnClickEvent(self.view.noHideBtn,self,self.HideModeSelectOnClick,EHideType.ENoHide)
    GUI:AddOnClickEvent(self.view.hideAllBtn,self,self.HideModeSelectOnClick,EHideType.EAllHide)
    GUI:AddOnClickEvent(self.view.hideUnioBtn,self,self.HideModeSelectOnClick,EHideType.ELeaguePlayerHide)
    GUI:AddOnClickEvent(self.view.hideEnemyBtn,self,self.HideModeSelectOnClick,EHideType.ERivalryPlayerHide)
    GUI:AddOnClickEvent(self.view.BtnReDefaultDispaly,self,self.ReDefaultDispalyBtnOnClick)
end 


function this:HidePlayerModelToggleOnValueChange(control,_,data)
    local isToggle = data[1]
    if isToggle then
        self:ResetToggle(false,128, EHideModeType.EHidePlayerModel)
        self:SetSelectMenuPos(control)
    end
    GUI:setVisible(self.view.selectMenu,isToggle)
end

function this:HidePlayerSkillEffectToggleOnValueChange(control,_,data)
    local isToggle = data[1]
    if isToggle then
        self:ResetToggle(false,128, EHideModeType.EHidePlayerSkillEffect)
        self:SetSelectMenuPos(control)
    end
    GUI:setVisible(self.view.selectMenu,isToggle)
end

function this:HidePlayerWingToggleOnValueChange(control,_,data)
    local isToggle = data[1]
    if isToggle then
        self:ResetToggle(false,128, EHideModeType.EHidePlayerWing)
        self:SetSelectMenuPos(control)
    end
    GUI:setVisible(self.view.selectMenu,isToggle)
end

function this:HideMeWingToggleOnValueChange(control,_,data)
    local isToggle = data[1]
    if isToggle then
        self:ResetToggle(true,64, EHideModeType.EHideMeWing)
        self:SetSelectMenuPos(control)
    end
    GUI:setVisible(self.view.selectMenu,isToggle)
end

function this:HidePlayerFootprintToggleOnValueChange(control,_,data)
    local isToggle = data[1]
    if isToggle then
        self:ResetToggle(false,128, EHideModeType.EHidePlayerFootprint)
        self:SetSelectMenuPos(control)
    end
    GUI:setVisible(self.view.selectMenu,isToggle)
end

function this:HidePetModelOnValueChange(control,_,data)
    local isToggle = data[1]
    SL:SetMetaValue(EMetaVarSetKey.SET_IS_HIDE_CALL_MONSTER,isToggle)
end

function this:HideMonsterModelOnValueChange(control,_,data)
    local isToggle = data[1]
    SL:SetMetaValue(EMetaVarSetKey.SET_IS_HID_MONSTER_MODEL,isToggle)
end

function this:HideMonsterSkillEffectOnValueChange(control,_,data)
    local isToggle = data[1]
    SL:SetMetaValue(EMetaVarSetKey.SET_IS_HID_MONSTER_SKILL_EFFECT,isToggle)
end

function this:HideDragonSkillEffectOnValueChange(control, _, data)
    local isToggle = data[1]
    InfoManager.dragonSoulSkillInfo:SetRoleDragonSkillSetting({ ["type"] = ERoleSettingType_Out.DragonSoulSkillShow, ["value"] = isToggle })
end

function this:HideVIPHeadOnValueChange(control, _, data)
    local isToggle = data[1]
    InfoManager.newVipInfo:SetRoleVIPHeadShowSetting({ ["type"] = ERoleSettingType_Out.VIPHeadShow, ["value"] = isToggle })
end


function this:IsPlayerNumOnValueChange(control,_,data)
    local isToggle = data[1]
    SL:SetMetaValue(EMetaVarSetKey.SET_IS_LIMIT_PLAYER_SHOW_COUNT,isToggle)
end

function this:SliderShowPlayerOnValueChange(control,_,data)
    local value = math.ceil(data[1])
    SL:SetMetaValue(EMetaVarSetKey.SET_LIMIT_PLAYER_SHOW_COUNT,value)
    GUI:Text_setString(self.view.playerCount,tostring(value))

    local sliderPointerPosX = self.sliderStartPosX + self.barWidth * value / 100
    GUI:setPositionX(self.view.barPointer, sliderPointerPosX)
end

function this:SliderCameraDistance(control,_,data)
    local value = math.ceil(data[1])
    -- 确保相机距离在有效范围内 (1-40)
    value = math.max(1, math.min(40, value))
    SL:SetLocalString("GET_CAMERA_DISTANCE",value.."")
    GUI:Text_setString(self.view.txtCamera,tostring(value))
    local sliderPointerPosX = self.sliderStartPosXCamera + self.barWidthCamera * value / 40
    GUI:setPositionX(self.view.barCamera, sliderPointerPosX)

    
    --设置相机距离
    if SL:GetMetaValue(EMetaVarGetKey.ENGINE_IS_LOCK_CAMERA) then
        SL.MainCamera:SetLookCamera(false,Vector2(32,-45),10,10,90)
    end
    SL.MainCamera:Set3DCameraParams(value,45,45)
end

function this:SelectPowerMode(control,data,_)
    SL:SetMetaValue(EMetaVarSetKey.SET_POWER_SAVING_MODE,data)
    self:Refresh()
end

function this:HideModeSelectOnClick(control,data,_)
    GUI:setVisible(self.view.selectMenu,false)
    if self.curHideType == EHideModeType.EHidePlayerModel then
        SL:SetMetaValue(EMetaVarSetKey.SET_HIDE_PLAYER_MODEL_TYPE,data)
        GUI:Text_setString(self.view.hidePlayerModelTxt,hideTypeStr[data])
        GUI:SetIsOnWithoutNotify(self.view.hidePlayerModelToggle,false)
    elseif self.curHideType == EHideModeType.EHidePlayerSkillEffect then
        SL:SetMetaValue(EMetaVarSetKey.SET_HIDE_PLAYER_SKILL_EFFECT_TYPE,data)
        GUI:Text_setString(self.view.hidePlayerSkillEffectTxt,hideTypeStr[data])
        GUI:SetIsOnWithoutNotify(self.view.hidePlayerSkillEffectToggle,false)
    elseif self.curHideType == EHideModeType.EHidePlayerWing then
        SL:SetMetaValue(EMetaVarSetKey.SET_HIDE_PLAYER_WING_TYPE,data)
        GUI:Text_setString(self.view.hidePlayerWingTxt,hideTypeStr[data])
        GUI:SetIsOnWithoutNotify(self.view.hidePlayerWingToggle,false)
    elseif self.curHideType == EHideModeType.EHideMeWing then
        SL:SetMetaValue(EMetaVarSetKey.SET_HIDE_ME_WING_TYPE,data)
        GUI:Text_setString(self.view.hideMeWingTxt,hideTypeStr[data])
        GUI:SetIsOnWithoutNotify(self.view.hideMeWingToggle,false)
    elseif self.curHideType == EHideModeType.EHidePlayerFootprint then
        SL:SetMetaValue(EMetaVarSetKey.SET_HIDE_PLAYER_FOOTPRINT_TYPE,data)
        GUI:Text_setString(self.view.hidePlayerFootprintTxt,hideTypeStr[data])
        GUI:SetIsOnWithoutNotify(self.view.hidePlayerFootprintToggle,false)
    end
    self.hideTypeDic[self.curHideType] = data
end

function this:ResetToggle(isSpecial,height, curHideType)
    self.curHideType = curHideType
    -- 设置菜单的选中显示
    local curHideModeType = self.hideTypeDic[curHideType]
    if self.lastHideModeType and self.lastHideModeType ~= curHideModeType then
        local lastSelectBtn = self.selectMenuType[self.lastHideModeType]
        if lastSelectBtn then
            GUI:Button_loadTextureNormal(lastSelectBtn, "setting_noChoose", "Atlas/FG_Setting.spriteatlas")
            GUI:setColor(lastSelectBtn, "#FFFFFF00")
        end
    end
    
    if self.lastHideModeType ~= curHideModeType then
        self.lastHideModeType = curHideModeType
        local curSelectBtn = self.selectMenuType[curHideModeType]
        if curSelectBtn then
            GUI:Button_loadTextureNormal(curSelectBtn, "btn_tips_select", "Atlas/FG_Common.spriteatlas")
            GUI:setColor(curSelectBtn, "#FFFFFFFF")
        end
    end
    
    GUI:SetIsOnWithoutNotify(self.view.hidePlayerModelToggle,self.curHideType == EHideModeType.EHidePlayerModel)
    GUI:SetIsOnWithoutNotify(self.view.hidePlayerSkillEffectToggle,self.curHideType == EHideModeType.EHidePlayerSkillEffect)
    GUI:SetIsOnWithoutNotify(self.view.hidePlayerWingToggle,self.curHideType == EHideModeType.EHidePlayerWing)
    GUI:SetIsOnWithoutNotify(self.view.hideMeWingToggle,self.curHideType == EHideModeType.EHideMeWing)
    GUI:SetIsOnWithoutNotify(self.view.hidePlayerFootprintToggle,self.curHideType == EHideModeType.EHidePlayerFootprint)
    GUI:setContentSize(self.view.selectMenu,122,height)
    GUI:setVisible(self.view.hideUnioBtn,not isSpecial)
    GUI:setVisible(self.view.hideEnemyBtn,not isSpecial)
end

function this:ReDefaultDispalyBtnOnClick()
    SL:ReplyDefaultShowSetting()
    self:Refresh()
end

function this:SetSelectMenuPos(target)
    local worldPosX, worldPosY = GUI:GetWorldPosition(target)
    local localPos = GUI:ConvertToNodeSpace(self.view.panel31, worldPosX, worldPosY)
    localPos.x = localPos.x - 80
    localPos.y = localPos.y - 256
    local height = GUI:GetHeight(self.view.selectMenu)
    if localPos.y - height <= -439 then -- 超出显示，往上走
        localPos.y = localPos.y + height + 31
    end
    GUI:SetAnchoredPosition(self.view.selectMenu, Vector2.New(localPos.x, localPos.y))
end

function this:SetRectTrans(rectTrans, anchorMin, anchorMax, sizeDelta)
    rectTrans.anchoredPosition = Vector3.New(0, 0, 0)
    rectTrans.anchorMin = anchorMin
    rectTrans.anchorMax = anchorMax
    rectTrans.sizeDelta = sizeDelta
end

function this:Close()
    local cameraDistance = tonumber(SL:GetLocalString("GET_CAMERA_DISTANCE")) or 13
    if cameraDistance == 13 then
        SL.MainCamera:SetLookCamera(true,Vector2(32,-45),10,10,90)
    end
    -- SL.MainCamera:SetLookCamera(true,Vector2(32,-45),10,10,90)
    
end

return this
