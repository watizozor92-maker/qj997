---@class KLMountDisplayPanel:UIKmlLuaPanelBase
---@field view KLMountDisplayPanelView
local KLMountDisplayPanel = class(UIKmlLuaPanelBase)
local this =KLMountDisplayPanel
---创建时调用一次
function this:Init()
    self.attTxtList = {}
    self.mountAtt_all_item = {}
    self.showSkin = false
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if SL:GetIsWebGL() then
        GUI:setPositionX(self.view.closeBtn,-180)
    end
    GUI:setVisible(self.view.success, false)
    self:SetMount(self.args.mountId)
end

function this:SetMount(mountId)
    self.mountId = mountId
    ---@type cfg_mount_column
    local tbl = SL:GetConfig("cfg_mount",self.mountId,"id")
    --判断该坐骑是否已激活
    local mountData = InfoManager.mountInfo:GetMountData(mountId)
    local isActive = mountData ~= nil
    GUI:setVisible(self.view.Root_Active, not isActive)
    GUI:setVisible(self.view.Root_LevelUp, isActive)
    GUI:setVisible(self.view.Root_Skin, false)
    GUI:Text_setString(self.view.rideArea, tbl.setarea == 0 and "骑乘场景：<color=#5dE367>全图</color>" or "骑乘场景：野外")
    local skin
    if isActive then
        GUI:setContentSize(self.view.scroll,343,290)
        self:ShowLevelUpPage()
        if mountData.curSkin ~= 0 then
            ---@type cfg_mount_skin_column
            skin = mountData.curSkin
        end
        if self.mountId == InfoManager.mountInfo:GetDefaultMountId() then
            GUI:setVisible(self.view.btn_ride, false)
        else
            GUI:setVisible(self.view.btn_ride, true)
        end
    else
        GUI:setVisible(self.view.btn_ride, false)
        GUI:setContentSize(self.view.scroll,343,105)
        --显示激活道具
        self:ShowActivePage()
    end
    --self:ShowActivePage()
    --显示模型
    self:ShowModel(skin)
    --显示属性
    self:ShowAtts() 
    --判断是否有皮肤跟臻藏系列
    GUI:setVisible(self.view.btn_skin, InfoManager.mountInfo:GetMountSkins(mountId) ~= nil)
    GUI:setVisible(self.view.btn_fashionCollect, InfoManager.mountInfo:CheckRideSuit(tbl.itemId))
    --关闭皮肤界面显示装备
    if self.showSkin then
        self:ShowSkinPanel()
    end
    GUI:SetZIndex(self.view.btn_skin,220)
    GUI:SetZIndex(self.view.btn_fashionCollect,220)
   
end
function this:ShowModel(skin)
    ---@type cfg_mount_column
    local tbl = SL:GetConfig("cfg_mount",self.mountId)
    if skin then
        tbl = SL:GetConfig("cfg_mount",skin)
    end
    ---@type cfg_mount_model_column
    local mount_model_tbl = SL:GetConfig("cfg_mount_model",tbl.mountId,"id")
    ---@type cfg_mount_behaviour_column
    local behaviour_tbl = SL:GetConfigMultiKeys("cfg_mount_behaviour",tbl.motion,1,"id","state")
    local modelPath = mount_model_tbl.path
    local scale = tbl.scale2.. ",".. tbl.scale2 ..",".. tbl.scale2
    if not self.cur_mount_model then
        self.cur_mount_model = GUI:Model_Create(self.view.model,{
            id="cur_mount_model",
            mscale=scale,
            mrotate="0,200,0",
            x="0",
            y="-120",
            z="-300",
            a="00",
            src=modelPath,
            ani=behaviour_tbl.name,
        })
    else
        GUI:Model_setSrc(self.cur_mount_model, modelPath, scale)
    end
end

---切换皮肤
function this:ShowSkin(skin)
    
end

