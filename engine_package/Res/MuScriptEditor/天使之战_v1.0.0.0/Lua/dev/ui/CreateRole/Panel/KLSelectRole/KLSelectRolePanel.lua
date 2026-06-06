---@class KLSelectRolePanel:UIKmlLuaPanelBase
---@field view KLSelectRolePanelView
local KLSelectRolePanel = class(UIKmlLuaPanelBase)
local this = KLSelectRolePanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    SL:MainCameraCreateRoleSet()
    self.ItemList = {}
    self.RoleTable = {}
    self.createCount = 1
    GUI:setVisible(self.view.CreatButton)
    local p = GUI:GetAnchoredPosition(self.view.CreatButton)
    self.createStartPos = Vector2.New(0, p.y)
    self.createEndPos = Vector2.New(0, 420)
    GUI:setVisible(self.view.Tips,false)
    if SL:HasConfig("cfg_global",400004) then
        self.fixedUISpace = SL:GetConfig("cfg_global",400004).value
    end
    
    if SL:HasConfig("cfg_global",400006) then
        self.txtStr = SL:GetConfig("cfg_global",400006).value
    else
        self.txtStr = "系统提示:复古版本究极还原，扩展技术支持:复古小组"
    end
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.createBtn, self, self.CreatButtonOnClick)
    GUI:AddOnClickEvent(self.view.goBtn, self, self.StartButtonOnClick)
    GUI:AddOnClickEvent(self.view.delBtn, self, self.DeleteRole)
    GUI:AddOnClickEvent(self.view.backBtn, self, self.BackButtonOnClick)
    GUI:AddOnClickEvent(self.view.tipCanelBtn, self, self.TipCanelBtnOnClick)
    GUI:AddOnClickEvent(self.view.tipCloseBtn, self, self.TipCanelBtnOnClick)
    GUI:AddOnClickEvent(self.view.tipSureBtn, self, self.TipSurelBtnOnClick)

    SL:RegisterLuaNetMsg(MessageDef.ResCreateRoleMessage, self.ResCreateRoleMessage, self)
    SL:RegisterLuaNetMsg(MessageDef.ResRemoveRoleMessage, self.ResRemoveRoleMessage, self)
    SL:RegisterLuaNetMsg(MessageDef.ResRandomRoleNameMessage, self.ResRandomRoleNameMessage, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_DELETE_ROLE_LIMIT, self.ResDeleteRole, self)

end
---界面显示时调用一次
function this:Show() --self.Effect = SL:CreateSceneEffect("Effect/Scene/Teleport_14.prefab") 
   -- SL.MainCamera:SetLookCamera(0,0,0)
    SL:MainCameraCreateRoleSet()
    self.lastRoleId = PlayerPrefs.GetString(SL.LoginManager:GetLastAccount() .. "ChoosePlayer", "")
    self:ShowRole()
    SL.LoginManager:SetInGame(false)
    SL.LoginManager:SetIsLoginCheck(nil)
    GUI:Text_setString(self.view.text8,self.txtStr)
    
    if #SL.LoginManager:GetLoginRes_Role() == 0 then
        self:ShowChooseRole()
    else
        self:HideChooseRole()
    end
    SL:PlayBGM(10018, true)
    if self.fixedUISpace then
        GUI:SetAttr(self.view.PlayerRole_New,"space",self.fixedUISpace)
    end
    
end
---创建或者刷新界面数据时调用
function this:Refresh()

end

function this:Close()
    if self.Model ~= nil then
        PlayerPrefs.SetString(SL.LoginManager:GetLastAccount() .. "ChoosePlayer", self.Model.date.rid)
    end
    self:CleanRole()

    self.Role = nil
    for i, v in pairs(self.RoleTable) do
        self.registInBaseUI:RemoveModelEffect(v.Model)
    end
    self.RoleTable = {}
end

function this:KmlBackRefresh()
    if #SL.LoginManager:GetLoginRes_Role() == 0 then
        self:ShowChooseRole()
    else
        self:HideChooseRole()
    end
