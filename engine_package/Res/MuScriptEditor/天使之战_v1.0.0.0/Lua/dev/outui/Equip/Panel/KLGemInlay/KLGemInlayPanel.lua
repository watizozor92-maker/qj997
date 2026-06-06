---@class KLGemInlayPanel:UIKmlLuaPanelBase
---@field view KLGemInlayPanelView
---@field equipPanel KLGemEquipUIPanel
local KLGemInlayPanel = class(UIKmlLuaPanelBase)
local this =KLGemInlayPanel
---创建时调用一次
function this:Init()
    ---第一次打开界面
    self.firstOpen = true
    self:OpenGemEquipUI()
    
    InfoManager.gemSlateInfo:SetOptEquip(nil)
    InfoManager.gemSlateInfo:ChangeGemPosId(nil)
    InfoManager.gemSlateInfo:ChangeEquipPosId(nil)
    
    self.curSelectGemInlayType=E_GemInlayType.Gem
    self.curSelectSchemeType=1
    
    self.bagItems = {}

    self.currentAttList = {}
    GUI:DataListInitData(self.view.datalist_gemAttrs, function()
        return self:CurrentCountFunc()
    end, function(realIndex)
        return self:CurrentGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:CurrentInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:CurrentUpdateFunc(realIndex, kmlcontrol)
    end)

    
    GUI:DataListInitData(self.view.datalist_AllGemAttrs, function()
        return self:AllGemAttrCountFunc()
    end, function(realIndex)
        return self:AllGemAttrCurrentGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:AllGemAttrCurrentInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:AllGemAttrCurrentUpdateFunc(realIndex, kmlcontrol)
    end)
    
end

---打开萤石装备界面
function this:OpenGemEquipUI()
    local selectType = nil
    local equip_boot = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, EEquipSlotType.TwoHandWeapon)
    if equip_boot then-- 策划要求先选中武器
        selectType = EEquipSlotType.Weapon
    end
    if not selectType then
        for index=1, 15 do
            if table.contains(InfoManager.gemSlateInfo.CanInlayGemEquipPosTbl,tostring(index)) then
                local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, index)
                if equip then
                    selectType = index
                    break
                end
            end
        end
    end
    
    GUI:UIPanel_Open("dev/outui/Equip/Panel/KLGemEquipUI/KLGemEquipUIPanel",
            nil,
            nil,
            { x = -465, hideTips = true, callBack = self.CloseEquipUi,selectType = selectType}, 
            true,
            function(equipPanel)
                self.equipPanel = equipPanel
            end)
end

E_GemInlayType = {
    Gem = enum(0),
    Slate = enum(1),
}

---注册UI事件和服务器消息
function this:RegistEvents()

    GUI:AddOnClickEvent(self.view.CloseButton, self, self.ClosePanel)
    GUI:AddOnClickEvent(self.view.GemCellImg1, self, self.OnClickGemCellImg1)
    GUI:AddOnClickEvent(self.view.GemCellImg2, self, self.OnClickGemCellImg2)
    GUI:AddOnClickEvent(self.view.GemCellImg3, self, self.OnClickGemCellImg3)
    GUI:AddOnClickEvent(self.view.SlateImg, self, self.OnClickSlateImg)
    GUI:AddOnClickEvent(self.view.zhu_click, self, self.OnClickOptEquip)
    GUI:AddOnClickEvent(self.view.HelpBtn, self, self.OnClickHelpBtn)
    
    GUI:SetToggleOnValueChange(self.view.schemeToggle1, self, self.SchemeToggleChanged,1)
    GUI:SetToggleOnValueChange(self.view.schemeToggle2, self, self.SchemeToggleChanged,2)

    GUI:SetToggleOnValueChange(self.view.gemBtn, self, self.GemSlateToggleChanged,E_GemInlayType.Gem)
    --GUI:SetToggleOnValueChange(self.view.slateBtn, self, self.GemSlateToggleChanged,E_GemInlayType.Slate)


    SL:RegisterLUAEvent(LUA_EVENT_EQUIP_GRID_CLICK, self.OnClickEquipPanelPos, self)
    SL:RegisterLUAEvent(LUA_EVENT_REFRESH_GEM_SLATE_INFO, self.RefreshPanelShow, self)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GEM_SCHEME, self.InitSchemeByMsg, self)
    
    SL:RegisterLUAEvent(LUA_EVENT_FORGE_GROUP_PANEL_CLOSE, self.ClosePanel, self)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SCHEME_INFO)
    self:RefreshRedPoint()
