--工具自动生成
---@class MuBoxProto.MuBoxInfoRes
---@field boxPrivilege boolean @是否解锁特权
---@field dailyGift boolean @是否领取过每日礼包
---@field state number @ 0关闭  1开启
---@field boxUrl string @下载链接
---@field appId number @渠道id
---@field name string @渠道名
---@field muBoxInfo MuBoxProto.MuBoxInfo[] @盒子特权信息
---@field titleId number @显示的称号序号
---@field isHideSelf boolean @ 是否隐藏自己的称号  false：不隐藏 true：隐藏
---@field isHideRests boolean @ 是否隐藏其他的称号  false：不隐藏 true：隐藏
---@field isBoxLogin boolean @是否盒子登录

---@class MuBoxProto.PrivilegeGiftReq
---@field boxCfgId number @盒子配置id

---@class MuBoxProto.MuBoxInfo
---@field type number @1-特权称号 2-每日礼包 3-超级礼包
---@field id number 
---@field state number @子功能是否开启
---@field cfgInfo MuBoxProto.CfgInfo[] @内容信息
---@field activate boolean @是否已领取或是否已激活  false：未领取、未激活 true：已领取、已激活
---@field functionName string @功能对应的名字

---@class MuBoxProto.CfgInfo
---@field id number @ 道具id或属性id等
---@field value number @ 道具数量或属性值

---@class MuBoxProto.UpdatePrivilegeTitleReq
---@field hideSelfTitle boolean @ 是否隐藏自己的称号  false：不隐藏 true：隐藏
---@field hideRestsTitle boolean @ 是否隐藏其他的称号  false：不隐藏 true：隐藏

---@class MuBoxProto.BoxCdKeyReq
---@field cdKey string @ 盒子推广礼包码

---@class MuBoxProto.MuBoxPopupConfigRes
---@field lastLoginTime number @上次登录时间
---@field iconSwitch boolean @常驻图标弹窗开关，false ：关闭；true：开启
---@field loginSwitch boolean @每日首登弹窗开关，false ：关闭；true：开启
---@field icon string @icon图标对应路径
---@field iconImage string @icon弹窗对应背景图路径
---@field iconDownload string @icon弹窗对应下载链接
---@field loginImage string @每日首登弹窗对应背景图路径
---@field loginDownload string @每日首登弹窗对应下载链接

