---@class KLRechargePushPanel:UIKmlLuaPanelBase
---@field view KLRechargePushPanelView
local KLRechargePushPanel = class(UIKmlLuaPanelBase)
local this = KLRechargePushPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.curIndex = 1
    self.BtnList = {}
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseBtn, self, self.CloseBtnOnClick)
    GUI:AddOnClickEvent(self.view.BuyBtn, self, self.BuyBtnOnClick)
end

function this:BuyBtnOnClick()
    if self.dataList then
        GUI:UIPanel_Close("dev/outui/Recharge/Panel/KLRechargePush/KLRechargePushPanel")
        local GiftTbl = SL:GetConfig("cfg_gift_preferential", self.dataList[self.curIndex].giftId)
        shortcutOutMgr.DO(GiftTbl.Jump)
        SL:HideMainPanel()
    end

end
function this:CloseBtnOnClick()
    local topPanel = GUI:GetUI("dev/ui/MainUI/Panel/KLUISystemTop/KLUISystemTopPanel")
    if topPanel then
        topPanel:Refresh()
    end
    GUI:UIPanel_Close("dev/outui/Recharge/Panel/KLRechargePush/KLRechargePushPanel")
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    if not InfoManager.rechargePushInfo:IsShowBtn() then
        GUI:UIPanel_Close("dev/outui/Recharge/Panel/KLRechargePush/KLRechargePushPanel")
    end
    self.ItemList = {}
    self.dataList = {}
    local infoList = InfoManager.rechargePushInfo.DataList
    for _, v in pairs(infoList) do
        if v.endTime >= Time.GetServerTime() then
            table.insert(self.dataList, v)
        end
    end
    local index = 1
    local pos = {
        { 384, 95 },
        { 379, 35 },
        { 374, -25 },
        { 368, -85 }
    }
    for _, v in pairs(self.BtnList) do
        GUI:UIPanel_Close(nil, v)
    end
    self.BtnList = {}
    for _, v in pairs(self.dataList) do
        if not self.BtnList[index] then
            self.BtnList[index] = GUI:UIPanel_Open("dev/outui/Recharge/Item/KLPushGiftBtn/KLPushGiftBtnItem", self.view.Bg, self, nil, true,function(tempUI)
                self.BtnList[index] = tempUI
                GUI:setPosition(self.BtnList[index].view.root, pos[index][1], pos[index][2])
                local GiftTbl = SL:GetConfig("cfg_gift_preferential", v.giftId)
                GUI:Text_setString(self.BtnList[index].view.BtnText, GiftTbl.name)
                GUI:AddOnClickEvent(self.BtnList[index].view.GiftBtn, self, self.ShowBtnOnClick, index)
            end)
        end
        index = index + 1
    end
    self:ShowBtnOnClick(_, 1)
end
function this:ShowBtnOnClick(_, index)
    if index then
        self:SetSelectImg(index)
    end
end
function this:SetSelectImg(index)
    for i, v in pairs(self.BtnList) do
        local GiftTbl = SL:GetConfig("cfg_gift_preferential", self.dataList[index].giftId)
        if i == index then
            self.curIndex = index
            GUI:Image_loadTexture(v.view.GiftBtn, "button_choosen", "Atlas/QJ5_RechargePushPanel.spriteatlas")
            self:ShowMountModel(GiftTbl)
            self:ShowItem(GiftTbl)
            GUI:Text_setString(self.view.BuyBtn, tostring(GiftTbl.buttonTips))
            self:UpDataBtnUI(GiftTbl.id)
            GUI:SetActive(v.view.Time, false)
            GUI:setPosition(v.view.BtnText, 0, 0)
            v:ShowTime(self.dataList[i].endTime)
        else
            v:ShowTime(self.dataList[i].endTime)
            GUI:SetActive(v.view.Time, true)
            GUI:setPosition(v.view.BtnText, 0, 10)
            GUI:Text_setString(self.view.BuyBtn, tostring(GiftTbl.buttonTips))
            GUI:Image_loadTexture(v.view.GiftBtn, "button_unchoosen", "Atlas/QJ5_RechargePushPanel.spriteatlas")
        end
    end
