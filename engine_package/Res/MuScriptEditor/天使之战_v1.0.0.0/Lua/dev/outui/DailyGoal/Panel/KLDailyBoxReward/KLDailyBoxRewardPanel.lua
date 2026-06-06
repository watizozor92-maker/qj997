---@class KLDailyBoxRewardPanel:UIKmlLuaPanelBase
---@field view KLDailyBoxRewardPanelView
local KLDailyBoxRewardPanel = class(UIKmlLuaPanelBase)
local this =KLDailyBoxRewardPanel
---创建时调用一次
function this:Init()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if not self.args then
        return
    end
    self.rewardList = self.args.rewardList
    for _, rewardItem in pairs(self.rewardList) do
        --[[GUI:Item_Create(self.view.item_group,{
            width = "80",
            height = "80",
            itemid = rewardId,
            tips = "1",
            mfixsize = "80,80",
        })]]
        GUI:UIPanel_Open("dev/outui/DailyGoal/Item/KLDailyBoxReward/KLDailyBoxRewardItem",self.view.item_group,self,rewardItem,true)
        
    end
    ---@type cfg_activeness_reward_column
    local config = self.args.config
    local index = math.tointeger(config.axNum // 20)
    GUI:Image_loadTexture(self.view.img_title,"txt_title_boxLv" .. tostring(index),"Atlas/DailyGoal.spriteatlas")
    GUI:SetActive(self.view.btn_get_reward,self.args.showBtnGet)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close,self,self.BtnCloseOnClick)
    GUI:AddOnClickEvent(self.view.btn_get_reward,self,self.BtnGetRewardOnClick)
end

function this:BtnCloseOnClick()
    GUI:UIPanel_Close("dev/outui/DailyGoal/Panel/KLDailyBoxReward/KLDailyBoxRewardPanel")
    --GUI:UIPanel_Open("dev/outui/DailyGoal/Panel/KLDailyBoxReward/KLDailyBoxRewardPanel",_,_,{["rewardList"]={10010001,10020001},["title"]=2})
end

function this:BtnGetRewardOnClick()
    ---@type cfg_activeness_reward_column
    local config = self.args.config
    SL:SendLuaNetMsg(LuaMessageIdToSever.GET_DAILY_ACTIVITY_REWARD,config.id)
    self:BtnCloseOnClick()
end

function this:Close()
end

return this
