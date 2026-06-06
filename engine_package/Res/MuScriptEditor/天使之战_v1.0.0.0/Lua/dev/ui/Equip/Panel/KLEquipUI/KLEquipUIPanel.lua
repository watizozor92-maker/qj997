---@class KLEquipUIPanel:UIKmlLuaPanelBase
---@field view KLEquipUIPanelView
---@field slotToGrid table<number, KLBagItemItem>
---@field gridData table<number, EEquipGridDefaultData> @<装备位置, EEquipGridDefaultData>
---@field wearBarItems KLWearBarBtnItem[]
local KLEquipUIPanel = class(UIKmlLuaPanelBase)
local this = KLEquipUIPanel

---@class ESlotCondition
local ESlotCondition = {
    [EEquipSlotType.FashionHelmet] = EEquipSlotType.Helmet,
    [EEquipSlotType.FashionArmor] = EEquipSlotType.Armor,
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
    [EEquipSlotType.FashionRightEarring] = EEquipSlotType.RightEarring,
    [EEquipSlotType.FashionLeftRing] = EEquipSlotType.LeftRing,
    [EEquipSlotType.FashionRightRing] = EEquipSlotType.RightRing,
    [EEquipSlotType.ArchangelTwoHandWeapon] = EEquipSlotType.ArchangelWeapon
}
local showSlot = {
    EEquipSlotType.Weapon, EEquipSlotType.OffHandWeapon, EEquipSlotType.Helmet, EEquipSlotType.Armor, EEquipSlotType.Glove, EEquipSlotType.Pant,EEquipSlotType.LeftEarring,EEquipSlotType.RightEarring,
    EEquipSlotType.Boot, EEquipSlotType.Guard, EEquipSlotType.Wing, EEquipSlotType.Necklace,EEquipSlotType.LeftRing, EEquipSlotType.RightRing,EEquipSlotType.Mount
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

function this:Hide()
    --for _, wearBarItem in pairs(self.wearBarItems) do
    --    GUI:UIPanel_Close(nil, wearBarItem)
    --end
    --self.wearBarItems = nil
end

---创建时调用一次
function this:Init()
    GUI:SetAsFirstSibling(self.view.BG_Templete)
    self.equipSlotTypeList = {}
    for i, v in pairs(showSlot) do
        table.insert(self.equipSlotTypeList, { name = v, type = v })
    end
    --[[table.sort(self.equipSlotTypeList, function(a, b)
        return a.type < b.type
    end)]]
    if not self.slotToGrid then
        self.slotToGrid = {}
    else
        ---初始化红点为隐藏
        for i, v in pairs(self.slotToGrid) do
            if v.redPointItem then
                GUI:setVisible(v.redPointItem, false)
            end
        end
    end
    self.equips = {}
    if not self.wearBarItems then
        self.wearBarItems = {}
        --self.selectItem = nil
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
                local item = GUI:UIPanel_Open('dev/ui/Equip/Item/KLWearBarBtn/KLWearBarBtnItem', self.view.Content, self,
                        { sprite = v.icon, altas = "Atlas/UIzhuangbeixt.spriteatlas", selectSprite = string.replace(v.icon, "01", "02"),
                          onClick = self.SetSelfWearBarType, clickData = self, wearBar = k,
                          width = width, height = height, toggleGroup = self.view.Content }, true)
                self.wearBarItems[k] = item
            end
        end
    end

    self.gridData = {
        [EEquipSlotType.Weapon] = { bg = "img_player_weapon1", otherBg = "img_player_weapon1_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 86, height = 216, x = 24, y = -120, qualityX = 3, qualityY = -3, strengthX = -16, selectX = 0, selectY = 0, selectWidth = 86, selectHeight = 216 ,xinyunX = 3, xinyunY = 5},
        [EEquipSlotType.OffHandWeapon] = { bg = "img_player_weapon2", otherBg = "img_player_weapon2_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 86, height = 216, x = 300, qualityX = 5.2, qualityY = -2.8, y = -120, strengthX = -10, selectX = 0, selectY = 0, selectWidth = 86, selectHeight = 216 ,xinyunX = 3, xinyunY = 5},
        [EEquipSlotType.Helmet] = { bg = "img_player_helm", otherBg = "img_player_helm_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 109, height = 106, x = 150, y = -15, qualityX = 7, qualityY = -2, strengthX = -12, selectX = 0, selectY = -2, selectWidth = 107, selectHeight = 102 ,xinyunX = 3, xinyunY = 5},
        [EEquipSlotType.Armor] = { bg = "img_player_armor", otherBg = "img_player_armor_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 110, height = 216, x = 150, y = -120, qualityX = 7, qualityY = -2, strengthX = -12, selectX = 3, selectY = 0, selectWidth = 105, selectHeight = 210 ,xinyunX = 3, xinyunY = 5},
        [EEquipSlotType.Glove] = { bg = "img_player_glove", otherBg = "img_player_glove_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 88, height = 105, x = 24, y = -335, qualityX = 3, qualityY = -2, strengthX = -12, selectX = 2, selectY = -2, selectWidth = 86, selectHeight = 101 ,xinyunX = 3, xinyunY = 5},
        [EEquipSlotType.Pant] = { bg = "img_player_pant", otherBg = "img_player_pant_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 109, height = 106, x = 150, y = -335, qualityX = 7, qualityY = -2, strengthX = -12, selectX = 3, selectY = -3, selectWidth = 105, selectHeight = 100 ,xinyunX = 3, xinyunY = 5},
        [EEquipSlotType.Boot] = { bg = "img_player_boot", otherBg = "img_player_boot_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 88, height = 105, x = 300, y = -335, qualityX = 3, qualityY = -2, strengthX = -12, selectX = 3, selectY = -1, selectWidth = 83, selectHeight = 100 ,xinyunX = 3, xinyunY = 5},
        [EEquipSlotType.Necklace] = { bg = "img_player_necklace", otherBg = "img_player_necklace_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 56, height = 56, x = 103, y = -15, qualityX = 0, qualityY = 0, strengthX = -3, selectX = 0, selectY = 0, selectWidth = 54, selectHeight = 50,xinyunX = 3, xinyunY = 5 },
        [EEquipSlotType.LeftEarring] = { bg = "img_player_earrings", otherBg = "img_player_earrings_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 56, height = 56, x = 103, y = -120, qualityX = 0, qualityY = 0, strengthX = -3, selectX = 0, selectY = 0, selectWidth = 54, selectHeight = 50 ,xinyunX = 3, xinyunY = 5},
        [EEquipSlotType.RightEarring] = { bg = "img_player_earrings", otherBg = "img_player_earrings_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 56, height = 56, x = 252, y = -120, qualityX = 0, qualityY = 0, strengthX = -3, selectX = 0, selectY = 0, selectWidth = 51, selectHeight = 50,xinyunX = 3, xinyunY = 5 },
        [EEquipSlotType.LeftRing] = { bg = "img_player_ring", otherBg = "img_player_ring_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 56, height = 56, x = 103, y = -335, qualityX = 0, qualityY = 0, strengthX = -3, selectX = 0, selectY = 0, selectWidth = 54, selectHeight = 50,xinyunX = 3, xinyunY = 5 },
        [EEquipSlotType.RightRing] = { bg = "img_player_ring", otherBg = "img_player_ring_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 56, height = 56, x = 252, y = -335, qualityX = 0, qualityY = 0, strengthX = -3, selectX = 3, selectY = -1, selectWidth = 50, selectHeight = 48 ,xinyunX = 3, xinyunY = 5},
        [EEquipSlotType.Guard] = { bg = "img_player_pet", otherBg = "img_player_pet_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 88, height = 105, x = 24, y = -15, qualityX = 3, qualityY = -2, strengthX = -12, selectX = 3, selectY = -2, selectWidth = 84, selectHeight = 100,xinyunX = 3, xinyunY = 5 },        
        [EEquipSlotType.Wing] = { bg = "img_player_wing", otherBg = "img_player_wing_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 88, height = 105, x = 300, y = -15, qualityX = 3, qualityY = -2, strengthX = -12, selectX = 3, selectY = -2, selectWidth = 82, selectHeight = 100,xinyunX = 3, xinyunY = 5 },
        [EEquipSlotType.PriestHawk] = { bg = "img_player_washi", otherBg = "img_player_washi_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 96, height = 116, x = 330, y = -157, qualityX = 3, qualityY = -2, strengthX = -10 ,xinyunX = 3, xinyunY = 5 },
        [EEquipSlotType.ArchangelWeapon] = { bg = "img_player_weapon1", otherBg = "img_player_weapon1_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 97, height = 228, x = 28, y = -120, qualityX = 3, qualityY = -3, strengthX = -16, selectX = 5, selectY = -2, selectWidth = 78, selectHeight = 211,xinyunX = 3, xinyunY = 5 },
        [EEquipSlotType.ArchangelOffHandWeapon] = { bg = "img_player_weapon2", otherBg = "img_player_weapon2_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 98, height = 228, x = 328, qualityX = 5.2, qualityY = -2.8, y = -120, strengthX = -10, selectX = 8.5, selectY = -5, selectWidth = 80, selectHeight = 210 ,xinyunX = 3, xinyunY = 5},
        [EEquipSlotType.ArchangelHelmet] = { bg = "img_player_helm", otherBg = "img_player_helm_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 124, height = 115, x = 166, y = -15, qualityX = 7, qualityY = -2, strengthX = -12, selectX = 7, selectY = -2, selectWidth = 107, selectHeight = 102 ,xinyunX = 3, xinyunY = 5},
        [EEquipSlotType.ArchangelArmor] = { bg = "img_player_armor", otherBg = "img_player_armor_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 124, height = 228, x = 166, y = -120, qualityX = 7, qualityY = -2, strengthX = -12, selectX = 7, selectY = -3, selectWidth = 105, selectHeight = 210 ,xinyunX = 3, xinyunY = 5},
        [EEquipSlotType.ArchangelGlove] = { bg = "img_player_glove", otherBg = "img_player_glove_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 96, height = 116, x = 30, y = -335, qualityX = 3, qualityY = -2, strengthX = -12, selectX = 2, selectY = -2, selectWidth = 86, selectHeight = 101 ,xinyunX = 3, xinyunY = 5},
        [EEquipSlotType.ArchangelPant] = { bg = "img_player_pant", otherBg = "img_player_pant_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 124, height = 115, x = 166, y = -335, qualityX = 7, qualityY = -2, strengthX = -12, selectX = 7, selectY = -3, selectWidth = 105, selectHeight = 100 ,xinyunX = 3, xinyunY = 5},
        [EEquipSlotType.ArchangelBoot] = { bg = "img_player_boot", otherBg = "img_player_boot_select", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 96, height = 116, x = 330, y = -335, qualityX = 3, qualityY = -2, strengthX = -12, selectX = 3, selectY = -3, selectWidth = 83, selectHeight = 100,xinyunX = 3, xinyunY = 5 },
        [EEquipSlotType.Mount] = { bg = "img_mount", otherBg = "img_mount_noNull", bgAtlas = "Atlas/FG_BagEquip.spriteatlas", width = 56, height = 56, x = 252, y = -15, qualityX = 3, qualityY = -2, strengthX = -12, selectX = 0, selectY = 0, selectWidth = 54, selectHeight = 50,xinyunX = 3, xinyunY = 5 },
    }
    self.specialData = { bg = "img_player_gemstone", width = 96, height = 116, x = 330, y = -270, qualityX = 3, qualityY = -2, strengthX = -10 ,xinyunX = 3, xinyunY = 5}
    if not self.args then
        self.args = {}
    end
    local x = self.args.x or -400
    local y = self.args.y or 0
    local z = self.args.z or 0
    --local wearArchangeX = GUI:getPositionX(self.view.WearArchange)
    --local wearArchangeOffest = wearArchangeX - GUI:getPosition(self.view.UIEquipPanel_Root)
    GUI:setPosition(self.view.UIEquipPanel_Root, x, y)
    GUI:setPositionZ(self.view.UIEquipPanel_Root, z)
    --GUI:setPositionX(self.view.WearArchange,x + wearArchangeOffest)
    --self.relatePanel = self.args.relatePanel
    if self.args and self.args.zindex then
        GUI:SetZIndex(self.view.root,self.args.zindex)
    end
    ---是否隐藏主界面
    self.isHideMainUI = self.args.isHideMainUI
    self.hideTips = self.args.hideTips
    self.closeCallBack = self.args.callBack
    self.closeCallBackData = self.args.callBackData
    --是否是查看其他玩家装备
    self.isOtherPlayer = self.args.isOther
    self.otherRid = self.args.rid
    self.forgeGroupType = self.args.forgeGroupType
    self.otherEquips = nil
    if self.isOtherPlayer then
        EquipFunc.otherRid = tostring(self.otherRid)

        SL.Friend:ReqOtherRoleInfoMessage(self.otherRid, 4)
    end
    self:SetBaseWearBar()
    if self.selectItem then
        self.selectItem:SetSelect(false)
        self.selectItem = nil
    end

    self.updateTime = 0
end

function this:SetBaseWearBar(career)
    --基础穿戴栏
    local wearBars
    if self.isOtherPlayer and career then
        wearBars = SL:GeCareerBaseWearBar(career)
    else
        wearBars = SL:GeCareerBaseWearBar(SL:MeData_GetCareer())
    end
    --[[    self.baseWearBar = EEquipWearBarType.BaseEquip
        if wearBars and wearBars[1] then
            self.baseWearBar = wearBars[1]
        end]]
    self.baseWearBar = wearBars
end

function this:Show(...)
    self.relatePanel = self.args.relatePanel
end
---创建或者刷新界面数据时调用
function this:Refresh()
    if not self.isOtherPlayer then
        ---打开自己的装备界面的时候如果没有萤石数据的时候请求一下
        if not InfoManager.gemSlateInfo.AllSchemeData then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SCHEME_INFO)
        end
        self:UpdatePanel()
    else
        --SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_OTHER_GEM_EQUIP_INFO, { rid = self.otherRid })--请求一下别的玩家的萤石信息
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
        self.selectIndex = nil
    else
        self.selectIndex = index
    end
end

function this:SetUnselectIndex(index)
    index = self.selectIndex and self.selectIndex or index
    local item = self.slotToGrid[index]
    if item then
        item:SetSelect(false)
    end
end

function this:CanShowFashion()
    local ui = GUI:GetUI("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
    return ui == nil and SL:CheckOwnFashion()
end

---@刷新界面
function this:UpdatePanel()
    --拥有时装时才显示切换时装穿戴栏按钮
    local ownFashion
    --到达指定等级才显示大天使穿戴栏按钮
    local archange = false
    if self.isOtherPlayer then
        --查看他人装备只查看基础穿戴栏装备
        ownFashion = false
        archange = true
    else

        ownFashion = SL:CheckOwnFashion()
        self:UpdateMoney()
    end
    local global = SL:GetConfig("cfg_global", 22002, "id")
    if global and SL:GetMetaValue("LEVEL") >= tonumber(global.value) then
        archange = true
    end
    local ui = GUI:GetUI("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
    local archangeUI = GUI:GetUI("dev/outui/Archangel/Panel/KLArchangelGroup/KLArchangelGroupPanel")
    if archangeUI then
        ownFashion = false
        archange = false
    end
    local isShowFashion = ownFashion and ui == nil
    local isShowArchange = archange and ui == nil
    GUI:setVisible(self.view.wearBarChange, isShowFashion)
    GUI:setVisible(self.view.WearArchange, false)
    local wearBar = self.args and self.args.wearBar or self.baseWearBar
    if not isShowFashion then
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
        if wearBarType == self.baseWearBar then
            local icon = SL:GetConfig("cfg_wearing_bar", EEquipWearBarType.Archange).icon
            GUI:Image_loadTexture(self.view.WearArchange, icon, "Atlas/UIzhuangbeixt.spriteatlas")
        else
            local icon = SL:GetConfig("cfg_wearing_bar", self.baseWearBar).icon
            GUI:Image_loadTexture(self.view.WearArchange, icon, "Atlas/UIzhuangbeixt.spriteatlas")
        end
    else
        --自己装备
        equips = SL:GetWearBarsData(wearBarType)

        local show = false
        if wearBarType == self.baseWearBar then
            show = true
            local icon = SL:GetConfig("cfg_wearing_bar", EEquipWearBarType.Archange).icon
            local icon2 = SL:GetConfig("cfg_wearing_bar", EEquipWearBarType.ShengDaoShi).icon
            GUI:Image_loadTexture(self.view.WearArchange, icon, "Atlas/UIzhuangbeixt.spriteatlas")
            GUI:Image_loadTexture(self.view.wearBarChange, icon2, "Atlas/UIzhuangbeixt.spriteatlas")

        elseif wearBarType == EEquipWearBarType.Archange then
            show = true
            local icon = SL:GetConfig("cfg_wearing_bar", self.baseWearBar).icon
            local icon2 = SL:GetConfig("cfg_wearing_bar", EEquipWearBarType.ShengDaoShi).icon
            GUI:Image_loadTexture(self.view.wearBarChange, icon2, "Atlas/UIzhuangbeixt.spriteatlas")
            GUI:Image_loadTexture(self.view.WearArchange, icon, "Atlas/UIzhuangbeixt.spriteatlas")
        else
            local icon = SL:GetConfig("cfg_wearing_bar", EEquipWearBarType.Archange).icon
            local icon2 = SL:GetConfig("cfg_wearing_bar", self.baseWearBar).icon
            GUI:Image_loadTexture(self.view.wearBarChange, icon2, "Atlas/UIzhuangbeixt.spriteatlas")
            GUI:Image_loadTexture(self.view.WearArchange, icon, "Atlas/UIzhuangbeixt.spriteatlas")
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
    --- 隐藏坐骑栏
    if self.args and self.args.hideMount then
        table.insert(noShowSlot, EEquipSlotType.Mount)
    end
    ---@type cfg_wearing_bar_column
    local tbl = SL:GetConfig("cfg_wearing_bar", wearBarType)

    if wearBarType == 12 then --圣导师专属装备栏
        self.gridData[EEquipSlotType.OffHandWeapon].height =110
        self.gridData[EEquipSlotType.OffHandWeapon].selectHeight =110
        self.gridData[EEquipSlotType.OffHandWeapon].y = -267

        self.gridData[EEquipSlotType.ArchangelOffHandWeapon].height =110
        self.gridData[EEquipSlotType.ArchangelOffHandWeapon].selectHeight =110
        self.gridData[EEquipSlotType.ArchangelOffHandWeapon].y = -267
        
    end

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
                    local itemCfgId = self.equips[v] and self.equips[v].cfgId or nil
                    local args = { equipPos = v, isOtherPlayer = self.isOtherPlayer, isEquipGrid = true, item = nil, default = default or {}, x = default.x, y = default.y, click = self.OnGridItemClick, callBackUI = self, mscaleType = EEquipScaleType.ForgeEquipScale ,is_wear_eauip=true}
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
                        elseif v== EEquipSlotType.Necklace or v == EEquipSlotType.LeftEarring or v == EEquipSlotType.RightEarring or v == EEquipSlotType.LeftRing or v == EEquipSlotType.RightRing then
                            -- Glove和Pant和右侧的装备栏贴的太近 需要调下层级（主要是加了红点会被遮挡）
                            GUI:SetAsLastSibling(self.slotToGrid[v].view.root)
                        end
                        if self.selectIndex == EEquipSlotType.TwoHandWeapon and v == 1 then
                            ---双手武器穿在1位置  需要选中
                            win:SetSelect(true)
                            self.selectItem = win
                        end
                        if self.selectIndex == v then
                            win:SetSelect(true)
                            self.selectItem = win
                        end
                        if k == self.endEquipSlotTypeListIndex then
                            self.isUpdateEquips = false
                        end
                        GUI:SetZIndex(win.view.equipInfo,205)
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
                    GUI:SetZIndex(self.slotToGrid[v].view.equipInfo,205)
                end

            else
                if self.slotToGrid[v] then
                    GUI:setVisible(self.slotToGrid[v].view.root, false)
                end
            end
        end
    end

end
---@param view KLBagItemItemView
--装备穿戴栏点击回调
function this:OnGridItemClick(view, item)
    if not self.hideTips and item then
        local bag = self.isOtherPlayer and "otherEquip" or "equip"
        SL:OpenTips(bag, item.cfgId, item.id, nil, nil, { otherRid = self.otherRid })
    end
    if self.hideTips then
        if GUI:getVisible(view.selectImg) then
            local ui = GUI:GetUI("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
            local archangeUI = GUI:GetUI("dev/outui/Archangel/Panel/KLArchangelGroup/KLArchangelGroupPanel")
            if ui or archangeUI then
                local bag = self.isOtherPlayer and "otherEquip" or "equip"
                SL:OpenTips(bag, item.cfgId, item.id, nil, nil, { hideBtn = true, otherRid = self.otherRid })
            end

        end
    end
    if not self.isOtherPlayer then
        for pos, v in pairs(self.slotToGrid) do
            if v.view and v.view == view then
                if not self.hideTips and item == nil and jewelryDefaultId[pos] then
                    --SL:CommonItemGetPath("", jewelryDefaultId[pos])
                    SL:OpenTips("", jewelryDefaultId[pos])
                end
                SL:onLUAEvent(LUA_EVENT_EQUIP_GRID_CLICK, pos, self.wearBar)
                break
            end
        end
    end
end

---刷新所有位置上的装备（主要是为了显示红点 对应面板上的事件调用即可）
function this:UpdateAllItem()
    for v, equip in pairs(self.equips) do
        if self.slotToGrid[v] then
            self.slotToGrid[v]:SetItem(equip, self.forgeGroupType)
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
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_INFO, self.ResOtherRoleInfoMessage, self)
    GUI:AddOnClickEvent(self.view.WearArchange, self, self.WearArchangeOnClick)
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
    if table.isNullOrEmpty(data) then
        return
    end

    if data.WearBar ~= self.wearBar then

        -- 基础装备逻辑
        if data.WearBar == EEquipWearBarType.BaseEquip then
            self:SetSelfWearBarType(self.baseWearBar)
            return
        end

        --跳转到穿戴装备的穿戴栏
        if self.wearBarItems[data.WearBar] then
            self.wearBarItems[data.WearBar]:SetSelectedIgnoreIsOn()
            --跳转到时装穿戴栏需要检测一下每个时装穿戴栏的显示状况
            --只有拥有对应时装才显示
            local tbl = SL:GetConfigTable("cfg_wearing_bar")
            ---@param v cfg_wearing_bar_column
            for k, v in pairs(tbl) do
                if self.wearBarItems[v.id] then
                    --判断有没有该穿戴栏的装备数据包括背包里
                    if SL:CheckOwnTargetWearbarFashion(v.id) then
                        GUI:setVisible(self.wearBarItems[v.id].view.root, true)
                    else
                        GUI:setVisible(self.wearBarItems[v.id].view.root, false)
                    end
                end
            end
            GUI:setVisible(self.view.wearBarChange, self:CanShowFashion())
        end
        if data.WearBar == EEquipWearBarType.Archange then
            -- 跳转到大天使穿戴栏
            local archange = false
            local global = SL:GetConfig("cfg_global", 22002, "id")
            if global and SL:GetMetaValue("LEVEL") >= tonumber(global.value) then
                archange = true
            end
            local bagUI = GUI:GetUI("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
            if archange and bagUI then
                self:SetSelfWearBarType(EEquipWearBarType.Archange)
            end
        end
    else
        self.equips = SL:GetWearBarsData(self.wearBar)
        local pos = data.Where
        if self.slotToGrid[pos] then
            self.slotToGrid[pos]:SetItem(self.equips[pos], self.forgeGroupType)
        end
        local isShowFashion = self:CanShowFashion()
        GUI:setVisible(self.view.wearBarChange, isShowFashion)
        if self.wearBar == EEquipWearBarType.Angel then
            if not isShowFashion then
                self:SetSelfWearBarType(self.baseWearBar)
            end
        end
    end

end

function this:WearBarChangeOnClick()
    if self.wearBar == self.baseWearBar or self.wearBar == EEquipWearBarType.Archange then
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
                    GUI:setVisible(self.wearBarItems[v.id].view.root, true)
                else
                    GUI:setVisible(self.wearBarItems[v.id].view.root, false)
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

function this:WearArchangeOnClick()
    if self.wearBar == self.baseWearBar or self.wearBar ~= EEquipWearBarType.Archange then
        self:SetSelfWearBarType(EEquipWearBarType.Archange)
    else
        self:SetSelfWearBarType(self.baseWearBar)
    end
end

function this:CloseOnClick()
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
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
end

function this:Close()
    self.wearBar = nil
    self.closeCallBack = nil
    if self.delayUpdt then
        SL:UnSchedule(self.delayUpdt)
        self.delayUpdt = nil
    end
end

return this
