---@class KLClickNPCTransferTipsPanel:UIKmlLuaPanelBase
---@field view KLClickNPCTransferTipsPanelView
local KLClickNPCTransferTipsPanel = class(UIKmlLuaPanelBase)
local this =KLClickNPCTransferTipsPanel

---创建时调用一次
function this:Init()
    self.mapMoveId = self.args and tonumber(self.args) or nil
    if not self.mapMoveId then
        return
    end
    ---@type cfg_mapMove_column
    self.mapMoveCfg = SL:GetConfig("cfg_mapMove", self.mapMoveId)
    if not self.mapMoveCfg then
        SL:LogError("cfg_mapMove not found, id: " .. self.mapMoveId)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    if not self.mapMoveCfg then
        return
    end
    self:OpenCommonTips()
end

function this:Hide()
end

function this:Close()
    SL.ShowMainPanel()
end

function this:OpenCommonTips()
    local tipsText = string.format("是否进入%s地图？", self.mapMoveCfg.mapName)
    local tipsData = {
        showTips = tipsText,
        sureBtnText = "确定",
        cancelBtnText = "取消",
        ui = self,
        callback = function()
            self:DoTransfer()
            GUI:UIPanel_Close("dev/outui/Tips/Panel/KLClickNPCTransferTips/KLClickNPCTransferTipsPanel")
        end,
        cancelCallBack = function()
            GUI:UIPanel_Close("dev/outui/Tips/Panel/KLClickNPCTransferTips/KLClickNPCTransferTipsPanel")
        end,
        closeCallBack = function()
            GUI:UIPanel_Close("dev/outui/Tips/Panel/KLClickNPCTransferTips/KLClickNPCTransferTipsPanel")
        end
    }
    SL:CommonTipsMessage(tipsData)
end

--- 执行地图传送
function this:DoTransfer()
    local param = {}
    param[1] = "transfer"
    param[2] = self.mapMoveId
    param[3] = self.mapMoveCfg.mapX
    param[4] = self.mapMoveCfg.mapY
    -- SL:ShortcutDO(param)
    if self.mapMoveCfg.mapName == "狼魂要塞" then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ENTER_DUPLICATE, 15001) -- cfg_rep 表id 15001为狼魂要塞副本
    else
        SL:MapTransferXY(self.mapMoveCfg.mapID, self.mapMoveCfg.mapX, self.mapMoveCfg.mapY, self.mapMoveCfg.range,
            MapProtos_CustomizeType.CUSTOMIZE_TP, 1)
    end
end

return this