end

function this:RefreshPanelShow()
    if self.firstOpen then
        self.firstOpen = false
        local equip_boot = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, EEquipSlotType.TwoHandWeapon)
        if equip_boot then
            InfoManager.gemSlateInfo:ChangeEquipPosId(EEquipSlotType.TwoHandWeapon)
            self.bagIndex = nil
            self:ClickEquip(equip_boot)
            self.selectEquipType = EEquipSlotType.TwoHandWeapon

            return
        end
        for index=1, 15 do
            if table.contains(InfoManager.gemSlateInfo.CanInlayGemEquipPosTbl,tostring(index)) then
                local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, index)
                if equip then
                    InfoManager.gemSlateInfo:ChangeEquipPosId(index)
                    self.bagIndex = nil
                    self.selectEquipType = index
                    self:ClickEquip(equip)
                    return
                end
            end
        end
        self:RefreshGemSlateShow(self.curSelectGemInlayType)
        return
    end
    self:RefreshGemSlateShow(self.curSelectGemInlayType)
end

function this:CurrentCountFunc()
    return #self.currentAttList
end
function this:CurrentGetFunc(realIndex)
    
end
function this:CurrentInitFunc(realIndex,kmlcontrol)

end
function this:CurrentUpdateFunc(realIndex,kmlcontrol)
    local data = self.currentAttList[realIndex + 1]
    local singleAttrTxt = GUI:GetChildControl(self.view.datalist_gemAttrs, realIndex, "singleAttrTxt")
    local cfg=SL:GetConfig("cfg_equip_gem", data)
    local attrTbl = SL:GetConfig("cfg_att_info", cfg.gemAtt[1][1])
    local slateCfg
    local addValue=0
    local factor=1
    if self.curSelectGemInlayType==E_GemInlayType.Slate then
        local inlaySlate=InfoManager.gemSlateInfo:GetCurActiveSchemeGem(nil,true)
        if inlaySlate then
            slateCfg=SL:GetConfig("cfg_equip_stoneBoard", inlaySlate)
        end
        if slateCfg then
            for k, v in pairs(slateCfg.stoneAtt2) do
                if cfg.gemBelong[1]==v[1] then
                    factor=v[2]*0.0001
                    break
                end
            end
        else
            factor=0
        end
        -- GUI:SetActive(self.view.NoAttribute,not slateCfg)
    end
    local attrName=attrTbl.showname
    addValue=math.floor(cfg.gemAtt[1][2]*factor)
    if cfg.gemAtt[2] then
        if cfg.gemAtt[1][1]==200011 and cfg.gemAtt[2][1]==200021 then
            attrName="攻击力"
            addValue=string.format("%s~%s",math.floor(cfg.gemAtt[1][2]*factor),math.floor(cfg.gemAtt[2][2]*factor))
        elseif cfg.gemAtt[1][1]==201011 and cfg.gemAtt[2][1]==201021 then
            attrName="攻击力"--"物理攻击力"
            addValue=string.format("%s~%s",math.floor(cfg.gemAtt[1][2]*factor),math.floor(cfg.gemAtt[2][2]*factor))
        elseif cfg.gemAtt[1][1]==202011 and cfg.gemAtt[2][1]==202021 then
            attrName="攻击力"--"魔法攻击力"
            addValue=string.format("%s~%s",math.floor(cfg.gemAtt[1][2]*factor),math.floor(cfg.gemAtt[2][2]*factor))
        elseif cfg.gemAtt[1][1]==205011 and cfg.gemAtt[2][1]==205021 then
            attrName="攻击力"--"诅咒攻击力"
            addValue=string.format("%s~%s",math.floor(cfg.gemAtt[1][2]*factor),math.floor(cfg.gemAtt[2][2]*factor))
        elseif cfg.gemAtt[1][1]==203011 and cfg.gemAtt[2][1]==203021 then
            attrName="攻击力"--"天鹰攻击力"
            addValue=string.format("%s~%s",math.floor(cfg.gemAtt[1][2]*factor),math.floor(cfg.gemAtt[2][2]*factor))
        end
    end
    
    GUI:Text_setString(singleAttrTxt,string.format("%s    %s:<color=#00ff00ff>%s</color>",cfg.gemName,attrName,addValue))
