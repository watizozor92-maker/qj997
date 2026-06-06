---SDK相关枚举

---上报数据类型
---@class ESubmitDataType
---@field SelectServer number @  = 1, --选择服务器
---@field CreateRole number @ = 2, --创建角色
---@field EnterGame number @ = 3, -- 进入游戏
---@field LevelUp number @ = 4, --等级提升
---@field ExitGame number @ = 5, --退出游戏
---@field Event number @ = 6,--自定义事件
ESubmitDataType ={
    UnKnown = 0, --未知默认类型
    SelectServer = 1, --选择服务器
    CreateRole = 2, --创建角色
    EnterGame = 3, -- 进入游戏
    LevelUp = 4, --等级提升
    ExitGame = 5, --退出游戏
    Event = 6,--自定义事件
}


---定义的一些上报事件写在这里
---@class ESubmitEventType
ESubmitEventType = {
    MainTask = "main_task", --主线任务
    GameTutorial = "gameTutorial",--新手引导
    Join_Union = "join_union",--加入战盟
    Change_Role_Name = "change_role_name"
}



