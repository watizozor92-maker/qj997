---@class KLUIPrivilegeItemDescriptionPanel:UIKmlLuaPanelBase
---@field view KLUIPrivilegeItemDescriptionPanelView
local KLUIPrivilegeItemDescriptionPanel = class(UIKmlLuaPanelBase)
local this =KLUIPrivilegeItemDescriptionPanel
---创建时调用一次
function this:Init()
    self.privilegeType = {
        [1] = self.GetGoldenBranches(),
        [2] = self:GetCarryShop(),
        [3] = self:GetMonsterProtect(),
        [4] = self:GetExpandBag(),
        [5] = self:GetPrivilegeWarehouse(),
        [6] = self:GetAutoBuyMedicine(),
        [7] = self:GetChangeAttrPoints(),
        [8] = self:GetChangeMasterTalent(),
        [9] = self:GetDropOddsDouble(),
        [10] = self:GetExpDouble(),
        [11] = self:GetRecoverProceeds(),
        [12] = self:GetPatrolOnHook(),
        [13] = self:GetRemoteRepositories(),
        [14] = self:GetUpgradeTradeLimit(),
        [15] = self.GetDropAndExperience(),
    }

    GUI:DataListInitData( self.view.datalist_tips,function()
        return self:ListItemCountFunc()
    end,function(realIndex)
        return self:ListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:ListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:ListItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

function this:ListItemCountFunc()
    return #self.descList - 1
end

function this:ListItemGetFunc(realIndex)

end

function this:ListItemInitFunc(realIndex, kmlcontrol)

end

function this:ListItemUpdateFunc(realIndex, kmlcontrol)
    local text = GUI:GetChildControl(self.view.datalist_tips, realIndex, "text_tip")
    GUI:Text_setString(text, self.descList[realIndex + 2])
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.img_mask_click, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.button_tip, self, self.button_tip)
    --GUI:UIPanel_Open("dev/outui/Privilege/Panel/KLUIPrivilegeItemDescription/KLUIPrivilegeItemDescriptionPanel")
end

function this:button_tip()
    self:CloseSelf()
    if self.baseUI then
        self.baseUI:CloseSelf()
    end
    GUI:UIPanel_Open("dev/ui/Map/Panel/KLBigMap/KLBigMapPanel")
end

---创建或者刷新界面数据时调用
function this:Refresh()
    ---黄金 1， 钻石 2
    local type = self.args.type
    local uiType = self.args.uiType
    if uiType == 4 and type == 2 then
        self.descList = self:GetDiamondExpandBag()
    elseif uiType == 5 and type == 2 then
        self.descList = self:GetDiamondPrivilegeWarehouse()
    else
        self.descList = self.privilegeType[uiType]
    end
    GUI:Text_setString(self.view.text_tip_title, self.descList[1])
    GUI:DataListUpdateData(self.view.datalist_tips)
    if uiType == 1 then
        GUI:setVisible(self.view.button_tip, true)
    else
        GUI:setVisible(self.view.button_tip, false)
    end
end

function this:CloseSelf()
    GUI:UIPanel_Close("dev/outui/Privilege/Panel/KLUIPrivilegeItemDescription/KLUIPrivilegeItemDescriptionPanel")
end

function this:GetGoldenBranches()
    return {
        "野外地图开放黄金分线",
        "1.消耗月卡时间兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>获取超额收益。",
        "2.如果当前角色的月卡时间不足,可以直接消耗背包内的月卡道具兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>。",
        "3.激活<color=#00ff00>黄金特权</color>后,可以开启<color=#00ff00>黄金分线</color>,前往不同地图的特权分线。"
    }
end

function this:GetDropAndExperience()
    return {
        "掉落经验加成50%",
        "1.消耗月卡时间兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>获取超额收益。",
        "2.如果当前角色的月卡时间不足,可以直接消耗背包内的月卡道具兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>。",
        "3.激活<color=#00ff00>黄金特权</color>后,在部分野外地图可获得<color=#00ff00>掉落、经验加50%</color>效果,其中经验加成会被<color=#00ff00>钻石特权</color>的经验加成效果覆盖,掉落加成与<color=#00ff00>钻石特权</color>的互相叠加"
    }
end

function this:GetCarryShop()
    return {
        "随身商店",
        "1.消耗月卡时间兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>获取超额收益。",
        "2.如果当前角色的月卡时间不足,可以直接消耗背包内的月卡道具兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>。",
        "3.激活<color=#00ff00>黄金特权</color>后,可以开启<color=#00ff00>随身商店</color>,可以随时购买生命治疗药剂、魔力恢复药剂。"
    }
end

function this:GetMonsterProtect()
    return {
        "小怪挂机保护",
        "1.消耗月卡时间兑换黄金特权或钻石特权获取超额收益。",
        "2.如果当前角色的月卡时间不足,可以直接消耗背包内的月卡道具兑换黄金特权或钻石特权。",
        "3.激活黄金特权后,可以在小怪挂机点开启小怪挂机保护功能,开启挂机保护,任何玩家无法对你造成伤害,离线和在线都生效。",
    }
end

function this:GetExpandBag()
    return {
        "拓展背包",
        "1.消耗月卡时间兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>获取超额收益。",
        "2.如果当前角色的月卡时间不足,可以直接消耗背包内的月卡道具兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>。",
        "3.激活<color=#00ff00>黄金特权</color>后,可获得<color=#00ff00>160格</color>扩展背包,特权失效后,空置的格子将会被回收,已放置道具的格子会在取消占用后回收。"
    }