end


function this:AllGemAttrCountFunc()
    return #InfoManager.gemSlateInfo.ActiveGemSuitCfgTbl
end
function this:AllGemAttrCurrentGetFunc(realIndex)
    
end
function this:AllGemAttrCurrentInitFunc(realIndex,kmlcontrol)

end
function this:AllGemAttrCurrentUpdateFunc(realIndex,kmlcontrol)
    ---@type cfg_equip_gemSuit_column
    local data = InfoManager.gemSlateInfo.ActiveGemSuitCfgTbl[realIndex + 1]
    local NotActive = GUI:GetChildControl(self.view.datalist_AllGemAttrs, realIndex, "NotActive",kmlcontrol)
    local ActiveTxt = GUI:GetChildControl(self.view.datalist_AllGemAttrs, realIndex, "ActiveTxt",kmlcontrol)
    local detialBtn = GUI:GetChildControl(self.view.datalist_AllGemAttrs, realIndex, "detialBtn",kmlcontrol)

    
    GUI:AddOnClickEvent(detialBtn, self, self.OnClickAllGemsInfoBtn)    
    
    GUI:SetActive(NotActive,data.sortId>0)
    GUI:SetActive(ActiveTxt,data.sortId<0)
    local txtShowColor="#FFFFFF"
    if data.sortId>0 then
        txtShowColor="#8E8E8E"
    end
    local gemTitleParent = GUI:GetChildControl(self.view.datalist_AllGemAttrs, realIndex, "gemTitleParent",kmlcontrol)
    local attrInfoTxt = GUI:GetChildControl(self.view.datalist_AllGemAttrs, realIndex, "attrInfoTxt",kmlcontrol)
    local skillInfoTxt = GUI:GetChildControl(self.view.datalist_AllGemAttrs, realIndex, "skillInfoTxt",kmlcontrol)

    GUI:Text_setString(gemTitleParent,data.title)
    GUI:Text_setTextColor(gemTitleParent,txtShowColor)
    local attrStr=""
    for i,v in ipairs(data.suitAtt) do
        local tmpStr=SL:GetConfig("cfg_att_info", v[1]).showname..v[2].."  "
        attrStr=attrStr..tmpStr
    end
    -- local attrTbl = SL:GetConfig("cfg_att_info", v[1])
    GUI:Text_setString(attrInfoTxt,attrStr)
    GUI:Text_setTextColor(attrInfoTxt,txtShowColor)
    
    GUI:Text_setString(skillInfoTxt,data.skillText)
    GUI:Text_setTextColor(skillInfoTxt,txtShowColor)
end


function this:RefreshGemSlateShow(EGemInlayType)
    local inlayGem1=InfoManager.gemSlateInfo:GetCurActiveSchemeGem("1")
    local inlayGem2=InfoManager.gemSlateInfo:GetCurActiveSchemeGem("2")
    local inlayGem3=InfoManager.gemSlateInfo:GetCurActiveSchemeGem("3")
    local inlaySlate=InfoManager.gemSlateInfo:GetCurActiveSchemeGem(nil,true)
    self.currentAttList={}
    if inlayGem1 then
        table.insert(self.currentAttList,inlayGem1)
    end
    if inlayGem2 then
        table.insert(self.currentAttList,inlayGem2)
    end
    if inlayGem3 then
        table.insert(self.currentAttList,inlayGem3)
    end

    if EGemInlayType==E_GemInlayType.Gem then
        GUI:SetActive(self.view.GemCellParentImg,true)
        GUI:SetActive(self.view.SlateCellParentImg,false)

        GUI:Text_setString(self.view.gemAddParentTitle,"萤石加成")

        self:SetGem1Model(inlayGem1)
        self:SetGem2Model(inlayGem2)
        self:SetGem3Model(inlayGem3)

        
    else

        if not inlaySlate then
            self:SetSlateModel(nil)
        else
            self:SetSlateModel(inlaySlate)
        end

        GUI:SetActive(self.view.GemCellParentImg,false)
        GUI:SetActive(self.view.SlateCellParentImg,true)

        GUI:Text_setString(self.view.gemAddParentTitle,"石板加成")
    end
    GUI:DataListUpdateData(self.view.datalist_gemAttrs)
    GUI:DataListUpdateData(self.view.datalist_AllGemAttrs)
    GUI:SetActive(self.view.NoAttribute,table.isNullOrEmpty(self.currentAttList))
