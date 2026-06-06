---@class ColorUtil @注释
ColorUtil = class()
local this = ColorUtil

---@param htmlString string @ #ffffff
function this.TryParseHtmlStringToVector4(htmlString)
    ---@type Color
    local b, outColor = ColorUtility.TryParseHtmlString(htmlString)
    if b then
        return Vector4(outColor.r, outColor.g, outColor.b, outColor.a)
    end
    return nil
end

function this.TryParseHtmlStringToColor(htmlString)
    ---@type Color
    local b, outColor = ColorUtility.TryParseHtmlString(htmlString)
    if b then
        return Color(outColor.r, outColor.g, outColor.b, outColor.a)
    end
    return nil
end

---@param htmlString string @ #ffffff
function this.TryParseHtmlStringToColor(htmlString)
    ---@type Color
    local b, outColor = ColorUtility.TryParseHtmlString(htmlString)
    if b then
        return outColor
    end
    return nil
end

function this.GetColorText(msg, color)
    return string.format("<color=%s>%s</color>", color, msg)
end

function this.HexToRGB(str_num, outLine, hex)
    str_num = string.replace(str_num, "#", "")
    local str_num_six
    local rgba = {}
    if string.len(str_num) == 6 then
        str_num_six = str_num
    else
        str_num_six = string.sub(str_num, 1, 7)
    end
    rgba.r = tonumber(string.sub(str_num_six, 1, 2), hex) / 255
    rgba.g = tonumber(string.sub(str_num_six, 3, 4), hex) / 255
    rgba.b = tonumber(string.sub(str_num_six, 5, 6), hex) / 255
    rgba.a = (outLine or 255) / 255
    return rgba
end

function this.RichTextFormatToHex(color)
    return string.replace(color, '#', '0x') .. 'ff'
end

function this.RGB01ToHtmlString(r, g, b, a)
    r = math.ceil(r * 255)
    g = math.ceil(g * 255)
    b = math.ceil(b * 255)
    a = math.ceil(a * 255)
    return string.format("#%x%x%x%x", r, g, b, a)
end 