end

-- 每帧更新，需要使用时打开
function this:Update()
    if SL.Main:GetVersion() == EVersion.XW then
        for _, v in pairs(self.ItemList) do
            if v.role then
                v.role:Update()
            end
        end
    end
end

function this:LoginGameImmediately()
    if LoginManager.quickLoginInfo then
        SL.UIManager.ShowNotHideUI("UILoadingWaitPanel", { isTips = true, msg = "" })
        SL.GamePlay:SetGameInfo(_, _, LoginManager.quickLoginInfo.rid, LoginManager.quickLoginInfo.rName)
        SL.NetManager_Req:ReqEnterRoleMessage(LoginManager.quickLoginInfo.rid)
        LoginManager.quickLoginInfo = nil
    end
end

function this:CreatButtonOnClick(control)
    ---先做已创建人物数量判断
    if #SL.LoginManager:GetLoginRes_Role() < 5 then
        self:ShowChooseRole()
    else
        self.isAll = true
        GUI:setVisible(self.view.Tips,true)
        GUI:SetZIndex(self.view.Tips,1000)
        GUI:Text_setString(self.view.tipStrTxt,"可创建角色已满")
        --SL.UIManager:ShowNotHideUI("UIPromptTipPanel", { textContent = "可创建角色已满" })
    end
end

function this:StartButtonOnClick()
    if not SL.Main:IsEditor() and (SL.Main:IsAndroid() or SL.Main:IsIos()) then
        SL:InitErrorLogTool()
    end
    if SL.LoginManager:GetLoginRes() and #SL.LoginManager:GetLoginRes_Role() > 0 then
        if not SL:IsAllLoad() then
            SL.UIManager:ShowNotHideUI("UILoadingWaitPanel", {isTips=true, msg = "初始化中" ,timeOutCallBack=function()
                self:ReqEnterGame()
            end})
            Coroutine.Start(function()
                while not SL:IsAllLoad() do
                    Coroutine.WaitForEndOfFrame()
                end
                SL.UIManager:Hide("UILoadingWaitPanel")
                self:ReqEnterGame()
            end)
            return
        end
        SL.UIManager:Hide("UILoadingWaitPanel")
        self:ReqEnterGame()
    else
        SL:TipMessage(SL:GetConfig('cfg_string', 316).text, 1, NoticeType.NoticeMid)
    end
end

function this:ReqEnterGame()
    SL.UIManager:ShowNotHideUI("UILoadingWaitPanel", { isTips = true, msg = "" })
    SL.GamePlay:SetGameInfo(_, _, self.Model.date.rid, self.Model.date.name)
    SL.NetManager_Req:ReqEnterRoleMessage(self.Model.date.rid)
end

---@param message UserProtos.CreateRoleRes
function this:AddPlayer(message)
    self:CreateRoleModel(message.role)
    self.haveRoleCount = self.haveRoleCount + 1
end

---开始游戏
function this:StartGame()
    SL.NetManager_Req:ReqEnterRoleMessage(self.Model.date.rid)
end


--显示当前选中的角色
---@param UIModelItemTemplate KLUIModelItemPanel
function this:ShowChoosePlayer(UIModelItemTemplate)
    if self.Model == nil then
        self.Model = UIModelItemTemplate
        self.Model:LoadEffect()
    else
        self.Model:RecycleEffect()
        self.Model = UIModelItemTemplate
        self.Model:LoadEffect()
    end
end

function this:DeleteRole(id)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CHECK_DELETE_ROLE)
end

function this:ResDeleteRole(_,data)
    local count = table.count(SL.LoginManager:GetLoginRes_Role())
    if count <= 0 then
        SL:TipMessage("当前无可删除的角色，请先创建", 1, NoticeType.NoticeMid)
        return
    end
    self.result = data.result
    self.deleteID = self.selectId
    

    if self.result then 
        GUI:setVisible(self.view.Tips,true)
        GUI:SetZIndex(self.view.Tips,1000)
        ---@type cfg_string_column
        local deleteConfir = SL:GetConfig("cfg_string", 72001) -- 每日删除限制提醒
        GUI:Text_setString(self.view.tipStrTxt, deleteConfir.text)

        GUI:setLocalZOrder(self.view.tipStrTxt,4)
    else
        local notDeleteTbl = SL:GetConfig("cfg_string", 73001)
        SL:TipMessage(notDeleteTbl.text, 1, NoticeType.NoticeMid)
    end
