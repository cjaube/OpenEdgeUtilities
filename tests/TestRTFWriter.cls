 
 /*------------------------------------------------------------------------
    File        : TestRTFWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : CurtisJA
    Created     : Tue Jul 07 14:39:12 EDT 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.Core.Assert.
using RTFWriter.*.

block-level on error undo, throw.

class TestRTFWriter:
  
  @Test.
  method public void Test_Document_Blank():
    def var doc as RTFDocument no-undo.
    
    doc = new RTFDocument().
    doc:AddFont('Times').
    
    Assert:Equals("~{\rtf1\ansi\deff0", substring (doc:Output(), 1, 17)). 
    
    doc:DefaultFont = 1.
    
    Assert:Equals("~{\rtf1\ansi\deff1", substring (doc:Output(), 1, 17)). 
    
    doc:CharacterSet = "pc".
    
    Assert:Equals("~{\rtf1\pc\deff1", substring (doc:Output(), 1, 15)). 
    
  end method.
  
  @Test.
  method public void Test_Paragraph_Output():
    def var par as RTFParagraph no-undo.
    
    par = new RTFParagraph().
    par:AddText("This is a test").
    
    Assert:Equals("~{\pard This is a test\par}~n", par:Output()). 
  end method.
  
  @Test.
  method public void Test_Group_Formatted():
    def var par as RTFParagraph no-undo.
    def var grp as RTFGroup no-undo.
    
    par = new RTFParagraph().
    par:AddText("This is ").
    grp = par:AddGroup().
    grp:Italics = true.
    grp:AddText("a").
    par:AddText(" ").
    grp = par:AddGroup().
    grp:Bold = true.
    grp:AddText("test").
    par:AddText(".").
    
    
    Assert:Equals("~{\pard This is ~{\i a} ~{\b test}.\par}~n", par:Output()). 
  end method.
  
  @Test.
  method public void Test_Row_Output():
    def var rw as RTFRow no-undo.
    def var cel as RTFCell no-undo.
    def var c as char no-undo.
    
    rw = new RTFRow().
    rw:XOffset = 72.
    rw:CellMargins = 12.
    cel = rw:AddCell().
    cel:Bold = yes.
    cel:AddText("Description").
    cel:Width = 144.
    cel = rw:AddCell().
    cel:Bold = yes.
    cel:AddText("Price").
    
    Assert:Equals("\trowd\trgaph240\trleft1440~n\cellx4320~n\cellx5760~n\pard\intbl ~{\b Description}\cell~n\pard\intbl ~{\b Price}\cell~n\row~n", rw:Output()). 
  end method.
    
end class.