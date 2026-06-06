---@class KLQuintonInvasionPanel:UIKmlLuaPanelBase
---@field view KLQuintonInvasionPanelView
local KLQuintonInvasionPanel = class(UIKmlLuaPanelBase)
local this =KLQuintonInvasionPanel
function this:AsyncLoadUI()
        end
---创建时调用一次
function this:Init()
        SL:SetCampNameList({"苍狼阵营","巨龙阵营","猎鹰阵营"})
        self.reward_all_item = {}
        GUI:DataListInitData(self.view.rewardList,function()
                return self:RewardDataListItemCountFunc()
        end,function(realIndex)
                return self:RewardDataListItemGetFunc(realIndex)
        end,function(realIndex, kmlcontrol)
                return self:RewardDataListItemInitFunc(realIndex, kmlcontrol)
        end, function(realIndex, kmlcontrol)
                return self:RewardDataListItemUpdateFunc(realIndex, kmlcontrol)
        end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
        GUI:AddOnClickEvent(self.view.enterBtn,self,self.OnCliCkEnterBtn)
        GUI:AddOnClickEvent(self.view.rewardBtn,self,self.OnCliCkRewardBtn)
        GUI:AddOnClickEvent(self.view.shopBtn,self,self.OnCliCkShopBtn)
end

function this:OnCliCkEnterBtn()
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    if mapId == 21000 then
        SL:TipMessage(SL:GetConfig("cfg_string",33001).text, 1, NoticeType.NoticeMid)
        return
    end
    local cond, message = InfoManager.godsDescendInfo.CheckActivityConditionMapId(21001)
    if cond then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GOTO_CROSS_MAP,{})
    else
            SL:TipMessage(message, 1, NoticeType.NoticeMid)
    end
end

function this:OnCliCkRewardBtn()
        GUI:UIPanel_Open("dev/outui/Activity/Panel/KLQuintonInvasionReward/KLQuintonInvasionRewardPanel",nil,nil,2012)
end

function this:OnCliCkShopBtn()
        GUI:UIPanel_Open("dev/ui/ShopMall/Panel/KLShopMall/KLShopMallPanel",nil,nil,2012)
        GUI:UIPanel_Close("dev/outui/CrossServer/Panel/KLCrossServerMain/KLCrossServerPanel")
        SL.HideMainPanel()
end

---界面显示时调用一次
function this:Show()
        
end
---创建或者刷新界面数据时调用
function this:Refresh()
        ---@type cfg_activity_rule_column
        local tab = SL:GetConfig("cfg_activity_rule",21001)
        local tbl = SL:GetConfig("cfg_map_info", tab.mapid[1])
        local needLevel = tbl.condition[1]
        local needStrengthLevel = tbl.condition[2]
        local needAttachLevel = tbl.condition[3]
        local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
        local strengthLevel = SL:GetMetaValue(EMetaVarGetKey.GET_STRENGTH_ADD_ATTRIBUTE,EForgeGroupType.Strength)
        local addLevel = SL:GetMetaValue(EMetaVarGetKey.GET_STRENGTH_ADD_ATTRIBUTE,EForgeGroupType.Add)
        local des = GUIUtil.GetColorText("等级".. needLevel,level>=needLevel and "#00ff00" or "#ff2323")
        des = des.. "\n" .. GUIUtil.GetColorText("强化总等级"..needStrengthLevel.."级",strengthLevel>=needStrengthLevel and "#00ff00" or "#ff2323")
        des = des.. " " .. GUIUtil.GetColorText("追加总等级"..needAttachLevel.."级",addLevel>=needAttachLevel and "#00ff00" or "#ff2323")
        GUI:Text_setString(self.view.enterTimeDes,tab.timeText)
        GUI:Text_setString(self.view.activity_des,tab.uiTextRule)
        GUI:Text_setString(self.view.enterLevel,des)
        self:RefreshReward()
end

function  this:RefreshReward()
        ---@type cfg_rep_column
        local tbl = SL:GetConfig("cfg_rep",21001,"id")
        self.rewardData = tbl.UIreward
        GUI:DataListUpdateData(self.view.rewardList)
end

function this:RewardDataListItemCountFunc()
        return #self.rewardData
end

function this:RewardDataListItemGetFunc(realIndex)
        local data = self.rewardData[realIndex + 1]
        local message = {cfgId = data[1],count="",width = 65,height=65}
        local item = GUI:UIPanel_Open("dev/outui/Activity/Item/KLItem/KLItemItem",self.view.rewardList,self,message,true)
        self.reward_all_item[item.view.root] = item
        return item.view.root
end

function this:RewardDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:RewardDataListItemUpdateFunc(realIndex, kmlcontrol)
        local data = self.rewardData[realIndex + 1]
        self.reward_all_item[kmlcontrol]:RefreshItem(data[1],"")
end

function this:Close()
end

return this
