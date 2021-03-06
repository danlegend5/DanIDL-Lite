PRO define_equal_bins, value1, value2, nbins, bin_limits, bin_size, status, NO_PAR_CHECK = no_par_check

; Description: This module defines the bin limits "bin_limits" for "nbins" bins of equal size between
;              the values "value1" and "value2".
;
; Input Parameters:
;
;   value1 - BYTE/INTEGER/LONG/FLOAT/DOUBLE - The value of the first limit for the range for which bins
;                                             are to be defined. This limit is usually the lower limit
;                                             for the range.
;   value2 - BYTE/INTEGER/LONG/FLOAT/DOUBLE - The value of the second limit for the range for which bins
;                                             are to be defined. This limit is usually the upper limit
;                                             for the range. The value of "value2" must not be equal to
;                                             the value of "value1".
;   nbins - INTEGER/LONG - The number of bins to be defined in the range between "value1" and "value2".
;                          This parameter must be positive.
;
; Output Parameters:
;
;   bin_limits - DOUBLE VECTOR - A one-dimensional vector of size "nbins + 1" with consecutive pairs
;                                of values representing the lower and upper limits of each bin.
;                                Specifically, the ith bin, with i running from "0" to "nbins - 1",
;                                corresponds to the range of values between bin_limits[i] and
;                                bin_limits[i+1], where bin_limits[i] < bin_limits[i+1], regardless
;                                of whether "value1" is greater than or less than "value2".
;   bin_size - DOUBLE - The size of each bin.
;   status - INTEGER - If the module successfully defined a set of bin limits, then "status" is
;                      returned with a value of "1", otherwise it is returned with a value of "0".
;
; Keywords:
;
;   If the keyword NO_PAR_CHECK is set (as "/NO_PAR_CHECK"), then the module will not perform parameter
;   checking on the input parameters, reducing module overheads.
;
; Author: Dan Bramich (dan.bramich@hotmail.co.uk)


;Set the default output parameter values
bin_limits = [0.0D]
bin_size = 0.0D
status = 0

;Perform parameter checking if not instructed otherwise
if ~keyword_set(no_par_check) then begin

  ;Check that "value1" and "value2" are numbers of the correct type
  if (test_bytintlonfltdbl_scalar(value1) NE 1) then return
  if (test_bytintlonfltdbl_scalar(value2) NE 1) then return

  ;Check that "nbins" is a positive number of the correct type
  if (test_intlon_scalar(nbins) NE 1) then return
  if (nbins LT 1) then return
endif
value1_use = double(value1)
value2_use = double(value2)
nbins_use = long(nbins)

;Check that "value1" and "value2" have sensible values
if (value2_use EQ value1_use) then return

;Create the vector of values defining the bin limits
val_lo = value1_use < value2_use
val_hi = value1_use > value2_use
if (val_lo EQ 0.0D) then begin
  bin_size = val_hi/nbins_use
  bin_limits = dindgen(nbins_use + 1L)*bin_size
endif else begin
  bin_size = (val_hi - val_lo)/nbins_use
  bin_limits = val_lo + (dindgen(nbins_use + 1L)*bin_size)
endelse

;Set "status" to "1"
status = 1

END
