/**
* 
* Maps, gestion de l'affichage d'une carte de type mercator en 2D OU en 3D
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.maps.map3D {
	

	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.stage.StageManager;
	import railk.as3.maps.map3D.Dot;
	import railk.as3.display.DSprite;
	import railk.as3.tween.process.*;
	import railk.as3.tween.process.easing.*;
	
	// __________________________________________________________________________________ IMPORT PAPERVISION
	import org.papervision3d.Papervision3D;
	import org.papervision3d.cameras.*;
    import org.papervision3d.core.geom.*;
    import org.papervision3d.events.*;
    import org.papervision3d.materials.special.*;
    import org.papervision3d.render.*;
    import org.papervision3d.scenes.*;
    import org.papervision3d.view.*;

	
	public class Map3D extends Sprite {
		
		
		// ________________________________________________________________________________________ VARIABLES
		private var conteneur                   :DynamicRegistration;
		
		// _________________________________________________________________________________ VARIABLES MARKER
		private var markers                     :Marker;
		
		// ____________________________________________________________________________ VARIABLES PAPERVISION
		private var scene                       :Scene3D;
		private var viewport                    :Viewport3D;
		private var renderer                    :BasicRenderEngine;
		private var camera                      :Camera3D;
		private var particles                   :Particles;
		
		private var size                        :Number = 70;
        private var dens                        :Number = 150;
        private var currentYaw                  :Number = 0;
        private var timeStopDrag                :Number = 0;
        private var endTime                     :Number = 0;
        private var orgCx                       :Number = 0;
		private var orgCy                       :Number = 0;
		private var orgCz                       :Number = 0;
        private var plottedPlaces               :Array;
        private var returnCam                   :Boolean = false;
        private var easeOut                     :Boolean = false;
        private var marker                      :Array;
        private var dotArray                    :Array;
        private var avgSpeed                    :Number = 0;
        private var fadein                      :Boolean = true;
		private var fadeout                     :Boolean = false;
        private var moveX                       :Number = 0;
        private var moveY                       :Number = 0;
        private var globeMoveH                  :Boolean = false;
        private var globeMoveV                  :Boolean = false;
        private var degree                      :Number = 0;
        private var enableCursors               :Boolean = false;
        private var timeStopMove                :Number = 0;
        private var paused                      :Boolean = false;
        private var noMove                      :Boolean = false;
        private var rotateAfter                 :Boolean = false;
        private var speedUp                     :Boolean = false;
        private var lastMovement                :Number = 0;
        private var dirX                        :Number = 0;
        private var dirY                        :Number = 0;
        private var movedToX                    :Number = 0;
        private var movedToY                    :Number = 0;
        private var duration                    :Number = 0;
        private var timeDrag                    :Number = 0;
        private var circleCenterX               :Number = 0;
        private var circleCenterY               :Number = 0;
        private var stopped                     :Boolean = false;
        private var DynamicDegree               :Number = 0;
        private var rot                         :Number = 0;
        private var ellipse                     :Sprite;
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	texture
		 */
		public function Map3D( texture:* ):void {
			conteneur = new DSprite();
			conteneur.name = "map";
			addChild( conteneur );
			
			//-- particle
			particles = new Particles();
			//--vars
			paused = false;
			stopped = false;
			plottedPlaces = new Array();
			dens = 150;
			size = 70;
			degree = 0;
			moveX = 0;
			moveY = 0;
			movedToX = 0;
			movedToY = 0;
			dirX = 0;
			dirY = 0;
			lastMovement = 0;
			timeDrag = 0;
			endTime = 0;
			duration = 0;
			timeStopDrag = 0;
			timeStopMove = 0;
			globeMoveH = false;
			globeMoveV = false;
			easeOut = false;
			DynamicDegree = 0;
			rotateAfter = false;
			currentYaw = 0;
			ellipse = new Sprite();
			rot = 0;
			orgCx = 0;
			orgCy = 0;
			orgCz = 0;
			returnCam = false;
			noMove = false;
			avgSpeed = 0;
			speedUp = false;
			circleCenterX = 0;
			circleCenterY = 0;
			fadeout = false;
			fadein = true;
			
			///////////////////////////////////
			init3D();
			parseTexture( texture );
			///////////////////////////////////
		
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				      		  INIT 3D
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function init3D():void {
			//Papervision3D.VERBOSE = false;
            viewport = new Viewport3D(0, 0, true, true);
			//viewport.buttonMode = true;
            conteneur.addChild(viewport);
            renderer = new BasicRenderEngine();
            scene = new Scene3D();
            camera = new Camera3D();
            camera.focus = 200;
            camera.zoom = 5;
            conteneur.addEventListener(Event.ENTER_FRAME, loop3D);
			
			//createGlobe();
            //resizeGlobe();
            return;
        }
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				      		  LOOP 3D
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function loop3D( evt:Event ):void{
            var _loc_2:*;
            var _loc_3:*;
            hitCircle();
            if (!stopped)
            {
                if (!paused)
                {
                    camera.x = Math.cos(degree * Math.PI / 180) * 150;
                    camera.z = Math.sin(degree * Math.PI / 180) * 150;
                    if (!rotateAfter)
                    {
                        degree = degree + 0.1;
                    }
                    else
                    {
                        _loc_2 = getTimer() - timeStopDrag;
                        if (speedUp == true)
                        {
                            if (_loc_2 / 5000 <= 1)
                            {
                                rot = 0.1 * Math.sin(_loc_2 / 5000 * (Math.PI / 2));
                            }// end if
                            if (dirX > 0)
                            {
                                degree = degree + rot;
                            }
                            else
                            {
                                degree = degree - rot;
                            }// end else if
                        }
                        else
                        {
                            degree = degree + DynamicDegree;
                        }// end if
                    }// end if
                }// end else if
            }// end else if
            if (easeOut == true)
            {
                _loc_3 = getTimer() - timeStopDrag;
                if (movedToX != 0)
                {
                    if (_loc_3 / duration <= 1)
                    {
                        DynamicDegree = avgSpeed * Math.cos(_loc_3 / duration * (Math.PI / 2));
                        degree = degree + DynamicDegree;
                        camera.x = Math.cos(degree * Math.PI / 180) * 150;
                        camera.z = Math.sin(degree * Math.PI / 180) * 150;
                    }
                    else if (_loc_3 / duration >= 1)
                    {
                        degree = degree + DynamicDegree;
                        camera.x = Math.cos(degree * Math.PI / 180) * 150;
                        camera.z = Math.sin(degree * Math.PI / 180) * 150;
                        rotateAfter = true;
                        paused = false;
                        easeOut = false;
                        degree = degree + DynamicDegree;
                    }// end if
                }// end if
            }// end else if
            renderer.renderScene(scene, camera, viewport);

            return;
        }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				      		RESET CAM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
        public function resetCam(param1:Event) : void
        {
            var bezier:Array;
            var e:* = param1;
            bezier = new Array();
            bezier.push({x:orgCx, y:orgCy, z:orgCz});
            Process.to(camera, .7, {x:orgCx, y:orgCy, z:orgCz, bezier:bezier, zoom:5},{ onStart:
				function ()
				{
					paused = true;
					return;
				}
				, onComplete:
				function ()
				{
					paused = false;
					returnCam = false;
					stage.removeEventListener(MouseEvent.MOUSE_DOWN, resetCam);
					return;
				}
				, transition:"easeInSine"});
            return;
        }

        
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				      	   HIT CIRCLE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
        public function hitCircle() : void
        {
            var circleRadius:*;
            var delta:*;
            circleRadius;
            delta = Math.sqrt(Math.pow(mouseX - circleCenterX, 2) + Math.pow(mouseY - circleCenterY, 2));
            if (delta >= circleRadius)
            {
                if (fadein == false && fadeout == true)
                {
                    fadeout = false;
                }// end if
            }// end if
            if (delta <= circleRadius)
            {
                if (fadein == true && fadeout == false)
                {
                    fadein = false;
                }// end if
            }// end if
            return;
        }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				      		 DATALOAD
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
        private function parseTexture( texture:* )
        {
            dotArray = new Array();
            var textureTab:Array = texture.split(":");
            var i:Number = 0;
			
			
            while ( (i+=1) < textureTab.length )
            {
                dotArray.push( textureTab[i].split(",") );
            }
			
            createGlobe();
            return;
        }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				     	 CREATE GLOBE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
        public function createGlobe() : void
        {
            var _loc_1:Number;
            var _loc_2:Number;
            var _loc_3:Number;
            var _loc_4:Number;
            var _loc_5:Number;
            var _loc_6:Number;
            var mapPoint:Dot;
			var test:Number = 0;
			var test2:Number = dotArray.length - 1;
			
            StageManager.GlobalVars.material1 = new ParticleMaterial(0xFFFFFF, 1);//MovieAssetParticleMaterial( "dotMat", true );
            StageManager.GlobalVars.material2 = new ParticleMaterial(0x111112, 1);;
            StageManager.GlobalVars.material3 = new MovieAssetParticleMaterial( "dotMat" );// ParticleMaterial(16711680, 1);
            _loc_2 = ( -360 / dens) * Math.floor(90 / (360 / dens));
			
            while (_loc_2 < 90)
            {
                _loc_3 = Math.cos(_loc_2 * Math.PI / 180) * size;
                _loc_4 = _loc_3 / (size / dens);
                _loc_5 = 0;
                _loc_6 = 0;
				
                while (_loc_6 < 360)
                {	
					
                    if (dotArray[test2][test] == 1) {
                        mapPoint = new Dot( Math.cos(_loc_6 * Math.PI / 180) * _loc_3, Math.sin(_loc_2 * Math.PI / 180) * size, Math.sin(_loc_6 * Math.PI / 180) * _loc_3 );
                        particles.addParticle( mapPoint.getParticle() );
                    }
					test += 1;
                    _loc_6 = _loc_6 + 360 / Math.floor(_loc_4);
                }
				test = 0;
				test2 -= 1;
                _loc_2 = _loc_2 + 360 / dens;
            }
			
            scene.addChild(particles);
            particles.rotationY = 180;
            particles.yaw(-10);
            globeInteraction();
            return;
        }
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				      PLOT COORDINATE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
        function plotCoordinates(param1:Array, param2:String) : void
        {
            var _loc_4:Array;
            var _loc_5:Number;
            var _loc_6:Number;
            var _loc_7:Number;
            var _loc_8:Number;
            var _loc_9:Number;
            var _loc_10:Array;
            //var _loc_11:Array;
            var _loc_12:Object;
            var _loc_13:*;
            var _loc_14:*;
            var _loc_15:Number;
            var _loc_16:Number;
            var _loc_17:Number;
            var _loc_18:Marker;
            _loc_4 = new Array();
            _loc_5 = 0;
            while (_loc_5++ < plottedPlaces.length)
            {
                // label
                _loc_4.push(plottedPlaces[_loc_5]);
            }
            _loc_5 = 0;
            while (_loc_5++ < _loc_4.length)
            {
                // label
                particles.removeChild(_loc_4[_loc_5]);
            }
            if (param2 == "students" || param2 == "creatives")
            {
                _loc_6 = 16724787;
                _loc_7 = 15606306;
                _loc_8 = 3407667;
                _loc_9 = 2289186;
            }
            else if (param2 == "visitors")
            {
                _loc_6 = 3407667;
                _loc_7 = 2289186;
                _loc_8 = 16724787;
                _loc_9 = 15606306;
            }// end else if
            _loc_10 = [_loc_6, _loc_7, _loc_8, _loc_9];
            plottedPlaces = new Array();
            for ( var prop in param1 )
            {
                // label
                _loc_12 = new Object();
                _loc_13 = Number( prop[2]) + 3;
                _loc_14 = Number( prop[3]) + 179;
                _loc_15 = 0;
                _loc_16 = 0;
                _loc_17 = 0;
                if ( prop[4] > 0)
                {
                    _loc_15 = prop[4];
                }// end if
                if (prop[5] > 0)
                {
                    _loc_16 = prop[5];
                }// end if
                if (prop[6] > 0)
                {
                    _loc_17 = prop[6];
                }// end if
                _loc_12.height = (_loc_15 + _loc_16 + _loc_17) / 10;
                if (_loc_12.height < 1)
                {
                    _loc_12.height = 1;
                }// end if
                _loc_12.city = prop[0];
                _loc_18 = new Marker(_loc_13, _loc_14, size, dens, prop[0] + ", " + prop[1], _loc_10, _loc_15, _loc_16, _loc_17, param2);
                _loc_18.extra = _loc_12;
                _loc_18.lookAt(particles);
                _loc_18.moveBackward(_loc_12.height / 2);
                _loc_18.moveDown(0.5);
                _loc_18.moveRight(0.5);
                _loc_18.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, pillarClick);
                particles.addChild(_loc_18);
                plottedPlaces.push(_loc_18);
                Process.to(_loc_18, 1,{x:_loc_18.x, y:_loc_18.y, z:_loc_18.z},{ ease:Cubic.easeInOut, delay:plottedPlaces.length / 100});
                _loc_18.moveBackward(2000);
            }// end of for ... in
            trace("plotted places: " + plottedPlaces.length);
            return;
        }

        
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				       VERTICAL PRESS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
        public function verticalPress( evt:MouseEvent ) : void
        {
			
            var _loc_2:*;
            var _loc_3:*;
            _loc_2 = 230;
            _loc_3 = Math.sqrt(Math.pow(mouseX - circleCenterX, 2) + Math.pow(mouseY - circleCenterY, 2));
            //if (_loc_3 <= _loc_2)
           // {
                if (!returnCam)
                {
					trace( mouseY );
                    timeDrag = getTimer();
                    moveX = stage.mouseX;
                    moveY = stage.mouseY;
                    dirX = 0;
                    dirY = 0;
                    paused = true;
                    globeMoveV = true;
                    globeMoveH = true;
                    easeOut = false;
                    noMove = false;
                }// end if
            //}// end if
            return;
        }
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				     	 MARKER CLICK
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
        private function pillarClick( evt:InteractiveScene3DEvent ) : void
        {
            orgCx = camera.x;
            orgCy = camera.y;
            orgCz = camera.z;
            return;
        }

			
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				     	 LOAD VISITOR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
        public function loadVisitors() : void
        {
            var places:Array;
            var visitorCount:Number;
            var visitor:Object;
            var i:Number;
            var searchArray:Function;
            var placesToPlot:Array;
            var latitude:Number;
            var longitude:Number;
            var returnArr:Array;
            var searchArray:Function = function (param1:Number, param2:Number, param3:String) : Array
				{
					var _loc_4:String;
					var _loc_5:Number;
					var _loc_6:Number;
					_loc_4 = "";
					_loc_5 = 0;
					_loc_6 = 0;
					while (_loc_6++ < places.length)
					{
						// label
						if (places[_loc_6].lat == param1 && places[_loc_6].lon == param2 && places[_loc_6].city != param3 && param1 != -1 && param2 != -1)
						{
							_loc_5 = _loc_5 + Number(places[_loc_6].count);
							var _loc_7:int;
							places[_loc_6].lon = -1;
							places[_loc_6].lat = _loc_7;
						}// end if
					}
					return [_loc_4, _loc_5];
				};
				
            places = new Array();
            visitorCount;
            var _loc_2:int;
            var _loc_3:* = null;
            while (_loc_3 in _loc_2)
            {
                // label
                visitor = _loc_3[_loc_2];
                latitude = snapLat(visitor.lat);
                longitude = snapLon(visitor.lat, visitor.lon);
                places.push({city:visitor.city, country:visitor.country, lat:latitude, lon:longitude, count:visitor.count});
                visitorCount = visitorCount + Number(visitor.count);
            }
            places.sortOn("count", Array.DESCENDING | Array.NUMERIC);
            i;
            while (i < places.length)
            {
                // label
                returnArr = searchArray(places[i].lat, places[i].lon, places[i].city);
                if (returnArr.length > 0)
                {
                    places[i].city = places[i].city + returnArr[0];
                    places[i].count = Number(places[i].count) + Number(returnArr[1]);
                }// end if
                i = i++;
            }
            placesToPlot = new Array();
            i;
            while (i < places.length)
            {
                // label
                if (places[i].lat > -1 && places[i].count > 2 && places[i].city.length > 0)
                {
                    placesToPlot.push([places[i].city, places[i].country, places[i].lat, places[i].lon, places[i].count]);
                }// end if
                i = i++;
            }
            plotCoordinates(placesToPlot, "visitors");
            return;
        }
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				        REMOVE MARKER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
        public function removePillar( m:Marker ) : void
        {
            //removeChild( m );
            m = null;
            return;
        }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				      	STAGE RELEASE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
        public function stageRelease( evt:MouseEvent ) : void
        {
			trace( "move" );
            var _loc_2:*;
            if (!returnCam)
            {
                if (globeMoveH == true)
                {
                    degree = dirX + degree;
                    currentYaw = -dirY + currentYaw;
                    movedToX = moveX - stage.mouseX;
                    movedToY = moveY - stage.mouseY;
                    timeStopDrag = getTimer();
                    duration = (timeStopDrag - timeDrag) * ((timeStopDrag - timeDrag) / 100 * 3) + 1000;
                    endTime = getTimer() + duration;
                    easeOut = true;
                    _loc_2 = 0.03;
                    if (timeStopDrag - timeStopMove > 125)
                    {
                        if (lastMovement / (timeStopDrag - timeStopMove) > -_loc_2 && lastMovement / (timeStopDrag - timeStopMove) < _loc_2)
                        {
                            easeOut = false;
                            noMove = true;
                            speedUp = true;
                            paused = false;
                            rotateAfter = true;
                        }// end if
                    }// end if
                    if (!noMove)
                    {
                        if (dirX <= 0)
                        {
                            dirX = -dirX;
                            avgSpeed = Math.pow(Math.pow(dirX, 1.08) / (duration / 300), 1.06);
                            avgSpeed = -avgSpeed;
                            speedUp = false;
                        }
                        else
                        {
                            avgSpeed = Math.pow(Math.pow(dirX, 1.08) / (duration / 400), 1.06);
                        }// end else if
                        degree = degree + avgSpeed;
                    }// end if
                    globeMoveH = false;
                    globeMoveV = false;
                }// end if
            }// end if
            return;
        }

		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				    		LONGITUDE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
        private function snapLon(param1:Number, param2:Number) : Number
        {
            var _loc_3:Number;
            var _loc_4:Number;
            _loc_3 = Math.cos(snapLat(param1) * Math.PI / 180);
            _loc_4 = Math.floor(_loc_3 * dens);
            return Math.round(param2 / (360 / _loc_4)) * (360 / _loc_4);
        }
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				    		 LATITUDE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
        private function snapLat(param1:Number) : Number
        {
            return Math.round(param1 / 360 * dens) * 360 / dens;
        }
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				 ENABLE INTERACTIVITY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function setInteractive( enable:Boolean ):void
        {
            var _loc_2:* = enable;
            viewport.interactive = enable;
            var _loc_2:* = _loc_2;
            this.mouseChildren = _loc_2;
            this.mouseEnabled = _loc_2;
            return;
        }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				 		 RESIZE GLOBE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
        public function resizeGlobe() : void
        {
            ellipse.x = stage.stageWidth / 2 - ellipse.width / 2;
            ellipse.y = stage.stageHeight / 2 - ellipse.height / 2;
            circleCenterX = stage.stageWidth / 2;
            circleCenterY = stage.stageHeight / 2;
            return;
        }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				 	GLOBE INTERCATION
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
        private function globeInteraction()
        {
            var _loc_1:*;
            var _loc_2:*;
            var _loc_3:*;
            var _loc_4:*;
            _loc_1 = camera.zoom * 100;
            _loc_2 = camera.zoom * 100;
            _loc_3 = StageManager.W / 2 - _loc_1 / 2;
            _loc_4 = StageManager.H / 2 - _loc_2 / 2 - 20;
            ellipse.graphics.beginFill(16711680);
            ellipse.graphics.drawEllipse(0, 0, _loc_1, _loc_2);
            ellipse.graphics.endFill();
            ellipse.buttonMode = true;
            ellipse.useHandCursor = false;
            conteneur.addChildAt(ellipse, 0);
            ellipse.alpha = 0;
            ellipse.x = _loc_3;
            ellipse.y = _loc_4;
            ellipse.mouseChildren = false;
            ellipse.mouseEnabled = true;
            addEventListener( MouseEvent.MOUSE_DOWN, verticalPress ) ;
            addEventListener( MouseEvent.MOUSE_UP, stageRelease );
            addEventListener( MouseEvent.MOUSE_MOVE, stageMove );
            return;
        }


        public function stageMove( evt:MouseEvent ) : void
        {
            if (!returnCam)
            {
                if (globeMoveH == true)
                {
                    lastMovement = dirX - (moveX - stage.mouseX) * 0.1;
                    dirX = (moveX - stage.mouseX) * 0.1;
                    camera.x = Math.cos((dirX + degree) * Math.PI / 180) * 150;
                    camera.z = Math.sin((dirX + degree) * Math.PI / 180) * 150;
                    timeStopMove = getTimer();
                }// end if
                if (globeMoveV == true)
                {
                    dirY = (moveY - stage.mouseY) * 0.08;
                    camera.y = Math.sin((-dirY + currentYaw) * Math.PI / 180) * 70;
                }// end if
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