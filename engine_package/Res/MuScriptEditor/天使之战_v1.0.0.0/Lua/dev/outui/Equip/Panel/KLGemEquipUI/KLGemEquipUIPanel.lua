---@class KLGemEquipUIPanel:UIKmlLuaPanelBase
---@field view KLGemEquipUIPanelView
local KLGemEquipUIPanel = class(UIKmlLuaPanelBase)
local this =KLGemEquipUIPanel

---@class ESlotCondition
local ESlotCondition = {
    [EEquipSlotType.FashionHelmet] = EEquipSlotType.Helmet,
    [EEquipSlotType.FashionArmor] = EEquipSlotType.Armor,
    [EEquipSlotType.FashionWeapon] = EEquipSlotType.Weapon,
    [EEquipSlotType.TwoHandWeapon] = EEquipSlotType.Weapon,
    [EEquipSlotType.FashionTwoHandWeapon] = EEquipSlotType.Weapon,
    [EEquipSlotType.FashionOffHandWeapon] = EEquipSlotType.OffHandWeapon,
    [EEquipSlotType.FashionGlove] = EEquipSlotType.Glove,
    [EEquipSlotType.FashionPant] = EEquipSlotType.Pant,
    [EEquipSlotType.FashionBoot] = EEquipSlotType.Boot,
    [EEquipSlotType.FashionWing] = EEquipSlotType.Wing,
    [EEquipSlotType.FashionGuard] = EEquipSlotType.Guard,
    [EEquipSlotType.FashionNecklace] = EEquipSlotType.Necklace,
    [EEquipSlotType.FashionLeftEarring] = EEquipSlotType.LeftEarring,
    [EEquipSlotType.FashionRightEarring] = EEquipSlotType.RightRing,
    [EEquipSlotType.FashionLeftRing] = EEquipSlotType.LeftRing,
    [EEquipSlotType.FashionRightRing] = EEquipSlotType.RightRing
}

---@class EEquipGridDefaultData
---@field width number      @grid的宽度
---@field height number     @grid的高度
---@field x number          @grid的x坐标
---@field y number          @grid的y坐标
---@field qualityX number   @品阶角标x坐标
---@field qualityY number   @品阶角标y坐标
---@field strengthX number  @强化追加x坐标

local jewelryDefaultId = {
    [EEquipSlotType.Necklace] = 21000021,
    [EEquipSlotType.LeftEarring] = 21200121,
    [EEquipSlotType.RightEarring] = 21200121,
    [EEquipSlotType.LeftRing] = 21100031,
    [EEquipSlotType.RightRing] = 21100031,
}

function this:AsyncLoadUI(...)
    SL:LoadUIAssetAsync('UI/UIEquipPanel.prefab', self)
end

