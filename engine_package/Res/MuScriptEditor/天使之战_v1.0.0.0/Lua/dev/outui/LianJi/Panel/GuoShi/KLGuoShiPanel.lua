---@class KLLianJiPanel:UIKmlLuaPanelBase
---@field view KLLianJiPanelView
local KLLianJiPanel = class(UIKmlLuaPanelBase)
local this =KLLianJiPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.parent_path = "dev/outui/LianJi/Panel/KLLianJi/KLLianJiPanel"
    self.path = "dev/outui/LianJi/Panel/GuoShi/KLGuoShiPanel"
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.close,self,self.Close1)
    SL:RegisterLUAEvent(LUA_EVENT_LIANJI_DATACHANGE, function()
        self:Refresh()
    end,self)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    local sd_use_count = InfoManager.LianJiInfo.sd_count
    local rate_use_count = InfoManager.LianJiInfo.rate_count
    local conf = InfoManager.LianJiInfo.conf
    local rete_item_id = SL:GetConfigMultiKeys("cfg_item", conf.addLianJi.itemName,"name").id
    local sd_item_id = SL:GetConfigMultiKeys("cfg_item", conf.addSD.itemName,"name").id

    GUI:SetAttr(self.view.cur_rate,"text",string.format("连击加成+%s%%",rate_use_count*conf.addLianJi.add_value/100))
    GUI:SetAttr(self.view.LianJiRate_Max_Value,"text",conf.addLianJi.max_count*conf.addLianJi.add_value)
    GUI:SetAttr(self.view.cur_sd,"text",string.format("SD护盾值+%s",sd_use_count*conf.addSD.add_value))
    GUI:SetAttr(self.view.SD_Max_Value,"text",conf.addSD.max_count*conf.addSD.add_value)
   
    GUI:Item_setItemId(self.view.item1,rete_item_id)
    GUI:Item_setItemId(self.view.item2,sd_item_id)

    GUI:Item_setItemId(self.view.rate_item,rete_item_id)

    local rete_have_count = SL:GetBagItemCount(rete_item_id)
    GUI:Item_setItemCount(self.view.rate_item,rete_have_count)
    GUI:SetAttr(self.view.rate_item,"textcolor",rete_have_count>0 and "#00ff00" or "#ff0000")
    GUI:AddOnClickEvent(self.view.rate_item, self, function()
        local isUse = false
        if rate_use_count < conf.addLianJi.max_count then
            isUse = true
        end
        if rete_have_count > 0 and isUse then
            local item = SL:MeData_GetCfgBaseOnItemId(rete_item_id)
            SL:OpenTips("bag", item.cfgId,item.id,rete_have_count >= 10 and 10 or rete_have_count)
--[[            GUI:UIPanel_Open("dev/outui/Tips/Panel/KLTipLayout/KLTipLayoutPanel",nil,nil, {
                cfgId=rete_item_id,
                equip_pos="bag",
                btn = {
                    leftbtn = {
                        {
                            name = "使用";
                            click =  function()
                                SL:SendLuaNetMsg(LuaMessageIdToSever.LianJi_MsgID, {3,1})
                                SL:CloseTips()
                            end;
                        };
                    };
                    rightbtn = {
                        {
                            name = string.format("使用%s个",rete_have_count >= 10 and 10 or rete_have_count);
                            click =  function()
                                SL:SendLuaNetMsg(LuaMessageIdToSever.LianJi_MsgID, {3,rete_have_count >= 10 and 10 or rete_have_count})
                                SL:CloseTips()
                            end;
                        };
                    };
                };
            })]]
        else
            SL:CommonItemGetPath(nil,rete_item_id)
        end
    end)

    GUI:Item_setItemId(self.view.sd_item,sd_item_id)
    local sd_have_count = SL:GetBagItemCount(sd_item_id)
    GUI:Item_setItemCount(self.view.sd_item,SL:GetBagItemCount(sd_item_id))
    GUI:SetAttr(self.view.sd_item,"textcolor",sd_have_count>0 and "#00ff00" or "#ff0000")
    GUI:AddOnClickEvent(self.view.sd_item, self, function()
        local isUse = false
        if rate_use_count < conf.addSD.max_count then
            isUse = true
        end
        if sd_have_count > 0 and isUse then
            local item = SL:MeData_GetCfgBaseOnItemId(sd_item_id)
            SL:OpenTips("bag", item.cfgId,item.id,rete_have_count >= 10 and 10 or rete_have_count)
--[[            GUI:UIPanel_Open("dev/outui/Tips/Panel/KLTipLayout/KLTipLayoutPanel",nil,nil, {
                cfgId=sd_item_id,
                equip_pos="bag",
                btn = {    
                    leftbtn = {
                        {
                            name = "使用";
                            click =  function()
                                SL:SendLuaNetMsg(LuaMessageIdToSever.LianJi_MsgID, {4,1})
                                SL:CloseTips()
                            end;
                        };
                    };
                    rightbtn = {
                        {
                            name = string.format("使用%s个",sd_have_count >= 10 and 10 or sd_have_count);
                            click =  function()
                                SL:SendLuaNetMsg(LuaMessageIdToSever.LianJi_MsgID, {4,sd_have_count >= 10 and 10 or sd_have_count})
                                SL:CloseTips()
                            end;
                        };
                    };
                };
            })]]
        else
            SL:CommonItemGetPath(nil,sd_item_id)
        end
    end)
end

function this:Hide()
end

function this:Close()
end

function this:Close1()
    GUI:UIPanel_Close(self.parent_path) 
    GUI:UIPanel_Close(self.path) 
end

return this
