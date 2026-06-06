---@class UIKmlLuaControl
UIKmlLuaControl={}

---@class UIKmlLuaPanelBase
---@field baseUI UIKmlLuaPanelBase
---@field filePath string
---@field args any
---@field view UIKmlLuaViewBase
---@field subWins table<string,UIKmlLuaPanelBase[]> @可为空
---@field parent UIKmlLuaControl
---@field panelName string
---@field wiilBeClose boolean
---@field isLoading boolean
UIKmlLuaPanelBase = {}

---@class UIKmlLuaViewBase
---@field root UIKmlLuaControl
---@field InitRoot function
UIKmlLuaViewBase={}

---@class UIKmlLuaControlHandler
---@field panel UIKmlLuaPanelBase
---@field controlId string
---@field controlPath string
UIKmlLuaControlHandler={}

class={}
CS={}

---@alias IntMap table<number,number>
---@alias IntListList number[][]
---@alias DoubleListList number[][]
---@alias DoubleList number[]
---@alias StringList string[]
---@alias IntList number[]
---@alias StringListList string[][]
---@alias IntListListList table<number,table<number,table<number,number>>>
---@alias StringListListList table<number,table<number,table<number,string>>>


---@class ServerStruct
---@field name string @名称 
---@field domainAdr string @地址
---@field state number @显示状态(1新服，2畅通，3爆满，4维护，5隐藏,6过期(和4一样的效果)),7-关闭(和4一样的效果),8-测试清档(和4一样的效果)
---@field port number @端口
---@field sid number @区服id
---@field bigAreaName number @区服分组id
---@field engineVersoin string @引擎版本
---@field gmResGroup string @GM资源组
---@field gmVersion string @GM版本
---@field dataConfigIndex number @配置文件索引号 DataConfig。暂时屏蔽，注释。
---@field isGaoFangServer boolean @是否是高仿服务器
---@field mergeServerSid number @合服后，这个字段高仿的时候第一个包用来发送，没有值就用sid
---@field isOnlyShowInWhiteIp boolean @仅白名单的才显示


---@class HpData
---@field hp number 当前血量
---@field maxHp number 最大血量

---@class MpData
---@field mp number 当前蓝量
---@field maxMp number 最大蓝量

---@class EquipChangeData
---@field MakeIndex number 唯一ID
---@field Where number 装备位置
---@field opera number 操作类型 ( 0-初始化 1-增加 2-删除 3:改变)
---@field ItemData CommonProtos.Item 装备数据，
---@field WearBar number 穿戴栏id cfg_wearing_bar的id