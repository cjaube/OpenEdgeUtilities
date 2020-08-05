 
 /*------------------------------------------------------------------------
    File        : DocumentWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : CurtisJA
    Created     : Tue Aug 04 09:24:00 EDT 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.Core.*.
using OpenEdge.Core.Collections.*.
using DocumentWriter.*.

block-level on error undo, throw.

class DocumentWriter.DocumentWriter: 
  def static var SegmentSize as int init 31960 no-undo.
  def stream exp.
  
  /**
   * Purpose: Save the document to a file
   * @param content The content of the document
   * @param docFilename The document file name
   */
  method public static void SaveToFile(content as longchar, docFilename as char):
    output stream exp to value(docFilename).
    StreamFile(content).
    output stream exp close.
  end.
  
  /**
   * Purpose: Save the document to a file
   * Note: If the codepages are incorrect, non-ascii characters may display incorrectly.
   * @param content The content of the document
   * @param docFilename The document file name
   * @param targetCodepage The target codepage to convert to.
   */
  method public static void SaveToFile(content as longchar, docFilename as char, targetCodepage as char):
    output stream exp to value(docFilename) convert target targetCodepage.
    StreamFile(content).
    output stream exp close.
  end.
  
  /**
   * Purpose: Save the document to a file
   * Note: If the codepages are incorrect, non-ascii characters may display incorrectly.
   * @param content The content of the document
   * @param docFilename The document file name
   * @param sourceCodepage The source codepage to convert from.
   * @param targetCodepage The target codepage to convert to.
   */
  method public static void SaveToFile(content as longchar, docFilename as char, sourceCodepage as char, targetCodepage as char):
    output stream exp to value(docFilename) convert source sourceCodepage target targetCodepage.
    StreamFile(content).
    output stream exp close.
  end.
  
  /**
   * Purpose: Stream each segment
   */
  method private static void StreamFile(content as longchar):
    def var segment as char no-undo.
    def var i as int init 1 no-undo.

    do while i < length(content):
      if i + SegmentSize - 1 <= length(content) then
        segment = substring(content,i,SegmentSize).
      else
        segment = substring(content,i).
      put stream exp unformatted segment.
      i = i + SegmentSize.
    end.
  end.

end class.