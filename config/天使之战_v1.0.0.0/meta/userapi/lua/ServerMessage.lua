ServerMessageID = {
    TRADE_RETURN_PREORDER_COIN = 10001,
    TRADE_TRANSFER_EQUIP_EXIT = 10002,
}

function servermsg(actor, msgData)
    -- local msgId= tonumber( msgData.msgId )
    -- if msgId == ServerMessageID.TRADE_RETURN_PREORDER_COIN then
    --     info(actor,"接收到跨服交易预购货币返还数据", msgData)

    --     local itemId=  msgData.itemId
    --     local cointype=  msgData.cointype
    --     local totalprice=  msgData.totalprice
    --     local itemname=  msgData.itemname
    --     Trade.tradeReturnPreorderCoin0(tonumber(actor:toString()), itemId, cointype, totalprice,itemname)
    -- elseif msgId == ServerMessageID.TRADE_TRANSFER_EQUIP_EXIT then
    --     info(actor,"接收到跨服交易转移装备属性数据", msgData)

    --     local itemId = msgData.itemId
    --     local equipext = msgData.equipext
    --     Trade.transferEquipExit(actor, itemId, equipext)
    -- end
end
