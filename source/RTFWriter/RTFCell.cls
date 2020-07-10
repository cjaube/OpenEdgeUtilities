 
 /*------------------------------------------------------------------------
    File        : RTFCell
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : CurtisJA
    Created     : Fri Jul 10 08:42:02 EDT 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using RTFWriter.*.

block-level on error undo, throw.

class RTFWriter.RTFCell inherits RTFGroup: 

  /** The width of the cell in points */
  define public property Width as decimal init 72 no-undo public get. public set.

  /**
   * Output the cell declaration
   */
  method public char OutputDeclaration(cellx as decimal):
    return "\cellx" + RTFDocument:PointsToTwips(cellx) + " ".
  end method.
  
  /**
   * Output the open text
   */
  method protected override character OutputOpen():
    return "\pard\intbl ~{".
  end method.
  
  /**
   * Output the close text
   */
  method protected override character OutputClose():
    return "}\cell~n".
  end method.

end class.