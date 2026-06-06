---@class KLUICommonMapTipsPanel:UIKmlLuaPanelBase
---@field view KLUICommonMapTipsPanelView
---@field args KLUICommonMapTipsData
local KLUICommonMapTipsPanel = class(UIKmlLuaPanelBase)
local this = KLUICommonMapTipsPanel

---@class KLUICommonMapTipsData
---@field showTips string @中心文本
---@field tipsPos table @中心文本位置
---@field title string @标题文本
---@field titlePos table @标题位置
---@field isShowSureBtn boolean @确认按钮是否显示(默认显示)
---@field isShowCancelBtn boolean @确认按钮是否显示(默认显示)
---@field callback function @确认回调
---@field sureBtnPos table @确认按钮位置
---@field sureBtnText string @确认按钮文本
---@field sureBtnImageData KLUICommonMapTipsImageData @确认按钮图片数据
---@field cancelCallBack function @取消回调
---@field cancelBtnPos table @确认按钮位置
---@field cancelBtnText string @取消按钮文本
---@field cancelBtnImageData KLUICommonMapTipsImageData @确认按钮图片数据
---@field ui UIKmlLuaPanelBase @打开通用面板的ui
---@field callbackData table @回调数据
---@field closeTime number @如果有关闭时间，关闭整个面板
---@field showInput boolean @显示输入框
---@field inputPos table @输入框位置
---@field showToggle boolean @显示复选框
---@field togglePos table @复选框位置
---@field showSlider boolean @显示拖动条
---@field sliderPos table @拖动条位置
---@field littleTipsTextTable KLUICommonMapTipsTextControl @提示文本
---@field closeCallBack KLUICommonMapTipsTextControl @关闭回调
---@field stringTblID number @string表id
---@field stringTblFormat table @字符串参数
---@class KLUICommonMapTipsTextControl
---@field id string @控件名字
---@field x number @水平偏移
---@field y number @垂直偏移
---@field text string @文本内容


---@class KLUICommonMapTipsImageData
---@field atlas string @图集名
---@field src string @图片名