---创建时调用一次
function this:Init()
    GUI:setVisible(self.view.WearArchange,false)
    self.slotToGrid = {}
    self.equips = {}
    self.wearBarItems = {}
    self.selectItem = nil
    self.equipSlotTypeList = {}
    for i, v in pairs(EEquipSlotType) do
        table.insert(self.equipSlotTypeList, { name = i, type = v })
    end
    table.sort(self.equipSlotTypeList, function(a, b)
        return a.type < b.type
    end)
    local config = SL:GetConfigTable("cfg_wearing_bar")
    ---@param v cfg_wearing_bar_column
    for k, v in pairs(config) do
        if string.contains(v.tag, "时装穿戴栏") then
            local width = 81
            local height = 82
            if k == EEquipWearBarType.Angel then
                width = 168
                height = 85
            end
            GUI:UIPanel_Open('dev/ui/Equip/Item/KLWearBarBtn/KLWearBarBtnItem', self.view.Content, self,
                    { sprite = v.icon, altas = "Atlas/UIzhuangbeixt.spriteatlas", selectSprite = string.replace(v.icon, "01", "02"),
                      onClick = self.SetSelfWearBarType, clickData = self, wearBar = k,
                      width = width, height = height, toggleGroup = self.view.Content }, true,
                    function(item)
                        self.wearBarItems[k] = item
                    end)
        end
    end
    self.gridData = {
        [EEquipSlotType.Weapon] = { bg = "img_player_weapon1", width = 97, height = 228, x = 28, y = -157, qualityX = 3, qualityY = -3, strengthX = -16, selectX = 5, selectY = -2, selectWidth = 78, selectHeight = 211 },
        [EEquipSlotType.OffHandWeapon] = { bg = "img_player_weapon2", width = 98, height = 228, x = 328, y = -157,qualityX = 5.2, qualityY = -2.8, strengthX = -10, selectX = 8.5, selectY = -5, selectWidth = 80, selectHeight = 210 },
        [EEquipSlotType.Helmet] = { bg = "img_player_helm", width = 124, height = 115, x = 166, y = -15, qualityX = 7, qualityY = -2, strengthX = -12, selectX = 7, selectY = -2, selectWidth = 107, selectHeight = 102 },
        [EEquipSlotType.Armor] = { bg = "img_player_armor", width = 124, height = 228, x = 166, y = -157, qualityX = 7, qualityY = -2, strengthX = -12, selectX = 7, selectY = -3, selectWidth = 105, selectHeight = 210 },
        [EEquipSlotType.Glove] = { bg = "img_player_glove", width = 96, height = 116, x = 30, y = -411, qualityX = 3, qualityY = -2, strengthX = -12, selectX = 2, selectY = -2, selectWidth = 86, selectHeight = 101 },
        [EEquipSlotType.Pant] = { bg = "img_player_pant", width = 124, height = 115, x = 166, y = -411, qualityX = 7, qualityY = -2, strengthX = -12, selectX = 7, selectY = -3, selectWidth = 105, selectHeight = 100 },
        [EEquipSlotType.Boot] = { bg = "img_player_boot", width = 96, height = 116, x = 330, y = -411, qualityX = 3, qualityY = -2, strengthX = -12, selectX = 3, selectY = -3, selectWidth = 83, selectHeight = 100 },
        [EEquipSlotType.Necklace] = { bg = "img_player_necklace", width = 55, height = 57, x = 118, y = -19, qualityX = 0, qualityY = 0, strengthX = -3, selectX = 0, selectY = 0, selectWidth = 54, selectHeight = 50 },
        [EEquipSlotType.LeftEarring] = { bg = "img_player_earrings", width = 55, height = 57, x = 118, y = -322, qualityX = 0, qualityY = 0, strengthX = -3, selectX = 0, selectY = 0, selectWidth = 54, selectHeight = 50 },
        [EEquipSlotType.RightEarring] = { bg = "img_player_earrings", width = 55, height = 57, x = 279, y = -322, qualityX = 0, qualityY = 0, strengthX = -3, selectX = 0, selectY = 0, selectWidth = 51, selectHeight = 50 },
        [EEquipSlotType.LeftRing] = { bg = "img_player_ring", width = 55, height = 57, x = 118, y = -413, qualityX = 0, qualityY = 0, strengthX = -3, selectX = 0, selectY = 0, selectWidth = 54, selectHeight = 50 },
        [EEquipSlotType.RightRing] = { bg = "img_player_ring", width = 55, height = 57, x = 279, y = -413, qualityX = 0, qualityY = 0, strengthX = -3, selectX = 3, selectY = -1, selectWidth = 50, selectHeight = 48 },
        [EEquipSlotType.Guard] = { bg = "img_player_pet", width = 96, height = 116, x = 30, y = -15, qualityX = 3, qualityY = -2, strengthX = -12, selectX = 3, selectY = -2, selectWidth = 84, selectHeight = 100 },
        [EEquipSlotType.Wing] = { bg = "img_player_wing", width = 96, height = 116, x = 330, y = -15, qualityX = 3, qualityY = -2, strengthX = -12, selectX = 3, selectY = -2, selectWidth = 82, selectHeight = 100 },
        [EEquipSlotType.PriestHawk] = { bg = "img_player_washi", width = 96, height = 116, x = 330, y = -157, qualityX = 3, qualityY = -2, strengthX = -10 }
    }
    self.specialData = { bg = "img_player_gemstone", width = 96, height = 116, x = 330, y = -270, qualityX = 3, qualityY = -2, strengthX = -10 }
    if not self.args then
        self.args = {}
    end
    local x = self.args.x or -400
    local y = self.args.y or 0
    GUI:setPosition(self.view.UIEquipPanel_Root, x, y)
    self.relatePanel = self.args.relatePanel
    ---是否隐藏主界面
    self.isHideMainUI = self.args.isHideMainUI
    self.hideTips = self.args.hideTips
    self.closeCallBack = self.args.callBack
    self.closeCallBackData = self.args.callBackData
    self.selectType = self.args.selectType
    --是否是查看其他玩家装备
    self.isOtherPlayer = self.args.isOther
    self.otherRid = self.args.rid
    self.otherEquips = nil
    if self.isOtherPlayer then
        SL.Friend:ReqOtherRoleInfoMessage(self.otherRid, 4)
    end
    self:SetBaseWearBar()
