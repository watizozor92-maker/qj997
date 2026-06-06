---@class KLItemGetPathItem:UIKmlLuaPanelBase
---@field view KLItemGetPathItemView
local KLItemGetPathItem = class(UIKmlLuaPanelBase)
local this =KLItemGetPathItem
---创建时调用一次
function this:Init()
    
end

function this:InitData(data)
    ---1:快捷购买类型#货币id#价格#图标文件名
    ---2:界面跳转类型#图标文件名#界面显示名称#脚本命令
    ---@type {itemCfg:cfg_item_column,quickshopping:string[],callBack:function,ui:UIKmlLuaPanelBase}
    self.data = data
    if self.data then
        if self.data.quickshopping[1] == "1" then
            local type = self.data.quickshopping[1]
            local needCostId = self.data.quickshopping[2]
            local cost = self.data.quickshopping[3]
            local item =  SL:GetConfig("cfg_item",tonumber(needCostId))
            GUI:Text_setString(self.view.buyBtn, "购买")
            GUI:Text_setString(self.view.gainTxt, item.name .. " × " .. cost)
        else
            GUI:Text_setString(self.view.gainTxt, self.data.quickshopping[3])
            GUI:Text_setString(self.view.buyBtn, "前往")
        end
        GUI:setVisible(self.view.costCount, false)
        GUI:setVisible(self.view.costItemName, false)
        GUI:setVisible(self.view.costModel, false)
        GUI:setVisible(self.view.itemModel, false)
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local pos = GUI:GetAnchoredPosition(self.view.gainTxt)
    SL:Log("获取途径-pos:".. pos.x .. "," .. pos.y)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.buyBtn,self,self.BtnOnClick)
end

function this:BtnOnClick()
    if self.data.quickshopping[1] == "1" then
        local needCostId = tonumber(self.data.quickshopping[2])
        local costCount = tonumber(self.data.quickshopping[3])
        local ownCount = SL:GetBagItemCount(needCostId)
        local result = SL:ShortcutDO({"buyGoods",needCostId,costCount,self.data.itemCfg.id})
        if not result then
            return
        end
        --GUI:UIPanel_Close('dev/ui/Common/Panel/KLItemGetPath/KLItemGetPathPanel')
    else
        local tempShortcut = {self.data.quickshopping[4],self.data.quickshopping[5],self.data.quickshopping[6],self.data.quickshopping[7]}
        if self.data.callBack then
            self.data.callBack()
        end
        --[[if self.data.ui then
            GUI:UIPanel_Close(nil,self.data.ui)
        end
        GUI:UIPanel_Close('dev/ui/Common/Panel/KLItemGetPath/KLItemGetPathPanel')]]
        SL:KeepOpenPanel("KLItemGetPathPanel",true)
        GUI:CloseAllUIWithoutMainUI()
        SL:ShortcutDO(tempShortcut)
        SL:CloseTips()  
        SL:KeepOpenPanel("KLItemGetPathPanel",false)
        GUI:UIPanel_Close('dev/ui/Common/Panel/KLItemGetPath/KLItemGetPathPanel')
        return
    end
    if self.data.callBack then
        self.data.callBack()
    end
end

function this:Close()
end

return this
