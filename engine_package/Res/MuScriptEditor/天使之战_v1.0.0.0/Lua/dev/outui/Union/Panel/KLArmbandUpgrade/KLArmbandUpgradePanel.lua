---@class KLArmbandUpgradePanel:UIKmlLuaPanelBase
---@field view KLArmbandUpgradePanelView
local KLArmbandUpgradePanel = class(UIKmlLuaPanelBase)
local this =KLArmbandUpgradePanel
---创建时调用一次
function this:Init()
end

function this:GetAllStarCount()
    local StarNum = 0
    local skillInfoTbl = SL:FindConfigs('cfg_gard_armbands')
    for i, v in ipairs(skillInfoTbl) do
        if v.armbandsStar > StarNum then
            StarNum = v.armbandsStar
        end
    end
    return StarNum
end

function this:SetStarDataList()
    local starnum = self:GetAllStarCount()
    GUI:DataListInitData(self.view.datalist_armbandstar, function()
        return starnum
    end, function(realIndex)
        return self:StarItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:StarItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:StarItemUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListUpdateData(self.view.datalist_armbandstar)
end
function this:StarItemGetFunc(realIndex)
end
function this:StarItemInitFunc(realIndex, kmlcontrol)
end
function this:StarItemUpdateFunc(realIndex, kmlcontrol)
    local index = realIndex+1
    local ico_star = GUI:GetChildControl(self.view.datalist_armbandstar,realIndex, 'ico_star')
    local armbandstar = 0
    if self.armbandTbl then
        armbandstar = self.armbandTbl[1].armbandsStar
    end
    GUI:SetActive(ico_star, index <= armbandstar)
end
--------------------------------------------------------------------------------------------
function this:SetArrDataList()
    --属性
    GUI:DataListInitData(self.view.arrData_list, function()
        return table.count(self.attInfos)
    end, function(realIndex)
        return self:AttItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:AttItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:AttItemUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListUpdateData(self.view.arrData_list)
end
function this:AttItemGetFunc(realIndex)
    local index = realIndex + 1
    local item = GUI:UIPanel_Open("dev/outui/Union/Item/KLUnionArmband/KLUnionArmbandItem", self.view.arrData_list, self, nil, true)
    if not self.armAttItems then
        self.armAttItems = {}
    end
    local kmlCtrl = item.view.root
    self.armAttItems[index] = item
    return kmlCtrl
end
function this:AttItemInitFunc(realIndex, kmlcontrol)
end
function this:AttItemUpdateFunc(realIndex, kmlcontrol)
    local index = realIndex + 1
    local item = self.armAttItems[index]
    local info = self.attInfos[index]
    item:UpdateUI(info)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL.HideMainPanel()
    self.selectTab = 1
    self.AnimTimer = nil
    self.reAnim = self.view.resultAnim
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_UNION_INFO)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_UNION_ARMBAND_INFO)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.costItem,self,self.costItemTipClick)
    GUI:AddOnClickEvent(self.view.costAdd,self,self.costAddTipClick)
    GUI:AddOnClickEvent(self.view.btnarmtip,self,self.BtnarmtipClick)
    GUI:AddOnClickEvent(self.view.CloseButton,self,self.CloseButtonClick)
    GUI:AddOnClickEvent(self.view.UpgradeBtn,self,self.UpgradeBtnClick)
    GUI:AddOnClickEvent(self.view.StrengthenBtn,self,self.StrengthenBtnClick)
    GUI:AddOnClickEvent(self.view.OperateBtn,self,self.OperateBtnClick)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_UNION_INFO, self.ResUnionInfo, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_SEND_UNION_ARMBAND_INFO, self.ResUnionAembandInfo, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_UNION_ARMBAND_LEVEL_UP, self.ResUnionAembandLevelup, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_UNION_ARMBAND_STRONG, self.ResUnionAembandStrong, self)

end

function this:ResUnionInfo(id,data)
    if data and data.unionarmband then
        self.unionlevel = tonumber(data.unionlevel)
        GUI:Image_loadTexture(self.view.armbandicon, string.format("Texture/log%s.png",data.unionarmband), "")
    else
        self.unionlevel = 1
    end
end

function this:ResUnionAembandInfo(id,data)
    self.AembandInfo = data
    if self.selectTab == 1 then
        self:UpgradeBtnClick()
        self:SetStarDataList()  --星级
    else
        self:StrengthenBtnClick()
    end
    self:SetArrDataList()  --属性
end

function this:ResUnionAembandLevelup(id,data)
    if self.AembandInfo and data then
        self.AembandInfo.level = tonumber(data)
        self:UpgradeBtnClick()  --默认显示升级UI
    end
end

