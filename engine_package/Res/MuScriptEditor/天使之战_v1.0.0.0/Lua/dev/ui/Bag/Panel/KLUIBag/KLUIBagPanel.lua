---@class KLUIBagPanel:UIKmlLuaPanelBase
---@field view KLUIBagPanelView
---@field bagInfoChangeCallBack function 背包在加载的过程中有背包物品变化，会调用此回调
---@field fashionDatas cfg_FashionGuide_column[]
local KLUIBagPanel = class(UIKmlLuaPanelBase)
local this = KLUIBagPanel

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
    [EEquipSlotType.FashionRightEarring] = EEquipSlotType.RightEarring,
    [EEquipSlotType.FashionLeftRing] = EEquipSlotType.LeftRing,
    [EEquipSlotType.FashionRightRing] = EEquipSlotType.RightRing,
    [EEquipSlotType.ArchangelTwoHandWeapon] = EEquipSlotType.ArchangelWeapon
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

local gridData = {
    [EEquipSlotType.Weapon] = { bg = "img_player_weapon1", otherBg = "img_player_weapon1_noNull", width = 72, height = 111, x = 90, y = -19, qualityX = 3, qualityY = -2, strengthX = -4, selectX = 5, selectY = -2, selectWidth = 78, selectHeight = 211 ,xinyunX = 3, xinyunY = 5},
    [EEquipSlotType.OffHandWeapon] = { bg = "img_player_weapon2", otherBg = "img_player_weapon2_noNull", width = 72, height = 111, x = 370, y = -19, qualityX =3, qualityY = -2, strengthX = -4, selectX = 8.5, selectY = -5, selectWidth = 80, selectHeight = 210 ,xinyunX = 3, xinyunY = 5},
    [EEquipSlotType.Helmet] = { bg = "img_player_helm", otherBg = "img_player_helm_noNull", width = 72, height = 72, x = 229, y = 53, qualityX = 3, qualityY = -2, strengthX = -4, selectX = 7, selectY = -2, selectWidth = 107, selectHeight = 102 ,xinyunX = 3, xinyunY = 5},
    [EEquipSlotType.Armor] = { bg = "img_player_armor", otherBg = "img_player_armor_noNull", width = 72, height = 111, x = 229, y = -19, qualityX = 3, qualityY = -2, strengthX = -4, selectX = 7, selectY = -3, selectWidth = 105, selectHeight = 210 ,xinyunX = 3, xinyunY = 5},
    [EEquipSlotType.Glove] = { bg = "img_player_glove", otherBg = "img_player_glove_noNull", width = 72, height = 72, x = 90, y = -129, qualityX = 3, qualityY = -2, strengthX = -4, selectX = 2, selectY = -2, selectWidth = 86, selectHeight = 101 ,xinyunX = 3, xinyunY = 5},
    [EEquipSlotType.Pant] = { bg = "img_player_pant", otherBg = "img_player_pant_noNull", width = 72, height = 72, x = 229, y = -129, qualityX = 3, qualityY = -2, strengthX = -4, selectX = 7, selectY = -3, selectWidth = 105, selectHeight = 100 ,xinyunX = 3, xinyunY = 5},
    [EEquipSlotType.Boot] = { bg = "img_player_boot", otherBg = "img_player_boot_noNull", width = 72, height = 72, x = 370, y = -129, qualityX = 3, qualityY = -2, strengthX = -4, selectX = 3, selectY = -3, selectWidth = 83, selectHeight = 100 ,xinyunX = 3, xinyunY = 5},    
    [EEquipSlotType.PriestHawk] = { bg = "img_player_washi", otherBg = "img_player_washi", width = 45, height = 45, x = 169, y = 70, qualityX = 0, qualityY = 0, strengthX = -3, selectX = 0, selectY = 0, selectWidth = 54, selectHeight = 50 ,xinyunX = 3, xinyunY = 5},
    [EEquipSlotType.Banner] = { bg = "img_player_banner", otherBg = "img_player_banner_noNull", width = 42, height = 42, x = 169, y = 25, qualityX = 0, qualityY = 0, strengthX = -3, selectX = 0, selectY = 0, selectWidth = 54, selectHeight = 50 ,xinyunX = 3, xinyunY = 5},
    [EEquipSlotType.Necklace] = { bg = "img_player_necklace", otherBg = "img_player_necklace_noNull", width = 51, height = 51, x = 169, y = -20, qualityX = 0, qualityY = 0, strengthX = -3, selectX = 0, selectY = 0, selectWidth = 54, selectHeight = 50 ,xinyunX = 3, xinyunY = 5},
    [EEquipSlotType.LeftEarring] = { bg = "img_player_Earring", otherBg = "img_player_Earring", width = 51, height = 51, x = 169, y = -79, qualityX = 0, qualityY = 0, strengthX = -3, selectX = 0, selectY = 0, selectWidth = 54, selectHeight = 50 ,xinyunX = 3, xinyunY = 5},
    [EEquipSlotType.LeftRing] = { bg = "img_player_ring", otherBg = "img_player_ring_noNull", width = 51, height = 51, x = 169, y = -129, qualityX = 0, qualityY = 0, strengthX = -3, selectX = 0, selectY = 0, selectWidth = 54, selectHeight = 50 ,xinyunX = 3, xinyunY = 5},
    [EEquipSlotType.Mount] = { bg = "img_mount", otherBg = "img_mount_noNull", width = 51, height = 51,x = 312,  y = -20, qualityX = 3, qualityY = -2, strengthX = -4, selectX = 3, selectY = -2, selectWidth = 84, selectHeight = 100 ,xinyunX = 3, xinyunY = 5},
    [EEquipSlotType.RightEarring] = { bg = "img_player_Earring", otherBg = "img_player_Earring", width = 51, height = 51, x = 312, y = -79, qualityX = 0, qualityY = 0, strengthX = -3, selectX = 3, selectY = -1, selectWidth = 50, selectHeight = 48 ,xinyunX = 3, xinyunY = 5},
    [EEquipSlotType.RightRing] = { bg = "img_player_ring", otherBg = "img_player_ring_noNull", width = 51, height = 51, x = 312, y = -129, qualityX = 0, qualityY = 0, strengthX = -3, selectX = 3, selectY = -1, selectWidth = 50, selectHeight = 48 ,xinyunX = 3, xinyunY = 5},
    [EEquipSlotType.Guard] = { bg = "img_player_pet", otherBg = "img_player_pet_noNull", width = 72, height = 72, x = 90, y = 52, qualityX = 3, qualityY = -2, strengthX = -4, selectX = 3, selectY = -2, selectWidth = 84, selectHeight = 100 ,xinyunX = 3, xinyunY = 5},
    [EEquipSlotType.Wing] = { bg = "img_player_wing", otherBg = "img_player_wing_noNull", width = 110, height = 72, x = 331, y = 52, qualityX = 3, qualityY = -2, strengthX = -4, selectX = 3, selectY = -2, selectWidth = 82, selectHeight = 100,xinyunX = 3, xinyunY = 5 },
    
}
--EEquipSlotType.PriestHawk, EEquipSlotType.Banner,
local baseWearBarShowSlot = {
    EEquipSlotType.Weapon, EEquipSlotType.OffHandWeapon, EEquipSlotType.Helmet, EEquipSlotType.Armor, EEquipSlotType.Glove, EEquipSlotType.Pant,
    EEquipSlotType.PriestHawk, EEquipSlotType.Banner,
    EEquipSlotType.Boot, EEquipSlotType.Necklace, EEquipSlotType.LeftEarring, EEquipSlotType.RightEarring, EEquipSlotType.LeftRing, EEquipSlotType.RightRing, EEquipSlotType.Guard, EEquipSlotType.Wing, EEquipSlotType.TwoHandWeapon,EEquipSlotType.Mount
}

