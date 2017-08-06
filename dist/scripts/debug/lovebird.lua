local a=require"socket"local b={_version="0.4.3"}b.loadstring=loadstring or load;b.inited=false;b.host="*"b.buffer=""b.lines={}b.connections={}b.pages={}b.wrapprint=true;b.timestamp=true;b.allowhtml=false;b.echoinput=true;b.port=8000;b.whitelist={"127.0.0.1"}b.maxlines=200;b.updateinterval=.5;b.pages["index"]=[[
<?lua
-- Handle console input
if req.parsedbody.input then
  local str = req.parsedbody.input
  if lovebird.echoinput then
    lovebird.pushline({ type = 'input', str = str })
  end
  if str:find("^=") then
    str = "print(" .. str:sub(2) .. ")"
  end
  xpcall(function() assert(lovebird.loadstring(str, "input"))() end,
         lovebird.onerror)
end
?>

<!doctype html>
<html>
  <head>
  <meta http-equiv="x-ua-compatible" content="IE=Edge"/>
  <meta charset="utf-8">
  <title>lovebird</title>
  <style>
    body {
      margin: 0px;
      font-size: 14px;
      font-family: helvetica, verdana, sans;
      background: #FFFFFF;
    }
    form {
      margin-bottom: 0px;
    }
    .timestamp {
      color: #909090;
      padding-right: 4px;
    }
    .repeatcount {
      color: #F0F0F0;
      background: #505050;
      font-size: 11px;
      font-weight: bold;
      text-align: center;
      padding-left: 4px;
      padding-right: 4px;
      padding-top: 0px;
      padding-bottom: 0px;
      border-radius: 7px;
      display: inline-block;
    }
    .errormarker {
      color: #F0F0F0;
      background: #8E0000;
      font-size: 11px;
      font-weight: bold;
      text-align: center;
      border-radius: 8px;
      width: 17px;
      padding-top: 0px;
      padding-bottom: 0px;
      display: inline-block;
    }
    .greybordered {
      margin: 12px;
      background: #F0F0F0;
      border: 1px solid #E0E0E0;
      border-radius: 3px;
    }
    .inputline {
      font-family: mono, courier;
      font-size: 13px;
      color: #606060;
    }
    .inputline:before {
      content: '\00B7\00B7\00B7';
      padding-right: 5px;
    }
    .errorline {
      color: #8E0000;
    }
    #header {
      background: #101010;
      height: 25px;
      color: #F0F0F0;
      padding: 9px
    }
    #title {
      float: left;
      font-size: 20px;
    }
    #title a {
      color: #F0F0F0;
      text-decoration: none;
    }
    #title a:hover {
      color: #FFFFFF;
    }
    #version {
      font-size: 10px;
    }
    #status {
      float: right;
      font-size: 14px;
      padding-top: 4px;
    }
    #main a {
      color: #000000;
      text-decoration: none;
      background: #E0E0E0;
      border: 1px solid #D0D0D0;
      border-radius: 3px;
      padding-left: 2px;
      padding-right: 2px;
      display: inline-block;
    }
    #main a:hover {
      background: #D0D0D0;
      border: 1px solid #C0C0C0;
    }
    #console {
      position: absolute;
      top: 40px; bottom: 0px; left: 0px; right: 312px;
    }
    #input {
      position: absolute;
      margin: 10px;
      bottom: 0px; left: 0px; right: 0px;
    }
    #inputbox {
      width: 100%;
      font-family: mono, courier;
      font-size: 13px;
    }
    #output {
      overflow-y: scroll;
      position: absolute;
      margin: 10px;
      line-height: 17px;
      top: 0px; bottom: 36px; left: 0px; right: 0px;
    }
    #env {
      position: absolute;
      top: 40px; bottom: 0px; right: 0px;
      width: 300px;
    }
    #envheader {
      padding: 5px;
      background: #E0E0E0;
    }
    #envvars {
      position: absolute;
      left: 0px; right: 0px; top: 25px; bottom: 0px;
      margin: 10px;
      overflow-y: scroll;
      font-size: 12px;
    }
  </style>
  </head>
  <body>
    <div id="header">
      <div id="title">
        <a href="https://github.com/rxi/lovebird">lovebird</a>
        <span id="version"><?lua echo(lovebird._version) ?></span>
      </div>
      <div id="status"></div>
    </div>
    <div id="main">
      <div id="console" class="greybordered">
        <div id="output"> <?lua echo(lovebird.buffer) ?> </div>
        <div id="input">
          <form method="post"
                onkeydown="return onInputKeyDown(event);"
                onsubmit="onInputSubmit(); return false;">
            <input id="inputbox" name="input" type="text"
                autocomplete="off"></input>
          </form>
        </div>
      </div>
      <div id="env" class="greybordered">
        <div id="envheader"></div>
        <div id="envvars"></div>
      </div>
    </div>
    <script>
      document.getElementById("inputbox").focus();

      var changeFavicon = function(href) {
        var old = document.getElementById("favicon");
        if (old) document.head.removeChild(old);
        var link = document.createElement("link");
        link.id = "favicon";
        link.rel = "shortcut icon";
        link.href = href;
        document.head.appendChild(link);
      }

      var truncate = function(str, len) {
        if (str.length <= len) return str;
        return str.substring(0, len - 3) + "...";
      }

      var geturl = function(url, onComplete, onFail) {
        var req = new XMLHttpRequest();
        req.onreadystatechange = function() {
          if (req.readyState != 4) return;
          if (req.status == 200) {
            if (onComplete) onComplete(req.responseText);
          } else {
            if (onFail) onFail(req.responseText);
          }
        }
        url += (url.indexOf("?") > -1 ? "&_=" : "?_=") + Math.random();
        req.open("GET", url, true);
        req.send();
      }

      var divContentCache = {}
      var updateDivContent = function(id, content) {
        if (divContentCache[id] != content) {
          document.getElementById(id).innerHTML = content;
          divContentCache[id] = content
          return true;
        }
        return false;
      }

      var onInputSubmit = function() {
        var b = document.getElementById("inputbox");
        var req = new XMLHttpRequest();
        req.open("POST", "/", true);
        req.send("input=" + encodeURIComponent(b.value));
        /* Do input history */
        if (b.value && inputHistory[0] != b.value) {
          inputHistory.unshift(b.value);
        }
        inputHistory.index = -1;
        /* Reset */
        b.value = "";
        refreshOutput();
      }

      /* Input box history */
      var inputHistory = [];
      inputHistory.index = 0;
      var onInputKeyDown = function(e) {
        var key = e.which || e.keyCode;
        if (key != 38 && key != 40) return true;
        var b = document.getElementById("inputbox");
        if (key == 38 && inputHistory.index < inputHistory.length - 1) {
          /* Up key */
          inputHistory.index++;
        }
        if (key == 40 && inputHistory.index >= 0) {
          /* Down key */
          inputHistory.index--;
        }
        b.value = inputHistory[inputHistory.index] || "";
        b.selectionStart = b.value.length;
        return false;
      }

      /* Output buffer and status */
      var refreshOutput = function() {
        geturl("/buffer", function(text) {
          updateDivContent("status", "connected &#9679;");
          if (updateDivContent("output", text)) {
            var div = document.getElementById("output");
            div.scrollTop = div.scrollHeight;
          }
          /* Update favicon */
          changeFavicon("data:image/png;base64," +
"iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAP1BMVEUAAAAAAAAAAAD////19fUO"+
"Dg7v7+/h4eGzs7MlJSUeHh7n5+fY2NjJycnGxsa3t7eioqKfn5+QkJCHh4d+fn7zU+b5AAAAAnRS"+
"TlPlAFWaypEAAABRSURBVBjTfc9HDoAwDERRQ+w0ern/WQkZaUBC4e/mrWzppH9VJjbjZg1Ii2rM"+
"DyR1JZ8J0dVWggIGggcEwgbYCRbuPRqgyjHNpzUP+39GPu9fgloC5L9DO0sAAAAASUVORK5CYII="
          );
        },
        function(text) {
          updateDivContent("status", "disconnected &#9675;");
          /* Update favicon */
          changeFavicon("data:image/png;base64," +
"iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAYFBMVEUAAAAAAAAAAADZ2dm4uLgM"+
"DAz29vbz8/Pv7+/h4eHIyMiwsLBtbW0lJSUeHh4QEBDn5+fS0tLDw8O0tLSioqKfn5+QkJCHh4d+"+
"fn5ycnJmZmZgYGBXV1dLS0tFRUUGBgZ0He44AAAAAnRSTlPlAFWaypEAAABeSURBVBjTfY9HDoAw"+
"DAQD6Z3ey/9/iXMxkVDYw0g7F3tJReosUKHnwY4pCM+EtOEVXrb7wVRA0dMbaAcUwiVeDQq1Jp4a"+
"xUg5kE0ooqZu68Di2Tgbs/DiY/9jyGf+AyFKBAK7KD2TAAAAAElFTkSuQmCC"
          );
        });
      }
      setInterval(refreshOutput,
                  <?lua echo(lovebird.updateinterval) ?> * 1000);

      /* Environment variable view */
      var envPath = "";
      var refreshEnv = function() {
        geturl("/env.json?p=" + envPath, function(text) {
          var json = eval("(" + text + ")");

          /* Header */
          var html = "<a href='#' onclick=\"setEnvPath('')\">env</a>";
          var acc = "";
          var p = json.path != "" ? json.path.split(".") : [];
          for (var i = 0; i < p.length; i++) {
            acc += "." + p[i];
            html += " <a href='#' onclick=\"setEnvPath('" + acc + "')\">" +
                    truncate(p[i], 10) + "</a>";
          }
          updateDivContent("envheader", html);

          /* Handle invalid table path */
          if (!json.valid) {
            updateDivContent("envvars", "Bad path");
            return;
          }

          /* Variables */
          var html = "<table>";
          for (var i = 0; json.vars[i]; i++) {
            var x = json.vars[i];
            var fullpath = (json.path + "." + x.key).replace(/^\./, "");
            var k = truncate(x.key, 15);
            if (x.type == "table") {
              k = "<a href='#' onclick=\"setEnvPath('" + fullpath + "')\">" +
                  k + "</a>";
            }
            var v = "<a href='#' onclick=\"insertVar('" +
                    fullpath.replace(/\.(-?[0-9]+)/g, "[$1]") +
                    "');\">" + x.value + "</a>"
            html += "<tr><td>" + k + "</td><td>" + v + "</td></tr>";
          }
          html += "</table>";
          updateDivContent("envvars", html);
        });
      }
      var setEnvPath = function(p) {
        envPath = p;
        refreshEnv();
      }
      var insertVar = function(p) {
        var b = document.getElementById("inputbox");
        b.value += p;
        b.focus();
      }
      setInterval(refreshEnv, <?lua echo(lovebird.updateinterval) ?> * 1000);
    </script>
  </body>
