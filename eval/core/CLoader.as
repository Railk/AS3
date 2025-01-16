/**
 * Eval
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.eval.core
{
	import flash.utils.ByteArray;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import railk.as3.eval.asm.Output;
	import railk.as3.event.CustomEvent;
	
	public class CLoader extends EventDispatcher
	{
		static public const ON_CLOADER_COMPLETE:String = 'onCLoaderComplete';
		
		private var className:String;
		
		public static function getInstance():CLoader
		{
			return Singleton.getInstance(CLoader);
		}
				
		public function CLoader() { Singleton.assertSingle(CLoader); }
		
		
		public function load( bytes:ByteArray, classeName:String ):void
		{
			this.className = classeName;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, manageEvent );
			loader.loadBytes( bytes, new LoaderContext( false, new ApplicationDomain( ApplicationDomain.currentDomain ) ) );
		}	
		
		private function manageEvent( evt:Event ):void
		{
			var classe:Class = ( ( evt.target as LoaderInfo ).applicationDomain.getDefinition( className ) as Class );
			dispatchEvent( new CustomEvent( ON_CLOADER_COMPLETE, {classe:classe} ) );
		}
	}
}