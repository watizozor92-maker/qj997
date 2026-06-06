---@class KLUIRechargeDirectPanel:UIKmlLuaPanelBase
---@field view KLUIRechargeDirectPanelView
local KLUIRechargeDirectPanel = class(UIKmlLuaPanelBase)
local this =KLUIRechargeDirectPanel
--运营活动-直购礼包面板
---创建时调用一次
function this:Init()
    self.giftDatas = {}
    self.allGifts = {}
    GUI:DataListInitData(self.view.giftDataList, function()
        return table.count(self.giftDatas)
    end, function(realIndex)
        local data = self.giftDatas[realIndex + 1]
        local item = GUI:UIPanel_Open("dev/outui/RunActive_RechargeDirect/Item/KLUIRechargeDirectGift/KLUIRechargeDirectGiftItem",self.view.giftDataList,self,data,true)
        self.allGifts[realIndex + 1] = item
        return item.view.root.kmlControl
    end, function(realIndex, kmlcontrol)
        
    end, function(realIndex, kmlcontrol)
        local data = self.giftDatas[realIndex + 1]
        self.allGifts[realIndex + 1]:RefreshItem(data)
    end)
end

function this:RefreshGifts()
    local currentGroup = self.mainOperateActivityInfo.NowOperateActivityMainGroup
    local cfg = SL:GetConfigTable("cfg_OperateActivity_CDM")
    self.giftDatas = {}
    for k,v in ipairs(cfg) do
        if v.mainGroup == currentGroup and (v.bugType == 1 or v.bugType == 3) then
            table.insert(self.giftDatas,v)
        end
    end
    for i,v in ipairs(self.giftDatas) do
        v.index = i
    end
    GUI:DataListUpdateData(self.view.giftDataList)
end

function this:buyAllBtn()
    if self.buyAllRechargeCfg then
        for k,cfg in ipairs(self.giftDatas) do
            local rechargeCfg = SL:GetConfigTwoKeys("cfg_recharge",cfg.id,cfg.rechargeType,"parameter","type")
            if not rechargeCfg then
                return
            end
            if rechargeCfg.amount > 0 then
                local count,totalcount = InfoManager.countInfo:GetLimitAndTotalCountByKey(rechargeCfg.Countkey)
                if count < totalcount then
                    SL:TipMessage("有已购买的礼包，无法购买",1,NoticeType.NoticeMid)
                    return
                end
            end
        end
        GUIUtil.SDKPay(self.buyAllRechargeCfg,1)        
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.buyAllBtn,self,self.buyAllBtn)
    SL:RegisterLUAEvent(LUA_EVENT_MAINOPERATEACTIVITY_CHANGE, self.LUA_EVENT_MAINOPERATEACTIVITY_CHANGE, self)
end

function this:LUA_EVENT_MAINOPERATEACTIVITY_CHANGE()
    self:Refresh()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if self.args then
        self.mainOperateActivityInfo = self.args.OperateActivityInfo
    end
    if not self.mainOperateActivityInfo then return end
    local leftTime = self.mainOperateActivityInfo:GetOADJSTimeBySubType(EOperateActivityActivityType.RechargeDirect)
    GUI:SetControl_time(self.view.refreshTime, leftTime)
    local group = self.mainOperateActivityInfo.NowOperateActivityMainGroup
    local tempTbl = SL:GetConfig("cfg_OperateActivity_CDM",group,"mainGroup")
    if tempTbl and tempTbl.img and not string.isNullOrEmpty(tempTbl.img) then
        GUI:Image_loadTexture(self.view.bg,string.format("Texture/%s.png",tempTbl.img))
    end
    self:RefreshGifts()
    --一键购买
    local buyAllActivityCfg = SL:GetConfigMultiKeys("cfg_OperateActivity_CDM",group,2,"mainGroup","bugType")
    if buyAllActivityCfg then
        self.buyAllRechargeCfg = SL:GetConfigTwoKeys("cfg_recharge",buyAllActivityCfg.id,buyAllActivityCfg.rechargeType,"parameter","type")
        if self.buyAllRechargeCfg then
            GUI:setVisible(self.view.buyAllBtn,true)
            --原价现价
            GUI:Text_setString(self.view.oldText,string.format("原价：  <color=red>%d</color>",buyAllActivityCfg.parameter))
            GUI:Text_setString(self.view.priceText,string.format("%d元",self.buyAllRechargeCfg.amount))
        else
            GUI:setVisible(self.view.buyAllBtn,false)
        end
    else
        GUI:setVisible(self.view.buyAllBtn,false)
    end
end

function this:Close()
    SL:UnRegisterLUAEvent(LUA_EVENT_MAINOPERATEACTIVITY_CHANGE, self.LUA_EVENT_MAINOPERATEACTIVITY_CHANGE, self)
end

return this