end

function this:SetBaseWearBar(career)
    --基础穿戴栏
    local wearBars
    if self.isOtherPlayer and career then
        wearBars = self:GetCareerOpenWearBar(career)
    else
        wearBars = self:GetCareerOpenWearBar(SL:MeData_GetCareer())
    end
    self.baseWearBar = EEquipWearBarType.BaseEquip
    if wearBars and wearBars[1] then
        self.baseWearBar = wearBars[1]
    end
end

function this:GetCareerOpenWearBar(career)
    ---@type cfg_career_column
    local tbl = SL:GetConfigMultiKeys('cfg_career',career.baseCareer, career.careerRank,
            'baseCareer', 'careerRank')

    if tbl == nil then
        return nil
    end

    return tbl.careerWearBar
end

function this:Show(...)
    self.relatePanel = self.args.relatePanel
end
---创建或者刷新界面数据时调用
function this:Refresh()
    if not self.isOtherPlayer then
        self:UpdatePanel()
    end

    if not self.args or (self.args and not self.args.isPreLoad) then
        SL.HideMainPanel()
    end
end

function this:SetSelectIndex(index)
    local item = self.slotToGrid[index]
    if item then
        if self.selectItem then
            self.selectItem:SetSelect(false)
        end
        item:SetSelect(true)
        self.selectItem = item
    end
end

---@刷新界面
function this:UpdatePanel()
    --拥有时装时才显示切换时装穿戴栏按钮
    local ownFashion
    if self.isOtherPlayer then
        --查看他人装备只查看基础穿戴栏装备
        ownFashion = false
    else
        ownFashion = false
        self:UpdateMoney()
    end
    GUI:setVisible(self.view.wearBarChange, ownFashion)
    local wearBar = self.args and self.args.wearBar or self.baseWearBar
    if not ownFashion then
        wearBar = self.baseWearBar
    end
    self:SetSelfWearBarType(wearBar)
end

---@param wearBarType EEquipWearBarType
function this:SetSelfWearBarType(wearBarType)
    self.wearBar = wearBarType
    local equips
    if self.isOtherPlayer then
        --别人装备
        equips = self.otherEquips and self.otherEquips[wearBarType] or {}
        GUI:setVisible(self.view.MoneyList, false)
        GUI:setVisible(self.view.WearBarList, false)
    else
        --自己装备
        equips = SL:GetWearBarsData(wearBarType)
        local show = false
        if wearBarType == self.baseWearBar then
            show = true
            GUI:Image_loadTexture(self.view.wearBarChange, "sz_01", "Atlas/UIzhuangbeixt.spriteatlas")
        else
            GUI:Image_loadTexture(self.view.wearBarChange, "zb_01", "Atlas/UIEquipPanel.spriteatlas")
        end
        GUI:setVisible(self.view.MoneyList, show)
        GUI:setVisible(self.view.WearBarList, not show)
    end
    self.equips = equips
    if self.wearBarItems[wearBarType] then
        self.wearBarItems[wearBarType]:SetSelected()
    end
    self:UpdateEquips()
end

