/**
 * Eval
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.eval.core
{
	import flash.utils.ByteArray;
	
	import railk.as3.eval.asm.Context;
	import railk.as3.eval.asm.Output;
	import railk.as3.eval.asm.Writer;
	import railk.as3.eval.asm.Index;
	import railk.as3.eval.utils.Data;
	
	public class Compiler
	{
		private var context:Context;
		private var stack:int = 0;
		
		public static function getInstance():Compiler
		{
			return Singleton.getInstance(Compiler);
		}
		
		public function Compiler() { Singleton.assertSingle(Compiler); }
		
		
		public function compile( data:Data ):ByteArray
		{
			context = new Context();
			context.beginClass( className );
			var m = context.beginMethod("test", [intType], anyType);
		
			
			context.defineField( 'x', intType );
			context.defineField( 'y', intType );
			context.defineField( 'model', anyType );
			
			m.maxStack = 3;
			context.finalize();
			
			var output:Output = new Output();
			Writer.write( output, context );			
			return output.getBytes();
		}
		
		public function types( data:Array ):void
		{
			var intType:Index = context.type('int');
			var anyType:Index = context.type('*');
		}
		
		public function fields( data:Array ):void
		{
			
		}
		
		public function ops( data:Array ):void
		{
			context.ops([
						 OpCode.OReg(1),
						 OpCode.OInt(2),
						 OpCode.OOp(Operation.OpAdd),
						 OpCode.OInt(5),
						 OpCode.OOp(Operation.OpMul),
						 OpCode.ORet,
						]);
		}
		
	}
}