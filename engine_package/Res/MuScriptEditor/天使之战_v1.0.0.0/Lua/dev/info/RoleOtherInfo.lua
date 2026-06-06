---@class RoleOtherInfo 角色其他信息
RoleOtherInfo = class()
local this = RoleOtherInfo
local nameBgPath = "HUD/RoleHead/HeadNameBg.prefab"
--local nameBgPath = "HUD/RoleHead/PlayerNameBg.prefab"
local ENameColorConfig = {
    ---同盟
    SomeUnion = 310001,
    ---非敌对战盟
    NoEnemyUnion = 310002,
    ---敌对战盟
    EnemyUnion = 310003,
    ---文字背景
    TextBg = 310004,
    ---自己文字背景
    SelfTextBg = 310005,
    ---玩家名字
    PlayerName = 310006,
    ---怪物名字
    MonsterName = 310007,
}
local showNameBgColor = {
    [ERoleType.Me] = ENameColorConfig.SelfTextBg,
    [ERoleType.Player] = ENameColorConfig.TextBg,
    [ERoleType.Npc] = ENameColorConfig.TextBg,
    [ERoleType.Monster] = ENameColorConfig.MonsterName,
}
local showNameBgType = {
    [ERoleType.Me] = true,
    [ERoleType.Player] = true,
    [ERoleType.Npc] = true,
}
local nameBgInitY = {
    [ERoleType.Me] = 0.32,
    [ERoleType.Player] = 0.32,
    [ERoleType.Npc] = 5.5,
    [ERoleType.Monster] = -2.16
}
local nameBgRenderQueue = {}
local scale = 25.16
local labelSizeScale = 7.5
local damageNumberConfig = {}

function this:ctor()
    SL:SetPreLoadAssetPath(nameBgPath)
    self.nameBgMats = {}
    SL:SetReplaceEngineFunc(EReplaceEngineFunc.GetDropItemNameScale, function()
        return 1.4
    end)
    -- 设置离线不暂停自动挂机
    SL.AutoFight:SetIsLeaveGameStopAutoHook(false)
    SL.AutoFight:SetIsClickFloorStopHook(false)
    SL:SetLocalString("skipSetIsShowMount","1")
end

function this:Init()
    self.oldAttrNum = 0
    self.newPlayerEffect = nil
    self.isNewPlayerBuff = false
    this.showcountItemType = {}
    local global_str = SL:GetConfig("cfg_global", 29002)
    if global_str then
        local type_List = string.split(global_str.value, "|")
        for k, v in ipairs(type_List) do
            local sqlit = string.split(v, "#")
            if this.showcountItemType[tonumber(sqlit[1])] == nil then
                this.showcountItemType[tonumber(sqlit[1])] = {}
            end
            if sqlit[2] then
                this.showcountItemType[tonumber(sqlit[1])][tonumber(sqlit[2])] = 1
            end
        end
    end
    self:RegistMessages()
    self:Reset()
    self.colorConfig = {}
    for i, v in pairs(ENameColorConfig) do
        local global = SL:GetConfig("cfg_global", v)
        self.colorConfig[v] = SL:ConvertColorFromHexString(global.value)
    end
    self.globalFontSize = {}
    global_str = SL:GetConfig("cfg_global", 420001)
    if global_str then
        local type_List = string.split(global_str.value, "#")
        for _, v in ipairs(type_List) do
            table.insert(self.globalFontSize, tonumber(v))
        end
    end
    SL.DropItem:SetGlobalFontSize(self.globalFontSize[4])
    damageNumberConfig = {}
    local damageNumberTbl = SL:GetConfigTable("cfg_damage_number")
    for i, v in pairs(damageNumberTbl) do
        damageNumberConfig[v.id] = {
            cfg = v,
            fontColor = SL:GetConfig("cfg_color", v.fontColor).color,
            OtherFontColors = SL:GetConfig("cfg_color", v.OtherFontColors).color,
        }
    end

    local queueConfig = SL.Head:GetGlobalRenderQueueConfig()
    nameBgRenderQueue[ERoleType.Me] = queueConfig[EHeadType_RenderQueue.Me].renderQueue
    nameBgRenderQueue[ERoleType.Item] = queueConfig[EHeadType_RenderQueue.Item].renderQueue
    nameBgRenderQueue[ERoleType.Npc] = queueConfig[EHeadType_RenderQueue.NPC].renderQueue
    nameBgRenderQueue[ERoleType.Player] = queueConfig[EHeadType_RenderQueue.Player].renderQueue
    nameBgRenderQueue[ERoleType.Pet] = queueConfig[EHeadType_RenderQueue.Pet].renderQueue
    nameBgRenderQueue[ERoleType.Seller] = queueConfig[EHeadType_RenderQueue.Seller].renderQueue
    nameBgRenderQueue[ERoleType.Monster] = queueConfig[EHeadType_RenderQueue.Monster].renderQueue
    nameBgRenderQueue[999] = queueConfig[EHeadType_RenderQueue.Other].renderQueue
    ---自身buff值
    self.selfBuffValue = {}