end

function this:TipCanelBtnOnClick()
    GUI:setVisible(self.view.Tips,false)
end
function this:TipSurelBtnOnClick()
    if not self.isAll and self.result then
        self:ReqDelete()
    end


    self.isAll = false
    GUI:setVisible(self.view.Tips,false)
end

function this:ReqDelete(message)
    SL.NetManager_Req:ReqRemoveRoleMessage(self.deleteID)
    if not SL.Main:IsLocalServer() or SL.Main:IsEditor() then
        this:DeleteServerRoleInfo(self.deleteID)
    end
end

function this:DeleteServerRoleInfo(rid)
    local tbl = {
        openId = SL.LoginManager:GetOpenId(),
        rid = tostring(rid)
    }
    local loginForm = SL:GetWWWForm(tbl)
    local loginUrl = SL.UIStaticParameter:GetDeleteServerUrl()
    SL:logNoFlag(loginUrl)
    SL.Http:RequestWWW(loginUrl, loginForm, self.UpdateRoleBack, self)
end

function this:UpdateRoleBack(www)
    local msg = SL:DecodeJson(www)
    if msg ~= nil and msg.success ~= nil then
        SL:Log("RoleInfo report server success")
    else
        SL:Log("RoleInfo report server fail")
    end
end

function this:ShowRole()
    self:CleanRole()
    self.haveRoleCount = 0
    for i, v in pairs(SL.LoginManager:GetLoginRes_Role()) do
        self:CreateRoleModel(v)
        self.haveRoleCount = self.haveRoleCount + 1
    end
end


--创建玩家角色模型
---@param v UserProtos.RoleInfo
function this:CreateRoleModel(v)
    local tp = {}
    tp.rid = v.rid
    table.insert(self.ItemList, tp)
    if tp.Model == nil then
        GUI:UIPanel_Open("dev/ui/CreateRole/Panel/KLUIModel/KLUIModelItemPanel", self.view.PlayerRole_New, self, { createRolePanel = self }, true, function(win)
            --webgl下GetTemplateByLoad异步加载，self.tp值被覆盖了，需要通过下面的逻辑重新找一下
            --local tpk, tp = table.find(self.ItemList, function(_, _, k, itemV)
            --    return itemV.rid == v.rid
            --end)
            --self.tp = tp
            tp.Model = win
            GUI:SetAsLastSibling(tp.Model.view.root)
            tp.Model:RefreshUI(v, self.createCount)

            if self.Model == nil then
                self.Model = tp.Model
                GUI:SetActive(self.Model.view.root, true)
                self.Model:LoadEffect()

            end
            if tostring(v.rid) == self.lastRoleId then
                if self.Model ~= nil then
                    
                    self.Model:RecycleEffect()
                end
                self.Model = tp.Model
                self.Model:LoadEffect()
                self:EnterGameOnExitSceneEditor()
            end
            if SL.Main:GetVersion() == EVersion.XW then
                tp.Model:PlayerAni()
            end
            self.createCount = self.createCount + 1
            GUI:ForceRebuildLayoutImmediate(self.view.PlayerRole_New)
        end)
    end
end

function this:CleanRole()
    self.Model = nil
    if self.ItemList then
        for k, v in pairs(self.ItemList) do
            if v.Model then
                GUI:UIPanel_Close("", v.Model)
            end
        end
    end
    self.ItemList = {}
    self.createCount = 1
end

function this:SetSelectId(rid)
    self.selectId = rid
end


--点击显示职业
function this:ShowJob()

end

