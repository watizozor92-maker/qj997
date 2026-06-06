---@class KLEquipRegenerateUIPanel:UIKmlLuaPanelBase
---@field view KLEquipRegenerateUIPanelView
--- kml代码lua化 会有较多冗余代码
local KLEquipRegenerateUIPanel = class(UIKmlLuaPanelBase)
local this =KLEquipRegenerateUIPanel
---创建时调用一次
function this:Init()
    self.equipPanel = GUI:UIPanel_Open("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel",nil,nil, {x=-465, hideTips=true, callBack=self.CloseEquipUi})
    self.equipIndex = nil
    self.equipInfo = nil
    self.xilianList = {}
    self.currentAttList = {}

    self.AllCiTiao = {}
    GUI:DataListInitData(self.view.datalist_yulan, function()
        return self:AllCountFunc()
    end, function(realIndex)
        return self:AllGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:AllInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:AllUpdateFunc(realIndex, kmlcontrol)
    end)

    GUI:DataListInitData(self.view.datalist_current, function()
        return self:CurrentCountFunc()
    end, function(realIndex)
        return self:CurrentGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:CurrentInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:CurrentUpdateFunc(realIndex, kmlcontrol)
    end)

    GUI:DataListInitData(self.view.datalist_new, function()
        return self:NewCountFunc()
    end, function(realIndex)
        return self:NewGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:NewInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:NewUpdateFunc(realIndex, kmlcontrol)
    end)

    self.consume = {}
    GUI:DataListInitData(self.view.cost_list, function()
        return self:ConsumeCountFunc()
    end, function(realIndex)
        return self:ConsumeGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:ConsumeInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:ConsumeUpdateFunc(realIndex, kmlcontrol)
    end)

    self.jinhua_list = {}
    GUI:DataListInitData(self.view.datalist_jinhua, function()
        return self:JinHuaCiTiaoCountFunc()
    end, function(realIndex)
        return self:JinHuaCiTiaoGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:JinHuaCiTiaoInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:JinHuaCiTiaoUpdateFunc(realIndex, kmlcontrol)
    end)

    self.jinhua_consume = {}
    GUI:DataListInitData(self.view.jinhua_cost_list, function()
        return self:JinHuaConsumeCountFunc()
    end, function(realIndex)
        return self:JinHuaConsumeGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:JinHuaConsumeInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:JinHuaConsumeUpdateFunc(realIndex, kmlcontrol)
    end)
    self.lock_list = {0,0,0,0,0,0,0,0,0,0}
    self.is_xilian = true
    GUI:setVisible(self.view.xilian_panel,false)
    GUI:setVisible(self.view.jinhua_panel,false)
    GUI:Text_setString(self.view.equipName, "")
    GUI:Text_setString(self.view.equipName2, "")
    GUI:Text_setString(self.view.equipName_yulan, "")
    self:SelectXilian()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.equipIndex = nil
    self:SelectEquip()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseButton, self, self.CloseButton)
    GUI:AddOnClickEvent(self.view.yulan_btn, self, self.YuLan)
    GUI:AddOnClickEvent(self.view.yulan_close_btn, self, self.YuLanClose)
    GUI:AddOnClickEvent(self.view.btn_xilian, self, self.SelectXilian)
    GUI:AddOnClickEvent(self.view.btn_jinhua, self, self.SelectJingHua)
    GUI:AddOnClickEvent(self.view.xilian_btn, self, self.XiLian)
    GUI:AddOnClickEvent(self.view.tihuan_btn, self, self.TiHuan)
    GUI:AddOnClickEvent(self.view.jinhua_btn, self, self.JinHua)

    SL:RegisterLUAEvent(LUA_EVENT_EQUIP_GRID_CLICK, self.LUA_EVENT_EQUIP_GRID_CLICK, self)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_UP_REGENERATION_ATTR,self.RES_UP_REGENERATION_ATTR,self)      --响应上一次再生词条洗练数据
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_EQUIP_REGENERATION,self.RES_EQUIP_REGENERATION,self)          --响应装备再生
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_REPLACE_REGENERATION_ATTR,self.RES_REPLACE_REGENERATION_ATTR,self)   --响应替换再生属性
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_STRENGTH_REGENERATION_ATTR,self.RES_STRENGTH_REGENERATION_ATTR,self)   --响应强化再生属性

    SL:RegisterLUAEvent(LUA_EVENT_FORGE_GROUP_PANEL_CLOSE, self.CloseButton, self)
