---@class KLUIChallengeBossRewardItem:UIKmlLuaPanelBase
---@field view KLUIChallengeBossRewardItemView
local KLUIChallengeBossRewardItem = class(UIKmlLuaPanelBase)
local this = KLUIChallengeBossRewardItem
---创建时调用一次
function this:Init()
   
end

---创建或者刷新界面数据时调用
function this:RefreshItem(args)
    self.args = args
    local img_quality = self.view.img_quality
    GUI:setVisible(img_quality, false)
    GUI:Item_setItemId(self.view.equip_item,self.args.cfgId)
    if self.args.count and self.args.count > 1 then
        GUI:Item_setItemCount(self.view.equip_item, self.args.count)
    else
        --GUI:Item_setItemCount(self.view.equip_item, 0)
    end
    --GUI:Item_setItemId(self.view.equip_item,20900002)
    local tab = SL:GetConfig('cfg_item', self.args.cfgId)
    if not tab or (tab and tab.type ~= EItemType.Equip) then
        GUI:setVisible(self.view.arrow, false)
    else
        if SL:CheckEquipBaseCareer(self.args) and SL:CompareInitGrage(self.args) == 1 then
            GUI:setVisible(self.view.arrow, true)
        else
            GUI:setVisible(self.view.arrow, false)
        end
        local entryLib = nil
        if SL:HasConfig('cfg_equip_entryLib', self.args.cfgId) then
            entryLib = SL:GetConfig('cfg_equip_entryLib', self.args.cfgId)
        end
        if entryLib then
            local qualityTbl = SL:GetConfigTable("cfg_equip_quality")
            ---@param v cfg_equip_quality_column
            for _, v in pairs(qualityTbl) do
                if not string.isNullOrEmpty(v.logo) and entryLib.initialRating >= v.stage[1] and entryLib.initialRating <= v.stage[2] then
                    GUI:setVisible(img_quality, true)
                    GUI:Image_loadTexture(img_quality, v.logo, "Atlas/UIBagPanel.spriteatlas")
                    break
                end
            end
        end
    end
    local effect_id = SL:GetConfig("cfg_item",self.args.cfgId,"id").sEffect
    if effect_id and effect_id ~= 0 then
        local effect_tbl = SL:GetConfig("cfg_model_effect",effect_id,"id")
        GUI:Model_setSrc(self.view.effect_model,effect_tbl.path)
        GUI:setVisible(self.view.effect_model, true)
    else
        GUI:setVisible(self.view.effect_model, false)
    end
    
end


---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn,self,self.BtnClick)
end

function this:BtnClick()
    SL:OpenTips("", self.args.cfgId)
end

function this:Close()
    
end



return this
