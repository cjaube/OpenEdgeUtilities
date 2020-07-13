 
 /*------------------------------------------------------------------------
    File        : RTFParagraph
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : CurtisJA
    Created     : Tue Jul 07 16:08:16 EDT 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using RTFWriter.*.

block-level on error undo, throw.

class RTFWriter.RTFParagraph inherits RTFGroup: 

  /** Align the text: left, right, center, or justify */
  define public property TextAlign as char init "" no-undo public get. public set.
  /** Add space before the paragraph measured in points */
  define public property SpaceBefore as int no-undo public get. public set.
  /** Add space after the paragraph measured in points */
  define public property SpaceAfter as int no-undo public get. public set.
  /** Indent the first line of the paragraph measured in points */
  define public property Indent as int no-undo public get. public set.
  /** Indent the whole paragraph measured in points  */
  define public property IndentBlock as int no-undo public get. public set.
  /** Indent the whole paragraph on the right measured in points */
  define public property IndentBlockRight as int no-undo public get. public set.
  
  /**
   * Output the RTF commands
   */
  method protected override character OutputCommands():
    def var outText as char init "" no-undo.
    
    outText = super:OutputCommands().
    
    if TextAlign <> "" then do:
      if lookup(TextAlign, "left,right,center,justify") = 0 then
        undo, throw new Progress.Lang.AppError("Invalid value for TextAlign. Must be 'left', 'right', 'center', or 'justify'.", 0).
      case TextAlign:
        when "left" then
          outText = outText + "\ql".
        when "right" then
          outText = outText + "\qr".
        when "center" then
          outText = outText + "\qc".
        when "justify" then
          outText = outText + "\qj".
      end.
    end.
    if SpaceBefore > 0 then
      outText = outText + "\sb" + RTFDocument:PointsToTwips(SpaceBefore).
    if SpaceAfter > 0 then
      outText = outText + "\sa" + RTFDocument:PointsToTwips(SpaceAfter).
    if Indent > 0 then
      outText = outText + "\fi" + RTFDocument:PointsToTwips(Indent).
    if IndentBlock > 0 then
      outText = outText + "\li" + RTFDocument:PointsToTwips(IndentBlock).
    if IndentBlockRight > 0 then
      outText = outText + "\ri" + RTFDocument:PointsToTwips(IndentBlockRight).

    return outText.
  end method.
  
  /**
   * Output the open text
   */
  method protected override character OutputOpen():
    return "~{\pard ".
  end method.
  
  /**
   * Output the close text
   */
  method protected override character OutputClose():
    return "\par}~n".
  end method.

end class.