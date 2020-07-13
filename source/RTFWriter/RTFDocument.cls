 
 /*------------------------------------------------------------------------
    File        : Document
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : CurtisJA
    Created     : Tue Jul 07 14:39:46 EDT 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using RTFWriter.*.
using OpenEdge.Core.Collections.*.

block-level on error undo, throw.

class RTFWriter.RTFDocument inherits RTFContainer: 
  /** The document character set. */
  define public property CharacterSet as char init "ansi" no-undo public get. public set.
  /** The document language code. Defaulted to U.S. English. */
  define public property LanguageCode as char init "1033" no-undo public get. public set.
  /** The default font id */
  define public property DefaultFont as int init 0 no-undo public get. public set.
  /** The default font size in points */
  define public property DefaultFontSize as dec init 12 no-undo public get. public set.
  /** Turn on widow-and-orphans control to avoid breaking a paragraph between its first and second lines, or between its second-to-last and last lines. */
  define public property WidowAndOrphansControl as log init no no-undo public get. public set.
  /** Automatically add hyphens. */
  define public property AutomaticHyphenation as log init no no-undo public get. public set.
  /** The top page margin in points */
  define public property MarginTop as dec init 72 no-undo public get. public set.
  /** The bottom page margin in points */
  define public property MarginBottom as dec init 72 no-undo public get. public set.
  /** The top page margin in points */
  define public property MarginLeft as dec init 90 no-undo public get. public set.
  /** The top page margin in points */
  define public property MarginRight as dec init 90 no-undo public get. public set.
  
  def var Fonts as char no-undo.
  def var Colors as char no-undo.
  def stream exp.

  /**
   * Purpose: Add a font to the document's font table
   * @param name The name of the font
   * @return the font id or -1 if not added
   */
  method public int AddFont(name as char):
    if name = "" then return -1.
    if num-entries(Fonts) > 0 then Fonts = Fonts + ",".
    Fonts = Fonts + name.
    return num-entries(Fonts) - 1.
  end method.
  
  /**
   * Purpose: Add a color to the document's color table
   * @param value The hex value of the color
   * @return the font id or -1 if not added
   */
  method public int AddColor(colorValue as char):
    if colorValue = "" then return -1.
    if num-entries(Colors) > 0 then Colors = Colors + ",".
    Colors = Colors + colorValue.
    return num-entries(Colors). // Account for the default color
  end method.
  
  /**
   * Purpose: Save the rtf to a file
   * @param rtfFilename The rtf file name
   */
  method public void SaveToFile(rtfFilename as char):
    output stream exp to value(rtfFilename) convert target "1252".
    put stream exp unformatted string(this-object:Output()).
    output stream exp close.
  end.
  
  /**
   * Purpose: Save the rtf to a file
   * @param rtfFilename The rtf file name
   * @param sourceCodepage The source codepage to convert from. If the codepage is incorrect, non-ascii characters will display as question marks.
   */
  method public void SaveToFile(rtfFilename as char, sourceCodepage as char):
    output stream exp to value(rtfFilename) convert source sourceCodepage target "1252".
    put stream exp unformatted string(this-object:Output()).
    output stream exp close.
  end.
  
  /**
   * Output the open text
   */
  method protected override character OutputOpen():
    def var outText as character no-undo.
    
    outText = outText + "~{" + OutputProlog() + OutputFontTable() + "~n".
    
    outText = outText + OutputColorTable().
    
    outText = outText + OutputPreliminaries().

    return outText.
  end method.
  
  /**
   * Output the close text
   */
  method protected override character OutputClose():
    return "}~n".
  end method.
  
  /**
   * Purpose: Output the rtf prolog
   * @return the prolog text
   */
  method private char OutputProlog():
    return "\rtf1\" + (if lookup(CharacterSet, "ansi,mac,pc,pca") > 0 then CharacterSet else "ansi") + "\deff" + string(DefaultFont) + " ".
  end.
  
  /**
   * Purpose: Output the rtf font table
   * @return the font table text
   */
  method private char OutputFontTable():
    def var outText as char no-undo.
    def var i as int no-undo.
    
    if Fonts = "" then
      undo, throw new Progress.Lang.AppError("No fonts set for RTF output.", 0).
    
    outText = "~{\fonttbl ".
    
    do i = 1 to num-entries(Fonts):
      outText = outText + "~{\f" + string(i - 1) + " " + entry(i, Fonts) + ";}".
    end.
    
    outText = outText + "}".
    
    return outText.
  end method.
  
  /**
   * Purpose: Output the rtf color table
   * @return the color table text
   */
  method private char OutputColorTable():
    def var outText as char no-undo.
    def var i as int no-undo.
    def var clr as Color no-undo.
    
    if Colors = "" then return "".
    
    outText = "~{\colortbl~n".
    outText = outText + ";~n". // Always declare the default color first.
    
    do i = 1 to num-entries(Colors):
      clr = new Color(entry(i, Colors)).
      outText = outText + "\red" + string(clr:Red) + "\green" + string(clr:Green) + "\blue" + string(clr:Blue) + ";~n".
    end.
    
    outText = outText + "}~n".
    
    return outText.
  end method.
  
  /**
   * Purpose: Output the preliminaries like language code and margins
   * @return the preliminaries text
   */
  method private char OutputPreliminaries():
    def var outText as char no-undo.
    def var i as int no-undo.
    def var clr as Color no-undo.
    
    outText = "\deflang" + LanguageCode + "\plain\fs" + string(DefaultFontSize * 2).
    if WidowAndOrphansControl then
      outText = outText + "\widowctrl".
    if AutomaticHyphenation then
      outText = outText + "\hyphauto".
    if MarginTop <> 72 then
      outText = outText + "\margt" + RTFDocument:PointsToTwips(MarginTop).
    if MarginBottom <> 72 then
      outText = outText + "\margb" + RTFDocument:PointsToTwips(MarginBottom).
    if MarginLeft <> 80 then
      outText = outText + "\margl" + RTFDocument:PointsToTwips(MarginLeft).
    if MarginRight <> 80 then
      outText = outText + "\margr" + RTFDocument:PointsToTwips(MarginRight).
    outText = outText + "~n".
    
    return outText.
  end method.
  
  /**
   * Purpose: Convert points to a twips character string.
   * @return the twips character string.
   */
  method public static char PointsToTwips(points as decimal):
    return string(truncate(points * 20, 0)).
  end method.
end class.