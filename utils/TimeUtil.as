/**
* Time Utils class
* 
* @author RICHARD RODNEY
* @version 0.3
*/

package railk.as3.utils 
{
	public class TimeUtil 
	{
		/**
		 * FORMAT TIME
		 * @param	n
		 * @return
		 */
		public static function formatTime (n:Number):String {
			//reste
			var reste:Number;
			
			//hours
			var hours:int = int(n/3600);
			reste = n%3600;
			
			//minutes
			var minutes:int = int(reste*60);
			reste = (reste*60)-minutes;
			
			//seconds
			var seconds:int = int(reste*60);
			
			var hString:String = hours < 10 ? "0" + hours : "" + hours;	
			var mString:String = minutes < 10 ? "0" + minutes : "" + minutes;
			var sString:String = seconds < 10 ? "0" + seconds : "" + seconds;
			if ( hours > 0 ) return hString + ":" + mString + ":" + sString;
			return mString + ":" + sString;
		}
	}
}