end

function this:SetEquipModel(equipInfo)
    if equipInfo then
        GUI:setVisible(self.view.zhu_add, false)
        GUI:setVisible(self.view.zhu_item, true)
        GUI:Item_setItemId(self.view.zhu_item, equipInfo.cfgId)
        self:SetLiuGuang(equipInfo)
    else
        GUI:setVisible(self.view.zhu_add, true)
        GUI:setVisible(self.view.zhu_item, false)
        GUI:ResetStreamAttr(self.view.zhu_item)
    end

end

function this:SetLiuGuang(equipInfo)
    local liuGuangId = EquipFunc.GetEquipLiuGuangId(equipInfo)
    if liuGuangId then
        GUI:SetStreamAttr(self.view.zhu_item, liuGuangId)
    else
        GUI:ResetStreamAttr(self.view.zhu_item)
    end
end


function this:SetSlateModel(cfgId)
    if not cfgId then
        GUI:setVisible(self.view.SlateCell, false)
        GUI:setVisible(self.view.SlateAddImg, true)
        GUI:setVisible(self.view.slateLevelTxt, false)
    else
        GUI:setVisible(self.view.slateLevelTxt, true)
        local cfg=SL:GetConfig("cfg_equip_stoneBoard", cfgId)
        GUI:Text_setString(self.view.slateLevelTxt,cfg.stoneBoardLevel.."级")
        GUI:setVisible(self.view.SlateCell, true)
        GUI:setVisible(self.view.SlateAddImg, false)
        GUI:Item_setItemId(self.view.SlateCell, cfgId)
    end
end

function this:SetGem1Model(cfgId)
    if not cfgId then
        GUI:setVisible(self.view.GemCell1, false)
        GUI:setVisible(self.view.AddImg1, true)
        GUI:setVisible(self.view.gemLevelTxt1, false)
    else
        GUI:setVisible(self.view.gemLevelTxt1, true)
        local cfg=SL:GetConfig("cfg_equip_gem", cfgId)
        GUI:Text_setString(self.view.gemLevelTxt1,cfg.gemBelong[2].."级")
        GUI:setVisible(self.view.GemCell1, true)
        GUI:setVisible(self.view.AddImg1, false)
        GUI:Item_setItemId(self.view.GemCell1, cfgId)
    end
end

function this:SetGem2Model(cfgId)
    if not cfgId then
        GUI:setVisible(self.view.GemCell2, false)
        GUI:setVisible(self.view.AddImg2, true)
        GUI:setVisible(self.view.gemLevelTxt2, false)
    else
        GUI:setVisible(self.view.gemLevelTxt2, true)
        local cfg=SL:GetConfig("cfg_equip_gem", cfgId)
        GUI:Text_setString(self.view.gemLevelTxt2,cfg.gemBelong[2].."级")

        GUI:setVisible(self.view.GemCell2, true)
        GUI:setVisible(self.view.AddImg2, false)
        GUI:Item_setItemId(self.view.GemCell2, cfgId)
    end
end

function this:SetGem3Model(cfgId)
    if not cfgId then
        GUI:setVisible(self.view.GemCell3, false)
        GUI:setVisible(self.view.AddImg3, true)
        GUI:setVisible(self.view.gemLevelTxt3, false)
    else
        GUI:setVisible(self.view.gemLevelTxt3, true)
        local cfg=SL:GetConfig("cfg_equip_gem", cfgId)
        GUI:Text_setString(self.view.gemLevelTxt3,cfg.gemBelong[2].."级")

        GUI:setVisible(self.view.GemCell3, true)
        GUI:setVisible(self.view.AddImg3, false)
        GUI:Item_setItemId(self.view.GemCell3, cfgId)
    end
