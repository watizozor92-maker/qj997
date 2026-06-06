---@class KLEquipEffPreviewPanel:UIKmlLuaPanelBase
---@field view KLEquipEffPreviewPanelView
local KLEquipEffPreviewPanel = class(UIKmlLuaPanelBase)
local this =KLEquipEffPreviewPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.tabDatas = {}
    GUI:DataListInitData(self.view.tabDataList,function()
        return self:TabDataListItemCountFunc()
    end,function(realIndex)
        return self:TabDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:TabDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:TabDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Btn_Close, self, self.CloseSelf)
    SL:RegisterTrigger(LUA_TRIGGER_SET_STREAM, self.LUA_TRIGGER_SET_STREAM, self)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    self.tabDatas = {}
    local globalCfg = SL:GetConfig("cfg_global", 360001)
    local tabs = string.split(globalCfg.value, '|')
    for _, v in ipairs(tabs) do
        local sp = string.split(v, '#')
        table.insert(self.tabDatas, { lv = tostring(sp[1]), path = sp[2] })
    end
    
    GUI:DataListUpdateData(self.view.tabDataList)
end

function this:Hide()
end

function this:Close()
    if self.curShowRole then
        SL:UIModel_Recycle(self.curShowRole)
    end
    if self.args.closeCallback then
        self.args.closeCallback(self.args.ui)
    end
end

function this:CloseSelf()
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipEffPreview/KLEquipEffPreviewPanel")
end

function this:TabDataListItemCountFunc()
    return #self.tabDatas
end

function this:TabDataListItemGetFunc(realIndex)
end

function this:TabDataListItemInitFunc(realIndex, kmlControl)
end

function this:TabDataListItemUpdateFunc(realIndex, kmlControl)
    local tog = GUI:GetChildControl(self.view.tabDataList, realIndex, "tog")
    local text = GUI:GetChildControl(self.view.tabDataList, realIndex, "text")
    local data = self.tabDatas[realIndex + 1]
    GUI:Text_setText(text, "特效+"..data.lv)
    GUI:SetToggleOnValueChange(tog, self, self.OnValueChange_Tog, data)
    GUI:SetToggleGroup(tog, self.view.tabToggleGroup)
    if realIndex == 0 then
        GUI:SetTogDefaultThis(tog)
    end
end

function this:RefreshModel(data)
    --SL:logNoFlag("刷新模型")
    local intensify = data.lv
    local str = "当主装备的头盔/护甲/护手/\n护腿/靴子均强化至+%s时显示"
    local baseCareer = SL:MeData_GetCareer().baseCareer
    if baseCareer == 14 then
        str = "当主装备的护甲/护手/\n护腿/靴子均强化至+%s时显示"
    end
    
    GUI:Text_setText(self.view.Text_Des, string.format(str, intensify))
    local global = SL:GetConfig("cfg_global", 360002)
    local temp = string.split(global.value,"|")
    local itemId = {}
    for k,v in pairs(temp) do
        local t = string.split(v,"#")
        if tonumber(t[1]) == baseCareer then
            for i=2,#t do
                table.insert(itemId, tonumber(t[i]))
            end
        end
    end
    
    local equip = {}
    local equipShowIdx = {}
    local roleAppear = {}
    for k,v in pairs(itemId) do
        local itemCfg = SL:GetConfig("cfg_item", v)
        local itemInfo = {
            cfgId = v,
            durability = 0,
            gmExtInfo = {
                field = 0,
                luaExt = string.format("{\"strengthlv\":%d}", intensify),
                shape = 0,
                sweepLevel = 0,
            },
            id = 0,
            index = (1 << 16) | (itemCfg.strPart[1] & 0xFF),
            modelExtInfo = {
                feedLevel = 0,
                grade = 1,
                strengthLevel = intensify
            },
            luaExtData = string.format("{\"strengthlv\":%d}", intensify),
        }
        table.insert(equip, itemInfo)
        table.insert(equipShowIdx, k)
        table.insert(roleAppear, { cfgId = v, pos = itemCfg.strPart[1] })
    end

    if self.curShowRole then
        SL:UIModel_Recycle(self.curShowRole)
    end
    local roleInfoExtData = InfoManager.cardShapeShiftInfo:DeepCopy(SL:MeData_GetRoleExtInfo().roleInfoExtData)
    roleInfoExtData.equip = equip
    roleInfoExtData.equipShowIdx = equipShowIdx
    roleInfoExtData.roleAppear = roleAppear
    self.curShowRole = SL:UIModel_Create(GUI:GetRectTransform(self.view.roleParent),111111,
                                         SL:MeData_GetCareer(), SL:MeData_GetLevel(), "模型展示", 
                                         0, EAction.Stand, EBehaviourType_Stand.Stand, roleInfoExtData,
                                         0,-287,-70,224,
                                         0, 30,0)
end

function this:OnValueChange_Tog(id, args, data)
    local isToggle = data[1]
    if isToggle then
        self:RefreshModel(args)
        --GUI:Model_setSrc(self.view.Model_Player, self.tabDatas[agrs].path)
    end
end

function this:LUA_TRIGGER_SET_STREAM(go, roleId, itemCfgId, strengthLevel)
    if roleId ~= 111111 then
        return
    end
    if not self.tempEquipInfo then
        self.tempEquipInfo = {}
    end
    self.tempEquipInfo.cfgId = itemCfgId
    --[[for _, v in pairs(self.teamInfo.teamMember) do
        if v.roleInfo.rid == roleId then
            for _, k in pairs(v.roleInfo.roleInfoExt.equip) do
                if k.cfgId == itemCfgId then
                    strengthLevel = k.strengthlv
                    break
                end
            end
            if strengthLevel > 0 then
                break
            end
        end
    end]]
    local liuGuangId = EquipFunc.GetEquipLiuGuangId(self.tempEquipInfo, strengthLevel)
    SL:SetMetaValue(EMetaVarSetKey.EQUIP_STREAMER_REFRESH, go, liuGuangId)
end

return this
