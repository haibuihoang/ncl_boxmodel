load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "./boxmodel.ncl"

;Demo box model

wks  = gsn_open_wks("png","demo1")  

drawNDCGrid(wks);
opt=True
opt@txFontHeightF = 0.030                     
gsn_text_ndc(wks,"Test subplots",0.5,0.95,opt)

x = fspan(0,10,20)
y = sin(x)


;Initialize the boxmodel
boxres=initbox()

;Change boxmodel setting if necessary 
boxres@boxScale=0.7
boxres@margin_top=0.1
boxres@margin_left=0.1

;new box
opt=newbox(0.8,0.3,boxres)
opt@gsnLeftString="(a) First plot"
plot=gsn_csm_xy(wks,x,y,opt)


boxres@margin_top=0.05

opt=newbox(0.35,0.3,boxres)
data= new((/20,20/),float)
do i=0,19
  do j=0,19
    data(j,i) = cos(x(i)) + sin(x(j))
  end do
end do

gsn_define_colormap(wks,"BlueWhiteOrangeRed")

opt@cnFillOn=True
opt@gsnLeftString = "(b) Second plot"
plot=gsn_csm_contour(wks,data,opt)
;we can add marker here easily
polyres               = True          ; poly marker mods desired 
polyres@gsMarkerIndex = 16            ; choose circle as polymarker
polyres@gsMarkerSizeF = 5.0           ; select size to avoid streaking
polyres@gsMarkerColor = (/"white"/)   ; choose color
gsn_polymarker(wks,plot,(/6.,12./),(/9.,15./),polyres)

;We can use a different color map
boxres@margin_left=0.05
opt=newbox(0.35,0.3,boxres)
opt@cnFillPalette        = "WhiteBlueGreenYellowRed" ;
;gsn_define_colormap(wks,"GMT_ocean")   ;or we can do this also
opt@gsnLeftString = "(c) Third plot"
plot=gsn_csm_contour(wks,data,opt)


frame(wks)