end

function this:Reset()
    self.oldAttrNum = 0
    if self.newPlayerEffect then
        SL:RecycleSceneItemModel(self.newPlayerEffect)
        self.newPlayerEffect = nil
    end
end

function this:RegistMessages()
    SL:RegisterLUAEvent(LUA_EVENT_ROLEMODEL_ONLOAD_ALL, self.LUA_EVENT_ROLEMODEL_ONLOAD_ALL, self)
    SL:RegisterTrigger(LUA_TRIGGER_ROLE_HEAD_UNION_NAME_CHANGE, self.LUA_TRIGGER_ROLE_HEAD_UNION_NAME_CHANGE, self)
    SL:RegisterTrigger(LUA_TRIGGER_PLAYER_NAME_COLOR_CHANGE, self.LUA_TRIGGER_PLAYER_NAME_COLOR_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_UNION_NAME_CHANGE, self.LUA_EVENT_PLAYER_UNION_NAME_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_QUIT_UNION, self.LUA_EVENT_QUIT_UNION, self)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_NAME_CHANGE, self.LUA_EVENT_PLAYER_NAME_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_NAME_CHANGE, self.LUA_EVENT_MONSTER_NAME_CHANGE, self)
    SL:RegisterTrigger(LUA_TRIGGER_ROLE_HP_SPRITE_LOAD, self.LUA_TRIGGER_ROLE_HP_SPRITE_LOAD, self)
    SL:RegisterTrigger(LUA_TRIGGER_DROP_ITEM_NAME_CHANGE, self.LUA_TRIGGER_DROP_ITEM_NAME_CHANGE, self)
    --SL:RegisterTrigger(LUA_TRIGGER_HURT_SHOW, self.LUA_TRIGGER_HURT_SHOW, self)
    SL:RegisterTrigger(LUA_TRIGGER_DROPITEM_NAME_LOCALPOSITION_Z, self.LUA_TRIGGER_DROPITEM_NAME_LOCALPOSITION_Z, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BUFF_VALUES, self.RES_BUFF_VALUES, self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_DIE_HPANIMATION_END, self.LUA_EVENT_ROLE_DIE_HPANIMATION_END, self)
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_MAP, self.LUA_EVENT_LOGIN_MAP, self)
    SL:RegisterLUAEvent(LUA_EVENT_SHIELDCHANGE, self.RefreshShield, self)--主角护盾值改变事件
    --SL:RegisterTrigger(LUA_EVENT_TRADE_HP_IS_SHOW, self.LUA_EVENT_TRADE_HP_IS_SHOW, self)
    SL:RegisterLUAEvent(LUA_EVENT_OTHER_ROLE_SD_SHIELD_CHANGE, self.LUA_EVENT_OTHER_ROLE_SD_SHIELD_CHANGE, self)--主角护盾值改变事件
