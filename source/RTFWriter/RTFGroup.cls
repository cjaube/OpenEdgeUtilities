 
 /*------------------------------------------------------------------------
    File        : RTFGroup
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : CurtisJA
    Created     : Tue Jul 07 16:08:16 EDT 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using RTFWriter.*.
using OpenEdge.Core.Collections.*.

block-level on error undo, throw.

class RTFWriter.RTFGroup inherits RTFBaseGroup: 
  
  /** Reset any formatting to defaults */
  define public property ResetFormatting as log no-undo public get. public set.
  /** The id of the font to use */
  define public property FontId as int init -1 no-undo public get. public set.
  /** The font size measured in points */
  define public property FontSize as decimal no-undo public get. public set.
  /** The font color in hex format */
  define public property FontColor as int init -1 no-undo public get. public set.
  
  define public property Italics as log no-undo public get. public set.
  define public property Bold as log no-undo public get. public set.
  define public property Underlined as log no-undo public get. public set.
  define public property Superccript as log no-undo public get. public set.
  define public property Subscript as log no-undo public get. public set.
  define public property Smallcaps as log no-undo public get. public set.
  define public property Strikethrough as log no-undo public get. public set.
  
  /**
   * Output the RTF commands
   */
  method protected override character OutputCommands():
    def var outText as char init "" no-undo.
    
    if ResetFormatting then assign
      outText = outText + "\plain ".
    if FontId >= 0 then assign
      outText = outText + "\f" + string(FontId) + " ".
    if FontSize > 0 then assign
      outText = outText + "\fs" + string(truncate(FontSize * 2, 0)) + " ".
    if FontColor >= 0 then assign
      outText = outText + "\cf" + string(FontColor) + " ".
    if Italics then assign
      outText = outText + "\i ".
    if Bold then assign
      outText = outText + "\b ".
    if Underlined then assign
      outText = outText + "\ul ".
    if Superccript then assign
      outText = outText + "\super ".
    if Subscript then assign
      outText = outText + "\sub ".
    if Smallcaps then assign
      outText = outText + "\scaps ".
    if Strikethrough then assign
      outText = outText + "\strike ".
    
    return outText.
  end method.

end class.