end
 

function this:CloseEquipUi()
    GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipRegenerateUI/KLEquipRegenerateUIPanel")
end

function this:closeMask()
    GUI:setVisible(self.view.equip_show_tips, false)
end


function this:CloseButton()
    GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipRegenerateUI/KLEquipRegenerateUIPanel")
end

function this:Close()
    if self.coHide then
        SL:UnSchedule(self.coHide)
        self.coHide = nil
    end
end

function this:SelectXilian()
    self.is_xilian = true
    GUI:setVisible(self.view.xilian_panel,true)
    GUI:setVisible(self.view.jinhua_panel,false)
    GUI:setVisible(self.view.btn_xilian_select,true)
    GUI:setVisible(self.view.btn_jinhua_select,false)
    GUI:setVisible(self.view.xilian_top,true)
    GUI:setVisible(self.view.jinhua_top,false)
    GUI:setVisible(self.view.yulan_panel,false)
    
    if not self.equipInfo then
        GUI:setVisible(self.view.lock,false)
        GUI:setVisible(self.view.info_panel,false)
        return
    end
    local strengthLevel = EquipFunc.GetEquipStrengthLevel(self.equipInfo) 
    local tbl = SL:GetConfig('cfg_equip_regeneration', self.equipInfo.cfgId)
    if strengthLevel < tbl.condition then
        GUI:setVisible(self.view.lock,true)
        GUI:setVisible(self.view.info_panel,false)
    else
        GUI:setVisible(self.view.lock,false)
        GUI:setVisible(self.view.info_panel,true)
        self:UpdateCurrentCiTiao()
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UP_EQUIP_REGENERATION, {itemId=self.equipInfo.id})
    end
end

function this:SelectJingHua()
    if not self.equipInfo then
        SL:TipMessage(SL:GetConfig('cfg_string',266).text,  1, NoticeType.NoticeMid )--"没有词条无法进化",
        return
    end
    local message = EquipFunc.GetEquipRegenerate(self.equipInfo)
    if message then
        local all_attr_id = {}
        for i=1,10,1 do
            if message[tostring(i)] then
                table.insert(all_attr_id,message[tostring(i)].id)
            else
                break
            end
        end
        if #all_attr_id < 1 then
            SL:TipMessage( SL:GetConfig('cfg_string',266).text,1, NoticeType.NoticeMid )--"没有词条无法进化", 
            return
        end
    else
        SL:TipMessage( SL:GetConfig('cfg_string',266).text, 1, NoticeType.NoticeMid )--"没有词条无法进化",
        return
    end

    self.is_xilian = false
    GUI:setVisible(self.view.jinhua_panel,true)
    GUI:setVisible(self.view.xilian_panel,false)
    GUI:setVisible(self.view.btn_jinhua_select,true)
    GUI:setVisible(self.view.btn_xilian_select,false)
    GUI:setVisible(self.view.xilian_top,false)
    GUI:setVisible(self.view.jinhua_top,true)
    self:UpdateJinHuaUI()
end

function this:SelectEquip()

    for index=1, 15 do
        local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, index)
        if equip then
            if SL:HasConfig('cfg_equip_regeneration', equip['cfgId']) then
                local tbl = SL:GetConfig('cfg_equip_regeneration', equip['cfgId'])
                self.equipPanel:SetSelectIndex(index)
                self:ClickEquip(equip)
                return
            end
        end
    end
end

function this:LUA_EVENT_EQUIP_GRID_CLICK(_, index)
    local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, index)
    if index == E_AppearEquipType.Weapon and equip == nil then
        equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, E_AppearEquipType.TwoHandWeapon)
    end
    if equip then
        if SL:HasConfig('cfg_equip_regeneration', equip['cfgId']) then
            local tbl = SL:GetConfig('cfg_equip_regeneration', equip['cfgId'])
            self.equipPanel:SetSelectIndex(index)
            self:ClickEquip(equip)
            return
        else
            SL:TipMessage( SL:GetConfig('cfg_string',267).text, 1, NoticeType.NoticeMid )--"该部位装备无法再生",
        end
    end
end

function this:ResetUi()
    
end

