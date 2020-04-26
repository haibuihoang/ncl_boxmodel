
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

 res@tmInward = False ; inward tickmarks 
 res@direction= "l2r" ; "l2r" or "t2b"
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
undef("returnbox")
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

  if (boxres@direction.eq."l2r") ;-----left to right
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
  else ;-----top to bottom
   top = boxres@yBottom
   bottom = top - bbheight
   left = boxres@xLeft
   right = left + bbwidth
   if (bottom.lt.0) 
     top = 1
     bottom = top - bbheight
     left = boxres@xMax
     right = left + bbwidth
   end if
   if (right.gt.boxres@xMax) then
     boxres@xMax = right
   end if
   ;Save the current coordinate
   boxres@xRight=right
   boxres@xLeft=left
   boxres@yTop = top
   boxres@yBottom = bottom
  end if

  ;Return the res for drawing chart
  res=True
  res@vpXF = left + boxres@margin_left
  res@vpYF = top - boxres@margin_top
  res@vpWidthF = width
  res@vpHeightF = height
  res@gsnFrame=False

  ;Set tickmark resources
  res@tmEqualizeXYSizes = True ; propagate tm to all axis
  res@tmXBLabelFontHeightF=0.018*boxres@boxScale
  res@tmXBMajorLengthF = 0.016*boxres@boxScale
  res@tmXBMinorLengthF = 0.008*boxres@boxScale
  if (boxres@tmInward)
    res@tmXBMajorOutwardLengthF = -res@tmXBMajorLengthF-0.015
    res@tmXBMinorOutwardLengthF = -res@tmXBMinorLengthF-0.01 
  else
    res@tmXBMajorOutwardLengthF = res@tmXBMajorLengthF+0.005
    res@tmXBMinorOutwardLengthF = res@tmXBMinorLengthF+0.001
  end if
  ;left/middle/right title option
  res@gsnLeftStringFontHeightF = 0.03*boxres@boxScale
  res@gsnRightStringFontHeightF = 0.03*boxres@boxScale
  res@gsnCenterStringFontHeightF = 0.03*boxres@boxScale
  ;Color label
  res@lbLabelFontHeightF = 0.02*boxres@boxScale 
  ;Axis title
  res@tiYAxisFontHeightF=0.025*boxres@boxScale
  res@tiXAxisFontHeightF=0.025*boxres@boxScale
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


;------Other ultils
;----------------
;0->a, 1->b...
undef ("abc")
function abc(idx)
begin
 alphabet="abcdefghijklmnopqrstuvwxyz"
 r="("+str_get_cols(alphabet,idx,idx)+")"
 return r
end

;---trim off color map in away the color is still symmetric for asymmetric contour levels
;cmapName is the input colormap,
;nneg,nnpos is the number of contour labels in negative & positive region
undef ("symm_colorpallete")
function symm_colorpallete(cmapName,nneg,npos)
local cmap, cmapin,dims, icut
begin
    cmapin = read_colormap_file(cmapName)
    dims=dimsizes(cmapin)
    mcols=dims(0)
    mcol2=tointeger(mcols/2)
    ncols=nneg+npos+1
    if (nneg.lt.npos)
       icut=mcol2 - tointeger(mcol2*nneg/npos) 
       cmap=cmapin(icut:,:)
       print(icut+":")
    else
       icut=mcol2 + tointeger(mcol2*npos/nneg)  
       cmap=cmapin(:icut,:)
       print(":"+icut)
    end if
return cmap
end

;--manually get cnFillColors from colorpallete and number of Colors
undef ("get_cnFillColors")
function get_cnFillColors(cmap,nCols)
local cmap,dims,i,im,cols
begin
  dims=dimsizes(cmap)
  mCols=dims(0)
  cols=new((/nCols,4/),"float")
  do i=0,nCols-1
    im = tointeger(i*(mCols-1)/(nCols-1))
    cols(i,:) = cmap(im,:)
  end do
return cols
end

;----Some toher utils
; Draw Unit on the right label bar 
undef("lbTitleR")
procedure lbTitleR(wks,boxres,title,fontsize,offsetX,offsetY)
begin
  x = boxres@xRight - boxres@margin_right + offsetX
  y = boxres@yTop - boxres@margin_top + offsetY
  res=True
  res@txFontHeightF=fontsize
  res@txJust = "bottomcenter"
  gsn_text_ndc(wks,title,x,y,res)
end
