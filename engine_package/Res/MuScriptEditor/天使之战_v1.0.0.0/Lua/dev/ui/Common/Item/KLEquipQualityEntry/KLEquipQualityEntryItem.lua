---@class KLEquipQualityEntryItem:UIKmlLuaPanelBase
---@field view KLEquipQualityEntryItemView
local KLEquipQualityEntryItem = class(UIKmlLuaPanelBase)
local this =KLEquipQualityEntryItem
---创建时调用一次
function this:Init()
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.equipAttItems = {}
    local cfgId = self.args.cfgId
    local img_quality = self.view.imgQuality
    GUI:setVisible(img_quality, false)
    -- self:Recycle()
    if not cfgId then
        return
    end
    --装备品阶

    ---@type cfg_equip_entryLib_column
    local entryLib = nil
    if SL:HasConfig('cfg_equip_entryLib', cfgId) then
         entryLib = SL:GetConfig('cfg_equip_entryLib', cfgId)
    end
    local is_zhuoyue = false
    if entryLib then
        local qualityTbl = SL:GetConfigTable("cfg_equip_quality")
        ---@param v cfg_equip_quality_column
        for _, v in pairs(qualityTbl) do
            if not string.isNullOrEmpty(v.logo) and entryLib.initialRating >= v.stage[1] and entryLib.initialRating <= v.stage[2] then
                GUI:setVisible(img_quality, true)
                GUI:Image_loadTexture(img_quality, v.logo, "Atlas/UIBagPanel.spriteatlas")
                if v.id == 2 then
                  is_zhuoyue = true
                end
                break
            end
        end
    end
    --卓越词条数量
    local count = self.args.entryCount or 0
    if is_zhuoyue and count > 0 then
        GUI:Image_loadTexture(img_quality, "zhuo_"..count, "Atlas/UIBagPanel.spriteatlas")
        GUI:setContentSize(img_quality,23,52)
    else
        GUI:SetImageNativeSize(img_quality)
    end
    
    -- for i=1, count do
    --     if i > #self.equipAttItems then
    --         ---@type KLCommonImageItem
    --         local attItem = GUI:UIPanel_Open("dev/ui/Equip/Item/KLCommonImage/KLCommonImageItem", self.view.imgQuality, self, {
    --             sprite = "img_equipAtt", altas = "Atlas/UIBagPanel.spriteatlas"
    --         }, true)
    --         table.insert(self.equipAttItems, attItem)
    --         attItem:SetSize(20, 20)
    --         attItem:SetPosition(-2, -18 - (i - 1) * 8)
    --     else
    --         GUI:SetActive(self.equipAttItems[i].view.root, true)
    --     end
    -- end

    -- for i=count+1, #self.equipAttItems do
    --     GUI:SetActive(self.equipAttItems[i].view.root, false)
    -- end
end

function this:SetData(cfgId, entryCount)
    self.args = {
        cfgId = cfgId,
        entryCount = entryCount
    }
    self:Refresh()
end

function this:Recycle()
    for _, v in pairs(self.equipAttItems) do
        GUI:UIPanel_Close(nil, v)
    end
    table.clear(self.equipAttItems)
end

function this:Close()
    self:Recycle()
end

return this
