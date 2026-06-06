---@class KLUIChallengeBossLineItem:UIKmlLuaPanelBase
---@field view KLUIChallengeBossLineItemView
local KLUIChallengeBossLineItem = class(UIKmlLuaPanelBase)
local this = KLUIChallengeBossLineItem
---创建时调用一次
function this:Init()
    --GUI:Text_setString(self.view.num,"")
end

---创建或者刷新界面数据时调用
function this:Refresh()

end

function this:RefreshItem(monsterid, map, move, panel, height, cfg_BOSS_challenge, index)
    self.isOpen = true
    self.panel = panel
    self.index = index
    --SL:LogError(self.args.is_copy)
    ----@type cfg_BOSS_challenge_column
    self.cfg_BOSS_challenge = cfg_BOSS_challenge
    if self.args.is_copy and self.args.is_copy == 1 then
        self.mapId = monsterid
        self.data = map
        height = 217
        --[[if height == 217 then
        else
            height = 230
        end]]
        self.monsterid   = self.data[1]
        self.monster_num = self.data[2]
        self.x           = self.data[3]
        self.y           = self.data[4]
        self.range       = self.data[5]
        local name       = nil
        --local level = self.cfg_BOSS_challenge.level
        local pos_tr     = ""
        ----@type cfg_map_info_column
        local map_info   = nil
        if self.cfg_BOSS_challenge and self.cfg_BOSS_challenge.monsterType == EBossChallengeType.Sanctuary then
            map_info = SL:GetConfig('cfg_map_info', self.mapId, 'id')
            ----@type cfg_mapMove_column
            local map_move = SL:GetConfig('cfg_mapMove', move, 'id')
            name = map_info.mapname
            --level = map_move.level
            pos_tr = string.format("<color=#00FF00>[跨]</color>%s [%s线]", name, 1)
            self.line = 1
            self.monsterid = cfg_BOSS_challenge.monsterid
            self.monster_num = 1
        else
            ---@type cfg_repfairyland_column
            local tab = SL:GetConfig('cfg_repfairyland', self.mapId, 'id')
            name = tab.name[1]
            --level = tab.level
            pos_tr = string.format("%s(%s,%s)", name, self.x, self.y)
        end
        local lineName = SL:GetMapLineName(map_info.id,self.line)
        GUI:Text_setString(self.view.name, pos_tr..lineName)
        --GUI:Text_setString(self.view.level,level.."级")
        --local playerLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
        self.is_jion = true
        self.is_show_num = true
        --[[        if playerLevel < level then
            GUI:setVisible(self.view.level,true)
            GUI:setVisible(self.view.num,false)
            self.is_show_num = false
        else
            self.is_jion = true
            GUI:setVisible(self.view.level,false)
            GUI:setVisible(self.view.num,true)
        end]]
        GUI:setVisible(self.view.level, false)
        GUI:setVisible(self.view.num, true)
        GUI:Text_setString(self.view.num, "")
        local src = "btn_weixuanzhongfenxian"
        if map_info and map_info.goldmap and map_info.goldmap == 1 then
            src = "btn_weixuanzhongfenxian"
            GUI:setContentSize(self.view.btn, height, 45)
        else
            GUI:setContentSize(self.view.btn, height, 45)
        end
        --GUI:Image_loadTexture(self.view.btn,src,"Atlas/UIChallengeBoss.spriteatlas")
        --self:GetCopyMonsterCount()
    else
        self.monsterid = monsterid
        self.mapId = map[1]
        self.line = map[2]
        self.moveId = move[1]
        local map_info = SL:GetConfig('cfg_map_info', self.mapId, 'id')
        local move_info = SL:GetConfig('cfg_mapMove', self.moveId, 'id')
        self.mapX = move_info.mapX
        self.mapY = move_info.mapY
        --local map_info = SL:FindConfigs("cfg_map_info","id",self.mapId)
        local lineName = SL:GetMapLineName(map_info.id,self.line)
        local name = map_info.mapname .. " [" .. self.line .. "线]"..lineName
        --local level = move_info.level
        --local level = self.cfg_BOSS_challenge.level
        GUI:Text_setString(self.view.name, name)
        --[[        local level_str = level.."级"
        if self.args.is_copy and self.args.is_copy == 2 then
            local monster_level = SL:GetConfig('cfg_monster', self.monsterid, 'id').level
            level_str = monster_level.."级"
        end
        GUI:Text_setString(self.view.level,level_str)]]
        --local playerLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
        --self.is_jion = false
        self.is_show_num = true
        --[[        if playerLevel < level then
            GUI:setVisible(self.view.level,true)
            GUI:setVisible(self.view.num,false)
            self.is_show_num = false
        else
            self.is_jion = true
            GUI:setVisible(self.view.level,false)
            GUI:setVisible(self.view.num,true)
        end]]
        self.is_jion = true
        GUI:setVisible(self.view.level, false)
        GUI:setVisible(self.view.num, true)
        height = 217
        --[[if height == 217 then
        else
            height = 230
        end]]
        GUI:Text_setString(self.view.num, "")
        local src = "btn_weixuanzhongfenxian"
        if map_info.goldmap and map_info.goldmap == 1 then
            src = "btn_weixuanzhongfenxian"
            GUI:setContentSize(self.view.btn, height, 45)
        else
            GUI:setContentSize(self.view.btn, height, 45)
        end
        --GUI:Image_loadTexture(self.view.btn,src,"Atlas/UIChallengeBoss.spriteatlas")
        --self:GetMonsterCount()
    end
    self:MonserCount()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn, self, self.OnclickIcon)
    --SL:RegisterLuaNetMsg(LuaMessageIdToClient.MONSTER_COUNT_RESULT_BY_ID,self.MONSTER_COUNT_RESULT_BY_ID,self)
