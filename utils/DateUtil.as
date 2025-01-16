/**
* 
* Date Utils class
* 
* @author RICHARD RODNEY
* @version 0.3
*/


package railk.as3.utils {
	
	public class DateUtil 
	{	
		static public function date():String {
			var dayTab:Array = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"];
			var monthTab:Array = ["january", "february", "march", "april", "may", "june", "july" ,"august" ,"september", "october", "november", "december"];
			
			var time:Date = new Date();
			var timeStr:String =  String( dayTab[time.getDay()]+" "+zero(time.getDate())+"-"+monthTab[time.getMonth()]+"-"+time.fullYear+" "+zero(time.getHours()) +":"+ zero(time.getMinutes()) +":"+ zero(time.getSeconds()) );
			return timeStr;
		}
		
		static public function date_PHP():String {
			var d:Date = new Date();
			return String(zero(d.date)+'/'+ zero(d.month+1)+'/09');
		}
		
		static public function heure_PHP():String {
			var d:Date = new Date();
			return String(zero(d.hours)+ ':' + zero(d.minutes) + ':' + zero(d.seconds));
		}
		
		static public function numberToTime( value:Number, displayHours:Boolean ):String {
			var minutes:Number = Math.floor(value/ 60);
			if (displayHours) var hours:Number = Math.floor(minutes/60);
			var seconds:Number = Math.round(value-(minutes*60));
			return ((hours < 10)?"0" + String(hours):String(hours))+ ":" + ((minutes < 10)?"0" + String(minutes):String(minutes))+ ":" + ((seconds < 10)?"0"+String(seconds):String(seconds));
		}
		
		/**
		 * UTILITIES
		 */
		static public function zero( value:* ):String {
			if ( value >= 0 && value <= 9 ) return "0" + value;
			return String(value);
		}
	}	
}		