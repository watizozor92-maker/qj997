local t = SL:Get_G()['DataManager']
local this = t.uiBoxTipsInfo
 this.eventContainer:UnRegistAll() -- 取消掉消息注册
 this.messageContainer:UnRegistAll() -- 取消掉消息注册

-- -- 返回穿戴位置
-- -- 该方法要重写
-- ---@param item CommonProtos.Item
-- ---@return EEquipSlotType
-- function this:GetPutSlot(item, wearBarId)
--     local cfgId = item.cfgId
--     local tbl = SL:GetConfig("cfg_item",cfgId)
--     local strPart = tbl.strPart[1]

--     -- 双手武器直接返回， 不进行判断
--     if tbl.twoHanded == 1 then
--         return EEquipSlotType.TwoHandWeapon
--     end

--     local equips = SL:GetTotalWearEquips() or {}
--     if equips[wearBarId] and #tbl.strPart > 1 then
--         local equips = equips[wearBarId]
--         for _, v in pairs(tbl.strPart) do
--             if not equips[v] then
--                 return v
--             end
--         end
--         local equip1 = equips[tbl.strPart[1]]
--         local equip2 = equips[tbl.strPart[2]]
--         return self:CompareItemGradeAndEntrys(equip1, equip2) and tbl.strPart[1] or tbl.strPart[2]
--     end

--     -- 通常情况
--     return strPart
-- end

-- function this:CompareItemGradeAndEntrys(oldItem, newItem)
--     --先比较类型 然后比较评分
--     --评分相同则比较词条数量
--     local old = self:GetEquipReplaceRating(oldItem)
--     local new = self:GetEquipReplaceRating(newItem)
--     if old and new and old[1] == new[1] then
--         local oldGrade = old[2] or 0
--         local newGrade = new[2] or 0
--         if newGrade > oldGrade then
--             return true
--         elseif newGrade == oldGrade then
--             local oldEntrys = SL:GetEquipEntrys(oldItem)
--             local newEntrys = SL:GetEquipEntrys(newItem)
--             return table.count(newEntrys) > table.count(oldEntrys)
--         end
--     end
--     return false
-- end

-- ---@param item CommonProtos.Item
-- function this:GetEquipReplaceRating(item)
--     if SL.replaceEngineFunc[EReplaceEngineFunc.CalcEquipGrade] then
--         return SL.replaceEngineFunc[EReplaceEngineFunc.CalcEquipGrade](item)
--     else
--         local cfgId = item.cfgId
--         --配置的初始评分
--         if SL:HasConfig("cfg_equip_entryLib", cfgId) then
--             local cfg = SL:GetConfig("cfg_equip_entryLib", cfgId)
--             return cfg.replaceRating
--         end
--         return nil
--     end
-- end

-- local wearBarList = {}
-- ---添加符合条件的新装备  装备/职业/评分
-- ---@param bagItem BagProtos.BagItem
-- ---@param item CommonProtos.Item
-- this.TryAddNewEquip = function(self, bagItem, item)
--     item = item or bagItem.item
--     if item.endTime ~= 0 and item.endTime * 1000 <= Time.GetServerTime() then
--         return
--     end
--     if self:RemoveEquipRepeat(item.id) then
--         return
--     end

--     local itemCfg = SL:GetConfig("cfg_item",item.cfgId)
--     if itemCfg.type ~= EItemType.Equip or not self:CareeritemjobCheck(itemCfg.job) or self.quickPopUpItemIdList[item.cfgId] then
--         return
--     end

--     table.clear(wearBarList)
--     if table.count(itemCfg.wearBarID) > 1 then
--         local wearBars = SL:GetMetaValue("GET_OPEN_WEARBARS")
--         if wearBars then
--             for i, wearBarId in pairs(itemCfg.wearBarID) do
--                 if table.contains(wearBars, wearBarId) then
--                     table.insert(wearBarList, wearBarId)
--                 end
--             end
--         else
--             table.insert(wearBarList, itemCfg.wearBarID[1])
--         end
--     else
--         table.insert(wearBarList, itemCfg.wearBarID[1])
--     end
--     local career = SL:GetMetaValue("ME_CAREER_TAB_COLUMN")
--     for _, wearId in pairs(wearBarList) do
--         local pos = self:GetPutSlot(item, wearId)
--         if pos == EEquipSlotType.OffHandWeapon and itemCfg.subType == EItemSubType_Equip.MainSecWeapon then
--             --穿戴主副手武器时， 有些职业的副手装备需要单独做检测
--             ---@type cfg_equip_entryLib_column
--             local entryLib = SL:GetConfig("cfg_equip_entryLib", item.cfgId)
--             if not table.isNullOrEmpty(entryLib.assistantJob) and entryLib.assistantJob[1][1] ~= 0 then
--                 local canEquip = false
--                 for _, jobInfo in pairs(entryLib.assistantJob) do
--                     local baseCareer = jobInfo[1]
--                     local careerRank = jobInfo[2]
--                     if career.baseCareer == baseCareer and career.careerRank >= careerRank then
--                         canEquip = true
--                         break
--                     end
--                 end
--                 if not canEquip then
--                     break
--                 end
--             end
--         end

--         local nowItem = SL:MeData_GetEquipByPosAndWearBar(pos, wearId)
--         if (nowItem == nil or self:CompareItemGradeAndEntrys(nowItem, item)) then
--             if equipList[wearId] == nil then
--                 equipList[wearId] = {}
--             end
--             local indexOfEquip = wearId << 16 | pos
--             if not equipList[wearId][indexOfEquip] then
--                 equipList[wearId][indexOfEquip] = {}
--             end
--             if table.isNullOrEmpty(equipList[wearId][indexOfEquip]) then
--                 bagItem = bagItem or { item = item }
--                 table.insert(equipList[wearId][indexOfEquip], bagItem)
--                 isBreak = true
--                 break
--             else
--                 ---穿戴部位唯一
--                 if table.count(itemCfg.strPart) == 1 then
--                     if equipList[wearId][indexOfEquip][1].item == nil or self:CompareItemGradeAndEntrys(equipList[wearId][indexOfEquip][1].item, item) then
--                         equipList[wearId][indexOfEquip] = {}
--                         bagItem = bagItem or { item = item }
--                         table.insert(equipList[wearId][indexOfEquip], bagItem)
--                     end
--                 elseif table.count(itemCfg.strPart) == 2 then
--                     bagItem = bagItem or { item = item }
--                     self:ReplaceLowEquip(equipList[wearId][indexOfEquip], bagItem)
--                 end

--             end

--         end
--     end

-- end