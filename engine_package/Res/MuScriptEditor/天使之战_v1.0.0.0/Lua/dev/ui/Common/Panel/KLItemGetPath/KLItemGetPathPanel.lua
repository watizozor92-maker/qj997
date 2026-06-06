---@class KLItemGetPathPanel:UIKmlLuaPanelBase
---@field view KLItemGetPathPanelView
local KLItemGetPathPanel = class(UIKmlLuaPanelBase)
local this =KLItemGetPathPanel
---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.gainData_list, function()
        return self:DataListItemCountFunc()
    end, function(realIndex)
        return self:DataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    ----@type {itemId:number,pos:{x:number,y:number}}
    self.args = self.args
    ---@type cfg_item_column
    self.itemCfg = SL:GetConfig("cfg_item",self.args.itemId)
    if self.args.pos then
        GUI:setPositionX(self.view.root,self.args.pos[1])
        GUI:setPositionY(self.view.root,self.args.pos[2])
    end
    if self.args and self.args.width then
        GUI:setContentSize(self.view.rootBG,self.args.width,self.args.height)
    end
    GUI:setContentSize(self.view.bg,ETipsParameter.TipsWidth,161)
    GUI:DataListUpdateData(self.view.gainData_list)
    self:SetBgHeight()
    
end

function this:SetBgHeight()
    local len = (#self.itemCfg.Quickshopping >= 3 and 2.5 or #self.itemCfg.Quickshopping)
    GUI:setContentSize(self.view.bg, GUI:GetControlWidth(self.view.bg), 82 + 47 * len)
    GUI:setContentSize(self.view.gainList, GUI:GetControlWidth(self.view.gainList), 48 * len)
    self:SetPositionY(82 + 47 * len)
    self:SetTipPosition(82 + 47 * len)
end

function this:SetPositionY(height)
    --UI布局有问题，先这样处理
    GUI:setPositionY(self.view.root,self.args.pos[2] + height - 68)
end

function this:SetTipPosition(height)
    -- 计算获取途径面板的位置，使其更靠近按钮
    local tipsPanel = GUI:GetUI("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel")
    if tipsPanel and tipsPanel.view.root then
        tipsPanel:SetTipPosition(height)
        -- 获取当前tips面板的位置和尺寸
        local tipsX, tipsY = GUI:getPosition(tipsPanel.view.root)
        local tipsWidth = GUI:GetWidth(tipsPanel.view.panel_bg)
        local tipsHeight = GUI:GetHeight(tipsPanel.view.panel_bg)
        -- 设置获取途径面板位置更靠近按钮
        if tipsPanel.isLeft then
            local tipsPanelX = tipsX + (ETipsParameter.TipsWidth / 2 + tipsWidth / 2)
            GUI:setPositionX(self.view.root, tipsX)
            GUI:setPositionX(tipsPanel.view.root, tipsPanelX)
        else
            local tipsPanelX = tipsX - (ETipsParameter.TipsWidth / 2 + tipsWidth / 2)
            GUI:setPositionX(self.view.root, tipsX)
            GUI:setPositionX(tipsPanel.view.root, tipsPanelX)
        end
        
        --tips底部位置= btnY-(tipsH/2+btnH/2)
        local tipsBottomPos = tipsY - (tipsHeight  - height  )
        local tipsTopPos = tipsBottomPos + tipsHeight
        GUI:setPositionY(self.view.root, tipsY)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    --GUI:AddOnClickEvent(self.view.closeBg, self, self.BtnCloseOnClick)
end

function this:BtnCloseOnClick()
    GUI:UIPanel_Close("dev/ui/Common/Panel/KLItemGetPath/KLItemGetPathPanel")
    SL:CloseTips()
end

function this:DataListItemCountFunc()
    return #self.itemCfg.Quickshopping
end

function this:DataListItemGetFunc(realIndex)
    ---@type KLItemGetPathItem
    local item = GUI:UIPanel_Open("dev/ui/Common/Item/KLItemGetPath/KLItemGetPathItem", self.view.gainData_list, self, nil,true)
    local tempData = {
        itemCfg = self.itemCfg,
        quickshopping = self.itemCfg.Quickshopping[realIndex + 1],
        callBack = self.args.callBack,
        ui = self.args.ui
    }
    item:InitData(tempData)
    return item.view.root
end

---@param kmlcontrol UIKmlLuaControl
function this:DataListItemInitFunc(realIndex, kmlcontrol)
    
end

function this:DataListItemUpdateFunc(realIndex, kmlcontrol)
    
end


function this:Close()
end

return this
