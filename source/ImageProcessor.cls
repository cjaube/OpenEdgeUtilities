 
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
using System.Array.
using System.Drawing.Image.
using System.Drawing.RotateFlipType.
using System.Drawing.Imaging.PropertyItem.
using System.Drawing.Imaging.ImageFormat.
using System.IO.MemoryStream.
using System.BitConverter.

block-level on error undo, throw.

class Business.Library.ImageProcessor: 
  def var FileData as memptr no-undo.
  def var Ext as char no-undo.
  def var Img as Image no-undo.
  def var IsDirty as log no-undo.
  
  def var exifOrientationID as int init 274 no-undo. //0x112
  
  constructor public ImageProcessor(cFileData as memptr, extension as char):
    FileData = cFileData.
    Ext = extension.
  end constructor.

  /**
   * Purpose: Read EXIF data and apply orientation correction. Only valid for JPEG files.
   * Sourced from https://stackoverflow.com/questions/6222053/problem-reading-jpeg-metadata-orientation/38459903#38459903
   */
  method public void CorrectOrientation():
    define variable exifOrientation as int no-undo.
    define variable prop as PropertyItem no-undo.
    
    if Ext <> ".jpg" and Ext <> ".jpeg" then
      return.
      
    if Img = ? then
      Img = MemptrToImage(FileData).
    
    if Array:IndexOf(Img:PropertyIdList, exifOrientationID) = -1 then
      return.
    
    prop = img:GetPropertyItem(exifOrientationID).
    exifOrientation = prop:Value:GetValue(0).
    case exifOrientation:
        when 1 then return. // No rotation
        when 2 then Img:RotateFlip(RotateFlipType:RotateNoneFlipX).
        when 3 then Img:RotateFlip(RotateFlipType:Rotate180FlipNone).
        when 4 then Img:RotateFlip(RotateFlipType:Rotate180FlipX).
        when 5 then Img:RotateFlip(RotateFlipType:Rotate90FlipX).
        when 6 then Img:RotateFlip(RotateFlipType:Rotate90FlipNone).
        when 7 then Img:RotateFlip(RotateFlipType:Rotate270FlipX).
        when 8 then Img:RotateFlip(RotateFlipType:Rotate270FlipNone).
    end.
    
    // This EXIF data is now invalid and should be removed.
    Img:RemovePropertyItem(exifOrientationID).
    
    IsDirty = yes.
  end method.
  
  /**
   * Purpose: Get the file data from the processed image
   * @return The new file data
   */
  method public memptr GetFileData():
    if Img <> ? and IsDirty then
      FileData = ImageToMemptr(Img).
    return FileData.
  end method.
  
  /**
   * Purpose: Converts an MEMPTR to a .NET Image
   * @param cFileData The MEMPTR
   * @return The new Image
   */
  method private System.Drawing.Image MemptrToImage( cFileData as memptr ):
    define variable systemImage  as System.Drawing.Image no-undo.
    define variable memoryStream as System.IO.MemoryStream no-undo.
    
    memoryStream = new System.IO.MemoryStream(MemptrToByteArray(cFileData)).
    systemImage = System.Drawing.Image:FromStream(memoryStream, true).
    memoryStream:close().
    
    return systemImage.
  end method.
  
  /**
   * Purpose: Converts a .NET Image to MEMPTR
   * @param systemImage The Image to convert
   * @return The new MEMPTR
   */
  method private memptr ImageToMemptr( systemImage as System.Drawing.Image ):
    define variable memoryStream as System.IO.MemoryStream no-undo.

    memoryStream = new System.IO.MemoryStream().
    systemImage:Save(memoryStream, GetFormat()) no-error.
    
    if memoryStream:Length <> 0 then
      return byteArrayToMemptr(memoryStream:ToArray()).
    else
      return FileData.
    
    finally:
      memoryStream:close().
    end finally.
  end method.
  
  /**
   * Purpose: Converts an extension in to an ImageFormat
   * @return The ImageFormat
   */
  method private ImageFormat GetFormat():
    case Ext:
      when ".bmp" then return ImageFormat:Bmp.
      when ".exif" then return ImageFormat:Exif.
      when ".icon" then return ImageFormat:Icon.
      when ".jpg" then return ImageFormat:Jpeg.
      when ".jpeg" then return ImageFormat:Jpeg.
      when ".png" then return ImageFormat:Png.
      when ".tiff" then return ImageFormat:Tiff.
    end.
    return ?.
  end method.
  
  /**
   * Purpose: Converts a .NET Byte[] to an ABL MEMPTR
   * Sourced from https://community.progress.com/community_groups/openedge_development/f/19/t/30025
   * @param poBytes The System.Byte[] to convert to a MEMPTR
   * @return The new MEMPTR with the data from the Byte[]
   */
  method private memptr ByteArrayToMemptr (poBytes as "System.Byte[]":U):
 
    define variable memptr      as memptr        no-undo.
    define variable oIntPointer as System.IntPtr no-undo.
    define variable ptrVal as int64           no-undo.
 
    set-size (memptr) = poBytes:Length . 
    ptrVal = get-pointer-value (memptr).
    oIntPointer = new System.IntPtr (ptrVal). 
    System.Runtime.InteropServices.Marshal:Copy (poBytes, 0, oIntPointer, poBytes:Length). 
    return memptr .
 
    finally:
        delete object oIntPointer.
    end finally.
  end method.
 
  /**
   * Purpose: Converts an ABL MEMPTR to a .NET Byte[]
   * Sourced from https://community.progress.com/community_groups/openedge_development/f/19/t/30025
   * @param pmptr The MEMPTR to convert to System.Byte[]
   * @return The new Byte[]
   */
  method private "System.Byte[]" MemptrToByteArray( pmptr as memptr ):
    define variable nPtr   as System.IntPtr   no-undo.
    define variable vInt   as integer         no-undo.
    define variable ptrVal as int64           no-undo.
    define variable nBytes as "System.Byte[]".
     
    vInt = get-size(pmPtr).
    nBytes = new "System.Byte[]"(vInt).
    ptrVal = get-pointer-value(pmPtr).
    nPtr = new System.IntPtr(ptrVal).
    System.Runtime.InteropServices.Marshal:Copy(nPtr, nBytes, 0, vInt).
     
    return nBytes.
    
    finally:
      nPtr = ?.
      nBytes = ?.
    end.
  end method.

end class.