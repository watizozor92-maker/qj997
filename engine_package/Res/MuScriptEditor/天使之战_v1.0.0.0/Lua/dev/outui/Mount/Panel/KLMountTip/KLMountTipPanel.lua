---@class KLMountTipPanel:UIKmlLuaPanelBase
---@field view KLMountTipPanelView
---@field mountTbl cfg_mount_column
local KLMountTipPanel = class(UIKmlLuaPanelBase)
local this =KLMountTipPanel
---创建时调用一次
function this:Init()
    if self.args.equip_pos and self.args.equip_pos == "bag" then
        GUI:setAnchorPoint(self.view.root, 2, 0)
        GUI:setPositionX(self.view.root,-450)
        GUI:setVisible(self.view.cancelBtn, true)
        GUI:setVisible(self.view.putOnBtn, true)
    else
        GUI:setVisible(self.view.cancelBtn, false)
        GUI:setVisible(self.view.putOnBtn, false)
    end
    if self.args.info and self.args.info.hideMask then
        GUI:setVisible(self.view.bgMask, false)
    else
        GUI:setVisible(self.view.bgMask, true)
    end
    if self.args.info and self.args.info.isRight then
        GUI:setAnchorPoint(self.view.root, 2, 0)
    end
    if self.args.info and self.args.info.posX then
        GUI:setPositionX(self.view.root,self.args.info.posX)
    end
    --计算高度
--[[    local x_1,y_1 = GUI:getSizeDelta(self.view.bg)
    local str_height = y_1 + 20
    if str_height > 310 then
        str_height = 310
    end
    local all_add = str_height - 180
    local bg_h = 434 + all_add
    EquipFunc.tipsHeight = bg_h
    ]]
--[[    local item = SL:GetConfig("cfg_item",self.args.cfgId)
    local itemInfo = SL:GetPosItemInfo(self.args.equip_pos, self.args.cfgId, self.args.id)
    if item.subType == E_ItemSubType_Equip.PriestHorse then
        if self.args.data and self.args.data.level ~= 0 then
            self.level = self.args.data.level
            ---@type cfg_equip_priest_column
            local tbl = InfoManager.mountInfo:GetBlackStallionByTypeAndLevel(self.level)
            if tbl then
                GUI:Text_setString(self.view.expTxt, "经验值:"..tostring(self.args.data.experience).."/"..tbl.hawkExp)
                GUI:Text_setString(self.view.levelTxt, "等级:"..self.args.data.level)
            end
        else
            if itemInfo and itemInfo.itemExtInfo and itemInfo.itemExtInfo.equipExtInfo and itemInfo.itemExtInfo.equipExtInfo.level ~= 0 then
                self.level = itemInfo.itemExtInfo.equipExtInfo.level
                ---@type cfg_equip_priest_column
                local tbl = InfoManager.mountInfo:GetBlackStallionByTypeAndLevel(self.level)
                if tbl then
                    GUI:Text_setString(self.view.expTxt, "经验值:"..tostring(itemInfo.itemExtInfo.equipExtInfo.currentExperience).."/"..tbl.hawkExp)
                    GUI:Text_setString(self.view.levelTxt, "等级:"..itemInfo.itemExtInfo.equipExtInfo.level)
                end
            end
        end
    else
        GUI:setVisible(self.view.expTxt,false)
        GUI:setVisible(self.view.levelTxt,false)
    end]]
    GUI:setVisible(self.view.expTxt,false)
    GUI:setVisible(self.view.levelTxt,false)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.bgMask,self,self.OnClickCancelBtn)
    GUI:AddOnClickEvent(self.view.cancelBtn,self,self.OnClickCancelBtn)
    GUI:AddOnClickEvent(self.view.putOnBtn,self,self.OnClickPutOnBtn)
--[[    )
    GUI:AddOnClickEvent(self.view.takeOffBtn,self,self.OnClickTakeOffBtn)
    GUI:AddOnClickEvent(self.view.putOnBtn,self,self.OnClickPutOnBtn)
    GUI:AddOnClickEvent(self.view.putOnStoreBtn,self,self.OnClickPutOnStoreBtn)
    GUI:AddOnClickEvent(self.view.takeOutStoreBtn,self,self.OnClickTakeOutStoreBtn)]]
end

function this:OnClickCancelBtn()
    GUI:UIPanel_Close("dev/outui/Mount/Panel/KLMountTip/KLMountTipPanel")
end

function this:OnClickPutOnBtn()
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    if self.mountTbl then
        local mountData = InfoManager.mountInfo:GetMountData(self.mountTbl.mountId)
        if mountData ~= nil then
            if self.mountTbl.limitedtype ~= 1 then
                local tips = SL:GetConfig("cfg_string", 38001)
                SL:TipMessage(tips.text, 1, NoticeType.NoticeLeftBottom)
                return
            end
            local index = SL:GetSlotBaseOnCfgId(self.mountTbl.itemId)
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ACTIVE_MOUNT, {idxOfBag = index})
        else
            GUI:UIPanel_Open("dev/outui/Mount/Panel/KLMountStore/KLMountStorePanel", _, _, {itemId = self.args.cfgId})
        end
    end
    self:OnClickCancelBtn()
