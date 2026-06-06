---@class KLUICreateRolePanel:UIKmlLuaPanelBase
---@field view KLUICreateRolePanelView
local KLUICreateRolePanel = class(UIKmlLuaPanelBase)
local this =KLUICreateRolePanel
---创建时调用一次
function this:Init()
    ---@type UICreateRolePanel
    local panel = self.args.uiCreateRolePanel
    panel:HideChooseRolePanel(_, { [2] = true })
    GUI:DataListInitData( self.view.att_list,function()
        return self:ItemCountFunc()
    end,function(realIndex)
        return self:ItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:ItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:ItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

function this:ItemCountFunc()
    return #self.attrItemsData
end

function this:ItemGetFunc(realIndex)
end

function this:ItemInitFunc(realIndex, kmlcontrol)
end

function this:ItemUpdateFunc(realIndex, rectTrans)
    local attrData = self.attrItemsData[realIndex + 1]
    local cfg = SL:GetConfig("cfg_att_info", attrData)
    local attrKey = "att"..self.cfgId
    local attrValue = cfg[attrKey]
    local attrName = cfg.name
    
    local attName = GUI:GetChildControl(self.view.att_list,realIndex,'attName')
    GUI:Text_setString(attName,attrName)
    local attValue = GUI:GetChildControl(self.view.att_list,realIndex,'attValue')
    GUI:Text_setString(attValue,tostring(attrValue))
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.unlockList = self.args.unlockList
    ---@type cfg_character_create_column[]
    local createCfg = SL:GetConfigTable("cfg_character_create")
    self.createRoleData = {}
    for _, v in pairs(createCfg) do
        if v.unlock == 1 then --是否解锁
            ---@type KLCareerButtonItem
            local toggle = GUI:UIPanel_Open("dev/ui/CreateRole/Item/KLCareerButton/KLCareerButtonItem",self.view.createrole_layout,self,nil,true)
            --if v.conditionLv ~= 0 then
            --    toggle:RefreshToggle("Atlas/Common.spriteatlas","button_interface_window22", "button_interface_window21")
            --end
            toggle:RefreshToggleName(v)
            toggle:SetOnValueChange(self.ToggleChangeEvent, self)
        end
    end
    self:RefreshCreateRoleUI(1)
    self:OnClickRandomButton()
    GUI:SetZIndex(self.view.midNode,1000)
    GUI:SetZIndex(self.view.panel_lockRole,1001)

    --GUI:SetZIndex(self.view.btn_createrole_random,1000)
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn,self,self.OnClickCloseButton)
    GUI:AddOnClickEvent(self.view.btn_createrole_unlock,self,self.OnClickUnlockButton)
    GUI:AddOnClickEvent(self.view.btn_createrole_random,self,self.OnClickRandomButton)
    GUI:AddOnClickEvent(self.view.btn_createrole_create,self,self.OnClickCreateButton)

    SL:RegisterLuaNetMsg(MessageDef.ResRandomRoleNameMessage,self.ResRandomRoleNameMessage,self)
    SL:RegisterLuaNetMsg(MessageDef.ResUnLockUserCareerMessage,self.ResUnLockUserCareerMessage,self)
end

function this:OnClickCloseButton()
    ---@type KLSelectRolePanel
    local panel = self.args.uiCreateRolePanel
    panel:HideChooseRolePanel(_, { [2] = "true" })
    GUI:UIPanel_Close('dev/ui/CreateRole/Panel/KLUICreateRole/KLUICreateRolePanel')
end

function this:OnClickUnlockButton()
    local cfg = SL:GetConfig("cfg_character_create",self.cfgId)
    --GUI:UIPanel_Open("dev/ui/Common/Panel/KLUICommonTips/KLUICommonTipsPanel",nil,nil, { showTips = "是否花费<color=#00ff00>" .. cfg.price .. "</color>解锁该职业", callback = self.UnLockCareer, ui = self })
    SL:CommonTipsMessage({
        showTips = "是否花费<color=#00ff00>" .. cfg.price .. "</color>元解锁该职业", 
        callback = self.UnLockCareer, 
        ui = self
    })
end

function this:OnClickRandomButton()
    SL.NetManager_Req:ReqRandomRoleNameMessage(self.cfgId or 0, self.randomName or "")
end

function this:OnClickCreateButton()
    local name = GUI:Text_getString(self.view.createrole_input)
    local message = {}
    if string.isNullOrEmpty(name) then
        message.msg = "名字不能为空"
        message.type = "error"
        SL:TipMessage( "名字不能为空", 1, NoticeType.NoticeMid )
        --UINoticeMgr.PopTips(message)
    elseif string.find(name,"%s") ~= nil then
        message.msg = "名字中不能包含空格"
        message.type = "error"
        SL:TipMessage( "名字中不能包含空格", 1, NoticeType.NoticeMid )
        --UINoticeMgr.PopTips(message)
    elseif self:GetStrLen(name) > 14 then
        message.msg = "名字过长"
        message.type = "error"
        SL:TipMessage( "名字过长", 1, NoticeType.NoticeMid )
        --UINoticeMgr.PopTips(message)
    else
        SL.NetManager_Req:ReqCreateRoleMessage(name,1,self.cfgId)
    end