</html>
]]b.pages["buffer"]=[[ <?lua echo(lovebird.buffer) ?> ]]b.pages["env.json"]=[[
<?lua
  local t = _G
  local p = req.parsedurl.query.p or ""
  p = p:gsub("%.+", "."):match("^[%.]*(.*)[%.]*$")
  if p ~= "" then
    for x in p:gmatch("[^%.]+") do
      t = t[x] or t[tonumber(x)]
      -- Return early if path does not exist
      if type(t) ~= "table" then
        echo('{ "valid": false, "path": ' .. string.format("%q", p) .. ' }')
        return
      end
    end
  end
?>
{
  "valid": true,
  "path": "<?lua echo(p) ?>",
  "vars": [
    <?lua
      local keys = {}
      for k in pairs(t) do
        if type(k) == "number" or type(k) == "string" then
          table.insert(keys, k)
        end
      end
      table.sort(keys, lovebird.compare)
      for _, k in pairs(keys) do
        local v = t[k]
    ?>
      {
        "key": "<?lua echo(k) ?>",
        "value": <?lua echo(
                          string.format("%q",
                            lovebird.truncate(
                              lovebird.htmlescape(
                                tostring(v)), 26))) ?>,
        "type": "<?lua echo(type(v)) ?>",
      },
    <?lua end ?>
  ]
}
]]function b.init()b.server=assert(a.bind(b.host,b.port))b.addr,b.port=b.server:getsockname()b.server:settimeout(0)b.origprint=print;if b.wrapprint then local c=print;print=function(...)c(...)b.print(...)end end;for d,e in pairs(b.pages)do b.pages[d]=b.template(e,"lovebird, req","pages."..d)end;b.inited=true end;function b.template(f,g,h)g=g and","..g or""local i=function(j)return string.format(" echo(%q)",j)end;f=("?>"..f.."<?lua"):gsub("%?>(.-)<%?lua",i)f="local echo "..g.." = ..."..f;local k=assert(b.loadstring(f,h))return function(...)local l={}local m=function(f)table.insert(l,f)end;k(m,...)return table.concat(b.map(l,tostring))end end;function b.map(n,k)local o={}for d,p in pairs(n)do o[d]=k(p)end;return o end;function b.trace(...)local f="[lovebird] "..table.concat(b.map({...},tostring)," ")print(f)if not b.wrapprint then b.print(f)end end;function b.unescape(f)local i=function(j)return string.char(tonumber("0x"..j))end;return f:gsub("%+"," "):gsub("%%(..)",i)end;function b.parseurl(q)local o={}o.path,o.search=q:match("/([^%?]*)%??(.*)")o.query={}for d,p in o.search:gmatch("([^&^?]-)=([^&^#]*)")do o.query[d]=b.unescape(p)end;return o end;local r={["<"]="&lt;",["&"]="&amp;",['"']="&quot;",["'"]="&#039;"}function b.htmlescape(f)return f:gsub("[<&\"']",r)end;function b.truncate(f,s)if#f<=s then return f end;return f:sub(1,s-3).."..."end;function b.compare(t,u)local v,w=tonumber(t),tonumber(u)if v then if w then return v<w end;return false elseif w then return true end;return tostring(t)<tostring(u)end;function b.checkwhitelist(x)if b.whitelist==nil then return true end;for y,t in pairs(b.whitelist)do local z="^"..t:gsub("%.","%%."):gsub("%*","%%d*").."$"if x:match(z)then return true end end;return false end;function b.clear()b.lines={}b.buffer=""end;function b.pushline(A)A.time=os.time()A.count=1;table.insert(b.lines,A)if#b.lines>b.maxlines then table.remove(b.lines,1)end;b.recalcbuffer()end;function b.recalcbuffer()local function B(A)local f=A.str;if not b.allowhtml then f=b.htmlescape(A.str):gsub("\n","<br>")end;if A.type=="input"then f='<span class="inputline">'..f..'</span>'else if A.type=="error"then f='<span class="errormarker">!</span> '..f;f='<span class="errorline">'..f..'</span>'end;if A.count>1 then f='<span class="repeatcount">'..A.count..'</span> '..f end;if b.timestamp then f=os.date('<span class="timestamp">%H:%M:%S</span> ',A.time)..f end end;return f end;b.buffer=table.concat(b.map(b.lines,B),"<br>")end;function b.print(...)local n={}for C=1,select("#",...)do table.insert(n,tostring(select(C,...)))end;local f=table.concat(n," ")local D=b.lines[#b.lines]if D and f==D.str then D.time=os.time()D.count=D.count+1;b.recalcbuffer()else b.pushline({type="output",str=f})end end;function b.onerror(E)b.pushline({type="error",str=E})if b.wrapprint then b.origprint("[lovebird] ERROR: "..E)end end;function b.onrequest(F,G)local e=F.parsedurl.path;e=e~=""and e or"index"if not b.pages[e]then return"HTTP/1.1 404\r\nContent-Length: 8\r\n\r\nBad page"end;local f;xpcall(function()local H=b.pages[e](b,F)local I="text/html"if string.match(e,"%.json$")then I="application/json"end;f="HTTP/1.1 200 OK\r\n".."Content-Type: "..I.."\r\n".."Content-Length: "..#H.."\r\n".."\r\n"..H end,b.onerror)return f end;function b.receive(G,J)while 1 do local H,K=G:receive(J)if not H then if K=="timeout"then coroutine.yield(true)else coroutine.yield(nil)end else return H end end end;function b.send(G,H)local L=1;while L<#H do local o,K=G:send(H,L)if not o and K=="closed"then coroutine.yield(nil)else L=L+o;coroutine.yield(true)end end end;function b.onconnect(G)local M="(%S*)%s*(%S*)%s*(%S*)"local F={}F.socket=G;F.addr,F.port=G:getsockname()F.request=b.receive(G,"*l")F.method,F.url,F.proto=F.request:match(M)F.headers={}while 1 do local A,K=b.receive(G,"*l")if not A or#A==0 then break end;local d,p=A:match("(.-):%s*(.*)$")F.headers[d]=p end;if F.headers["Content-Length"]then F.body=b.receive(G,F.headers["Content-Length"])end;F.parsedbody={}if F.body then for d,p in F.body:gmatch("([^&]-)=([^&^#]*)")do F.parsedbody[d]=b.unescape(p)end end;F.parsedurl=b.parseurl(F.url)local H=b.onrequest(F)b.send(G,H)G:close()end;function b.update()if not b.inited then b.init()end;while 1 do local G=b.server:accept()if not G then break end;G:settimeout(0)local x=G:getsockname()if b.checkwhitelist(x)then local N=coroutine.wrap(function()xpcall(function()b.onconnect(G)end,function()end)end)b.connections[N]=true else b.trace("got non-whitelisted connection attempt: ",x)G:close()end end;for N in pairs(b.connections)do local O=N()if O==nil then b.connections[N]=nil end end end;return b