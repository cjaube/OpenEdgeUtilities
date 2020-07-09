 
 /*------------------------------------------------------------------------
    File        : Hyperlink
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

class RTFWriter.Hyperlink inherits Group: 

  /** The url to use */
  define public property UrlText as char no-undo public get. public set.

  constructor public Hyperlink():
    super().
  end constructor.
  
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
    return " }}}~n".
  end method.

end class.