--更下当前穿戴栏装备
function this:UpdateEquips()
    if self.isUpdateEquips then
        return
    end
    local wearBarType = self.wearBar
    --根据穿戴栏更新装备数据以及需要显示的装备grid
    local noShowSlot = {
        EEquipSlotType.None,
        EEquipSlotType.Banner,
        EEquipSlotType.FashionTotalArmor
    }

    ---@type cfg_wearing_bar_column
    local tbl = SL:GetConfig("cfg_wearing_bar", wearBarType)

    for k, data in ipairs(self.equipSlotTypeList) do
        --类型
        local v = data.type
        --双手武器和双手时装武器 跟对应主武器共用一个
        if v ~= EEquipSlotType.TwoHandWeapon and v ~= EEquipSlotType.FashionTwoHandWeapon and v ~= EEquipSlotType.ArchangelTwoHandWeapon then
            if not table.contains(noShowSlot, v) and not table.contains(tbl.hideArea, v) then
                local p = v
                if ESlotCondition[v] then
                    p = ESlotCondition[v]
                end
                if not self.slotToGrid[v] then
                    self.isUpdateEquips = true
                    self.endEquipSlotTypeListIndex = k
                    local default = self.gridData[v] or self.gridData[p]
                    if self.wearBar == EEquipWearBarType.ShengDaoShi and v == EEquipSlotType.OffHandWeapon then
                        default = self.specialData
                    end
                    local args = { equipPos = v, isOtherPlayer = self.isOtherPlayer, isEquipGrid = true, item = nil, default = default or {}, x = default.x, y = default.y, click = self.OnGridItemClick, callBackUI = self }
                    GUI:UIPanel_Open("dev/ui/Common/Item/KLBagItem/KLBagItemItem", self.view.EquipGrid, self, args, true, function(win)
                        self.slotToGrid[v] = win
                        GUI:setName(self.slotToGrid[v].view.root, "Grid_" .. data.name)
                        GUI:setVisible(self.slotToGrid[v].view.root, true)
                        self.slotToGrid[v]:SetItem(self.equips[v], self.forgeGroupType)
                        --双手武器没进来 正常双手武器跟主手武器不会同时出现，主武器空就设置一下双手武器
                        if v== EEquipSlotType.Weapon then
                            self.slotToGrid[EEquipSlotType.TwoHandWeapon] = self.slotToGrid[EEquipSlotType.Weapon]  --双手武器和主武器用同一个
                            if self.equips[v] == nil then
                                self.slotToGrid[EEquipSlotType.TwoHandWeapon]:SetItem(self.equips[EEquipSlotType.TwoHandWeapon], self.forgeGroupType)
                            end
                        elseif v== EEquipSlotType.FashionWeapon then
                            self.slotToGrid[EEquipSlotType.FashionTwoHandWeapon] = self.slotToGrid[EEquipSlotType.FashionWeapon]  --时装双手武器和时装主武器用同一个
                            if self.equips[v] == nil then
                                self.slotToGrid[EEquipSlotType.FashionTwoHandWeapon]:SetItem(self.equips[EEquipSlotType.FashionTwoHandWeapon], self.forgeGroupType)
                            end
                        elseif v== EEquipSlotType.ArchangelWeapon then
                            self.slotToGrid[EEquipSlotType.ArchangelTwoHandWeapon] = self.slotToGrid[EEquipSlotType.ArchangelWeapon] -- 天使装备同上
                            if self.equips[v] == nil then
                                self.slotToGrid[EEquipSlotType.ArchangelTwoHandWeapon]:SetItem(self.equips[EEquipSlotType.ArchangelTwoHandWeapon], self.forgeGroupType)
                            end
                        elseif v== EEquipSlotType.Pant or v == EEquipSlotType.Glove then
                            -- Glove和Pant和右侧的装备栏贴的太近 需要调下层级（主要是加了红点会被遮挡）
                            GUI:SetAsLastSibling(self.slotToGrid[v].view.root)
                        end
                        if k == self.endEquipSlotTypeListIndex then
                            self.isUpdateEquips = false
                        end
                        self.slotToGrid[v]:SetSelect(self.selectType == v)
                        if self.selectType == v then
                            self.selectItem = self.slotToGrid[v]
                        end
                    end)
                else
                    local default = self.gridData[v] or self.gridData[p]
                    if self.wearBar == EEquipWearBarType.ShengDaoShi and v == EEquipSlotType.OffHandWeapon then
                        default = self.specialData
                    end
                    local args = { equipPos = v, isOtherPlayer = self.isOtherPlayer, isEquipGrid = true, item = nil, default = default or {}, x = default.x, y = default.y, click = self.OnGridItemClick, callBackUI = self }
                    self.slotToGrid[v]:set_args(args)
                    self.slotToGrid[v]:SetItem(self.equips[v], self.forgeGroupType)
                    if self.equips[v] == nil then
                        --双手武器没进来 只能在设置主武器时同时设置一下
                        if v== EEquipSlotType.Weapon then
                            self.slotToGrid[EEquipSlotType.TwoHandWeapon]:SetItem(self.equips[EEquipSlotType.TwoHandWeapon], self.forgeGroupType)
                        elseif v== EEquipSlotType.FashionWeapon then
                            self.slotToGrid[EEquipSlotType.FashionTwoHandWeapon]:SetItem(self.equips[EEquipSlotType.FashionTwoHandWeapon], self.forgeGroupType)
                        elseif v== EEquipSlotType.ArchangelWeapon then
                            self.slotToGrid[EEquipSlotType.ArchangelTwoHandWeapon]:SetItem(self.equips[EEquipSlotType.ArchangelTwoHandWeapon], self.forgeGroupType)
                        end
                    end
                    -- 预加载重新调用下这个
                    self.slotToGrid[v]:RegistEvents()
                    GUI:setVisible(self.slotToGrid[v].view.root, true)
                end

            else
                if self.slotToGrid[v] then
                    GUI:setVisible(self.slotToGrid[v].view.root, false)
                end
            end
        end
    end