end

function this:CloseEquipUi()
    GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLGemEquipUI/KLGemEquipUIPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLGemInlay/KLGemInlayPanel")
end

function this:ItemClick(itemControl, itemData)
    local pos = self:GetPos(itemData.id)
    SL:OpenTips(pos, itemData.cfgId, itemData.id)
end

function this:GetPos(itemId)
    for _, v in pairs(self.bagItems) do
        if v == itemId then
            return "bag"
        end
    end
    return "equip"
end


function this:GetSlateItems()
    local data = {}
    local bagItemTabl = SL:GetMetaValue("BAG_DATA")[1]

    if bagItemTabl then
        for _, v in pairs(bagItemTabl) do
            if SL:HasConfig("cfg_equip_stoneBoard", v.cfgId, "id") then

                --data[SL:GetBagIndex(v.id) - 10000] = v
                table.insert(data, v)
                table.insert(self.bagItems, v.id)
            end
        end
    end
    return SL.Bag:SortItemList(data) 
end

function this:GetGemItems()
    local data = {}
    local bagItemTabl = SL:GetMetaValue("BAG_DATA")[1]

    if bagItemTabl then
        for _, v in pairs(bagItemTabl) do
            if SL:HasConfig("cfg_equip_gem", v.cfgId, "id") then

                --data[SL:GetBagIndex(v.id) - 10000] = v
                table.insert(data, v)
                table.insert(self.bagItems, v.id)
            end
        end
    end
    return SL.Bag:SortItemList(data)
end

function this:OnClickEquipPanelPos(_, index)
    
    local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, index)
    local realIndex=index
    if index == E_AppearEquipType.Weapon and equip == nil then
        equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, E_AppearEquipType.TwoHandWeapon)
        realIndex=E_AppearEquipType.TwoHandWeapon
    end
    if equip then
        InfoManager.gemSlateInfo:ChangeEquipPosId(realIndex)
        if self.curSelectGemInlayType==E_GemInlayType.Gem then
            self.bagIndex = nil
            if table.contains(InfoManager.gemSlateInfo.CanInlayGemEquipPosTbl,tostring(index)) then
                self.equipPanel:SetSelectIndex(index)
                self:ClickEquip(equip)
                self.selectEquipType = index
            else
                SL:TipMessage( SL:GetConfig("cfg_string",325).text ,3, NoticeType.NoticeMid )
            end
        else
            self.bagIndex = nil
            if table.contains(InfoManager.gemSlateInfo.CanInlaySlateEquipPosTbl,tostring(index)) then
                self.equipPanel:SetSelectIndex(index)
                self:ClickEquip(equip)
                self.selectEquipType = index
            else
                SL:TipMessage( SL:GetConfig("cfg_string",326).text ,3, NoticeType.NoticeMid )
            end
        end
    else
        if self.curSelectGemInlayType==E_GemInlayType.Gem then
            SL:TipMessage( SL:GetConfig("cfg_string",327).text ,3, NoticeType.NoticeMid )
        else
            SL:TipMessage( SL:GetConfig("cfg_string",328).text ,3, NoticeType.NoticeMid )
        end
    end
end

-- 装备名字
function this:SetEquipName(cfgId, strengthLevel)

    GUI:setVisible(self.view.equipName, true)
    local equipName = SL:GetConfig('cfg_item', cfgId).name
    local colorStr = EquipFunc.GetEquipNameColor(cfgId)
    --if strengthLevel > 0 then
    --    equipName = equipName .. '+' .. strengthLevel
    --end
    GUI:Text_setString(self.view.equipName, string.format("<color=%s>%s</color>", colorStr, equipName))
end

function this:ClickEquip(equip)
    local strengthLevel = EquipFunc.GetEquipStrengthLevel(equip)
    self:SetEquipName(equip.cfgId, strengthLevel)
    self:SetEquipModel(equip)
    InfoManager.gemSlateInfo:SetOptEquip(equip)
    -- if self.curSelectGemInlayType==E_GemInlayType.Gem then
        
    -- else

    -- end
    self:RefreshGemSlateShow(self.curSelectGemInlayType)
