---@class KLPreviewPanel:UIKmlLuaPanelBase
---@field view KLPreviewPanelView
---@field tabType number 页签类型
local KLPreviewPanel = class(UIKmlLuaPanelBase)
local TabType = {
    Guide = enum(1),
    GamePlay = enum(2)
}
---创建时调用一次
function KLPreviewPanel:Init()
    self.onClickCfgId = -1
    self.selectid = 1
    self.previewCreatList = {}
    self.previewCreatListIndex = 0
    self.rewardItemInfo = {}
    self.imgSchedule = {}
    SL.HideMainPanel()
    
    GUI:DataListInitData(self.view.reward_data, function()
        return self:DataListRewardItemCountFunc()
    end, function(realIndex)
        return self:DataListRewardItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataListRewardItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListRewardItemUpdateFunc(realIndex, kmlcontrol)
    end)
    --GetPreviewData
end
function KLPreviewPanel:DataListItemCountFunc()
    return table.count(self.Info)
end
function KLPreviewPanel:DataListItemGetFunc(realIndex)

end
function KLPreviewPanel:DataListItemInitFunc(realIndex, kmlcontrol)

end
function KLPreviewPanel:DataListItemUpdateFunc(realIndex, kmlcontrol)
    local btn = GUI:GetChildControl(self.view.previewlist,realIndex,'toggle') --self.view.previewlist:GetChildControl(realIndex, 'toggle')
    local red = GUI:GetChildControl(self.view.previewlist,realIndex,"red")  --self.view.previewlist:GetChildControl(realIndex, "red")
    
    self.btn[realIndex] = btn
    GUI:AddOnClickEvent(self.btn[realIndex], self, function()
        self:LoadPanel(realIndex)
        if self.tabType == TabType.GamePlay then
            GUI:SetActive(red, false)
        end
    end)

    local data = self.Info[realIndex + 1]
    if data["red"] == 1 then
        GUI:SetActive(red, true)
    else
        GUI:SetActive(red, false)
    end
    local testtext = GUI:GetChildControl(self.view.previewlist,realIndex,"test") --self.view.previewlist:GetChildControl(realIndex, "test")
    GUI:Text_setString(testtext, data.name[1][1])

end

function KLPreviewPanel:DataListRewardItemCountFunc()
    return table.count(self.rewardItemInfo)
end
function KLPreviewPanel:DataListRewardItemGetFunc(realIndex)

end
function KLPreviewPanel:DataListRewardItemInitFunc(realIndex, kmlcontrol)

end
function KLPreviewPanel:DataListRewardItemUpdateFunc(realIndex, kmlcontrol)
    local receive_item = GUI:GetChildControl(self.view.reward_data,realIndex,'receive_item') --self.view.previewlist:GetChildControl(realIndex, 'toggle')
    local clickItem = GUI:GetChildControl(self.view.reward_data,realIndex,"clickItem")  --self.view.previewlist:GetChildControl(realIndex, "red")
    local data = self.rewardItemInfo[realIndex + 1]
    GUI:Item_UpdataData(receive_item, {
        itemid = data[1],
        itemcount = data[2] or 1
    })
    GUI:AddOnClickEvent(clickItem, self, function()
        SL:OpenTips("", data[1])
    end)
end

---创建或者刷新界面数据时调用
function KLPreviewPanel:Refresh()
    self.previewRewardInfo = SL:TaskInfo_GetPreviewRewardInfo()
    local isGamePlay = self.args and self.args.togType and self.args.togType == 2
    self.selectid = self.args and self.args.subType and self.args.subType or 1
    GUI:Text_setText(self.view.text1, isGamePlay and "玩法" or "Guide")
    if isGamePlay then
        --GUI:SetTogDefaultThis(self.view.Tog_Preview)
        self:OnValueChange_Tog_Preview(nil, nil, { true })
    else
        --GUI:SetTogDefaultThis(self.view.Tog_Guide)
        self:OnValueChange_Tog_Guide(nil, nil, { true })
    end
    --self:RefreshRedDot()
end