end

--装备穿戴栏点击回调
function this:OnGridItemClick(view, item)
    if not self.hideTips and item then
        local bag = self.isOtherPlayer and "otherEquip" or "equip"
        SL:OpenTips(bag, item.cfgId, item.id)
    end
    if self.hideTips then
        if GUI:getVisible(view.selectImg)  then
            local bag = self.isOtherPlayer and "otherEquip" or "equip"
            SL:OpenTips(bag, item.cfgId, item.id,nil,nil,{hideBtn = true})
        end
    end
    if not self.isOtherPlayer then
        for pos, v in pairs(self.slotToGrid) do
            if v.view and v.view == view then
                if not self.hideTips and item == nil and jewelryDefaultId[pos] then
                    SL:CommonItemGetPath("", jewelryDefaultId[pos])
                    --SL:OpenTips("", jewelryDefaultId[pos])
                end
                SL:onLUAEvent(LUA_EVENT_EQUIP_GRID_CLICK, pos)
                break
            end
        end
    end
end

--刷新货币数据
function this:UpdateMoney()
    if self.isOtherPlayer then
        return
    end
    GUI:Text_setString(self.view.moneyText, tostring(SL:GetMetaValue(EMetaVarGetKey.MONEY, MUEResourceType.GoldMoney)))
    GUI:Text_setString(self.view.muCoinText, tostring(SL:GetMetaValue(EMetaVarGetKey.MONEY, MUEResourceType.MiracleCurrency)))
    GUI:Text_setString(self.view.muBindCoinText, tostring(SL:GetMetaValue(EMetaVarGetKey.MONEY, MUEResourceType.BindDiaMond)))
    GUI:Text_setString(self.view.diamondText, tostring(SL:GetMetaValue(EMetaVarGetKey.MONEY, MUEResourceType.DiaMond)))
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseButton, self, self.CloseOnClick)
    GUI:AddOnClickEvent(self.view.wearBarChange, self, self.WearBarChangeOnClick)
    SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.UpdateMoney, self)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, self.EquipChange, self)
    GUI:AddOnClickEvent(self.view.moneyBackground, self, self.ShowMoneyTips, MUEResourceType.GoldMoney)
    GUI:AddOnClickEvent(self.view.MUCoinBackground, self, self.ShowMoneyTips, MUEResourceType.MiracleCurrency)
    GUI:AddOnClickEvent(self.view.MUBindCoinBackground, self, self.ShowMoneyTips, MUEResourceType.BindDiaMond)
    GUI:AddOnClickEvent(self.view.diamondBackground, self, self.ShowMoneyTips, MUEResourceType.DiaMond)
    SL:RegisterLuaNetMsg(MessageDef.ResOtherRoleInfoMessage, self.ResOtherRoleInfoMessage, self)
