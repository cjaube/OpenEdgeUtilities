 
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
using RTFWriter.IRTFDocumentPart.

block-level on error undo, throw.

class RTFWriter.RTFText implements IRTFDocumentPart: 
  
  define public property Content as longchar no-undo public get. public set.
  
  constructor public RTFText(content as longchar):
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

end class.