end
function this:UpDataBtnUI(rechargeId)
    local buycount, totalcount = InfoManager.countInfo:GetLimitAndTotalCountByRechargeId(rechargeId)
    if buycount <= 0 then
        GUI:Text_setString(self.view.BuyBtn, "已购买")
    end
end
function this:ShowItem(GiftTbl)
    local careerId = SL:GetMetaValue(EMetaVarGetKey.JOB)
    local index = 1
    for i, award in pairs(GiftTbl.item) do
        --首充道具
        if award[1] == nil or (careerId ~= nil and careerId == award[1]) then
            index = index + 1
            local itemId = award[2]
            local count = award[3]
            local data = {
                width = "80",
                height = "80",
                itemid = itemId,
                mfixsize = "80,80",
                mscale = "40,40,40",
                tips = "1",
                itemcustomcount = count
            }
            if self.ItemList[index] then
                GUI:Item_UpdataData(self.ItemList[index], data)
            else
                local item = GUI:Item_Create(self.view.gridview2, data)
                self.ItemList[index] = item
            end
            GUI:AddOnClickEvent(self.ItemList[index], self, function()
                SL:OpenTips(nil, itemId)
            end)
        end
    end
end
function this:ShowMountModel(Tbl)
    if not Tbl then
        return
    end
    local careerId = SL:GetMetaValue(EMetaVarGetKey.JOB)
    local scale = 1
    local mrotate = "0,0,0"
    local x = "0"
    local y = "0"
    local z = "0"
    local path = ""
    local ani = ""
    local rX = 1
    local rY = 0
    local rZ = 0
    for _, model1 in pairs(Tbl.model) do
        if tonumber(model1[2]) == careerId then
            path = model1[1]
            --GUI:Text_setString(self.view.ShowInfoText, tostring(model1[2]))
        end
    end
    for _, model2 in pairs(Tbl.modelCondition) do
        if tonumber(model2[5]) == careerId then
            x = model2[1]
            y = model2[2]
            z = model2[3]
            scale = tonumber(model2[4])
        end
    end
    for _, model3 in pairs(Tbl.modelRevolve) do
        if tonumber(model3[4]) == careerId then
            --mrotate = model3[1] .. "," .. model3[2] .. "," .. model3[3]
            rX = tonumber(model3[1])
            rY = tonumber(model3[2])
            rZ = tonumber(model3[3])
        end
    end
    if Tbl.modelBehavior then
        for _, model4 in pairs(Tbl.modelBehavior) do
            if tonumber(model4[2]) == careerId then
                ani = model4[1]
            end
        end
    end
    if Tbl.tips then
        for _, tip in pairs(Tbl.tips) do
            if tonumber(tip[2]) == careerId then
                GUI:Text_setString(self.view.Texts, tostring(tip[1]))
            end
        end
    end
    local data = {
        mscale = 1 .. "," .. 1 .. "," .. 1,
        mrotate = mrotate,
        x = x,
        y = y,
        z = z,
        a = "00",
        src = path,
        ani = ani,
    }
    if self.cur_mount_model then
        GUI:Item_UpdataData(self.cur_mount_model, data)
    else
        self.cur_mount_model = GUI:Model_Create(self.view.Item_model, data)
    end
    GUI:setScale(self.cur_mount_model, scale / 10)
    GUI:setRotationSkewX(self.cur_mount_model, rX)
    GUI:setRotationSkewY(self.cur_mount_model, rY)
    GUI:setRotation(self.cur_mount_model, rZ)
end
function this:Close()

    SL:ShowMainPanel()
    for _, v in pairs(self.BtnList) do
        GUI:UIPanel_Close(nil, v)
    end
    self.BtnList = {}
end

return this
