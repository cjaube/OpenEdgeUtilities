 
 /*------------------------------------------------------------------------
    File        : Paragraph
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

class RTFWriter.Paragraph inherits Group: 

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

  constructor public Paragraph():
    super().
  end constructor.
  
  /**
   * Output the RTF commands
   */
  method protected override character OutputCommands():
    def var outText as char init "" no-undo.
    
    outText = super:OutputCommands().
    
    if TextAlign <> "" then do:
      case TextAlign:
        when "left" then
          outText = outText + "\ql ".
        when "right" then
          outText = outText + "\qr ".
        when "center" then
          outText = outText + "\qc ".
        when "justify" then
          outText = outText + "\qj ".
      end.
    end.
    if SpaceBefore > 0 then
      outText = outText + "\sb" + string(SpaceBefore * 20) + " ".
    if SpaceAfter > 0 then
      outText = outText + "\sa" + string(SpaceAfter * 20) + " ".
    if Indent > 0 then
      outText = outText + "\fi" + string(Indent * 20) + " ".
    if IndentBlock > 0 then
      outText = outText + "\li" + string(IndentBlock * 20) + " ".
    if IndentBlockRight > 0 then
      outText = outText + "\ri" + string(IndentBlockRight * 20) + " ".
      
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
    return " \par}~n".
  end method.

end class.