---显示属性
function this:ShowAtts()
    ---@type cfg_mount_column
    local tbl = SL:GetConfig("cfg_mount",self.mountId,"id")
    local mountData = InfoManager.mountInfo:GetMountData(self.mountId)
    local levelAtts = {}
    --if mountData then
    --    ---@type cfg_mount_levelUp_column
    --    local lvTbl = SL:GetConfigTwoKeys("cfg_mount_levelUp", tbl.type, mountData.level, "type", "level")
    --    ---@type cfg_mount_levelUp_column
    --    local nextLvTbl
    --    if SL:HasConfigTwoKeys("cfg_mount_levelUp", tbl.type, mountData.level+1, "type", "level") then
    --        nextLvTbl = SL:GetConfigTwoKeys("cfg_mount_levelUp", tbl.type, mountData.level+1, "type", "level")
    --    end
    --    levelAtts.attId = lvTbl.att[1]
    --    levelAtts.nowValue = lvTbl.att[2]
    --    levelAtts.nextValue = nextLvTbl and nextLvTbl.att[2] or lvTbl.att[2]
    --end
    self:RefreshAttInfoList(tbl.attribute, levelAtts, false)
end

---显示激活页面
function this:ShowActivePage()
    GUI:setVisible(self.view.Root_Active, true)
    ---@type cfg_mount_column
    local tbl = SL:GetConfig("cfg_mount", self.mountId)
    --显示激活道具
    GUI:Item_UpdataData(self.view.item_activeCost, {
        itemid = tbl.itemId
    })
    --GUI:setVisible(self.view.haveItem, SL:GetBagItemCount(tbl.itemId) <= 0)
end

--显示坐骑升级相关信息
function this:ShowLevelUpPage()
    local mountData = InfoManager.mountInfo:GetMountData(self.mountId)
    if not mountData then
        return
    end
    GUI:setVisible(self.view.Root_LevelUp, false)
    ---@type cfg_mount_column
    local tbl = SL:GetConfig("cfg_mount", self.mountId)
    ---@type cfg_mount_levelUp_column
    local lvTbl = SL:GetConfigTwoKeys("cfg_mount_levelUp", tbl.type, mountData.level, "type", "level")
    local isMaxLv = table.isNullOrEmpty(lvTbl.deplete) or tbl.limitedtype == 1
    GUI:setVisible(self.view.btn_LvUp, not isMaxLv)
    GUI:setVisible(self.view.costInfoTitle, not isMaxLv)
    GUI:setVisible(self.view.levelMaxTip, isMaxLv)
    if not isMaxLv then
        if not self.costMatItem then
            self.costMatItem = GUI:UIPanel_Open("dev/outui/OutCommon/Item/KLCommon/KLCommonItem", self.view.costInfo, self)
        end
        self.costMatItem:RefreshData({
            itemid = lvTbl.deplete[1],
            itemcustomcount = ToolFunc.GetRichTextByComparison(lvTbl.deplete[1],lvTbl.deplete[2]),
            width = 55,
            height = 55,
        })
    else
        if self.costMatItem then
            GUI:UIPanel_Close(_, self.costMatItem)
        end
        self.costMatItem = nil
    end
    if self.mountId == InfoManager.mountInfo:GetDefaultMountId() then
        GUI:setVisible(self.view.btn_ride, false)
        GUI:setPositionX(self.view.btn_LvUp, 0)
    else
        GUI:setVisible(self.view.btn_ride, true)
        GUI:setPositionX(self.view.btn_LvUp, 80)
        --GUI:setPositionX(self.view.btn_ride, isMaxLv and 0 or -80)
    end
    local endTime = mountData.endTime * 1000
    local nowTime = Time.GetServerTime()
    if tbl.limitedtype == 1 and endTime > nowTime then
        GUI:SetActive(self.view.text_limitTime, true)
        self:ShowTime(endTime)
    else
        GUI:SetActive(self.view.text_limitTime, false)
    end
end