end

--[[

function this:OnClickTakeOffBtn()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MOUNT_STORE_TO_BAG,{self.mountTbl.id,0})
    self:OnClickCancelBtn()
end

function this:OnClickPutOnBtn()
    local BagIndex = SL:GetBagIndex(self.args.id)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MOUNT_BAG_TO_STORE,{BagIndex,self.mountTbl.itemId})
    self:OnClickCancelBtn()
end

function this:OnClickPutOnStoreBtn()
    local BagIndex = SL:GetBagIndex(self.args.id)
    SL.Equip:ReqBagPutStoreButtonMessage(BagIndex, SL:GetDepotsCurPage())
    self:OnClickCancelBtn()
end

function this:OnClickTakeOutStoreBtn()
    local storeIndex = SL:GetDepotsIndex(self.args.id)
    SL.Equip:ReqStoreTakeButtonMessage(storeIndex)
    self:OnClickCancelBtn()
end]]

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
--[[    if self.args.equip_pos == "bag" then
        self.args.type = EMountTipType.BagUIOpen
    elseif self.args.equip_pos == "depots" then
        self.args.type = EMountTipType.StoreUIOpen
    elseif not self.args.type then
        self.args.type = EMountTipType.OtherUIOpen
    end
    local panel = GUI:GetUI("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel")
    ]]
--[[    GUI:setVisible(self.view.cancelBtn, self.args.type ~= EMountTipType.OtherUIOpen)
    GUI:setVisible(self.view.takeOffBtn,self.args.type == EMountTipType.MountUIOpen)
    GUI:setVisible(self.view.putOnBtn,self.args.type == EMountTipType.BagUIOpen and not panel)
    GUI:setVisible(self.view.putOnStoreBtn,self.args.type == EMountTipType.BagUIOpen and panel)
    GUI:setVisible(self.view.takeOutStoreBtn,self.args.type == EMountTipType.StoreUIOpen)
    ]]
    local tblList =SL:GetConfigTable("cfg_mount")
    local cfgId = SL:GetItemBindCfgId(self.args.cfgId)
    ---@param v cfg_mount_column
    for i, v in pairs(tblList) do
        if cfgId == v.itemId then
            self.mountTbl = v
            break
        end
    end
    --self.mountTbl = SL:GetConfig("cfg_mount", self.args.mountId)
    if not self.mountTbl then
        logError("cfg_mount not exist itemId = ",cfgId)
        return
    end
    
    ---@type cfg_item_column
    local itemTbl = SL:GetConfig("cfg_item", self.args.cfgId,"id")
    ---@type cfg_color_column
    local tbl = SL:GetColorCfg(itemTbl.color)
    GUI:Text_setString(self.view.title,GUIUtil.GetColorText(itemTbl.name,tbl and tbl.color or ""))
    ---@type cfg_mount_model_column
    local mount_model_tbl = SL:GetConfig("cfg_mount_model",self.mountTbl.mountId,"id")
    ---@type cfg_model_charactor_column
    local model_tbl = SL:GetConfig("cfg_model_charactor",itemTbl.shape[1],"id")
    ---@type cfg_mount_behaviour_column
    local behaviour_tbl = SL:GetConfigMultiKeys("cfg_mount_behaviour",self.mountTbl.motion,1,"id","state")
    GUI:Model_setSrc(self.view.item_model,model_tbl.path)
    GUI:SetEulerAngles(self.view.item_model,model_tbl.inrotate[1],model_tbl.inrotate[2],model_tbl.inrotate[3])
    GUI:setScale(self.view.item_model,model_tbl.inscale)
    --坐骑模型
    GUI:HideAllChilds(self.view.mount_model)
    self.cur_mount_model = GUI:Model_Create(self.view.mount_model,{
        id="cur_mount_model",
        mscale=self.mountTbl.scale2.. ",".. self.mountTbl.scale2 ..",".. self.mountTbl.scale2,
        mrotate="0,200,0",
        x="0",
        y="-120",
        z="0",
        a="00",
        src=mount_model_tbl.path,
        ani=behaviour_tbl.name,
    })
    
    self:RefreshAttInfoList(self.mountTbl.attribute)
--[[    if itemTbl.subType == E_ItemSubType_Equip.PriestHorse then
        ---@type cfg_equip_priest_column
        local attr = InfoManager.mountInfo:GetBlackStallionAttr(self.level)
        self:RefreshSpecializedAttInfoList(attr)
        if self.mountTbl.skillID ~= 0 then
            self:RefreshSkillTipsInfoList(self.mountTbl.skillID,self.mountTbl.skillLevel)
        end
    end]]
end