---创建时调用一次
function this:Init()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.returnData = {}
    ---@type KLUICommonMapTipsData
    self.args = self.args
    if self.args then
        if self.args.stringTblID then
            ---@type cfg_string_column
            local stringTbl = SL:GetConfig("cfg_string", self.args.stringTblID)
            local ColorTbl = SL:GetConfig("cfg_color", tonumber(stringTbl.textColor))
            local textColor = ColorTbl.color
            textColor = string.sub(textColor, 1, 7)
            local alpha = string.format("%x", math.floor(255 - stringTbl.transparencyT * 2.55))
            self.args.showTips = "<color=" .. textColor .. alpha .. ">" .. stringTbl.text .. "</color>"
            GUI:setPosition(self.view.root, stringTbl.offsetX, stringTbl.offsetY)
            GUI:Text_setFontSize(self.view.tipsContent, stringTbl.textSize)
            if self.args.stringTblFormat then
                self.args.showTips = string.format(self.args.showTips, table.unpack(self.args.stringTblFormat))
            end
        end
        if self.args.cfgId and self.args.needCount then
            local item =  GUI:Item_Create(self.view.layout2, {
                width = "80",
                height = "80",
                itemid = self.args.cfgId,
                tips = "1",
                noclip = "1",
                mfixsize = "80,80",
                bgtype = "0",
                y="-50",
                x="-20"
            })
            local haveCount = SL:GetBagItemCount(self.args.cfgId)
            local needCount = self.args.needCount
            if haveCount < needCount then
                GUI:Text_setString(self.view.tipsItemCount, string.format('<color="#9b1818">%d</color>/%d', haveCount, needCount))
            else
                GUI:Text_setString(self.view.tipsItemCount, string.format('<color="#5CE366FF">%d</color>/%d', haveCount, needCount))
            end
            GUI:SetAsFirstSibling(item)
            GUI:setVisible(self.view.tipsItemCount, true)
            GUI:setPosition(self.view.tipsItemCount, 20, -25)
            GUI:setPosition(self.view.tipsContent,0,25)
        end
        ---内容
        if self.args.showTips then
            --普通空格会导致换行出错，替换成不会换行的空格
            self.args.showTips = string.replace( self.args.showTips," ","\u{00A0}")
            GUI:Text_setString(self.view.tipsContent, self.args.showTips)
            GUI:setVisible(self.view.tipsContent, true)
            if self.args.tipsPos then
                GUI:setPosition(self.view.tipsContent, self.args.tipsPos.x, self.args.tipsPos.y)
            end
        end
        if self.args.littleTipsTextTable then
            local defaultPos = { x = 0, y = -40 }
            if not self.args.littleTipsTextTable.x or not self.args.littleTipsTextTable.y then
                self.args.littleTipsTextTable.x = defaultPos.x
                self.args.littleTipsTextTable.y = defaultPos.y
            end
            local textControl = GUI:Text_Create(self.view.bg, {
                id = "tipsText",
                text = self.args.littleTipsTextTable.text,
                x = self.args.littleTipsTextTable.x,
                y = self.args.littleTipsTextTable.y + 10
                --fontType = "MSYH"
            })
        end
        GUI:Text_setString(self.view.txt_title, self.args.title or "提示")
        ---标题
        if self.args.title then
            --GUI:Text_setString(self.view.txt_title, self.args.title)
            --GUI:setVisible(self.view.img_title, false)
            --GUI:setVisible(self.view.txt_title, true)
            if self.args.titlePos then
                GUI:setPosition(self.view.txt_title, self.args.titlePos.x, self.args.titlePos.y)
            end
        end
        ---按钮
        if self.args.isShowSureBtn == nil then
            self.args.isShowSureBtn = true
        end
        if self.args.isShowCancelBtn == nil then
            self.args.isShowCancelBtn = true
        end
        if self.args.isShowCloseBtn == nil then
            self.args.isShowCloseBtn = true
        end
        
        if not self.args.isShowSureBtn then
            GUI:setVisible(self.view.btn_sure, false)
        end
        if not self.args.isShowCancelBtn then
            GUI:setVisible(self.view.btn_cancel, false)
            if self.args.isShowSureBtn then
                GUI:setPosition(self.view.btn_sure, 0, GUI:getPositionY(self.view.btn_sure))
            end
        end
        
        if not self.args.isShowCloseBtn then
            GUI:setVisible(self.view.closeBtn, false)
        end
        
        if self.args.sureBtnText then
            GUI:Text_setString(self.view.btn_sure, self.args.sureBtnText)
        end
        if self.args.cancelBtnText then
            GUI:Text_setString(self.view.btn_cancel, self.args.cancelBtnText)
        end
        if self.args.sureBtnImageData then
            GUI:Image_loadTexture(self.view.btn_sure, self.args.sureBtnImageData.src, self.args.sureBtnImageData.atlas)
        end
        if self.args.cancelBtnImageData then
            GUI:Image_loadTexture(self.view.btn_cancel, self.args.cancelBtnImageData.src, self.args.cancelBtnImageData.atlas)
        end

        if self.args.cancelBtnColor then
            GUI:Button_setTitleColor(self.view.btn_cancel, self.args.cancelBtnColor)
        end

        ---输入框
        if self.args.showInput then
            GUI:setVisible(self.view.input, true)
            if self.args.inputPos then
                GUI:setPosition(self.view.input, self.args.inputPos.x, self.args.inputPos.y)
            end
        end
        ---复选框
        if self.args.showToggle then
            GUI:setVisible(self.view.toggle, true)
            if self.args.togglePos then
                GUI:setPosition(self.view.toggle, self.args.togglePos.x, self.args.togglePos.y)
            end
        end
        ---滑动条
        if self.args.showSlider then
            GUI:setVisible(self.view.slider, true)
            if self.args.sliderPos then
                GUI:setPosition(self.view.slider, self.args.sliderPos.x, self.args.sliderPos.y)
            end
        else
            GUI:setVisible(self.view.slider, false)
        end
        ---延迟关闭
        if self.args.closeTime and type(self.args.closeTime) == "number" then
            SL:ScheduleOnce(self.args.closeTime, function()
                self:CloseSelf()
            end)
        end
        ---取消按钮位置
        if self.args.cancelButtonPos then
            GUI:setPosition(self.view.btn_cancel,self.args.cancelButtonPos.x,self.args.cancelButtonPos.y)
        end
        ---确认按钮位置
        if self.args.sureButtonPos then
            GUI:setPosition(self.view.btn_sure,self.args.sureButtonPos.x,self.args.sureButtonPos.y)
        end
    end
    GUI:setPositionZ(self.view.root,-5000)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_sure, self, self.OnClickSureButton)
    GUI:AddOnClickEvent(self.view.btn_cancel, self, self.OnClickCancel)
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.CloseSelf)
end

function this:OnClickCancel()
    if self.args and self.args.cancelCallBack then
        self.args.cancelCallBack(self.args.ui, self.returnData)
    end
    GUI:UIPanel_Close('dev/ui/Common/Panel/KLUICommonMapTips/KLUICommonMapTipsPanel')
end

function this:CloseSelf()
    if self.args and self.args.closeCallBack then
        self.args.closeCallBack(self.args.ui, self.returnData)
    end
    GUI:UIPanel_Close('dev/ui/Common/Panel/KLUICommonMapTips/KLUICommonMapTipsPanel')
end

function this:OnClickSureButton()
    if self.args.showInput then
        self.returnData["inputText"] = GUI:Text_getString(self.view.input)
    end
    if self.args.showToggle then
        self.returnData["toggleIsOn"] = GUI:Toggle_getIsOn(self.view.toggle)
    end
    if self.args.showSlider then
        self.returnData["toggleIsOn"] = GUI:Toggle_getIsOn(self.view.slider)
    end
    self.returnData["callbackData"] = self.args.callbackData
    self.returnData["ui"] = self.args.ui
    if self.args and self.args.callback then
        self.args.callback(self.returnData)
    end
    self:CloseSelf()
end

function this:Close()
end

return this