function this:ShowTime(endTime)
    self.limitTimer = SL:Schedule(self.limitTimer, 0, 1, -1, function()
        local timeText = endTime - Time.GetServerTime()
        GUI:Text_setString(self.view.text_limitTime, "有效期：" .. GUIUtil.FormatTimeDHMS(timeText // 1000))
        if timeText <= 0 then
            GUI:Text_setString(self.view.text_limitTime, "")
            return
        end
    end)
end
---显示或者关闭皮肤界面
function this:ShowSkinPanel()
    if self.showSkin then
        GUI:UIPanel_Close("dev/outui/Mount/Panel/KLMountSkins/KLMountSkinsPanel")
       
        GUI:setVisible(self.view.Root_Skin, false)
        self:ShowLevelUpPage()
        self:ShowModel()
    else
        GUI:UIPanel_Open("dev/outui/Mount/Panel/KLMountSkins/KLMountSkinsPanel", _, _, self.mountId)
       
    end
    self.showSkin = not self.showSkin
    GUI:setVisible(self.view.skin_select, self.showSkin)
end

---购买皮肤
---@param skin cfg_mount_skin_column
function this:ShowBuyRideSkin(skin)
    if self.mountId then
        local mountData = InfoManager.mountInfo:GetMountData(self.mountId)
        if skin.skinid == 0 or skin.skinid == self.mountId then
            GUI:setVisible(self.view.Root_Skin, false)
            if mountData then
                GUI:setVisible(self.view.Root_Active, false)
                self:ShowLevelUpPage()
            else
                GUI:setVisible(self.view.Root_LevelUp, false)
                self:ShowActivePage()
            end
        elseif InfoManager.mountInfo:CheckRideOwnSkin(self.mountId, skin.skinid) then
            GUI:setVisible(self.view.Root_Skin, false)
            GUI:setVisible(self.view.Root_Active, false)
            self:ShowLevelUpPage()
        else
            GUI:setVisible(self.view.Root_Skin, true)
            GUI:setVisible(self.view.Root_LevelUp, false)
            GUI:setVisible(self.view.Root_Active, false)
            GUI:Item_UpdataData(self.view.item_skinNeed, {
                itemid = skin.money[1],
                itemcount = skin.money[2]
            })
            GUI:setVisible(self.view.btn_buySkin, mountData ~= nil)
        end
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn,self,self.OnClickCloseBtn)
    GUI:AddOnClickEvent(self.view.desBtn,self,self.OnClickDesBtn)
    GUI:AddOnClickEvent(self.view.item_activeCost, self, self.ShowActiveItemTips)
    GUI:AddOnClickEvent(self.view.btn_active, self, self.ActiveRide)
    GUI:AddOnClickEvent(self.view.btn_LvUp, self, self.LevelUpRide)
    GUI:AddOnClickEvent(self.view.btn_skin, self, self.ShowSkinPanel)
    GUI:AddOnClickEvent(self.view.btn_ride, self, self.UseRide)
    GUI:AddOnClickEvent(self.view.btn_buySkin, self, self.BuySkin)
    GUI:AddOnClickEvent(self.view.btn_collect, self, self.OnCollectBtn)

    SL:RegisterLUAEvent(LUA_EVENT_MOUNT_LEVEL_CHANGE, self.LUA_EVENT_MOUNT_LEVEL_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_SET_DEFAULT_RIDE, self.LUA_EVENT_SET_DEFAULT_RIDE, self)
    SL:RegisterLUAEvent(LUA_EVENT_MOUNT_BUY_SKIN_CHANGE, self.LUA_EVENT_MOUNT_BUY_SKIN_CHANGE, self)
end

function  this:OnClickCloseBtn()
    GUI:UIPanel_Close("dev/outui/Mount/Panel/KLMountStore/KLMountStorePanel")
    GUI:UIPanel_Close("dev/outui/Mount/Panel/KLMountDisplay/KLMountDisplayPanel")
    GUI:UIPanel_Close("dev/outui/Mount/Panel/KLMountSkins/KLMountSkinsPanel")
end

function this:OnClickDesBtn()
    GUI:UIPanel_Open("dev/outui/Mount/Panel/KLMountDes/KLMountDesPanel")
end

function this:OnCollectBtn()
    GUI:UIPanel_Open("dev/outui/Mount/Panel/KLMountCollect/KLMountCollectPanel")
    GUI:setVisible(self.view.btn_collect, false)
end

---显示激活道具的tips
function this:ShowActiveItemTips()
    if self.mountId then
        ---@type cfg_mount_column
        local tbl = SL:GetConfig("cfg_mount",self.mountId,"id")
        SL:OpenItemTips("", tbl.itemId)
    end
end
---激活当前坐骑
function this:ActiveRide()
    if self.mountId then
        ---@type cfg_mount_column
        local tbl = SL:GetConfig("cfg_mount",self.mountId,"id")
        local index = SL:GetSlotBaseOnCfgId(tbl.itemId)
        if not index then
            local cfg = SL:GetConfig("cfg_string", 412)
            local str = cfg and cfg.text or "条件未满足"
            SL:CommonTipsMessage({
                showTips = str, 
                ui = self
            })
            return
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ACTIVE_MOUNT, {idxOfBag = index})
    end