-- local testLevel = 0
function this:ClickEquip(equipInfo)
    local tbl = SL:GetConfig('cfg_equip_regeneration', equipInfo.cfgId)
    if tbl then
        self.equipInfo = equipInfo
        self:ResetUi()
        local strengthLevel = EquipFunc.GetEquipStrengthLevel(self.equipInfo)
        self:SetEquipName(self.equipInfo.cfgId, strengthLevel)
        self:SetEquipModel(self.equipInfo.cfgId)
        local message = EquipFunc.GetEquipRegenerate(self.equipInfo)
        if message then
            local all_attr_id = {}
            for i=1,10,1 do
                if message[tostring(i)] then
                    table.insert(all_attr_id,message[tostring(i)].id)
                else
                    break
                end
            end
            if #all_attr_id < 1 then
                self.is_xilian = true
            end
        else
            self.is_xilian = true
        end

        if self.is_xilian then
            self:ResetLock()
            self:UpdateConsume()
            self:SelectXilian()
        else
            self:SelectJingHua()
        end
       
    end
 
end



function this:CheckTiHuanBtn()
    if self.xilianList and #self.xilianList > 0 then
        GUI:setVisible(self.view.tihuan_btn,true)
        GUI:setPosition(self.view.xilian_btn,72,-360)
    else
        GUI:setVisible(self.view.tihuan_btn,false)
        GUI:setPosition(self.view.xilian_btn,0,-360)
    end
    local num = 0
    for i, v in ipairs(self.lock_list) do
        if v == 1 then
            num = num + 1
        end
    end
    self:UpdateConsume(num)
    
end

function this:UpdateCurrentCiTiao()
    self.currentAttList = {}
    local message = EquipFunc.GetEquipRegenerate(self.equipInfo)
    -- SL:LogError("获得当前再生词条")
    -- SL:LogTable(message,true)
    if message then
        local all_attr_id = {}
        for i=1,10,1 do
            if message[tostring(i)] then
                --SL:LogTable(message[tostring(i)].id,true)
                table.insert(all_attr_id,message[tostring(i)].id)
            else
                break
            end
        end
        for i, v in ipairs(all_attr_id) do
            local att = SL:GetConfig('cfg_equip_regenerationGroup', v)
            table.insert(self.currentAttList,att)
        end
    end
    GUI:DataListUpdateData(self.view.datalist_current)
end

function this:XiLian()
    local lock = {}
    for i, v in ipairs(self.currentAttList) do
        if self.lock_list[i] == 1 then
            table.insert(lock,self.currentAttList[i].id)
        end
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_EQUIP_REGENERATION, {itemId=self.equipInfo.id,lockattrpos=lock})
end

function this:RES_EQUIP_REGENERATION(_id, message)
    if not message then
        return
    end
    -- SL:LogError("洗练返回")
    -- SL:LogTable(message,true)
    self:UpdateXiLianUI(message)
end

function this:RES_UP_REGENERATION_ATTR(_id, message)
    -- SL:LogError("请求上次洗练数据返回")
    -- SL:LogTable(message,true)
    self:UpdateXiLianUI(message and message.entryAttr or {})
    
end

function this:TiHuan()

    SL:CommonTipsMessage({ stringTblID=212, ui = self, sureBtnText = "确定", cancelBtnText = "取消",
            callback = function()
                self:BeginTiHuan()
            end})
    
end

function this:BeginTiHuan()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_REPLACE_REGENERATION_ATTR, {itemId=self.equipInfo.id})
end

function this:RES_REPLACE_REGENERATION_ATTR(_id, message)
    if not message then
        return
    end
    -- SL:LogError("请求替换返回")
    -- SL:LogTable(message,true)
    self:ResetLock()
    self:SelectXilian()
end

function this:ResetLock()
    for i = 1, 10, 1 do
        self.lock_list[i] = 0
    end
end

function this:UpdateXiLianUI(message)
    local all_attr_id = {}
    for i=1,10,1 do
        if message[tostring(i)] then
            table.insert(all_attr_id,message[tostring(i)])
        else
            break
        end
    end
    self.xilianList = {}
    for i, v in ipairs(all_attr_id) do
        local att = SL:GetConfig('cfg_equip_regenerationGroup', v)
        table.insert(self.xilianList,att)
    end
    GUI:DataListUpdateData(self.view.datalist_new)
    self:CheckTiHuanBtn()
end

