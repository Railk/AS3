/**
 * Micro Tween (2.9k) 
 * is not suitable for high number of tweens/performance test
 * as nothing is strong typed for smallness sake. 
 * Use twin instead who is strong typed
 * 
 * 		autorotate /
 * 		sound / 
 * 		tint /
 * 		text /
 * 		textColor /
 * 		hexcolor /
 * 		begin update complete function + params / 
 * 		bezier / FROM EASE TWEEN
 * 		filters / 
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion.tweens
{
	import flash.display.Shape;
	import flash.utils.getTimer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.geom.ColorTransform;
	import flash.media.SoundTransform;
	import railk.as3.motion.utils.*;
	
	final public class Byte
	{	
		private var stm:*=getTimer()*.001;
		private var rn:* = new Shape();
		private var t:*;
		private var dr:*;
		private var ps:*=[];
		private var d:*=0;
		private var e:*=de;
		private var b:*;
		private var ba:*;
		private var u:*;
		private var ua:*;
		private var c:*;
		private var ca:*;
		
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	_t	target to be tweened
		 */
		public function Byte(_t:*) { t =_t; }
		
		/**
		 * TO
		 * 
		 * @param	_dr	duration
		 * @param	_ps	props {}
		 * @return
		 */
		public function to( _dr:*, _ps:* ):Byte {
			dr = _dr;
			for ( var p:* in _ps ) {
				if (p.search('rotation')!=-1){ t[p]=t[p]%360+((Math.abs(t[p]%360-_ps[p]%360)<180)?0:(t[p]%360>_ps[p]%360)?-360:360); _ps[p]=_ps[p]%360;}	
				if (p=='color') var c:* = t.transform.colorTransform;
				ps[ps.length] = [((p.search('Filter')!=-1)?'filter':p),((p in t && p!='color')?((_ps[p] is Array)?ibz(t[p],_ps[p]):t[p]):((p.search('Filter')!=-1)?iflt(p,_ps[p]):((p=='color')?c:((p=='volume')?t.soundTransform.volume:t)))),(p=='color')?new ColorTransform(0-c.redMultiplier,0-c.greenMultiplier,0-c.blueMultiplier,0,((_ps[p]>>16)&0xff)-c.redOffset,((_ps[p]>>8)&0xff)-c.greenOffset,(_ps[p]&0xff)-c.blueOffset):_ps[p]];
			}
			rn.addEventListener('enterFrame', tk );
			return this;
		}
		
		public function delay(v:*):Byte { d = v; return this; } 
		public function ease(f:*):Byte { e = (f!=null)?f:de; return this; } 
		public function onBegin(f:*, ...a:*):Byte { b = f; ba = a; return this; }
		public function onUpdate(f:*, ...a:*):Byte { u = f; ua = a; return this; }
		public function onComplete(f:*, ...a:*):Byte { c = f; ca = a; return this; }
		
		private function tk(ev:*):void {
			var tm:Number = (getTimer()*.001-stm)-d;
			if (b && tm>=0) { b.apply(null, ba); b=null };
			if ( up(((tm>=dr)?1:((tm<=0)?0:e(tm,0,1,dr))))==1 ){
				if(c) c.apply(null,ca);
				dispose();
			}
		}

		private function up( r:* ):* {
			if (!r) return r;
			if (u) u.apply(null,ua);
			var i:int=ps.length;
			while( --i > -1 ) {
				var p:*= ps[i];
				if(p[0]=='volume') t.soundTransform=new SoundTransform(p[2]-(1-r),t.soundTransform.pan)
				else if(p[0]=='text') t.text = txt(r,p[1],p[2]);
				else if(p[0]=='textColor') t.textColor = clr(r,p[1],p[2]);
				else if(p[0]=='color') t.transform.colorTransform=tnt(r,p[1],p[2]);
				else if(p[0] == 'filter') t.filters = flt(r, p[1], p[2]);
				else t[p[0]] = (p[1] is Array)?bz(r,p[1]):p[1]+(p[2]-p[1])*r+1e-18-1e-18;
			}
			return r;
		}
		
		/**
		 * TEXT TWEENING
		 * @param	r
		 * @param	b
		 * @param	e
		 * @return
		 */
		private function txt(r:*, b:String, e:String):* {
			var i:int, mxL:*= ((b.length > e.length)?b.length:e.length), x:*= 1/mxL, ind:*= int(r/x), curL:*= [], nxtL:*= [], reg:*= new RegExp(',', 'g');
			for (i=0;i<e.length;++i) nxtL.push(e.charAt(i));
			for (i=0;i<b.length;++i) curL.push(b.charAt(i));
			for (i=0; i < ind;++i) curL[i] = (nxtL[i])?nxtL[i]:'';
			return curL.toString().replace(reg, '');
		}
		
		/**
		 * HEX COLOR TWEENING
		 * 
		 * @param	r
		 * @param	b
		 * @param	e
		 * @return
		 */
		private function clr(r:*,b:*,e:*):* {
			var q:Number=1-r;
			return  (((b>>24)&0xFF)*q+((e>>24)&0xFF)*r)<<24|(((b>>16)&0xFF)*q+((e>>16)&0xFF)*r)<<16|(((b>>8)&0xFF)*q+((e>>8)&0xFF)*r)<<8|(b&0xFF)*q+(e&0xFF)*r;
		}
		
		/**
		 * TINT COLOR TWEENING
		 * 
		 * @param	r
		 * @param	b
		 * @param	e
		 * @return
		 */
		private function tnt(r:*, b:*, e:*):*{
			return new ColorTransform(b.redMultiplier+e.redMultiplier*r,b.greenMultiplier+e.greenMultiplier*r,b.blueMultiplier+e.blueMultiplier*r,1,b.redOffset+e.redOffset*r,b.greenOffset+e.greenOffset*r,b.blueOffset+e.blueOffset*r);
		}
		
		/**
		 * BESIER TWEENING
		 */
		private function bz(r:*, sgs:*):* {
			var l:* = sgs.length-1, i:int =(r*sgs.length)>>0, rs:*;
			if ( r >= 1 ) rs = sgs[l].p + sgs[l].d2;
			else if (sgs.length == 1) rs = sgs[0].calc(r);
			else {
				if(i<0) i=0; 
				else if(i>l) i=l;
				rs = sgs[i].calc(sgs.length*(r-i/sgs.length));
			}
			return rs;
		}
		
		private function ibz(b:*, e:*):* {
			var thg:Boolean = false, sgs:*=[];
			if (e[0] is Array) { thg = true; e = e[0]; }
			e.unshift(b);
			
			var p:*, p1:*, p2:* = e[0], l:* = e.length - 1, i:* = 1, a:* = NaN;
			while (i<l) {
				p = p2;
				p1 = e[i];
				p2 = e[++i];
				if (thg) {
					if (!sgs.length) { a = (p2-p)/4; sgs[sgs.length] = new Seg(p,p1-a,p1);}
					sgs[sgs.length] = new Seg(p1,p1+a,p2);
					a = p2-(p1+a);
				} else {
					if (i!=l) p2=(p1+p2)/2;
					sgs[sgs.length] = new Seg(p,p1,p2);
				}
			}
			return sgs;
		}
		
		/**
		 * FILTERS TWEENING
		 * 
		 * @param	r
		 * @param	b
		 * @param	e
		 * @param	tp
		 * @return
		 */
		private function flt(r:*, b:*, e:*):* {
			var flts:* = t.filters;
			for ( var p:* in e) b[p] = b[p]+(e[p]-b[p])*r;
			for (var i:int=0; i<flts.length; i++) if (flts[i].toString() == getQualifiedClassName(b)) flts.splice(i, 1);
			flts.push( b );
			return flts;
		}
		
		private function iflt(f:*,ps:*):* {
			var i:*= t.filters.length, c:* = getDefinitionByName('flash.filters::'+f);
			while( --i > -1 ) if (t.filters[i] is c) return t.filters[i];
			var flt:* = new c();
			for ( var p:* in ps ) flt[p] = 0;
			return flt;
		}
		
		/**
		 * DEFAULT EASING (QUADRATIC EASEOUT)
		 * 
		 * @param	t
		 * @param	b
		 * @param	c
		 * @param	d
		 * @return
		 */
		private function de(t:*,b:*,c:*,d:*):* { return -c*(t/=d)*(t-2)+b; }
		
		/**
		 * DISPOSE TWEEN
		 */
		public function dispose():void {
			rn.removeEventListener('enterFrame', tk );
			ps = rn = null;
		}
	}
}