end

function this:SchemeToggleChanged(kmlCtrl, eventData, args,isMessage)
    if args[1] then
        -- logError("切换方案"..eventData)
        if eventData==1 then
            self.curSelectSchemeType=1
         
            
            GUI:Text_setString(self.view.schemeTxt1,"方案一"..string.format("<color=#00ff00ff>%s</color>", "(激活)"))
            GUI:Text_setString(self.view.schemeTxt2,"方案二")
            if not isMessage then
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SCHEME_SWITCH,{schemepos=1})
            end
        elseif eventData==2 then
            self.curSelectSchemeType=2
            GUI:Text_setString(self.view.schemeTxt1,"方案一")
            GUI:Text_setString(self.view.schemeTxt2,"方案二"..string.format("<color=#00ff00ff>%s</color>", "(激活)"))
            if not isMessage then
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SCHEME_SWITCH,{schemepos=2})
            end
        end
    end
end

function this:GemSlateToggleChanged(kmlCtrl, eventData, args)
    if args[1] then
        local tmpUI=GUI:GetUI("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel")
        self.curSelectGemInlayType=eventData
        if eventData==E_GemInlayType.Gem then
            self:RefreshGemSlateShow(E_GemInlayType.Gem)
            if tmpUI then
                GUI:UIPanel_Close("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel")
                GUI:UIPanel_Open("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel", nil, nil, { itemList = self:GetGemItems(), x = -482, y = 0, itemClick = self.ItemClick, callBackUI = self,bagType=E_GemInlayType.Gem })
            end
            self:OnClickGemCellImg1()
        elseif eventData==E_GemInlayType.Slate then
            self:RefreshGemSlateShow(E_GemInlayType.Slate)
            if tmpUI then
                GUI:UIPanel_Close("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel")
                GUI:UIPanel_Open("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel", nil, nil, { itemList = self:GetSlateItems(), x = -482, y = 0, itemClick = self.ItemClick, callBackUI = self,bagType=E_GemInlayType.Slate })
            end
            self:OnClickSlateImg()
        end
    end
 

end

---@param message {cur:number, data:table}
function this:InitSchemeByMsg(id, message)
    if message.cur==1 then
        GUI:SetIsOnWithoutNotify(self.view.schemeToggle1,true)
        self:SchemeToggleChanged(self.view.schemeToggle1,message.cur,{true},true)
    elseif message.cur==2 then
        GUI:SetIsOnWithoutNotify(self.view.schemeToggle2,true)
        self:SchemeToggleChanged(self.view.schemeToggle2,message.cur,{true},true)
    end
    
    GUI:SetIsOnWithoutNotify(self.view.gemBtn,true)
end

function this:ClosePanel()

    GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLGemEquipUI/KLGemEquipUIPanel")
    self.equipPanel = nil
	GUI:UIPanel_Close("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel")
	GUI:UIPanel_Close("dev/outui/Equip/Panel/KLGemInlay/KLGemInlayPanel")
end

function this:OnClickGemCellImg1()
    InfoManager.gemSlateInfo:ChangeGemPosId(1)
    local tmpUI=GUI:GetUI("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel")
    if not tmpUI then
        GUI:UIPanel_Close("dev/outui/Equip/Panel/KLGemEquipUI/KLGemEquipUIPanel")
        self.equipPanel = nil
        GUI:UIPanel_Open("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel", nil, nil, { itemList = self:GetGemItems(), x = -482, y = 0, itemClick = self.ItemClick, callBackUI = self,bagType=E_GemInlayType.Gem })
    end
    local inlayGem=InfoManager.gemSlateInfo:GetCurActiveSchemeGem("1")
    SL:OpenTips("gems", inlayGem)
    GUI:SetActive(self.view.SelectImg1,true)
    GUI:SetActive(self.view.SelectImg2,false)
    GUI:SetActive(self.view.SelectImg3,false)
    
end

