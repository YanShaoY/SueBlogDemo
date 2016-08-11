最近在学Unity3D，看到一个博主做了一个圆环， 博客链接如下：
http://blog.csdn.net/tab_space/article/details/51775163。
自动动手修改了点代码，并多画了两个进度条，比较拙劣，先分享在这里。

### 主要思路
1. 用一个UI对象Image，导入图片资源，然后设置以下属性.在脚本中，每帧刷新改变Fill Amont属性的值，可以看到进度条变化.

```
{ 
"ImageType" : "Filled", 
"FillMethod" : "Radial 360",
"FillOrigin" : "Top",
"Clockwise" : False
}
```

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1126909-5b6f0491c4004c29.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
	void Update () {
		
		if (currentAmout < targetProcess) {
			Debug.Log("currentAmount:" + currentAmout.ToString());
			// 改变Fill Amont属性的值
			currentAmout += speed;
			if(currentAmout > targetProcess)
				currentAmout = targetProcess;
			indicator.GetComponent<Text>().text = ((int)currentAmout).ToString() + "%";
			process.GetComponent<Image>().fillAmount = currentAmout/100.0f;
		}
		
	}
```

###效果

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1126909-45638dc7d5b47682.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

[Demo,包含Sketch的图片资源](https://github.com/sueLan/SueBlogDemo/tree/master/Unity/CircularProgressView)