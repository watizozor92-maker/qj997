---@class KLBigSecretCopyPanel:UIKmlLuaPanelBase
---@field view KLBigSecretCopyPanelView
local KLBigSecretCopyPanel = class(UIKmlLuaPanelBase)
local this = KLBigSecretCopyPanel
---创建时调用一次
function this:Init()
    SL.HideMainPanel()
   

    GUI:DataListInitData(self.view.reward_data_list,function()
        return self:SecretRewardDataListItemCountFunc()
    end,function(realIndex)
        return self:SecretRewardDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:SecretRewardDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:SecretRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.AllRwward = {}
    self.reward_all_item = {}

    local saodang_str = SL:GetConfig("cfg_rule_text",19001).location
    GUI:Text_setString(self.view.pingfen_no,saodang_str)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_BIG_SECRET_REALM_PANEL_INFO, {})
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BIG_SECRET_REALM_PANEL_INFO,self.RES_BIG_SECRET_REALM_PANEL_INFO,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BIG_SECRET_REALM_RECEIVE_STATUS,self.RES_BIG_SECRET_REALM_RECEIVE_STATUS,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BIG_SECRET_REALM_CLEARANCE_PANEL_INFO,self.RES_BIG_SECRET_REALM_CLEARANCE_PANEL_INFO,self)
    GUI:AddOnClickEvent(self.view.btn_close,self,self.CloseOnclick)
    GUI:AddOnClickEvent(self.view.btn_exit,self,self.CloseOnclick)
    GUI:AddOnClickEvent(self.view.btn_join,self,self.JoinCopy)
    GUI:AddOnClickEvent(self.view.btn_sao_dang,self,self.SaoDangOnclick)
    GUI:SetToggleOnValueChange(self.view.reward_toggle, self, self.reward_toggle_OnClick)
    GUI:AddOnClickEvent(self.view.men_piao_item,self,self.men_piao_item_OnClick)
    
end

function this:Close()
    self:UnRegistEvents()
end


function this:UnRegistEvents()
    SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.RES_BIG_SECRET_REALM_PANEL_INFO,self.RES_BIG_SECRET_REALM_PANEL_INFO,self)
    SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.RES_BIG_SECRET_REALM_RECEIVE_STATUS,self.RES_BIG_SECRET_REALM_RECEIVE_STATUS,self)
    SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.RES_BIG_SECRET_REALM_CLEARANCE_PANEL_INFO,self.RES_BIG_SECRET_REALM_CLEARANCE_PANEL_INFO,self)
    
end

function this:CloseOnclick()
    GUI:UIPanel_Close("dev/outui/BigSecretCopy/Panel/KLBigSecretCopy/KLBigSecretCopyPanel")
    --GUI:UIPanel_Open("dev/outui/BigSecretCopy/Panel/KLBigSecretCopy/KLBigSecretCopyPanel")
    SL.ShowMainPanel()
end



function this:SecretRewardDataListItemCountFunc()
    return #self.AllRwward
end

function this:SecretRewardDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossRewardItem/KLUIChallengeBossRewardItem",self.view.reward_data_list,self,{},true)
    
    self.reward_all_item[item.view.root] = item
    return item.view.root
end

function this:SecretRewardDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:SecretRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.AllRwward[realIndex + 1]
    self.reward_all_item[kmlcontrol]:RefreshItem(data,self.select_Secret_level,self)
end


function this:SaoDangOnclick()
    --GUI:UIPanel_Open("dev/outui/BigSecretCopy/Panel/KLBigSecretCopyReward/KLBigSecretCopyRewardPanel")
    if self.data.rewardCount <= 0 then
        SL:TipMessage(SL:GetConfig('cfg_string',19004).text, 1, NoticeType.NoticeMid)
        return
    end
    self:TipSaoDang()
end

function this:TipSaoDang()
    SL:CommonTipsMessage({ stringTblID = 19003, showTips = "", ui = self, sureBtnText = "确定", cancelBtnText = "取消",
                          callback = self.SendSaoDang })
end

