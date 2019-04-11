
undef("initbox")
function initbox()
begin
 res=True
 res@yMin=1.
 res@xMax=0.
 res@margin_top=0.05
 res@margin_right=0.05
 res@margin_bottom=0.05
 res@margin_left=0.05
 res@xLeft=0.   ;coordinate of the supposed bounding box
 res@xRight=0.
 res@yTop=1.
 res@yBottom=1.

 res@boxScale=1. ;with the vp of different sizes, 
                      ;the tickmark length & font should be the same
                      ;boxScale=1. according to the original viewport=0.6,
                      ;boxScale<1. is recommended for smaller subplots
                      ;boxScale also affect the Left, right middle string


 return res
end

;-------------------------
undef("resetbox")
procedure resetbox(res)
begin
  res@yMin=1.
  res@xMax=0.
  res@xLeft=0.   ;coordinate of the supposed bounding box
  res@xRight=0.
  res@yTop=1.
  res@yBottom=1.
  return 1
end

;------------------
;Return the box pointer to the next row
undref("returnbox")
procedure returnbox(boxres)
begin
  boxres@xLeft=0.
  boxres@xRight=0.
  boxres@yTop = boxres@yBottom
  boxres@yBottom =  boxres@yBottom
end
;-----------
undef("newbox")
function newbox(width,height,boxres)
begin
  bbwidth=width + boxres@margin_left +  boxres@margin_right
  bbheight=height + boxres@margin_top +  boxres@margin_bottom

  left = boxres@xRight
  right = left + bbwidth
  top = boxres@yTop
  bottom = top - bbheight

  if (right.gt.1) then   ;over flow
     left=0.
     right = left + bbwidth
     top = boxres@yMin
     bottom = top - bbheight
  end if


  if (bottom.lt.boxres@yMin) then
     boxres@yMin = bottom
  end if


  ;Save the current coordinate
  boxres@xRight=right
  boxres@xLeft=left
  boxres@yTop = top
  boxres@yBottom = bottom

  ;Return the res for drawing chart
  res=True
  res@vpXF = left + boxres@margin_left
  res@vpYF = top - boxres@margin_top
  res@vpWidthF = width
  res@vpHeightF = height
  res@gsnFrame=False

  ;Set tickmark resources
  res@tmXBLabelFontHeightF = 0.02*boxres@boxScale
  res@tmXBMajorLengthF     = 0.02*boxres@boxScale
  res@tmYLMinorLengthF     = 0.01*boxres@boxScale
  res@tmXTLabelFontHeightF = 0.02*boxres@boxScale
  res@tmXTMajorLengthF     = 0.02*boxres@boxScale
  res@tmXTMinorLengthF     = 0.01*boxres@boxScale
  res@tmYLLabelFontHeightF = 0.02*boxres@boxScale
  res@tmYLMajorLengthF     = 0.02*boxres@boxScale
  res@tmYLMinorLengthF     = 0.01*boxres@boxScale
  res@tmYRLabelFontHeightF = 0.02*boxres@boxScale
  res@tmYRMajorLengthF     = 0.02*boxres@boxScale
  res@tmYRMinorLengthF     = 0.01*boxres@boxScale
  ;left/middle/right title option
  res@gsnLeftStringFontHeightF = 0.03*boxres@boxScale
  res@gsnRightStringFontHeightF = 0.03*boxres@boxScale
  res@gsnCenterStringFontHeightF = 0.03*boxres@boxScale
  ;Color label
  res@lbLabelFontHeightF = 0.02*boxres@boxScale

  if (isatt(boxres,"skip_tmYLLabel")) then
     if (boxres@skip_tmYLLabel) then
       res@tmYLLabelFontHeightF = 0
     end if
  end if
  if (isatt(boxres,"skip_tmXBLabel")) then
     if (boxres@skip_tmXBLabel) then
       res@tmXBLabelFontHeightF = 0
     end if
  end if

  return res
end

     