function KLPreviewPanel:RefreshRedDot()
    local result = InfoManager.qjAcademyInfo:GetGuideRedDot()
    GUI:setVisible(self.view.RedDot_Guide, result)
    GUI:setVisible(self.view.RedDot_Preview, InfoManager.qjAcademyInfo:GetGamePlayRedDot())
end

---刷新攻略
function KLPreviewPanel:RefreshPreview()
    self.cfgInfo = SL:GetConfigTable("cfg_preview")
    self.Info = self:LoadInfo()
    if #self.Info == 0 then
        GUI:UIPanel_Close("dev/ui/Preview/Panel/KLPreview/KLPreviewPanel")
        SL.ShowMainPanel()
        return
    end
    self.btn = {}
    GUI:DataListInitData(self.view.previewlist, function()
        return self:DataListItemCountFunc()
    end, function(realIndex)
        return self:DataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListUpdateData(self.view.previewlist,_,function()
        for i, v in pairs(self.btn) do
            if i == self.selectid - 1 then
                GUI:Button_loadTextureNormal(v, "btn_cebian1", "Atlas/FG_Common.spriteatlas")
            else
                GUI:Button_loadTextureNormal(v, "btn_cebian2", "Atlas/FG_Common.spriteatlas")
            end
        end
    end)
    self:LoadPanel(self.selectid and self.selectid - 1 or 0)
    self:RefreshBtnLayout()
    self.onClickCfgId = -1

end

---刷新玩法
function KLPreviewPanel:RefreshGamePlay()
    self.cfgInfo = SL:GetConfigTable("cfg_gamePlay")
    self.Info = self:LoadGamePlayInfo()
    GUI:DataListInitData(self.view.previewlist, function()
        return self:DataListItemCountFunc()
    end, function(realIndex)
        return self:DataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.btn = {}
    GUI:DataListUpdateData(self.view.previewlist,_,function()
        for i, v in pairs(self.btn) do
            if i == self.selectid - 1 then
                GUI:Button_loadTextureNormal(v, "btn_cebian1", "Atlas/FG_Common.spriteatlas")
            else
                GUI:Button_loadTextureNormal(v, "btn_cebian2", "Atlas/FG_Common.spriteatlas")
            end
        end
    end)
    self:LoadPanel(self.selectid and self.selectid - 1 or 0)
    self:RefreshBtnLayout()
    self.onClickCfgId = -1
end

---注册UI事件和服务器消息
function KLPreviewPanel:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.ClosePreviewPanel)
    GUI:SetToggleOnValueChange(self.view.Tog_Guide, self, self.OnValueChange_Tog_Guide)
    GUI:SetToggleOnValueChange(self.view.Tog_Preview, self, self.OnValueChange_Tog_Preview)
    GUI:AddOnClickEvent(self.view.receive_btn, self, self.GoToPanel)
    SL:RegisterLuaNetMsg(MessageDef.ResPreviewRewardInfoMessage, self.ResPreviewRewardInfoMessage, self)
    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE, self.LUA_EVENT_LEVELCHANGE, self)
end

function KLPreviewPanel:Close()
    SL:UnSchedule(self.maskSchedule)
    for k, v in pairs(self.imgSchedule) do
        SL:UnSchedule(v)
    end
    self.imgSchedule = {}
    SL.ShowMainPanel()
    SL:UnRegisterLuaNetMsg(MessageDef.ResPreviewRewardInfoMessage, self.ResPreviewRewardInfoMessage, self)
    InfoManager.qjAcademyInfo:SavePreviewRedDot()
end