local fashionWearBarShowSlot = {
    EEquipSlotType.FashionWeapon, EEquipSlotType.FashionOffHandWeapon, EEquipSlotType.FashionHelmet, EEquipSlotType.FashionArmor, EEquipSlotType.FashionGlove, EEquipSlotType.FashionPant,
    EEquipSlotType.FashionBoot, EEquipSlotType.FashionNecklace, EEquipSlotType.FashionLeftEarring, EEquipSlotType.FashionRightEarring, EEquipSlotType.FashionLeftRing, EEquipSlotType.FashionRightRing, EEquipSlotType.FashionTwoHandWeapon, EEquipSlotType.FashionGuard
}
---创建时调用一次
function KLUIBagPanel:Init()
    if not self.args then
        self.args = {}
    end
    self:InitData(self.args)
    local bag_info = string.split(SL:GetConfig("cfg_global", 6).value, '#')
    self.money_info = ToolFunc.AnalysisStr(SL:GetConfig("cfg_global", 640001).value)
    local forbidNum = 0
    local increaseRow, needLockRow
    self.JumpSelectId = nil
    if self.args then
        for i, v in pairs(self.args) do
            if string.split(i, "_")[1] == "JumpSelectItem" then
                if SL:GetBagItemCount(tonumber(v)) > 0 then
                    self.JumpSelectId = tonumber(v)
                end
            end
        end
    end
    self.slotToGrid = {}
    self.slotRectToGrid = {}
    self.baseWearBar = SL:GeCareerBaseWearBar(SL:MeData_GetCareer())
    self.hideTips = self.args.hideTips
    local global = SL:GetConfig("cfg_global", 320016)
    local split = string.split(global.value, "#")
    self.fixCostId = tonumber(split[1])
    self.fixCostNum = tonumber(split[2])
    ---特权暂时没这个功能，先注释，别删
    -- if #bag_info >= 5 then
    --     increaseRow, needLockRow = PrivilegeCardManager.GetBagCanShowRow(tonumber(bag_info[1]))
    --     self.maxHor = tonumber(bag_info[1]) + increaseRow
    --     self.maxVet = tonumber(bag_info[2])
    --     forbidNum = PrivilegeCardManager.GetBagSiftLockGridNum()
    -- else
    self.maxHor = tonumber(bag_info[1])
    self.maxVet = tonumber(bag_info[2])
    self.isSuit = self.args.isSuit
    self.fashionDatas = EquipFunc.GetMeFashionEquipCfgs()
    local function openBag()
        ---@type KLUIBagTileScrollViewItem
        ---@param bagTileScrollView KLUIBagTileScrollViewItem
        GUI:UIPanel_Open("dev/ui/Common/Item/KLUIBagTileScrollView/KLUIBagTileScrollViewItem", self.view.root, self,
                {
                    itemList = self:GetBagItemList(),
                    id = EBagTileScrollViewId.Bag,
                    forbidCount = SL:GetMetaValue("BAG_FORBID_COUNT") - forbidNum,
                    hor = self.maxHor,
                    vet = self.maxVet,
                    forbidClickCallback = self.forbidClick,
                    dragEndCallback = self.dragEnd,
                    JumpSelectId = self.JumpSelectId,
                    parent = self,
                    contentScale = 1.31,
                    contentH = 295,
                    contentW = 357,
                    x=-49,
                    y=-65,
                    filterTagList = self.filterTagList or {},
                },true,function(bagTileScrollView)
                    self.bagTileScrollView = bagTileScrollView
                    self.bagTileScrollView:ResetPos()
                    self.bagTileScrollView:RefreshInfo()
                    if needLockRow and needLockRow > 0 then
                        self.bagTileScrollView:RefreshRedGrid(needLockRow * self.maxVet)
                    end
                    if self.bagInfoChangeCallBack then
                        self.bagInfoChangeCallBack()
                        self.bagInfoChangeCallBack = nil
                    end
                    if self.filterTagList then
                        self.bagTileScrollView:RefreshFilterTagList(self.filterTagList)
                    end
                end)
    end
    
    if SL:GetIsWebGL() then
        openBag()
    else
        if not self.bagTileScrollView then
            openBag()
        else
            --预加载打开刷新背包
            local itemList = self:GetBagItemList()
            local forbidCount = SL:GetMetaValue("BAG_FORBID_COUNT") - forbidNum
            self.bagTileScrollView.itemList = itemList
            self.bagTileScrollView.forbidCount = forbidCount
            self.bagTileScrollView.hor = self.maxHor
            self.bagTileScrollView.vet = self.maxVet
            self.bagTileScrollView.id = EBagTileScrollViewId.Bag
            self.bagTileScrollView.forbidClickCallback = self.forbidClick
            self.bagTileScrollView.dragEndCallback = self.dragEnd
            self.bagTileScrollView.JumpSelectId = self.JumpSelectId
            self.bagTileScrollView.parent = self
            
            self.bagTileScrollView:RefreshForbidGrid(forbidCount)
            self.bagTileScrollView:ResetPos()
            self.bagTileScrollView:RefreshItemByItem(itemList,function()
                ---@param v KLBagItemItem
                for i, v in pairs(self.bagTileScrollView.indexToItem) do
                    v:RegistEvents()
                end
            end)
            --self.bagTileScrollView:RefreshInfo() --RefreshItemByItem有刷过，先注释
            if needLockRow and needLockRow > 0 then
                self.bagTileScrollView:RefreshRedGrid(needLockRow * self.maxVet)
            end
        end
    end
    
    --EquipFunc:ReplaceEquipBagButton({self.view.person_shop_btn,self.view.storage_btn,self.view.recycle_btn,self.view.tidy_btn})
    self.inTidy= false
    GUI:DataListInitData(self.view.datalist_suit, function()
        return table.count(self.fashionDatas)
    end, function()
        
    end, function()
        
    end, function(realIndex)
        local btn_suit = GUI:GetChildControl(self.view.datalist_suit, realIndex, 'btn_suit')
        local btn_suit_select = GUI:GetChildControl(self.view.datalist_suit, realIndex, 'btn_suit_select')
        GUI:setVisible(btn_suit_select, false)
        local data = self.fashionDatas[realIndex + 1]
        if self.wearBar == data.wearing then
            GUI:setVisible(btn_suit_select, true)
            self.lastIcon = btn_suit_select
        else
            GUI:setVisible(btn_suit_select, false)
        end
        GUI:Image_loadTexture(btn_suit, data.icon.."_01", "Atlas/UIzhuangbeixt.spriteatlas")
        GUI:Image_loadTexture(btn_suit_select, data.icon.."_02" , "Atlas/UIzhuangbeixt.spriteatlas")
        GUI:SetImageNativeSize(btn_suit)
        GUI:SetImageNativeSize(btn_suit_select)
        GUI:AddOnClickEvent(btn_suit, self, self.SuitOnClick, {data = data, icon = btn_suit_select})
    end)
    GUI:DataListInitData(self.view.datalist_atts, function()
        return table.count(self.attTextList)
    end, function()

    end, function()

    end, function(realIndex)
        local text = GUI:GetChildControl(self.view.datalist_atts, realIndex, 'text')
        
        local str = self.attTextList[realIndex + 1]
        GUI:Text_setString(text, str)
    end)
    GUI:setScaleY(self.view.RawImage, 1)