function this:SendSaoDang( ... )
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_BIG_SECRET_REALM_SWEEP, this.rep_id)
end
--[[
{
    score:
    isReceiveReward:false
    bonusId:2
    keyLevel:0
    rewardCount:2
}
--]]
function this:RES_BIG_SECRET_REALM_PANEL_INFO(_id,message)
    --SL:LogTable(message,true)
    self.data = message
    
    if self.data.keyLevel == 0 then
        self.data.keyLevel = 1
    end
    GUI:Text_setString(self.view.level,tostring(self.data.keyLevel))
    GUI:Text_setString(self.view.last_num,tostring(self.data.rewardCount))
    GUI:Text_setString(self.view.jia_cheng_text,self.data.bonusInfo)
    self.rep_data = SL:GetConfigMultiKeys('cfg_rep', 19001, self.data.keyLevel, 'type', 'repLevel')
    this.rep_id = self.rep_data.id
    local recommend = self.rep_data.recommend
    local my_num = SL:MeData_GetSpecialAttrValue(recommend[1])
    if my_num >= recommend[2] then
        GUI:Text_setString(self.view.fangyu,tostring(recommend[2]))
        GUI:Text_setTextColor(self.view.fangyu,"#00ff00")
    else
        local str = recommend[2] .. "(您的防御值低于推荐值)"
        GUI:Text_setString(self.view.fangyu,str)
        GUI:Text_setTextColor(self.view.fangyu,"#ff2323")
    end
    if not self.data.score or string.isNullOrEmpty(self.data.score) then
        GUI:Image_loadTexture(self.view.pingfen,"icon_wei", "Atlas/UIBigSecretCopy.spriteatlas")
        GUI:setPositionX(self.view.pingfen,20)
    else
        GUI:setPositionX(self.view.pingfen,0)
        if self.data.score == "B" then
            GUI:Image_loadTexture(self.view.pingfen,"icon_b", "Atlas/UIBigSecretCopy.spriteatlas")
        elseif self.data.score == "S" then
            GUI:Image_loadTexture(self.view.pingfen,"icon_s", "Atlas/UIBigSecretCopy.spriteatlas")
        elseif self.data.score == "SS" then
            GUI:Image_loadTexture(self.view.pingfen,"icon_ss", "Atlas/UIBigSecretCopy.spriteatlas")
        elseif self.data.score == "SSS" then
            GUI:Image_loadTexture(self.view.pingfen,"icon_sss", "Atlas/UIBigSecretCopy.spriteatlas")
        end
    end
    local saodang_level = SL:GetConfig("cfg_repGlobal",19001006).value
    local target_level = self:GetDaoDangLevel(saodang_level)
    local cur_level = self:GetDaoDangLevel(self.data.score)
    if cur_level >= target_level  then
        GUI:setVisible(self.view.pingfen_no,false)
        GUI:setVisible(self.view.btn_sao_dang,true)
        GUI:setPositionX(self.view.btn_join,630)
    else
        GUI:setVisible(self.view.pingfen_no,true)
        GUI:setVisible(self.view.btn_sao_dang,false)
        GUI:setPositionX(self.view.btn_join,770)
    end
    GUI:setVisible(self.view.btn_join,true)
    local baseCareer = SL:GetMetaValue(EMetaVarGetKey.JOB)
    self.AllRwward = {}
    for i, one_reward in ipairs(self.rep_data.UIJobReward) do
        if one_reward[1] == baseCareer then
            local _count = nil
            if self.rep_data.reward then
                for ii, one_list in ipairs(self.rep_data.UIreward) do
                    if one_list[1] == one_reward[2] then
                        _count = one_list[2]
                        break
                    end
                end
            end
            table.insert(self.AllRwward,{cfgId = one_reward[2],count=_count})
        end
    end
    GUI:DataListUpdateData(self.view.reward_data_list)

    local menpiao_id = SL:GetConfig("cfg_repGlobal",19001001).value
    local item_data = SL:GetConfig("cfg_item",tonumber(menpiao_id)) 
    local bagCount = SL:GetBagItemCount(item_data.id) 
    local count_str = bagCount.."/1"
    local dengji = "钥匙等级:".. self.data.keyLevel .."级"
    GUI:Text_setString(self.view.piao_num,dengji)
    self.item_cfg_id = item_data.id
    GUI:Item_setItemId(self.view.men_piao_item,item_data.id)
    self.can_join = false
    if bagCount > 0 then
        GUI:Text_setTextColor(self.view.piao_num,"#00ff00")
        self.can_join = true
    else
        GUI:Text_setTextColor(self.view.piao_num,"#ff2323")
    end
    if self.data.isReceiveReward then
        GUI:Toggle_setIsOn(self.view.reward_toggle,true)
    else
        GUI:Toggle_setIsOn(self.view.reward_toggle,false)
    end
end

function this:GetDaoDangLevel(level_str)
    if level_str == "B" then
        return 1
    elseif level_str == "S" then
        return 2
    elseif level_str == "SS" then
        return 3
    elseif level_str == "SSS" then
        return 4
    end
    return 0
end

function this:reward_toggle_OnClick(kmlCtrl, eventData, args)
    if not self.data then
        return
    end
    if args[1] then
        if self.data.isReceiveReward then
            return
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_BIG_SECRET_REALM_CHANGE_RECEIVE_STATUS)
    else
        if not self.data.isReceiveReward then
            return
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_BIG_SECRET_REALM_CHANGE_RECEIVE_STATUS)
    end
end

function this:RES_BIG_SECRET_REALM_RECEIVE_STATUS(_id,message)
    if not self.data then
        return
    end
    self.data.isReceiveReward = message
    if message then
        GUI:Toggle_setIsOn(self.view.reward_toggle,true)
    else
        GUI:Toggle_setIsOn(self.view.reward_toggle,false)
    end
end

--进入大秘境副本
function this:JoinCopy()
    if not self.rep_data  then
        return
    end
    local playerLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    local level = self.rep_data.level
    if playerLevel < level[1] or playerLevel > level[2] then
        SL:TipMessage(SL:GetConfig('cfg_string',118).text, 1, NoticeType.NoticeMid)
        return
    end
    if not self.can_join then
        SL:TipMessage(SL:GetConfig('cfg_string',495).text, 1, NoticeType.NoticeMid)
        return
    end

    if self.data.rewardCount <= 0 then
        self:TipJoin()
        return
    end
    self:SendJoin()
end

function this:RES_BIG_SECRET_REALM_CLEARANCE_PANEL_INFO(_id,message)
    --SL:LogTable(message,true)
    GUI:UIPanel_Open("dev/outui/BigSecretCopy/Panel/KLBigSecretCopyReward/KLBigSecretCopyRewardPanel",nil,nil,message)
end

function this:TipJoin()
    SL:CommonTipsMessage({ stringTblID = 19002, showTips = "", ui = self, sureBtnText = "确定", cancelBtnText = "取消",
                          callback = self.SendJoin })
end

function this:SendJoin( )
    this:CloseOnclick()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ENTER_DUPLICATE, this.rep_id)
end

function this:men_piao_item_OnClick()
    SL:OpenTips("",self.item_cfg_id)
end

return this
