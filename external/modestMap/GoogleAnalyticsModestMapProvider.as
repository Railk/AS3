package railk.as3.external.modestMap {
	
	import com.modestmaps.core.Coordinate;
	import com.modestmaps.geo.MercatorProjection;
	import com.modestmaps.geo.Transformation;
	import com.modestmaps.mapproviders.AbstractZoomifyMapProvider;
	import com.modestmaps.mapproviders.IMapProvider;

	public class GoogleAnalyticsModestMapProvider extends AbstractZoomifyMapProvider implements IMapProvider  {
		
		private var __path__                          :String;
		
		public function GoogleAnalyticsModestMapProvider( path:String ):void {
			super();
			__path__ = path;
			defineImageProperties( path, 1600, 778 );		
			
			var t:Transformation = new Transformation(18874.771335015033, -73337.98998796544, 41991.10559178539,
											  -26.926262348670072, -578.9143032903524, 1041.8651977259656);
			__projection = new MercatorProjection(11, t);
			
		}	
			
		override public function toString():String {
			return "GA_MAP";
		}
		
		override public function getTileUrl(coord:Coordinate):String {
			return super.getTileUrl(coord);
		}
		
	}	
	
}