end

function this:LUA_EVENT_LOGIN_MAP()
    -- 设置离线不暂停自动挂机
    SL.AutoFight:SetIsLeaveGameStopAutoHook(false)
    SL.AutoFight:SetIsClickFloorStopHook(false)
end

---角色模型加载完成
function this:LUA_EVENT_ROLEMODEL_ONLOAD_ALL(_, msg)
    -- if msg.RoleType == ERoleType.Me then
    --     local rid = SL:GetMeData().id
    --     local head = SL:GetHeadPart_out(rid, EHeadPart_Out.SD_Slider, SL:GetPreLoadAsset("SpriteMesh-hp"), 
    --     Vector3.New(0,22,0), Vector3.one, Vector3.zero, CS.CSSpriteMesh)
    --     SL.Head:SetHeadPartSprite(rid, EHeadPart_Out.SD_Slider, 4, "FG_Common", "setting_loadingBar_fill", 1, 30, 40, 1)
    --     SL.Head:SetHeadPartSprite(rid, EHeadPart_Out.SD_Slider, 5, "FG_Common", "setting_loadingBar_bg", 1, 1, 1, 1)
    -- end
    if not showNameBgType[msg.RoleType] or msg.data.isUI then
        return
    end
    self:UpdateNameBg(msg)
end

--刷新护盾值
---@param data RoleChangeData
function this:RefreshShield(data)
    local shield = Global.CurSD
    local maxShield = Global.MaxSD
    local precent = 1
    if shield and maxShield ~= 0 and maxShield ~= nil then
        precent = shield / maxShield
    end
    local rid = tonumber(SL:GetMetaValue(EMetaVarGetKey.USER_ID))
    SL.Head:SetHeadPartSprite(rid, EHeadPart_Out.SD_Slider, 4, "FG_HUD", "bg_sd_shield", precent, 75, 50, 1)
    self:GetHead(rid)
end
--其他玩家刷新护盾值
function this:LUA_EVENT_OTHER_ROLE_SD_SHIELD_CHANGE(_, rid)
    local curSd, maxSd = InfoManager.AGAndSDInfo:GetOtherPlayerSdData(rid)
    local fillAmount
    if curSd and maxSd and maxSd ~= 0 then
        fillAmount = curSd / maxSd
    else
        fillAmount = 1
    end
    SL.Head:SetHeadPartSprite(rid, EHeadPart_Out.SD_Slider, 4, "FG_HUD", "bg_sd_shield", fillAmount, 75, 50, 1)
    self:GetHead(rid)
end

function this:LUA_EVENT_TRADE_HP_IS_SHOW(rid, isHpActive)
    local role = SL:GetRoleById(rid)
    local isPlayer = role and role:IsPlayer() or false
    local isMe =  role and role:IsMe() or false
    local isDead = role and role:IsDie() or false
    if isPlayer or isMe then
        --logError(tostring(isMe) .. "   "..tostring(isDead))
        if isHpActive and not isDead then
            local head = SL:GetHeadPart_out(rid, EHeadPart_Out.SD_Slider, SL:GetPreLoadAsset("SpriteMesh-hp"), 
             Vector3.New(0,-12,0), Vector3.New(75, 50, 1), Vector3.zero, CS.CSSpriteMesh)
            local bgSprite22 = head:GetComponent(typeof(CS.CSSpriteMesh))
            if not IsNil(bgSprite22.Mat) then
                bgSprite22.Mat.renderQueue = 5000
            end
            if isMe then
                self:RefreshShield()
            end
            if isPlayer then
                self:LUA_EVENT_OTHER_ROLE_SD_SHIELD_CHANGE(nil, rid)
            end
            SL.Head:SetHeadPartSprite(rid, EHeadPart_Out.SD_Slider, 5, "FG_HUD", "bg_hp_di_2", 1, 0, 0, 0)
        else
            SL:RecycleHeadPart_out(rid, EHeadPart_Out.SD_Slider)
        end
    end