function this:RefreshAttInfoList(attribute)
    local attInfo = {}
    local attTxtList = {}
    GUI:HideAllChilds(self.view.attList)
    table.insert(attribute,{318011,self.mountTbl.speed})
    for i, v in pairs(attribute) do
        local isSkip = false
        ---@type cfg_att_info_column
        local tbl = SL:GetConfig("cfg_att_info",v[1],"id")
        local attTxt
        if tbl.remarks ~= EAttrRemarkType.Number then
            attTxt = v[2]/100 .."%"
        else
            attTxt = v[2]
        end
        if v[1] == 200011 then--最小
            attInfo[1] = "攻击力："..attTxt.."~"
        elseif v[1] == 200021 then--最大
            attInfo[2] = attTxt
        elseif v[1] == 202021 then--最小
            attInfo[3] = "魔法攻击力："..attTxt.."~"
        elseif v[1] == 202011 then--最大
            attInfo[4] = attTxt
        elseif v[1] == 205011 then--最小
            attInfo[5] = "诅咒攻击力："..attTxt.."~"
        elseif v[1] == 205021 then--最大
            attInfo[6] = attTxt
        else
            attTxt = tbl.name.."：" ..attTxt
            if v[1] == 313012 or  v[1] == 311012 or  v[1] == 318022 then
                attTxt = GUIUtil.GetColorText(attTxt,"#4ba7e8")
            end
            table.insert(attTxtList,attTxt)
            isSkip = true
        end
        
        if not isSkip then
            if attInfo[1] and attInfo[2] then
                table.insert(attTxtList,attInfo[1]..attInfo[2])
                attInfo[1] = nil
                attInfo[2] = nil
            elseif attInfo[3] and attInfo[4] then
                table.insert(attTxtList,attInfo[3]..attInfo[4])
                attInfo[3] = nil
                attInfo[4] = nil
            elseif attInfo[5] and attInfo[6] then
                table.insert(attTxtList,attInfo[5]..attInfo[6])
                attInfo[5] = nil
                attInfo[6] = nil
            end
        end
    end
    table.remove(attribute,#attribute)
    for i = 1, #attTxtList do
        GUI:Text_Create(self.view.attList, {
            id = "attTxt",
            text = attTxtList[i],
            width = 295,
            height = 20,
            ta="02",
            x = 0,
            y = 0,
        })
    end
end

function this:RefreshSpecializedAttInfoList(attribute)
    local attInfo = {}
    local attTxtList = {}
    for i, v in pairs(attribute) do
        local isSkip = false
        ---@type cfg_att_info_column
        local tbl = SL:GetConfig("cfg_att_info",v[1],"id")
        local attTxt
        if tbl.remarks ~= EAttrRemarkType.Number then
            attTxt = v[2]/100 .."%"
        else
            attTxt = v[2]
        end
        
        if v[1] == 200011 then--最小
            attInfo[1] = "攻击力："..attTxt.."~"
        elseif v[1] == 200021 then--最大
            attInfo[2] = attTxt
        elseif v[1] == 202021 then--最小
            attInfo[3] = "魔法攻击力："..attTxt.."~"
        elseif v[1] == 202011 then--最大
            attInfo[4] = attTxt
        elseif v[1] == 205011 then--最小
            attInfo[5] = "诅咒攻击力："..attTxt.."~"
        elseif v[1] == 205021 then--最大
            attInfo[6] = attTxt
        else
            attTxt = tbl.name.."：" ..attTxt
            table.insert(attTxtList,attTxt) 
            isSkip = true
        end

        if not isSkip then
            if attInfo[1] and attInfo[2] then
                table.insert(attTxtList,attInfo[1]..attInfo[2])
                attInfo[1] = nil
                attInfo[2] = nil
            elseif attInfo[3] and attInfo[4] then
                table.insert(attTxtList,attInfo[3]..attInfo[4])
                attInfo[3] = nil
                attInfo[4] = nil
            elseif attInfo[5] and attInfo[6] then
                table.insert(attTxtList,attInfo[5]..attInfo[6])
                attInfo[5] = nil
                attInfo[6] = nil
            end
        end
    end
    
    for i = 1, #attTxtList do
        GUI:Text_Create(self.view.attList, {
            id = "attTxt",
            text =  GUIUtil.GetColorText(attTxtList[i],"#ffff00") ,
            width = 295,
            height = 20,
            ta="02",
            x = 0,
            y = 0,
        }) 
    end
end

function this:RefreshSkillTipsInfoList(skillId,level)
    local attTxtList = {}
    ---@type cfg_skill_info_column
    local info =  SL:GetConfigMultiKeys('cfg_skill_info', skillId, level, 'skillID', 'skillLevel')
    table.insert(attTxtList,"坐骑技能")
    table.insert(attTxtList,info.name .. level .. "级")
    table.insert(attTxtList,info.tips)
    for i = 1, #attTxtList do
        GUI:Text_Create(self.view.attList, {
            id = "attTxt",
            text =  GUIUtil.GetColorText(attTxtList[i],"#4ba7e8") ,
            width = 295,
            height = 20,
            ta="00",
            x = 0,
            y = 0,
            horwrap="1"
        })
    end
   
end

function this:Close()
end

return this
