/**
 * Eval
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.eval.core
{
	import railk.as3.pattern.singleton.Singleton;
	import railk.as3.eval.utils.ParsedObject;
	
	public class Parser
	{
		public static function getInstance():Parser
		{
			return Singleton.getInstance(Parser);
		}
		
		public function Parser() { Singleton.assertSingle(Parser); }
		
		
		public function parse( data:String, type:String ):ParsedObject
		{
			var result:ParsedObject;
			switch( type )
			{
				case 'function' :
					result
					break;
				
				case 'class' :
					break;	
			}
			return result;
		}
		
		private function parseFunction(data):ParsedObject
		{
			
		}
		
		private function parseClass(data):ParsedObject
		{
			
		}
	}
}