end

function this:SuitOnClick(a, data)
    self:SetWearBar(data.data.wearing, data.data)
    if self.lastIcon then
        GUI:setVisible(self.lastIcon, false)
    end
    GUI:setVisible(data.icon, true)
    self.lastIcon = data.icon
end
---初始化数据
function KLUIBagPanel:InitData(data)
    self.x = (data and tonumber(data.x)) or 0
    self.y = (data and tonumber(data.y)) or 0
    self.bagType = (data and data.bagType) or EBagShowType.Bag
end

function KLUIBagPanel:Show(...)
    SL.HideMainPanel()
end

-- 引导模块高亮特定道具
function this:GuideToShowItem(cfgId)
    if self.bagType == EBagShowType.Bag then
        self.bagTileScrollView:SelectItem(cfgId)
    end
end

---创建或者刷新界面数据时调用
function KLUIBagPanel:Refresh()
    local x = self.x
    local y = self.y
    GUI:setPosition(self.view.root, x, y)
    if self.args and self.args.JumpType then
        ---跳转用
        if self.args.JumpType == 1 then
            self:recycle_btn()
        end
    end
    GUI:setVisible(self.view.btn_emptyBg, false)
    local showSlot
    if self.isSuit then
        showSlot = fashionWearBarShowSlot
        GUI:setVisible(self.view.MoneyRoot, false)
        GUI:setVisible(self.view.FashionRoot, true)
        GUI:setVisible(self.view.btn_go_model, true)
        --GUI:setVisible(self.view.btn_fashion_map, true)
        GUI:setVisible(self.view.btn_attSuits, false)
        GUI:setVisible(self.view.btn_attGems, false)
        self.wearBar = self.fashionDatas[1].wearing
        GUI:DataListUpdateData(self.view.datalist_suit)
        GUI:Text_setString(self.view.title, "时 装")
        GUI:setPositionY(self.view.title, 346)
        GUI:UIPanel_Open("dev/outui/FashionEquip/Panel/KLFashionEquipMap/KLFashionEquipMapPanel")
    else
        showSlot = baseWearBarShowSlot
        self.wearBar = self.baseWearBar
        GUI:setVisible(self.view.MoneyRoot, true)
        GUI:setVisible(self.view.FashionRoot, false)
        GUI:setVisible(self.view.btn_go_model, false)
        --GUI:setVisible(self.view.btn_fashion_map, false)
        GUI:setVisible(self.view.btn_attSuits, true)
        GUI:setVisible(self.view.btn_attGems, true)
        --GUI:Text_setString(self.view.title, "装 备")
        GUI:Text_setString(self.view.title, "Equip")
        GUI:setPositionY(self.view.title, 350)
        self:UpdateMoney()
    end
    GUI:setVisible(self.view.btn_strengthenAtts, not self.isSuit)
    self.showSlot = showSlot
    self:UpdateEquips()
    self:UpdateSuitColor()
    self:UpdateStrengthMasterColor()

    if self.args and self.args.showFixLight then
        self.args.showFixLight = false
        --GUI:setPositionX(self.view.obj_highLight, -1)
        GUI:setVisible(self.view.obj_highLight, true)
    else
        GUI:setVisible(self.view.obj_highLight, false)
    end
end

---注册UI事件和服务器消息
function KLUIBagPanel:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.closeBtn)
    SL:RegisterLUAEvent(Event.BagInfo_Change, self.BagInfo_Change, self)
    GUI:AddOnClickEvent(self.view.btn_storage, self, self.storage_btn)
    GUI:AddOnClickEvent(self.view.btn_sell, self, self.recycle_btn)
    GUI:AddOnClickEvent(self.view.btn_arrange, self, self.tidy_btn)
    GUI:AddOnClickEvent(self.view.btn_fix, self, self.FixEquipClick)
    GUI:AddOnClickEvent(self.view.btn_shop, self, self.PillNoEnough)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_UNLOCK, self.LUA_EVENT_BAG_UNLOCK, self)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_SORT, self.LUA_EVENT_BAG_SORT, self)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, self.LUA_EVENT_PLAYER_EQUIP_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.UpdateMoney, self)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, self.EquipChange, self)
    
    GUI:AddOnClickEvent(self.view.btn_gold, self, self.ShowMoneyTips, self.money_info[1][2])
    GUI:AddOnClickEvent(self.view.btn_diamond, self, self.ShowMoneyTips, self.money_info[2][2])
    GUI:AddOnClickEvent(self.view.btn_ruibi, self, self.ShowMoneyTips, self.money_info[3][2])

    GUI:AddOnClickEvent(self.view.btn_go_model, self, self.GoDressPage)
    --GUI:AddOnClickEvent(self.view.btn_fashion_map, self, self.GoMapPage)
    GUI:AddOnClickEvent(self.view.btn_attSuits, self, self.ShowSuitAtts)
    GUI:AddOnClickEvent(self.view.btn_emptyBg, self, self.EmptyBgClick)
    GUI:AddOnClickEvent(self.view.btn_strengthenAtts, self, self.ShowStrengthAtts)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_DURABILITY_CHANGE, self.RES_DURABILITY_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_TAKE_ON_EQUIP, self.ResPutOnTheEquipMessage, self)
    SL:RegisterLUAEvent(LUA_EVENT_TAKE_OFF_EQUIP, self.ResTakeOffEquipMessage, self)