function this:OnClickGemCellImg2()
    InfoManager.gemSlateInfo:ChangeGemPosId(2)
    local tmpUI=GUI:GetUI("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel")
    if not tmpUI then
        GUI:UIPanel_Close("dev/outui/Equip/Panel/KLGemEquipUI/KLGemEquipUIPanel")
        self.equipPanel = nil
        GUI:UIPanel_Open("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel", nil, nil, { itemList = self:GetGemItems(), x = -482, y = 0, itemClick = self.ItemClick, callBackUI = self,bagType=E_GemInlayType.Gem })
    end
    local inlayGem=InfoManager.gemSlateInfo:GetCurActiveSchemeGem("2")
    SL:OpenTips("gems", inlayGem)
    GUI:SetActive(self.view.SelectImg1,false)
    GUI:SetActive(self.view.SelectImg2,true)
    GUI:SetActive(self.view.SelectImg3,false)
end

function this:OnClickGemCellImg3()
    InfoManager.gemSlateInfo:ChangeGemPosId(3)
    local tmpUI=GUI:GetUI("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel")
    if not tmpUI then
        GUI:UIPanel_Close("dev/outui/Equip/Panel/KLGemEquipUI/KLGemEquipUIPanel")
        self.equipPanel = nil
        GUI:UIPanel_Open("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel", nil, nil, { itemList = self:GetGemItems(), x = -482, y = 0, itemClick = self.ItemClick, callBackUI = self,bagType=E_GemInlayType.Gem })
    end
    local inlayGem=InfoManager.gemSlateInfo:GetCurActiveSchemeGem("3")
    SL:OpenTips("gems", inlayGem)

    GUI:SetActive(self.view.SelectImg1,false)
    GUI:SetActive(self.view.SelectImg2,false)
    GUI:SetActive(self.view.SelectImg3,true)
end

function this:OnClickSlateImg()
    InfoManager.gemSlateInfo:ChangeGemPosId(nil)
    local tmpUI=GUI:GetUI("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel")
    if not tmpUI then
        GUI:UIPanel_Close("dev/outui/Equip/Panel/KLGemEquipUI/KLGemEquipUIPanel")
        self.equipPanel = nil
        GUI:UIPanel_Open("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel", nil, nil, { itemList = self:GetSlateItems(), x = -482, y = 0, itemClick = self.ItemClick, callBackUI = self,bagType=E_GemInlayType.Slate })
    end
    local inlaySlate=InfoManager.gemSlateInfo:GetCurActiveSchemeGem(nil,true)
    SL:OpenTips("gems", inlaySlate)

end

function this:OnClickOptEquip()

    GUI:UIPanel_Close("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel")
    if not self.equipPanel then
        GUI:UIPanel_Open("dev/outui/Equip/Panel/KLGemEquipUI/KLGemEquipUIPanel",
                nil,
                nil,
                { x = -465, hideTips = true, callBack = self.CloseEquipUi,selectType = self.selectEquipType},
                true,function(equipPanel)
                    self.equipPanel = equipPanel
                end)
    end

end
function this:OnClickHelpBtn()
    local helpCfg=nil
    if self.curSelectGemInlayType==E_GemInlayType.Gem then
        helpCfg=SL:GetConfig("cfg_rule_text",1)
    else
        helpCfg=SL:GetConfig("cfg_rule_text",2)
    end
    if helpCfg then
        SL:CommonStrTipsMessage({title =helpCfg.menutxt,str=helpCfg.location})
    end
end
function this:OnClickAllGemsInfoBtn()
    GUI:UIPanel_Open("dev/outui/Equip/Panel/KLGemInlayAllInfo/KLGemInlayAllInfoPanel", nil, nil, { x = -465})
end

function this:RefreshRedPoint()
    -- local gemData = {}
    -- local slateData = {}
    -- local bagItemTabl = SL:GetMetaValue("BAG_DATA")[1]

    -- if bagItemTabl then
    --     for _, v in pairs(bagItemTabl) do
    --         if SL:HasConfig("cfg_equip_gem", v.cfgId, "id") then
    --             table.insert(gemData, v)
    --         end
    --         if SL:HasConfig("cfg_equip_stoneBoard", v.cfgId, "id") then
    --             table.insert(slateData, v)
    --         end
    --     end
    -- end

    -- GUI:SetActive(    self.view.redPointImg1,false)
    -- GUI:SetActive(    self.view.redPointImg2,false)
end

function this:Close()

end

return this
