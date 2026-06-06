---@class KLUIModelItemPanel:UIKmlLuaPanelBase
---@field view KLUIModelItemPanelView
---@field Model
local KLUIModelItemTemplateItem = class(UIKmlLuaPanelBase)
local this = KLUIModelItemTemplateItem
local _fixedModelPos = {
    Vector3.New(87.39, 3.15, 187.84),
    Vector3.New(88.65081, 3.030007, 189.6734),
    Vector3.New(89.26869, 3.030007, 191.3171),
    Vector3.New(89.88649, 3.030007, 192.9608),
    Vector3.New(89.98649, 3.030007, 193.3608),
}

---创建时调用一次
function this:Init()
    if SL:HasConfig("cfg_global",400001) then
        local value = SL:GetConfig("cfg_global",400001).value
        local temp = ToolFunc.AnalysisStr(value,nil)
        self.fixedModelPos = {}
        for i, v in ipairs(temp) do
            table.insert(self.fixedModelPos,Vector3.New(v[1],v[2],v[3]))
        end
    else
        self.fixedModelPos = _fixedModelPos
    end
    
    if SL:HasConfig("cfg_global",400002) then
        local value = SL:GetConfig("cfg_global",400002).value
        local temp = ToolFunc.AnalysisStr(value,nil)
        self.fixedModelRotation = {}
        for i, v in ipairs(temp) do
            table.insert(self.fixedModelRotation,Vector3.New(v[1],v[2],v[3]))
        end
    end
    if SL:HasConfig("cfg_global",400003) then
        local value = SL:GetConfig("cfg_global",400003).value
        self.fixedModelSize = ToolFunc.AnalysisStr(value,nil,{"#"})
    end
    
    if SL:HasConfig("cfg_global",400005) then
        local value = SL:GetConfig("cfg_global",400005).value
        self.fixedUIPosition = ToolFunc.AnalysisStr(value,nil)
    end
    
    if SL:HasConfig("cfg_global",400005) then
        local value = SL:GetConfig("cfg_global",400005).value
        self.fixedUIPosition = ToolFunc.AnalysisStr(value,nil)
    end
    
    if SL:HasConfig("cfg_global",400007) then
        local value = SL:GetConfig("cfg_global",400007).value
        self.effectUIPosition = ToolFunc.AnalysisStr(value,nil)
    end
    
    if SL:HasConfig("cfg_global",400008) then
        local value = SL:GetConfig("cfg_global",400008).value
        self.effectUISize = ToolFunc.AnalysisStr(value,nil,{"#"})
    end
    
    if SL:HasConfig("cfg_global",400009) then
        local value = SL:GetConfig("cfg_global",400009).value
        self.effectUIRotation = ToolFunc.AnalysisStr(value,nil)
    end
    if SL:HasConfig("cfg_global",400010) then
        local value = SL:GetConfig("cfg_global",400010).value
        self.effectUIPosition1 = ToolFunc.AnalysisStr(value,nil)
    end

    if SL:HasConfig("cfg_global",400011) then
        local value = SL:GetConfig("cfg_global",400011).value
        self.effectUISize1 = ToolFunc.AnalysisStr(value,nil,{"#"})
    end

    if SL:HasConfig("cfg_global",400012) then
        local value = SL:GetConfig("cfg_global",400012).value
        self.effectUIRotation1 = ToolFunc.AnalysisStr(value,nil)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.DeleteBtn, self, self.DeleteBtnOnClick)
    GUI:AddOnClickEvent(self.view.ModelBtn, self, self.ShowDelete)
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:SetZIndex(self.view.UIModelItemTemplate,199)
end

function this:DeleteBtnOnClick()
    
end

function this:ShowDelete()
    self.baseUI:ShowChoosePlayer(self)
end


function this:Close()
    self:Recycle()
end

