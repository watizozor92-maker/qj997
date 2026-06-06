---@class KLUIModelItemTemplateItem:UIKmlLuaPanelBase
---@field view KLUIModelItemTemplateItemView
---@field Model
local KLUIModelItemTemplateItem = class(UIKmlLuaPanelBase)
local this = KLUIModelItemTemplateItem

---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.DeleteBtn, self, self.DeleteBtnOnClick)
    GUI:AddOnClickEvent(self.view.ModelBtn, self, self.ShowDelete)
end

---界面显示时调用一次
function this:Show()
    self.CreateRolePanel = self.args.createRolePanel
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:DeleteBtnOnClick()
    self.CreateRolePanel:DeleteRole(self.date.rid)
end

function this:ShowDelete()
    self.CreateRolePanel:ShowChoosePlayer(self)
end

function this:Close()
end

function this:LoadEffect()
    local index = 52
    if SL:GetConfig("cfg_character_create", 1) and SL:GetConfig("cfg_character_create", 1).effect ~= nil then
        index = SL:GetConfig("cfg_character_create", 1).effect
    end
    local effect = SL:GetConfig("cfg_model_effect", index)
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
    self.Effect = SL.Constructor_In:UIEffect()
    self.Effect:Init(data)
end

function this:SetSize()
    self.Effect.modelObject.transform:GetComponent(typeof(CS.UnityEngine.ParticleSystemRenderer)).minParticleSize = 0.16
    self.Effect.modelObject.transform:Find("0/Circle"):GetComponent(typeof(CS.UnityEngine.ParticleSystemRenderer)).minParticleSize = 0.13
end

function this:CreateRole(count)
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
    local role = SL:CreatePlayer(t, false, true)
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
    modelRota.y = tonumber(yList[count])
    local sizeList = string.split('0.4#0.4#0.4', '#')
    modelSize = Vector3.New(tonumber(sizeList[1]), tonumber(sizeList[2]), tonumber(sizeList[3]))
    role.model:SetLocalScale(modelSize.x, modelSize.y, modelSize.z)
    role.model:SetLocalRotation(modelRota.x, modelRota.y, modelRota.z)
    role.transform.position = self.modelPos
    role.model.transform.localPosition = Vector3.New(0, 0, 0)
    role:SetAnyActionStopTime(1)
    role:SetActionForce()
    if role.guardEquipModelId ~= 0 and SL:GetVersion() == EVersion.Normal then
        ---@field guardPet GuardPet
        local guardPet = SL:GetRoleById(role.guardEquipModelId)
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
    SL:RecycleRole(self.role.data.id)
    self:RecycleEffect()
    self.activator = nil
end

function this:RecycleEffect()
    if self.Effect ~= nil then
        self.Effect:Recycle()
    end
end

-- 初始化或者刷新界面时调用（如果不需要刷新整个模板，另外写函数调用(推荐方式)）
---@param v UserProtos.RoleInfo
function this:RefreshUI(v, count)
    self.date = v
    self.createCount = count
    GUI:Text_setString(self.view.Name, v.name)
    GUI:SetActive(self.view.DeleteBtn, false)
    local startPos = -375
    
    GUI:SetAnchoredPosition(self.view.root, Vector2.New((startPos + (self.createCount - 1) * 250), 50))
    local rect = GUI:GetRectTransform(self.view.UIModelItemTemplate)
    self.model = rect:Find("UIModelItemTemplate/Model")
    local screenPoint = SL:ConvertWorldPos2Screen(self.model.transform.position.x,self.model.transform.position.y)
    local noUILayerMask = bit.lshift(1, ELayerMaskType.Default)
    local obj, x, y, z = SL:RaycastScene(screenPoint.x, screenPoint.y,noUILayerMask)
    self.modelPos = Vector3.New(x, y, z)
    local str = v.level .. "级"
    if SL:GetConfig("cfg_career", v.career.baseCareer) then
        local careerName = SL:GetConfig("cfg_career", v.career.baseCareer).name
        local careerId = self.Get_cfg_career_id(v.career)
        if careerId then
            local carName = self.Get_cfg_career_name(careerId)
            if carName then
                careerName = carName
            end
        end
        GUI:Text_setString(self.view.Level, careerName .. "  " .. str)
    end
    self:CreateRole(count)
end

---@return number @根据根职业，职业等级，职业编号获取职业表id,职业名称
---@param careerInfo CommonProtos.Career
function this.Get_cfg_career_id(careerInfo)
    local baseCareer = careerInfo.baseCareer
    local careerRank = careerInfo.careerRank
    ---@type cfg_career_column[]
    local careers = SL:GetConfigTable("cfg_career")
    for _, v in pairs(careers) do
        if v.baseCareer == baseCareer and v.careerRank == careerRank then
            return v.id, v.name, v.upGradeEffect, v.careerRankName, v.nextCareerNum
        end
    end
end

---@return string @获取职业中文名称
function this.Get_cfg_career_name(id)
    local careerCol = SL:GetConfigTable("cfg_career")
    return careerCol.name
end

function this:PlayerAni()
    self.role.data.isUI = false
    self.role:SetStandActoin(EAction.Stand, self.role.data.Dir, true)
    self.role:SetIsReplaceModel()
end

return this
