 
 /*------------------------------------------------------------------------
    File        : TestColor
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Curtis Aube
    Created     : Tue May 19 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.Core.Assert.

block-level on error undo, throw.

class TestColor:
  
  def var TestColor1 as Color no-undo.
  def var TestColor2 as Color no-undo.
  
  @Test.
  method public void Test_Color_ToHexString():
    TestColor1 = new Color('#ffdd33').
    Assert:Equals("#ffdd33", TestColor1:ToHexString()). 
    TestColor1 = new Color(44, 103, 201).
    Assert:Equals("#2c67c9", TestColor1:ToHexString()). 
  end method.

  @Test.
  method public void Test_Color_Darken():
    TestColor1 = new Color('#ffffff').
    Assert:Equals("#cccccc", TestColor1:Darken(20):ToHexString()). 
    TestColor1 = new Color(44, 103, 201).
    TestColor1:Darken(20).
    Assert:Equals(0, TestColor1:Red).  // Doesn't go below 0
    Assert:Equals(103 - 51, TestColor1:Green). // 51 is 20%
    Assert:Equals(201 - 51, TestColor1:Blue).  // 51 is 20%
  end method.
  
  @Test.
  method public void Test_Color_Lighten():
    TestColor1 = new Color('#000000').
    Assert:Equals("#333333", TestColor1:Lighten(20):ToHexString()). 
    TestColor1 = new Color(44, 103, 230).
    TestColor1:Lighten(20).
    Assert:Equals(44 + 51, TestColor1:Red).  // 51 is 20%
    Assert:Equals(103 + 51, TestColor1:Green).  // 51 is 20%
    Assert:Equals(255, TestColor1:Blue).  // Doesn't go over 255
  end method.
  
  @Test.
  method public void Test_Color_RelativeLuminance():
    TestColor1 = new Color('#FA7014').
    Assert:Equals("0.3196", string(TestColor1:RelativeLuminance(), "9.9999")). 
    TestColor1 = new Color('#057014').
    Assert:Equals("0.1167", string(TestColor1:RelativeLuminance(), "9.9999")). 
  end method.
  
  @Test.
  method public void Test_Color_ContrastRatio():
    TestColor1 = new Color('#FFFFFF').
    TestColor2 = new Color('#FA7014').
    Assert:Equals("2.84", string(TestColor1:ContrastRatio(TestColor2), "9.99")). 
    Assert:Equals("2.84", string(TestColor2:ContrastRatio(TestColor1), "9.99")). 
  end method.
  
  @Test.
  method public void Test_Color_PickContrastingColor():
    TestColor1 = new Color('#FFFFFF').
    Assert:Equals("#e0e0e0", TestColor1:PickContrastingColor(4.5, "#EAEAEA,#E0E0E0"):ToHexString()).  // Pick highest contrast when not meeting minumum
    Assert:Equals("#606060", TestColor1:PickContrastingColor(4.5, "#EAEAEA,#606060,#303030"):ToHexString()).  // Pick lowest contrast that meets minumum
    TestColor1 = new Color('#F0A070').
    Assert:Equals("#303030", TestColor1:PickContrastingColor(4.5, "#FFFFFF,#606060,#303030"):ToHexString()).
  end method.
end class.