 
 /*------------------------------------------------------------------------
    File        : Text
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : CurtisJA
    Created     : Wed Jul 08 11:49:45 EDT 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using RTFWriter.IDocumentPart.

block-level on error undo, throw.

class RTFWriter.Text implements IDocumentPart: 
  
  define public property Content as longchar no-undo public get. public set.
  
  constructor public Text(content as longchar):
    this-object:Content = content.
  end constructor.

  method public longchar Output(  ):
    def var outText as longchar no-undo.
    outText = Content.
    outText = replace(outText, "\", "\\").
    outText = replace(outText, "~{", "\~{").
    outText = replace(outText, "}", "\}").
    
    return outText.
  end method.
  /*
  method public longchar Output(  ):
    def var outText as longchar init "" no-undo.
    def var i as int no-undo.
    def var singleChar as char no-undo.
    def var unicodeValue as int no-undo.
    
    do i = 1 to length(Content):
      assign
        singleChar = substring(Content,i,1)
        unicodeValue = asc(singleChar, "utf-8").
      if lookup(singleChar, "~{}\") <> 0 then assign
        outText = outText + "\" + singleChar.
      else if unicodeValue > 127 then assign
        outText = outText + "\u" + string(unicodeValue).
      else assign
        outText = outText + singleChar.
    end.
    
    return outText.
  end method.
  */

end class.