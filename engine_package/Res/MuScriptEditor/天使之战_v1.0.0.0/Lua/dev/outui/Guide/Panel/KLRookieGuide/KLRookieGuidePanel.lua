---@class KLRookieGuidePanel:UIKmlLuaPanelBase
---@field view KLRookieGuidePanelView
local KLRookieGuidePanel = class(UIKmlLuaPanelBase)
local this = KLRookieGuidePanel
local panel_check_times = 100 --引导打开界面检出的次数

---地图引导处理
local BigMapPanel = "KLBigMapPanel"
---创建时调用一次
function this:Init()
    self.arrowPos = { [1] = self.view.TopArrow, [2] = self.view.DownArrow, [3] = self.view.LeftArrow, [4] = self.view.RightArrow }
    self.comp_Rect = SL:GetRectGuideMaskComp(GUI:GetGameObject(self.view.RectMask_Real))
    GUI:setScaleY(self.view.RawImage,0.5209424)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self:Reset()
    self:ShowGuideKml(self.args.guideId)
end
    
---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:Close()
    self:Reset()
    if self.loadTextureRequest then
        SL:DisposeAsset(self.loadTextureRequest)
        self.loadTextureRequest = nil
    end
end

---@param id number
function this:ShowGuideKml(id)
    self.cort = Coroutine.Start(this.ShowGuideBaseKml, self, id)
end

function this:Reset()
    GUI:SetActive(self.view.TipsGo, false)
    GUI:SetActive(self.view.HighlightGo, false)
    GUI:SetActive(self.view.CircleGo, false)
    GUI:setVisible(self.view.RectMask, false)
    self:HidePointControlGuide()
    if self.cort then
        Coroutine.Stop(self.cort)
        self.cort = nil
    end

    if self.moveY then
        GUI:DOKill(self.moveY)
        self.moveY = nil
    end
    if self.moveX then
        GUI:DOKill(self.moveX)
        self.moveX = nil
    end

    if self.clone_Highlight then
        SL:DestroyObjectImmediate(self.clone_Highlight)
        self.clone_Highlight = nil
    end
    if self.highlightClone then
        SL:DestroyObjectImmediate(self.highlightClone)
        self.highlightClone = nil
    end
    if self.contentClone then
        SL:DestroyObjectImmediate(self.contentClone)
        self.contentClone = nil
    end
    if self.panelId then
        GUI:DelCloneControl(self.panelId, self.contrName .. "_clonePanel")
    end
    self.pointPanelId = nil
    self.pointContrId = nil
end

function this:CheckIsLastGuideEnd(rearId)
    if rearId then
        if rearId == KLGuideManager.getMaxGuideId() then
            --引导结束
            --SL.SDKMgr:SubmitGameData(ESubmitDataType.Event, "gameTutorial")
        end
    end
end

