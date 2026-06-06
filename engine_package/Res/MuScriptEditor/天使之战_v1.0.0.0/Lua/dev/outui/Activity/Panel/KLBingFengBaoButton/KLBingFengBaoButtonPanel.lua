---@class KLBingFengBaoButtonPanel:UIKmlLuaPanelBase
---@field view KLBingFengBaoButtonPanelView
local KLBingFengBaoButtonPanel = class(UIKmlLuaPanelBase)
local this =KLBingFengBaoButtonPanel
local MountOffSetY = 28
local UnionOffSetY = 0
local BingFengFloorPos = {x = 224, z = 204}
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    SL:KeepOpenPanel("KLBingFengBaoButtonPanelKml",true)
    GUI:setVisible(self.view.button_ZhanLing,self.args and self.args.open)
    GUI:Button_setTitleText(self.view.button_ZhanLing, (self.args and self.args.open) and "占领" or "取消占领")
    
end

---注册UI事件和服务器消息
function this:RegistEvents()

    GUI:AddOnClickEvent(self.view.button_ZhanLing,self,self.ZhanLing)
    GUI:AddOnClickEvent(self.view.btnGo,self,self.BtnGoClick)
end

function this:BtnGoClick()
    SL:PathMoveTo(BingFengFloorPos)
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh(open)
    if not self.StartY then
        self.StartY = GUI:GetAnchoredPosition(self.view.panel2).y
    end
    
    if SL:MeData_GetUnionId() ~= 0 then
        UnionOffSetY = 20
    end
    
    if EquipFunc.GetMountIsShow() then
        GUI:setPositionY(self.view.panel2, self.StartY + MountOffSetY + UnionOffSetY)
    else
        GUI:setPositionY(self.view.panel2, self.StartY + UnionOffSetY)
    end
    
    self.data = InfoManager.bingFengBaoInfo.data
    local ZhanLingName = "无"
    local zlTime = 0
    local LinShiUnionName = "无"
    local rid

    if self.data then
        rid = self.data.masterRid
        ZhanLingName = self.data.actorName or "无"
        zlTime = tonumber(self.data.zlTime)
        LinShiUnionName = self.data.CurrentUnionName
    end
    zlTime = zlTime > 180 and 180 or zlTime

    if rid == tonumber(SL:MeData_GetId()) then
        GUI:Button_setTitleText(self.view.button_ZhanLing, "取消占领")
    else
        GUI:Button_setTitleText(self.view.button_ZhanLing, "占领")
    end
    --占领者
    GUI:Text_setString(self.view.text4,string.format("冰风堡占领者：<color=#00FF00>【%s】</color><color=#31AAFF>【%d/180】</color>",ZhanLingName,zlTime))
    --占领时长
    GUI:setVisible(self.view.text5,false)
    --占领战盟
    GUI:Text_setString(self.view.text6, string.format("当前正在占领中的战盟：<color=#ED27FF>【%s】</color>",LinShiUnionName))
    if SL:GetMetaValue(EMetaVarGetKey.USER_IS_DIE) then
        InfoManager.bingFengBaoInfo.open = false
    end

    if open and not SL:GetMetaValue(EMetaVarGetKey.USER_IS_DIE) then
        GUI:setVisible(self.view.button_ZhanLing,open)
    else
        GUI:setVisible(self.view.button_ZhanLing,false)
    end
end


function this:Hide()
end

function this:Close()
end
-- 添加防抖功能相关变量
function this:ZhanLing()
    -- 检查是否在冷却中
    if self.isButtonInCooldown then
        return  -- 如果在冷却中，则不执行任何操作
    end

    -- 设置按钮为冷却状态
    self.isButtonInCooldown = true

    -- 执行实际的点击逻辑
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_BING_FENG_BAO,
    {
        sendType=3,mainPage = 1,
    })
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    -- 设置0.5秒后解除冷却状态
    self.timer = SL:ScheduleOnce(0.5, function()
        self.isButtonInCooldown = false
    end)
end




return this
