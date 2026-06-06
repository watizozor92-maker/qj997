---存放新手引导相关的枚举值

---@class EGuideShowWay @新手引导显示方式
---@field Arrow number @1：箭头
---@field Content number @2：文本
---@field Mask number @3：黑幕
---@field Highlight number @4：控件高亮
EGuideShowWay = {
    Arrow = enum(1), ---1：箭头
    Content = enum(), ---2：文本
    Mask = enum(), ---3：黑幕
    Highlight = enum(), ---4：控件高亮
    ShowHide =enum(), --5 控制物体显示隐藏
}

---@class EGuideFinishType @新手引导步骤结束方式
---@field AnyClick number @2:点击任意地方
---@field ClickControl number @1:点击控件
EGuideFinishType = {
    AnyClick = enum(2), --点击任意地方
    ClickControl = enum(1), --点击控件
}

---@class EGuideCallType  @新手引导显示方式
---@field AcceptMission number @1：接受任务时触发
---@field ClickMission number @2：点击任务时触发
EGuideCallType = {
    AcceptMission = enum(1), ---1：接受任务时触发
    ClickMission = enum(), ---2：点击任务时触发
}


---@class EGuideShowType @新手引导显示方式
---@field Content number @1：文本+箭头
---@field Highlight number @2：控件高亮
---@field Mask number @3：黑幕
---@field ToProp number @4：指向道具
EGuideShowType = {
    Content = enum(1), ---1：文本+箭头
    Highlight = enum(), ---2：控件高亮
    Mask = enum(), ---3：黑幕
    ToProp = enum(), ---4：指向道具
}

---@class EGuideEndType  @新手引导显示方式
---@field AcceptMission number @1：任务结束后结束
---@field ClickControlToEnd number
EGuideEndType = {
    AfterTaskEnd = enum(1), ---1：接受任务时触发
    AnyClick = enum(2), -- 点击任意地方消失
    ClickControlToEnd = enum(3),
    ClickAndCheckTaskEnd = enum(4), --点击按钮关闭引导，如果任务未结束，引导也不会结束
}