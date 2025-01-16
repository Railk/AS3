package math {
import flash.geom.Vector3D;
/**
* @author miaumiau.cat
* Clase que se encarga de generar una parametrización
* Bezier de trayectoria o superficie.
*
*/
public class Bezier {
//Variable que determina si se trabaja en 3D...
public static var _3D : Boolean = false;
//Variable que permite tener los datos de la combinatoria para cada grado...
private static var combinatoriaData : Array = new Array();
combinatoriaData[0] = [0];
combinatoriaData[1] = [1];
//A partír de 2 se tienen la cantidad mínima de puntos para interpolar
combinatoriaData[2] = new Array(1, 1);
combinatoriaData[3] = new Array(1, 2, 1);
combinatoriaData[4] = new Array(1, 3, 3, 1);
combinatoriaData[5] = new Array(1, 4, 6, 4, 1);
combinatoriaData[6] = new Array(1, 5, 10, 10, 5, 1);
combinatoriaData[7] = new Array(1, 6, 15, 20, 15, 6, 1);
combinatoriaData[8] = new Array(1, 7, 21, 35, 35, 21, 7, 1);
combinatoriaData[9] = new Array(1, 8, 28, 56, 70, 56, 28, 8, 1);
combinatoriaData[10] = new Array(1, 9, 36, 84, 126, 126, 84, 36, 9, 1);
combinatoriaData[11] = new Array(1, 10, 45, 120, 210, 252, 210, 120, 45, 10, 1);
combinatoriaData[12] = new Array(1, 11, 56, 165, 330, 462, 462, 330, 165, 56, 11, 1);
//Variables estáticas que permiten guardar los valores de segmentación de la malla (evita recalcular la cantidad de puntos...)
private static var Ne : uint = 0;
private static var Nn : uint = 0;
private static var paramsE : Array = new Array();
private static var paramsN : Array = new Array();
//Variable que contiene las constantes de la curva bezier para un grado y una parametrización (cantidad de puntos) fija.
private static var coeficientesCurva : Array = new Array();
//Función que calcula los coeficientes de la curva...
public static function bezier(t : Number, controlPoints : Vector.) : Vector3D {
var salida : Vector3D = new Vector3D;
var coeficientes : Array = new Array();
var i : uint;
var length : uint = controlPoints.length;
var n : uint = length - 1;
//Si los valores de la combinatoria para la cantidad de puntos no estan definidos, los defino...
if(combinatoriaData[length] == undefined) {
combinatoriaData[length] = setCoeficients(n);
}
//Determino los coeficientes...
for (i = 0;i <= n; i++) {
coeficientes[i] = combinatoriaData[length][i] * Math.pow(t, i) * Math.pow((1 - t), (n - i));
}
//Obtengo los valores de salida del vector3D...
for(i = 0;i <= n; i++) {
salida.x += coeficientes[i] * controlPoints[i].x;
salida.y += coeficientes[i] * controlPoints[i].y;
salida.z += coeficientes[i] * controlPoints[i].z;
}
salida.w = 1;
return salida;
}
//Función que se encarga de obtener un conjunto de puntos xyz agrupados en un array para una curva bezier...
public static function bezierPoints(m : uint, controlPoints : Array, borderDistance : Number = -1) : Vector. {
var salida : Vector. = new Vector.();
var length1 : uint = controlPoints.length;
var n : uint = controlPoints.length - 1;
var i : uint;
var j : uint;
//Si los valores de la combinatoria para la cantidad de puntos no estan definidos, los defino...
if(combinatoriaData[length1] == undefined) {
combinatoriaData[length1] = setCoeficients(n);
}
//Si no hay un arreglo que guarde la referencia para un grado definido, se define...
if(coeficientesCurva[n] == undefined) {
coeficientesCurva[n] = new Array();
}
//Si no hay un arreglo que guarde los coeficientes para "m" puntos se define...
//Se guarda un arreglo de cuatro dimensiones según la siguiente definición...
//
//coeficientes[n][m][j][i] donde:
//n : grado,
//m : cantidad de puntos a parametrizar,
//j : vector de coeficientes para un valor de parametrización perteneciente al rango [0, 1]
//i : coeficientes a multiplicar por cada punto para la parametrización anterior...
//
if(coeficientesCurva[n][m] == undefined) {
coeficientesCurva[n][m] = new Array();
for (j = 0;j <m; j++) {
//Defino la parametrización...
var delta : Number = j / (m - 1);
coeficientesCurva[n][m][j] = new Array();
for(i = 0;i <= n; i++) {
coeficientesCurva[n][m][j].push(combinatoriaData[length1][i] * Math.pow(delta, i) * Math.pow((1 - delta), (n - i)));
}
}
}
//Obtengo los distintos puntos que componen el vector de salida...
for(j = 0;j <m; j++) {
var pointer : Vector3D = new Vector3D(0, 0, 0, 0);
for(i = 0;i <= n; i++) {					 pointer.x += coeficientesCurva[n][m][j][i] * controlPoints[i].x;				pointer.y += coeficientesCurva[n][m][j][i] * controlPoints[i].y;		   pointer.z += coeficientesCurva[n][m][j][i] * controlPoints[i].z;	 }			 salida.push(pointer);	}				 //En caso de requerir bordes fijos...			 if(borderDistance> 0) {
//Determino la longitud de la curva y calculo el valor porcentual de la parametrización de 0 a 1
var length : Number = 0;
for(i = 1;i <salida.length; i++) {
length += Vector3D.distance(salida[i], salida[i - 1]);
}
var percentDistance : Number = borderDistance / length;
var centerDistance : Number = (1 - 2 * percentDistance) / (m - 3);
var parameters : Array = new Array();
var relativeCoeficients : Array = new Array();
parameters.push(0);
for(i = 0;i <m - 2; i++) {
parameters.push(percentDistance + i * centerDistance);
}
parameters.push(1);
//Determino el nuevo grupo de coeficientes a utilizar dependiendo de la parametrización...
for (j = 0;j <m; j++) {
relativeCoeficients.push(new Array());
for(i = 0;i <= n; i++) {
relativeCoeficients[j].push(combinatoriaData[controlPoints.length][i] * Math.pow(parameters[j], i) * Math.pow((1 - parameters[j]), (n - i)));
}
}
//Obtengo los nuevos puntos tomando en cuenta las separaciones requeridas...
salida.length = 0;
for(j = 0;j <m; j++) {
var pointer1 : Vector3D = new Vector3D(0, 0, 0, 0);
for(i = 0;i <= n; i++) {
pointer1.x += relativeCoeficients[j][i] * controlPoints[i].x;
pointer1.y += relativeCoeficients[j][i] * controlPoints[i].y;
if(_3D) pointer.z += relativeCoeficients[j][i] * controlPoints[i].z;
}
salida.push(pointer1);
}
}
return salida;
}
//Función que devuelve una superficie Bezier de MxN puntos de control (de borde e internos), se diferencia del patch porque esta última solo permite el control con las curvas de borde (no hay puntos internos...)
public static function surface(u_cps : uint, points : Vector., Ne : uint = 10, Nn : uint = 10, force : uint = 1) : Vector. {
var i : uint;
var j : uint;
var k : uint;
var r : uint;
var output : Vector.  = new Vector.();
var v_cps : uint = points.length / u_cps;
var cp_curves : Array = new Array();
//Separo los puntos para obtener cada curva...
for(i = 0; i <u_cps; i++) {
cp_curves[i] = new Vector.();
for(j = i; j <= v_cps * (u_cps - 1) + i; j += u_cps) {
for(r = 0; r <force; r ++) {
cp_curves[i].push(points[j]);
}
}
}
//Genero los parámetros si no estan definidos...
if(Bezier.Ne != Ne && Bezier.Nn != Ne) {
Bezier.Ne = Ne;
Bezier.Nn = Nn;
paramsN = [];
paramsE = [];
for (i = 1;i <= Nn; i++) {
paramsN.push((i - 1) / (Nn - 1));
}
for (i = 1;i <= Ne; i++) {
paramsE.push((i - 1) / (Ne - 1));
}
}
//Genero el arreglo de puntos...
var jMax : uint = paramsN.length;
var iMax : uint = paramsE.length;
for (j = 0;j <jMax; j++) {
//Conjunto de puntos obtenidos de evaluar las curvas verticales...
var resultant_curve : Vector. = new Vector.();
for(k = 0; k <cp_curves.length; k++) {
for(r = 0; r <force; r++) {
resultant_curve.push(bezier(paramsN[j], cp_curves[k]));
}
}
//De los puntos obtenidos de las curvas verticales se obtiene una curva horizontal que al ser evaluada entrega cada punto de la superficie...
for (i = 0;i <iMax; i++) {
output.push(bezier(paramsE[i], resultant_curve));
}
}
return output;
}
//Función que se encarga de conseguir todos los puntos de una malla generada por bordes...
//Entrega los puntos ordenados de la siguiente manera suponiendo un arreglo de 3X3...
//
//  0  1  2
//  3  4  5
//  6  7  8
//
public static function getPatch(Xt0 : Vector3D, Xt1 : Vector3D, Xb0 : Vector3D, Xb1 : Vector3D, BT : Array, BB : Array, BL : Array, BR : Array, Ne : uint = 10, Nn : uint = 10, borderSeparation : Number = -1) : Array {
var i : uint;
var points : Array = new Array();
//Obtengo los puntos de las curvas para interpolar...
var b_top : Vector. = Bezier.bezierPoints(Ne, BT, borderSeparation);
var b_bottom : Vector. = Bezier.bezierPoints(Ne, BB, borderSeparation);
var b_left : Vector. = Bezier.bezierPoints(Nn, BL, borderSeparation);
var b_right : Vector. = Bezier.bezierPoints(Nn, BR, borderSeparation);
//Genero los parámetros si no estan definidos...
if(Bezier.Ne != Ne && Bezier.Nn != Ne) {
Bezier.Ne = Ne;
Bezier.Nn = Nn;
paramsN = [];
paramsE = [];
for (i = 1;i <= Nn; i++) {
paramsN.push((i - 1) / (Nn - 1));
}
for (i = 1;i <= Ne; i++) {
paramsE.push((i - 1) / (Ne - 1));
}
}
//Genero el arreglo de puntos...
var j : uint;
var jMax : uint = paramsN.length;
var iMax : uint = paramsE.length;
for (i = 0;i <iMax; i++) {
for (j = 0;j <jMax; j++) {
points.push(TFI(paramsE[i], paramsN[j], b_top[i], b_bottom[i], b_left[j], b_right[j], Xt0, Xt1, Xb0, Xb1));
}
}
return points;
}
//Función que permite liberar la memoria de la clase Bezier...
public static function clearMemory() : void {
coeficientesCurva = [];
paramsN = [];
paramsE = [];
combinatoriaData = [];
coeficientesCurva = paramsN = paramsE = combinatoriaData = null;
}
//Función que genera una interpolación tranfinita TFI para un grupo de cuatro curvas de borde bezier.
//Se pasan los puntos de borde Xt0, Xt1, Xb0, Xb1 y los valores e, n definidos de 0 a 1 para pasar de
//estado plano al definido por las cuatro curvas... se busca generar los puntos P intermedios...
//
//
//  Xt0 Xt Xt Xt Xt Xt Xt Xt1
//  Xl					 Xr
//  Xl					 Xr
//  Xl   P				 Xr
//  Xl					 Xr
//  Xl					 Xr
//  Xl					 Xr
//  Xl					 Xr
//  Xb0 Xb Xb Xb Xb Xb Xb Xb1
//
//
private static function TFI(e : Number, n : Number, Xt : Vector3D, Xb : Vector3D, Xl : Vector3D, Xr : Vector3D , Xt0 : Vector3D, Xt1 : Vector3D, Xb0 : Vector3D, Xb1 : Vector3D) : Vector3D {
var TFIPoint : Vector3D = new Vector3D();
//Evalúo la interpolación para cada coordenada del punto, x, y, z...
TFIPoint.x = (1 - n) * Xt.x + n * Xb.x + (1 - e) * Xl.x + e * Xr.x - (e * n * Xb1.x + e * (1 - n) * Xt1.x + n * (1 - e) * Xb0.x + (1 - n) * (1 - e) * Xt0.x);
TFIPoint.y = (1 - n) * Xt.y + n * Xb.y + (1 - e) * Xl.y + e * Xr.y - (e * n * Xb1.y + e * (1 - n) * Xt1.y + n * (1 - e) * Xb0.y + (1 - n) * (1 - e) * Xt0.y);
if(_3D) TFIPoint.z = (1 - n) * Xt.z + n * Xb.z + (1 - e) * Xl.z + e * Xr.z - (e * n * Xb1.z + e * (1 - n) * Xt1.z + n * (1 - e) * Xb0.z + (1 - n) * (1 - e) * Xt0.z);
TFIPoint.w = 1;
return TFIPoint;
}
//Función que realiza un set de los coeficientes en caso que cantidad de puntos sean distintos a los valores almacenados...
private static function setCoeficients(n : Number) : Array {
var datos : Array = new Array();
var i : Number;
for (i = 0;i <= n; i++) {
datos.push(MathFunctions.combinatoria(n, i));
}
return datos;
}
//fín del programa....
}
}