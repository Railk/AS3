/**
* google analytics xml parser class
* 
* @author richard rodney
* @version 0.2
*/

package railk.as3.data.parser 
{	
	public class GAXMLItem 
	{	
		public static function parse( xml:XML, type:String = 'GeoMap' ):Array {
			var nodes:Array = new Array();
			var nb_nodes:Number = xml.children()[0].children().length();
			var count:Number = 0;
			
			//création du tabelau contenant les informations xml triées
			for( var i:int=0; i<nb_nodes-1; i++ ) {
				if ( xml.children()[0].children()[i].name() == "Region" ) {
					var itr =  xml.children()[0].children()[i].children().length();
					var location:Object = new Object();
					
					for( var j:int=0; j<itr-1; j++ ){
						var temp = String( xml.children()[0].children()[i].children()[j].name() );
						location[String(temp)] = xml.children()[0].children()[i].children()[j];
					}
					
					nodes[count] = location;
					count += 1;
				}
			}
			return nodes;
		}
	}
}