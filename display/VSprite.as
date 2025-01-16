/**
* Virtual sprite
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.display 
{
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import railk.as3.geom.Bounds;
	
	public class VSprite extends EventDispatcher
	{
		public var name:String='undefined';
		public var parent:*;
		private var matrix:Matrix = new Matrix();
		private var childs:Array=[];
		
		private var origin:Point = new Point();
		private var end:Point = new Point();
		private var center:Point = new Point();
		private var reg:Point = new Point();
		private var _width:Number;
		private var _height:Number;
		private var _rotation:Number=0;
		private var _rotation2:Number = 0;
		private var _scaleX:Number=1;
		private var _scaleY:Number=1;
		private var _scaleX2:Number=0;
		private var _scaleY2:Number = 0;
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function VSprite(parent:*){
			this.parent = parent;
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							  ADDCHILD
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function addChild( child:*, scale:Boolean=true ):void {
			this.redefine(child);
			childs[childs.length] = child;
			parent.addChild( child );
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						   REMOVECHILD
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function getChildByName( name:String ):* {
			var i:int = childs.length;
			while( --i > -1 ) if ( childs[i].name == name ) return childs[i];
			return null;
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						   REMOVECHILD
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function removeChild( target:* ):Boolean {
			var i:int = childs.length;
			while ( --i > -1 ) {
				if ( childs[i] == target ) {
					childs.splice(i, 1);
					return true;
				}
			}
			return false;
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  	  TO ARRAY
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function changeRegistration(x:Number , y:Number):void {
			reg = new Point(x, y);
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  	  TO ARRAY
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function toArray():Array {
			return childs;
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  	 TO STRING
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		override public function toString():String {
			var i:int = childs.length, result:String = '[ VSPRITE > '+this.name+ '\n';
			while( --i > -1 ) result += childs[i].toString()+'\n';
			result += ' END VSPRITE ]'
			return result;
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  	 UTILITIES
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function redefine( child:* ):void {
			if ( !childs.length) {
				origin.x = child.x;
				origin.y = child.y;
			} else {
				//origin
				if ( child.x < origin.x ) origin.x = child.x; 
				if ( child.y < origin.y ) origin.y = child.y; 
				//end
				if ( child.x > end.x ) end.x = child.x; 
				if ( child.y > end.y ) end.y = child.y;
				//center
				reg.x = center.x = (end.x-origin.x)*.5;
				reg.y = center.y = (end.y - origin.y) * .5;
				//width/height
				_width = end.x -origin.x;
				_height = end.y -origin.y;
			}
		}
		
		private function replace(value:Number,type:String):void {
			var save:Point, i:int=childs.length;
			while( --i > -1 ) {
				switch( type ){
					case 'x' : case 'y' : childs[i][type] += value; break;
					case 'x2' : childs[i].x += value; break;
					case 'y2' : childs[i].y += value; break;
					case 'rotation' :
						save = origin.clone();
						this.x = 0;
						this.y = 0;
						rotate( childs[i], value );
						this.x = save.x;
						this.y = save.y;
						break;
					case 'rotation2' :
						save = center.clone();
						this.x2 = 0;
						this.y2 = 0;
						rotate( childs[i], value );
						this.x2 = save.x;
						this.y2 = save.y;
						break;
					case 'scaleX' : break;
					case 'scaleY' : break;
					case 'scaleX2' : break;
					case 'scaleY2' : break;
					default : break;
				}
			}
		}
		
		private function rotate(target:*,angle:Number):void {
			matrix.rotate( angle*(Math.PI/180) );
			var B:Point = matrix.transformPoint(new Point(target.x, target.y));
			target.x = B.x;
			target.y = B.y;
			target.rotation2 = angle;
			matrix.identity();
		}
		
		private function scale(value:Number, type:String):void
		{
			
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 GETTER/SETTER
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function get x():Number { return origin.x; }
		public function set x(value:Number):void { 
			var dist:Number = (center.x - origin.x);
			this.replace(value-origin.x, 'x');
			center.x = value + dist;
			origin.x = value;
		}
		
		public function get y():Number { return origin.y; }
		public function set y(value:Number):void { 
			var dist:Number = (center.y - origin.y);
			this.replace(value-origin.y, 'y');
			center.y = value + dist;
			origin.y = value;
		}
		
		public function get rotation():Number { return _rotation; }
		public function set rotation(value:Number):void { 
			this.replace(value,'rotation');
			_rotation = value; 
		}
		
		public function get scaleX():Number { return _scaleX; }
		public function set scaleX(value:Number):void { 
			this.replace(value-origin.y,'scaleX');
			_scaleX = value; 
		}
		
		public function get scaleY():Number { return _scaleY; }
		public function set scaleY(value:Number):void { 
			this.replace(value-origin.y,'scaleY');
			_scaleY = value; 
		}
		
		public function get x2():Number { return center.x; }
		public function set x2(value:Number):void { 
			var dist:Number = (reg.x - origin.x);
			this.replace((value-origin.x)-dist,'x2');
			origin.x = value-dist;
			reg.x = value;
		}
		
		public function get y2():Number { return center.y; }
		public function set y2(value:Number):void { 
			var dist:Number = (reg.y - origin.y);
			this.replace( (value-origin.y) - dist, 'y2');
			origin.y = value-dist;
			reg.y = value;
		}
		
		public function get rotation2():Number { return _rotation2; }
		public function set rotation2(value:Number):void { 
			this.replace(value,'rotation2');
			_rotation2 = value; 
		}
		
		public function get scaleX2():Number { return _scaleX2; }
		public function set scaleX2(value:Number):void { 
			this.replace(value-origin.y,'scaleX2');
			_scaleX2 = value; 
		}
		
		public function get scaleY2():Number { return _scaleY2; }
		public function set scaleY2(value:Number):void { 
			this.replace(value-origin.y,'scaleY2');
			_scaleY2 = value; 
		}
		
		public function get numChildren():int { return childs.length; }
		
		public function get width():Number { return _width }
		public function set width(value:Number):void { 
			//_name = value; 
		}
		
		public function get height():Number { return _height }
		public function set height(value:Number):void { 
			//_name = value; 
		}	
	}
}