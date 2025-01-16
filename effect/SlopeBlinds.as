package railk.as3.effect
{
	import flash.display.* ;
	import flash.events.* ;
	import flash.filters.ColorMatrixFilter ;
	import flash.net.* ;
	import flash.system.* ;
	import flash.utils.getTimer ;
	import flash.geom.ColorTransform ;
	import caurina.transitions.Tweener ;
	
	public class SlopeBlinds extends Sprite
	{
		private var _loader:Loader ;
		private var _loaderInfo:LoaderInfo ;
		private var _maskList:SlopeBlindsMask ;
		
		private var _canvas:BitmapData ;
		private var _startTime:int ;
		
		public function SlopeBlindsEffect( )
		{
			init( ) ;
		}
		
		private function init( ):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE ;
			stage.align = StageAlign.TOP_LEFT ;
			//stage.quality = StageQuality.LOW ;
			
			Security.loadPolicyFile( "http://www.twist-cube.com/wonderfl/crossdomain.xml" ) ;
			
			var loaderContext:LoaderContext = new LoaderContext( ) ;
			loaderContext.checkPolicyFile = true ;
			
			_loader = new Loader( ) ;
			_loader.load( new URLRequest( "http://www.twist-cube.com/wonderfl/logo03.png" ), loaderContext ) ;
			
			_loaderInfo = _loader.contentLoaderInfo ;
			_loaderInfo.addEventListener( Event.COMPLETE, onLoadComplete ) ;
		}
		
		private function onLoadComplete( event:Event ):void
		{
			_loaderInfo.removeEventListener( Event.COMPLETE, onLoadComplete ) ;
			
			var nStartX:Number = Math.floor( ( stage.stageWidth - _loader.width ) / 2 ) ;
			var nStartY:Number = Math.floor( ( stage.stageHeight - _loader.height ) / 2 ) ;
			
			var MASK_NUM:uint = 25 ; // Blindの数
			var MASK_ANGLE:Number = 45 ; // Blindの角度
			_maskList = new SlopeBlindsMask( _loader, MASK_NUM, MASK_ANGLE ) ;
			
			var mainContainer:Sprite = new Sprite( ) ;
			mainContainer.x = nStartX ;
			mainContainer.y = nStartY ;
			addChild( mainContainer )
			
			var maskContainer:Sprite = new Sprite( ) ;
			maskContainer.x = nStartX ;
			maskContainer.y = nStartY ;
			maskContainer.rotation = MASK_ANGLE ;
			addChild( maskContainer ) ;
			
			mainContainer.addChild( _loader ) ;
			_loader.mask = maskContainer ;
			
			var mask_sp:Sprite ;
			var nLength:uint = _maskList.list.length ;
			for ( var i:uint = 0; i < nLength; i++ )
			{
				mask_sp = _maskList.list[ i ] ;
				maskContainer.addChild( mask_sp ) ;
				
				var nTarget:Number = mask_sp.width ;
				mask_sp.width = 0 ;
				
				Tweener.addTween(
					mask_sp, 
					{
						width : nTarget,
						time  : .7,
						delay : .05 * i,
						transition : "easeOutQuad"
					}
				) ;
			}
		}
	}
}


import flash.display.* ;
import flash.geom.Rectangle ;

class SlopeBlindsMask
{
	private var _originImage:DisplayObject ;
	private var _num:uint ;
	private var _rot:Number ;
	private var _list:Array = new Array( ) ;
	
	public function SlopeBlindsMask( _originImage:DisplayObject, _num:uint, _rot:Number )
	{
		this._originImage = _originImage ;
		this._num = _num ;
		this._rot = _rot ;
		init( ) ;
	}
	
	private function init( ):void
	{
		var size:Object = getMaskSize( ) ;		
		var mask_sp:Sprite = new Sprite( ) ;
		var nW2:Number = size.width / _num ;
		for ( var i:uint = 0; i < _num; i++ )
		{
			mask_sp = new Sprite( ) ;
			mask_sp.y = -_originImage.width * Math.sin( _rot * Math.PI / 180 ) ;
			mask_sp.x = nW2 * i ;
			// mask_sp.alpha = 0.3
			mask_sp.graphics.beginFill( 0xFFFFFF * Math.random( ) ) ;
			mask_sp.graphics.drawRect( 0, 0, Math.ceil( nW2 ), size.height ) ;
			mask_sp.graphics.endFill( ) ;
			list.push( mask_sp ) ;
		}
	}
	
	private function getMaskSize( ):Object {
		var container:Sprite = new Sprite( ) ;
		var sp:Sprite = new Sprite( ) ;
		sp.graphics.beginFill( 0xFFFFFF * Math.random( ) ) ;
		sp.graphics.drawRect( 0, 0, _originImage.width, _originImage.height ) ;
		sp.graphics.endFill( ) ;
		
		container.addChild( sp ) ;
		sp.addChild( _originImage ) ;
		
		// 傾ける
		sp.rotation = _rot
		
		// --
		
		// マスクサイズを計測
		var bounds:Rectangle = sp.getBounds( container ) ;
		var Xmin:Number = bounds.left ;
		var Xmax:Number = bounds.right ;
		var Ymin:Number = bounds.top ;
		var Ymax:Number = bounds.bottom ;
		
		// --
		
		// 計測が終わったので破棄
		container.removeChild( sp ) ;
		sp = null ;
		container = null ;
		
		// --
		
		var nW:Number = Xmax - Xmin ;
		var nH:Number = Ymax - Ymin ;
		
		// --
		
		return { width:nW, height:nH } ;
	}
	
	public function get list():Array { return _list ; }
	public function set list( _list:Array ):void { this._list = _list ; }
}