function KLPreviewPanel:LoadPanel(index)
    self.selectid = index + 1
    GUI:SetActive(self.view.receive_btn, true)
    GUI:SetActive(self.view.receive_text, false)
    for i, v in pairs(self.btn) do
        if i == index then
            GUI:Button_loadTextureNormal(v, "btn_cebian1", "Atlas/FG_Common.spriteatlas")
        else
            GUI:Button_loadTextureNormal(v, "btn_cebian2", "Atlas/FG_Common.spriteatlas")
        end
    end
    -- 加载步骤：根据索引读表，解析，对应信息，显示
    local data = self.Info[index + 1]
    self.selectData = data
    if not data then
        data = {}
    end
    self.previewCreatList = {}
    self.previewCreatListIndex = 0
    GUI:DataListInitData(self.view.contentlist, function()
        return self:DataContentListCountFunc()
    end, function(realIndex)
        return self:DataContentListGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataContentListInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataContentListUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListUpdateData(self.view.contentlist,nil,function()
        self:InitSmall_TittleList()
    end)
    self.cfgid = data["id"]
    
    if self.tabType == TabType.GamePlay then
        InfoManager.qjAcademyInfo:SetPreviewRedDot(self.cfgid)
        GUI:setVisible(self.view.RedDot_Preview, InfoManager.qjAcademyInfo:GetGamePlayRedDot())
    elseif self.tabType == TabType.Guide then
        self:RefreshBtnLayout()
    end
    --[[local completionLevel = data["completionLevel"]
    if SL:MeData_GetLevel() >= completionLevel then
        if not self.previewRewardInfo[self.cfgid] then
            GUI:Button_setTitleText(self.view.receive_btn, "领取")
            GUI:AddOnClickEvent(self.view.receive_btn, self, self.Receive)
        else
            GUI:Button_setTitleText(self.view.receive_btn, "前往")
            GUI:AddOnClickEvent(self.view.receive_btn, self, function()
                self.GoToPanel(data)
            end)
        end
    else
        GUI:SetActive(self.view.receive_btn, false)
        str = "达到" .. completionLevel .. "解锁"
        GUI:SetActive(self.view.receive_text, true)
        if str then
            GUI:Text_setString(self.view.receive_text, str)
        end

    end]]
    if data.item then
        --GUI:Item_setItemId(self.view.receive_item,data.item[1])
        --GUI:Item_UpdataData(self.view.receive_item, {
        --    itemid = data.item[1],
        --    itemcount = data.item[2]
        --})
        --GUI:AddOnClickEvent(self.view.clickItem, self, function()
        --    SL:OpenTips("", data.item[1])
        --end)
        --SL:OpenTips("",data.item[1])
        if self.tabType == TabType.GamePlay then
            self.rewardItemInfo = data.item
            GUI:DataListUpdateData(self.view.reward_data)
        end
    end

end

function KLPreviewPanel:LoadInfo()
    --拿信息，根据信息排序
    local data = {}
    local complete = {} -- 可领取
    local done = {}  -- 已完成
    local incomplete = {} -- 未达成
    for k, v in pairs(self.cfgInfo) do
        local showinfo = v
        showinfo["red"] = 0
        if SL:MeData_GetLevel() >= showinfo.showLevel then
            if SL:MeData_GetLevel() >= showinfo.completionLevel then
                if self.previewRewardInfo[showinfo.id] then
                    --已完成
                    if SL:MeData_GetLevel() < showinfo.hideLevel then
                        table.insert(done, showinfo)
                    end
                else
                    -- 可领取未领取
                    showinfo["red"] = 1
                    table.insert(complete, showinfo)
                end
            else
                table.insert(incomplete, showinfo)
            end
            table.insert(data, showinfo)
        end
    end

    --[[table.sort(complete, function(a, b)
        return a.completionLevel < b.completionLevel
    end)
    table.sort(done, function(a, b)
        return a.completionLevel < b.completionLevel
    end)
    table.sort(incomplete, function(a, b)
        return a.completionLevel < b.completionLevel
    end)
    for i = 1, #complete do
        table.insert(data, complete[i])
    end
    for i = 1, #incomplete do
        table.insert(data, incomplete[i])
    end
    for i = 1, #done do
        table.insert(data, done[i])
    end]]
    return data
end

function KLPreviewPanel:LoadGamePlayInfo()
    local data = {}
    for i, v in pairs(self.cfgInfo) do
        local showinfo = v
        showinfo["red"] = (i > 1 and InfoManager.qjAcademyInfo:HasPreviewRedDotById(showinfo.id)) and 1 or 0
        if SL:MeData_GetLevel() >= showinfo.showLevel then
            table.insert(data, showinfo)
        end
    end
    return data
end


function KLPreviewPanel:OnClick_Btn_Receive()
    if self.onClickCfgId == self.cfgid then
        --SL:MessageTip({ id = 501 })
        return
    end
    self.onClickCfgId = self.cfgid
    SL:ReqReceivePreviewRewardMessage(self.cfgid)
    if self.maskSchedule then
        SL:UnSchedule(self.maskSchedule)
    end
    --[[self.maskSchedule = SL:ScheduleOnce(0.5, function()
        self.onClickCfgId = -1
    end)]]
end

function KLPreviewPanel:Receive()
    if self.onClickCfgId == self.cfgid then
        SL:MessageTip({ id = 501 })
        return
    end
    self.onClickCfgId = self.cfgid
    SL:ReqReceivePreviewRewardMessage(self.cfgid)
    if self.maskSchedule then
        SL:UnSchedule(self.maskSchedule)
    end
    --[[self.maskSchedule = SL:ScheduleOnce(0.5, function()
        self.onClickCfgId = -1
    end)]]
end

function KLPreviewPanel:ClosePreviewPanel()
    GUI:UIPanel_Close("dev/ui/Preview/Panel/KLPreview/KLPreviewPanel")
    SL.ShowMainPanel()
end

---改变攻略按钮状态
function KLPreviewPanel:OnValueChange_Tog_Guide(_, args, data)
    local isOn = data[1]
    if isOn then
        self.tabType = TabType.Guide
        self:RefreshPreview()
    end
    self.onClickCfgId = -1
    GUI:setVisible(self.view.preview_receive, not isOn)
    GUI:setContentSize(self.view.content_scroll, 810, 356)
end

---改变预览按钮状态
function KLPreviewPanel:OnValueChange_Tog_Preview(_, args, data)
    local isOn = data[1]
    if isOn then
        self.tabType = TabType.GamePlay
        self:RefreshGamePlay()
        GUI:setContentSize(self.view.content_scroll, 810, 356)
    end
end

function KLPreviewPanel:GoToPanel()
    local data = self.selectData
    if data.openPanel[1] and not string.isNullOrEmpty(data.openPanel[1][1]) then
        GUI:UIPanel_Close("dev/ui/Preview/Panel/KLPreview/KLPreviewPanel")
        local uipath = data.openPanel[1][1]
        local args = data.openPanel[1][2]
        GUI:UIPanel_Open(uipath, nil, nil, args)
        SL:HideMainPanel()
    end
    --if data.Panel then
    --    GUI:UIPanel_Open(data.Panel,nil,nil,)
    --end
end

function KLPreviewPanel:DataContentListCountFunc()
    return table.count(self.Info[self.selectid]["name"])
end
function KLPreviewPanel:DataContentListGetFunc(realIndex)

end
function KLPreviewPanel:DataContentListInitFunc(realIndex, kmlcontrol)
    SL:Log('DataListItemInitFunc' .. tostring(realIndex))
end

function KLPreviewPanel:DataContentListUpdateFunc(realIndex, kmlcontrol)
    local nametext = GUI:GetChildControl(self.view.contentlist,realIndex,'preview_name') --self.view.contentlist:GetChildControl(realIndex, 'preview_name')
    local data = self.Info[self.selectid]
    local name = data["name"][realIndex + 1][1]
    if name then
        GUI:Text_setString(nametext, name)
    end
    
    local small_tittlelist = GUI:GetChildControl(self.view.contentlist,realIndex,'small_tittlelist') --self.view.contentlist:GetChildControl(realIndex, 'small_tittlelist')

    self.previewCreatList[realIndex + 1] = small_tittlelist
    --self.preview_content = small_tittlelist
    --self.preview_name = realIndex + 1
    
end

---刷新按钮已领取还是领取状态
function KLPreviewPanel:RefreshBtnLayout()
    if self.tabType == TabType.Guide then
        local data = self.Info[self.selectid]
        GUI:setVisible(self.view.BtnLayout, self.tabType == TabType.Guide)
        GUI:setVisible(self.view.img5, self.tabType == TabType.Guide)
        local canReceive = not self.previewRewardInfo[data.id]
        GUI:setVisible(self.view.img_receiveRed, canReceive)
        GUI:Button_setTitleText(self.view.Btn_Receive, canReceive and "领取" or "已领取")
        --GUI:Button_loadTextureNormal(btn_receive, canReceive and "btn_recive" or "btn_alreadyReceived", "Atlas/FG_Common.spriteatlas")
        if canReceive then
            GUI:AddOnClickEvent(self.view.Btn_Receive, self, self.OnClick_Btn_Receive)
        end
        local hasReward = not table.isNullOrEmpty(data.item)
        GUI:setVisible(self.view.Item_Reward, hasReward)
        if hasReward then
            GUI:Item_UpdataData(self.view.Item_Reward, {
                itemid = data.item[1],
                itemcount = data.item[2]
            })
        end
    end
end

function KLPreviewPanel:InitSmall_TittleList()
    self.previewCreatListIndex = self.previewCreatListIndex + 1
    if not self.previewCreatList[self.previewCreatListIndex] then
        return
    end
    GUI:DataListInitData(self.previewCreatList[self.previewCreatListIndex], function()
        return self:DataTittleListCountFunc()
    end, function(realIndex)
        return self:DataTittleListGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataTittleListInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataTittleListUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListUpdateData(self.previewCreatList[self.previewCreatListIndex],nil,function()
        self:RefreshSmall_TittleList(self.previewCreatListIndex - 1)
        self:InitSmall_TittleList()
        GUI:SetScrollView_scrollpos(self.view.content_scroll, 0)
    end)
end

function KLPreviewPanel:RefreshSmall_TittleList(index)
    if self.tabType ~= TabType.Guide then
        return
    end
    
    SL:ScheduleOnce(0.08, function()
        local preview_name_img = GUI:GetChildControl(self.view.contentlist,index,'preview_name_img')
        local layout1 = GUI:GetChildControl(self.view.contentlist,index,'layout1')
        local controls = { preview_name_img, layout1}
        local totalHeight = 400
        local count = table.count(self.Info[self.selectid]["describe"][index + 1])
        totalHeight = totalHeight - (count - 1 + 3) * 12
        for i, v in pairs(controls) do
            local tran = GUI:GetRectTransform(v)
            totalHeight = totalHeight - tran.rect.size.y
        end
        local space = GUI:GetChildControl(self.view.contentlist, index,'space')
        if totalHeight < 10 then
            totalHeight = 10
        end
        GUI:SetAttr(space, "preferredheight", totalHeight)
    end)
    
    --[[local _, sizey = GUI:getSizeDelta(GUI:GetChildControl(self.view.contentlist,index,'preview_name_img')) --(self.view.contentlist:GetChildControl(realIndex, 'preview_name_img'))
    local _, sizey1 = GUI:getSizeDelta(GUI:GetChildControl(self.view.contentlist,index,'layout1'))
    for i = 0, table.count(self.Info[self.selectid]["describe"][index + 1]) do
        local textlayout1 = GUI:GetChildControl(self.view.contentlist,index,"textlayout1") --self.view.contentlist:GetChildControl(realIndex, "textlayout1")
        sizey = sizey + GUI:getSizeDelta(textlayout1)
    end
    local content_layout = GUI:GetChildControl(self.view.contentlist,index,"content_layout")--self.view.contentlist:GetChildControl(realIndex, "content_layout")
    GUI:setContentSize(content_layout, 730, sizey + 12)]]
end

function KLPreviewPanel:DataTittleListCountFunc()
    return self.Info[self.selectid]["describe"][self.previewCreatListIndex] and table.count(self.Info[self.selectid]["describe"][self.previewCreatListIndex])
end
function KLPreviewPanel:DataTittleListGetFunc(realIndex)
end
function KLPreviewPanel:DataTittleListInitFunc(realIndex, kmlcontrol)
    --SL:Log('DataListItemInitFunc' .. tostring(realIndex))
end

function KLPreviewPanel:DataTittleListUpdateFunc(realIndex, kmlcontrol)
    local data = self.Info[self.selectid]["describe"][self.previewCreatListIndex][realIndex + 1]
    local content = self.previewCreatList[self.previewCreatListIndex]
    local preview_tittle = GUI:GetChildControl(content,realIndex,'preview_tittle') --self.preview_content:GetChildControl(realIndex, 'preview_tittle')
    local preview_text_layout = GUI:GetChildControl(content,realIndex,'preview_text_layout')
    local preview_img_layout = GUI:GetChildControl(content,realIndex,'preview_img_layout')
    local str = data[1]
    GUI:setVisible(preview_tittle, str ~= "img")
    GUI:setVisible(preview_text_layout, str ~= "img")
    GUI:setVisible(preview_img_layout, str == "img")
    if str == "img" then
        local preview_img = GUI:GetChildControl(content,realIndex,'preview_img')
         
        GUI:Image_loadTexture(preview_img, data[2], data[3])
        GUI:setVisible(preview_img,false)
        if self.imgSchedule[realIndex] then
            SL:UnSchedule(self.imgSchedule[realIndex])
            self.imgSchedule[realIndex] = nil
        end
        self.imgSchedule[realIndex] = SL:ScheduleOnce(0.1, function()
           GUI:setContentSize(preview_img, tonumber(data[4]), tonumber(data[5]))
           GUI:setVisible(preview_img,true)
        end)
        return
    end
    
    GUI:Text_setString(preview_tittle, str)

    local preview_text = GUI:GetChildControl(content,realIndex,'preview_text') --self.preview_content:GetChildControl(realIndex, 'preview_text')
    str = data[2]
    if str then
        GUI:Text_setString(preview_text, str)
    else
        GUI:Text_setString(preview_text, "")
    end
    local textlayout1 = GUI:GetChildControl(content,realIndex,"textlayout1") --self.preview_content:GetChildControl(realIndex, "textlayout1")
    --local preview_text_layout = GUI:GetChildControl(content,realIndex,"preview_text_layout")--self.preview_content:GetChildControl(realIndex, "preview_text_layout")
    local _, textsizey = GUI:getSizeDelta(preview_text)
    GUI:setContentSize(preview_text_layout, 700, textsizey)
    local _, imagesizey = GUI:getSizeDelta (GUI:GetChildControl(content,realIndex,'preciew_icon_img1'))--(self.preview_content:GetChildControl(realIndex, 'preciew_icon_img1'))
    GUI:setContentSize(textlayout1, 730, textsizey + imagesizey + 12)
end

---@param message RoleProtos.ReceivePreviewRewardRes  @预告奖励领取信息 响应
function KLPreviewPanel:ResPreviewRewardInfoMessage(_, message)
    local data = {}
    for k, v in pairs(message.receiveInfos) do
        self.previewRewardInfo[v.id] = v.isReceive

        local hideLeveltable = SL:GetConfig("cfg_preview", v.id, "id")
        local hideLevel = hideLeveltable["hideLevel"]
        if SL:MeData_GetLevel() >= hideLevel then
            table.insert(data, v.id)
        end
    end
    local itemdata = SL:GetConfig("cfg_preview", self.cfgid, "id").item
    local items = {}
    items[itemdata[1]] = itemdata[2]
    --SL:OpenRewardTips(items,0)
    SL:onLUAEvent(LUA_EVENT_PREVIEW_OVER, data)
    
    --self:Refresh()
    local btn_receive = self.view.Btn_Receive
    local img_receiveRed = self.view.img_receiveRed
    GUI:Button_setTitleText(btn_receive, "已领取")
    GUI:setVisible(img_receiveRed, false)
    ---@param v cfg_preview_column
    for i, v in ipairs(self.Info) do
        if v.id == self.onClickCfgId then
            local red = GUI:GetChildControl(self.view.previewlist, i - 1, "red")
            GUI:setVisible(red, false)
            break
        end
    end
end

---等级改变
function KLPreviewPanel:LUA_EVENT_LEVELCHANGE()
    if self.tabType == TabType.Guide then
        self:RefreshPreview()
    else
        self:RefreshGamePlay()
    end
    self:RefreshRedDot()
end

return KLPreviewPanel