function this:KmlCreateButtonOnClick()
    GUI:SetActive(self.view.StartButton, false)
    local t = GUI:DOAnchorPos(GUI:GetRectTransform(self.view.CreateButton), self.createEndPos, 0)
    GUI:TweenSetOnComplete(t, function()
        GUI:SetActive(self.view.NewCreateButton, false)
        ---（Kml初始化完成）打开Kml创建角色界面
        GUI:UIPanel_Open("dev/ui/CreateRole/Panel/KLUICreateRole/KLUICreateRolePanel", nil, nil, { unlockList = Sl.LoginManager:GetLoginRes_UnlockList(), uiCreateRolePanel = self })
    end)
end

function this:BackButtonOnClick(control)
    if SL.LoginInfo:IsSDK() then
        if SL.Main:IsWindows() then
            SL:QuitGame()
        else
            if SL.LoginInfo:IsBox() or SL.LoginInfo:IsBoxSDK() then
                ---返回选择服务器页面
                GUI:UIPanel_Close("dev/ui/CreateRole/Panel/KLSelectRole/KLSelectRolePanel")
                SL.NetManager:Close()
                GUI:UIPanel_Open("dev/ui/LoadingPanel/Panel/KLUILoadingPanel/KLUILoadingPanelPanel", nil, nil, { ProgressType = ProgressType.NoProcess, texure2DPath = "muuiback" }, false)
                SL.Scene:SetSceneName("login")
                this.request = SceneManager.Load("Scene/login.unity", this.OnLoadlogin)
            else
                MuInterface.Instance:LogoutAccount()
            end
        end
    else
        ---返回选择服务器页面
        GUI:UIPanel_Close("dev/ui/CreateRole/Panel/KLSelectRole/KLSelectRolePanel")
        SL.NetManager:Close()
        GUI:UIPanel_Open("dev/ui/LoadingPanel/Panel/KLUILoadingPanel/KLUILoadingPanelPanel", nil, nil, { ProgressType = ProgressType.NoProcess, texure2DPath = "muuiback" }, false)
        SL.Scene:SetSceneName("login")
        this.request = SL.SceneManager:Load("Scene/login.unity", this.OnLoadlogin)
    end
end

function this.OnLoadlogin()
    SL.MainCamera:ResetCameraToMain()
    GUI:UIPanel_Close("dev/ui/LoadingPanel/Panel/KLUILoadingPanel/KLUILoadingPanelPanel")
    local env = SL:GetMetaValue("CS_MAIN_ENV")
    if SL.LoginInfo:IsSDK() or (not string.isNullOrEmpty(env) and env ~= "local" and not SL.LoginInfo:IsWhitePkg() ) or (SL.Main:IsEditor() and SL:GetResourceLoadMode() == 2) then
        GUI:UIPanel_Open("dev/ui/Login/Panel/KLSelectGameLogin/KLSelectGameLoginPanel")
    else
        SL.UIManager:ShowFunctionUI("UILoginPanel", { panelState = PanelStateEnum.ConnectServer, isBackFromCreateRole = true },nil,not SL:GetIsWebGL())
        ---GUI:UIPanel_Open("dev/ui/Login/Panel/KLUILogin/KLUILoginPanel",nil,nil, { panelState = PanelStateEnum.ConnectServer, isBackFromCreateRole = true })
    end

    SL:onLUAEvent(LUA_EVENT_PLAYER_LOGOUT)
end

---接收 KmlCreateRoleUI 界面事件，调整原lua界面部分组件显隐
---message[2] = "false" Kml界面开启，message[2] = "true" Kml界面关闭
function this:HideChooseRolePanel(id, message)
    if message then
        if message[2] == "true" then
            self:HideChooseRole()
        end
        --self:SetPlayerRoleModelShowState(message[2] == "true")
    end
end

---isShow = false 创建角色时隐藏现有角色模型
function this:SetPlayerRoleModelShowState(isShow)
    if not isShow then
        for _, v in pairs(self.ItemList) do
            GUI:SetActive(v.Model.view.root, false)
        end
    else
        for _, v in pairs(self.ItemList) do
            if v.Model then
                GUI:SetActive(v.Model.view.root, true)
                v.Model.role.transform.localPosition = Vector3.New(0, -300, -100)
            end
        end
    end