end

function this:OnclickIcon()
    if not self.is_jion then
        SL:TipMessage(SL:GetConfig('cfg_string', 249).text, 1, NoticeType.NoticeMid)  --"等级不足",
        return
    end
    local map_id = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    local mapTab = SL:GetConfig("cfg_map_info", map_id)
    if mapTab.nopositionmove and mapTab.nopositionmove == 1 then
        SL:MessageTip({ id = 116 }) --"副本中无法传送",
        return
    end
    ---@type cfg_map_info_column
    local map_info = nil
    if SL:HasConfig('cfg_map_info', self.mapId) then
        map_info = SL:GetConfig('cfg_map_info', self.mapId)
    end

    if map_info and map_info.goldmap == 1 and not PrivilegeCardManager.isGoldLine2() then
        SL:OpenCommonTipPanelById(27)
        return
    end
    -- 检查黄金分线特权条件 2103
    local mapLineCfg = SL:GetConfig("cfg_map_line", self.mapId)
    local entryCondition = string.split(mapLineCfg.entryCondition, '|')
    for i, v in pairs(entryCondition) do
        local condition = string.split(v, '#')
        if tonumber(condition[1]) == self.line and condition[2] == "2103" and condition[3] == "27" and not PrivilegeCardManager.isGoldLine2() then
            SL:OpenCommonTipPanelById(27)
            return
        end
    end

    if not self:CheckCost(map_info) then
        SL:CommonItemGetPath(nil, map_info.transferCost[1][1])
        SL:TipMessage("消耗金币不满足，无法传送", 1, NoticeType.NoticeMid) --"等级不足",
        return
    end

    local mapMove_info = SL:GetConfigMultiKeys("cfg_mapMove", self.mapId, "mapID")
    if not SL:CheckCondition(mapMove_info.conditions) then
        SL:TipMessage("需要穿戴翅膀", 1, NoticeType.NoticeMid)
        return
    end
    if mapMove_info then
        local playerLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
        if tonumber(mapMove_info.level) > playerLevel then
            SL:TipMessage(string.format("等级不足%s", tostring(mapMove_info.level)), 1, NoticeType.NoticeMid) --"等级不足",
            return
        end
    end
    if self.cfg_BOSS_challenge and self.cfg_BOSS_challenge.monsterType == EBossChallengeType.Sanctuary then
        local IsSatisfy, tipsStr = InfoManager.sanctuaryBossInfo:GetIsSatisfy()
        if IsSatisfy then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CROSS_MAP_TRANSFER_TO_NPC,
                { npcid = self.cfg_BOSS_challenge.npcInteraction })
            InfoManager.sanctuaryBossInfo.sanctuaryNpcId = self.cfg_BOSS_challenge.npcInteraction
            InfoManager.sanctuaryBossInfo.sanctuaryMapId = self.mapId
            GUI:UIPanel_Close("dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel")
            SL.ShowMainPanel()
        else
            SL:TipMessage(tipsStr, 1, NoticeType.NoticeMid)  --"次数不足",
            return
        end
    else
        if self.args.is_copy and self.args.is_copy == 1 then
            if not self.panel:isJoin() then
                SL:TipMessage(SL:GetConfig('cfg_string', 256).text, 1, NoticeType.NoticeMid)  --"次数不足",
                return
            end
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ENTER_SECRET_REALM, { repId = self.mapId })
            GUI:UIPanel_Close("dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel")
        else
            self:GetMonsterPos()
        end
    end


    --GUI:UIPanel_Open("dev/outui/ChallengeBoss/Panel/KLChallengeBossPos/KLChallengeBossPosPanel")
end

