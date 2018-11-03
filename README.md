# AG3line:Active Grouping and Geometry-Gradient Combined Validation for Line Segment Extraction

## Introduction
This is the implementation of the proposed line segment detector named AG3line: "Active Grouping and Geometry-Gradient Combined Validation for Line Segment Extraction". The extraction result will be shown in figure after running the code in 'AG3lineDemo.m', and the only parameter in the code is the name of picture to be used in folder "pic". The folder "pic" contains 13 images for experiment, and about 100 images can be found on the [website](http://www.elderlab.yorku.ca/resources/york-urban-line-segment-database-information/), the York Urban database. Also, the experimental results of AG3line, [LSD](http://www.ipol.im/pub/art/2012/gjmr-lsd/), [Linelet](https://github.com/NamgyuCho/Linelet-code-and-YorkUrban-LineSegment-DB) and [EDLines](http://ceng.anadolu.edu.tr/cv/EDLines/) on the York Urban database are saved in folder "YorkUrbanRes", and the comparing of the extraction result can be plotted by the code in "comparedraw.m".  
Since this is the experimental vision coded by MATLAB, the running speed remains to be improved. It takes about 10-20 seconds to deal with the image in size of 640 x 480, and the image over 1000 in width or height is not recommended in experiment since it may take a long time. Good luck!
## Some results
Some experimental results are listed below, and they can be magnified or downloaded. In addition, the results of other 100 images in York Urban databse are saved in "YorkUrbanRes" and they can be ploted by the code in "comparedraw.m".  

| image | PPHT | LSD | EDLines |Linelet | MCMLSD | AG3line |
| ---- | ---- |---- |---- |---- |---- |---- |
|![](pic/testimg/010.png "005") |![](pic/result/tower1-ppht.png "005")|![](pic/result/tower1-LSD.jpg "005")|![](pic/result/tower1-EDLines.jpg "005")|![](pic/result/tower1-Linelet.jpg "005")|![](pic/result/tower1-MCMLSD.jpg "005")|![](pic/result/tower1-AG3line.jpg "005")|