function this:ResUnionAembandStrong(id,data)
    if self.AembandInfo and self.reAnim then
        if tonumber(data) > self.AembandInfo.strong then
            GUI:Image_loadTexture(self.reAnim,"strength_success" ,"Atlas/FG_Union.spriteatlas")
        else
            GUI:Image_loadTexture(self.reAnim,"strength_fail" ,"Atlas/FG_Union.spriteatlas")
        end
        GUI:SetActive(self.reAnim, true)
        if self.AnimTimer then
            SL:UnSchedule(self.AnimTimer)
            self.AnimTimer = nil
        end
        if self.AnimTimer == nil then
            self.AnimTimer = SL:ScheduleOnce(1, function()
                if self.reAnim then
                    GUI:SetActive(self.reAnim, false)
                end
                self.AnimTimer = nil
            end)
        end
        self.AembandInfo.strong = tonumber(data)
        self:StrengthenBtnClick()
    end
end

---道具/途径 提示
function this:costItemTipClick(id,event)
    SL:OpenTips(nil,self.costId)
end
function this:costAddTipClick(id,event)
    SL:CommonItemGetPath(nil, self.costId, nil, nil, self)
end

function this:BtnarmtipClick(id,event)
    SL:CommonStrTipsMessage({title="战盟臂章",str="1、战盟臂章可给玩家增加一些属性上的加成。\n2、可消耗战盟贡献对臂章进行升级，等级上限与当前所在战盟等级相关。\n3、离开战盟将对臂章进行冻结，失去所加属性，当加入新战盟后根据战盟等级解冻臂章属性"})
end

function this:CloseButtonClick(id,event)
    GUI:UIPanel_Close("dev/outui/Union/Panel/KLArmbandUpgrade/KLArmbandUpgradePanel")
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel")
    SL.ShowMainPanel()
end



----获取属性列表
function this:GetAttListData(curAtts,nextAtts,islast)
    local attInfos = {}
    for i, v in ipairs(curAtts) do
        if SL:HasConfig("cfg_att_info",v[1],"id") then
            local attdata = SL:FindConfigs("cfg_att_info","id",v[1])
            if attdata and attdata[1] then
                local data = {
                    des = attdata[1].name,
                    prenum = tostring(v[2]),
                }
                if not islast and nextAtts then
                    data = {
                        des = attdata[1].name,
                        prenum = tostring(v[2]),
                        nextnum = tostring(nextAtts[i][2]),
                    }
                end
                table.insert(attInfos,data)
            end
        end

    end
    return attInfos
end

--当前区间等级最大臂章name
function this:GetArmbandsNameByUnionlevel(unionlevel)
    local TblData = SL:GetConfigTable("cfg_gard_armbands")
    local taskdata = {}
    for i, v in ipairs(TblData) do
        if v.GuildRank and v.GuildRank[1] then
            local Lv = v.GuildRank[1]
            if Lv <= unionlevel then
                table.insert(taskdata,{unLv = Lv,armLv = v.GuildRank[2] })
            end
        end
    end

    table.sort(taskdata, function(a, b)
        return a.unLv > b.unLv
    end)
    local data = taskdata[1]
    if data then
        self.maxlevel = data.armLv
        local tbldata = SL:FindConfigs('cfg_gard_armbands', 'Level', data.armLv)
        return tbldata[1].armbandsName
    end
    return nil
end