---@param cfg cfg_map_info_column
function this:CheckCost(cfg)
    for i, v in pairs(cfg.transferCost) do
        if SL:GetBagItemCount(v[1]) < v[2] * InfoManager.redNameInfo:GetMapTransmissionCost() then
            return false
        end
    end
    return true
end

function this:GoldBossBtnDataListItemCountFunc()
    return #self.allGoldLevel
end

function this:GoldBossBtnDataListItemGetFunc(realIndex)
    local data = self.allGoldLevel[realIndex + 1]
    local item = GUI:UIPanel_Open("dev/ui/ChallengeBoss/Item/KLUIChallengeBossBtnItem/KLUIChallengeBossBtnItem",
        self.view.gold_boss_level, self, {}, true)
    self.glod_boss_level_btn_all_item[item.view.root] = item
    return item.view.root
end

function this:GoldBossBtnDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:GoldBossBtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.allGoldLevel[realIndex + 1]
    self.glod_boss_level_btn_all_item[kmlcontrol]:RefreshItem(data, self.select_gold_level, self)
    if data == self.select_gold_level then
        self.GoldBossLevelBtn = self.glod_boss_level_btn_all_item[kmlcontrol]
    end
end

function this:GetMonsterCount()
    --GUI:setGrey(self.view.btn,false)
    GUI:Text_setString(self.view.num, "")
    if not self.is_show_num then
        return
    end
    if not self.mapId or not self.line or not self.monsterid then
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.GET_MOUNSTER_COUNT_BY_MAP,
        { mapCfgId = self.mapId, line = self.line, monsterCfgId = self.monsterid, state = 1 })
end

function this:MONSTER_COUNT_RESULT_BY_ID(id, message)
    InfoManager.challengeBossInfo.count_data = message
    self:MonserCount()
end

function this:MonserCount()
    if not InfoManager.challengeBossInfo.count_data then
        return
    end
    local tempData = nil
    for k, v in pairs(InfoManager.challengeBossInfo.count_data) do
        for k2, v2 in pairs(v) do
            if v2.monsterCfgId == self.monsterid and v2.mapCfgId == self.mapId and v2.line == self.line then
                tempData = v2
                break
            end
        end
        if tempData then
            break
        end
    end
    if not tempData then
        return
    end
    local monsterCount = tempData.monsterCount
    if not monsterCount then
        monsterCount = 0
    end
    --GUI:Button_loadTextureNormal(self.view.btn, monsterCount > 0 and "btn_weixuanzhongfenxian" or "btn_xuanzhongfenxian", "Atlas/UIChallengeBoss.spriteatlas")
    GUI:Text_setString(self.view.num, monsterCount .. "只")
    --GUI:Text_setTextColor(self.view.name, monsterCount < 1 and "#FF2323" or "#FFFFFF")
    --GUI:Text_setTextColor(self.view.num, monsterCount < 1 and "#FF2323" or "#1ADE1F")
end

--[[--获得秘境副本怪物指定地图位置范围的怪物数量
function this:GetCopyMonsterCount()
    if not self.isOpen then
        return
    end
    --SL:LogError("GetCopyMonsterCount")
    --GUI:setGrey(self.view.btn,false)
    --GUI:Button_loadTextureNormal(self.view.btn, "btn_xuanzhongfenxian", "Atlas/UIChallengeBoss.spriteatlas")
    GUI:Text_setString(self.view.num,"")
    if not self.is_show_num then
        return
    end
    if not self.mapId or not self.monsterid then
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.GET_SECRET_REALM_MONSTER_COUNT, {repId=self.mapId,monsterId=self.monsterid,x=self.x,y=self.y,range=self.range})
end]]

function this:MonserCopyCount(id, message)
    if not message then
        return
    end
    if message.repId ~= self.mapId or message.x ~= self.x or message.y ~= self.y or message.range ~= self.range then
        return
    end
    local monsterCount = message.count
    --SL:LogError(monsterCount)
    if not monsterCount then
        monsterCount = 0
    end
    local timeStr = message.time
    GUI:Button_loadTextureNormal(self.view.btn, monsterCount > 0 and "btn_weixuanzhongfenxian" or "btn_xuanzhongfenxian",
        "Atlas/UIChallengeBoss.spriteatlas")
    if monsterCount <= 0 then
        timeStr = tonumber(timeStr)
        local current_time = Time.GetServerTime()
        timeStr = math.ceil((timeStr - current_time) / 1000)
        if timeStr > 0 then
            -- SL:ScheduleOnce(timeStr+0.5,function ()
            --     self:GetCopyMonsterCount()
            -- end)
            --GUI:setGrey(self.view.btn,true)
            --GUI:setGrey(self.view.btn,false)
            GUI:Text_setString(self.view.num, "")
            GUI:setVisible(self.view.end_time, true)
            GUI:SetControl_time(self.view.end_time, timeStr)
        else
            GUI:setVisible(self.view.end_time, false)
            --GUI:setGrey(self.view.btn,false)
            GUI:Text_setString(self.view.num, monsterCount .. "只")
        end
    else
        GUI:setVisible(self.view.end_time, false)
        --GUI:setGrey(self.view.btn,false)
        GUI:Text_setString(self.view.num, monsterCount .. "只")
    end

    --GUI:Text_setString(self.view.num,monsterCount.."只")
