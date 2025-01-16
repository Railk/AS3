/**
  * A Sharpen Filter.
  * 
  * Example implementation:
  * <code>
  * var sf:SharpenFilter = new SharpenFilter( 65 );
  * target.filters = [ sf ];
  * </code>
  */

package railk.as3.display 
{
	
	import flash.filters.ConvolutionFilter;
	public class SharpenFilter extends ConvolutionFilter 
	{
		private var _amount:int;
		
		/**
		* @param p_amount Sharpen value
		*/
		public function SharpenFilter( p_amount:int=50 ) {
			super(3,3,[0,0,0,0,1,0,0,0,0],1);
			amount = p_amount;
		}  

		public function set amount( p_amount:int ):void {
			_amount = p_amount;
			var a:Number = p_amount/-100;
			var b:Number = a*(-8)+1;
			matrix = [a,a,a,a,b,a,a,a,a];
		}

		public function get amount():int { 
			return _amount; 
		}
	}
}