---显示升级UI
function this:UpgradeBtnClick(id,event)
    GUI:setPosition(self.view.OperateBtn, 0, -47)
    GUI:setPosition(self.view.costBg, -20, 0)
    GUI:setVisible(self.view.Text_Strengthen, false)
    if SL:HasConfig("cfg_gard_armbands",self.AembandInfo.level,"Level") then
        self.armbandTbl = SL:FindConfigs('cfg_gard_armbands', 'Level', self.AembandInfo.level)
    end
    self.selectTab = 1
    self.iscanUp = false
    self.maxlevel = self.armbandTbl[1].GuildRank[2]
    GUI:Image_loadTexture(self.view.UpgradeBtn,"btn_upgrade_select" ,"Atlas/TS_Union.spriteatlas")
    GUI:Image_loadTexture(self.view.StrengthenBtn,"btn_strength" ,"Atlas/TS_Union.spriteatlas")
    GUI:Text_setString(self.view.arr_title, "臂章属性")
    GUI:Button_setTitleText(self.view.OperateBtn,"升级")

    if self.armbandTbl then
        local curAtts = self.armbandTbl[1].levelupAttribute
        ---基础信息
        local armbandsName = self:GetArmbandsNameByUnionlevel(self.unionlevel)
        if armbandsName then
            local str = "当前<color=#00ff00>战盟等级"..self.unionlevel.."</color>"..",臂章上限<color=#ff2323>"..armbandsName.."</color>"
            GUI:Text_setString(self.view.armbandtip, str)
        else
            GUI:Text_setString(self.view.armbandtip, "")
        end
        GUI:Text_setString(self.view.armbandname, self.armbandTbl[1].armbandsName)

        ---属性
        self.nextdata = nil
        if SL:HasConfig("cfg_gard_armbands",self.armbandTbl[1].Level+1,"Level") then
            self.nextdata = SL:FindConfigs("cfg_gard_armbands",'Level',self.armbandTbl[1].Level+1)
            local nextAtts = self.nextdata[1].levelupAttribute
            self.attInfos = self:GetAttListData(curAtts,nextAtts,false)
        else
            self.attInfos = self:GetAttListData(curAtts,nil,true)
        end

        ---消耗
        if self.nextdata then
            self.costId = self.nextdata[1].levelupCost[1]
            local needCount = self.nextdata[1].levelupCost[2]
            local itemdata = SL:FindConfigs('cfg_item', 'id', self.costId)
            local ownCount = SL:GetMetaValue(EMetaVarGetKey.MONEY, MUEResourceType.UnionGx)
            --local ownCount = SL:GetBagItemCount(self.costId)
            local str = "<color=#ff2323>"..ownCount.."/"..needCount.."</color>"
            if ownCount >= needCount then
                self.iscanUp = true
                str = "<color=#00ff00>"..ownCount.."/"..needCount.."</color>"
            end
            GUI:Text_setString(self.view.costName, itemdata[1].name)
            GUI:Item_setItemId(self.view.costItem, self.costId)
            GUI:Text_setString(self.view.costNum, str)
        end

    end

    ---显示
    GUI:SetActive(self.view.armbandtip, true)
    GUI:SetActive(self.view.resultAnim, false)
    GUI:SetActive(self.view.resultLv, false)
    GUI:SetActive(self.view.resultAnimText, false)
    GUI:SetActive(self.view.KmlEquipReborn, false)
    GUI:SetActive(self.view.layout_armbandstar, true)
    GUI:SetActive(self.view.btntip, false)
    ---是否已满级
    GUI:SetActive(self.view.costBg, not (self.nextdata==nil))
    GUI:SetActive(self.view.OperateBtn, not (self.nextdata==nil))
    GUI:SetActive(self.view.fulllevel,  self.nextdata==nil)



    ---属性,星级刷新
    GUI:DataListUpdateData(self.view.arrData_list)
    GUI:DataListUpdateData(self.view.datalist_armbandstar)


