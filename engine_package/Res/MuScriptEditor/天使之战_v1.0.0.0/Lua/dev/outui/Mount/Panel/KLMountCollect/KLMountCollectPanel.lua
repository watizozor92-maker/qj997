---@class KLMountCollectPanel:UIKmlLuaPanelBase
---@field view KLMountCollectPanelView
local KLMountCollectPanel = class(UIKmlLuaPanelBase)
local this = KLMountCollectPanel

---创建时调用一次
function this:Init()
    self.attTxtList = {}
    GUI:DataListInitData(self.view.dataList_att, function()
        return table.count(self.attTxtList)
    end, function(realIndex)

    end, function(realIndex, kmlcontrol)

    end, function(realIndex, kmlcontrol)
        local att = self.attTxtList[realIndex + 1]
        local name = GUI:GetChildControl(self.view.dataList_att, realIndex, 'name')
        local num = GUI:GetChildControl(self.view.dataList_att, realIndex, 'num')
        local strList = string.split(att, "@")
        GUI:Text_setString(name, strList[1])
        GUI:Text_setString(num, strList[2])
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.OnCloseBtn)
end

function this:OnCloseBtn()
    GUI:UIPanel_Close("dev/outui/Mount/Panel/KLMountCollect/KLMountCollectPanel")
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local mounts = InfoManager.mountInfo:GetTotalMounts()
    if mounts then
        local totalAtts = self:GetActivatedMountNumberAttrs()
        self:RefreshAttInfoList(totalAtts)
        
    end
end

---获取所有已激活的cfg_MountNumberAtt
function this:GetActivatedMountNumberAttrs()
    local activatedAttrs = {}
    local mounts = InfoManager.mountInfo:GetTotalMounts()
    
    if mounts then
        local len = table.count(mounts)
        
        -- 遍历所有cfg_MountNumberAtt配置
        local allConfigs = SL:GetConfigTable("cfg_MountNumberAtt")
        for _, config in pairs(allConfigs) do
            -- 当坐骑数量大于等于所需数量时，表示已激活
            if len <= config.number then
                table.insert(activatedAttrs, config)
            end
        end
        
        -- 按照数量排序，确保顺序正确
        table.sort(activatedAttrs, function(a, b)
            return a.number < b.number
        end)
    end
    
    return activatedAttrs
end

---@param attribute cfg_MountNumberAtt_column[]
function this:RefreshAttInfoList(tbls)
    local attInfo = {}
    self.attTxtList = {}
    
    local mounts = InfoManager.mountInfo:GetTotalMounts()
    local len = 0
    if mounts then
        len = table.count(mounts)
    end
    
    for index, value in ipairs(tbls) do
        -- 插入显示当前number状态的条目
        local statusText = len .. "/" .. value.number
        local color = "#CCCCCC"
        if len >= value.number then
            -- 满足条件显示绿色 (#00ff00)
            color = "#00ff00"
        end
        table.insert(self.attTxtList,SL:GetColorText(statusText,color))
        for i, v in pairs(value.att) do
            local isSkip = false
            local attId = v[1]
            local attNum = v[2]
            ---@type cfg_att_info_column
            local tbl = SL:GetConfig("cfg_att_info", attId, "id")
            local attTxt
            if tbl.remarks ~= EAttrRemarkType.Number then
                attTxt = attNum / 100 .. "%"
            else
                attTxt = attNum
            end
            if attId == 200011 then --最小
                attInfo[1] = "攻击力#" .. attTxt .. "~"
            elseif attId == 200021 then --最大
                attInfo[2] = attTxt
            elseif attId == 202021 then --最小
                attInfo[3] = "魔法攻击力#" .. attTxt .. "~"
            elseif attId == 202011 then --最大
                attInfo[4] = attTxt
            elseif attId == 205011 then --最小
                attInfo[5] = "诅咒攻击力#" .. attTxt .. "~"
            elseif attId == 205021 then --最大
                attInfo[6] = attTxt
            else
                attTxt =SL:GetColorText(tbl.name,color)  .. "@" .. SL:GetColorText(attTxt,color)
                table.insert(self.attTxtList, attTxt)
                isSkip = true
            end

            if not isSkip then
                if attInfo[1] and attInfo[2] then
                    table.insert(self.attTxtList, SL:GetColorText(attInfo[1] .. attInfo[2],color))
                    attInfo[1] = nil
                    attInfo[2] = nil
                elseif attInfo[3] and attInfo[4] then
                    table.insert(self.attTxtList, SL:GetColorText(attInfo[3] .. attInfo[4],color))
                    attInfo[3] = nil
                    attInfo[4] = nil
                elseif attInfo[5] and attInfo[6] then
                    table.insert(self.attTxtList, SL:GetColorText(attInfo[5] .. attInfo[6],color))
                    attInfo[5] = nil
                    attInfo[6] = nil
                end
            end
        end
    end
    GUI:DataListUpdateData(self.view.dataList_att, true)
end

function this:Hide()
end

function this:Close()
    local panel = GUI:GetUI("dev/outui/Mount/Panel/KLMountDisplay/KLMountDisplayPanel")
    if panel then
        GUI:setVisible(panel.view.btn_collect, true)
    end
end
return this