end
---升级坐骑
function this:LevelUpRide()
    if self.mountId then
        local mountData = InfoManager.mountInfo:GetMountData(self.mountId)
        ---@type cfg_mount_column
        local tbl = SL:GetConfig("cfg_mount",self.mountId,"id")
        ---@type cfg_mount_levelUp_column
        local lvTbl = SL:GetConfigTwoKeys("cfg_mount_levelUp", tbl.type, mountData.level, "type", "level")
        if lvTbl and lvTbl.deplete[1] then
            if SL:GetBagItemCount(lvTbl.deplete[1]) >= lvTbl.deplete[2] then
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UP_LEVEL_MOUNT, {id=self.mountId})
            else
               SL:TipMessage("材料不足", 1, NoticeType.NoticeMid)     
            end
        end
    end
end
---设置默认坐骑
function this:UseRide()
    if self.mountId then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SET_MOUNT, {id=self.mountId})
    end
end
---购买坐骑皮肤
function this:BuySkin()
    if not self.mountId or not InfoManager.mountInfo:GetMountData(self.mountId) then
        return
    end
    ---@type KLMountSkinsPanel
    local skinUI = GUI:GetUI("dev/outui/Mount/Panel/KLMountSkins/KLMountSkinsPanel")
    if skinUI then
        if not InfoManager.mountInfo:CheckRideOwnSkin(self.mountId, skinUI.nowSkin) then
            ---@type cfg_mount_skin_column
            local tbl = InfoManager.mountInfo:GetMountSkins(self.mountId)[skinUI.nowSkin]
            if SL:GetBagItemCount(tbl.money[1]) >= tbl.money[2] then
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ACTIVE_SKIN_MOUNT, {id = self.mountId, skinid = skinUI.nowSkin})  
            else
                SL:TipMessage("材料不足", 1, NoticeType.NoticeMid)
            end
        end
    end
end
---坐骑升级响应
function this:LUA_EVENT_MOUNT_LEVEL_CHANGE(_, id)
    if id == self.mountId then
        if self.timer then
            GUI:setVisible(self.view.success, false)
            SL:UnSchedule(self.timer)
        end
        GUI:setVisible(self.view.success, true)
        self.timer = SL:ScheduleOnce(1, function()
            if GUI:getVisible(self.view.root) then
                GUI:setVisible(self.view.success, false)
            end
            self.timer = nil
        end)
        self:ShowLevelUpPage()
        self:ShowAtts()
    end
end
---设置默认坐骑响应
function this:LUA_EVENT_SET_DEFAULT_RIDE()
    if self.mountId == InfoManager.mountInfo:GetDefaultMountId() then
        self:ShowLevelUpPage()
    end
end
---购买皮肤响应
function this:LUA_EVENT_MOUNT_BUY_SKIN_CHANGE(_, id)
    if self.mountId == id then
        GUI:setVisible(self.view.Root_Skin, false)
        GUI:setVisible(self.view.Root_Active, false)
        self:ShowLevelUpPage()
    end
end

