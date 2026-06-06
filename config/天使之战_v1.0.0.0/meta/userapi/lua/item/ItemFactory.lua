---
--- Created by zhouzhipeng.
--- DateTime: 2025/12/25 下午1:23
---

ItemFactory = {}

function ItemFactory.build(itemDate)
    local item = {}
    item.id = itemDate.id
    item.cfgId = itemDate.cfgid
    item.count = itemDate.count
    item.bind = itemDate.isbind
    item.correctId = itemDate.correctid
    item.time = itemDate.createtimesec
    item.unTrade = itemDate.untrade
    item.endTime = itemDate.endtimesec
    local entries = {}
    for k, info in pairs(itemDate.entries or {}) do
        local entryAttr = {}
        entryAttr.increaseTimes = 0
        entryAttr.type = info.attrid
        entryAttr.level = info.grade
        entryAttr.initNum = info.value
        entryAttr.pos = k
        entryAttr.entryId = info.entryid
        entryAttr.num = info.value
        table.insert(entries, entryAttr)
    end
    item.itemExtInfo = { equipExtInfo = { entryAttr = entries } }
    item.luaExtData = itemDate.luaextdata
    return item
end
