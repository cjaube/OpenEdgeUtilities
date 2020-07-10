 
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
  /** The vertical alignment of the cell: 'top', 'middle', or 'bottom'. */
  define public property VerticalAlign as char init "" no-undo public get. public set.
  /** The horizontal alignment of the cell: 'left', 'center', or 'right'. */
  define public property HorizontalAlign as char init "" no-undo public get. public set.
  /** The cell border style: 'solid', 'dotted', 'dashed', or 'double'. */
  define public property BorderStyle as char init "" no-undo public get. public set.
  /** The cell border thickness measured in points. */
  define public property BorderThickness as decimal init 1 no-undo public get. public set.

  /**
   * Output the cell declaration
   */
  method public char OutputDeclaration(cellx as decimal):
    def var i as int no-undo.
    def var outText as char init "" no-undo.
    if BorderStyle <> "" and BorderThickness > 0 then do:
      if lookup(BorderStyle, "solid,dotted,dashed,double") = 0 then
        undo, throw new Progress.Lang.AppError("Invalid value for BorderStyle. Must be 'solid', 'dotted', 'dashed', or 'double'.", 0).
      else do:
        do i = 1 to 4:
          outText = outText + "\clbrdr" + entry(i, "t,l,b,r").
          outText = outText + "\brdrw" + RTFDocument:PointsToTwips(BorderThickness).
          case BorderStyle:
            when "solid" then
              outText = outText + '\brdrs'.
            when "dotted" then
              outText = outText + '\brdrdot'.
            when "dashed" then
              outText = outText + '\brdrdash'.
            when "double" then
              outText = outText + '\brdrdb'.
          end case.
        end.
      end.
    end.
    if VerticalAlign <> "" then do:
      if lookup(VerticalAlign, "top,middle,bottom") = 0 then
        undo, throw new Progress.Lang.AppError("Invalid value for VerticalAlign. Must be 'top', 'middle', or 'bottom'.", 0).
      else case VerticalAlign:
        when "top" then
          outText = outText + '\clvertalt'.
        when "middle" then
          outText = outText + '\clvertalc'.
        when "bottom" then
          outText = outText + '\clvertalb'.
      end case.
    end.
    outText = outText + "\cellx" + RTFDocument:PointsToTwips(cellx) + "~n".
    return outText.
  end method.
  
  /**
   * Output the open text
   */
  method protected override character OutputOpen():
    def var outText as char init "" no-undo.
    outText = "\pard\intbl".
    if HorizontalAlign <> "" then do:
      if lookup(HorizontalAlign, "left,center,right") = 0 then
        undo, throw new Progress.Lang.AppError("Invalid value for HorizontalAlign. Must be 'left', 'center', or 'right'.", 0).
      else case HorizontalAlign:
        when "left" then
          outText = outText + '\ql'.
        when "center" then
          outText = outText + '\qc'.
        when "right" then
          outText = outText + '\qr'.
      end case.
    end.
    outText = outText + " ~{".
    return outText.
  end method.
  
  /**
   * Output the close text
   */
  method protected override character OutputClose():
    return "}\cell~n".
  end method.

end class.