end

---@param message EquipProto.PutOnTheEquipRes
function this:ResPutOnTheEquipMessage(_, message)
    local cfgId = message.equip.cfgId
    ---@type cfg_item_column
    local cfg =  SL:GetConfig("cfg_item",cfgId)
    if cfg.subType == 10001 then
        local isSafe = SL:GetMetaValue(EMetaVarGetKey.IN_SAFE_AREA)
        if not isSafe then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SHOW_OR_HIDDEN_MOUNT,1)
        end
        SL:onLUAEvent(LUA_MOUNT_SHOW_CHANGE)
    end
end

function this:ResTakeOffEquipMessage(_, message)
    local cfgId = message.equip.cfgId
    ---@type cfg_item_column
    local cfg =  SL:GetConfig("cfg_item",cfgId)
    if cfg.subType == 10001 then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SHOW_OR_HIDDEN_MOUNT,0)
        SL:onLUAEvent(LUA_MOUNT_SHOW_CHANGE)
    end
end

function this:LUA_EVENT_PLAYER_EQUIP_CHANGE()
    self.bagTileScrollView:RefreshInfo()
end

function this:GetRepairCost(v)
    local price = 0
    ---@type cfg_item_column
    local tbl = SL:GetConfig("cfg_item", v.cfgId)
    if tbl.Durability ~= 0 then
        if SL:HasConfig("cfg_equip_guard", v.cfgId) or SL:HasConfig("cfg_equip_guard", tbl.bindEqualItem) then
            ---@type cfg_equip_guard_column
            local guard = SL:GetConfig("cfg_equip_guard", v.cfgId) or SL:GetConfig("cfg_equip_guard", tbl.bindEqualItem)
            if guard.repair == 0 then
                return 0
            end
        end
        local now = EquipFunc.GetDurability(v)
        local max = EquipFunc.GetMaxDurability(v)
        local delta = max - now
        price = delta * self.fixCostNum
    end
    return price
end

---修理
function this:FixEquipClick()
    GUI:setVisible(self.view.obj_highLight, false)
    local equips = self.equips
    local totalPrice = 0
    local repairList = {}
    if not table.isNullOrEmpty(equips) then
        for _, v in pairs(equips) do
            local price = self:GetRepairCost(v)
            if price > 0 then
                totalPrice = totalPrice + price
                table.insert(repairList, v.id)
            end
        end
    end
    if totalPrice == 0 then
        SL:TipMessage("没有需要修理的装备", 1, NoticeType.NoticeMid)
    else
        GUI:UIPanel_Open("dev/outui/Bag/Panel/KLBagRepairConfirm/KLBagRepairConfirmPanel", nil, nil,
                { totalPrice = totalPrice, list = repairList})
    end
    SL:ScheduleOnce(0.1, function()
        KLGuideManager.UpdateGuide()
    end)
end



-- 整理按钮
function this:tidy_btn()
    --每秒只能整理一次
    local nowTime = SL:GetMetaValue("SERVER_TIME")
    if not self.tidyTime or nowTime - self.tidyTime >= 1000 then
        self.tidyTime = nowTime
        self.inTidy = true
        SL:ReqTidyItemMessage()
    end
end

-- 背包格子解锁回包
function this:LUA_EVENT_BAG_UNLOCK(_, count)
    count = count - PrivilegeCardManager.GetBagSiftLockGridNum()
    if count < 0 then
        count = 0
    end
    self.bagTileScrollView:RefreshForbidGrid(count)
end

-- 整理完成回包
function this:LUA_EVENT_BAG_SORT()
    self.inTidy = false
    local itemList = SL:GetMetaValue("BAG_DATA")[1]
    self.bagTileScrollView:RefreshItemByItem(itemList)
    self.bagTileScrollView:RefreshInfo()

end

-- 仓库按钮
function this:storage_btn()
    if GUI:GetUI("dev/outui/Synthesis/Panel/KLNewNewSynthesis/KLNewNewSynthesisPanel") then
        GUI:UIPanel_Close("dev/outui/Synthesis/Panel/KLNewNewSynthesis/KLNewNewSynthesisPanel")
    end
    if GUI:GetUI("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel") then
        return
    end
    if self.bagType == EBagShowType.NPCShop then
        SL:MessageTip({id=502})
        return
    end
    --self:OpenStorage()
    if PrivilegeCardManager.iswithWarehouse() then
        self:OpenStorage()
    else
        local tipsData = self:StorageTips()
        self.storageRightJump = tipsData.rightUI
        -- SL:CommonTipsMessage({ showTips = tipsData.text, ui = self, sureBtnText = tipsData.rightText, cancelBtnText = "传送", cancelCallBack = self.TransferToNpcStorage, 
        --                        cancelBtnImageData = { src = "button_interface_window7", atlas = "Atlas/Common.spriteatlas" },
        --                        cancelBtnColor = "#FFFFFF" ,callback = self.StorageTipsRight})
        SL:OpenCommonTipPanelById(13,self,self.TransferToNpcStorage)
    end
end

function this:StorageTips()
    local str = SL:GetConfig("cfg_global", 290002).value
    local strTbl = string.split(str, "#")
    local data = {
        text = strTbl[1],
        rightText = not string.isNullOrEmpty(strTbl[2]) and strTbl[2] or "Yes",
        rightUI = strTbl[3],
    }
    return data
end


function this.StorageTipsRight(data)
    if string.isNullOrEmpty(data.ui.storageRightJump) then
        return
    end
    if data.ui.storageRightJump == "dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel" then
        return
    end
    GUI:UIPanel_Open(data.ui.storageRightJump)
    data.ui:closeBtn()
end


-- 仓库打开
function this:OpenStorage()
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    GUI:UIPanel_Open("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel", nil, nil, { x = -344, y = 0 })
end

-- 商城打开
function this:OpenShop()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    if GUI:GetUI("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel") then
        GUI:UIPanel_Close("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel")
    end
    local shop_id = SL:GetMetaValue("GET_NPC_SHOPID", 100101)
    SL:OpenNPCShop(shop_id)
end