function this:LoadEffect()
    local index = 52
    --if ConfigManager.Exsit_cfg_character_create(1) and ConfigManager.Get_cfg_character_create(1).effect ~= nil then
    --    index = ConfigManager.Get_cfg_character_create(1).effect
    --end
    if SL:GetConfig("cfg_character_create",1) and SL:GetConfig("cfg_character_create",1).effect ~=nil then
        index = SL:GetConfig("cfg_character_create",1).effect
    end
    local effect = SL:GetConfig("cfg_model_effect",index) ---ConfigManager.Get_cfg_model_effect(index)
    local scale = Vector3.one
    local rotation = Quaternion.Euler(0, 0, 0)
    if effect ~= nil then
        scale = Vector3.New(effect.scale * 0.0001, effect.scale * 0.0001, effect.scale * 0.0001)
    end
    local data = {
        id = index,
        pos = Vector3.New(0, 0.15, 0),
        parent = self.role.model.transform,
        scale = scale,
        selfRotate = false,
        tableName = "cfg_model_effect",
        rotation = rotation,
        isActive = false,
        isSynch = true,
        isActive = true,
        callback = this.SetSize,
        callbackData = self,
        effectObjPos = Vector3.New(0, 0, 0),
        isUI = false
    }
    --SL:CreateSceneEffect("Effect/Skill/Eff_712_xuanzhongtexiao.prefab")
    SL:CreateSceneItemModel("Effect/Skill/Eff_712_xuanzhongtexiao.prefab", function(res)
        if self.Effect then
            SL:RecycleSceneItemModel(self.Effect)
            self.Effect =nil
        end
        self.Effect = res
        
        res:SetParent(self.role.model.transform)
        local res1 = res.transform:Find("0")
        if self.effectUISize1 then
            res1:SetLocalScale(self.effectUISize1[self.count] ,self.effectUISize1[self.count] ,self.effectUISize1[self.count])
            res1:SetLocalEulerAngles(self.effectUIRotation1[self.count][1],self.effectUIRotation1[self.count][2],self.effectUIRotation1[self.count][3])
            res1:SetLocalPosition(self.effectUIPosition1[self.count][1],self.effectUIPosition1[self.count][2] ,self.effectUIPosition1[self.count][3])
        end
        if self.effectUISize then
            res:SetLocalScale(self.effectUISize[self.count] ,self.effectUISize[self.count] ,self.effectUISize[self.count])
            res:SetLocalEulerAngles(self.effectUIRotation[self.count][1],self.effectUIRotation[self.count][2],self.effectUIRotation[self.count][3])
            res:SetLocalPosition(self.effectUIPosition[self.count][1],self.effectUIPosition[self.count][2] ,self.effectUIPosition[self.count][3])
            if self.isRecycle == true then
                SL:RecycleSceneItemModel(self.Effect)
                self.isRecycle =false
            end
        else
            res:SetLocalScale(2.5 ,2.5 ,2.5)
            res:SetLocalEulerAngles(0,0,0)
            res:SetLocalPosition(0,0,0)
        end
        if self.isRecycle == true then
            SL:RecycleSceneItemModel(self.Effect)
            self.isRecycle =false
        end
    end)

    GUI:SetActive(self.view.ImageSelect,true)
    self.baseUI:SetSelectId(self.date.rid)
    --self.Effect = SL.Constructor_In:UIEffect()
    --self.Effect:Init(data)
    --self.baseUI:SetSelectId(self.date.rid)
end

function this:SetSize()
    --self.Effect.modelObject.transform:GetComponent(typeof(CS.UnityEngine.ParticleSystemRenderer)).minParticleSize = 0.16
    --self.Effect.modelObject.transform:Find("0/Circle"):GetComponent(typeof(CS.UnityEngine.ParticleSystemRenderer)).minParticleSize = 0.13
end

function this:CreateRole(count)
    self.count = count
    ---@type MapProtos.RoundPlayerEx
    local t = {}
    t.id = UtilityLua.UUID
    t.career = self.date.career
    t.level = self.date.level
    t.name = self.date.name
    t.hp = 1
    t.x = 0
    t.y = 0
    t.pkValue = 0
    if self.date.roleInfoExt ~= nil then
        t.equip = self.date.roleInfoExt.equip
        t.appearIdx = self.date.roleInfoExt.equipShowIdx
        t.roleAppear = self.date.roleInfoExt.roleAppear
        t.shapeRing = self.date.roleInfoExt.shapeRing
        t.mountId = t.shapeRing == 0 and self.date.roleInfoExt.mountId or 0
    end
    t.isCreateRolePanel = true
    local role = SL:CreatePlayer(t, false, true) ---RoleManager.CreatePlayer(t, false, true)
    role.data.isHasShadow = false
    role.data.isUI = true
    self.role = role
    role:AsyncInit()
    role:ShowHead(false)
    ---@type Vector3
    local modelSize = Vector3.New(0.5, 0.5, 0.5)
    ---@type Vector3
    local modelRota = Vector3.New(0, 180, 0)
    local yList = string.split('90#102#115#126', '#')
    if self.fixedModelRotation then
        ---@type Vector3
        modelRota = self.fixedModelRotation[count]
    else
        modelRota.y = tonumber(yList[count])
    end
    
    local sizeList = string.split('0.4#0.4#0.4', '#')
    if self.fixedModelSize then
        modelSize = Vector3.New(self.fixedModelSize[count], self.fixedModelSize[count],self.fixedModelSize[count])
    else
        modelSize = Vector3.New(tonumber(sizeList[1]), tonumber(sizeList[2]), tonumber(sizeList[3]))
    end
    
   
    
    role.model:SetLocalScale(modelSize.x, modelSize.y, modelSize.z)
    role.model:SetLocalRotation(modelRota.x, modelRota.y, modelRota.z)
    role.transform.position = self.modelPos
    role.model.transform.localPosition = Vector3.New(0, 0, 0)
    role:SetAnyActionStopTime(1)
    role:SetActionForce()
    if role.guardEquipModelId ~= 0 and SL.Main.Version == EVersion.Normal then
        ---@field guardPet GuardPet
        local guardPet =  SL:GetRoleById(role.guardEquipModelId)---RoleManager.GetRole(role.guardEquipModelId)
        if guardPet then
            guardPet.data.isUI = true
            guardPet.transform:SetParent(role.transform)
            if role.model.roleModelPartsCombine:IsHasMount() then
                guardPet.transform.position = Vector3.New(LoginManager.GuardPetPos[count][1], LoginManager.GuardPetPos[count][2], LoginManager.GuardPetPos[count][3])
            else
                guardPet.transform.position = Vector3.New(self.modelPos.x, self.modelPos.y + 0.3, self.modelPos.z + 1)
            end
            guardPet.model:SetLocalRotation(0, -210, 0)
            guardPet:UpdateAction()
        end
    end
