 
 /*------------------------------------------------------------------------
    File        : RTFRow
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : CurtisJA
    Created     : Thu Jul 09 17:08:37 EDT 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using RTFWriter.*.
using OpenEdge.Core.Collections.*.

block-level on error undo, throw.

class RTFWriter.RTFRow implements IRTFDocumentPart: 

  /** The size of the left and right cell margins measured in points */
  define public property CellMargins as int init 0 no-undo public get. public set.
  /** The x offset of the row measured in points */
  define public property XOffset as int init 0 no-undo public get. public set.

  def var Cells as List no-undo.

  constructor public RTFRow():
    Cells = new List().
  end constructor.

  /**
   * Purpose: Add a new cell to the row
   * @return the newly created cell
   */
  method public RTFCell AddCell():
    def var cell as RTFCell no-undo.
    
    cell = new RTFCell().
    Cells:Add(cell).
    
    return cell.
  end method.

  /**
   * Output the Row
   */
  method public longchar Output(  ):
    def var outText as char init "" no-undo.
    def var cellIterator as IIterator no-undo.
    def var cell as RTFCell no-undo.
    def var cellx as int no-undo.
    
    outText = "\trowd \trgaph" + RTFDocument:PointsToTwips(CellMargins) + "~n".
    
    if XOffset > 0 then
      outText = outText + "\trleft" + RTFDocument:PointsToTwips(XOffset) + " ".
    
    cellx = XOffset.
    cellIterator = Cells:Iterator().
    do while cellIterator:HasNext():
      cell = cast(cellIterator:Next(), RTFCell).
      cellx = cellx + cell:Width.
      outText = outText + cell:OutputDeclaration(cellx).
    end.
    
    outText = outText + "~n".
    
    cellIterator = Cells:Iterator().
    do while cellIterator:HasNext():
      cell = cast(cellIterator:Next(), RTFCell).
      outText = outText + cell:Output().
    end.
    
    outText = outText + "\row~n".
    return outText.
  end method.

end class.