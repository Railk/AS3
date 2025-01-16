/**
* 
* FlowEngine class
* 
* @author Richard Rodney
* @version 0.2
* 
* TODO lAYERS MANAGEMENT
*/


package railk.as3.painting 
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import railk.as3.display.graphicShape.CircleShape;
	import railk.as3.display.graphicShape.ArcCircleShape;
	import railk.as3.display.UISprite;
	import railk.as3.utils.Utils;
	import railk.as3.utils.Logger;
	import railk.as3.painting.BrushState;	
	import railk.as3.painting.FlowEngineEvent;
	
	
	public class FlowEngineVector extends UISprite  
	{	
		// _______________________________________________________________________________ CONSTANTES BRUSHS
		public const AA_BRUSH                            :String = 'aa';
		public const SOFT_BRUSH                          :String = 'soft';
		public const NORMAL_BRUSH                        :String = 'normal';
		public const BRUSH_MAX_SIZE                      :int = 140;
		public const BRUSH_MIN_SIZE                      :int = 1;
		public const BRUSH_MAX_ALPHA                     :int = 255;
		public const BRUSH_MIN_ALPHA                     :int = 15;
		
		// _______________________________________________________________________________ CONSTANTES ENGINE
		public const PAINT_MODE                          :String = 'paintMode';
		public const REPLAY_MODE                         :String = 'replayMode';
		public const ENGINE_MAX_LAYERS                   :int = 5;
		public const ENGINE_MIN_LAYERS                   :int = 1;
		public const ENGINE_MAX_UNDO                     :int = 30;
		
		// __________________________________________________________________________________ VARIABLES MODE
		private var mode                                 :String;
		private var replayTimer                          :Timer;
		
		// ________________________________________________________________________________ VARIABLES CANVAS
		private var brushBuffer                          :Bitmap;
		private var buffer                               :Bitmap;
		private var layer                                :Bitmap;
		private var previousAlpha                        :int=1;
		private var ct                                   :ColorTransform;
		private var m	                                 :Matrix;
		private var _bgColor                             :uint;
		private var _H                                   :int;
		private var _W                                   :int;
		

		// _________________________________________________________________________________ VARIABLES BRUSH
		private var ghostBrush                           :UISprite;
		private var cur                                  :ArcCircleShape;
		private var curPoint                             :CircleShape;
		private var curAlpha                             :Number = .3;
		private var brushSteps                           :int=1;
		private var points                               :Array;
		private var r_points                             :Array;
		
		// _______________________________________________________________________________ VARIABLES CONTROLE
		private var byteStroke                           :ByteArray;
		private var lastExternalStep                     :int = 0;
		private var overrideColor                        :int;
		private var overrideAlpha                        :int;
		private var replayStrokes                        :Array;
		private var replayStatus                         :String;
		private var replayDrawStatus                     :Boolean = false;
		private var _pressureEnabled                     :Boolean = false;
		
		// __________________________________________________________________________________ VARIABLES EVENT
		private var eEvent                               :FlowEngineEvent;
		
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	W
		 * @param	H
		 * @param	mode   replay|paint
		 */
		public function FlowEngineVector( bgColor:uint, W:int, H:int, engineMode:String, layers:int = 1 ) {	
			_W = W;
			_H = H;
			_bgColor = bgColor
			init();
		}
		
		private function init():void {
			layer = new Bitmap( new BitmapData( _W,_H,true, _bgColor ),"auto",true );
			addChild( layer );
			buffer = new Bitmap( new BitmapData( _W,_H,true,0x00ffffff ),"auto",true );
			addChild( buffer );
			brushBuffer = new Bitmap( new BitmapData( _W,_H,true,0x00ffffff ),"auto",true );
			addChild( brushBuffer );
				
			//--initialisation surface for brush painting
			BrushCreator.init( _W, _H, buffer.bitmapData );
			
			//--matrix for mirror
			m = new Matrix();
			
			//--engine mode
			mode = engineMode;
			if( engineMode == 'paint' ){
				points = new Array();
				r_points = new Array();
				BrushState.init( 0, 0, 'normal', 1, 255, 0xFF000000 );
				
				//--brush ghost
				ghostBrush = new UISprite()
				addChild( ghostBrush );
				
					cur = new ArcCircleShape( .5, 0xFFFFFF, 0, 0, BrushState.radius+3, 0, 360, 40 );
					cur.blendMode = "invert";
					cur.alpha = curAlpha;
					ghostBrush.addChild( cur );
					
					curPoint = new CircleShape( 0x000000, 0, 0, 1, .5 );
					curPoint.blendMode = "invert";
					ghostBrush.addChild( curPoint );
					
				////////////////////////////////
				initPaintListeners();
				////////////////////////////////
				
			}
			else if ( engineMode == 'replay' )
			{
				replayStrokes = new Array();
				byteStroke = new ByteArray();
				byteStroke.length = _W * _H;
				for ( var j:int = 0; j < byteStroke.length; j++ )
				{
					byteStroke[j] = 0;
				}
				byteStroke.position = 0;
				
				points = null;
				BrushState.init( 0, 0, 'normal', 1, 255, 0xFF000000 );
				replayStatus = 'stop';
				
				//--brush ghost
				ghostBrush = new UISprite()
				addChild( ghostBrush );
				
				////////////////////////////////
				initReplayListeners();
				////////////////////////////////
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 MANAGE LISTENERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function initPaintListeners():void {
			this.addEventListener( MouseEvent.MOUSE_DOWN, beginPaint, false, 0, true );
			this.addEventListener( MouseEvent.MOUSE_UP, stopPaint, false, 0, true );
			this.addEventListener( Event.ENTER_FRAME, cursorFollow, false, 0, true );
		}
		
		public function delPaintListeners():void {
			this.removeEventListener( MouseEvent.MOUSE_DOWN, beginPaint );
			this.removeEventListener( MouseEvent.MOUSE_UP, stopPaint );
			this.removeEventListener( Event.ENTER_FRAME, cursorFollow );
		}
		
		private function initReplayListeners():void {
			replayTimer = new Timer( 0.1 );
			replayTimer.addEventListener( TimerEvent.TIMER, beginReplay, false, 0, true );
		}
		
		private function delReplayListeners():void {
			replayTimer.removeEventListener( TimerEvent.TIMER, beginReplay );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  BEGIN PAINT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function beginPaint( evt:MouseEvent ):void {
			buffer.alpha = 1;
			BrushState.status = 'begin';
			
			ghostBrush.x2 = mouseX;
			ghostBrush.y2 = mouseY;
			BrushState.x = ghostBrush.x2;
			BrushState.y = ghostBrush.y2
			points.push( BrushState );
			r_points.push( BrushState.state );
			
			this.addEventListener( MouseEvent.MOUSE_MOVE, paint, false, 0, true );
			
			var p:Point = new Point( ghostBrush.x2, ghostBrush.y2 );
			////////////////////////////////
			drawBrush( p,p );
			////////////////////////////////
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 		PAINT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function paint( evt:MouseEvent ):void{
			BrushState.x = ghostBrush.x2;
			BrushState.y = ghostBrush.y2;
			points.push( BrushState );
			r_points.push( BrushState.state );
			
			ghostBrush.x2 = mouseX;
			ghostBrush.y2 = mouseY;
			
			var oldP:Point = new Point( points[points.length-1].x,points[points.length-1].y );
			var newP:Point = new Point( ghostBrush.x2, ghostBrush.y2 );
			
			////////////////////////////////
			drawBrush( oldP,newP );
			////////////////////////////////
			evt.updateAfterEvent();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						   STOP PAINT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function stopPaint( evt:MouseEvent ):void
		{	
			if ( pressureEnabled ){
				this.brushSize = 0;
				this.brushPressure = 0;
			}
			
			BrushState.status = 'end';
			r_points.push( BrushState.state );
			
			layer.bitmapData.draw( buffer,null,ct,null,null,true );
			//--
			buffer.alpha = 0;
			buffer.bitmapData.fillRect( buffer.bitmapData.rect, 0x00FFFFFF );
			BrushCreator.init( _W,_H,buffer.bitmapData );
			
			this.removeEventListener( MouseEvent.MOUSE_MOVE, paint );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  INIT REPLAY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function initReplay( replayPoints:Array ):void {
			points = new Array();
			points = replayPoints;
			BrushState.init( points[0].x, points[0].y, points[0].type, points[0].size, points[0].alpha, points[0].color );
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  PLAY REPLAY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function externalProcessReplay( step:int, color:uint = 0x00ffffff, alpha:int = 0 ):void 
		{
			var args:Object;
			var steps:int = step - lastExternalStep;
			overrideColor = color;
			overrideAlpha = alpha;
			
			///////////////////////////////////////
			replayStatus = 'start';
			///////////////////////////////////////
			
			for ( var i:int = 0; i < steps; i++ )
			{
				if ( brushSteps < points.length )
				{
					//--flip
					if ( points[ brushSteps ].flipX ) 
					{
						m.scale( -1,1 );
						m.translate( 512,0 );
						layer.transform.matrix = m;
					}
					if ( points[ brushSteps ].flipY ) 
					{
						m.scale( 1,-1 );
						m.translate( 0,384 );
						layer.transform.matrix = m;
					}
					
					//--state
					if ( points[ brushSteps ].status == 'begin' && replayDrawStatus == false )
					{
						buffer.alpha = 1;
						replayDrawStatus = true;
						replay( points[ brushSteps ], points[ brushSteps ] );
					}
					else if ( points[ brushSteps ].status == 'begin' && replayDrawStatus == true )
					{
						replay( points[ brushSteps - 1 ], points[ brushSteps ] );
					}
					else if ( points[ brushSteps ].status == 'end' || points[ brushSteps ].status == 'changeColor' || points[ brushSteps ].status == 'changeSize'  )
					{
						layer.bitmapData.draw( buffer, m, ct, null, null, true );
						//--
						buffer.alpha = 0;
						buffer.bitmapData.fillRect( buffer.bitmapData.rect, 0x00FFFFFF );
						BrushCreator.init( _W, _H, buffer.bitmapData );
						replayDrawStatus = false;
					}
					
					brushSteps++;
					var percent:Number = (brushSteps * 100) / points.length;
					//////////////////////////////////////////////////////////////////////
					args = { info:"replay progress", percent:percent};
					eEvent = new FlowEngineEvent( FlowEngineEvent.ONREPLAYPROGRESS, args );
					dispatchEvent( eEvent );
					/////////////////////////////////////////////////////////////////////
				}
				else 
				{
					replayStatus = "end";
					//lastExternalStep = 0;
					//////////////////////////////////////////////////////////////////////
					args = { info:"replay finish"};
					eEvent = new FlowEngineEvent( FlowEngineEvent.ONREPLAYCOMPLETE, args );
					dispatchEvent( eEvent );
					/////////////////////////////////////////////////////////////////////
				}
			}	
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 BEGIN REPLAY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function beginReplay( evt:TimerEvent ):void {
			var args:Object;
			if ( points == null ){
				replayTimer.stop();
				//////////////////////////////////////////////////////////////////////
				args = { info:"you must init replay first"};
				eEvent = new FlowEngineEvent( FlowEngineEvent.ONNOREPLAYPOINTS, args );
				dispatchEvent( eEvent );
				/////////////////////////////////////////////////////////////////////
			}
			else { replayStatus = 'start'; }	
			
			if ( brushSteps < points.length )
			{
				//--flip
				if ( points[ brushSteps ].flipX ) 
				{
					m.scale( -1,1 );
					m.translate( 512,0 );
					layer.transform.matrix = m;
				}
				if ( points[ brushSteps ].flipY ) 
				{
					m.scale( 1,-1 );
					m.translate( 0,384 );
					layer.transform.matrix = m;
				}
				
				//--state
				if ( points[ brushSteps ].status == 'begin' && replayDrawStatus == false )
				{
					buffer.alpha = 1;
					replayDrawStatus = true;
					replay( points[ brushSteps ], points[ brushSteps ] );
				}
				else if ( points[ brushSteps ].status == 'begin' && replayDrawStatus == true )
				{
					replay( points[ brushSteps - 1 ], points[ brushSteps ] );
				}
				else if ( points[ brushSteps ].status == 'end' || points[ brushSteps ].status == 'changeColor' || points[ brushSteps ].status == 'changeSize'  )
				{
					layer.bitmapData.draw( buffer, m, ct, null, null, true );
					//--
					buffer.alpha = 0;
					buffer.bitmapData.fillRect( buffer.bitmapData.rect, 0x00FFFFFF );
					BrushCreator.init( _W, _H, buffer.bitmapData );
					replayDrawStatus = false;
					
					//--replayStroke
					/*var stroke:Object = new Object();
					stroke.steps = brushSteps;
					stroke.flipX = points[ brushSteps ].flipX;
					stroke.flipY = points[ brushSteps ].flipY;
					stroke.color = points[ brushSteps ].color;
					stroke.bytes = byteStroke;
					replayStrokes.push( stroke );
					
					byteStroke = new ByteArray();
					byteStroke.length = _W * _H;
					byteStroke.position = 0;*/
				}
				
				brushSteps++;
				var percent:Number = (brushSteps * 100) / points.length;
				//////////////////////////////////////////////////////////////////////
				args = { info:"replay progress", percent:percent};
				eEvent = new FlowEngineEvent( FlowEngineEvent.ONREPLAYPROGRESS, args );
				dispatchEvent( eEvent );
				/////////////////////////////////////////////////////////////////////
			}
			else 
			{
				replayTimer.stop();
				replayStatus = "end";
				brushSteps = 1;
				//////////////////////////////////////////////////////////////////////
				args = { info:"replay finish"};
				eEvent = new FlowEngineEvent( FlowEngineEvent.ONREPLAYCOMPLETE, args );
				dispatchEvent( eEvent );
				/////////////////////////////////////////////////////////////////////
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	   REPLAY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function replay( A:Object, B:Object ):void 
		{
			BrushState.x = B.x;
			BrushState.y = B.y;
			BrushState.size = B.size;
			BrushState.type = B.brushType;
			if ( overrideColor != 0x00ffffff ) BrushState.color = overrideColor;
			else BrushState.color = B.color;
			if ( overrideAlpha != 0 ) BrushState.alpha = overrideAlpha;
			else BrushState.alpha = B.alpha;
			
			ghostBrush.x2 = B.x;
			ghostBrush.y2 = B.y;
			
			var oldP:Point = new Point( A.x,A.y );
			var newP:Point = new Point( B.x, B.y );
			
			//////////////////////////////////////////
			drawBrush( oldP,newP );
			//////////////////////////////////////////
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  PLAY REPLAY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function startReplay():void {
			if ( replayStatus == 'end' )
			{
				eraseSurface();
				brushSteps = 1;
			}
			replayTimer.start();
			replayStatus = 'start';
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 PAUSE REPLAY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function pauseReplay():void {
			replayTimer.stop();
			replayStatus = 'stop';
			trace( replayStrokes.length );
			layer = replayStrokes[0];
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  STOP REPLAY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function stopReplay():void {
			replayTimer.stop();
			replayStatus = 'stop';
			eraseSurface();
		}
		
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						   DRAW BRUSH
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function drawBrush( A:Point, B:Point ):void 
		{
			var x:int = A.x;
			var y:int = A.y;
			var dx:int = B.x - A.x;
			var dy:int = B.y - A.y;
			var sqrDist:Number = Math.sqrt( dx * dx + dy * dy );
			var color:uint = BrushState.color;
			var r:uint = color >>> 16 & 0xFF;
			var g:uint = color >>>  8 & 0xFF;
			var b:uint = color & 0xFF;
			color =  r << 16 | g << 8 | b;
			var brush:CircleShape = new CircleShape(color, 0, 0, BrushState.radius);
			brush.alpha = 0;
			
			if ( previousAlpha > BrushState.alpha )
			{
				layer.bitmapData.draw( buffer, m, ct,null,null,true );
				buffer.bitmapData.fillRect( buffer.bitmapData.rect, 0x00FFFFFF );
			}
			
			ct = new ColorTransform();
			ct.alphaMultiplier = BrushState.alpha / 255;
			buffer.alpha = BrushState.alpha / 255;
			
			var xinc:int = ( dx > 0 ) ? 1 : -1;
			var yinc:int = ( dy > 0 ) ? 1 : -1;
			var i:int;
			var cumul:int;
			if (dx < 0)  dx = -dx;
			if (dy < 0)  dy = -dy;
			
			if ( dx > dy ){
				cumul = dx >> 1 ;
				i = dx;
				do{
					x += xinc;
					cumul += dy;
					if (cumul >= dx){
						cumul -= dx;
						y += yinc;
					}
					brush.y = y;
					brush.x = x;
					buffer.bitmapData.draw( brush, brush.transform.matrix,null,null,null,true );
				}while (i-->=1);
			}else{
				cumul = dy >> 1;
				i = dy;
				do{
					y += yinc;
					cumul += dx;
					if ( cumul >= dy ){
						cumul -= dy;
						x += xinc ;
					}
					brush.y = y;
					brush.x = x;
					buffer.bitmapData.draw( brush, brush.transform.matrix,null,null,null,true );
				}while (i-->=1);
			}
			//brushBuffer.bitmapData = new BitmapData( _W,_H, true, 0x00FFFFFF);
			previousAlpha = BrushState.alpha;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  	PARSE SMALL BRUSH
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function parseSmallBrushes( brushes:Array ):void { BrushCreator.parseSmallBrushes( brushes ); }
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						CURSOR FOLLOW
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function cursorFollow( evt:Event ):void {
			ghostBrush.x2 = mouseX;
			ghostBrush.y2 = mouseY;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						ERASE SURFACE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function eraseSurface():void {
			layer.bitmapData =  new BitmapData( _W,_H,true,_bgColor );
			buffer.bitmapData = new BitmapData( _W, _H, true, 0x00ffffff );
			BrushCreator.init( _W, _H, buffer.bitmapData );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void {
			if ( engineMode == 'paint' ){
				delPaintListeners();
			}
			else if ( engineMode == 'replay' ){
				delReplayListeners();
			}
			layer.bitmapData.dispose();
			buffer.bitmapData.dispose();
			layer = null;
			buffer = null;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get engineMode():String { return mode; }
		
		public function set engineMode( type:String ):void { mode = type; }
		
		public function get replayPoints():Array { return r_points; }
		
		public function get replayState():String { return replayStatus; }
		
		public function get brushType():String { return BrushState.type; }
		
		public function set brushType( value:String ):void { BrushState.type = value }
		
		public function get brushSize():Number { return BrushState.size; }
		
		public function set brushSize( value:Number ):void {
			BrushState.size = value;
			cur = new ArcCircleShape( 1, 0xFFFFFF, 0, 0, BrushState.radius+3, 0, 360, 40 );
		}
		
		public function get brushColor():uint { return BrushState.color; }
		
		public function set brushColor( value:uint ):void { BrushState.color= value; }
		
		public function get brushAlpha():int { return BrushState.alpha; }
		
		public function set brushAlpha( value:int ):void {
			cur.alpha = (curAlpha * value)/BRUSH_MAX_ALPHA;
			BrushState.alpha = value;
			
			var color:uint = BrushState.color;
			var a:int = value;
			var r:int = color >>> 16 & 0xFF;
			var g:int  = color >>>  8 & 0xFF;
			var b:int  = color & 0xFF;
			BrushState.color = a << 24 | r << 16 | g << 8 | b;
		}
		
		public function get brushPressure():int { return BrushState.pressure; }
		
		public function set brushPressure( value:int ):void { BrushState.pressure = value; }
		
		public function get pressureEnabled():Boolean { return _pressureEnabled; }
		
		public function set pressureEnabled( value:Boolean ):void { _pressureEnabled = value; }
		
		public function get brushCursor():int { return BrushState.cursor; }
		
		public function set brushCursor( value:int ):void { BrushState.cursor = value; }
		
		public function get canvasColor():uint { return _bgColor; }
		
		public function set canvasColor( value:uint ):void { _bgColor = value; }
		
		public function get canvas():BitmapData { return layer.bitmapData; }	
	}
}