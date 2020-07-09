 
 /*------------------------------------------------------------------------
    File        : Group
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

class RTFWriter.Group implements IDocumentPart: 
  
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

  def var DocumentParts as List no-undo.

  constructor public Group():
    DocumentParts = new List().
  end constructor.
  
  /**
   * Purpose: Add Text to this Group
   * @return the new Text
   */
  method public Text AddText(content as char):
    def var txt as Text no-undo.
    
    txt = new Text(content).
    DocumentParts:Add(txt).
    
    return txt.
  end method.
  
  /**
   * Purpose: Add a Group to this Group
   * @return the new Group
   */
  method public Group AddGroup():
    def var grp as Group no-undo.
    
    grp = new Group().
    DocumentParts:Add(grp).
    
    return grp.
  end method.

  /**
   * Output the Group
   */
  method public character Output(  ):
    return OutputOpen() + OutputCommands() + OutputParts() + OutputClose().
  end method.
  
  /**
   * Output the RTF commands
   */
  method protected character OutputCommands():
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
  
  /**
   * Output the parts withing this group
   */
  method protected character OutputParts():
    def var outText as char no-undo.
    def var partsIterator as IIterator no-undo.
    def var part as IDocumentPart no-undo.

    partsIterator = DocumentParts:Iterator().
    do while partsIterator:HasNext():
      part = cast(partsIterator:Next(), IDocumentPart).
      outText = outText + part:Output().
    end.

    return outText.
  end method.
  
  /**
   * Output the open text
   */
  method protected character OutputOpen():
    return "~{".
  end method.
  
  /**
   * Output the close text
   */
  method protected character OutputClose():
    return "}".
  end method.

end class.