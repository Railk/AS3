/**
 * 
 * Prop
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion.utils 
{	
	public class Prop 
	{
		public var prev:Prop;
		public var type:String;
		public var prop:String;
		public var current:*, start:*, end:*;
		public var sNum:Number, eNum:Number;
		
		public function Prop( type:String, prop:String, start:*, end:*, rotation:Boolean=false) {
			this.type = type;
			this.prop = prop;
			this.start = sNum = current =(rotation)?(start%360+((Math.abs(start%360-end%360)<180)?0:(start%360>end%360)?-360:360)):start;
			if (end is Number) this.end = eNum = (rotation)?end % 360:end;
			else this.end = end;
		}
		
		public function dispose():void { prev = null; current = start = end = null; }
	}
}