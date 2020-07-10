
/*------------------------------------------------------------------------
    File        : RTFContainer
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

class RTFWriter.RTFContainer abstract implements IRTFDocumentPart:  
  
  def var DocumentParts as List no-undo.

  constructor public RTFContainer():
    DocumentParts = new List().
  end constructor.
  
  /**
   * Purpose: Add a new paragraph to the document
   * @return the newly created pargarph
   */
  method public RTFParagraph AddParagraph():
    def var par as RTFParagraph no-undo.
    
    par = new RTFParagraph().
    DocumentParts:Add(par).
    
    return par.
  end method.
  
  /**
   * Purpose: Add Text to this Document Part
   * @return the new Text
   */
  method public RTFText AddText(content as char):
    def var txt as RTFText no-undo.
    
    txt = new RTFText(content).
    DocumentParts:Add(txt).
    
    return txt.
  end method.
  
  /**
   * Purpose: Add a Group to this Document Part
   * @return the new Group
   */
  method public RTFGroup AddGroup():
    def var grp as RTFGroup no-undo.
    
    grp = new RTFGroup().
    DocumentParts:Add(grp).
    
    return grp.
  end method.
  
  /**
   * Purpose: Add a Hyperlink to this Document Part
   * @return the new Group
   */
  method public RTFHyperlink AddHyperlink():
    def var link as RTFHyperlink no-undo.
    
    link = new RTFHyperlink().
    DocumentParts:Add(link).
    
    return link.
  end method.
  
  /**
   * Purpose: Add a Row to this Document Part
   * @return the new Row
   */
  method public RTFRow AddRow():
    def var rw as RTFRow no-undo.
    
    rw = new RTFRow().
    DocumentParts:Add(rw).
    
    return rw.
  end method.

  /**
   * Output the Container
   */
  method public longchar Output(  ):
    return OutputOpen() + OutputParts() + OutputClose().
  end method.
  
  /**
   * Output the parts withing this group
   */
  method protected longchar OutputParts():
    def var outText as char no-undo.
    def var partsIterator as IIterator no-undo.
    def var part as IRTFDocumentPart no-undo.

    partsIterator = DocumentParts:Iterator().
    do while partsIterator:HasNext():
      part = cast(partsIterator:Next(), IRTFDocumentPart).
      outText = outText + part:Output().
    end.

    return outText.
  end method.
  
  /**
   * Output the open text
   */
  method protected abstract character OutputOpen().
  
  /**
   * Output the close text
   */
  method protected abstract character OutputClose().
end class.