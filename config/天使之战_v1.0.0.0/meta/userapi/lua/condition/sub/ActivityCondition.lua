---
--- Created by zhouzhipeng.
--- DateTime: 2026/1/6 下午5:06
--- Desc：检测活动
---

ConditionHandler:register(ConditionId.activity["活动是否开启"], "真实时间检测", function(actor, param)
    local activityId = tonumber(param)
    local activityInfo = getactivityinfo(activityId)
    return activityInfo.open
end)