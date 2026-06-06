---@class BagCellUtil @注释
BagCellUtil = class()
local this = BagCellUtil


function this.SortItemList(itemList, maxHor, maxVet)

    local sortItem = {}
    local useCellDict = {}

    -- 缺省时使用背包的配置
    maxHor = maxHor or RoleManager.meData.bagInfo.bagHorSize
    maxVet = maxVet or RoleManager.meData.bagInfo.bagVetSize

    -- itemList要变了 深拷贝一下
    local copyItemList = itemList

    -- 开始放物品
    for _, item in pairs(copyItemList) do
        -- 把物品放到每个格子上
        local isPut = false
        for hor=1, maxHor do

            -- 放置完了， 不用在遍历
            if isPut == true then
                break
            end

            for vet=1, maxVet do
                if BagInfo.GetCanPutItemInBagWithUseCellDict(hor, vet, item.cfgId, useCellDict, maxHor, maxVet) then
                    local putKey = BagInfo.GetIntWithHorAndVet(hor, vet)
                    sortItem[putKey] = item
                    isPut = true

                    -- 更新物品占用表
                    local holdVet, holdHor =  BagInfo.GetBagSizeByCfgId(item.cfgId)
                    for nowHor=hor, hor+holdHor-1 do
                        for nowVet=vet, vet+holdVet-1 do
                            useCellDict[BagInfo.GetIntWithHorAndVet(nowHor, nowVet)] = true
                        end
                    end

                    break
                end
            end
        end
    end

    return sortItem
end

-- 给定包裹放置字典， 判断是否能将item放置在srcHor行,srcVet的位置
-- maxHor, maxVet 缺省时使用背包的配置
function this.CanPutItemInBag(srcHor, srcVet, item, putBagDict, maxHor, maxVet)
    
    local useCellDict = this.GetUseCellDict(putBagDict)
    return this.GetCanPutItemInBagWithUseCellDict(srcHor, srcVet, item, useCellDict, maxHor, maxVet)
end

---@private
--- 获得物品占用表
---@param putBagDict table<number,CommonProtos.Item>
function this.GetUseCellDict(putBagDict)

    local UseCellDict = {}
    for putKey, item in pairs(putBagDict) do
        local hor, vet = BagInfo.GetHorAndVetWithInt(putKey)

        -- 物品占的行列
        local holdHor, holdVet =  BagInfo.GetBagSizeByCfgId(item.cfgId)

        for nowHor=hor, hor+holdHor-1 do
            if UseCellDict[nowHor] == nil then
                UseCellDict[nowHor] = {}
            end

            for nowVet=vet, vet+holdVet-1 do
                UseCellDict[nowHor][nowVet] = true
            end
        end
    end

    return UseCellDict
end

