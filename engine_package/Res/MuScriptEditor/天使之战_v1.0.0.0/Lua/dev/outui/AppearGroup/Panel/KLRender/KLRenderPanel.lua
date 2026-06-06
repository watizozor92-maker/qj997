---@class KLRenderPanel:UIKmlLuaPanelBase
---@field view KLRenderPanelView
local KLRenderPanel = class(UIKmlLuaPanelBase)
local this = KLRenderPanel
---@type table<EEquipSlotType,CommonProtos.Item>
local grade2Items = {}


---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.loopscrollviewData,
            function()
                return self:ItemCountFunc()
            end,
            function(realIndex)
                return self:ItemGetFunc(realIndex)
            end,
            function(realIndex, kmlCtrl)
                return self:ItemInitFunc(realIndex, kmlCtrl)
            end,
            function(realIndex, kmlCtrl)
                return self:ItemUpdateFunc(realIndex, kmlCtrl)
            end,
            function(realIndex)
                return self:ItemSizeGetFunc(realIndex)
            end
    )

    self.Part_ITEM_H = 80

    self.Page_Width = GUI:GetWidth(self.view.loopscrollview)
    self.PAGE_EXT_H = 70

end

function this:ItemCountFunc()
    return #self.partData
end

function this:ItemGetFunc()
    ---@type KLRenderItem
    local item = GUI:UIPanel_Open("dev/outui/AppearGroup/Item/KLRender/KLRenderItem", self.view.loopscrollviewData, self, nil, true)
    if not self.partItems then
        ---@type table<KingML.KmlControl,KLRenderItem>
        self.partItems = {}
    end

    local kmlCtrl = item.view.root
    self.partItems[kmlCtrl] = item

    return kmlCtrl
end

function this:ItemInitFunc()
end

---@param realIndex number
---@param kmlCtrl KingML.KmlControl
function this:ItemUpdateFunc(realIndex, kmlCtrl)
    local item = self.partItems[kmlCtrl]
    local luaIndex = realIndex + 1
    local slot = self.partData[luaIndex]
    local titleStr = SL:NumberToChinese(slot) .. "阶卓越套装"
    item:SetArgs(grade2Items[slot], titleStr, self.itemY, luaIndex)
    item:UpdateUI()


end

---@param realIndex number
function this:ItemSizeGetFunc(realIndex)
    local luaIndex = realIndex + 1
    local slot = self.partData[luaIndex]
    local equipCount = #grade2Items[slot]

    local line = math.ceil(equipCount / 5)
    self.itemY = line * self.Part_ITEM_H + self.PAGE_EXT_H

    return Vector2(self.Page_Width, self.itemY)
end

---创建或者刷新界面数据时调用
function this:Refresh()

    self:AnalysisEquipData()

    GUI:DataListUpdateData(self.view.loopscrollviewData)
end

function this:AnalysisEquipData()
    self.partData = {}
    grade2Items = {}

    ---@type cfg_fashion_column[]
    local tbl = SL:GetConfigTable('cfg_fashion')

    for _, fashTbl in pairs(tbl) do
        if table.contains(fashTbl.type, E_FashionType.Change) then

            if not grade2Items[fashTbl.grade] then
                grade2Items[fashTbl.grade] = {}
            end
            table.insert(grade2Items[fashTbl.grade], fashTbl)

            if not table.contains(self.partData, fashTbl.grade) then
                table.insert(self.partData, fashTbl.grade)
            end
        end
    end

    table.sort(self.partData)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.BtnClose, self, self.BtnCloseOnClick)
    GUI:AddOnClickEvent(self.view.BtnCancel, self, self.BtnCancelOnClick)
    GUI:AddOnClickEvent(self.view.BtnSure, self, self.BtnSureOnClick)
end

function this:BtnSureOnClick()

    --[[    local message = {
            showTips = "保存设置",
            title = "提示",
            callback = function()
    
    
            end
    
        }]]

    SL:CommonTipsMessage({ stringTblID = 209,
                           title = "提示",
                           callback = function()
                           end
    })

end

function this:BtnCancelOnClick()
    return self:BtnCloseOnClick()
end

function this:BtnCloseOnClick()
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppear/KLAppearPanel")
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppearGroup/KLAppearGroupPanel")
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppearPreview/KLAppearPreviewPanel")
end

function this:Close()

end

 

return this