end

---刷新渲染顺序
function this:GetHead(rid)
    -- local role = SL:GetRoleById(rid)
    -- if role and role.Head then
    --     local head = role.Head.out_headPart[EHeadPart_Out.SD_Slider]
    --     if head then
    --         local bgSprite = head:GetComponent(typeof(CS.UnityEngine.MeshRenderer))
    --         local orMat = bgSprite.materials[0]
    --         if not IsNil(orMat) then
    --             -- if not role:IsMe() then
    --             --     logError("不是我设置")
    --             -- end
    --             --orMat.renderQueue = 5000
    --         end
    --     end
    -- end
    -- local head = SL:GetHeadPart_out(rid, EHeadPart_Out.SD_Slider, SL:GetPreLoadAsset("SpriteMesh-hp"), 
    --         Vector3.New(0,-12,0), Vector3.New(75, 50, 1), Vector3.zero, CS.CSSpriteMesh)
    -- local bgSprite = head:GetComponent(typeof(CS.UnityEngine.MeshRenderer))
    -- local orMat = bgSprite.materials[0]
    -- if not IsNil(orMat) then
    --     orMat.renderQueue = 5000
    -- end
    -- return head
end

---触发器战盟改名
function this:LUA_TRIGGER_ROLE_HEAD_UNION_NAME_CHANGE(unionName, playerHead)
    local unionInfo = string.format("[%s] 战盟%s", unionName, playerHead.role.data.position == 0 and "成员" or EUnionPositionToName[playerHead.role.data.position])
    local selfUnionId = SL:MeData_GetUnionId()
    local color
    if selfUnionId == playerHead.role.data.unionId then
        -- 同一个战盟
        color = self.colorConfig[ENameColorConfig.SomeUnion]
    else
        local atkMode = SL:GetMetaValue(EMetaVarGetKey.PKMODE)
        if atkMode == EPKMode.Union then
            -- 攻击模式为战盟，就变为敌对战盟
            color = self.colorConfig[ENameColorConfig.EnemyUnion]
        else
            -- 其他模式是其他战盟
            color = self.colorConfig[ENameColorConfig.NoEnemyUnion]
        end
    end

    return unionInfo, color
end

---玩家名字颜色
function this:LUA_TRIGGER_PLAYER_NAME_COLOR_CHANGE(HeadData, color)
    ----精灵妹妹不改变名字颜色
    if HeadData and HeadData.role and HeadData.role.data and InfoManager.guardPetInfo.MM_ID == HeadData.role.data.id then
        return Color.whiteNonAlloc
    end
    if color.r == 1 and color.g == 1 and color.b == 1 and color.a == 1 then
        return self.colorConfig[ENameColorConfig.PlayerName]
    end
    return nil
end

---战盟改名
function this:LUA_EVENT_PLAYER_UNION_NAME_CHANGE(_, playerHead)
    self:UpdateNameBg(playerHead.role)
end

---退出战盟
function this:LUA_EVENT_QUIT_UNION()
    self:UpdateNameBg(SL:GetRoleById(SL:MeData_GetId()))
end

---角色改名
function this:LUA_EVENT_PLAYER_NAME_CHANGE(_, playerHead)
    if playerHead.role.data.isUI then
        return
    end
    self:UpdateNameBg(playerHead.role)
end

---怪物改名
function this:LUA_EVENT_MONSTER_NAME_CHANGE(_, playerHead)
    local monsterName = playerHead.role.data.name .. "  LV:" .. tostring(playerHead.role.serverData.level)
    --local monsterName = "黄金小巴哈姆特 LV:9999"
    --local monsterName = "黄金 LV:1"
    playerHead.lab_name.fontSize = self.globalFontSize[3]
    playerHead.lab_name.text = monsterName
    --playerHead.lab_name.Anchor = 1
    playerHead.lab_name.transform.localPosition = Vector3.New(0, -7.46, 0)
    self:UpdateNameBg(playerHead.role)
