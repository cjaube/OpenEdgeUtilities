 
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
  
  define public property Content as char no-undo public get. public set.
  
  constructor public Text(content as char):
    this-object:Content = content.
  end constructor.

  method public character Output(  ):
    def var outText as char no-undo.
    outText = Content.
    outText = replace(outText, "\", "\\").
    outText = replace(outText, "~{", "\~{").
    outText = replace(outText, "}", "\}").
    
    return outText.
  end method.

end class.