package railk.as3.effect.fluid
{
	import flash.display.*;

	[SWF(width="465", height="465", backgroundColor="0xFFFFFF", frameRate="30")]

	public class Waves extends Sprite
	{
		function Waves()
		{
			for(var i:int = 0; i < 3; i++)
			{
				var wave:Wave = new Wave();
				wave.colors = 0xC63369+i*0x130-i*0x300000;
				wave.blendMode = "multiply";
				wave.y = i*6;
				addChild(wave);

				var box:Box = new Box(wave);
				box.blendMode = "multiply";
				box.x = 465/2 - 100+i*100;
				box.y = 50;
				addChild(box);
			}
		}
	}
}

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.geom.Point;

	class Box extends Sprite
	{
		private var wave:Wave;
		private var vx:Number = 0;
		private var vy:Number = 0;
		private var vr:Number = 0;

		function Box(wave:Wave)
		{
			this.wave = wave;

			graphics.beginFill(wave.colors);
			graphics.drawRect(-30, -60, 60, 60);
			addEventListener(Event.ENTER_FRAME, update);
		}

		private function update(e:Event):void
		{
			vy += 0.5;

			var depth:Number = wave.getDepth(x, y);
			if(depth > 0)
			{
				vy -= depth / 50;
				y -= depth / 20;

				var slope:Number = wave.getSlope(x);
				if(rotation < slope) {vr += 0.2;}
				if(rotation > slope) {vr -= 0.2;}

				rotation /= 1.05;
				if(depth < 25) {
					vx += rotation/50;
				}
				vx /= 1.2;
			}

			x += vx;
			y += vy;
			rotation += vr;
		}
	}

	class Wave extends Sprite
	{
		public const STAGE_W:uint = 465;
		public const STAGE_H:uint = 465;
		public const NUM:uint=300;	//頂点数

		private const MOUSE_DIFF_RATIO:Number=1;	// (0<) 大きい程マウスに反応する
		private const AUTO_INTERVAL:uint = 5000;	//オート波が起きる間隔 msec

		private var vertexes:Array=[];	//頂点
		private var mdlPt:Array=[];	//頂点の中点

		//頂点の基本波からの位相差分
		// 0:マウス
		// 1:オート
		private var diffPt:Array=[[], []];

		//波が起こるインデックス
		// 0:マウス
		// 1:オート
		private var startIndex:Array=[0,0];

		private var mouseOldY:int;
		private var mouseNewY:int;
		private var mouseDiff:Number = 0;
		private var mouseDiffGoal:Number= 0;

		private var autoTimer:Timer;
		private var autoDiff:Number = 0;

		public var colors:uint;

		function Wave()
		{
			for(var i:uint=0; i<NUM; i++)
			{
				var vertex:Vertex=new Vertex( i, this );
				vertexes.push( vertex );

				//中点作成
				if(i>1) {
					mdlPt.push( new Point( (vertexes[i-1].x+vertexes[i].x)*0.5, (vertexes[i-1].y+vertexes[i].y)*0.5 ) );
				}

				//差分
				diffPt[0].push( 0 );
				diffPt[1].push( 0 );

			}
			mouseNewY = mouseY;
			if(mouseNewY < 0) { mouseNewY = 0; }
			else if(mouseNewY > STAGE_H) { mouseNewY = STAGE_H; }

			mouseOldY = mouseNewY;

			addEventListener(Event.ENTER_FRAME, updateMouseDiff);
			addEventListener(Event.ENTER_FRAME, updateWave);

			autoTimer = new Timer(AUTO_INTERVAL);
			autoTimer.addEventListener(TimerEvent.TIMER, generateAutoWave);
			autoTimer.start();
		}


		private function generateAutoWave(tEvt:TimerEvent):void
		{
			autoDiff = 100;
			startIndex[1] = Math.round( Math.random()*(NUM-1) );
		}


		//--------------------------------------
		//	マウスY座標の差を計算
		//--------------------------------------
		private function updateMouseDiff(evt:Event):void
		{
			mouseOldY = mouseNewY;
			mouseNewY = mouseY;
			if(mouseNewY < 0) { mouseNewY = 0; }
			else if(mouseNewY > STAGE_H) { mouseNewY = STAGE_H; }

			mouseDiffGoal = (mouseNewY - mouseOldY) * MOUSE_DIFF_RATIO;
		}


		//---------------------------------------
		//	各種更新
		//---------------------------------------
		private function updateWave(evt:Event):void
		{
			graphics.clear();

			//それぞれの波の減衰
			mouseDiff -= (mouseDiff - mouseDiffGoal)*0.3;
			autoDiff -= autoDiff*0.3;


			//-------------------------------------
			//波の基点
			//-------------------------------------
			//マウス波
			startIndex[0] = getIndex(mouseX);
			diffPt[0][startIndex[0]] -= ( diffPt[0][startIndex[0]] - mouseDiff )*0.99;

			//オート波
			diffPt[1][startIndex[1]] -= ( diffPt[1][startIndex[1]] - autoDiff )*0.99;

			var i:int;

			//-------------------------------------
			//差分更新
			//-------------------------------------
			//マウス波
			//左側
			var d:uint;
			for(i=startIndex[0]-1; i >=0; i--)
			{
				d = startIndex[0] - i;
				if(d>15) { d=15; }
				diffPt[0][i] -= ( diffPt[0][i] - diffPt[0][i+1] )*(1-0.01*d);
			}
			//右側
			for(i=startIndex[0]+1; i < NUM; i++)
			{
				d = i - startIndex[0];
				if(d>15){ d=15; }
				diffPt[0][i] -= ( diffPt[0][i] - diffPt[0][i-1] )*(1-0.01*d);
			}

			//オート波
			//左側
			for(i=startIndex[1]-1; i >=0; i--)
			{
				d = startIndex[1] - i;
				if(d>15) { d=15; }
				diffPt[1][i] -= ( diffPt[1][i] - diffPt[1][i+1] )*(1-0.01*d);
			}
			//右側
			for(i=startIndex[1]+1; i < NUM; i++)
			{
				d = i - startIndex[1];
				if(d>15) { d=15; }
				diffPt[1][i] -= ( diffPt[1][i] - diffPt[1][i-1] )*(1-0.01*d);
			}

			//-------------------------------------
			//各頂点更新
			//-------------------------------------
			for(i=0; i < NUM; i++) { vertexes[i].updatePos( diffPt[0][i]+diffPt[1][i] ); }

			//-------------------------------------
			//中点更新
			//-------------------------------------
			for(i=0; i < NUM-2; i++) { mdlPt[i].y = (vertexes[i+1].y + vertexes[i+2].y)*0.5; }

			drawWave();
		}


		//---------------------------------------
		//	描画
		//---------------------------------------
		private function drawWave():void
		{
			graphics.beginFill(colors, 1);

			graphics.moveTo(STAGE_W, STAGE_H);
			graphics.lineTo(0, STAGE_H);
			graphics.lineTo( vertexes[0].x, vertexes[0].y);
			graphics.curveTo( vertexes[1].x, vertexes[1].y, mdlPt[0].x, mdlPt[0].y);

			for(var i:uint=2; i<NUM-2; i++) {
				graphics.curveTo( vertexes[i].x, vertexes[i].y, mdlPt[i-1].x, mdlPt[i-1].y);
			}
			graphics.curveTo( vertexes[NUM-2].x, vertexes[NUM-2].y, vertexes[NUM-1].x, vertexes[NUM-1].y);

			graphics.endFill();
		}

		private function getIndex(pos:Number):int
		{
			if(pos < 0) { pos = 0; }
			else if(pos > STAGE_W-2) { pos = STAGE_W-2; }	//-2はみ出さないための保険

			return 1+Math.floor( (NUM-2) * pos / STAGE_W );
		}

		public function getDepth(x:Number, y:Number):Number
		{
			return y - vertexes[getIndex(x)].y;
		}

		public function getSlope(pos:Number):Number
		{
			var vl:Vertex = vertexes[Math.max(0, Math.min(getIndex(pos), NUM-2))]
			var vr:Vertex = vertexes[Math.max(0, Math.min(getIndex(pos), NUM-2) + 1)]

			return Math.atan2(vr.y - vl.y, vr.x - vl.x) * 180 / Math.PI;
		}
	}


	class Vertex
	{
		private static const BASE_Y:uint = 250;
		private static const BASE_R:uint = 10;
		private static const PI:Number = Math.PI;
		private static const FRICTION:Number = 0.1;
		private static const DECELERATION:Number = 0.85;
		private static const SPEED_OF_BASE_WAVE:uint = 2;

		private var theta:uint=0;
		private var goalY:Number=0;
		private var amp:Number=0;
		public var x:Number;
		public var y:Number;


		function Vertex(prmID:uint, parent:Object)
		{
			theta =  360 * prmID/( parent.NUM-1) ;
			x = prmID * parent.STAGE_W / (parent.NUM-1);
			y = BASE_Y +  BASE_R * Math.sin( theta * PI /180  );
		}


		public function updatePos(diffVal:Number):void
		{
			theta += SPEED_OF_BASE_WAVE;
			if( theta>=360 ) { theta -= 360; }

			goalY = BASE_Y +  BASE_R * Math.sin( theta * PI /180  );
			goalY += diffVal;


			amp += goalY - y;
			y += amp * FRICTION;
			amp *= DECELERATION;
		}
	}