---@class KLUIItemPreviewItem:UIKmlLuaPanelBase
---@field view KLUIItemPreviewItemView
local KLUIItemPreviewItem = class(UIKmlLuaPanelBase)
local this = KLUIItemPreviewItem
---创建时调用一次
function this:Init()
   
end

---创建或者刷新界面数据时调用
function this:RefreshItem(args)
    self.args = args
    GUI:Item_setItemId(self.view.equip_item,self.args.cfgId)
    if tostring(self.args.count) ~= "0" and tostring(self.args.count) ~= "1" then
        GUI:Item_setItemCount(self.view.equip_item,self.args.count)
        GUI:setVisible(self.view.count_attach,true)
    else
        GUI:setVisible(self.view.count_attach,false)
    end
    
    
    --GUI:Item_setItemId(self.view.equip_item,20900002)
    if SL:GetConfig('cfg_item', self.args.cfgId).type ~= EItemType.Equip then
        GUI:setVisible(self.view.arrow, false)
        GUI:setVisible(self.view.img_quality, false)
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
        local img_quality = self.view.img_quality
        GUI:setVisible(img_quality, false)
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
    --local effect_id = SL:GetConfig("cfg_item",self.args.cfgId,"id").sEffect
    --if effect_id and effect_id ~= 0 then
    --    local effect_tbl = SL:GetConfig("cfg_model_effect",effect_id,"id")
    --    GUI:Model_setSrc(self.view.effect_model,effect_tbl.path)
    --    GUI:setVisible(self.view.effect_model, false)
    --else
    --    GUI:setVisible(self.view.effect_model, false)
    --end
    GUI:setVisible(self.view.effect_model, false)
end


---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn,self,self.BtnClick)
end

function this:BtnClick()
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTipsOther/KLIUItemTipsOtherPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
    GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLArchangelGrailTips/KLArchangelGrailTipsPanel")
    
    local tab =  SL:GetConfig('cfg_item', self.args.cfgId)
    local equip_pos = self.args.equip_pos
    local is_right = false
    if not string.isNullOrEmpty(equip_pos) and equip_pos == "bag" then
        is_right = true
    end
    local selfSizeX, selfSizeY = GUI:getSizeDelta(self.baseUI.view.panel_bg)
    local selfSize = {x = selfSizeX, y = selfSizeY}
    local _posX = 0
        if is_right then
            _posX = -650
        else
            _posX = -766
        end
        
    if tab.type == 2 then
         if is_right then
            _posX = -640
        else
            _posX = -274
        end
        SL:OpenTips("", self.args.cfgId,nil,nil,nil,{hideComparsion = true,posX=_posX,previewSize = selfSize,hideBtn=true,isRight = is_right,hideMask=false})
    elseif tab.type == 9 then
        GUI:UIPanel_Open("dev/outui/Archangel/Panel/KLArchangelGrailTips/KLArchangelGrailTipsPanel",nil,nil,{ equip_pos = "", cfgId = self.args.cfgId, info={posX=_posX,previewSize = selfSize,isRight = is_right,hideMask=false} })
    else
        GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTipsOther/KLIUItemTipsOtherPanel")
        GUI:UIPanel_Open("dev/ui/Tips/Panel/KLIUItemTipsOther/KLIUItemTipsOtherPanel",nil,nil,{ equip_pos = "", cfgId = self.args.cfgId, info={posX=_posX,previewSize = selfSize,isRight = is_right,hideMask=false} })
    end
end

function this:Close()
    
end



return this
