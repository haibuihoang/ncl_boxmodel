# NCL_Boxmodel
NCL_Boxmodel contains some NCL functions to handle &amp; compose subplots easier and more flexible than gsn_panel

This script is inspired by CSS boxmodel and my gradscript implementation [Higrads](https://github.com/haibuihoang/higrads). Thanks to NCL's attributes, the implementation is simple compared to Higrads. 

## Concepts
Bacically, each subplot is consider a box that contains the a chart (the actually drawing area, or viewport). There are for margins (top, right, bottom, left) around chart to the box's boundaries. Once we have the chart's dimension and all the margins, we can lay one box by each other to compose the whole plot.

## Tutorial
First you need to intialise **boxmodel** resource by calling ```initbox()```

```ncl
boxres=initbox()
```

The return resource ```boxres``` holds the information needed for the box. We can change some of its attribute as needed:
* ```boxres@boxScale```: Determine the size of all the font size and tickmarks size, etc... (default: 1)
* ```boxres@margin_top```, also, ```margin_right```, ```margin_bottom```, ```margin_left```: the margin of the box, in NDC unit (default: 0.05)

After that, you call ```newbox(width, height, boxres)``` to get the resource for the NCL ploting functions. ```width``` and ```height``` are the dimension of the chart area (in NDC unit). For example:

```opt=newbox(0.8,0.3,boxres)```

After that, we use ```opt``` for a NCL plot scripts, for example:

```plot=gsn_csm_xy(wks,x,y,opt)```


## Examples
### Demo1
![Demo1](https://raw.githubusercontent.com/haibuihoang/ncl_boxmodel/master/demo1.png)

### Demo2
![Demo2](https://raw.githubusercontent.com/haibuihoang/ncl_boxmodel/master/demo2.png)