end

---@param message UserProtos.OtherRoleInfoRes
function this:ResOtherRoleInfoMessage(id, message)
    if message.type == 4 and message.role.rid == self.otherRid then
        SL:FriendInfo_SetOtherPlayerEquips(message.equipIndex)
        local equips = {}
        for _, v in pairs(message.equipIndex) do
            local wearBar, pos = SL:GetWearBarAndPosBaseEquipIndex(v.index)
            if not equips[wearBar] then
                equips[wearBar] = {}
            end
            equips[wearBar][pos] = v.equip
        end
        self.otherEquips = equips
        self:SetBaseWearBar(message.role.career)
        self:UpdatePanel()
    end
end

---@param moneyId number @货币id
function this:ShowMoneyTips(_, moneyId)
    SL:OpenTips("bag", moneyId)
end

---@param data table {MakeIndex = 唯一ID, Where = 装备位置, opera = 操作类型 ( 0:初始化 1:增加 2:删除 3:改变), ItemData = 装备数据, WearBar = 穿戴栏id}
function this:EquipChange(_, data)
    if self.isOtherPlayer then
        return
    end
    if not table.isNullOrEmpty(data) then
        if data.WearBar ~= self.wearBar then
            --跳转到穿戴装备的穿戴栏
            if self.wearBarItems[data.WearBar] then
                self.wearBarItems[data.WearBar]:SetSelectedIgnoreIsOn()
            end
        else
            self.equips = SL:GetWearBarsData(self.wearBar)
            local pos = data.Where
            if self.slotToGrid[pos] then
                self.slotToGrid[pos]:SetItem(self.equips[pos], self.forgeGroupType)
            end
        end
    end
end

function this:WearBarChangeOnClick()
    if self.wearBar == self.baseWearBar then
        --切换时装优先切换到穿有时装的穿戴栏
        local tbl = SL:GetConfigTable("cfg_wearing_bar")
        local first
        local ownFashion = false
        ---@param v cfg_wearing_bar_column
        for k, v in pairs(tbl) do
            if self.wearBarItems[v.id] then
                --判断有没有该穿戴栏的装备数据包括背包里
                if SL:CheckOwnTargetWearbarFashion(v.id) then
                    if not first then
                        first = self.wearBarItems[v.id]
                    end
                    if not ownFashion then
                        local equips = SL:GetWearBarsData(v.id)
                        if table.count(equips) > 0 then
                            ownFashion = true
                            self.wearBarItems[v.id]:SetSelectedIgnoreIsOn()
                        end
                    end
                    GUI:setVisible(self.wearBarItems[v.id].view.root,true)
                else
                    GUI:setVisible(self.wearBarItems[v.id].view.root,false)
                end
            end
        end
        --没时装默认选中第一个
        if not ownFashion and first then
            first:SetSelectedIgnoreIsOn()
        end
    else
        self:SetSelfWearBarType(self.baseWearBar)
    end
end

function this:CloseOnClick()
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLGemEquipUIPanel")
    if self.relatePanel then
        GUI:UIPanel_Close(self.relatePanel)
    end
    self.relatePanel = nil
    if self.closeCallBack then
        self.closeCallBack(self.closeCallBackData)
    end
    if not self.isHideMainUI then
        SL.ShowMainPanel()
    end
end

function this:Close()
    for i, v in pairs(self.slotToGrid) do
        GUI:UIPanel_Close(nil,v)
    end
    for i, v in pairs(self.wearBarItems) do
        GUI:UIPanel_Close(nil,v)
    end
    self.slotToGrid = {}
    self.wearBarItems = {}
    -- GUI:Image_loadTexture(self.view.btn_level, "Texture/tower_top.png")
end

return this
