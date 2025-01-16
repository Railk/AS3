/**
* 
* Maps, gestion de l'affichage d'une carte de type mercator
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.maps.map2D {
	

	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.stage.StageManager;
	import railk.as3.display.DSprite;
	

	
	public class Map2D extends Sprite {
		
		
		// ________________________________________________________________________________________ VARIABLES
		private var conteneur                   :DSprite;
		
		// _________________________________________________________________________________ VARIABLES MARKER
		private var markers                     :Marker2D;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	texture class de l'objet
		 */
		public function Map2D( texture:*, alpha:Number=1 ):void {
			conteneur = new DSprite();
			conteneur.name = "map";
				
				var carte = new texture();
				carte.alpha = alpha;
				conteneur.addChild( carte );
				
			addChild( conteneur );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				       SET 2D MARKERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	locations  array of objects { nom:nom, value:valeur, Lat:latitude, Lng:longitude }
		 */
		public function setMarkers( locations:Array ):void {
			
			for ( var i:int = 0; i <= locations.length - 1; i++ ) {
				if( locations[i].Name != "(not set)" ){
					marker = new Marker2D( locations[i].Name, locations[i], conteneur );
					conteneur.addChild( marker );
				}	
			}
			
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			  DESTROY MAP AND MARKERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function destroy():void {
			conteneur = null;
		}
		
	}
}