end

function this:GetMonsterPos()
    if not self.is_show_num then
        return
    end
    if not self.mapId or not self.line or not self.monsterid then
        return
    end
    local map_line = SL:GetMetaValue(EMetaVarGetKey.MAP_LINE)
    local map_id = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    if map_id == self.mapId and self.line == map_line and SL:MeData_Check() then
        if not SL:GetIsWebGL() then
            local me_x = SL:MeData_GetCoord().x
            local me_y = SL:MeData_GetCoord().z
            local all_monster = {}
            local all_status = SL:GetMapMonsterStatus()
            local one = 1
            for i, data in ipairs(all_status) do
                if data.configId == self.monsterid and data.status == one then
                    table.insert(all_monster, { configId = data.configId, x = data.pointX, y = data.pointY })
                end
            end
            local num = 0
            local index = 0
            SL:OpenWaitingUI({ msg = "最佳线路寻怪中" })
            local current_index = 1
            local is_end = false
            self.wait = SL:Schedule(self.wait, 0, Time.deltaTime, -1, function()
                if is_end then
                    return
                end
                local current_time = Time.GetServerTime()
                if current_index <= #all_monster then
                    local data = all_monster[current_index]
                    local arrive, path = SL:SearchPath({ x = me_x, z = me_y }, { x = data.x, z = data.y })
                    if arrive then
                        data.num = path.n
                        if num == 0 then
                            num = data.num
                            index = current_index
                        else
                            if num > data.num then
                                num = data.num
                                index = current_index
                            end
                        end
                    end
                    if current_index <= #all_monster then
                        current_index = current_index + 1
                        return
                    end
                end
                if current_index >= #all_monster then
                    is_end = true
                    if index > 0 then
                        local pos_data = all_monster[index]
                        SL:onLUAEvent(LUA_EVENT_CHALLENGE_BOSS_MONSTER_POS,
                            { mapCfgId = self.mapId, line = self.line, x = pos_data.x, y = pos_data.y, monsterCfgId =
                            self.monsterid })
                    else
                        SL:SendLuaNetMsg(LuaMessageIdToSever.GET_NEAREST_MONSTER,
                            { mapCfgId = self.mapId, line = self.line, monsterCfgId = self.monsterid, state = 1, x = me_x, y =
                            me_y })
                    end
                    SL:HideWaitingUI()
                    SL:UnSchedule(self.wait)
                end
            end)
        else
            local msg = { mapCfgId = self.mapId, line = self.line, monsterCfgId = self.monsterid }
            SL:onLUAEvent(LUA_EVENT_CHALLENGE_BOSS_MONSTER_POS_AFTER, msg)
        end
    else
        local msg = { mapCfgId = self.mapId, line = self.line, monsterCfgId = self.monsterid }
        local curMapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
        ---@type cfg_map_info_column
        local mapInfo = SL:GetConfig("cfg_map_info", curMapId)
        if mapInfo.nopositionmove == 1 then
            SL:MessageTip({ id = 116 })
            return
        end
        local mapMoveCfg = SL:GetConfigMultiKeys("cfg_mapMove", self.mapId, "mapID")
        local tips = InfoManager.redNameInfo:IsLimitTransferById(SL:GetMetaValue("MAIN_ACTOR_ID"), self.mapId,
            self.line)
        if tips then
            SL:TipMessage(tips, 1, NoticeType.NoticeMid) --pk值较高，无法传送
            return
        end

        SL:onLUAEvent(LUA_EVENT_CHALLENGE_BOSS_MONSTER_POS_AFTER, msg)
        --SL:MapTransfer(self.mapId, self.line)

        if mapMoveCfg then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MAP_MOVE_TRANSFER, { id = mapMoveCfg.id, line = self.line })
        else
            SL:TipMessage("传送失败，找不到地图id" .. self.mapId, 1, NoticeType.NoticeMid)
        end
    end
end

function this:Close()
    --self:UnRegistEvents()
    self.isOpen = false
end

function this:UnRegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.MONSTER_COUNT_RESULT_BY_ID, self.MONSTER_COUNT_RESULT_BY_ID, self)
end

return this
