 
 /*------------------------------------------------------------------------
    File        : StringOutputStream
    Purpose     : For use with JsonSerializer to serialize class object to longchar.
    Syntax      : 
    Description : 
    Author(s)   : Curtis Aube
    Created     : Mon Apr 27 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using Progress.IO.OutputStream.

block-level on error undo, throw.

class IO.StringOutputStream inherits OutputStream: 

  def public property OutputData as longchar get. private set.
  
  /**
   * Take the sourceData and copy it to longchar OutputData.
   * It doesn't work if we copy-lob because the sourceData is padded with null characters.
   * https://knowledgebase.progress.com/articles/Article/P110518
   * https://knowledgebase.progress.com/articles/Article/P116459
   */
  method override public int64 Write( input sourceData as memptr, input offset as int64, input length as int64 ):
    def var sourceSize as int64 no-undo.
    def var counter as int64 no-undo.
    def var acsiiNumber as int no-undo.
    
    sourceSize = get-size(sourceData).
    
    do counter = 1 to sourceSize:
      acsiiNumber = get-byte(sourceData, counter).
      if acsiiNumber = 0 then leave.
      OutputData = OutputData + chr(acsiiNumber).
    end.
    
    return sourceSize.
  end method.

  method override public int64 Write( input sourceData as longchar ):
  end method.

  method override public int64 Write( input sourceData as character ):
  end method.

end class.