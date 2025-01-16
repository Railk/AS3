/**
 * Repere de coordonnées multiple
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.geom 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class MultiCoordinateSystem 
	{
		public var TL:Point;
		public var T:Point;
		public var TR:Point;
		public var R:Point;
		public var BR:Point;
		public var B:Point;
		public var BL:Point;
		public var L:Point;
		public var CENTER:Point;
		public var REG:Point;
		
		private var systems:Dictionary = new Dictionary(true);
		private var transformedPoints:Object = { TL:null, L:null, BL:null, B:null, BR:null, R:null, TR:null, T:null, CENTER:null, REG:null, dx:null, dy:null };
		
		
		public function MultiCoordinateSystem(TL:Point=null, L:Point=null, BL:Point=null, B:Point=null, BR:Point=null, R:Point=null, TR:Point=null, T:Point=null, CENTER:Point=null, REG:Point=null) {
			if ( TL && L && BL && B && BR && R && TR && T && REG && CENTER) define(TL, L, BL, B, BR, R, TR, T, CENTER, REG);
		}
		
		public function define( TL:Point, L:Point, BL:Point, B:Point, BR:Point, R:Point, TR:Point, T:Point, CENTER:Point, REG:Point ):void {
			this.TL = TL;
			this.BL = BL;
			this.BR = BR;
			this.TR = TR
			this.T = T;
			this.B = B;
			this.L = L;
			this.R = R;
			this.CENTER = CENTER;
			this.REG = REG;
			this.defineSystems();
		}
		
		private function defineSystems():void {
			systems['TL'] = { BL:{p:new Point2D(TL.x,TL.y,new CoordinateSystem(BL,B,TL)),axis:'xAxis'}, TR:{p:new Point2D(TL.x,TL.y,new CoordinateSystem(BR,B,TR)),axis:'yAxis'} };
			systems['BL'] = { TL:{p:new Point2D(BL.x,BL.y,new CoordinateSystem(TL,T,BL)),axis:'xAxis'}, BR:{p:new Point2D(BL.x,BL.y,new CoordinateSystem(TR,T,BR)),axis:'yAxis'} };
			systems['TR'] = { TL:{p:new Point2D(TR.x,TR.y,new CoordinateSystem(TL,T,BL)),axis:'yAxis'}, BR:{p:new Point2D(TR.x,TR.y,new CoordinateSystem(BL,BR,TL)),axis:'xAxis'} };
			systems['BR'] = {  BL:{p:new Point2D(TL.x,TL.y,new CoordinateSystem(BL,B,TL)),axis:'yAxis'}, TR:{p:new Point2D(TL.x,TL.y,new CoordinateSystem(TR,TL,BR)),axis:'xAxis'} };
			systems['T'] = { T:{p:new Point2D(T.x,T.y,new CoordinateSystem(B,BL,T)),axis:'yAxis'}, TL:{p:new Point2D(T.x,T.y,new CoordinateSystem(BL,B,TL)),axis:'yAxis'}, TR:{p:new Point2D(T.x,T.y,new CoordinateSystem(BR,B,TR)),axis:'yAxis'} };
			systems['B'] = { B:{p:new Point2D(B.x,B.y,new CoordinateSystem(T,TL,B)),axis:'yAxis'}, BL:{p:new Point2D(B.x,B.y,new CoordinateSystem(TL,T,BL)),axis:'yAxis'}, BR:{p:new Point2D(B.x,B.y,new CoordinateSystem(TR,T,BR)),axis:'yAxis'} };
			systems['L'] = { L:{p:new Point2D(L.x,L.y,new CoordinateSystem(R,L,TR)),axis:'xAxis'}, TL:{p:new Point2D(L.x,L.y,new CoordinateSystem(TR,TL,R)),axis:'xAxis'}, BL:{p:new Point2D(L.x,L.y,new CoordinateSystem(BR,BL,R)),axis:'xAxis'} };
			systems['R'] = { R:{p:new Point2D(R.x,R.y,new CoordinateSystem(L,R,TL)),axis:'xAxis'}, TR:{p:new Point2D(R.x,R.y,new CoordinateSystem(TL,TR,L)),axis:'xAxis'}, BR:{p:new Point2D(R.x,R.y,new CoordinateSystem(BL,BR,L)),axis:'xAxis'} };
		}
		
		public function project( target:String, coordinate:Point ):Object {
			var result:Object={};
			var points:Object = systems[target];
			var v:Vector2D;
			switch( target )
			{
				case 'T' :
					result = projectPoints( points,coordinate );
					v = new Vector2D(B, result.T);
					result['CENTER'] = new Point(B.x+v.dx*.5, B.y+v.dy*.5);
					result['L'] = (new Point2D(B.x+v.dx*.5,B.y+v.dy*.5, new CoordinateSystem(L,R,TL))).yProjection;
					result['R'] = (new Point2D(B.x+v.dx*.5,B.y+v.dy*.5, new CoordinateSystem(R,L,TR))).yProjection;
					result['REG'] = this.getInnerSystemPoint( REG, { n:result.TR, o:TR }, { n:result.TL, o:TL }, { n:BR, o:BR } );
					result['dy'] = ((new Vector2D(result.T, T)).dy < 0)?-(new Vector2D(result.T, T)).distance:(new Vector2D(result.T, T)).distance;
					break;
				
				case 'B' :
					result = projectPoints( points,coordinate );
					v = new Vector2D(T, result.B);
					result['CENTER'] = new Point(T.x+v.dx*.5, T.y+v.dy*.5);
					result['L'] = (new Point2D(T.x+v.dx*.5,T.y+v.dy*.5, new CoordinateSystem(L,R,TL))).yProjection;
					result['R'] = (new Point2D(T.x+v.dx*.5,T.y+v.dy*.5, new CoordinateSystem(R,L,TR))).yProjection;
					result['REG'] = this.getInnerSystemPoint( REG, { n:result.BR, o:BR }, { n:result.BL, o:BL }, { n:TR, o:TR } );
					result['dy'] = ((new Vector2D(result.B, B)).dy < 0)?-(new Vector2D(result.B, B)).distance:(new Vector2D(result.B, B)).distance;
					break;
					
				case 'L' :
					result = projectPoints( points,coordinate );
					v = new Vector2D(R, result.L);
					result['CENTER'] = new Point(R.x+v.dx*.5, R.y+v.dy*.5);
					result['T'] = (new Point2D(R.x+v.dx*.5,R.y+v.dy*.5, new CoordinateSystem(T,TL,B))).xProjection;
					result['B'] = (new Point2D(R.x+v.dx*.5,R.y+v.dy*.5, new CoordinateSystem(B,BL,T))).xProjection;
					result['REG'] = this.getInnerSystemPoint( REG, { n:result.BL, o:BL }, { n:BR, o:BR }, { n:result.TL, o:TL } );
					result['dx'] = ((new Vector2D(result.L, L)).dx < 0)?-(new Vector2D(result.L, L)).distance:(new Vector2D(result.L, L)).distance;
					break;
				
				case 'R' :
					result = projectPoints( points,coordinate );
					v = new Vector2D(L, result.R);
					result['CENTER'] = new Point(L.x+v.dx*.5, L.y+v.dy*.5);
					result['T'] = (new Point2D(L.x+v.dx*.5,L.y+v.dy*.5, new CoordinateSystem(T,TL,B))).xProjection;
					result['B'] = (new Point2D(L.x+v.dx*.5,L.y+v.dy*.5, new CoordinateSystem(B,BL,T))).xProjection;
					result['REG'] = this.getInnerSystemPoint( REG, { n:result.BR, o:BR }, { n:BL, o:BL }, { n:result.TR, o:TR } );
					result['dx'] = ((new Vector2D(result.R, R)).dx < 0)?-(new Vector2D(result.R, R)).distance:(new Vector2D(result.R, R)).distance;
					break;
				
				case 'TL' :
					result = projectPoints( points, coordinate );
					result['TL'] = coordinate;
					v = new Vector2D(BR, result.TL);
					result['CENTER'] = new Point(BR.x+v.dx*.5, BR.y+v.dy*.5);
					result['R'] = (new Point2D(BR.x+v.dx*.5,BR.y+v.dy*.5, new CoordinateSystem(R,L,TR))).yProjection;
					result['B'] = (new Point2D(BR.x+v.dx*.5,BR.y+v.dy*.5, new CoordinateSystem(B,BL,T))).xProjection;
					result['L'] = (new Point2D(result.R.x,result.R.y, new CoordinateSystem(result.TL,result.TR,result.BL))).yProjection;
					result['T'] = (new Point2D(result.B.x,result.B.y, new CoordinateSystem(result.TR,result.TL,BR))).xProjection;
					result['REG'] = this.getInnerSystemPoint( REG, { n:result.TL, o:TL }, { n:result.TR, o:TR }, { n:result.BL, o:BL } );
					result['dy'] = ((new Vector2D(result.TR, TR)).dy < 0)?-(new Vector2D(result.TR, TR)).distance:(new Vector2D(result.TR, TR)).distance;
					result['dx'] = ((new Vector2D(result.BL, BL)).dx < 0)?-(new Vector2D(result.BL, BL)).distance:(new Vector2D(result.BL, BL)).distance;
					break;
					
				case 'BL' :
					result = projectPoints( points, coordinate );
					result['BL'] = coordinate;
					v = new Vector2D(TR, result.BL);
					result['CENTER'] = new Point(TR.x+v.dx*.5, TR.y+v.dy*.5);
					result['R'] = (new Point2D(TR.x+v.dx*.5,TR.y+v.dy*.5, new CoordinateSystem(R,L,TR))).yProjection;
					result['T'] = (new Point2D(TR.x+v.dx*.5,TR.y+v.dy*.5, new CoordinateSystem(T,TL,B))).xProjection;
					result['L'] = (new Point2D(result.R.x,result.R.y, new CoordinateSystem(result.TL,TR,result.BL))).yProjection;
					result['B'] = (new Point2D(result.T.x,result.T.y, new CoordinateSystem(result.BR,result.BL,TR))).xProjection;
					result['REG'] = this.getInnerSystemPoint( REG, { n:result.BL, o:BL }, { n:result.TL, o:TL }, { n:result.BR, o:BR } );
					result['dy'] = ((new Vector2D(result.BR, BR)).dy < 0)?-(new Vector2D(result.BR, BR)).distance:(new Vector2D(result.BR, BR)).distance;
					result['dx'] = ((new Vector2D(result.TL, TL)).dx < 0)?-(new Vector2D(result.TL, TL)).distance:(new Vector2D(result.TL, TL)).distance;
					break;
				
				case 'TR' :
					result = projectPoints( points, coordinate );
					result['TR'] = coordinate;
					v = new Vector2D(BL, result.TR);
					result['CENTER'] = new Point(BL.x+v.dx*.5, BL.y+v.dy*.5);
					result['B'] = (new Point2D(BL.x+v.dx*.5,BL.y+v.dy*.5, new CoordinateSystem(B,BL,T))).xProjection;
					result['L'] = (new Point2D(BL.x+v.dx*.5,BL.y+v.dy*.5, new CoordinateSystem(L,R,TL))).yProjection;
					result['R'] = (new Point2D(result.L.x,result.L.y, new CoordinateSystem(result.TR,result.TL,result.BR))).yProjection;
					result['T'] = (new Point2D(result.B.x,result.B.y, new CoordinateSystem(result.TL,result.TR,BL))).xProjection;
					result['REG'] = this.getInnerSystemPoint( REG, { n:result.TR, o:TR }, { n:result.TL, o:TL }, { n:result.BR, o:BR } );
					result['dy'] = ((new Vector2D(result.TL, TL)).dy < 0)?-(new Vector2D(result.TL, TL)).distance:(new Vector2D(result.TL, TL)).distance;
					result['dx'] = ((new Vector2D(result.BR, BR)).dx < 0)?-(new Vector2D(result.BR, BR)).distance:(new Vector2D(result.BR, BR)).distance;
					break;
				
				case 'BR' :
					result = projectPoints( points, coordinate );
					result['BR'] = coordinate;
					v = new Vector2D(TL, result.BR);
					result['CENTER'] = new Point(TL.x+v.dx*.5, TL.y+v.dy*.5);
					result['T'] = (new Point2D(TL.x+v.dx*.5,TL.y+v.dy*.5, new CoordinateSystem(T,TL,B))).xProjection;
					result['L'] = (new Point2D(TL.x+v.dx*.5,TL.y+v.dy*.5, new CoordinateSystem(L,R,TL))).yProjection;
					result['R'] = (new Point2D(result.L.x,result.L.y, new CoordinateSystem(result.TR,TL,result.BR))).yProjection;
					result['B'] = (new Point2D(result.T.x, result.T.y, new CoordinateSystem(result.BR, result.BL, result.TR))).xProjection;
					result['REG'] = this.getInnerSystemPoint( REG, { n:result.BR, o:BR }, { n:result.BL, o:BL }, { n:result.TR, o:TR } );
					result['dy'] = ((new Vector2D(result.BL, BL)).dy < 0)?-(new Vector2D(result.BL, BL)).distance:(new Vector2D(result.BL, BL)).distance;
					result['dx'] = ((new Vector2D(result.TR, TR)).dx < 0)?-(new Vector2D(result.TR, TR)).distance:(new Vector2D(result.TR, TR)).distance;
					break;
					
				default : break;
			}
			transformedPoints = { TL:((result.TL)?result.TL:TL), L:((result.L)?result.L:L), BL:((result.BL)?result.BL:BL), B:((result.B)?result.B:B), BR:((result.BR)?result.BR:BR), R:((result.R)?result.R:R), TR:((result.TR)?result.TR:TR), T:((result.T)?result.T:T), CENTER:((result.CENTER)?result.CENTER:CENTER), REG:((result.REG)?result.REG:REG), dx:((result.dx)?result.dx:0), dy:((result.dy)?result.dy:0) };
			return transformedPoints;
		}
		
		private function projectPoints( points:Object, coordinate:Point ):Object {
			var result:Object = {};
			for ( var point:String in points )
			{
				var axis:String = points[point].axis;
				var p:Point2D = points[point].p;
				p.x = coordinate.x;
				p.y = coordinate.y;
				result[point] = (axis=='xAxis')?p.xProjection:p.yProjection;
			}
			return result;
		}
		
		private function getInnerSystemPoint( p:Point, origin:Object, x:Object, y:Object ):Point {
			var xReg = (new Point2D(x.o.x + (new Vector2D(x.o, p)).dx * ((new Vector2D( x.n, origin.n)).dx / (new Vector2D(x.o, origin.o)).dx), x.o.y + (new Vector2D(x.o, p)).dy *( (((new Vector2D( x.n, origin.n)).dy / (new Vector2D(x.o, origin.o)).dy))?((new Vector2D( x.n, origin.n)).dy / (new Vector2D(x.o, origin.o)).dy):1 ) , new CoordinateSystem(origin.n, x.n, y.n))).xProjection;
			var yReg = (new Point2D(y.o.x + (new Vector2D(y.o, p)).dx * ( ((new Vector2D( y.n, origin.n)).dx / (new Vector2D(y.o, origin.o)).dx)?((new Vector2D( y.n, origin.n)).dx / (new Vector2D(y.o, origin.o)).dx):1 ), y.o.y + (new Vector2D(y.o, p)).dy * ((new Vector2D( y.n, origin.n)).dy / (new Vector2D(y.o, origin.o)).dy), new CoordinateSystem(origin.n, x.n, y.n))).yProjection;
			var v1:Vector2D = new Vector2D(origin.n, xReg);
			var v2:Vector2D = new Vector2D(origin.n, yReg);
			return new Point(origin.n.x+v1.dx+v2.dx,origin.n.y+v1.dy+v2.dy);
		}
		
		public function update(...args):void {
			this.TL = transformedPoints.TL;
			this.BL = transformedPoints.BL;
			this.BR = transformedPoints.BR;
			this.TR = transformedPoints.TR
			this.T = transformedPoints.T;
			this.B = transformedPoints.B;
			this.L = transformedPoints.L;
			this.R = transformedPoints.R;
			this.CENTER = transformedPoints.CENTER;
			this.REG = transformedPoints.REG;
			this.defineSystems();
		}
		
		public function toString():String {
			var result:String = '[ MULTI COORDINATESYSTEM \n';
			for ( var key:String in systems)
			{
				result += systems[key].system.toString();
			}	
			result +='\n'
			result += ' ]';
			return result
		}
	}
}