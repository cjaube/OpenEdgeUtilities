
/*------------------------------------------------------------------------
    File        : Rounding.i
    Purpose     : Provide functions for rounding up and rounding down.

    Syntax      :

    Description : 

    Author(s)   : Curtis Aube
    Created     : Fri May 22 2020
    Notes       :
  ----------------------------------------------------------------------*/

function RoundUp returns decimal (expression as decimal, precision as int):
/*------------------------------------------------------------------------------
 Purpose: Round up to the specified number of decimal places returning a decimal value (Ceiling).
 @param expression A decimal expression that you want to round up.
 @param precision A non-negative integer expression that indicates the number of decimal places for the round up expression.
 @return A rounded decimal.
------------------------------------------------------------------------------*/
  if precision < 0 then undo, throw new Progress.Lang.AppError("Negative precision not allowed in RoundUp function.",0).
  if expression < 0 then return truncate(expression, precision).
  if truncate(expression, precision) = expression then return expression.
  return truncate(expression + 1 / exp(10, precision), precision).
end function.

function RoundDown returns decimal (expression as decimal, precision as int):
/*------------------------------------------------------------------------------
 Purpose: Round down to the specified number of decimal places returning a decimal value (Floor).
 @param expression A decimal expression that you want to round down.
 @param precision A non-negative integer expression that indicates the number of decimal places for the round down expression.
 @return A rounded decimal.
------------------------------------------------------------------------------*/
  if precision < 0 then undo, throw new Progress.Lang.AppError("Negative precision not allowed in RoundDown function.",0).
  if expression < 0 then do:
    if truncate(expression, precision) = expression then return expression.
    return truncate(expression - 1 / exp(10, precision), precision).
  end.
  return truncate(expression, precision).
end function.