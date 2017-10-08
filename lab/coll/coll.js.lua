local _ENV = require("castl.runtime");
local doPolygonsIntersect,main,pol2,pol,h,w,g,canvas;

main = (function (this)
local i;
g:clearRect(0,0,w,h);
if _bool(doPolygonsIntersect(_ENV,pol,pol2)) then
g.fillStyle = "#FF0000";
else
g.fillStyle = "#000";
end

g:beginPath();
g:moveTo(pol[0].x,pol[0].y);
i = 1;
while (_lt(i,pol.length)) do
g:lineTo(pol[i].x,pol[i].y);
i = _inc(i);
end

g:fill();
g:beginPath();
g:moveTo(pol2[0].x,pol2[0].y);
i = 1;
while (_lt(i,pol2.length)) do
g:lineTo(pol2[i].x,pol2[i].y);
i = _inc(i);
end

g:fill();
end);
doPolygonsIntersect = (function (this, a, b)
local normal,p2,p1,i2,polygon,maxB,minB,j,i1,i,projected,maxA,minA,polygons;
polygons = _arr({[0]=a,b},2);
i = 0;
while (_lt(i,polygons.length)) do
polygon = polygons[i];
i1 = 0;
while (_lt(i1,polygon.length)) do
i2 = (_mod((_addNum2(i1,1)),polygon.length));
p1 = polygon[i1];
p2 = polygon[i2];
normal = _obj({
["x"] = (p2.y - p1.y),
["y"] = (p1.x - p2.x)
});
minA = Infinity;
maxA = -_tonum(Infinity);
j = 0;
while (_lt(j,a.length)) do
projected = ((normal.x * a[j].x) + (normal.y * a[j].y));
if (_lt(projected,minA)) then
minA = projected;
end

if (_gt(projected,maxA)) then
maxA = projected;
end

j = _inc(j);
end

minB = Infinity;
maxB = -_tonum(Infinity);
j = 0;
while (_lt(j,b.length)) do
projected = ((normal.x * b[j].x) + (normal.y * b[j].y));
if (_lt(projected,minB)) then
minB = projected;
end

if (_gt(projected,maxB)) then
maxB = projected;
end

j = _inc(j);
end

if ((function() local _lev=(_lt(maxA,minB)); return _bool(_lev) and _lev or (_lt(maxB,minA)) end)()) then
do return false; end
end

i1 = _inc(i1);
end

i = _inc(i);
end

do return true; end
end);
canvas = document:getElementById("canvas");
g = canvas:getContext("2d");
w = canvas.width;
h = canvas.height;
pol = _arr({[0]=_obj({
["x"] = 0,
["y"] = 0
}),_obj({
["x"] = 30,
["y"] = 2
}),_obj({
["x"] = 8,
["y"] = 30
})},3);
pol2 = _arr({[0]=_obj({
["x"] = 60,
["y"] = 60
}),_obj({
["x"] = 90,
["y"] = 61
}),_obj({
["x"] = 98,
["y"] = 100
}),_obj({
["x"] = 80,
["y"] = 100
})},4);
canvas.onmousemove = (function (this, e)
local rect;
rect = canvas:getBoundingClientRect();
pol[0].x = (e.clientX - rect.left);
pol[0].y = (e.clientY - rect.top);
pol[1].x = (_addNum2(pol[0].x,30));
pol[1].y = (_addNum2(pol[0].y,2));
pol[2].x = (_addNum2(pol[0].x,8));
pol[2].y = (_addNum2(pol[0].y,30));
end);
setInterval(_ENV,main,(1000 / 60));