end

function this:GetPrivilegeWarehouse()
    return {
        "特权仓库",
        "1.消耗月卡时间兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>获取超额收益。",
        "2.如果当前角色的月卡时间不足,可以直接消耗背包内的月卡道具兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>。",
        "3.激活<color=#00ff00>黄金特权</color>后,可获得<color=#00ff00>2页</color>特权仓库,特权失效后,空置的格子将会被回收,已放置道具的格子会在取消占用后回收。"
    }
end

function this:GetAutoBuyMedicine()
    return {
        "自动买药",
        "1.消耗月卡时间兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>获取超额收益。",
        "2.如果当前角色的月卡时间不足,可以直接消耗背包内的月卡道具兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>。",
        "3.激活<color=#00ff00>黄金特权</color>后,可以开启<color=#00ff00>自动买药</color>功能,可以在背包中生命治疗药剂、魔力恢复药剂不足时,自动消耗金币补充。"
    }
end

function this:GetChangeAttrPoints()
    return {
        "切换加点方案",
        "1.消耗月卡时间兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>获取超额收益。",
        "2.如果当前角色的月卡时间不足,可以直接消耗背包内的月卡道具兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>。",
        "3.激活<color=#00ff00>黄金特权</color>后,可在加点界面<color=#00ff00>切换加点方案</color>,玩家可保存<color=#00ff00>2套加点方案</color>进行切换。"
    }
end

function this:GetChangeMasterTalent()
    return {
        "大师天赋免费切换",
        "1.消耗月卡时间兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>获取超额收益。",
        "2.如果当前角色的月卡时间不足,可以直接消耗背包内的月卡道具兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>。",
        "3.激活<color=#00ff00>黄金特权</color>后,可在<color=#00ff00>免费切换大师天赋页</color>"
    }
end

function this:GetDropOddsDouble()
    return {
        "掉率翻倍",
        "1.消耗月卡时间兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>获取超额收益。",
        "2.如果当前角色的月卡时间不足,可以直接消耗背包内的月卡道具兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>。",
        "3.激活<color=#00ff00>钻石特权</color>后,立享<color=#00ff00>掉落翻倍</color>特权,本特权可以与月卡三倍收益叠加"
    }
end

function this:GetExpDouble()
    return {
        "经验翻倍",
        "1.消耗月卡时间兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>获取超额收益。",
        "2.如果当前角色的月卡时间不足,可以直接消耗背包内的月卡道具兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>。",
        "3.激活<color=#00ff00>钻石特权</color>后,立享<color=#00ff00>经验翻倍</color>特权,本特权可以与月卡三倍收益叠加"
    }
end

function this:GetRecoverProceeds()
    return {
        "回收收益",
        "1.消耗月卡时间兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>获取超额收益。",
        "2.如果当前角色的月卡时间不足,可以直接消耗背包内的月卡道具兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>。",
        "3.激活<color=#00ff00>钻石特权</color>后,<color=#00ff00>奇迹币回收价增加30%</color>。"
    }
end

function this:GetPatrolOnHook()
    return {
        "巡逻挂机",
        "1.消耗月卡时间兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>获取超额收益。",
        "2.如果当前角色的月卡时间不足,可以直接消耗背包内的月卡道具兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>。",
        "3.激活<color=#00ff00>钻石特权</color>后,可以开启<color=#00ff00>巡逻挂机</color>功能,开启<color=#00ff00>巡逻挂机</color>后,玩家会自动寻找本地图上的黄金怪进行战斗。玩家若在开启<color=#00ff00>巡逻挂机</color>后<color=#00ff00>离开游戏</color>则自动开启离线巡逻挂机。"
    }
end

function this:GetDiamondExpandBag()
    return {
        "拓展背包",
        "1.消耗月卡时间兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>获取超额收益。",
        "2.如果当前角色的月卡时间不足,可以直接消耗背包内的月卡道具兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>。",
        "3.激活<color=#00ff00>钻石特权</color>后,可获得<color=#00ff00>320格</color>扩展背包,特权失效后,空置的格子将会被回收,已放置道具的格子会在取消占用后回收。"
    }
end

function this:GetDiamondPrivilegeWarehouse()
    return {
        "特权仓库",
        "1.消耗月卡时间兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>获取超额收益。",
        "2.如果当前角色的月卡时间不足,可以直接消耗背包内的月卡道具兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>。",
        "3.激活<color=#00ff00>钻石特权</color>后,可获得<color=#00ff00>2页</color>特权仓库,特权失效后,空置的格子将会被回收,已放置道具的格子会在取消占用后回收。"
    }
end

function this:GetRemoteRepositories()
    return {
        "远程仓库",
        "1.消耗月卡时间兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>获取超额收益。",
        "2.如果当前角色的月卡时间不足,可以直接消耗背包内的月卡道具兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>。",
        "3.激活<color=#00ff00>钻石特权</color>后,开启<color=#00ff00>远程仓库</color>,开启仓库不再需要传送到勇者大陆,可以随时取出、存入道具或装备。"
    }
end

function this:GetUpgradeTradeLimit()
    return {
        "交易行寄售上限提升",
        "1.消耗月卡时间兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>获取超额收益。",
        "2.如果当前角色的月卡时间不足,可以直接消耗背包内的月卡道具兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>。",
        "3.激活<color=#00ff00>钻石特权</color>后,能够额外<color=#00ff00>解锁5个交易行寄售格子</color>,能够同时卖出更多道具。"
    }
end

function this:Close()
end

return this