end
---显示强化UI
function this:StrengthenBtnClick(id,event)
    GUI:setPosition(self.view.OperateBtn, 0, -27)
    GUI:setPosition(self.view.costBg, -20, 20)
    GUI:setVisible(self.view.Text_Strengthen, true)
    local playerLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    if SL:HasConfig("cfg_gard_bandsStrength",self.AembandInfo.strong,"level") then
        self.armStrengthTbl = SL:FindConfigs('cfg_gard_bandsStrength', 'level', self.AembandInfo.strong)
    end
    self.selectTab = 2
    self.iscanStrengthen = false
    self.iscanStrengLv = true
    GUI:Image_loadTexture(self.view.UpgradeBtn,"btn_upgrade" ,"Atlas/TS_Union.spriteatlas")
    GUI:Image_loadTexture(self.view.StrengthenBtn,"btn_strength_select" ,"Atlas/TS_Union.spriteatlas")
    GUI:Text_setString(self.view.arr_title, "强化属性")
    GUI:Button_setTitleText(self.view.OperateBtn,"强化")



    if self.armStrengthTbl then
        ---失败退到
        local curAtts = self.armStrengthTbl[1].strengthenAttribute
        --local levelFailure1 = self.armStrengthTbl[1].levelFailure1
        --local StrengthLevel = self.armStrengthTbl[1].level
        --if levelFailure1 and levelFailure1 > 0 and levelFailure1 < StrengthLevel then
        --    GUI:SetActive(self.view.btntip, true)
        --    GUI:Text_setString(self.view.btntip, "失败退到"..levelFailure1.."级")
        --else
        --    ---空或大于等于当前等级=不退回 停留在当前等级
        --    GUI:SetActive(self.view.btntip, false)
        --end

        ---成功率
        local Probalv = self.armStrengthTbl[1].strengthenProbability / 10000
        local successLv = math.ceil(Probalv *100) .."%"
        GUI:Text_setString(self.view.resultAnimText, successLv)

        ---属性
        self.nextStrengthdata = nil
        if SL:HasConfig("cfg_gard_bandsStrength",self.armStrengthTbl[1].level+1,"level") then
            self.nextStrengthdata = SL:FindConfigs("cfg_gard_bandsStrength",'level',self.armStrengthTbl[1].level+1)
            local nextAtts = self.nextStrengthdata[1].strengthenAttribute
            self.attInfos = self:GetAttListData(curAtts,nextAtts,false)
            ---成功率
            local Probalv = self.nextStrengthdata[1].strengthenProbability / 10000
            local successLv = math.ceil(Probalv *100) .."%"
            GUI:Text_setString(self.view.resultAnimText, successLv)
        else
            self.attInfos = self:GetAttListData(curAtts,nil,true)
        end

        ---消耗
        if self.nextStrengthdata then
            local levelLimit = self.nextStrengthdata[1].playerLevelLimit
            self.costId = self.nextStrengthdata[1].strengthCost[1]
            local needCount = self.nextStrengthdata[1].strengthCost[2]
            --local ownCount = SL:GetMetaValue(EMetaVarGetKey.MONEY, MUEResourceType.UnionGx)
            local ownCount = SL:GetBagItemCount(self.costId)
            local itemdata = SL:FindConfigs('cfg_item', 'id', self.costId)
            local str = "<color=#ff2323>"..ownCount.."/"..needCount.."</color>"
            if ownCount >= needCount then
                self.iscanStrengthen = true
                str = "<color=#00ff00>"..ownCount.."/"..needCount.."</color>"
            end
            if levelLimit and levelLimit > playerLevel then
                self.iscanStrengLv = false
                GUI:Text_setString(self.view.btntip, "角色达到"..levelLimit.."级可强化")
            else
                GUI:Text_setString(self.view.btntip, "")
            end
            GUI:Text_setString(self.view.costName, itemdata[1].name)  --臂章宝石
            GUI:Text_setString(self.view.costNum, str)
            GUI:Item_setItemId(self.view.costItem, self.costId)

            --GUI:setPosition(self.view.strengthIntro,-120,10)
            --GUI:setPosition(self.view.preLevel,-10,-10)

            GUI:Text_setString(self.view.preLevel, "+"..self.armStrengthTbl[1].level)
            GUI:Text_setString(self.view.nextLevel, "+"..self.armStrengthTbl[1].level+1)
        else
            --GUI:setPosition(self.view.strengthIntro,-60,10)
            --GUI:setPosition(self.view.preLevel,40,-10)
            GUI:Text_setString(self.view.btntip, "")
            GUI:Text_setString(self.view.preLevel, "+"..self.armStrengthTbl[1].level)
            GUI:Text_setString(self.view.nextLevel, "")
        end

    end

    ---显示
    GUI:SetActive(self.view.KmlEquipReborn, true)
    GUI:SetActive(self.view.layout_armbandstar, false)
    GUI:SetActive(self.view.armbandtip, false)
    ---是否已满级
    GUI:SetActive(self.view.costBg, not (self.nextStrengthdata==nil))
    GUI:SetActive(self.view.OperateBtn, not (self.nextStrengthdata==nil))
    GUI:SetActive(self.view.fulllevel,  self.nextStrengthdata==nil)
    GUI:SetActive(self.view.btntip, not (self.nextStrengthdata==nil))
    GUI:SetActive(self.view.resultLv, not (self.nextStrengthdata==nil))
    GUI:SetActive(self.view.resultAnimText, not (self.nextStrengthdata==nil))
    GUI:SetActive(self.view.arrow, not (self.nextStrengthdata==nil))

    ---属性刷新
    GUI:DataListUpdateData(self.view.arrData_list)
end


---升级/强化 提交判断消息
function this:OperateBtnClick(id,event)
    if self.selectTab ==1 then
        local isMaxlevel = self.armbandTbl and self.maxlevel and self.maxlevel > self.armbandTbl[1].Level
        local uplevel = self:GetArmbandsNameByUnionlevel(self.unionlevel) == nil
        if isMaxlevel or uplevel then
            if self.iscanUp then
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UNION_ARMBAND_LEVEL_UP)
            else
                SL:TipMessage( SL:GetConfig('cfg_string',282).text, 1, NoticeType.NoticeMid )--"道具不足！",
            end
        else
            SL:TipMessage( SL:GetConfig('cfg_string',283).text,1, NoticeType.NoticeMid )--"臂章已达到当前等级上限", 
        end
    else
        if self.iscanStrengthen then
            if self.iscanStrengLv then
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UNION_ARMBAND_STRONG)
            else
                SL:TipMessage( SL:GetConfig('cfg_string',249).text,1, NoticeType.NoticeMid )--"等级不足！", 
            end
        else
            SL:TipMessage( SL:GetConfig('cfg_string',282).text,1, NoticeType.NoticeMid )--"道具不足！", 
        end
    end
end

function this:Close()
    GUI:UIPanel_Close("dev/outui/Union/Panel/KLArmbandUpgrade/KLArmbandUpgradePanel")
end

return this
