load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "./boxmodel.ncl"

;Demo box model

wks  = gsn_open_wks("png","demo2")  

x = fspan(0,10,20)
y = sin(x)

;Initialize the boxmodel
boxres=initbox()

;Change boxmodel setting if necessary 
boxres@boxScale=0.7
boxres@margin_top=0.07
boxres@margin_left=0.07
boxres@margin_bottom=0
boxres@margin_right=0

;new box
abc=(/"a","b","c","d","e","f","g","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"/)

do i=0,11

  if (mod(i,4).eq.0) then
    boxres@margin_left=0.07
    boxres@skip_tmYLLabel=False
  else
    boxres@margin_left=0.03
    boxres@skip_tmYLLabel=True
  end if 
  if (i.gt.7) then
    boxres@skip_tmXBLabel=False
  else
    boxres@skip_tmXBLabel=True
  end if 
  opt=newbox(0.2,0.2,boxres)
  opt@gsnLeftString="("+abc(i)+") Plot #"+i
  plot=gsn_csm_xy(wks,x,y,opt)

end do

frame(wks)
