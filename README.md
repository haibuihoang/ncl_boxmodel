# NCL_Boxmodel
Some NCL functions to handle &amp; compose subplots easier and more flexible than gsn_panel

This script is inspired by CSS boxmodel and my gradscript implementation [Higrads](https://github.com/haibuihoang/higrads). Thanks to NCL's attributes, the implementation is simple compared to higrads. 

## Concepts
Bacically, each subplot is consider a box that contain the chart (viewport). There are for margin (top, right, bottom, left) from the chart to the box's boundary. Once we have the chart's dimension and all the margin, we can lay one box by each other to compose the whole plot.

## Tutorial
First you need to intialise **boxmodel** resource by calling ```initbox()```

```ncl
boxres=initbox()
```

In this case, ```boxres``` will hold the information needed for the box. We can change some attribute of its attribute, some important attribute ares:
* ```boxres@boxScale```: Determine the size of all the font size and tickmarks size, etc... (default: 1)
* ```boxres@margin_top```, also, ```margin_right```, ```margin_bottom```, ```margin_left```: the margin of the box, in NDC unit (default: 0.05)

After that, you call a new box with the chart width and height (in NDC unit), for example:

```opt=newbox(0.8,0.3,boxres)```

```opt``` is the resource which is needed for NCL plot scripts, for example:

```plot=gsn_csm_xy(wks,x,y,opt)```


## Examples
### Demo1
![Demo1](https://raw.githubusercontent.com/haibuihoang/ncl_boxmodel/master/demo1.png)

### Demo2
![Demo2](https://raw.githubusercontent.com/haibuihoang/ncl_boxmodel/master/demo2.png)





