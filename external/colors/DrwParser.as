/**
* 
* Parser for .drw Files of Colors! software 
* 
* @author richard rodney
* @version 0.1
*/

package railk.as3.external.colors 
{	
	import flash.utils.ByteArray;
	public class DrwParser 
	{	
		private static const FULL_BRUSH             :int=0;
		private static const VARIABLE_SIZE_BRUSH    :int=1;
		private static const VARIABLE_OPACITY_BRUSH :int=2;
		private static const HARD_BRUSH             :String='aa';
		private static const SOFT_BRUSH             :String='soft';
		
		private static var version                  :Number;
		private static var brushStep                :BrushStep;
		private static var _width                   :int;
		private static var _height                  :int;
		private static var _previousColor           :uint=0xFFFFFFFF;
		private static var _previousSize            :int = 1;
		private static var _previousType            :String = HARD_BRUSH;
		private static var _currentBrushControl     :int;
		private static var endStroke                :Boolean = true;
		private static var newStroke                :Boolean = false;
		
		
		/**
		 * PARSE
		 * 
		 * @param	drwFile
		 * @param	width
		 * @param	height
		 * @return
		 */
		public static function parse( drwFile:ByteArray, width:int, height:int ):Array {
			_width = width;
			_height = height;
			return hashBrushSteps( drwFile );
		}
		
		/**
		 * HASH
		 * 
		 * @param	drwFile
		 * @return
		 */
		private static function hashBrushSteps( drwFile:ByteArray ):Array {
			var result:Array = [];
			for ( var i:int=1;i<(drwFile.length/4)-2;++i ) {
				var byte_index:int = i * 4;
				var byteStep:int = (drwFile[byte_index + 0] & 0xff) | ((drwFile[byte_index + 1] << 8) & 0xff00) | ((drwFile[byte_index + 2] << 16) & 0xff0000) | ((drwFile[byte_index + 3] << 24) & 0xff000000);
				
				if (i == 1) version = byteStep;
				else {
					brushStep = new BrushStep();
					brushStep.brushControl = getBrushControl( byteStep );
					brushStep.status = getStatus( byteStep, brushStep.brushControl );
					brushStep.alpha = getAlpha( byteStep );
					brushStep.opacity = getOpacity( byteStep );
					brushStep.type = getBrushType( byteStep, brushStep.status );
					brushStep.x = getX( byteStep );
					brushStep.y = getY( byteStep );
					brushStep.size = getSize( byteStep, brushStep.brushControl, brushStep.alpha, brushStep.opacity, brushStep.status );
					brushStep.color = getColor( byteStep, brushStep.alpha, brushStep.status );
					brushStep.flipX = getFlipX( byteStep, brushStep.status );
					brushStep.flipY = getFlipY( byteStep, brushStep.status );
					result[i-2] = brushStep;
				}
			}
			return result;
		}
		
		/**
		 * GET DATA
		 */
		private static function getStatus( step:int, brushControl:int ):String {
			var result:String;
			if ( (step & 0x3) == 0 ) {
				result = 'begin';
				if ( endStroke ) {
					endStroke = false;
					newStroke = true;
				} 
				else newStroke = false;
			} else if ( (step & 0x3) == 1 ) {
				result = 'end';
				endStroke = true;
			} else if ( (step & 0x3) == 2 ) {
				endStroke = true;
				newStroke = false;
				result = 'changeColor';
			} else if ( (step & 0x3) == 3 ) {
				_currentBrushControl = brushControl;
				endStroke = true;
				newStroke = false;
				result = 'changeSize';
			}
			return result;
		}
		
		private static function getX( step:int ):int { 
			return ((step >> 10) & 0x7FF) * (_width/1024) - _width/2;
		}
		
		private static function getY( step:int ):int { 
			return ((step >> 21) & 0x7FF) * ( _height/1024 ) - _height/2; 
		}
		
		private static function getAlpha( step:int ):int { 
			return (step >> 2) & 0xFF; 
		}
		
		private static function getSize( step:int, brushControl:int, alpha:int, opacity:int, status:String  ):Number {
			var result:Number;
			var size:Number;
			var minSize:Number;
			
			if ( status == 'changeSize' ) {
				result = ((step >> 2) & 0xFFFF) / 32768 * _width ;
				if ( result < 2 ) {
					result = 2; 
					if ( brushStep.alpha + 15 < 255 ) brushStep.alpha += 15;
				}
				_previousSize = result; 
			} 
			else result = _previousSize;
			
			if( version == 1002 ){
				//--full brush
				if ( _currentBrushControl == 0 ) brushStep.alpha = 255;
				//--variablesize brush
				if ( (_currentBrushControl & 0x2) != 0 && (_currentBrushControl & 0x1) == 0  ) {
					size = alpha * result / 255;
					minSize = _width / 256;
					if (size < minSize) size = minSize;
					result = size;
					brushStep.alpha = 255;
				} else if ( (_currentBrushControl & 0x2) != 0 && (_currentBrushControl & 0x1) != 0  ) {
					size = alpha * result / 255;
					minSize = _width / 256;
					if (size < minSize) size = minSize;
					result = size;
				}
			}	
			return result;
		}
		
		private static function getBrushControl( step:int ):int { 
			return (step >> 18) & 0x3 ; 
		}
		
		private static function getBrushType( step:int, status:String ):String {
			var result:String;
			if( status == 'changeSize' && version == 1002 ){
				if ( ((step >> 20) & 0x3) == 0 ){ result = HARD_BRUSH; }
				else if ( ((step >> 20) & 0x3) == 1 ){ result = SOFT_BRUSH; brushStep.alpha -= brushStep.opacity }
				_previousType = result;
			}
			else result = _previousType;
			return result;
		}
		
		private static function getOpacity( step:int ):int { 
			return (step >> 22) & 0xFF; 
		}
		
		private static function getFlipX( step:int, status:String ):Boolean {
			var result:Boolean;
			if ( status == 'changeColor') {
				if ( ((step >> 26) & 0x1) == 0 ) result=false;
				else if ( step >> 26 & 0x1 == 1 ) result=true;
			}
			return result;
		}
		
		private static function getFlipY( step:int, status:String ):Boolean {
			var result:Boolean;
			if ( status == 'changeColor') {
				if ( ((step >> 27) & 0x1) == 0 ) result=false;
				else if ( ((step >> 27) & 0x1) == 1 ) result=true;
			}
			return result;
		}
		
		private static function getColor( step:int, alpha:int, status:String ):uint {
			var result:uint;
			var a:int;
			var r:int;
			var g:int;
			var b:int;
			var color:uint;
			if ( alpha == 0 ) alpha = 255;
			if ( status == 'changeColor' ) {
				a = alpha;
				r = (step >> 18) & 0xff;
			 	g = (step >> 10) & 0xff;
				b = (step >> 2) & 0xff;
				color =  a << 24 | r << 16 | g << 8 | b;
				result = color;
				_previousColor = result;
			} else  { 
				a = alpha;
				r = _previousColor >>> 16 & 0xFF;
			 	g = _previousColor >>> 8 & 0xFF;
				b = _previousColor & 0xFF;
				color =  a << 24 | r << 16 | g << 8 | b;
				result = color;
				_previousColor = result; 
			}
			return result;
		}
	}	
}