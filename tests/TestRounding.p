 
 /*------------------------------------------------------------------------
    File        : TestRounding.p 
    Syntax      : 
    Author(s)   : Curtis Aube
    Created     : Fri May 22 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.*.

block-level on error undo, throw. 

{Includes/Rounding.i}

@Test.
procedure Test_Rounding_RoundUp:
/*------------------------------------------------------------------------------
        Purpose: Test the RoundUp function
        Notes:                                                                        
------------------------------------------------------------------------------*/  

  Assert:Equals( 5   , RoundUp( 4.4536, 0)). // Round up
  Assert:Equals( 4.5 , RoundUp( 4.4536, 1)). // Precision of 1
  Assert:Equals( 4.46, RoundUp( 4.4536, 2)). // Precision of 2
  Assert:Equals(45.29, RoundUp(45.282 , 2)). // Round up when multiple digits
  Assert:Equals(10.00, RoundUp(9.999  , 2)). // Round up with carry
  Assert:Equals( 5.12, RoundUp( 5.12  , 2)). // Don't do anything when already rounded
  Assert:Equals(-4.32, RoundUp(-4.328 , 2)). // Round up negative numbers
  Assert:Equals(-5.12, RoundUp(-5.12  , 2)). // Don't do anything when already rounded
  RoundUp(7.467, -2) no-error.               // Invalid parameters
  AssertError:HasErrorStatus().
  RoundUp(-7.467, -2) no-error.              // Invalid parameters
  AssertError:HasErrorStatus().
end procedure.

@Test.
procedure Test_Rounding_RoundDown:
/*------------------------------------------------------------------------------
        Purpose: Test the RoundDown function
        Notes:                                                                        
------------------------------------------------------------------------------*/  

  Assert:Equals(  4   , RoundDown( 4.4689, 0)). // Round down
  Assert:Equals(  4.4 , RoundDown( 4.4689, 1)). // Precision of 1
  Assert:Equals(  4.46, RoundDown( 4.4689, 2)). // Precision of 2
  Assert:Equals( 45.28, RoundDown(45.288 , 2)). // Round down when multiple digits
  Assert:Equals(  5.12, RoundDown( 5.12  , 2)). // Don't do anything when already rounded
  Assert:Equals( -4.33, RoundDown(-4.322 , 2)). // Round down negative numbers
  Assert:Equals(-10.00, RoundDown(-9.999 , 2)). // Round down negative with carry
  Assert:Equals( -5.12, RoundDown(-5.12  , 2)). // Don't do anything when already rounded
  RoundDown(7.467, -2) no-error.                // Invalid parameters
  AssertError:HasErrorStatus().
  RoundDown(-7.467, -2) no-error.               // Invalid parameters
  AssertError:HasErrorStatus().
end procedure.