/**
* 
* IDE Preloader
* 
* @author RICHARD RODNEY
* 
* USAGE
* 
* Need 2 frame on the timeline :
* 
* 	frame 1 : Empty, it's for prelaod
* 	frame 2 : Class exported on this frame in settings + an instance of the "main" class put on the Stage with no reference name.
* 
* main class :
* 
* 	public function main():void{
* 		your different actions
* 		for acces to root or stage use mainLoader.info.root/mainLoader.info.stage
* 	}
* 
* you can extends this class and override  fucntions to change the loading bar aspect
* 
*/

package railk.as3.net.preloader 
{
	import flash.display.MovieClip;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import railk.as3.TopLevel;
	import railk.as3.display.UISprite;
	import railk.as3.ui.loading.*;
	import railk.as3.display.graphicShape.*;
	
	public class IDEPreloader extends MovieClip
	{
		private var container  :UISprite;
		private var foreground :UISprite;
		private var background :UISprite;
		private var masker     :UISprite;
		private var loading    :RectLoading
		
		
		/**
		 * CONSTRUCTEUR
		 */
		public function IDEPreloader():void {
			super();
			init();
		}
		
		/**
		 * INIT
		 */
		private function init():void {
			//--
			stop();
			TopLevel.root = root;
			TopLevel.stage = stage;
			TopLevel.main = this;
			
			//--stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener( Event.ACTIVATE, manageEvent, false, 0, true );
			stage.addEventListener( Event.RESIZE, manageEvent, false, 0, true );
			
			//--create loading bar
			container = new UISprite();
			this.addChild( container );
			
				background =  createBackground();
				container.addChild( background );
				
				loading = createLoading();
				container.addChild( loading );
				loading.x2 = Math.round(container.width*.5);
				loading.y2 = Math.round(container.height*.5);
				
				masker = createMask();
				container.addChild( masker );
				masker.x2 = Math.round(container.width*.5);
				masker.y2 = Math.round(container.height*.5);
				loading.mask = masker;
				
				foreground = createForeground();
				container.addChild( foreground );
				foreground.x2 = Math.round(container.width*.5);
				foreground.y2 = Math.round(container.height*.5);
			
			container.x2 = stage.stageWidth*.5;
			container.y2 = stage.stageHeight*.5;	
			
			if ( this.loaderInfo.bytesLoaded == this.loaderInfo.bytesTotal ){
				loading.percent = 100;
				launch();
			} else {
				this.loaderInfo.addEventListener( ProgressEvent.PROGRESS, manageEvent, false, 0, true );
				this.loaderInfo.addEventListener( Event.COMPLETE, manageEvent, false, 0, true  );
			}
		}
		
		/**
		 * CREATE BACKGROUND
		 * @return
		 */
		protected function createBackground():UISprite { return new UISprite(); }
		
		/**
		 * CREATE FOREGROUND
		 * @return
		 */
		protected function createForeground():UISprite { return new UISprite(); }
		
		/**
		 * CREATE MASK
		 * @return
		 */
		protected function createMask():UISprite {
			var s:UISprite= new UISprite();
			var m:RectangleShape = new RectangleShape(0xFF0000,0,0,200,6);
			s.addChild( m );
			return s;
		}
		
		/**
		 * CREATE LOADING
		 * @return
		 */
		protected function createLoading():ILoading { return new RectLoading(0xFFFFFF,0x111111,0,0,200,6);	}	
		
		/**
		 * DESTROY
		 */
		private function dispose():void {
			this.loaderInfo.removeEventListener( ProgressEvent.PROGRESS, manageEvent);
			this.loaderInfo.removeEventListener( Event.COMPLETE, manageEvent);
			stage.removeEventListener( Event.RESIZE, manageEvent );
			stage.removeEventListener( Event.ACTIVATE, manageEvent );
			container.removeChild( loading );
			this.removeChild( container );
		}
		
		/**
		 * LAUNCH
		 */
		private function launch():void {	
			dispose();
			gotoAndStop(2);
			trace("                                    Preloader done");
			trace("---------------------------------------------------------------------------------------");
		}
		
		/**
		 * MANAGE EVENT
		 * @param	evt
		 */
		private function manageEvent( evt:* ):void {
			switch( evt.type ) {
				case Event.RESIZE : case Event.ACTIVATE:
					container.x2 = Math.round(stage.stageWidth*.5);
					container.y2 = Math.round(stage.stageHeight*.5);
					break;
				
				case ProgressEvent.PROGRESS :
					var percent:Number = Math.round((evt.bytesLoaded / evt.bytesTotal )*100 );
					loading.percent = percent;
					break;
				
				case Event.COMPLETE :
					launch();
					break;
					
				default : break;
			}
		}
	}
}