end

---替换角色血条
function this:LUA_TRIGGER_ROLE_HP_SPRITE_LOAD(roleHead)
    if roleHead.role.RoleType ~= ERoleType.Monster and roleHead.role.RoleType ~= ERoleType.Me and roleHead.role.RoleType ~= ERoleType.Player then
        return
    end
    local isPlayer = roleHead.role.RoleType == ERoleType.Me or roleHead.role.RoleType == ERoleType.Player
    local hpBg
    local hpBgH = not IsNil(roleHead.hp) and roleHead.hp.transform or nil--roleHead.transform:Find("SpriteMesh-hp")
    local nilHp = IsNil(hpBgH)
    if not nilHp then
        hpBg = hpBgH:Find("SpriteMesh-hpbg")
        if isPlayer then
            hpBgH.localPosition = Vector3.New(0, -18, 0)
        end
    end
    if not IsNil(hpBg) and not nilHp then
        hpBg.localScale = Vector3.one
        if isPlayer then
            hpBg.localPosition = Vector3.New(0, 0.045, 0)
        else
            hpBg.localPosition = Vector3.zero
        end
        if roleHead.role.RoleType == ERoleType.Monster then
            hpBgH.localScale = { x = 75, y = 75 * 2 / 3, z = 75 }
        end
        if roleHead.role.RoleType == ERoleType.Player or roleHead.role.RoleType == ERoleType.Me then
            hpBgH.localScale = { x = 75, y = 75 * 4 / 5, z = 75 }
        end
    end
    local bg = "bg_hp_di"
    if isPlayer then
        bg = "bg_hp_di_2"
    end
    return "FG_HUD", "bg_hp_green", "bg_hp_red", bg
end

