/**
* 
* Marker, gestion de l'affichage de marker sur une carte de type Map
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.maps.map3D {
	

	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
	// __________________________________________________________________________________ IMPORT PAPERVISION
	import org.papervision3d.events.*;
    import org.papervision3d.materials.*;
    import org.papervision3d.materials.utils.*;
    import org.papervision3d.objects.primitives.*;
	

	public class Marker3D extends Cube {
		
		
		// _______________________________________________________________________________ VARIABLES MARKER3D
		private var dens                           :Number;
        private var pillarInfo                     :Boolean = false;
        private var type                           :String;
        private var agencies                       :Number;
        private var colors                         :Array;
        private var students                       :Number;
        private var latitude                       :Number;
        private var creatives                      :Number;
        private var longitude                      :Number;
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	location OBJECT
		 */
		public function Marker3D( param1:Number, param2:Number, param3:Number, param4:Number, param5:String, param6:Array, param7:Number, param8:Number, param9:Number, param10:String ):void {
			
			var _loc_11:BitmapMaterial;
            var _loc_12:BitmapMaterial;
            var _loc_13:MaterialsList;
            var _loc_14:Number;
            var _loc_15:Number;
            var _loc_16:Number;
            var _loc_17:Number;
            pillarInfo = false;
            this.dens = param4;
            this.colors = param6;
            this.type = param10;
            this.students = param7;
            this.creatives = param8;
            this.agencies = param9;
            _loc_11 = new BitmapMaterial(new BitmapData(1, 1, false, param6[0]));
            _loc_11.interactive = true;
            _loc_12 = new BitmapMaterial(new BitmapData(1, 1, false, param6[1]));
            _loc_12.interactive = true;
            _loc_13 = new MaterialsList({front:_loc_11, right:_loc_11, top:_loc_11, back:_loc_12, left:_loc_12, bottom:_loc_12});
            _loc_14 = (param7 + param8 + param9) / 10;
            if (_loc_14 < 1)
            {
                _loc_14 = 1;
            }// end if
            super(_loc_13, 1, _loc_14, 1, 1, 1);
            _loc_15 = Math.cos(param1 * Math.PI / 180) * param3;
            var _loc_18:* = snapLat(param1);
            this.latitude = snapLat(param1);
            _loc_16 = _loc_18;
            var _loc_18:* = snapLon(param1, param2);
            this.longitude = snapLon(param1, param2);
            _loc_17 = _loc_18;
            x = Math.cos(_loc_17 * Math.PI / 180) * _loc_15;
            y = Math.sin(_loc_16 * Math.PI / 180) * param3;
            z = Math.sin(_loc_17 * Math.PI / 180) * _loc_15;
            this.name = param5;
            addEventListener(InteractiveScene3DEvent.OBJECT_OVER, markerOver);
            addEventListener(InteractiveScene3DEvent.OBJECT_OUT, markerOut);
            return;
		}
		
		
		
		public function getMarker() {
			
		}
		

        private function markerOver(param1:InteractiveScene3DEvent) : void
        {
            //dispatchEvent(new CustomEvent("pillarShow", {city:this.name, students:students, creatives:creatives, agencies:agencies, x:this.screen.x, y:this.screen.y, pillar:this}));
            this.materials.getMaterialByName("front").bitmap = new BitmapData(1, 1, false, colors[2]);
            this.materials.getMaterialByName("right").bitmap = new BitmapData(1, 1, false, colors[2]);
            this.materials.getMaterialByName("top").bitmap = new BitmapData(1, 1, false, colors[2]);
            this.materials.getMaterialByName("back").bitmap = new BitmapData(1, 1, false, colors[3]);
            this.materials.getMaterialByName("left").bitmap = new BitmapData(1, 1, false, colors[3]);
            this.materials.getMaterialByName("bottom").bitmap = new BitmapData(1, 1, false, colors[3]);
            return;
        }
		
		 private function markerOut(param1:InteractiveScene3DEvent) : void
        {
            //dispatchEvent(new CustomEvent("pillarHide"));
            if (!pillarInfo)
            {
                this.materials.getMaterialByName("front").bitmap = new BitmapData(1, 1, false, colors[0]);
                this.materials.getMaterialByName("right").bitmap = new BitmapData(1, 1, false, colors[0]);
                this.materials.getMaterialByName("top").bitmap = new BitmapData(1, 1, false, colors[0]);
                this.materials.getMaterialByName("back").bitmap = new BitmapData(1, 1, false, colors[1]);
                this.materials.getMaterialByName("left").bitmap = new BitmapData(1, 1, false, colors[1]);
                this.materials.getMaterialByName("bottom").bitmap = new BitmapData(1, 1, false, colors[1]);
            }// end if
            return;
        }

        private function snapLon(param1:Number, param2:Number) : Number
        {
            var _loc_3:Number;
            var _loc_4:Number;
            _loc_3 = Math.cos(snapLat(param1) * Math.PI / 180);
            _loc_4 = Math.floor(_loc_3 * dens);
            return Math.round(param2 / (360 / _loc_4)) * (360 / _loc_4);
        }

        private function snapLat(param1:Number) : Number
        {
            return Math.round(param1 / 360 * dens) * 360 / dens;
        }

		
		
		
        public function getType() : String
        {
            return type;
        }

        public function getLatitude() : Number
        {
            return this.latitude;
        }

        public function getPillarInfo() : Boolean
        {
            return pillarInfo;
        }

        public function getLongitude() : Number
        {
            return this.longitude;
        }

        public function setPillarInfo(param1:Boolean) : void
        {
            pillarInfo = param1;
            if (!param1)
            {
                this.materials.getMaterialByName("front").bitmap = new BitmapData(1, 1, false, colors[0]);
                this.materials.getMaterialByName("right").bitmap = new BitmapData(1, 1, false, colors[0]);
                this.materials.getMaterialByName("top").bitmap = new BitmapData(1, 1, false, colors[0]);
                this.materials.getMaterialByName("back").bitmap = new BitmapData(1, 1, false, colors[1]);
                this.materials.getMaterialByName("left").bitmap = new BitmapData(1, 1, false, colors[1]);
                this.materials.getMaterialByName("bottom").bitmap = new BitmapData(1, 1, false, colors[1]);
            }// end if
            return;
        }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			  DESTROY MAP AND MARKERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function destroy():void {
			
		}
		
		
	}
	
}