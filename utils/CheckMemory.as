/**
* 
* checkMemory
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.utils {
	
	import flash.display.Sprite;
	import flash.system.System;
	import flash.events.Event;
	import flash.text.TextField;
	
	
	public class CheckMemory extends Sprite 
	{	
		// ___________________________________________________________________________________VARIABLES MEMORY
		private static var _txt                                   :TextField;
		private static var eventTrigger                           :Sprite;
		private var memory                                        :String;
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function CheckMemory():void {
			trace( "CheckMemory Activated" );
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   CHECKMEMORY GESTION
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public static function start( txt:TextField ):void {
			_txt = txt;
			eventTrigger = new Sprite();
			eventTrigger.addEventListener( Event.ENTER_FRAME, onEnterFrame, false, 0, true );
		}
		
		public static function stop():void {
			eventTrigger.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
			eventTrigger = null;
		}
		
		private static function onEnterFrame( evt:Event ):void {
			_txt.appendText( "" );
			_txt.text = "totalMemory used "+Number( System.totalMemory / 1024 / 1024 ).toFixed( 2 ) + "Mb";
		}
	}
}