local needUpdateMat = false
---更新名字背景
function this:UpdateNameBg(player)
    local root = player.Head.transform:Find("HeadNameBg")
    needUpdateMat = false
    if root == nil then
        local instanceGo = SL:GetPreLoadAsset(nameBgPath)
        if instanceGo == nil then
            SL:LogError("未找到名字背景")
            return
        end
        root = SL:GetHeadPart_out(player.data.id, EHeadPart_Path_Out[EHeadPart_Out.Name_BG_Part], instanceGo, Vector3.zero, Vector3.one, Vector3.zero).transform
        root:SetAsFirstSibling()
        needUpdateMat = true
    end

    local bgSprite = root:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    -- 更新材质
    if needUpdateMat then
        local mat = self.nameBgMats[player.RoleType]
        if mat == nil then
            local orMat = bgSprite.material
            mat = CS.UnityEngine.Material(orMat)
            local nameRenderQueue = nameBgRenderQueue[player.RoleType]
            if nameRenderQueue == nil then
                nameRenderQueue = nameBgRenderQueue[999]
            end
            mat.renderQueue = nameRenderQueue - 1
            self.nameBgMats[player.RoleType] = mat
        end
        bgSprite.material = mat
    end
    --local bgSprite = UtilityLua.Get(root.transform, "SpriteMesh-Img", typeof(CS.CSSpriteMesh))
    local color = self.colorConfig[showNameBgColor[player.RoleType] or ENameColorConfig.TextBg]
    bgSprite.color = color
    --headNameBg.bgSprite.Color = color
    --local strList = string.split(SL:GetConfig("cfg_global", 420001).value, "#")
    SL:ScheduleOnce(0.05, function()
        if player.Head == nil then
            return
        end
        local lab_name = player.Head.lab_name
        if IsNil(lab_name) then
            --SL:LogError("未找到Head lab_name", player.data.name)
            return
        end
        local meshFilter = lab_name.transform.gameObject:GetComponent(typeof(CS.UnityEngine.MeshFilter))
        if IsNil(meshFilter.sharedMesh) then
            --SL:LogError("name 未找到 sharedMesh", player.data.name)
            return
        end
        local halfWidth = lab_name:GetHalfWidth(lab_name.text)
        local width = halfWidth * scale * 0.505
        local textY = lab_name.transform.localPosition.y
        local scaleL = lab_name.transform.localScale.x
        local height = labelSizeScale * lab_name.fontSize
        local y = 0
        --local vertices = CS.System.Collections.Generic.List(CS.UnityEngine.Vector3)
        local vertices = meshFilter.sharedMesh.vertices
        local minY = vertices[0].y
        local maxY = vertices[0].y
        for i = 0, vertices.Length - 1 do
            local vaa = vertices[i]
            if vaa.y >= maxY then
                maxY = vaa.y
            end
            if vaa.y <= minY then
                minY = vaa.y
            end
        end
        local hY = maxY - minY
        local pY = (maxY + minY) / 2
        local offsetY = (textY + pY * scaleL)
        height = hY * scaleL * 5.288461538462
        y = offsetY
        local redNameWidthHalf = 0
        redNameWidthHalf = InfoManager.redNameInfo:GetRedNameWidthHalf(nil, player.data.id)
        if player.data.unionId ~= nil and player.data.unionId > 0 then
            local union_name = player.Head.union_name
            redNameWidthHalf = 0
            if IsNil(union_name) then
                return
            end
            if union_name.gameObject.activeSelf then
                halfWidth = union_name:GetHalfWidth(union_name.text)
                local textUY = union_name.transform.localPosition.y
                local scaleU = union_name.transform.localScale.x
                width = math.max(width, halfWidth * scale * 0.505)
                local union_MeshFilter = union_name.transform.gameObject:GetComponent(typeof(CS.UnityEngine.MeshFilter))
                if IsNil(union_MeshFilter.sharedMesh) then
                    --SL:LogError("name 未找到 union_MeshFilter", player.data.name)
                    return
                end
                local verticesU = union_MeshFilter.sharedMesh.vertices
                local minUY = verticesU[0].y
                local maxUY = verticesU[0].y
                for i = 0, verticesU.Length - 1 do
                    local vaa = verticesU[i]
                    if vaa.y >= maxUY then
                        maxUY = vaa.y
                    end
                    if vaa.y <= minUY then
                        minUY = vaa.y
                    end
                end
                local hUY = maxUY - minUY
                local pUY = (maxUY + minUY) / 2
                local offsetUY = (textUY + pUY * scaleU)
                y = (offsetUY + offsetY) / 2
                local spaceH = offsetUY - offsetY + scaleL + scaleU---字体描边顶点各自加了1  用缩放修正
                height = (hY * scaleL / 2 + hUY * scaleU / 2 + spaceH) * 5.288461538462
            end
            
        end
        
        root.localPosition = Vector3.New(-redNameWidthHalf, y, 0)
        root.localScale = Vector3.New(width * scaleL, height, 1)
        --[[        if player.RoleType ~= ERoleType.Monster then
                    root.localScale = Vector3.New(width*tonumber(strList[2]), height, 1)
                else
                    root.localScale = Vector3.New(width*0.8, height, 1)
                end]]
    end)
end

---道具掉落名字改变触发器
---@param item CommonProtos.Item
function this:LUA_TRIGGER_DROP_ITEM_NAME_CHANGE(item)
    local cfg = SL:GetConfig("cfg_item", item.cfgId)
    local color = SL:GetConfig("cfg_color", cfg.dropcolor).color
    if cfg.type == 2 then
        local _, tempColor = EquipFunc.GetEquipNameAndColor(item)
        color = tempColor
    else
        local name = cfg.name
        local space = "*"
        if name == "金币" then
            name = "金"
            space = " "
            return name .. space .. item.count, color
        end
    end

    return nil, color
