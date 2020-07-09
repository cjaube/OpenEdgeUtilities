 
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

class RTFWriter.Document: 
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
  /** Use real footnotes instead of endnotes */
  define public property RealFootnotes as log init no no-undo public get. public set.
  
  def var DocumentParts as List no-undo.
  def var Fonts as char no-undo.
  def var Colors as char no-undo.
  
  constructor public Document():
    DocumentParts = new List().
  end constructor.
  
  /**
   * Purpose: Add a new paragraph to the document
   * @return the newly created pargarph
   */
  method public Paragraph AddParagraph():
    def var par as Paragraph no-undo.
    
    par = new Paragraph().
    DocumentParts:Add(par).
    
    return par.
  end method.
  
  /**
   * Purpose: Add a font to the document's font table
   * @param name The name of the font
   * @return the font id or -1 if not added
   */
  method public int AddFont(name as char):
    if name = "" then return -1.
    if num-entries(Fonts) > 0 then Fonts = Fonts + ",".
    Fonts = Fonts + name.
    return num-entries(Fonts).
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
    return num-entries(Colors) + 1. // Account for the default color
  end method.
  
  /**
   * Purpose: Output the rtf text.
   * @return the rtf text.
   */
  method public longchar Output():
    def var outText as longchar no-undo.
    def var partsIterator as IIterator no-undo.
    def var part as IDocumentPart no-undo.
    
    outText = outText + "~{" + OutputProlog() + OutputFontTable() + "~n".
    
    outText = outText + OutputColorTable().
    
    outText = outText + OutputPreliminaries().
    
    partsIterator = DocumentParts:Iterator().
    do while partsIterator:HasNext():
      part = cast(partsIterator:Next(), IDocumentPart).
      outText = outText + part:Output().
    end.

    outText = outText + "}~n".
    return outText.
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
    
    outText = "\deflang" + LanguageCode + " \plain \fs" + string(DefaultFontSize * 2) + " ".
    if WidowAndOrphansControl then
      outText = outText + "\widowctrl ".
    if AutomaticHyphenation then
      outText = outText + "\hyphauto ".
    if RealFootnotes then
      outText = outText + "\ftnbj ".
    outText = outText + "~n".
    
    return outText.
  end method.
end class.