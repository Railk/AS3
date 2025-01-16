/**
* 
* Marker, gestion de l'affichage de marker sur une carte de type Map
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.maps.map2D {
	

	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.display.GraphicShape;
	import railk.as3.display.DSprite;
	
	// ______________________________________________________________________________________ IMPORT FOXAWEB
	import com.foxaweb.utils.Raster;
	

	public class Marker2D extends DSprite {
		
		// ______________________________________________________________________________ VARIABLES STATIQUES
		public static var markerList               :Object={};
		
		// _______________________________________________________________________________ VARIABLES LOCATION
		private var size                           :Number
		private var X                              :Number;
		private var Y                              :Number;  
		private var nom                            :String;
		private var valeur                         :String;
		private var lat                            :Number;                            
		private var lng                            :Number;                            
		
		// _________________________________________________________________________________ VARIABLES MARKER
		private var conteneur                      :DSprite;
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	location OBJECT
		 */
		public function Marker2D( name:String, location:Object ):void {
			
			//--vars
			markerList[name] = this;
			valeur = location.value;
			X = location.Lng * 3.360000E+000;
			Y = -location.Lat * 4.050000E+000;
			nom = location.Name;
			size = Math.pow(Math.sqrt(Number(location.Value) * 2), 1.450000E+000);
			lat = location.Lat;
			lng = location.Lng;
			
			//////////////////////////////
			create()
			//////////////////////////////
			
            return;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   CREATION DU MARKER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function create():void {
			conteneur = new DSprite();
			conteneur.name = "conteneur";
				
				var fond:GraphicShape = new GraphicShape();
				fond.name = "fond";
				fond.cercle( 0x00ffffff, 0, 0, size );
				fond.alpha = 0;
				conteneur.addChild( fond );
				
				var cercle:Bitmap = new Bitmap( new BitmapData( size, true ), "auto", false );
				Raster.aaCircle( cercle.bitmapData, size/2,size/2, size, 0x696765 );
				conteneur.addChild( cercle );
				
				var format:TextFormat = new TextFormat();
				format.color = 0x696765;
				format.font =  "arial";
				format.size = size/3;
				format.align = "center";
				
				var value:TextField = new TextField();
				txt.name = "txt";
				txt.text = valeur;
				txt.type = "dynamic";
				txt.x = size/2;
				txt.y = size/2;
				txt.selectable = false;
				txt.setTextFormat( format );
				conteneur.addChild( value );
				
				var ville:TextField = new TextField();
				conteneur.addChild( ville );
				
			addChild( conteneur );
			conteneur.x2 = X;
			conteneur.y2 = Y;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				           GET MARKER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function getMarker( name:String ) {
			return markerList[name];
		}

		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				        GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
        public function get latitude() : Number
        {
            return lat;
        }

        public function get longitude() : Number
        {
            return lng;
        }

		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			 		  DESTROY MARKERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function destroy():void {
			conteneur = null;
		}
		
		
	}
}