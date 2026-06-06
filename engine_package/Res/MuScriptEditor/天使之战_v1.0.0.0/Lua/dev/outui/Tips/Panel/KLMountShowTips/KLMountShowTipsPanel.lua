---@class KLMountShowTipsPanel:UIKmlLuaPanelBase
---@field view KLMountShowTipsPanelView
local KLMountShowTipsPanel = class(UIKmlLuaPanelBase)
local this = KLMountShowTipsPanel

---创建时调用一次
function this:Init()
    self.modelItemList = {}
    GUI:DataListInitData(self.view.MountItemData, function()
        return #self.modelItemList
    end, function()
    end, function()
    end, function(realIndex)
        local data = self.modelItemList[realIndex + 1]
        local itemText = GUI:GetChildControl(self.view.MountItemData, realIndex, 'itemText')
        local model = GUI:GetChildControl(self.view.MountItemData, realIndex, 'model9')
        GUI:Text_setText(itemText, "词条达到" .. data[1] .. "条时解锁:")
        local modelId = SL:GetConfig("cfg_mount", data[2]).mountId
        local path = SL:GetConfig("cfg_mount_model", modelId).path
        --GUI:Model_setSrc(model, path)
        GUI:Model_setSrc(model, path,"26,26,26")
        GUI:setRotationSkewY(model,-135)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    --GUI:AddOnClickEvent(self.view.MsakBtn, self, self.MsakBtn)
end
function this:MsakBtn()
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
    GUI:UIPanel_Close("dev/outui/Tips/Panel/KLMountShowTips/KLMountShowTipsPanel")
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    if self.args then
        local sizeW, sizeH = GUI:getSizeDelta(self.view.bg)
        self.height = sizeH
        if self.args.cfgId then
            --local entryAtt = SL:GetEquipEntrys(self.args.itemInfo)
            --local entryAttCount = table.count(entryAtt)
            local replaceMount = self:getMountId()
            if not table.isNullOrEmpty(replaceMount) then
                self.modelItemList = replaceMount
                self.height = table.count(replaceMount) * 250

                GUI:DataListUpdateData(self.view.MountItemData)
            end
        end
        if self.args.bgPosX then
            -- 计算获取装备的位置，使其更靠近按钮
            local tipsPanel = GUI:GetUI("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
            if tipsPanel and tipsPanel.view.root then
                if tipsPanel.isLeft then
                    GUI:setPositionX(self.view.root, self.args.bgPosX + self.args.bgSizeW)
                else
                    GUI:setPositionX(self.view.root, self.args.bgPosX - self.args.bgSizeW)
                end
            end
            
            local y = self.args.bgPosY - (sizeH - self.args.bgSizeH) / 2 +117+42
            GUI:setPositionY(self.view.root, y)
            self.height = self.height + 40
            if self.height >= 750/2 + self.args.bgSizeH / 2 then
                self.height = 750/2 + self.args.bgSizeH / 2
            end
            GUI:setContentSize(self.view.bg,sizeW,self.height)
            GUI:setContentSize(self.view.scrollview1,sizeW,self.height-30)
        end

    end
end
function this:getMountId()
    local mountTbl = nil
    if self.args.cfgId then
        local cfgs = SL:GetConfigTable("cfg_mount")
        ---@type cfg_item_column
        local cfg = SL:GetConfig("cfg_item", self.args.cfgId)
        ---@param v cfg_mount_column
        for i, v in ipairs(cfgs) do
            if v.itemId == self.args.cfgId or (cfg.bindEqualItem ~= 0 and v.itemId == cfg.bindEqualItem) then
                mountTbl = v
            end
        end
    end
    if mountTbl then
        local replaceMount = mountTbl.replaceMount
        if table.isNullOrEmpty(replaceMount) then
            return {{1,mountTbl.id}}
        else
            return replaceMount
        end

    end
    return nil
end
function this:Hide()
end

function this:Close()
end

return this
