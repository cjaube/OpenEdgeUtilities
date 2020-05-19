
 /*------------------------------------------------------------------------
    File        : Color
    Purpose     : Parse hex colors and provide manipulations such as lighten and darken.
    Syntax      : 
    Description : 
    Author(s)   : Curtis Aube
    Created     : Wed Apr 01 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

block-level on error undo, throw.

class Color: 
  define public property Red as int64 no-undo public get. public set.
  define public property Green as int64 no-undo public get. public set.
  define public property Blue as int64 no-undo public get. public set.
  
  constructor public Color(colortext as char):
    if colortext begins "#" or colortext begins "0x" then
      ParseHex(colortext).
    else if colortext begins "rgba" then
      ParseRgba(colorText).
    else if colortext begins "rgb" then
      ParseRgb(colorText).
    else
      undo, throw new Progress.Lang.AppError("Unable to parse color text: " + colortext, 0).
  end constructor.
  
  constructor public Color(red as int64, green as int64, blue as int64):
    this-object:Red = red.
    this-object:Green = green.
    this-object:Blue = blue.
  end constructor.
  
  /**
   * Purpose: Convenience method to get a new color object from a hex string.
   * @return this a new color object
   */
  method public static Color FromHex(hexColor as char):
    return new Color(hexColor).
  end method.
  
  /**
   * Purpose: Darken the color by a percentage step
   * Note: If you darken white by 50 percent once, it will be gray; twice, it will be black.
   * @param percent A number between 0 and 100 
   * @return a new color object
   */
  method public Color Darken(percent as int):
    define variable amount as int no-undo.
    
    assign
      amount = Clamp(percent, 0, 100) / 100 * 255
      Red = Clamp(Red - amount, 0, 255)
      Green = Clamp(Green - amount, 0, 255)
      Blue = Clamp(Blue - amount, 0, 255).
    
    return this-object.
  end method.
  
  /**
   * Purpose: Lighten the color by a percentage step
   * Note: If you lighten black by 50 percent once it will be gray; twice, it will be white.
   * @param percent A number between 0 and 100 
   * @return this color object
   */
  method public Color Lighten(percent as int):
    define variable amount as int no-undo.
    
    assign
      amount = Clamp(percent, 0, 100) / 100 * 255
      Red = Clamp(Red + amount, 0, 255)
      Green = Clamp(Green + amount, 0, 255)
      Blue = Clamp(Blue + amount, 0, 255).
    
    return this-object.
  end method.
  
  /**
   * Purpose: Clone this color object
   * @return a new color object
   */
  method override public Progress.Lang.Object Clone():
    return new Color(Red, Green, Blue).
  end method.
  
  /**
   * Purpose: Get the hex color string
   * @return the hex color string
   */
  method public character ToHexString():
    return "#" + IntToHex(Red) + IntToHex(Green) + IntToHex(Blue).
  end method.
  
  /**
   * Purpose: Get the relative luminance of the color
   * Sourced from https://www.w3.org/WAI/GL/wiki/Relative_luminance
   * @return the luminance (between 0% and 100%)
   */
  method public decimal RelativeLuminance():
    define variable RsRGB as decimal no-undo.
    define variable GsRGB as decimal no-undo.
    define variable BsRGB as decimal no-undo.
    define variable R as decimal no-undo.
    define variable G as decimal no-undo.
    define variable B as decimal no-undo.
    
    assign
      RsRGB = Red / 255
      GsRGB = Green / 255
      BsRGB = Blue / 255
      R = if RsRGB <= 0.03928 then RsRGB / 12.92 else exp((RsRGB + 0.055) / 1.055, 2.4)
      G = if GsRGB <= 0.03928 then GsRGB / 12.92 else exp((GsRGB + 0.055) / 1.055, 2.4)
      B = if BsRGB <= 0.03928 then BsRGB / 12.92 else exp((BsRGB + 0.055) / 1.055, 2.4).
      
    return 0.2126 * R + 0.7152 * G + 0.0722 * B.
  end method.
  
  /**
   * Purpose: Get the contrast ratio between this color and another color
   * Sourced from https://www.w3.org/WAI/GL/wiki/Contrast_ratio
   * @param other The other color to test against
   * @return the contract ratio in the range of 1 to 21.
   */
  method public decimal ContrastRatio(other as Color):
    define variable Luminance as decimal no-undo.
    define variable OtherLuminance as decimal no-undo.
    define variable L1 as decimal no-undo.
    define variable L2 as decimal no-undo.
    
    assign
      Luminance = RelativeLuminance()
      OtherLuminance = other:RelativeLuminance().
    
    if Luminance > OtherLuminance then 
      assign
        L1 = Luminance
        L2 = OtherLuminance.
    else
      assign
        L1 = OtherLuminance
        L2 = Luminance.
    return (L1 + 0.05) / (L2 + 0.05).
  end.
  
  /**
   * Purpose: Pick an appropriate color based on the minumum contrast ratio
   * The closest color that meets the minimum contrast will be returned.
   * @param minumumContrast the minumum contrast ratio (4.5 for WCAG AA).
   * @param colors The colors to choose from.
   * @return a new color that meets the minimum contrast or the highest contract listed if none found.
   */
  method public Color PickContrastingColor(minimumContrast as decimal, colors as character):
    define variable ix as int no-undo.
    define variable testColor as Color no-undo.
    define variable testRatio as decimal no-undo.
    define variable bestColor as Color no-undo.
    define variable bestRatio as decimal no-undo.

    do ix = 1 to num-entries(colors):
      testColor = new Color(entry(ix, colors)).
      testRatio = ContrastRatio(testColor).
      if bestColor = ? or
          (testRatio >= minimumContrast and (bestRatio < minimumContrast or testRatio < bestRatio)) or
          (testRatio < minimumContrast and bestRatio < minimumContrast and testRatio > bestRatio) then 
        assign
          bestColor = testColor
          bestRatio = testRatio.
    end.
    
    return bestColor.
  end.
  
  /**
   * Purpose: Parse a hex string in to Red, Green, and blue
   * @param hexColor the hex color to parse
   */
  method private void ParseHex(hexColor as char):
    hexColor = StripHex(hexColor).
    
    Red = HexToInt(substring(hexColor, 1, 2)).
    Green = HexToInt(substring(hexColor, 3, 2)).
    Blue = HexToInt(substring(hexColor, 5, 2)).
  end method.
  
  /**
   * Purpose: Convert an int value in to a 2 digit hex string
   * @param inValue The int value
   * @return hex string
   */
  method private character IntToHex (intValue as int64):
    define variable hex as character no-undo.
    hex = System.Convert:ToString(intValue, 16).
    if length(hex) = 1 then hex = '0' + hex.
    return hex.
  end method.
   
  /**
   * Purpose: Convert a 2 digit hex string in to an int value
   * @param hex The hex string
   * @return int value
   */
  method private int64 HexToInt (hex as character):
    return System.Convert:ToInt64(hex, 16).
  end method.
  
  /**
   * Purpose: Strip extra character from the beginning of a hex string
   * @param hex The hex string
   * @return a string without extra characters
   */
  method private char StripHex(hex as char):
    if hex begins "#" then
      hex = substring(hex, 2).
    else if hex begins "0x" then
      hex = substring(hex, 3).
      
    return hex.
  end method.
  
  /**
   * Purpose: Parse an rgba string in to Red, Green, and blue
   * Note: Ignores the alpha value
   * @param rgbaColor the rgba color to parse
   */
  method private void ParseRgba(rgbaColor as character):
    define variable colorValues as character no-undo.
    
    colorValues = substring(rgbaColor, 6, length(rgbaColor) - 6).
    
    if num-entries(colorValues) < 3 then
      undo, throw new Progress.Lang.AppError("Unable to parse rgba color text: " + rgbaColor, 0).
    
    assign
      Red = int64(entry(1, colorValues))
      Green = int64(entry(2, colorValues))
      Blue = int64(entry(3, colorValues)).
  end method.
  
  /**
   * Purpose: Parse an rgb string in to Red, Green, and blue
   * @param rgbColor the rgb color to parse
   */
  method private void ParseRgb(rgbColor as character):
    define variable colorValues as character no-undo.
    
    colorValues = substring(rgbColor, 5, length(rgbColor) - 5).
    
    if num-entries(colorValues) < 3 then
      undo, throw new Progress.Lang.AppError("Unable to parse rgb color text: " + rgbColor, 0).
    
    assign
      Red = int64(entry(1, colorValues))
      Green = int64(entry(2, colorValues))
      Blue = int64(entry(3, colorValues)).
  end method.
  
  /**
   * Purpose: Clamp an int between a min and max
   * @param intValue the original value
   * @param minValue the minumum value
   * @param maxValue the maximum value
   * @return clamped in
   */
  method private int64 Clamp(intValue as int64, minValue as int64, maxValue as int64):
    intValue = minimum(intValue, maxValue).
    intValue = maximum(intValue, minValue).
    return intValue.
  end method.

end class.