end
function this:Recycle()
    ---RoleManager.RecycleRole
    SL:RecycleRole(self.role.data.id)
    self:RecycleEffect()
    self.activator = nil
end

function this:RecycleEffect()
    
    --SL:ScheduleOnce(0.1,function()
    --    
    --end)
    if self.Effect ~= nil then
        self.isRecycle = false
        SL:RecycleSceneItemModel(self.Effect)
        self.Effect = nil
    else
        self.isRecycle = true
    end
    GUI:SetActive(self.view.ImageSelect,false)
end

-- 初始化或者刷新界面时调用（如果不需要刷新整个模板，另外写函数调用(推荐方式)）
---@param v UserProtos.RoleInfo
function this:RefreshUI(v, count)
    self.date = v
    self.createCount = count
    GUI:Text_setString(self.view.NameNew, v.name)
    GUI:SetActive(self.view.DeleteBtn, false)
    local startPos = -375
    GUI:SetAnchoredPosition(self.view.root, Vector2.New((startPos + (self.createCount - 1) * 250), 50))
    local rect = GUI:GetRectTransform(self.view.UIModelItemTemplate)
    self.model = rect:Find("UIModelItemTemplate/Model")
    if v.roleInfoExt.unionId == 0 then
        GUI:setVisible(self.view.UnionPos,false)
    else
        GUI:setVisible(self.view.UnionPos,true)
        GUI:Text_setString(self.view.UnionPos, EUnionPositionToName[v.roleInfoExt.unionId])
    end
    --local wX, wY = self.model.transform.position.x, self.model.transform.position.y
    --local screenPoint = SL:ConvertWorldPos2Screen(wX, wY)
    --local noUILayerMask = bit.lshift(1, ELayerMaskType.Default)
    --local obj, x, y, z = SL:RaycastScene(screenPoint.x, screenPoint.y, noUILayerMask)
    --self.modelPos = Vector3.New(x, y, z)
    self.modelPos = self.fixedModelPos[self.createCount]
    if SL:HasConfig("cfg_career", v.career.baseCareer) then
        local careerName = SL:GetConfig("cfg_career", v.career.baseCareer).name
        local careerId = SL:CfgCareerPost_GetCfgCareerId(v.career)  ---cfg_career_post.Get_cfg_career_id(v.career)
        if careerId then
            local carName =SL:CfgCareerPost_GetCfgCareerName(careerId) --cfg_career_post.Get_cfg_career_name(careerId)
            if carName then
                careerName = carName
            end
        end
        GUI:Text_setString(self.view.LevelNew, careerName .. "  " .. v.level .. "级")
    end
    
    if self.fixedUIPosition then
        GUI:setPosition(self.view.Image,self.fixedUIPosition[count][1],self.fixedUIPosition[count][2])
    end
    self:CreateRole(count)
    GUI:ForceRebuildLayoutImmediate(self.view.layout1)
end

function this:PlayerAni()
    self.role.data.isUI = true
    self.role:SetStandActoin(EAction.Stand, self.role.data.Dir, true)
    self.role:SetIsReplaceModel()
end


return this
