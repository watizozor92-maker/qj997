---@class KLRechargeActivityTwoItem:UIKmlLuaPanelBase
---@field view KLRechargeActivityTwoItemView
local KLRechargeActivityTwoItem = class(UIKmlLuaPanelBase)
local this =KLRechargeActivityTwoItem
--限时礼包单个礼包
---创建时调用一次
function this:Init()
    self.canBuy = false
    --道具奖励
    GUI:DataListInitData(self.view.giftDataList,function()
    return self:ItemRewardItemCountFunc()
    end,function(realIndex)
        return self:ItemRewardItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:ItemRewardItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:ItemRewardItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.Item_Reward_all_item = {}

    GUI:Effect_Create(self.view.RedDot,{
        effectid="40001",mpos="-47,-16,0",mscale="0.75,0.8,0.75",mrotate="0,0,0"
    })
end

--region 道具奖励列表
function this:ItemRewardItemCountFunc()
    return #self.allItemRewardData
end
function this:ItemRewardItemGetFunc(realIndex)
    local itemId = self.allItemRewardData[realIndex + 1][1]
    local itemCount = self.allItemRewardData[realIndex + 1][2]
    local item = GUI:Item_Create(self.view.giftDataList,{
        width = 60,
        height = 60,
        itemid = itemId,
        --mfixsize = "80,80",
        tips = "1",
        itemcustomcount = itemCount,
    })
    GUI:AddOnClickEvent(item,self,function()
        SL:OpenTips(nil,itemId)
    end)

    self.Item_Reward_all_item[realIndex + 1] = item
    return item.kmlControl
end
function this:ItemRewardItemInitFunc(realIndex, kmlcontrol)
end
function this:ItemRewardItemUpdateFunc(realIndex, kmlcontrol)
    local itemId = self.allItemRewardData[realIndex + 1][1]
    local itemCount = self.allItemRewardData[realIndex + 1][2]
    local item = self.Item_Reward_all_item[realIndex + 1]
    GUI:Item_setItemId(item,itemId)
    --GUI:Item_setItemCount(item,itemCount)
    GUI:Item_setItemCount(item,tostring(itemCount))
    GUI:AddOnClickEvent(item,self,function()
        SL:OpenTips(nil,itemId)
    end)
end

function this:RefreshItemList(gift)
    self.allItemRewardData = gift
    GUI:DataListUpdateData(self.view.giftDataList)
end
--endregion 道具奖励列表

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.buyButton, self, self.BuyButtonOnClick)
end

function this:BuyButtonOnClick()
    if not self.args.canBuy then
        --SL:TipMessage({ SL:GetConfig('cfg_string', 330).text, 1, NoticeType.NoticeMid })
        SL:TipMessage( "请先解锁上一档礼包",1, NoticeType.NoticeMid)
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_BUY_TIME_LIMIT_GIFT ,{id = self.args.giftCfg.id})
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if self.args then
        --高度
        GUI:Image_loadTexture(self.view.BG,string.format("Texture/img_rechargeBg%d.png",self.args.giftCfg.sort))
        --道具列表
        self:RefreshItemList(self.args.giftCfg.gift)
        --按钮
        if self.args.hasBuy then
            GUI:setVisible(self.view.buyButton,false)
        else
            GUI:setVisible(self.view.buyButton,true)
            if table.count(self.args.giftCfg.cost) == 0 then
                GUI:setVisible(self.view.zuanshi,false)
                GUI:Text_setString(self.view.buyCount,"免费")
            else
                --GUI:Image_loadTexture(self.view.zuanshi,) --TODO:根据道具id显示图标
                GUI:setVisible(self.view.zuanshi,true)
                --GUI:setContentSize(self.view.zuanshi,43,24) --组件自适应偶尔会把宽改成0
                GUI:Text_setString(self.view.buyCount,tostring(self.args.giftCfg.cost[2]))
            end
            if self.args.canBuy then
                GUI:setVisible(self.view.LockUI,false)
            else
                GUI:setVisible(self.view.LockUI,true)
            end
        end
    end
end

function this:RefreshItem(args)
    self.args = args
    self:Refresh()
end

function this:Close()
    self.canBuy = false
end

return this
