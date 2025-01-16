/**
 * 
 * Tween CallBack
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion.utils
{
	public class CallBack
	{
		public var pos:Number;
		public var onCallBack:Function;
		public var onCallBackParams:Array;
		
		public function CallBack( pos:Number=NaN,onCallBack:Function=null,onCallBackParams:Array=null) {
			this.pos = pos;
			this.onCallBack = onCallBack;
			this.onCallBackParams = onCallBackParams;
		}
		
		public function apply(...overrideParams):void {
			if(onCallBack!=null) onCallBack.apply(null,((overrideParams)?overrideParams:onCallBackParams));
		}
	}
}