function this:UpdateConsume(num)
    self.consume = {}
    if not num or num == 0  then      
        if self.currentAttList and #self.currentAttList > 0 then
            self.consume = SL:GetConfig('cfg_equip_regeneration', self.equipInfo.cfgId).again
        else
            self.consume = SL:GetConfig('cfg_equip_regeneration', self.equipInfo.cfgId).start
        end
    else
        local tbl = SL:GetConfig('cfg_equip_regeneration', self.equipInfo.cfgId)
        if #tbl.lock < num and #tbl.lock >0 then
            self.consume =  tbl.lock[#tbl.lock]
        else
            self.consume =  tbl.lock[num]
        end
    end
    GUI:DataListUpdateData(self.view.cost_list)
end

function this:SetEquipName(cfgId, strengthLevel)

    GUI:setVisible(self.view.equipName, true)
    local equipName = SL:GetConfig('cfg_item', cfgId).name
    local colorStr = EquipFunc.GetEquipNameColor(cfgId)
    if strengthLevel > 0 then
        equipName = equipName .. '+' .. strengthLevel
    end
    GUI:Text_setString(self.view.equipName, string.format("<color=%s>%s</color>", colorStr, equipName))
    GUI:Text_setString(self.view.equipName2, string.format("<color=%s>%s</color>", colorStr, equipName))
end

function this:SetEquipModel(cfgId)
    GUI:setVisible(self.view.item_model, true)
    GUI:Item_setItemId(self.view.item_model, cfgId)
    GUI:setVisible(self.view.item_model2, true)
    GUI:Item_setItemId(self.view.item_model2, cfgId)
end

function this:YuLan()
    GUI:setVisible(self.view.yulan_panel, true)
    if self.equipInfo then
        local equipName = SL:GetConfig('cfg_item', self.equipInfo.cfgId).name
        local colorStr = EquipFunc.GetEquipNameColor(self.equipInfo.cfgId)
        equipName = equipName .. '词条' 
        GUI:Text_setString(self.view.equipName_yulan, string.format("<color=%s>%s</color>", colorStr, equipName))
    else
        GUI:Text_setString(self.view.equipName_yulan, "全部词条")
    end
    local tbl 
    if self.equipInfo then
        tbl = SL:GetConfig('cfg_equip_regeneration', self.equipInfo.cfgId)
    end
    local AllCiTiao = SL:FindConfigs('cfg_equip_regenerationGroup', "level",1)
    self.AllCiTiao = {}
    --table.insert(self.AllCiTiao,{attName="词条"})
    for i, v in ipairs(AllCiTiao) do
        if tbl then
            if v.group == tbl.Group then
                table.insert(self.AllCiTiao,v)
            end
        else
            table.insert(self.AllCiTiao,v)
        end
    end
    GUI:DataListUpdateData(self.view.datalist_yulan)
end

function this:YuLanClose()
    GUI:setVisible(self.view.yulan_panel, false)
end

---词条预览显示
function this:AllCountFunc()
    return #self.AllCiTiao
end

function this:AllGetFunc(realIndex)

end

function this:AllInitFunc(realIndex, kmlcontrol)
end

function this:AllUpdateFunc(realIndex, kmlcontrol)
    local data = self.AllCiTiao[realIndex + 1]
    local name = GUI:GetChildControl(self.view.datalist_yulan, realIndex, "value")
    local bg = GUI:GetChildControl(self.view.datalist_yulan, realIndex, "bg")
    if realIndex % 2 == 1 then
        GUI:setVisible(bg, true)
    else
        GUI:setVisible(bg, false)
    end
    if data.att then
        local name_str,num_str= self:GetAttStr(data.att)
        GUI:Text_setString(name, name_str.." +"..num_str)
    else
        GUI:Text_setString(name, data.attName)
    end
    
end


function this:ConsumeCountFunc()
    return #self.consume
end

function this:ConsumeGetFunc(realIndex)

end

function this:ConsumeInitFunc(realIndex, kmlcontrol)
end

function this:ConsumeUpdateFunc(realIndex, kmlcontrol)
    local data = self.consume[realIndex + 1]
    local cost_item = GUI:GetChildControl(self.view.cost_list, realIndex, "cost_item")
    local cost_name = GUI:GetChildControl(self.view.cost_list, realIndex, "cost_name")
    local cost_num = GUI:GetChildControl(self.view.cost_list, realIndex, "cost_num")
    local costAddBtn = GUI:GetChildControl(self.view.cost_list, realIndex, "costAddBtn")
    local name = SL:GetConfig("cfg_item", data[1]).name
    GUI:Item_setItemId(cost_item, data[1])
    GUI:Text_setString(cost_name, name)
    local needCount = data[2]
    local haveCount = SL:GetBagItemCount(data[1])
        if haveCount < needCount then
            GUI:Text_setString(cost_num, string.format('<color="#9b1818">%d</color>/%d', haveCount, needCount))
        else
            GUI:Text_setString(cost_num, string.format('<color="#2a8430">%d</color>/%d', haveCount, needCount))
        end
    GUI:AddOnClickEvent(costAddBtn, self, self.costAddBtn, {cfgId=data[1]})
end

function this:costAddBtn(control, eventData)
    local cfgId = eventData.cfgId
    SL:CommonItemGetPath(nil, cfgId)
end

---洗练当前词条显示
function this:CurrentCountFunc()
    --SL:LogError(#self.currentAttList)
    return #self.currentAttList
end

function this:CurrentGetFunc(realIndex)

end

function this:CurrentInitFunc(realIndex, kmlcontrol)
end

function this:CurrentUpdateFunc(realIndex, kmlcontrol)
    local data = self.currentAttList[realIndex + 1]
    local name = GUI:GetChildControl(self.view.datalist_current, realIndex, "value")
    --GUI:Text_setString(name, data.attName)
    local name_str,num_str= self:GetAttStr(data.att)
    GUI:Text_setString(name, name_str.." +"..num_str)
    local btn_baoliu = GUI:GetChildControl(self.view.datalist_current, realIndex, "btn_baoliu")
    local btn_cancel = GUI:GetChildControl(self.view.datalist_current, realIndex, "btn_cancel")
    GUI:AddOnClickEvent(btn_baoliu, self, self.BaoLiu, {index=realIndex + 1})
    GUI:AddOnClickEvent(btn_cancel, self, self.JieChu, {index=realIndex + 1})
    if self.lock_list[realIndex + 1] == 0 then
        GUI:setVisible(btn_baoliu,true)
        GUI:setVisible(btn_cancel,false)
    else
        GUI:setVisible(btn_baoliu,false)
        GUI:setVisible(btn_cancel,true)
    end
end

function this:BaoLiu(control, eventData)
    local index = eventData.index
    local current_num = 0
    for i, v in ipairs(self.lock_list) do
        if v == 1 then
            current_num = current_num + 1
        end
    end
    local tbl = SL:GetConfig('cfg_equip_regeneration', self.equipInfo.cfgId)
    local max_num = #tbl.lock
    if current_num >= max_num then
        local str = string.format("该装备最多锁定%s个词条",max_num)
        SL:TipMessage( str, 1, NoticeType.NoticeMid )
        return
    end
    self.lock_list[index] = 1
    local num = 0
    for i, v in ipairs(self.lock_list) do
        if v == 1 then
            num = num + 1
        end
    end
    GUI:DataListUpdateData(self.view.datalist_current)
    self:UpdateConsume(num)
end

function this:JieChu(control, eventData)
    local index = eventData.index
    
    self.lock_list[index] = 0
    local num = 0
    for i, v in ipairs(self.lock_list) do
        if v == 1 then
            num = num + 1
        end
    end
    GUI:DataListUpdateData(self.view.datalist_current)
    self:UpdateConsume(num)
end


---洗练新词条显示
function this:NewCountFunc()
    return #self.xilianList
end

function this:NewGetFunc(realIndex)

end

function this:NewInitFunc(realIndex, kmlcontrol)
end

function this:NewUpdateFunc(realIndex, kmlcontrol)
    local data = self.xilianList[realIndex + 1]
    local name = GUI:GetChildControl(self.view.datalist_new, realIndex, "value")
    --GUI:Text_setString(name, data.attName)
    local name_str,num_str= self:GetAttStr(data.att)
    GUI:Text_setString(name, name_str.." +"..num_str)
end





function this:UpdateJinHuaUI()
    if not self.equipInfo then
        GUI:setVisible(self.view.lock,false)
        GUI:setVisible(self.view.info_panel,false)
        return
    end
    local strengthLevel = EquipFunc.GetEquipStrengthLevel(self.equipInfo) 
    local tbl = SL:GetConfig('cfg_equip_regeneration', self.equipInfo.cfgId)
    if strengthLevel < tbl.condition then
        GUI:setVisible(self.view.jinhua_lock,true)
        GUI:setVisible(self.view.jinhua_info_panel,false)
    else
        GUI:setVisible(self.view.jinhua_lock,false)
        GUI:setVisible(self.view.jinhua_info_panel,true)
        
    end
    self:UpdateJinHuaCiTiao()
end

function this:UpdateJinHuaCiTiao()
    local AttList = {}
    local message = EquipFunc.GetEquipRegenerate(self.equipInfo)
    if message then
        local all_attr_id = {}
        for i=1,10,1 do
            if message[tostring(i)] then
                --SL:LogTable(message[tostring(i)].id,true)
                table.insert(all_attr_id,message[tostring(i)].id)
            else
                break
            end
        end
        for i, v in ipairs(all_attr_id) do
            local att = SL:GetConfig('cfg_equip_regenerationGroup', v)
            table.insert(AttList,att)
        end
    end


    self.jinhua_list = {}
    local max_level = SL:GetConfig('cfg_equip_regeneration', self.equipInfo.cfgId).levelMax
    local current_level = EquipFunc.GetEquipRegenerateLevel(self.equipInfo)
    local next_level = current_level + 1
    if next_level > max_level then
        next_level = max_level
    end
    GUI:Text_setString(self.view.preLevel,"+".. tostring(current_level))
    GUI:Text_setString(self.view.nextLevel,"+".. tostring(next_level))
    if current_level >= max_level then
        GUI:setVisible(self.view.maxLevelTips,true)
        GUI:setVisible(self.view.jilv_img,false)
        GUI:setVisible(self.view.panel_jinhua_cailiao,false)
        GUI:setVisible(self.view.img_manji,true)
        GUI:setVisible(self.view.nextLevel,false)
        GUI:setVisible(self.view.jinhua_info_panel_arrow,false)
    else
        GUI:setVisible(self.view.maxLevelTips,false)
        GUI:setVisible(self.view.jilv_img,true)
        GUI:setVisible(self.view.panel_jinhua_cailiao,true)
        GUI:setVisible(self.view.img_manji,false)
        GUI:setVisible(self.view.nextLevel,true)
        GUI:setVisible(self.view.jinhua_info_panel_arrow,true)
    end
    for i, one_data in ipairs(AttList) do
        local id = one_data.id
        local level = one_data.level
        local tab = {}
        local name_str,num_str= self:GetAttStr(one_data.att)
        tab.note = name_str
        if level >= max_level then
            tab.before = ""
            tab.after = num_str
        else
            local next_id = id+1
            local next_tab = SL:GetConfig('cfg_equip_regenerationGroup',next_id)
            local name2,num_str2= self:GetAttStr(next_tab.att)
            tab.before = num_str
            tab.after = num_str2
        end
        table.insert(self.jinhua_list,tab)
    end

    GUI:DataListUpdateData(self.view.datalist_jinhua)
    self:UpdateJinHuaConsume()
end

function this:GetAttStr(str)
   -- SL:LogError(str)
    if string.isNullOrEmpty(str) then
        return "",""
    end
    local oneList = string.split(str,'#')
    local att_id = tonumber(oneList[1])
    local num = tonumber(oneList[2])
    local attrTbl = SL:GetConfig("cfg_att_info", att_id)
    local name = attrTbl.name
    local remarks = attrTbl.remarks
    local num_str = ""
    if remarks == 1 then
        num_str = num
    else
        num_str =  string.format("%.2".. "f", num / 100) .. "%"
    end
   -- SL:LogError(num_str)
    return name,num_str
end


---进化词条显示
function this:JinHuaCiTiaoCountFunc()
    return #self.jinhua_list
end

function this:JinHuaCiTiaoGetFunc(realIndex)

end

function this:JinHuaCiTiaoInitFunc(realIndex, kmlcontrol)
end

function this:JinHuaCiTiaoUpdateFunc(realIndex, kmlcontrol)
    local data = self.jinhua_list[realIndex + 1]
    local name = GUI:GetChildControl(self.view.datalist_jinhua, realIndex, "name")
    local before = GUI:GetChildControl(self.view.datalist_jinhua, realIndex, "before")
    local after = GUI:GetChildControl(self.view.datalist_jinhua, realIndex, "after")
    local arrow = GUI:GetChildControl(self.view.datalist_jinhua, realIndex, "arrow")
    if data.before == "" then
        GUI:setVisible(arrow,false)
    else
        GUI:setVisible(arrow,true)
    end
    GUI:Text_setString(name, tostring(data.note))
    GUI:Text_setString(before, tostring(data.before))
    GUI:Text_setString(after, tostring(data.after))
end


---进化所需材料
function this:JinHuaConsumeCountFunc()
    return #self.jinhua_consume
end

function this:JinHuaConsumeGetFunc(realIndex)

end

function this:JinHuaConsumeInitFunc(realIndex, kmlcontrol)
end

function this:JinHuaConsumeUpdateFunc(realIndex, kmlcontrol)
    local data = self.jinhua_consume[realIndex + 1]
    local cost_item = GUI:GetChildControl(self.view.jinhua_cost_list, realIndex, "cost_item")
    local cost_name = GUI:GetChildControl(self.view.jinhua_cost_list, realIndex, "cost_name")
    local cost_num = GUI:GetChildControl(self.view.jinhua_cost_list, realIndex, "cost_num")
    local costAddBtn = GUI:GetChildControl(self.view.jinhua_cost_list, realIndex, "costAddBtn")
    local name = SL:GetConfig("cfg_item", data[1]).name
    GUI:Item_setItemId(cost_item, data[1])
    GUI:Text_setString(cost_name, name)
    local needCount = data[2]
    local haveCount = SL:GetBagItemCount(data[1])
        if haveCount < needCount then
            GUI:Text_setString(cost_num, string.format('<color="#9b1818">%d</color>/%d', haveCount, needCount))
        else
            GUI:Text_setString(cost_num, string.format('<color="#2a8430">%d</color>/%d', haveCount, needCount))
        end
    GUI:AddOnClickEvent(costAddBtn, self, self.costAddBtn, {cfgId=data[1]})
end

function this:UpdateJinHuaConsume()
    
    local level = EquipFunc.GetEquipRegenerateLevel(self.equipInfo)
    
    self.jinhua_consume = {}
    local costId = SL:GetConfig('cfg_equip_regeneration', self.equipInfo.cfgId).costId
    local id = costId * 100 + level
    local has = SL:HasConfig('cfg_equip_regenerationCost', id)
    if not has then
        return
    end
    local tab = SL:GetConfig('cfg_equip_regenerationCost', id)
    self.jinhua_consume = tab.cost
    GUI:DataListUpdateData(self.view.jinhua_cost_list)
    local rateClient = tab.rateClient
    rateClient = math.floor(rateClient/100)
    GUI:Text_setString(self.view.jilv,rateClient.."%")
end

function this:JinHua()
    local max_level = SL:GetConfig('cfg_equip_regeneration', self.equipInfo.cfgId).levelMax
    local current_level = EquipFunc.GetEquipRegenerateLevel(self.equipInfo)
    if current_level >= max_level then
        SL:TipMessage( SL:GetConfig('cfg_string',241).text,"已经是最高等级了", 1, NoticeType.NoticeMid )
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_STRENGTH_REGENERATION_ATTR, {itemId=self.equipInfo.id})
end

function this:RES_STRENGTH_REGENERATION_ATTR(_id, message)
--    SL:LogError("响应进化")
--    SL:LogTable(message,true)
   GUI:setVisible(self.view.success_anim, true)
   if message then
       GUI:Text_setString(self.view.successText, "进化成功")
       GUI:Text_setTextColor(self.view.successText, "#FFE800")
       GUI:Image_loadTexture(self.view.success_anim, "img_function_13" ,"Atlas/UIEquipStrengthPanel.spriteatlas")
   else
       GUI:Text_setString(self.view.successText, "进化失败")
       GUI:Text_setTextColor(self.view.successText, "#FFFFFF")
       GUI:Image_loadTexture(self.view.success_anim, "strength_fail" ,"Atlas/UIEquipStrengthPanel.spriteatlas")
   end
    if self.coHide ~= nil then
        SL:UnSchedule(self.coHide)
    end
    self.coHide =  SL:ScheduleOnce(1.5,function ()
        GUI:setVisible(self.view.success_anim, false)
    end      
    )
    self:SelectJingHua()
end

return this
