var pol = [{x:0, y:0}, {x:30, y:2}, {x:8, y:30}];
var pol2 = [{x:60, y:60}, {x:90, y:61}, {x:98, y:100}, {x:80, y:100}];
 
love.mousemove = function(e) {
  //перемещение 1 полигона
  var rect = canvas.getBoundingClientRect();
  pol[0].x = e.clientX - rect.left;
  pol[0].y = e.clientY - rect.top;
  pol[1].x = pol[0].x + 30;
  pol[1].y = pol[0].y + 2;
  pol[2].x = pol[0].x + 8;
  pol[2].y = pol[0].y + 30;
}
 
function main() {
  g.clearRect(0, 0, w, h);
 
  if (doPolygonsIntersect(pol, pol2)) g.fillStyle = "#FF0000";
  else g.fillStyle = "#000";
 
  //отрисовка полигонов
  g.beginPath();
  g.moveTo(pol[0].x, pol[0].y);
  for (var i = 1; i < pol.length; i++) {
    g.lineTo(pol[i].x, pol[i].y);
  }
  g.fill();
 
  g.beginPath();
  g.moveTo(pol2[0].x, pol2[0].y);
  for (i = 1; i < pol2.length; i++) {
    g.lineTo(pol2[i].x, pol2[i].y);
  }
  g.fill();
 
}
 
function doPolygonsIntersect(a, b) {
  var polygons = [a, b];
  var minA, maxA, projected, i, i1, j, minB, maxB;
 
  for (i = 0; i < polygons.length; i++) {
 
    //на обоих полигонах смотрим каждую грань и определяем, есть ли с ней пересечение
    var polygon = polygons[i];
    for (i1 = 0; i1 < polygon.length; i1++) {
 
      //берем две вершины для создания грани
      var i2 = (i1 + 1) % polygon.length;
      var p1 = polygon[i1];
      var p2 = polygon[i2];
 
      //находим перпендикуляр этой грани (линия с наклоном на 90 градусов от текущей)
      var normal = {
        x: p2.y - p1.y,
        y: p1.x - p2.x
      };
 
      minA = Infinity;
      maxA = -Infinity;
 
      //каждую вершину первого полигона проецируем на линию, перпендикулярную грани
      //и находим мин/макс значения
      for (j = 0; j < a.length; j++) {
        projected = normal.x * a[j].x + normal.y * a[j].y;
        if (projected < minA) minA = projected;
        if (projected > maxA) maxA = projected;
      }
 
      //каждую вершину второго полигона проецируем на линию, перпендикулярную грани
      //и находим мин/макс значения
      minB = Infinity;
      maxB = -Infinity;
      for (j = 0; j < b.length; j++) {
        projected = normal.x * b[j].x + normal.y * b[j].y;
        if (projected < minB) minB = projected;
        if (projected > maxB) maxB = projected;
      }
 
      //если между проекциями нет перекрытия, то существует грань (линия), точно разделяющая два полигона
      //и тогда полигоны не пересекаются!
      if (maxA < minB || maxB < minA) return false;
    }
  }
  return true;
};
 
setInterval(main, 1000 / 60);