function this:OpenFirsh()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    if GUI:GetUI("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel") then
        GUI:UIPanel_Close("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel")
    end
    GUI:UIPanel_Open("dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel", nil, nil, { 2 })
end

function this:recycle_btn()
    if self.bagType == EBagShowType.NPCShop then
        SL:MessageTip({id=502})
        return
    end
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    GUI:UIPanel_Open("dev/ui/Recover/Panel/KLRecover/KLRecoverPanel")
end

function this:closeBtn()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    if GUI:GetUI("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel") then
        GUI:UIPanel_Close("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel")
    end
    SL.ShowMainPanel()
end

function KLUIBagPanel:Close()
    SL:onLUAEvent(LUA_EVENT_MAIN_UI_BOTTOM_SYSTEM_CLOSE)
    GUI:UIPanel_Close("dev/outui/FashionEquip/Panel/KLFashionEquip/KLFashionEquipPanel")
    GUI:UIPanel_Close("dev/outui/FashionEquip/Panel/KLFashionEquipMap/KLFashionEquipMapPanel")
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    if GUI:GetUI("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel") then
        GUI:UIPanel_Close("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel")
    end
    if GUI:GetUI("dev/ui/NPC/Panel/KLNPCShop/KLNPCShopPanel") then
        GUI:UIPanel_Close("dev/ui/NPC/Panel/KLNPCShop/KLNPCShopPanel")
    end
    GUI:UIPanel_Close("dev/outui/NPC/Panel/KLSpecialNPCShop/KLSpecialNPCShopPanel")
    GUI:UIPanel_Close("dev/outui/Synthesis/Panel/KLNewSynthesis/KLNewSynthesisPanel")
    GUI:UIPanel_Close("dev/outui/Task/Panel/KLTaskLoop/KLTaskLoopPanel")
    if self.args and self.args.closeCallBack then
        self.args.closeCallBack()
    end
end

function this:Hide()
    self:Close()
end

-- 点击禁用格子
function this:forbidClick()
    local bag_unlock_info = SL:GetConfig('cfg_global', 107).value
    local bag_unlock_split = string.split(bag_unlock_info, '#')
    local itemId = tonumber(bag_unlock_split[1])
    local needCount = tonumber(bag_unlock_split[2])
    SL:CommonTipsMessage({ stringTblID = 207,
                           ui = self, cfgId = itemId, needCount = needCount, callback = self.UnlockGrid, callbackData = nil ,NotSureCloseSelf = true})
end

function this:UnlockGrid()
    local bag_unlock_info = SL:GetConfig('cfg_global', 107).value
    local bag_unlock_split = string.split(bag_unlock_info, '#')
    local itemId = tonumber(bag_unlock_split[1])
    local needCount = tonumber(bag_unlock_split[2])
    if needCount > SL:GetBagItemCount(itemId) then
        SL:CommonItemGetPath(nil, itemId)
        SL:TipMessage("消耗道具不足", 1, NoticeType.NoticeMid)
        return
    end
    SL:ReqBagAddCapacityMessage(1)
    GUI:UIPanel_Close("dev/ui/Common/Panel/KLUICommonTips/KLUICommonTipsPanel")
end

-- 拖拽结束
function this:dragEnd(eventData)
    local bagHor = eventData.bagPutHor
    local bagVet = eventData.bagPutVet
    local raycastObj = eventData.raycastObj
    local dragItem = eventData.dragItem
    local storageHor = eventData.storageHor
    local storageVet = eventData.storageVet
    local synthesisSmelterHor = eventData.synthesisSmelterHor
    local synthesisSmelterVet = eventData.synthesisSmelterVet

    -- 丢弃道具
    if raycastObj == nil then
        local canDrop = self:GetItemCanDrop(dragItem)
        if canDrop then
            local article = SL:GetConfig('cfg_item', dragItem.item.cfgId).article
            local name = SL:GetConfig('cfg_item', dragItem.item.cfgId).name
            local isDestroy = table.contains(article, 3)
            if isDestroy then
                GUI:UIPanel_Open("dev/ui/Common/Panel/KLUICommonTips/KLUICommonTipsPanel", nil, nil, { showTips = string.format("是否摧毁%s", name), callback = self.DropItem, callbackData = { item = dragItem.item }, ui = self })
            else
                GUI:UIPanel_Open("dev/ui/Common/Panel/KLUICommonTips/KLUICommonTipsPanel", nil, nil, { showTips = string.format("是否丢弃%s", name), callback = self.DropItem, callbackData = { item = dragItem.item }, ui = self })
            end
        else
            SL:TipMessage(SL:GetConfig('cfg_string', 288).text, 1, NoticeType.NoticeMid)--"该道具不可被丢弃",
        end
        return
    end

    if bagHor <= self.maxHor and bagHor > 0 and bagVet <= self.maxVet and bagVet > 0 then
        ---@type CommonProtos.Item
        --local dragItem = eventData.dragItem
        local oldIndex = eventData.index
        local newIndex = SL.Bag:GetIndexWithPageHorAndVet(1, bagHor, bagVet)
        if not eventData.noMove then
            SL:ReqSwapItemMessage(newIndex, 10000 + oldIndex)
        end
    else
        local storage_info = string.split(SL:GetConfig("cfg_global", 7).value, '#')
        local maxHor = tonumber(storage_info[1])
        local maxVet = tonumber(storage_info[2])
        if storageHor and storageHor <= maxHor and storageHor > 0 and storageVet <= maxVet and storageVet > 0 then
            local oldIndex = eventData.index
            local panel = GUI:GetUI("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel")
            if panel.bagType == "privilege" then
                local newIndex = SL.StoreHouse:GetIndexWithPageHorAndVet(panel.CurPage + panel.maxDepotsPages, storageHor, storageVet)
                SL:ReqBagToStoreMessage(10000 + oldIndex, newIndex)
            elseif panel.bagType == "depots" then
                local newIndex = SL.StoreHouse:GetIndexWithPageHorAndVet(panel.CurPage, storageHor, storageVet)
                SL:ReqBagToStoreMessage(10000 + oldIndex, newIndex)
            end
        end
        -- 合成炉
        if eventData.canPut then
            local panel = GUI:GetUI("dev/outui/Synthesis/Panel/KLNewSynthesis/KLNewSynthesisPanel")
            if panel then
                maxHor = ESynthesisBagSize.H
                maxVet = ESynthesisBagSize.V
                if panel and synthesisSmelterHor and synthesisSmelterHor <= maxHor and synthesisSmelterHor > 0 and synthesisSmelterVet <= maxVet and synthesisSmelterVet > 0 then
                    local oldIndex = eventData.index
                    local newIndex = self.bagTileScrollView.GetIntWithHorAndVet(synthesisSmelterHor, synthesisSmelterVet)
                    panel:DragToSmelterItem(oldIndex, newIndex, dragItem.item)
                end
            else
                panel = GUI:GetUI("dev/outui/Task/Panel/KLTaskLoop/KLTaskLoopPanel")
                if panel then
                    maxHor = ELoopTaskBagSize.H
                    maxVet = ELoopTaskBagSize.V
                    if panel and synthesisSmelterHor and synthesisSmelterHor <= maxHor and synthesisSmelterHor > 0 and synthesisSmelterVet <= maxVet and synthesisSmelterVet > 0 then
                        local oldIndex = eventData.index
                        local newIndex = self.bagTileScrollView.GetIntWithHorAndVet(synthesisSmelterHor, synthesisSmelterVet)
                        panel:BagToSmelterItem(oldIndex, newIndex, dragItem.item)
                    end
                end
            end

        end

        -- 萤石合成
        ---@type KLGemSynthesisPanel
        local gemSynthesisPanel = GUI:GetUI("dev/outui/Synthesis/Panel/KLGemSynthesis/KLGemSynthesisPanel")
        if gemSynthesisPanel and gemSynthesisPanel.HandleBagDragEnd then
            gemSynthesisPanel:HandleBagDragEnd(eventData)
        end
    end
