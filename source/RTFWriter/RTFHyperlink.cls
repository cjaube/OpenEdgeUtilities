 
 /*------------------------------------------------------------------------
    File        : RTFHyperlink
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

class RTFWriter.RTFHyperlink inherits RTFGroup: 

  /** The url to use */
  define public property UrlText as char no-undo public get. public set.
  
  /**
   * Output the open text
   */
  method protected override character OutputOpen():
    return "~{\field~{\*\fldinst~{HYPERLINK ~"" + UrlText + "~"}}~{\fldrslt~{".
  end method.
  
  /**
   * Output the close text
   */
  method protected override character OutputClose():
    return "}}}".
  end method.

end class.