function this:ShowGuideBaseKml(id)
    Coroutine.WaitForEndOfFrame()
    Coroutine.WaitForEndOfFrame()
    local clm = SL:GetConfig('cfg_rookie_guide', id)
    local address = clm.uiAddress
    local addrSplit = string.split(address, '&')
    local panelId = addrSplit[1]
    local contrName = addrSplit[2]
    local contrTransform
    for i = 1, panel_check_times do
        local panel_ui = GUI:GetUIByPanelName(panelId)
        if GUI:IsUILoading(panel_ui) then
            Coroutine.Wait(0.3)
        else
            break
        end
    end
    --引导的时候关闭滑动条的滑动
    self:CloseOSAScrollView(panelId)
    Coroutine.WaitForEndOfFrame()
    Coroutine.WaitForEndOfFrame()
    if table.contains(clm.showType, EGuideShowType.Highlight) then
        if not string.isNullOrEmpty(clm.args) then
            if string.startsWith(clm.uiAddress, "KLOnHookPanel") then
                local argsList = ToolFunc.AnalysisStr(clm.args,nil,{"#"})
                local panel = GUI:GetUI("dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel")
                --if panel then
                --    panel:GuideToShowMonster(argsList[1],argsList[2])
                --    Coroutine.Wait(0.5)
                --end
                local error = true
                for i = 1, panel_check_times do
                    if GUI:IsUILoading(panel) then
                        Coroutine.Wait(0.3)
                    else
                        error = false
                        panel:GuideToShowMonster(argsList[1],argsList[2])
                        Coroutine.Wait(0.5)
                        break
                    end
                end
                
                if error then
                    SL:LogError("打开KLOnHookPanel界面引导出错，请检查原因")
                end
            end
        end
        if panelId == "KLBigMapPanel" then
            local args = ToolFunc.MatchStr(contrName)
            local panel = GUI:GetUI("dev/ui/Map/Panel/KLBigMap/KLBigMapPanel")
            if panel then
                local error = true
                for i = 1, panel_check_times do
                    if GUI:IsUILoading(panel) then
                        Coroutine.Wait(0.3)
                    else
                        error = false
                        panel:GuideToShowMap(args)
                        Coroutine.Wait(0.5)
                        break
                    end
                end
                if error then
                    SL:LogError("打开KLBigMapPanel界面引导出错，请检查原因")
                end
            end
        end
    end
    
    if contrName then
        contrTransform = GUI:GetControlTransform(panelId, contrName)
    end

    if contrTransform == nil and not table.contains(clm.showType, EGuideShowType.ToProp) then
        return
    end

    for i, showType in ipairs(clm.showType) do
        if showType == EGuideShowType.Content then
            GUI:Text_setString(self.view.Desc, clm.guideText)
            local p_width, p_height = GUI:GetTextPreferredWH(self.view.Desc)
            if contrTransform then
                GUI:setContentSize(self.view.GuideBG, p_width + 100, p_height + 50)
                local _, _, posZ = GUI:GetWorldPosition(self.view.GuideBG)
                --获取UI的中心点坐标
                ---@type Vector4
                local vec4 = SL:GetWorldCorners(contrTransform)
                local x = (vec4.x + vec4.z) / 2
                local y = (vec4.y + vec4.w) / 2
                --获取中心点坐标的屏幕坐标
                local scrPoint = SL:ConvertWorldPos2Screen(x, y)
                local bool, endPos = GUI:ScreenPointToLocalPointInRectangle(self.view.TipsGo, scrPoint)
                if bool then
                    if clm.arrowPosition == 1 or clm.arrowPosition == 2 then
                        GUI:setPosition(self.view.GuideBG, endPos.x, clm.arrowPosition == 1 and endPos.y - (p_height + 80) or endPos.y + (p_height + 80))
                    else
                        GUI:setPosition(self.view.GuideBG, endPos.x, endPos.y)

                        local ax, ay = GUI:getPosition(self.view.GuideBG)
                        if clm.arrowPosition == 3 then
                            ax = ax + contrTransform.rect.width / 2 + (p_width + 100) / 2 + 50
                            GUI:setPosition(self.view.GuideBG, ax, ay)
                        else
                            ax = ax - contrTransform.rect.width / 2 - (p_width + 100) / 2 - 50
                            GUI:setPosition(self.view.GuideBG, ax, ay)
                        end
                    end
                end
            end
            for k, arrow in pairs(self.arrowPos) do
                GUI:SetActive(arrow, k == clm.arrowPosition)
            end
            GUI:SetActive(self.view.Left_People, clm.guidePeople == 1)
            GUI:SetActive(self.view.Right_People, clm.guidePeople == 2)
            local delta = clm.guidePeople == 0 and 0 or (clm.guidePeople == 1 and 50 or -50)
            GUI:setPositionX(self.view.Desc, delta)
            local obj = GUI:GetGameObject(self.view.TipsGo)
            self.contentClone = SL:GameObjectInstantiate(obj, contrTransform.parent, true)
            self.contentClone:SetActive(true)
            ---@type UnityEngine.RectTransform
            local contentTrans = SL:GetRectTransfomComp(self.contentClone)
            --Dotween动画
            local contentX = contentTrans.anchoredPosition.x
            local contentY = contentTrans.anchoredPosition.y
            if clm.arrowPosition == 1 or clm.arrowPosition == 2 then
                self.moveY = GUI:DOAnchorPosY(contentTrans, contentY + 5, 0.6)
                GUI:TweenSetLoops(self.moveY, math.maxinteger)
                GUI:TweenSetEase(self.moveY, ELeanTweenType.pingPong)
            else
                self.moveX = GUI:DOAnchorPosX(contentTrans, contentX + 5, 0.6)
                GUI:TweenSetLoops(self.moveX, math.maxinteger)
                GUI:TweenSetEase(self.moveX, ELeanTweenType.pingPong)
            end

        elseif showType == EGuideShowType.Highlight then
            
            --控件高亮
            if contrTransform then
                ---@type Vector4
                local vec4 = SL:GetWorldCorners(contrTransform)
                local center_x = (vec4.x + vec4.z) / 2
                local center_y = (vec4.y + vec4.w) / 2
                if clm.highlightType == 0 then
                    GUI:setContentSize(self.view.RawImage, clm.highlightScale[1], clm.highlightScale[2])
                    GUI:setPosition(self.view.RawImage, clm.highlightPosition[1], clm.highlightPosition[2])
                    local _, _, worldZ = GUI:GetWorldPosition(self.view.Effect)
                    GUI:SetWorldPosition(self.view.Effect, center_x, center_y, worldZ)
                    local obj = GUI:GetGameObject(self.view.Effect)
                    self.highlightClone = SL:GameObjectInstantiate(obj, contrTransform.parent, true)
                    self.highlightClone:SetActive(true)
                    if not table.isNullOrEmpty(clm.img) and table.count(clm.img) > 0 then
                        local imgPath = clm.img[1]
                        if imgPath ~= "" then
                            local co, loadTextureRequest = SL:LoadAssetAsync(imgPath, function(res)
                                local rImgTrans = self.highlightClone.transform:GetChild(0)
                                local rImg = rImgTrans:GetComponent(typeof(CS.UnityEngine.UI.RawImage))
                                local texture = res
                                rImg.texture = texture
                            end)
                            if self.loadTextureRequest then
                                SL:DisposeAsset(self.loadTextureRequest)
                                self.loadTextureRequest = nil
                            end
                            self.loadTextureRequest = loadTextureRequest
                        end
                    end
                else
                    local _, _, worldZ = GUI:GetWorldPosition(self.view.Effect)
                    GUI:SetWorldPosition(self.view.CircleGo, center_x, center_y, worldZ)
                    GUI:setContentSize(self.view.RawImage, clm.highlightScale[1], clm.highlightScale[2])
                    GUI:setPosition(self.view.RawImage, clm.highlightPosition[1], clm.highlightPosition[2])
                    local obj = GUI:GetGameObject(self.view.CircleGo)
                    self.highlightClone = SL:GameObjectInstantiate(obj, contrTransform.parent, true)
                    self.highlightClone:SetActive(true)
                end

            end

        elseif showType == EGuideShowType.Mask then
            self:ShowRectMask(contrTransform)
        elseif showType == EGuideShowType.ToProp then
            if string.startsWith(clm.uiAddress, "KLShopMallPanel") then
                local itemShowIdList = clm.itemShowId
                local showId
                for _, itemShowIdInfo in pairs(itemShowIdList) do
                    local itemId = itemShowIdInfo[1]
                    local needCareer = itemShowIdInfo[2]
                    if SL:MeData_GetCareer().baseCareer == needCareer or needCareer == nil then
                        showId = itemId
                        break
                    end
                end
                if showId then
                    local panel = GUI:GetUI("dev/ui/ShopMall/Panel/KLShopMall/KLShopMallPanel")
                    if panel then
                        if panel.hasInit then
                            panel:GotoItemSubPage(showId, id)
                        else
                            SL:ScheduleOnce(1, function()
                                panel:GotoItemSubPage(showId, id)
                            end)
                        end
                    end
                end
            elseif string.startsWith(clm.uiAddress, "KLUIBagPanel") then
                local itemShowIdList = clm.itemShowId
                local showId
                for _, itemShowIdInfo in pairs(itemShowIdList) do
                    local itemId = itemShowIdInfo[1]
                    local needCareer = itemShowIdInfo[2]
                    if SL:MeData_GetCareer().baseCareer == needCareer or needCareer == nil then
                        showId = itemId
                        break
                    end
                end
                if showId then
                    local panel = GUI:GetUI("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
                    if panel then
                        panel:GuideToShowItem(showId)
                    end
                end
            end
        end

    end

    -- 有后置或者是强引导并且不是指向道具(指向道具要等相关模块确定指向了哪个在去处理)
    if (clm.rearGuide ~= 0 or clm.guideType == EGuideFinishType.ClickControl) and not table.contains(clm.showType, EGuideShowType.ToProp) then

        self.panelId = panelId
        self.contrName = contrName

        local index
        if clm.guideType == EGuideFinishType.ClickControl then
            index = 2000
        else
            index = 1700
        end
        if GUI:IsInScrollView(self.panelId,self.contrName) then
            index = 2000
        end
        ---@type UIKmlLuaControl
        local cloneControl = GUI:CloneControl(self.panelId, self.contrName, index or 0, 1)
        local rearGuide = clm.rearGuide
        GUI:AddOnClickEvent(cloneControl, self, self.ClickCloneBtn, {rearGuide, self.panelId, self.contrName, contrTransform ,clm.id})
    end

    if clm.guideType == EGuideFinishType.AnyClick then
        GUI:setVisible(self.view.MaskGo, false)
    else
        GUI:setVisible(self.view.MaskGo, true)
    end
    self:CheckIsLastGuideEnd(id)
end

function this:ShowRectMask(uiCtrl)
    GUI:setVisible(self.view.RectMask, true)
    self.comp_Rect:SetTarget(uiCtrl.transform)
end

function this:AddPointControlGuide(panelId, contrId, guideId)
    local clm = SL:GetConfig('cfg_rookie_guide', guideId)
    if clm then
        local contrTransform = GUI:GetControlTransform(panelId, contrId)

        if contrTransform == nil then
            return
        end
        --控件高亮
        if contrTransform then
            ---@type Vector4
            local vec4 = SL:GetWorldCorners(contrTransform)
            local x = (vec4.x + vec4.z) / 2
            local y = (vec4.y + vec4.w) / 2

            local _, _, worldZ = GUI:GetWorldPosition(self.view.Effect)
            GUI:SetWorldPosition(self.view.Effect, x, y, worldZ)
        end
        GUI:setContentSize(self.view.RawImage, 230, 600)

        GUI:setPosition(self.view.RawImage, clm.highlightPosition[1], clm.highlightPosition[2])
        local obj = GUI:GetGameObject(self.view.RawImage)
        self.clone_Highlight = SL:GameObjectInstantiate(obj, contrTransform.parent)
        self.clone_Highlight:SetActive(true)
        GUI:setPosition(self.view.RawImage, 0, 0)

        ---@type UIKmlLuaControl
        local cloneControl = GUI:CloneControl(panelId, contrId, 2000, 1)
        local rearGuide = clm.rearGuide
        GUI:AddOnClickEvent(cloneControl, self, self.ClickCloneBtn, {rearGuide, panelId, contrId, contrTransform,clm.id })
        self.pointPanelId = panelId
        self.pointContrId = contrId
    end
end

function this:HidePointControlGuide()
    if self.pointPanelId then
        GUI:DelCloneControl(self.pointPanelId, self.pointContrId .. "_clonePanel")

        if self.clone_Highlight then
            SL:DestroyObjectImmediate(self.clone_Highlight)
            self.clone_Highlight = nil
        end

        self.pointPanelId = nil
        self.pointContrId = nil
    end

end

function this:ClickCloneBtn(control, eventData)
    local rearGuide = eventData[1]
    local panelId = eventData[2]
    local contrName = eventData[3]
    local contrTransform = eventData[4]
    local guideId = eventData[5]
    if rearGuide then
        KLGuideManager.SetNextGuide(rearGuide)
    end

    local btn = SL:GetButtonComp(contrTransform)
    btn.onClick:Invoke()

    GUI:DelCloneControl(panelId, contrName .. "_clonePanel")
    self.panelId = nil
    self.contrName = nil

    if self.clone_Highlight then
        SL:DestroyObjectImmediate(self.clone_Highlight)
        self.clone_Highlight = nil
    end
    if self.highlightClone then
        SL:DestroyObjectImmediate(self.highlightClone)
        self.highlightClone = nil
    end
    if self.contentClone then
        SL:DestroyObjectImmediate(self.contentClone)
        self.contentClone = nil
    end

    if self.moveY then
        GUI:DOKill(self.moveY)
        self.moveY = nil
    end
    if self.moveX then
        GUI:DOKill(self.moveX)
        self.moveX = nil
    end

end

function this:CloseOSAScrollView(panelId)
    if panelId == BigMapPanel then
        ---@type KLBigMapPanel
        local panel = GUI:GetUIByPanelName(panelId)
        GUI:OSAScrollView_SetScrollable(panel.view.TransferScrollView,false)
    end
end

return this