end

function this.DropItem(callbackData)
    local item = callbackData.callbackData.item
    local index = SL:MeData_GetIndexBaseOnItemId(item.id)
    if index then
        SL:ReqGiveUpItemMessage(index)
    end

end

function this:UpdateSuitBag(eventData)
    local career = SL:MeData_GetCareer().baseCareer
    ---@type cfg_FashionGuide_column
    local nowSuitCfg = SL:GetConfigTwoKeys("cfg_FashionGuide", self.wearBar, career, "wearing", "career")
    if nowSuitCfg then
        local hasChange = false
        local temp = {}
        for _, v in pairs(nowSuitCfg.fashionId) do
            temp[v] = 1
        end
        for i, itemInfo in pairs(eventData) do
            if itemInfo.item == nil then
                if self.tempIndexToItemList and self.tempIndexToItemList[itemInfo.index % 10000] then
                    hasChange = true
                    break
                end
            else
                if temp[itemInfo.item.cfgId] then
                    hasChange = true
                    break
                end
            end
        end
        if hasChange then
            self.bagTileScrollView:RefreshItemByItem(self:GetBagItemList(nowSuitCfg))
        end
    end
end

function this:BagInfo_Change(_, eventData)
    if self.inTidy then
        return
    end
    if self.isSuit then
        if self.bagTileScrollView == nil then
            self.bagInfoChangeCallBack = function()
                self:UpdateSuitBag(eventData)
            end
        else
            self:UpdateSuitBag(eventData)
        end
        return
    end
    if self.bagTileScrollView == nil then
        self.bagInfoChangeCallBack = function()
            local ksItemList = self.bagTileScrollView:Item_Change(eventData)
            for _, ksItem in pairs(ksItemList) do
                ksItem:RefreshInfo()
            end
        end
        return 
    end
    
    local ksItemList = self.bagTileScrollView:Item_Change(eventData)
    for _, ksItem in pairs(ksItemList) do
        ksItem:RefreshInfo()
    end
end

---@param item KLBagItemItem
function this:GetItemCanDrop(item)
    local article = SL:GetConfig('cfg_item', item.item.cfgId).article
    local cantDrop = table.contains(article, 2)
    if cantDrop then
        return false
    end

    return not item.item.bind
end

--- 传送到NPC商店（NPC商店功能）
function this:TransferToNpcShop()
    local mapInfo = SL:GetConfig("cfg_map_info", SL:GetMetaValue("MAP_ID"), "id")
    if mapInfo.nopositionmove == 1 then
        SL:MessageTip({ id = 116 })
        return
    end
    SL:showTransferAnimation()

    SL:ScheduleOnce(0.5, function()
        SL:SendTransferToNpcMessage(100101, true)
    end)
    SL:ScheduleOnce(2, function()

        if not GUI:GetUI("dev/ui/NPC/Panel/KLNPCShop/KLNPCShopPanel") then
            SL:OpenNPCShop(1)
        end

    end)
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
end

function this:checkTigg()
    SL:ScheduleOnce(0.2, function()
        local uid = SL:GetMetaValue(EMetaVarGetKey.UID)
        local me = SL:GetRoleById(uid)
        SL:CellTrigger(SL:GetMetaValue(EMetaVarGetKey.MAP_ID), SL:MeData_GetCoord().x, SL:MeData_GetCoord().z, me)
    end)
end
--- 传送到NPC仓库
function this.TransferToNpcStorage()
    SL:FGRunToNpc(100107)
    --SL:showTransferAnimation()
--[[    local npcList = SL:GetConfig("cfg_npclist",100107)
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    if mapId ~= npcList.mapId then
        SL:showTransferAnimation()
    end
    --SL:SendTransferToNpcMessage(100107, true,true)
    SL:ScheduleOnce(0.5, function()
        local ShortcutMgr = SL:Get_G()['ShortcutMgr']
        ShortcutMgr.RunToNpc(100107,function()
            local SceneTouch = SL:Get_G()['SceneTouch']
            local mapId_ = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
            if mapId_ == npcList.mapId then
                SceneTouch.ClickNpc(100107)
                local EventManager = SL:Get_G()['EventManager']
                EventManager.Dispatch(Event.UIShow_MePathMoveStop)
                SL:onLUAEvent(LUA_EVENT_UI_SHOW_ME_PATH_STOP)
            end
        end)
        -- if SL:GetBattleState() then
        --     SL:TipMessage({ "战斗状态下禁止传送", 1, NoticeType.NoticeMid })
        --     return
        -- end

    end)]]
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
end

--region 穿戴栏相关

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
---@param fashionCfg cfg_FashionGuide_column
function this:SetWearBar(wearBar, fashionCfg)
    if self.wearBar and self.wearBar == wearBar then
        return
    end
    self.wearBar = wearBar
    self:UpdateEquips()
    if self.isSuit and fashionCfg and self.bagTileScrollView then
        self.bagTileScrollView:RefreshItemByItem(self:GetBagItemList(fashionCfg))
        self.bagTileScrollView:RefreshInfo()
    end
end

