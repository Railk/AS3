/**
 *  Noise({width:300, height:300, targetObj:new target_instance()})
 */

package railk.as3.effect.noise 
{	
	import flash.display.Sprite
	import flash.display.Bitmap;
	import flash.display.BitmapData
	import flash.events.Event;
	import flash.geom.Point
	import flash.geom.Rectangle
		
	public class Noise extends Sprite 
	{
		public var width			:Number;
		public var height			:Number;
		public var nbChannel		:Number = 3;
		public var level			:Number = 1;
		public var levelX			:Number = 200;
		public var levelY			:Number = 5;
		public var curveX			:Number = 3;
		
		private var target			:Sprite;
		private var video_noise		:Sprite;
		private var bitmap_noise	:Sprite;
		private var bmps            :Array = new Array(3);
		
		private var w				:Number = .20;
		private var v				:Number = 0;
		private var aX				:Array = new Array(Math.random() + 1, Math.random() + 1, Math.random() + 1);
		private var bX				:Array = new Array(0, 0, 0);
		private var p1				:Array = new Array(new Point(0, 0), new Point(0, 0), new Point(0, 0));
		private var p0				:Point = new Point(0, 0);
				
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	width
		 * @param	height
		 * @param	target
		 */
		public function Noise(width:Number, height:Number,target:Object ) {
			this.width = width;
			this.height = height;
			this.target = target;
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, dispose, false, 0, true);
		}
		
		/**
		 * INIT
		 */
		private function init(evt:Event):void {
			video_noise = new Sprite();
			bitmap_noise = new Sprite();
			video_noise.addChild(bitmap_noise);
			this.addChild(video_noise);
			bitmap_noise.addChild(target);
			bitmap_noise.mouseEnabled = false;
			stage.addEventListener(Event.RESIZE, resize, false, 0, true );
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			///////////////////////////////////
			createBitmap();
			resizeStage();
			///////////////////////////////////
		}
		
		/**
		 * MANAGE ACTIVATION
		 */
		public function start():void {
			this.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			for (var i:int = 1; i < nbChannel;i++ ) {
				var bm = bitmap_noise.getChildByName('bm' + i);
				bm.visible = true;
			}
		}
		public function pause():void {
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 * CREATE BITMAP
		 */
		private function createBitmap():void {
			bmps[0] = new BitmapData(width, height);
			bmps[1] = bmps[2] = bmps[0].clone();

			for (var i:int = 1; i < nbChannel; ++i ) {
				var bm:Bitmap = new Bitmap(bmps[i], 'auto', true);
				bm.name = 'bm'+i;
				bm.visible = false;
				bitmap_noise.addChild(bm);
			}
		}
		
		
		private function update(evt:Event):void {
			bmps[0].draw(target);
			bmps[1] = bmps[0].clone();
			
			var point:Number = nbChannel;
			while (point--){
				if (aX[point] >= 1){
					--aX[point];
					bX[point] = Math.random()/level;
				}
				aX[point] = aX[point] + bX[point];
				p1[point].x = Math.ceil(Math.sin(aX[point] * 6) * bX[point] * levelX/10) ;
			}
			var x = (Math.abs(p1[0].x) + Math.abs(p1[1].x) + Math.abs(p1[2].x)+10 ) / curveX;
			point = _height;
		  
			while (point--){
				var curve = Math.sin(point / height * (Math.random() / 8 + 1) * w * 6) * w * x * x;
				bmps[1].copyPixels(bmp0, new Rectangle(curve, point, width - curve, 1), new Point(0, point));
			} 
			
			if (x >2) w = Math.random() * 2;
			if (w < .8){
				var color = x * x * x * 2;
				bmps[1].merge(bmps[1], bmps[1].rect, p0, color, color, color, 0);
			}
			if (Math.random() < levelY/10) v = 10;
			if (v > 1000) v = 0;
			if (v > 0){
				v = v + 45;
				v = v % _height;
				var cloneBmp:BitmapData = bmps[1].clone(); 
				bmps[1].copyPixels(cloneBmp, new Rectangle(0, 0, width, v), new Point(0, height - v));
				bmps[1].copyPixels(cloneBmp, new Rectangle(0, v, width, height - v), new Point(0, 0));
			}
			bmps[2].copyChannel(bmps[1], bmps[1].rect, p1[0], 1, 1);
			bmps[2].copyChannel(bmps[1], bmps[1].rect, p1[1], 2, 2);
			bmps[2].copyChannel(bmps[1], bmps[1].rect, p1[2], 4, 4);
		}
		
		/**
		 * RESIZE
		 */
		private function resize(evt:Event=null):void {
			var dWidth:Number = stage.stageWidth / width;
			var dHeight:Number = stage.stageHeight /  height;
			var dScaleBack:Number = (dHeight>dWidth)?dHeight:dWidth;
			video_noise.scaleX = video_noise.scaleY = dScaleBack;
		}
		
		/**
		 * DISPOSE
		 */
		private function dispose(evt:Event):void {
			pause();
			for (var i:int = 0; i < bmps.length; ++i) bmps[i].dispose(); 
			this.removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
			stage.removeEventListener(Event.RESIZE, resizeStage);
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function get isPaused():Boolean { return this.hasEventListener(Event.ENTER_FRAME); }
	}
}