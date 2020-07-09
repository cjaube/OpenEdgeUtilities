
/*------------------------------------------------------------------------
    File        : BaseGroup
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : CurtisJA
    Created     : Tue Jul 07 16:04:35 EDT 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using RTFWriter.*.
using OpenEdge.Core.Collections.*.

class RTFWriter.BaseGroup abstract implements IDocumentPart:  
  
  def var DocumentParts as List no-undo.

  constructor public BaseGroup():
    DocumentParts = new List().
  end constructor.
  
  /**
   * Purpose: Add a new paragraph to the document
   * @return the newly created pargarph
   */
  method public Paragraph AddParagraph():
    def var par as Paragraph no-undo.
    
    par = new Paragraph().
    DocumentParts:Add(par).
    
    return par.
  end method.
  
  /**
   * Purpose: Add Text to this Document Part
   * @return the new Text
   */
  method public Text AddText(content as char):
    def var txt as Text no-undo.
    
    txt = new Text(content).
    DocumentParts:Add(txt).
    
    return txt.
  end method.
  
  /**
   * Purpose: Add a Group to this Document Part
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
  method public longchar Output(  ):
    return OutputOpen() + OutputCommands() + OutputParts() + OutputClose().
  end method.
  
  /**
   * Output the RTF commands
   */
  method protected character OutputCommands():
    return "".
  end method.
  
  /**
   * Output the parts withing this group
   */
  method protected longchar OutputParts():
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