end

local isTextFont
local damageNumberColor
local damageNumberFontSize
local damageNumberPlayTime
local zoomSize
local height
local fadeoutPercentage
---伤害显示触发器
function this:LUA_TRIGGER_HURT_SHOW(hurtType, hurtNumber, targetId, attackerId)
    isTextFont = damageNumberConfig[hurtType] and damageNumberConfig[hurtType].cfg.isFont == 1
    if isTextFont then
        local cfg = damageNumberConfig[hurtType]
        damageNumberColor = targetId == SL:MeData_GetId() and cfg.fontColor or cfg.OtherFontColors
        damageNumberFontSize = cfg.cfg.font
        damageNumberPlayTime = cfg.cfg.time
        if hurtNumber <= 0 then
            hurtNumber = "Miss"
        end
        zoomSize = cfg.cfg.enlarge
        height = cfg.cfg.height
        fadeoutPercentage = cfg.cfg.isFadeOut == 1 and 0.6 or 1
    else
        zoomSize = 1
        fadeoutPercentage = 1
    end
    return hurtNumber, isTextFont, damageNumberColor, damageNumberFontSize, damageNumberPlayTime, zoomSize, height, fadeoutPercentage
end

---掉落物名字位置修正
function this:LUA_TRIGGER_DROPITEM_NAME_LOCALPOSITION_Z(dropItem, x, z)
    return -1
end

---buff值
function this:RES_BUFF_VALUES(_, msg)
    table.clear(self.selfBuffValue)
    self.isNewPlayerBuff = false
    for i, v in pairs(msg) do
        self.selfBuffValue[v.buffCfgId] = v
        if v.buffCfgId == 10300002 or v.buffCfgId == 10300003 then
            self.isNewPlayerBuff = true
        end
    end
    
    if self.isNewPlayerBuff and not self.newPlayerEffect then
        local path = SL:GetConfig('cfg_global', 650001).value
        if path then
            SL:CreateSceneItemModel(path, function(res)
                if not IsNil(res) then
                    if self.newPlayerEffect then
                        SL:RecycleSceneItemModel(self.newPlayerEffect)
                        self.newPlayerEffect = nil
                    end
                    self.newPlayerEffect = res
                    
                    local role = SL:GetRoleById(SL:GetMetaValue("USER_ID"))
                    res:SetLocalEulerAngles(0, 0, 0)
                    res:SetParent(role.root.transform)
                    res:SetLocalPosition(0, 0, 0)
                    --self:reMoveNpcTips()
                    SL:onLUAEvent(LUA_NewPlayer_MM_BUFF_CHANGE)
                end
            end)
        end
    else
        if self.newPlayerEffect then
            SL:RecycleSceneItemModel(self.newPlayerEffect)
            self.newPlayerEffect = nil
--[[            if not InfoManager.guardPetInfo.Role_MM then
                self:newPlayerBuffActive()
            end]]
            SL:onLUAEvent(LUA_NewPlayer_MM_BUFF_CHANGE)
        end
    end


end
--[[function this:newPlayerBuffActive()
    SL:MessageTip({id=65001,isServer=false})
    
end
function this:reMoveNpcTips()
    local horseRaceLamp = GUI:GetUI("dev/outui/Message/Panel/KLHorseRaceLamp/KLHorseRaceLampPanel")
    if horseRaceLamp then
        horseRaceLamp:reMoveNpcTips()
    end
end]]
---获取buff属性值
function this:GetBuffAttValue(buffCfgId, attId)
    if self.selfBuffValue[buffCfgId] then
        return self.selfBuffValue[buffCfgId].buffValue[tostring(attId)]
    end
    return nil
end

---死亡移除血条
function this:LUA_EVENT_ROLE_DIE_HPANIMATION_END(id,rid)
    SL.Head:RemoveAllHeadPart(rid)
end