end

function this:ShowChooseRole()
    GUI:SetActive(self.view.StartButton, false)
    GUI:UIPanel_Open("dev/ui/CreateRole/Panel/KLUICreateRole/KLUICreateRolePanel", nil, nil, { unlockList = SL.LoginManager:GetLoginRes_UnlockList(), uiCreateRolePanel = self })
    --local t = GUI:DOAnchorPos(GUI:GetRectTransform(self.view.CreatButton), self.createEndPos, 0.5)
    --GUI:TweenSetOnComplete(t, function()
    --    GUI:SetActive(self.view.NewCreateButton, false)
    --    GUI:UIPanel_Open("dev/ui/CreateRole/Panel/KLUICreateRole/KLUICreateRolePanel", nil, nil, { unlockList = SL.LoginManager:GetLoginRes_UnlockList(), uiCreateRolePanel = self })
    --end)
end

function this:HideChooseRole()
    --local t = GUI:DOAnchorPos(GUI:GetRectTransform(self.view.CreatButton), self.createStartPos, 0.5)
    --GUI:TweenSetOnComplete(t, function()
    --    if self.view then
    --        GUI:SetActive(self.view.goBtn, true)
    --        GUI:SetActive(self.view.backBtn, true)
    --    end
    --end)
    if self.view then
        GUI:SetActive(self.view.goBtn, true)
        GUI:SetActive(self.view.backBtn, true)
    end
end

---@param message UserProtos.RemoveRoleRes
function this:ResRemoveRoleMessage(id, message)
    SL.LoginManager:RemoveRole(message)
    self:ShowRole()
    SL:onLUAEvent(LUA_EVENT_DELETEROLE, message.role)
end
---@param message UserProtos.RandomRoleNameRes
function this:ResRandomRoleNameMessage(id, message)
    self.randomName = message.roleName
end

---@param message UserProtos.CreateRoleRes
function this:ResCreateRoleMessage(id, message)
    SL.SDKMgr:SubmitGameData(ESubmitDataType.CreateRole, nil, message.role.rid, message.role.name, message.role.level)
    SL.NetManager:PrintMessage(id, message)
    SL.LoginManager:AddRoleRes(message)
    if self.Model ~= nil then
        self.Model:RecycleEffect()
        self.Model = nil
    end
    self:HideChooseRole()
    self:AddPlayer(message)
    self:HideChooseRolePanel(_, { [2] = "true" })
    if not SL.Main:IsLocalServer() or SL.Main:IsEditor() then
        self:UpdateHttpUserInfo(SL.LoginManager:GetOpenId(), message.role.rid, message.role.name, message.role.career.baseCareer)
    end
    ---创角成功关闭kml创角界面
    GUI:UIPanel_Close('dev/ui/CreateRole/Panel/KLUICreateRole/KLUICreateRolePanel')
    SL:onLUAEvent(LUA_EVENT_CREATEROLE, message.role)
end

function this:UpdateHttpUserInfo(openId, rid, rName, rBaseCareer)
    local tbl = {
        openId = openId,
        rid = tostring(rid),
        rName = rName,
        rBaseCareer = rBaseCareer,
        sid = SL.LoginManager:GetCurServer_Sid(),
        createTime = os.time(),
        channelId = SL.LoginManager:GetChannelId()
    }
    local loginForm = SL:GetWWWForm(tbl)
    local loginUrl = SL.UIStaticParameter:GetCreateServerUrl()
    SL:logNoFlag(loginUrl)
    SL.Http:RequestWWW(loginUrl, loginForm, self.UpdateRoleBack, self)
end

function this:EnterGameOnExitSceneEditor()
    if SL:GetIsXtra() then
        if SL:IsSceneEditorOperTypeClose() then
            self:StartButtonOnClick()
        end
    end
end

return this
