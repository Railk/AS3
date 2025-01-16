/**
* 
* BOOTPreloader for FD project
* 
* @author RICHARD RODNEY
* @version 0.3
*/

package railk.as3.net.preloader 
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.utils.getDefinitionByName;	
	
	public class BOOTPreloader extends MovieClip
	{
		protected var loading:*;
		
		/**
		 * CONSTRUCTEUR
		 */
		public function BOOTPreloader() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * INIT
		 */
		private function init(evt:Event = null):void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener( Event.ACTIVATE, manageEvent, false, 0, true );
			stage.addEventListener( Event.RESIZE, manageEvent, false, 0, true );
			
			loading = createLoading();
			addChild( loading );

			if ( currentFrame == totalFrames ){
				loading.percent = 100;
				main();
			} else {
				loaderInfo.addEventListener( ProgressEvent.PROGRESS, manageEvent, false, 0, true );
				addEventListener(Event.ENTER_FRAME, loop);
			}
		}
		
		/**
		 * CREATE LOADING
		 */
		protected function createLoading():* {}
		protected function resize():void{}
		
		/**
		 * LOADING STATE LOOP
		 */
		private function loop(evt:Event):void {
			if (currentFrame == totalFrames) {
				dispose();
				main();
			}
		}
		
		/**
		 * START MAIN
		 */
		private function main():void {
			var mainClass:Class = getDefinitionByName('Main') as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
		/**
		 * DISPOSE
		 */
		private function dispose():void {
			stop();
			removeEventListener(Event.ENTER_FRAME, loop);
			loaderInfo.removeEventListener( ProgressEvent.PROGRESS, manageEvent);
			stage.removeEventListener( Event.RESIZE, manageEvent );
			stage.removeEventListener( Event.ACTIVATE, manageEvent );
			removeChild( loading );
		}
		
		/**
		 *MANAGE EVENT
		 */
		private function manageEvent(e:*):void {
			switch( e.type ) {
				case Event.RESIZE : case Event.ACTIVATE: resize(); break;
				case ProgressEvent.PROGRESS : loading.percent = Math.round((e.bytesLoaded / e.bytesTotal )*100 ); break;
				default : break;
			}
		}
	}
}