---@class KLUIPrivilegeIntroducePanel:UIKmlLuaPanelBase
---@field view KLUIPrivilegeIntroducePanelView
local KLUIPrivilegeIntroducePanel = class(UIKmlLuaPanelBase)
local this =KLUIPrivilegeIntroducePanel
---创建时调用一次
function this:Init()
    GUI:DataListInitData( self.view.datalist_introduce,function()
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
    return #self.introduceList
end

function this:ListItemGetFunc(realIndex)

end

function this:ListItemInitFunc(realIndex, kmlcontrol)

end

function this:ListItemUpdateFunc(realIndex, kmlcontrol)
    local text = GUI:GetChildControl(self.view.datalist_introduce, realIndex, "text_introduce")
    GUI:Text_setString(text, self.introduceList[realIndex + 1])
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.button_close, self, self.CloseSelf)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.introduceList = self:GetTotalDescription()
    GUI:DataListUpdateData(self.view.datalist_introduce)
end

function this:GetTotalDescription()
    return {
        "1.可以消耗月卡时间兑换<color=#00ff00>黄金特权</color>或<color=#00ff00>钻石特权</color>获取超额收益。",
        "2.使用<color=#00ff00>黄金特权卡</color>后激活30天<color=#E6E600>黄金特权</color>",
        "激活后可获得以下特权",
        "<color=#00ff00>·开启黄金线</color>",
        "<color=#00ff00>·黄金线中额外享受50%的经验、掉落加成</color>",
        "<color=#00ff00>·开启小怪挂机保护功能</color>",
        "<color=#00ff00>·背包空间增加160格</color>",
        "<color=#00ff00>·开启自动买药</color>",
        "<color=#00ff00>·开启随身商店功能</color>",
        "<color=#00ff00>·开启加点方案切换</color>",
        "3.使用<color=#00ff00>钻石特权卡</color>后激活30天<color=#E6E600>钻石特权</color>",
        "激活后可获得以下特权",
        "<color=#00ff00>·装备掉率增加100%</color>",
        "<color=#00ff00>·怪物经验增加100%</color>",
        "<color=#00ff00>·奇迹而回收价增加30%</color>",
        "<color=#00ff00>·开启黄金怪挂机功能</color>",
        "<color=#00ff00>·背包空间增加320格</color>",
        "<color=#00ff00>·开启远程仓库</color>",
        "<color=#00ff00>·增加交易行寄售格子5格</color>",
    }
end

function this:CloseSelf()
    GUI:UIPanel_Close("dev/outui/Privilege/Panel/KLUIPrivilegeIntroduce/KLUIPrivilegeIntroducePanel")
end

function this:Close()
end

return this