end

function this:GetStrLen(inputstr)
    if not inputstr or type(inputstr) ~= "string" or #inputstr <= 0 then
        return nil
    end
    local length = 0  -- 字符的个数
    local i = 1
    while true do
        local lengthCount=1
        local curByte = string.byte(inputstr, i)
        local byteCount = 1
        if curByte > 239 then
            byteCount = 4  -- 4字节字符
            lengthCount=2
        elseif curByte > 223 then
            lengthCount=2
            byteCount = 3  -- 汉字
        elseif curByte > 128 then
            byteCount = 2  -- 双字节字符
        else
            byteCount = 1  -- 单字节字符
        end
        i = i + byteCount
        length = length + lengthCount
        if i > #inputstr then
            break
        end
    end
    return length
end

---玩家随机名字返回
---@param message UserProtos.RandomRoleNameRes
function this:ResRandomRoleNameMessage(_, message)
    self.randomName = message.roleName
    GUI:Text_setString(self.view.createrole_input, self.randomName)
end

---职业解锁返回
---@param message UserProtos.UnLockUserCareerRes
function this:ResUnLockUserCareerMessage(_, message)
    if message.ok then
        SL.LoginManager:RefreshCareerUnlockList(self.cfgId)
    end
    self:RefreshCreateRoleUI(self.cfgId, true)
end

function this:ToggleChangeEvent(_,eventData)
    if eventData.data.id ~= self.cfgId then
        self:RefreshCreateRoleUI(eventData.data.id)
    end
end

---职业解锁请求
function this:UnLockCareer()
    if not self.isLvCanUnlock then
        return
    end
    SL.NetManager_Req:ReqUnLockUserCareerMessage(CS.GameInfo.UID,self.cfgId)
end

---根据职业根id刷新界面显示
function this:RefreshCreateRoleUI(id,refreshBtn)
    self.cfgId = id
    ---@type cfg_character_create_column
    local cfg = SL:GetConfig("cfg_character_create",id)
    if not refreshBtn then
        local scale = string.split(cfg.modelScale,'#')
        local pos = string.split(cfg.modelPosition,'#')
        local rotation = string.split(cfg.modelRotation,'#')

        GUI:Model_setSrc(self.view.createrole_model, cfg.path, scale[1]..","..scale[2]..","..scale[3], rotation[1]..","..rotation[2]..","..rotation[3], pos[1]..","..pos[2]..","..pos[3])
        GUI:Text_setString(self.view.createrole_description, cfg.description)
        self.attrItemsData = cfg.attShow
        GUI:DataListUpdateData(self.view.att_list)
        GUI:SetZIndex(self.view.createrole_model,199)
    end
    GUI:setVisible(self.view.panel_lockRole, cfg.isShow ~= 1)
    GUI:setVisible(self.view.midNode, cfg.isShow == 1)
    GUI:setVisible(self.view.closeBtn, true)
    GUI:setVisible(self.view.btn_createrole_unlock, false)
    ---当前等级需求是否达到可解锁条件
    self.isLvCanUnlock = false
    for _, v in pairs(SL.LoginManager:GetLoginRes_Role()) do
        if v.level >= cfg.unlockLv then
            self.isLvCanUnlock = true
            break
        end
    end
    ---是否解锁职业
    if cfg.unlockLv == 0 then
        GUI:setVisible(self.view.btn_createrole_create, true)
    else
        if SL.LoginManager:GetCareerUnlockData(id) then
            GUI:setVisible(self.view.btn_createrole_create, true)
        else
            if cfg.price > 0 then
                GUI:setVisible(self.view.btn_createrole_unlock, true)
                GUI:Button_setTitleText(self.view.btn_createrole_unlock,"立即解锁￥"..cfg.price)
                GUI:setVisible(self.view.closeBtn, false)
            end
            
            GUI:setVisible(self.view.btn_createrole_create, false)
        end
    end
    -- 若conditionsText为空，不显示解锁条件并隐藏背景图
    if not string.isNullOrEmpty(cfg.conditionsText) then
        GUI:setVisible(self.view.textbg_createrole_unlock, true)
        GUI:Text_setString(self.view.text_createrole_unlock, cfg.conditionsText)
    else
        GUI:setVisible(self.view.textbg_createrole_unlock, false)
    end
end

function this:Close()
end

return this
