/* ***********************************************************************
Flash CS4 tutorial by Barbara Kaskosz

http://www.flashandmath.com/

Last modified: July 5, 2009
************************************************************************ */

package flashandmath.as3 {
	
	import flash.display.Sprite;
	
	import flash.display.Bitmap;
	
	import flash.display.BitmapData;	
	
	import flash.display.Loader;	
	
	import flash.events.ProgressEvent;
	
	import flash.events.Event;
	
	import flash.events.IOErrorEvent;
	
	import flash.text.TextField;
	
	import flash.text.TextFormat;
	
	import flash.text.TextFieldType;
	
	import flash.net.URLRequest;
	
	import flash.geom.Matrix;
	
	
    public  class Kaleidoscope extends Sprite {
		 
	    private var imageData:BitmapData;
		
		private var loader:Loader;
		
		private var infoBox:TextField;
		
		private var picWidth:Number;
		
		private var picHeight:Number;
		
		private var rad:Number;
		
		private var ang:Number;
		
		private var radAng:Number;
		
		private var numWedges:int;
		
		private var wedgeHeight:Number;
		
		private var sideLen:Number;
		
		private var wedgesVec:Vector.<Sprite>;
		
		private var isReady:Boolean;
		
		/*
		The constructor takes two parameters plus one optional parameter. The first
		parameter is a string with the URL pointing to the image file on your server. 
		That image file will provide BimapData for your instance of Kaleidoscope. 
		The image file will be loaded at runtime. The second parameter is the radius, in pixels, 
		of your instance. The last, optional, parameter sets the number of wedges 
		in your Kaleidoscope. The default value: 20.
		*/
		  
	    public function Kaleidoscope(url:String,r:Number,n:Number=20){
			
			rad=r;

            numWedges=n;

            ang=360/numWedges;

            radAng=ang*Math.PI/180;

            sideLen=2*rad*Math.sin(radAng/2);

            wedgeHeight=sideLen/(2*Math.tan(radAng/2));
			
			isReady=false;
			
			setUpLoadBox();

            loadImg(url);
		}
		
		//End of constructor.
		
		//The private, loadImg, method uses an instance of the Loader class to load
		//at runtime the image file passed to the constructor. The loading progress
		//is displayed in infoBox text field.
		
	private function loadImg(s:String):void {
	
	       loader=new Loader();
	
	       loader.load(new URLRequest(s));
	
           infoBox.text="Start loading...";

           loader.contentLoaderInfo.addEventListener(Event.COMPLETE,initApp);
	
	       loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,updateInfo);
		   
		   loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorOccured);
	
   }
   
   private function errorOccured(e:IOErrorEvent):void {
		
		infoBox.text="There has been an error loading the image. Try refreshing the page.";
		
		loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,initApp);
	 
	    loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,updateInfo);
	   
	    loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorOccured);
		
		loader=null;
	
	}

    private function updateInfo(e:ProgressEvent):void {
	
	    infoBox.text="Loading: "+String(Math.floor(e.bytesLoaded/1024))+" KB of "+String(Math.floor(e.bytesTotal/1024))+" KB.";
	
   }
   
   //Upon successful completion of loading, the application is initiated. 


  private function initApp(e:Event):void {
	 
	   imageData=Bitmap(loader.content).bitmapData;
	 
	   picWidth=imageData.width;
	 
	   picHeight=imageData.height;
	 
	   loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,initApp);
	 
	   loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,updateInfo);
	   
	   loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorOccured);
	 
	   loader=null;
	
	   infoBox.text="";
	
	   infoBox.visible=false;
	   
	   wedgesVec=new Vector.<Sprite>();
	 
	   createWedges();

       drawWedges();
	 
	   isReady=true;
	 
  }
  
  /*
  The private method, createWedges, creates wedges of the Kaleidoscope
  and stores them in a Vector, wedgesVec. The drawWedges method creates
  a bitmap fill in the first wedge and copies it to other wedges.
  */
  

  private function createWedges():void {
	
	 var i:int;
	
	 for(i=0;i<numWedges;i++){
		
		wedgesVec[i]=new Sprite();
		
		this.addChild(wedgesVec[i]);
		
		wedgesVec[i].rotation=i*ang;
		
	 }
		
 }


 private function drawWedges():void {
	
	var i:int;
	
	var mat:Matrix=new Matrix();
	
	mat.translate(picWidth/2,picHeight/2);
	
	mat.rotate(Math.random()*2*Math.PI);
	
	mat.scale(Math.random()*0.5+0.5,Math.random()*0.5+0.5);
	
	for(i=0;i<numWedges;i++){
		
		wedgesVec[i].graphics.clear();
		
	}
	
	//We fill the first wedge using BitmapData of our image. The 'beginBitmapFill'
	//call uses a matrix, mat, that conatins random parameters. This will cause the image
	//to be different each time the method is called. By default, beginBitmapFill is set
	//to 'repeat'. That means that if you image is small, it will simply be repeated.
	
	wedgesVec[0].graphics.lineStyle();
	
	wedgesVec[0].graphics.beginBitmapFill(imageData,mat);
	
	wedgesVec[0].graphics.moveTo(0,0);
	
	wedgesVec[0].graphics.lineTo(-sideLen/2,-wedgeHeight);
	
	wedgesVec[0].graphics.lineTo(sideLen/2,-wedgeHeight);
	
	wedgesVec[0].graphics.lineTo(0,0);
	
	wedgesVec[0].graphics.endFill();
	
	//Below we use the method 'copyFrom' of the Graphics class to copy the fill
	//from the first wedge to all other wedges. The method copyFrom is new to FP10.
	//It copies all drawings created via the Graphics' class commands 
	//from one DisplayObject to another.
	
	for(i=1;i<numWedges;i++){
		
		wedgesVec[i].graphics.copyFrom(wedgesVec[0].graphics);
		
	}
	
}

   private function setUpLoadBox():void {
	
	    var infoFormat:TextFormat=new TextFormat();
		
		infoBox=new TextField();
			
		this.addChild(infoBox);
			
		infoBox.x=-rad/2;

        infoBox.y=-rad/2;
		
		infoBox.type=TextFieldType.DYNAMIC;
		
		infoBox.width=1.5*rad;
		
		infoBox.height=1.5*rad;
		
		infoBox.wordWrap=true;
		
		infoBox.border=false;
				
		infoBox.background=false;

        infoBox.mouseEnabled=false;
		
		infoFormat.color=0xCC0000;

        infoFormat.size=14;

        infoFormat.font="Arial";

        infoBox.defaultTextFormat=infoFormat;

     }
	 
	 /*
	 The public 'doSpin' method redraws the wedges by calling 'drawWedges' method 
	 (provided the image finished loading at which time 'isReady' is set to 'true').
	 Since the matrix of the BitmapFill in 'drawWedges' contains random parameters,
	 the image will change each time the method is called.
	 */
	 
	public function doSpin():void {
	 
	 if(isReady){
	
	   drawWedges();
	
	 }
  }
  
  //You should call 'destroy' method if you wish to dispose of your instance 
  //of Keleidoscope at runtime.
  
  public function destroy():void {
	  
	  var i:int;
	  
	  for(i=0;i<numWedges;i++){
		  
		  if(wedgesVec[i]!=null){
		
		    wedgesVec[i].graphics.clear();
			
			wedgesVec[i]=null;
		
		  }
		
	   }
	   
	   if(imageData!=null){
	
	      imageData.dispose();
	  
	    }
	
	 if(infoBox!=null){
	
	    infoBox=null;
	  
	 }
	  
	  
  }
  
			
 }
 
}