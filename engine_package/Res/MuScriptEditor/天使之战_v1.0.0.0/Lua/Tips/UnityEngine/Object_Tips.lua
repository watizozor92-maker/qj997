local ObjectEx = CS.TCFramework.ObjectEx

function IsNil(obj)
    return obj == nil or ObjectEx.IsNull(obj)
end