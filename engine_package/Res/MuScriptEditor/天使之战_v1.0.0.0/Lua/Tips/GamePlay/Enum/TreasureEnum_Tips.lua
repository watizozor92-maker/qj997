--藏宝阁（交易行）

---@class ETreasureUpType
ETreasureUpType = {
    Buy = enum(1),
    Sale = enum(),
    Shelf = enum(),
    Mine = enum(),
}

---@class ETreasureLeftType
ETreasureLeftType = {
    Role = enum(1),
    Money = enum(),
    Item = enum(),
    ToMe = enum(),
}

---@class ECmdCode
ECmdCode = {
    GetOSS = 10001, --获取oss临时访问地址
    SaleRole = 20001, --寄售角色
    SaleItem = 20002, --寄售道具
    SaleMoney = 20003, --寄售货币
    OperAction = 20004, --取回/上架/下架/修改商品/解冻角色
    SaleRecord = 20005, --出售记录
    Shelf = 20006, --货架
    BuyList = 30001, --购买列表
    GoodsDetail = 30002, --商品详情
    BuyRecord = 30003, --购买记录
    MyAccount = 40001, --我的账户信息
}

---@class EGoodsType
EGoodsType = {
    Role = 1, --角色
    Item = 2, --道具
    Money = 4, --货币
}

---@class EGoodsSort
EGoodsSort = {
    Up = 1, --升序
    Down = 0, --降序
}

---@class EGoodsSortType
EGoodsSortType = {
    Price = 1, --价格
    RemainTime = 2, --剩余时间
    RemainCount = 3, --剩余数量
}

---@class EGoodsAction
EGoodsAction = {
    GetBack = 1, --取回
    UpShelf = 2, --上架
    DownShelf = 3, --下架
    Modify = 4, --修改
    UnFreezeRole = 5, --解冻角色
}

---@class EStallType
EStallType = {
    Shot = 0, --角色截图
    Role = 1, --角色类型
    Item = 2, --道具类型
    Money = 4, --货币类型
}

---@class EGoodsState
EGoodsState = {
    UpShelfing = 1, --上架中
    DownShelef = 2, --下架
}