--更下当前穿戴栏装备
function this:UpdateEquips()
    if self.isUpdateEquips then
        return
    end
    self.equips = SL:GetWearBarsData(self.wearBar) or {}
    --根据穿戴栏更新装备数据以及需要显示的装备grid    
    local noShowSlot = {
        EEquipSlotType.None, 
        EEquipSlotType.FashionTotalArmor
        --EEquipSlotType.Banner,
    }
    ---@type cfg_wearing_bar_column
    local tbl = SL:GetConfig("cfg_wearing_bar", self.wearBar)
    for k, v in ipairs(self.showSlot) do
        --类型
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
                    local default = gridData[v] or gridData[p]
                    local itemCfgId = self.equips[v] and self.equips[v].cfgId or nil
                    local args = { equipPos = v, isOtherPlayer = self.isOtherPlayer, isEquipGrid = true, item = nil, default = default or {}, x = default.x, y = default.y, click = self.OnGridItemClick, callBackUI = self, mscaleType = EEquipScaleType.BagEquipScale ,is_wear_eauip=true}
                    GUI:UIPanel_Open("dev/ui/Common/Item/KLBagItem/KLBagItemItem", self.view.EquipGrid, self, args, true, function(win)
                        self.slotToGrid[v] = win
                        GUI:setName(self.slotToGrid[v].view.root, "Grid_" .. v)
                        GUI:setVisible(self.slotToGrid[v].view.root, true)
                        local itemControl = GUI:GetChildById(self.slotToGrid[v].view.root, "bag_item_")
                        self.slotRectToGrid[v] = GUI:GetGameObject(GUI:GetChildById(itemControl, "empty"))
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
                        GUI:SetZIndex(win.view.equipInfo,205)
                    end)
                else
                    local default = gridData[v] or gridData[p]
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
--[[    if self.hideTips then
        if GUI:getVisible(view.selectImg) then
            local ui = GUI:GetUI("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
            local archangeUI = GUI:GetUI("dev/outui/Archangel/Panel/KLArchangelGroup/KLArchangelGroupPanel")
            if ui or archangeUI then
                local bag = self.isOtherPlayer and "otherEquip" or "equip"
                SL:OpenTips(bag, item.cfgId, item.id, nil, nil, { hideBtn = true, otherRid = self.otherRid })
            end

        end
    end]]
    if not self.isOtherPlayer then
        for pos, v in pairs(self.slotToGrid) do
            if v.view and v.view == view then
                SL:onLUAEvent(LUA_EVENT_EQUIP_GRID_CLICK, pos, self.wearBar)
                break
            end
        end
    end
end

---@param data table {MakeIndex = 唯一ID, Where = 装备位置, opera = 操作类型 ( 0:初始化 1:增加 2:删除 3:改变), ItemData = 装备数据, WearBar = 穿戴栏id}
function this:EquipChange(_, data)
    if table.isNullOrEmpty(data) then
        return
    end
    if data.WearBar == self.wearBar then
        self.equips = SL:GetWearBarsData(self.wearBar)
        local pos = data.Where
        if self.slotToGrid[pos] then
            self.slotToGrid[pos]:SetItem(self.equips[pos], self.forgeGroupType)
        end
        self:UpdateSuitColor()
        self:UpdateStrengthMasterColor()
    end
end

--刷新货币数据
function this:UpdateMoney()
    local goldCount= SL:GetBagItemCount(self.money_info[1][2],false) + SL:GetBagItemCount(self.money_info[1][3],false)
    local diamondCount= SL:GetBagItemCount(self.money_info[2][2],false) + SL:GetBagItemCount(self.money_info[2][3],false)
    local ruibiCount = SL:GetBagItemCount(self.money_info[3][2],false) + SL:GetBagItemCount(self.money_info[3][3],false)
    local icon1 = SL:GetConfig("cfg_item", tonumber(self.money_info[1][2])).looks
    local icon2 = SL:GetConfig("cfg_item", tonumber(self.money_info[2][2])).looks
    --local icon3 = SL:GetConfig("cfg_item", tonumber(self.money_info[3][2])).looks
    GUI:Image_loadTexture(self.view.goldIcon, icon1,"Atlas/QJ5_ItemLooksIcon.spriteatlas")
    GUI:Image_loadTexture(self.view.diamondIcon, icon2,"Atlas/QJ5_ItemLooksIcon.spriteatlas")
    --GUI:Image_loadTexture(self.view.ruibiIcon, icon3,"Atlas/UIBagPanel.spriteatlas")
    GUI:Text_setString(self.view.txt_gold, tostring(goldCount))
    GUI:Text_setString(self.view.txt_diamond, tostring(diamondCount))
    GUI:Text_setString(self.view.txt_ruibi, tostring(ruibiCount))
end

---@param moneyId number @货币id
function this:ShowMoneyTips(_, moneyId)
    SL:OpenTips("nil", moneyId,nil,nil, nil,{isShowAll = true})
end

--跳转外观
function this:GoDressPage()
    GUI:UIPanel_Close(self.filePath)
    GUI:UIPanel_Close("dev/outui/FashionEquip/Panel/KLFashionEquipMap/KLFashionEquipMapPanel")
    GUI:UIPanel_Open("dev/outui/AppearGroup/Panel/KLAppearGroup/KLAppearGroupPanel", nil, nil, {type = E_FashionType.Appear, isFromBag = true})
end

--跳转图鉴
function this:GoMapPage()
    if GUI:GetUI("dev/outui/FashionEquip/Panel/KLFashionEquipMap/KLFashionEquipMapPanel") then
        GUI:UIPanel_Close("dev/outui/FashionEquip/Panel/KLFashionEquipMap/KLFashionEquipMapPanel")
    else
        GUI:UIPanel_Open("dev/outui/FashionEquip/Panel/KLFashionEquipMap/KLFashionEquipMapPanel")    
    end
end

--endRegion

---@param cfg cfg_FashionGuide_column
function this:GetBagItemList(cfg)
    --筛选目前不能整体兼容，暂时屏蔽
    -- local ui = GUI:GetUI("dev/outui/Task/Panel/KLTaskLoop/KLTaskLoopPanel")
    -- if ui then
    --     local list = ui:getBagItemList()
    --     return SL.Bag:SortItemList(list)
    -- end
    local items = SL:GetMetaValue("BAG_DATA")[1]

    if self.isSuit then
        if not cfg then
            cfg = self.fashionDatas[1]
        end
        local temp = {}
        
        for _, v in pairs(cfg.fashionId) do
            temp[v] = 1
        end
        local itemList = {}
        local list = {}
        for idx, item in pairs(items) do
            if temp[item.cfgId] then
                table.insert(itemList, item)
                list[idx] = item
            end
        end
        self.tempIndexToItemList = list
        return SL.Bag:SortItemList(itemList)
    end
    return items
end

function this:UpdateSuitColor()
    if self.isSuit or not self.equips then
        return
    end
    local checkList = {}
    --GUI:Text_setString(self.view.btn_attSuits, "[套装属性]")
    GUI:Text_setString(self.view.btn_attSuits, "[Set Bns]")
    for _, v in pairs(self.equips) do
        local suitId = EquipFunc.GetSuitIdByEquipCfgId(v.cfgId)
        if suitId and not checkList[suitId] then
            checkList[suitId] = 1
            local equipList, sutEffects = SL:GetSuitEquipInfoList(v.cfgId)
            for _, effectList in pairs(sutEffects) do
                for _, eff in pairs(effectList) do
                    if eff.isActive then
                        --GUI:Text_setString(self.view.btn_attSuits, "<color=#FFCC19>[套装属性]</color>")
                        GUI:Text_setString(self.view.btn_attSuits, "<color=#FFCC19>[Set Bns]</color>")
                        return
                    end
                end
            end
        end
    end
end

function this:UpdateStrengthMasterColor()
    if self.isSuit then
        return
    end
    local strengthMaster = EquipFunc.GetStrengthMasterActiveAttr(1)
    if not table.isNullOrEmpty(strengthMaster) then
       -- GUI:Text_setString(self.view.btn_strengthenAtts, "<color=#FFCC19>[强化属性]</color>")
        GUI:Text_setString(self.view.btn_strengthenAtts, "<color=#FFCC19>[Enh Bns]</color>")
    else
        --GUI:Text_setString(self.view.btn_strengthenAtts, "[强化属性]")
        GUI:Text_setString(self.view.btn_strengthenAtts, "[Enh Bns]")
    end
end


function this:ShowSuitAtts()
    if self.isSuit or not self.equips then
        return
    end
    local checkList = {}
    self.attTextList = {}
    local count = 0
    for _, v in pairs(self.equips) do
        local suitId = EquipFunc.GetSuitIdByEquipCfgId(v.cfgId)
        if suitId and not checkList[suitId] then
            checkList[suitId] = 1
            local addTitle = false
            local equipList, sutEffects = SL:GetSuitEquipInfoList(v.cfgId)
            for _, effectList in pairs(sutEffects) do
                for _, eff in pairs(effectList) do
                    if eff.isActive then
                        if not addTitle then
                            ---@type cfg_equip_suit_column
                            local tbl = SL:GetConfig("cfg_equip_suit", suitId)
                            table.insert(self.attTextList, "<color=#FFCC19>" .. tbl.name .. "</color>")
                            addTitle = true
                            count = count + 1
                        end
                        local text = EquipFunc.GetAttText(eff.attId, eff.attNum, " 增加 +")
                        table.insert(self.attTextList, text)
                        count = count + 1
                    end
                end
            end
        end
    end
    if table.isNullOrEmpty(self.attTextList) then
        return
    end
    GUI:DataListUpdateData(self.view.datalist_atts)
    self:SetSize(count)
    GUI:setVisible(self.view.AttInfosRoot, true)
    GUI:SetZIndex(self.view.AttInfosRoot, 220)
    GUI:setVisible(self.view.btn_emptyBg, true)
    GUI:SetZIndex(self.view.btn_emptyBg, 220)


end

function this:ShowStrengthAtts()
    local strengthMaster = EquipFunc.GetStrengthMasterActiveAttr(1)
    if table.isNullOrEmpty(strengthMaster) then
        return
    end
    GUI:setVisible(self.view.AttInfosRoot, true)
    GUI:SetZIndex(self.view.AttInfosRoot, 220)
    GUI:setVisible(self.view.btn_emptyBg, true)
    GUI:SetZIndex(self.view.btn_emptyBg, 220)

    local count = 0
    self.attTextList = {}
    if not table.isNullOrEmpty(strengthMaster) then
        table.insert(self.attTextList, "<color=#E6E600>强化大师</color>")
        count = count + 1
        for _, v in pairs(strengthMaster) do
            local attText = EquipFunc.GetAttText(v.id, v.value, " +")
            table.insert(self.attTextList, attText)
            count = count + 1
        end
    end
    self:SetSize(count)
    GUI:DataListUpdateData(self.view.datalist_atts)
end

function this:SetSize(count)
    local paddingUp = 15
    local itemSize = 21
    local paddingDown = 10
    local size = paddingUp + itemSize * count + paddingDown
    GUI:setContentSize(self.view.AttInfosRoot, 300, size)
end

function this:EmptyBgClick()
    GUI:setVisible(self.view.btn_emptyBg, false)
    GUI:setVisible(self.view.AttInfosRoot, false)
end

function this:RefreshFilterTagList(filterTagList)
    -- SL:LogError("RefreshFilterTagList", SL:JsonEncode(filterTagList))
    self.filterTagList = filterTagList
    if self.bagTileScrollView then
        -- SL:LogError("RefreshFilterTagList2", table.count(filterTagList))
        self.bagTileScrollView:RefreshFilterTagList(filterTagList)
    end
end

function this:PillNoEnough()
    if PrivilegeCardManager.iswithStore() then
        SL:HideAllKmlPanel()
        self:OpenShop()
    else
        SL:OpenCommonTipPanelById(2)
--[[        SL:CommonTipsMessage({ stringTblID = 226, ui = self, sureBtnText = "取消", cancelBtnText = "传送", cancelCallBack = self.TransferToNpcShop,
                               cancelBtnImageData = { src = "button_interface_window7", atlas = "Atlas/Common.spriteatlas" },
                               cancelBtnColor = "#FFFFFF"})]]
--[[        SL:CommonTipsMessage({ stringTblID = 226, ui = self, sureBtnText = "随身买药", cancelBtnText = "传送", cancelCallBack = self.TransferToNpcShop,
                               callback = self.OpenFirsh, littleTipsTextTable = { text = "<color='#FFFF00'>激活白银特权卡</color>", x = 100, y = -60 } ,
                               sureBtnImageData = { src = "button_interface_window6", atlas = "Atlas/Common.spriteatlas" }, cancelBtnImageData = { src = "button_interface_window7", atlas = "Atlas/Common.spriteatlas" },
                               cancelBtnColor = "#FFFFFF"})]]
    end
end

function this:OpenShop()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    if GUI:GetUI("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel") then
        GUI:UIPanel_Close("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel")
    end
    local shop_id = SL:GetMetaValue("GET_NPC_SHOPID", 100101)
    SL:OpenNPCShop(shop_id)
end

function this:RES_DURABILITY_CHANGE()
    if self.slotToGrid then
        for _, v in pairs(self.slotToGrid) do
            v:UpdateDurShow()
        end  
    end
end

return KLUIBagPanel
