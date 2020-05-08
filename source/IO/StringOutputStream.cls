 
 /*------------------------------------------------------------------------
  MIT License
  
  Copyright (c) 2020 Curtis Aube, Vermont Systems
  
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
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