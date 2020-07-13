 
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
USING System.Text.ASCIIEncoding FROM ASSEMBLY.

block-level on error undo, throw.

class RTFWriter.RTFText implements IRTFDocumentPart: 
  
  define public property Content as longchar no-undo public get. public set.
  define public property SourceCodepage as char init "" no-undo public get. public set.
  
  constructor public RTFText(content as longchar, sourceCodepage as char):
    assign
      this-object:Content = content
      this-object:SourceCodepage = sourceCodepage.
  end constructor.
  
  constructor public RTFText(content as longchar):
    this-object:Content = content.
  end constructor.

  method public longchar Output():
    def var outText as longchar init "" no-undo.
    def var i as int no-undo.
    def var singleChar as char no-undo.
    def var unicodeValue as int no-undo.
    
    if sourceCodepage = "" then do:
      outText = Content.
      outText = replace(outText, "\", "\\").
      outText = replace(outText, "~{", "\~{").
      outText = replace(outText, "}", "\}").
    end.
    else do:
      // If we have a sourceCodepage then we can translate non-ascii characters to their unicode representations
      do i = 1 to length(Content):
        assign
          singleChar = substring(Content,i,1)
          unicodeValue = asc(singleChar, "utf-16", sourceCodepage).
        if lookup(singleChar, "~{}\") <> 0 then assign
          outText = outText + "\" + singleChar.
        else if unicodeValue > 127 then assign
          outText = outText + "\uc0\u" + string(unicodeValue) + " ".
        else assign
          outText = outText + singleChar.
      end.
    end.
    
    return outText.
  end method.

end class.