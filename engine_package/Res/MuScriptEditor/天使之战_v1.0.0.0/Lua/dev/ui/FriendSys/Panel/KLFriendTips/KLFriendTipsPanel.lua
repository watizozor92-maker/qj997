---@class KLFriendTipsPanel:UIKmlLuaPanelBase
---@field view KLFriendTipsPanelView
local KLFriendTipsPanel = class(UIKmlLuaPanelBase)
local this =KLFriendTipsPanel
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local content = "1、添加好友时需对方同意后才会成为好友。\n2、好友互动可以增加亲密度。\n3、屏蔽后将无法接收该玩家的信息。\n4、被陌生人击杀后会自动将其加入宿敌。"
    if self.args and self.args.type == "hook" then
        content = "1、等级达到70级后开启离线挂机助手，玩家离线前需先前往挂机点开启自动战斗，离线将持续挂机获得相同收益。\n2、挂机点挂机有被杀风险，被杀后将回城只获得泡点收益。\n3、离线挂机时自动消耗药品，如果已开启特权也正常生效：自动拾取、自动回收、自动买药。\n4、每次离线只累计12小时收益，再次登录可重置时间。\n5、装备、金币、道具类收益在挂机时实时获得经验收益将在上线时统一领取。"
    end
    GUI:Text_setString(self.view.TextContent, content)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.BtnClose, self, self.CloseMe)
end

function this:CloseMe()
    GUI:UIPanel_Close(self.filePath)
end

function this:Close()
end

return this