function this:RefreshAttInfoList(attribute, levelAtts, showArrow)
    local attInfo = {}
    self.attTxtList = {}
    if next(levelAtts) then
        local containLevelAttId = false
        for i, v in pairs(attribute) do
            local attId = v[1]
            if attId == levelAtts.attId then
                containLevelAttId = true
                break
            end
        end
        if not containLevelAttId then
            table.insert(attribute, {levelAtts.attId, 0})
        end
    end
    for i, v in pairs(attribute) do
        local isSkip = false
        local attId = v[1]
        local attNum = v[2]
        local nextAttNum = v[2]
        if levelAtts.attId and levelAtts.attId == attId then
            attNum = v[2] + levelAtts.nowValue
            nextAttNum = v[2] + levelAtts.nextValue
        end
        ---@type cfg_att_info_column
        local tbl = SL:GetConfig("cfg_att_info",attId,"id")
        local attTxt
        local nextText
        if tbl.remarks ~= EAttrRemarkType.Number then
            attTxt = attNum/100 .."%"
            nextText = nextAttNum/100 .."%"
        else
            attTxt = tostring(attNum)
            nextText = tostring(nextAttNum)
        end
        if levelAtts.attId and levelAtts.attId == attId then
            nextText = "<color=#5Ed367>"..nextText.."</color>"
        end
        local attSingleInfo = {}
        if attId == 200011 then--最小
            attSingleInfo.name = "攻击力"
            attSingleInfo.pre = attTxt.."~"
            attSingleInfo.next = nextText.."~"
            attInfo[1] = attSingleInfo
        elseif attId == 200021 then--最大
            attSingleInfo.pre = attTxt
            attSingleInfo.next = nextText
            attInfo[2] = attSingleInfo
        elseif attId == 202021 then--最小
            attSingleInfo.name = "魔法攻击力"
            attSingleInfo.pre = attTxt.."~"
            attSingleInfo.next = nextText.."~"
            attInfo[3] = attSingleInfo
        elseif attId == 202011 then--最大
            attSingleInfo.pre = attTxt
            attSingleInfo.next = nextText
            attInfo[4] = attSingleInfo
        elseif attId == 205011 then--最小
            attSingleInfo.name = "诅咒攻击力"
            attSingleInfo.pre = attTxt.."~"
            attSingleInfo.next = nextText.."~"
            attInfo[5] = attSingleInfo
        elseif attId == 205021 then--最大
            attSingleInfo.pre = attTxt
            attSingleInfo.next = nextText
            attInfo[6] = attSingleInfo
        else
            attSingleInfo.showArrow = showArrow
            attSingleInfo.name = tbl.name
            attSingleInfo.pre = attTxt
            attSingleInfo.next = nextText
            table.insert(self.attTxtList,attSingleInfo)
            isSkip = true
        end
        local function Connect(attA, attB, arrow)
            return {name = attA.name, pre = attA.pre..attB.pre, showArrow = arrow, next = attA.next..attB.next}
        end
        if not isSkip then
            if attInfo[1] and attInfo[2] then
                table.insert(self.attTxtList,Connect(attInfo[1], attInfo[2], showArrow))
                attInfo[1] = nil
                attInfo[2] = nil
            elseif attInfo[3] and attInfo[4] then
                table.insert(self.attTxtList,Connect(attInfo[3], attInfo[4], showArrow))
                attInfo[3] = nil
                attInfo[4] = nil
            elseif attInfo[5] and attInfo[6] then
                table.insert(self.attTxtList,Connect(attInfo[5], attInfo[6], showArrow))
                attInfo[5] = nil
                attInfo[6] = nil
            end
        end
    end

    for i = 1, #self.mountAtt_all_item do
        GUI:UIPanel_Close("",self.mountAtt_all_item[i])
    end
    self.mountAtt_all_item = {}
    ---@type cfg_mount_column
    local tbl = SL:GetConfig("cfg_mount", self.mountId)
    local speed = tostring(tbl.speed)
    table.insert(self.attTxtList, {name="移动速度", pre = speed, next = speed, showArrow = showArrow})
    for i = 1, #self.attTxtList do
        local att = self.attTxtList[i]
        ---@type KLMountAttInfoItem
        local item = GUI:UIPanel_Open("dev/outui/Mount/Item/KLMountAttInfo/KLMountAttInfoItem",self.view.mount_att_info_list,self,{width=343},true)
        local nextStr = tbl.limitedtype == 1 and att.pre or att.next
        local preStr = tbl.limitedtype == 1 and "" or att.pre
        local isShowArrow = tbl.limitedtype ~= 1 and att.showArrow
        item:SetText(att.name, preStr, nextStr, isShowArrow)
        self.mountAtt_all_item[i] = item
    end
    --GUI:setPositionY(self.view.skillContainer,0)
    --self:ShowSkillInfo(tbl.skillID,tbl.skillLevel,tbl.mountEquip)
end

function this:ShowSkillInfo(skillId,level,mountEquip)
    GUI:setVisible(self.view.skillContainer,mountEquip ~= 1 and skillId~=0)
    if skillId ~= 0 then
        ---@type cfg_skill_info_column
        local tbl = SL:GetConfigMultiKeys("cfg_skill_info",skillId,level,"skillID","skillLevel")
        GUI:Image_loadTexture(self.view.skillIcon,tbl.icon,"Atlas/Skill_icon.spriteatlas")
        GUI:Text_setString(self.view.skillName,tbl.name.."    Lv."..level)
        GUI:Text_setString(self.view.skillDes,tbl.tips)
    end
end

function this:SetVisible(isVisible)
    GUI:setVisible(self.view.root,isVisible)
end

function this:GetVisible()
   return GUI:getVisible(self.view.root)
end

function this:Close()
    if self.timer then
        SL:UnSchedule(self.timer)
    end
    self.timer = nil
    
    if self.limitTimer then
        SL:UnSchedule(self.limitTimer)
    end
    self.limitTimer = nil
    SL.ShowMainPanel()
end

return this
