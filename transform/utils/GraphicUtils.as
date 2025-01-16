package railk.as3.transform.utils {
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import railk.as3.display.DSprite;
	import railk.as3.display.drawingShape.DrawingShape;
	import railk.as3.display.GraphicShape;
	
    public class GraphicUtils extends Sprite
    {	
		public static function rotate(x,y,outerRadius:Number, innerRadius:Number):GraphicShape
		{
			var rotate:GraphicShape = new GraphicShape();
			rotate.camembert( 0x000000, 0, 0, outerRadius, 0, 360, 22, innerRadius);
			rotate.x = x;
			rotate.y = y;
			rotate.alpha = .25;
			return rotate;
		}
		
		public static function corner(color:uint,x:Number,y:Number,rotation:Number):DrawingShape
		{
			var corner:DrawingShape = new DrawingShape();
			var data:Object =  { 
				width:14, height:14,  pixels:[ 
					[0xFFFFFF,1],1,1,1,1,1,1,1,1,1,1,1,1,1,
					[0xFFFFFF,1],1,1,1,1,1,1,1,1,1,1,1,[color,1],[0xFFFFFF,1],
					1,[color,1],1,1,1,1,1,1,1,1,1,1,1,[0xFFFFFF,1],
					[0xFFFFFF,1],1,1,1,1,1,1,1,1,1,1,1,[color,1],[0xFFFFFF,1],
					1,[color,1],1,1,[0xFFFFFF,1],1,1,1,1,1,1,1,1,1,
					[0xFFFFFF,1],1,1,[color,1],[0xFFFFFF,1],0,0,0,0,0,0,0,0,0,
					1,[color,1],1,1,[0xFFFFFF,1],0,0,0,0,0,0,0,0,0,
					[0xFFFFFF,1],1,1,[color,1],[0xFFFFFF,1],0,0,0,0,0,0,0,0,0,
					1,[color,1],1,1,[0xFFFFFF,1],0,0,0,0,0,0,0,0,0,
					[0xFFFFFF,1],1,1,[color,1],[0xFFFFFF,1],0,0,0,0,0,0,0,0,0,
					1,[color,1],1,1,[0xFFFFFF,1],0,0,0,0,0,0,0,0,0,
					[0xFFFFFF,1],1,1,[color,1],[0xFFFFFF,1],0,0,0,0,0,0,0,0,0,
					1,[color,1],1,1,[0xFFFFFF,1],0,0,0,0,0,0,0,0,0,
					1,1,1,1,1,0,0,0,0,0,0,0,0,0
				] 
			}; 
			corner.drawPixelGraphicsShape( data );
			corner.setRegistration(6, 6);
			corner.rotation2 = rotation;
			corner.x2 = x;
			corner.y2 = y;
			corner.alpha = .7;
			return corner;
		}
		
		public static function cornerSelected(x:Number,y:Number,rotation:Number):DrawingShape
		{
			var corner:DrawingShape = new DrawingShape();
			var data:Object =  { 
				width:24, height:23,  pixels:[ 
					0,0,0,0,0,0,0,0,0,0,0,[0xFFFFFFFF,1],1,1,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,0,[0xFFFFFFFF,1],1,1,[0xFF000000,1],1,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,1,[0xFF000000,1],1,1,1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,[0xFFFFFFFF,1],1,1,1,1,1,1,[0xFF000000,1],1,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,1,[0xFF000000,1],1,1,1,1,1,1,1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,
					0,0,0,0,0,0,[0xFFFFFFFF,1],1,1,1,1,1,1,1,1,1,1,[0xFF000000,1],1,0,0,0,0,0,
					0,0,0,0,0,1,[0xFF000000,1],1,1,1,1,1,1,1,1,1,1,1,1,[0xFFFFFFFF,1],0,0,0,0,
					0,0,0,0,[0xFFFFFFFF,1],1,1,1,1,1,1,1,1,1,1,1,1,1,1,[0xFF000000,1],1,0,0,0,
					0,0,0,1,[0xFF000000,1],1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,[0xFFFFFFFF,1],0,0,
					0,0,[0xFFFFFFFF,1],1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,[0xFF000000,1],1,0,
					0,1,[0xFF000000,1],1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					[0xFFFFFFFF,1],1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					1,[0xFF000000,1],1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					[0xFFFFFFFF,1],1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,1,[0xFF000000,1],1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,[0xFFFFFFFF,1],1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,1,[0xFF000000,1],1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,[0xFFFFFFFF,1],1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,1,[0xFF000000,1],1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,[0xFFFFFFFF,1],1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,1,[0xFF000000,1],1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,[0xFFFFFFFF,1],1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
				] 
			}; 
			corner.drawPixelArrayShape( data );
			corner.setRegistration(11, 11);
			corner.rotation2 = rotation;
			corner.x2 = x;
			corner.y2 = y;
			corner.alpha = .25;
			return corner;
		}
		
		public static function border(x:Number,y:Number,rotation:Number):DrawingShape
		{
			var border:DrawingShape = new DrawingShape();
			var data:Object =  { 
				width:10, height:19, pixels:[ 
					[0xFFFFFF,1],1,1,1,1,1,0,0,0,0,
					[0xFFFFFF,1],1,1,1,[0x000000,1],[0xFFFFFF,1],0,0,0,0,
					1,[0x000000,1],1,1,1,[0xFFFFFF,1],0,0,0,0,
					[0xFFFFFF,1],1,1,1,[0x000000,1],[0xFFFFFF,1],0,0,0,0,
					1,[0x000000,1],1,1,1,[0xFFFFFF,1],0,0,0,0,
					[0xFFFFFF,1],1,1,1,[0x000000,1],[0xFFFFFF,1],0,0,0,0,
					1,[0x000000,1],1,1,1,[0xFFFFFF,1],1,1,1,1,
					[0xFFFFFF,1],1,1,1,1,1,1,1,[0x000000,1],[0xFFFFFF,1],
					1,[0x000000,1],1,1,1,1,1,1,1,[0xFFFFFF,1],
					[0xFFFFFF,1],1,1,1,1,1,1,1,[0x000000,1],[0xFFFFFF,1],
					1,[0x000000,1],1,1,1,1,1,1,1,[0xFFFFFF,1],
					[0xFFFFFF,1],1,1,1,1,1,1,1,[0x000000,1],[0xFFFFFF,1],
					1,[0x000000,1],1,1,1,[0xFFFFFF,1],1,1,1,1,
					[0xFFFFFF,1],1,1,1,[0x000000,1],[0xFFFFFF,1],0,0,0,0,
					1,[0x000000,1],1,1,1,[0xFFFFFF,1],0,0,0,0,
					[0xFFFFFF,1],1,1,1,[0x000000,1],[0xFFFFFF,1],0,0,0,0,
					1,[0x000000,1],1,1,1,[0xFFFFFF,1],0,0,0,0,
					[0xFFFFFF,1],1,1,1,[0x000000,1],[0xFFFFFF,1],0,0,0,0,
					1,1,1,1,1,1,0,0,0,0
				] 
			}; 
			border.drawPixelGraphicsShape( data );
			border.setRegistration(6, 9);
			border.rotation2 = rotation;
			border.x2 = x;
			border.y2 = y;
			border.alpha = .7;
			return border;
		}
		
		public static function borderSelected(x:Number,y:Number,rotation:Number):DrawingShape
		{
			var borderSel:DrawingShape = new DrawingShape();
			var data:Object =  { 
				width:10, height:19, pixels:[ 
					0,[0xFFFFFFFF,1],1,1,1,1,1,1,1,1,
					1,[0xFFFFFFFF,1],1,1,1,1,1,1,1,[0xFF000000,1],
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],1,[0xFF000000,1],1,1,1,1,1,1,1,
					0,[0xFFFFFFFF,1],1,1,1,1,1,1,1,1
				] 
			}; 
			borderSel.drawPixelArrayShape( data );
			borderSel.setRegistration(10, 9);
			borderSel.rotation2 = rotation;
			borderSel.x2 = x;
			borderSel.y2 = y;
			borderSel.alpha = .25;
			return borderSel;
		}
		
		public static function plus():DrawingShape
		{
			var plus:DrawingShape = new DrawingShape();
			var data:Object =  { 
				width:8, height:8, pixels:[ 
					0,0,0,[0xFFFFFFFF,1],1,0,0,0,
					0,0,[0xFFFFFFFF,1],1,[0xFF000000,1],1,0,0,
					0,1,1,[0xFF000000,1],1,[0xFFFFFFFF,1],1,0,
					[0xFFFFFFFF,1],1,1,1,1,1,[0xFF000000,1],1,
					1,[0xFF000000,1],1,1,1,1,1,[0xFFFFFFFF,1],
					0,1,[0xFFFFFFFF,1],1,[0xFF000000,1],1,1,0,
					0,0,1,[0xFF000000,1],1,[0xFFFFFFFF,1],0,0,
					0,0,0,1,1,0,0,0
				] 
			}; 
			plus.drawPixelArrayShape( data );
			plus.setRegistration( 4, 4);
			return plus;
		}
		
		public static function moins():DrawingShape
		{
			var moins:DrawingShape = new DrawingShape();
			var data:Object =  { 
				width:9, height:4, pixels:[ 
					0,[0xFFFFFFFF,1],1,1,1,1,1,1,0,
					[0xFFFFFFFF,1],1,1,1,1,1,1,[0xFF000000,1],1,
					1,[0xFF000000,1],1,1,1,1,1,1,[0xFFFFFFFF,1],
					0,1,1,1,1,1,1,1,0
				] 
			}; 
			moins.drawPixelArrayShape( data );
			moins.setRegistration(4, 2);
			return moins;
		}
		
		public static function regPoint(x:Number,y:Number):DSprite
		{
			var regPoint:DSprite = new DSprite();
			regPoint.graphics.lineStyle(.5,0xFFFFFF,1);
			regPoint.graphics.beginFill(0x000000, 1);
			regPoint.graphics.drawCircle(0, 0, 6);
			regPoint.graphics.drawCircle(0, 0, 3);
			regPoint.graphics.drawCircle(0, 0, 1.5);
			regPoint.graphics.endFill();
			regPoint.alpha = .8;
			regPoint.setRegistration(0,0);
			regPoint.x2 = x;
			regPoint.y2 = y;
			return regPoint;
		}
		
		public static function contour(x:Number,y:Number,w:Number,h:Number):Sprite
		{
			var contour:Sprite = new Sprite();
			contour.graphics.lineStyle( 1, 0x000000, 1,true,'normal','square','miter' );
			contour.graphics.moveTo(x-1, y-1);
			contour.graphics.lineTo(x+w, y-1);
			contour.graphics.lineTo(x+w, y+h);
			contour.graphics.lineTo(x-1, y+h);
			contour.graphics.lineTo(x - 1, y - 1);
			contour.alpha = .12;
			return contour;
		}
		
		public static function bg(x:Number,y:Number,w:Number,h:Number):Sprite
		{
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0x000000,.5);
			bg.graphics.moveTo(x, y);
			bg.graphics.lineTo(x+w, y);
			bg.graphics.lineTo(x+w, y+h);
			bg.graphics.lineTo(x, y+h);
			bg.graphics.lineTo(x, y);
			bg.graphics.endFill();
			return bg;
		}
		
		public static function hover():GraphicShape
		{
			var hover:GraphicShape = new GraphicShape();
			hover.alpha = 0;
			hover.cercle(0xFF0000, 0, 0, 12);
			return hover;
		}
		
		public static function skewBorder(x:Number,y:Number,w:Number,h:Number,constraint:String):GraphicShape
		{ 
			var border:GraphicShape = new GraphicShape()
			border.rectangle(0xFF0000, 0, 0, w, h);
			if (constraint == 'LEFT') border.setRegistration(w, 0);
			else if (constraint == 'TOP') border.setRegistration(0, h);
			else border.setRegistration(0, 0);
			border.x2 = x;
			border.y2 = y;
			border.alpha = .5;
			return border;
		}
	}
}	