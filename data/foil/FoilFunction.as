/**
 * foil serializer/deserializer
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.data.foil
{
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.display.LoaderInfo;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import railk.as3.event.CustomEvent;
	import railk.as3.eval.core.Parser;
	import railk.as3.eval.core.CLoader;
	import railk.as3.eval.core.Compiler;
	import railk.as3.eval.utils.ParsedObject;
	
	public class FoilFunction
	{
		private var _data:Function;
		
		public function FoilFunction( data:String )
		{
			var parsed:ParsedObject = Parser.getInstance().parse( data, 'function' );
			var bytes:ByteArray = Compiler.getInstance().compile( parsed.data );
			var cloader:CLoader = CLoader.getInstance().load( bytes, parsed.className );
			cloader.addEventListener( CLoader.ON_CLOADER_COMPLETE, manageEvent, false, 0, true );
		}
		
		private function manageEvent( evt:CustomEvent ):void
		{
			_data = evt.classe.execute;
		}
		
		public function get data():Function { return _data; }
	}
	
}