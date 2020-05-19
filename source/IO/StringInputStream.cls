 
 /*------------------------------------------------------------------------
    File        : StringInputStream
    Purpose     : For use with JsonSerializer to deserialize longchar to class object.
    Syntax      : 
    Description : 
    Author(s)   : Curtis Aube
    Created     : Tue Apr 28 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using Progress.IO.InputStream.

block-level on error undo, throw.

class IO.StringInputStream inherits InputStream: 

  def public property SourceData as longchar get. private set.
  
  constructor public StringInputStream(sourceData as longchar):
    this-object:SourceData = sourceData.
  end constructor.

  method override public int64 Read( input targetData as memptr, input offset as int64, input length as int64 ):
    put-string(targetData, 1) = SourceData.
    return get-size(targetData).
  end method.

  method override public int64 Read( input delimiter0 as character, output target as longchar ):
  end method.

  method override public int64 Read( input delimiter0 as character, output target as character ):
  end method.

end class.