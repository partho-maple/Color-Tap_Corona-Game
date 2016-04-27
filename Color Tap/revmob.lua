package.preload['json']=(function(...)local e=string
local d=math
local u=table
local i=error
local a=tonumber
local c=tostring
local s=type
local o=setmetatable
local l=pairs
local f=ipairs
local r=assert
local n=Chipmunk
module("json")local n={buffer={}}function n:New()local e={}o(e,self)self.__index=self
e.buffer={}return e
end
function n:Append(e)self.buffer[#self.buffer+1]=e
end
function n:ToString()return u.concat(self.buffer)end
local t={backslashes={['\b']="\\b",['\t']="\\t",['\n']="\\n",['\f']="\\f",['\r']="\\r",['"']='\\"',['\\']="\\\\",['/']="\\/"}}function t:New()local e={}e.writer=n:New()o(e,self)self.__index=self
return e
end
function t:Append(e)self.writer:Append(e)end
function t:ToString()return self.writer:ToString()end
function t:Write(n)local e=s(n)if e=="nil"then
self:WriteNil()elseif e=="boolean"then
self:WriteString(n)elseif e=="number"then
self:WriteString(n)elseif e=="string"then
self:ParseString(n)elseif e=="table"then
self:WriteTable(n)elseif e=="function"then
self:WriteFunction(n)elseif e=="thread"then
self:WriteError(n)elseif e=="userdata"then
self:WriteError(n)end
end
function t:WriteNil()self:Append("null")end
function t:WriteString(e)self:Append(c(e))end
function t:ParseString(n)self:Append('"')self:Append(e.gsub(n,'[%z%c\\"/]',function(t)local n=self.backslashes[t]if n then return n end
return e.format("\\u%.4X",e.byte(t))end))self:Append('"')end
function t:IsArray(i)local n=0
local t=function(e)if s(e)=="number"and e>0 then
if d.floor(e)==e then
return true
end
end
return false
end
for e,i in l(i)do
if not t(e)then
return false,'{','}'else
n=d.max(n,e)end
end
return true,'[',']',n
end
function t:WriteTable(e)local r,t,i,n=self:IsArray(e)self:Append(t)if r then
for t=1,n do
self:Write(e[t])if t<n then
self:Append(',')end
end
else
local n=true;for e,t in l(e)do
if not n then
self:Append(',')end
n=false;self:ParseString(e)self:Append(':')self:Write(t)end
end
self:Append(i)end
function t:WriteError(n)i(e.format("Encoding of %s unsupported",c(n)))end
function t:WriteFunction(e)if e==Null then
self:WriteNil()else
self:WriteError(e)end
end
local l={s="",i=0}function l:New(n)local e={}o(e,self)self.__index=self
e.s=n or e.s
return e
end
function l:Peek()local n=self.i+1
if n<=#self.s then
return e.sub(self.s,n,n)end
return nil
end
function l:Next()self.i=self.i+1
if self.i<=#self.s then
return e.sub(self.s,self.i,self.i)end
return nil
end
function l:All()return self.s
end
local n={escapes={['t']='\t',['n']='\n',['f']='\f',['r']='\r',['b']='\b',}}function n:New(n)local e={}e.reader=l:New(n)o(e,self)self.__index=self
return e;end
function n:Read()self:SkipWhiteSpace()local n=self:Peek()if n==nil then
i(e.format("Nil string: '%s'",self:All()))elseif n=='{'then
return self:ReadObject()elseif n=='['then
return self:ReadArray()elseif n=='"'then
return self:ReadString()elseif e.find(n,"[%+%-%d]")then
return self:ReadNumber()elseif n=='t'then
return self:ReadTrue()elseif n=='f'then
return self:ReadFalse()elseif n=='n'then
return self:ReadNull()elseif n=='/'then
self:ReadComment()return self:Read()else
i(e.format("Invalid input: '%s'",self:All()))end
end
function n:ReadTrue()self:TestReservedWord{'t','r','u','e'}return true
end
function n:ReadFalse()self:TestReservedWord{'f','a','l','s','e'}return false
end
function n:ReadNull()self:TestReservedWord{'n','u','l','l'}return nil
end
function n:TestReservedWord(n)for r,t in f(n)do
if self:Next()~=t then
i(e.format("Error reading '%s': %s",u.concat(n),self:All()))end
end
end
function n:ReadNumber()local n=self:Next()local t=self:Peek()while t~=nil and e.find(t,"[%+%-%d%.eE]")do
n=n..self:Next()t=self:Peek()end
n=a(n)if n==nil then
i(e.format("Invalid number: '%s'",n))else
return n
end
end
function n:ReadString()local n=""r(self:Next()=='"')while self:Peek()~='"'do
local e=self:Next()if e=='\\'then
e=self:Next()if self.escapes[e]then
e=self.escapes[e]end
end
n=n..e
end
r(self:Next()=='"')local t=function(n)return e.char(a(n,16))end
return e.gsub(n,"u%x%x(%x%x)",t)end
function n:ReadComment()r(self:Next()=='/')local n=self:Next()if n=='/'then
self:ReadSingleLineComment()elseif n=='*'then
self:ReadBlockComment()else
i(e.format("Invalid comment: %s",self:All()))end
end
function n:ReadBlockComment()local n=false
while not n do
local t=self:Next()if t=='*'and self:Peek()=='/'then
n=true
end
if not n and
t=='/'and
self:Peek()=="*"then
i(e.format("Invalid comment: %s, '/*' illegal.",self:All()))end
end
self:Next()end
function n:ReadSingleLineComment()local e=self:Next()while e~='\r'and e~='\n'do
e=self:Next()end
end
function n:ReadArray()local t={}r(self:Next()=='[')local n=false
if self:Peek()==']'then
n=true;end
while not n do
local r=self:Read()t[#t+1]=r
self:SkipWhiteSpace()if self:Peek()==']'then
n=true
end
if not n then
local n=self:Next()if n~=','then
i(e.format("Invalid array: '%s' due to: '%s'",self:All(),n))end
end
end
r(']'==self:Next())return t
end
function n:ReadObject()local l={}r(self:Next()=='{')local t=false
if self:Peek()=='}'then
t=true
end
while not t do
local r=self:Read()if s(r)~="string"then
i(e.format("Invalid non-string object key: %s",r))end
self:SkipWhiteSpace()local n=self:Next()if n~=':'then
i(e.format("Invalid object: '%s' due to: '%s'",self:All(),n))end
self:SkipWhiteSpace()local o=self:Read()l[r]=o
self:SkipWhiteSpace()if self:Peek()=='}'then
t=true
end
if not t then
n=self:Next()if n~=','then
i(e.format("Invalid array: '%s' near: '%s'",self:All(),n))end
end
end
r(self:Next()=="}")return l
end
function n:SkipWhiteSpace()local n=self:Peek()while n~=nil and e.find(n,"[%s/]")do
if n=='/'then
self:ReadComment()else
self:Next()end
n=self:Peek()end
end
function n:Peek()return self.reader:Peek()end
function n:Next()return self.reader:Next()end
function n:All()return self.reader:All()end
function encode(n)local e=t:New()e:Write(n)return e:ToString()end
function decode(e)local e=n:New(e)return e:Read()end
function Null()return Null
end
end)package.preload['asyncHttp']=(function(...)local e=require"socket"local n=require"dispatch"local c=require"socket.http"local r=require"ltn12"n.TIMEOUT=10
local t=Runtime
local u=table
local e=print
local e=coroutine
module(...)function request(f,a,i,e)local n=n.newhandler("coroutine")local s=true
n:start(function()local l,d=r.sink.table()local t,o
if e then
if e.headers then
t=e.headers
end
if e.body then
o=r.source.string(e.body)end
end
local e,n,t=c.request{url=f,method=a,create=n.tcp,sink=l,source=o,headers=t}if e then
i{statusCode=n,headers=t,response=u.concat(d),sink=l,isError=false}else
i{isError=true}end
s=false
end)local e={}function e.enterFrame()if s then
n:step()else
t:removeEventListener("enterFrame",e)end
end
function e:cancel()t:removeEventListener("enterFrame",self)n=nil
end
t:addEventListener("enterFrame",e)return e
end
end)package.preload['dispatch']=(function(...)local n=_G
local i=require("table")local l=require("socket")local t=require("coroutine")local s=type
module("dispatch")TIMEOUT=60
local o={}function newhandler(e)e=e or"coroutine"return o[e]()end
local function e(n,e)return e()end
function o.sequential()return{tcp=l.tcp,start=e}end
function l.protect(e)return function(...)local r=t.create(e)while true do
local e={t.resume(r,n.unpack(arg))}local i=i.remove(e,1)if not i then
if s(e[1])=='table'then
return nil,e[1][1]else n.error(e[1])end
end
if t.status(r)=="suspended"then
arg={t.yield(n.unpack(e))}else
return n.unpack(e)end
end
end
end
local function s()local e={}local t={}return n.setmetatable(t,{__index={insert=function(t,n)if not e[n]then
i.insert(t,n)e[n]=i.getn(t)end
end,remove=function(l,r)local t=e[r]if t then
e[r]=nil
local n=i.remove(l)if n~=r then
e[n]=t
l[t]=n
end
end
end}})end
local function a(i,e,r)if not e then return nil,r end
e:settimeout(0)local s={__index=function(i,t)i[t]=function(...)arg[1]=e
return e[t](n.unpack(arg))end
return i[t]end}local l=false
local r={}function r:settimeout(e,n)if e==0 then l=true
else l=false end
return 1
end
function r:send(o,n,s)n=(n or 1)-1
local l,r
while true do
if t.yield(i.sending,e)=="timeout"then
return nil,"timeout"end
l,r,n=e:send(o,n+1,s)if r~="timeout"then return l,r,n end
end
end
function r:receive(s,r)local n="timeout"local o
while true do
if t.yield(i.receiving,e)=="timeout"then
return nil,"timeout"end
o,n,r=e:receive(s,r)if(n~="timeout")or l then
return o,n,r
end
end
end
function r:connect(o,l)local r,n=e:connect(o,l)if n=="timeout"then
if t.yield(i.sending,e)=="timeout"then
return nil,"timeout"end
r,n=e:connect(o,l)if r or n=="already connected"then return 1
else return nil,"non-blocking connect failed"end
else return r,n end
end
function r:accept()while 1 do
if t.yield(i.receiving,e)=="timeout"then
return nil,"timeout"end
local n,e=e:accept()if e~="timeout"then
return a(i,n,e)end
end
end
function r:close()i.stamp[e]=nil
i.sending.set:remove(e)i.sending.cortn[e]=nil
i.receiving.set:remove(e)i.receiving.cortn[e]=nil
return e:close()end
return n.setmetatable(r,s)end
local i={__index={}}function schedule(i,r,e,t)if r then
if i and e then
e.set:insert(t)e.cortn[t]=i
e.stamp[t]=l.gettime()end
else n.error(e)end
end
function kick(e,n)e.cortn[n]=nil
e.set:remove(n)end
function wakeup(i,n)local e=i.cortn[n]if e then
kick(i,n)return e,t.resume(e)else
return nil,true
end
end
function abort(i,n)local e=i.cortn[n]if e then
kick(i,n)t.resume(e,"timeout")end
end
function i.__index:step()local e,t=l.select(self.receiving.set,self.sending.set,.1)for n,e in n.ipairs(e)do
schedule(wakeup(self.receiving,e))end
for n,e in n.ipairs(t)do
schedule(wakeup(self.sending,e))end
local t=l.gettime()for e,n in n.pairs(self.stamp)do
if e.class=="tcp{client}"and t-n>TIMEOUT then
abort(self.sending,e)abort(self.receiving,e)end
end
end
function i.__index:start(e)local e=t.create(e)schedule(e,t.resume(e))end
function o.coroutine()local e={}local e={stamp=e,sending={name="sending",set=s(),cortn={},stamp=e},receiving={name="receiving",set=s(),cortn={},stamp=e},}function e.tcp()return a(e,l.tcp())end
return n.setmetatable(e,i)end
end)package.preload['revmob_messages']=(function(...)REVMOB_MSG_NO_ADS="No ads for this device/country right now"REVMOB_MSG_NO_SESSION="The method RevMob.startSession(REVMOB_IDS) has not been called"REVMOB_MSG_UNKNOWN_REASON="Ad was not received for an unknown reason: "REVMOB_MSG_OPEN_MARKET="Opening market"REVMOB_EVENT_AD_RECEIVED="adReceived"REVMOB_EVENT_AD_NOT_RECEIVED="adNotReceived"REVMOB_EVENT_AD_DISPLAYED="adDisplayed"REVMOB_EVENT_AD_CLICKED="adClicked"REVMOB_EVENT_AD_CLOSED="adClosed"REVMOB_EVENT_INSTALL_RECEIVED="installReceived"REVMOB_EVENT_INSTALL_NOT_RECEIVED="installNotReceived"end)package.preload['revmob_about']=(function(...)REVMOB_SDK={NAME="corona",VERSION="3.3.0"}end)package.preload['revmob_client']=(function(...)local i=require('json')require('revmob_about')require('revmob_messages')require('revmob_utils')require("asyncHttp")local t='https://api.bcfads.com'local e='9774d5f368157442'local n='4c6dbc5d000387f3679a53d76f6944211a7f2224'local r=e
Connection={wifi=nil,wwan=nil,hasInternetConnection=function()return(not network.canDetectNetworkStatusChanges)or(Connection.wifi or Connection.wwan)end}function RevMobNetworkReachabilityListener(e)if e.isReachable then
log("Internet connection available.")else
log("Could not connect to RevMob site. No ads will be available.")end
Connection.wwan=e.isReachableViaCellular
Connection.wifi=e.isReachableViaWiFi
log("IsReachableViaCellular: "..tostring(e.isReachableViaCellular))log("IsReachableViaWiFi: "..tostring(e.isReachableViaWiFi))end
if network.canDetectNetworkStatusChanges then
network.setStatusListener("revmob.com",RevMobNetworkReachabilityListener)log("Listening network reachability.")end
Device={identities=nil,country=nil,manufacturer=nil,model=nil,os_version=nil,connection_speed=nil,new=function(n,e)e=e or{}setmetatable(e,n)n.__index=n
e.identities=e:buildDeviceIdentifierAsTable()e.country=system.getPreference("locale","country")e.locale=system.getPreference("locale","language")e.manufacturer=e:getManufacturer()e.model=e:getModel()e.os_version=system.getInfo("platformVersion")if Connection.wifi then
e.connection_speed="wifi"elseif Connection.wwan then
e.connection_speed="wwan"else
e.connection_speed="other"end
return e
end,isSimulator=function(e)return"simulator"==system.getInfo("environment")or system.getInfo("name")==""or system.getInfo("name")=="iPhone Simulator"or system.getInfo("name")=="iPad Simulator"end,isAndroid=function(e)return"Android"==system.getInfo("platformName")end,isIphoneOS=function(e)return"iPhone OS"==system.getInfo("platformName")end,isIPad=function(e)return"iPad"==system.getInfo("model")end,getDeviceId=function(e)return(e:isSimulator()and r)or system.getInfo("deviceID")end,buildDeviceIdentifierAsTable=function(e)local e=e:getDeviceId()e=string.gsub(e,"-","")e=string.lower(e)if(string.len(e)==40)then
return{udid=e}elseif(string.len(e)==14 or string.len(e)==15 or string.len(e)==17 or string.len(e)==18)then
return{mobile_id=e}elseif(string.len(e)==16)then
return{android_id=e}else
log("WARNING: device not identified, no registration or ad unit will work")return nil
end
end,getManufacturer=function(e)local e=system.getInfo("platformName")if(e=="iPhone OS")then
return"Apple"end
return e
end,getModel=function(e)local e=e:getManufacturer()if(e=="Apple")then
return system.getInfo("architectureInfo")end
return system.getInfo("model")end}Client={payload={},adunit=nil,applicationId=nil,device=nil,TEST_WITH_ADS="with_ads",TEST_WITHOUT_ADS="without_ads",new=function(e,n,t)local n={adunit=n,applicationId=t or RevMobSessionManager.appID,device=Device:new()}setmetatable(n,e)e.__index=e
return n
end,url=function(e)return t.."/api/v4/mobile_apps/"..e.applicationId.."/"..e.adunit.."/fetch.json"end,urlInstall=function(e)return t.."/api/v4/mobile_apps/"..e.applicationId.."/install.json"end,urlSession=function(e)return t.."/api/v4/mobile_apps/"..e.applicationId.."/sessions.json"end,payloadAsJsonString=function(n)if RevMobSessionManager.testMode~=nil then
log("TESTING MODE ACTIVE")local e=nil
if RevMobSessionManager.testMode==Client.TEST_WITHOUT_ADS then
e={response=Client.TEST_WITHOUT_ADS}else
e={response=Client.TEST_WITH_ADS}end
return i.encode({device=n.device,sdk={name=REVMOB_SDK["NAME"],version=REVMOB_SDK["VERSION"]},testing=e})end
return i.encode({device=n.device,sdk={name=REVMOB_SDK["NAME"],version=REVMOB_SDK["VERSION"]}})end,post=function(t,n,e)if n==nil then return end
if not e then e=function(e)end
end
local i={["Content-Length"]=tostring(#n),["Content-Type"]="application/json"}local e=asyncHttp.request(t,"POST",e,{body=n,headers=i})timer.performWithDelay(5e3,function()e:cancel()native.setActivityIndicator(false)end)end,fetch=function(n,e)if RevMobSessionManager.isSessionStarted()then
local t=coroutine.create(Client.post)coroutine.resume(t,n:url(),n:payloadAsJsonString(),e)else
local n={statusCode=0,response={error="Session not started"},headers={}}if e then
e(n)end
end
end,install=function(e,t)local n=coroutine.create(Client.post)coroutine.resume(n,e:urlInstall(),e:payloadAsJsonString(),t)end,startSession=function(e)local n=coroutine.create(Client.post)coroutine.resume(n,e:urlSession(),e:payloadAsJsonString(),listener)end,theFetchSucceed=function(t,e,n)if(e.statusCode==204)then
log(REVMOB_MSG_NO_ADS)if n~=nil then n({type=REVMOB_EVENT_AD_NOT_RECEIVED,ad=t,reason=REVMOB_MSG_NO_ADS})end
return false,nil
elseif(e.statusCode~=200 and e.statusCode~=302 and e.statusCode~=303)then
local e=REVMOB_MSG_UNKNOWN_REASON..tostring(e.statusCode)log(e)if n~=nil then n({type=REVMOB_EVENT_AD_NOT_RECEIVED,ad=t,reason=e})end
return false,nil
end
if e.statusCode==302 or e.statusCode==303 then
return true,nil
end
local i,e=pcall(i.decode,e.response)if(not i or e==nil)then
local e=REVMOB_MSG_UNKNOWN_REASON..tostring(i).." / "..tostring(e)log(e)if n~=nil then n({type=REVMOB_EVENT_AD_NOT_RECEIVED,ad=t,reason=e})end
end
return i,e
end,}end)package.preload['revmob_utils']=(function(...)function log(e)print("[RevMob] "..tostring(e))io.output():flush()end
getLink=function(n,e)for t,e in ipairs(e)do
if e.rel==n then
return e.href
end
end
return nil
end
Screen={left=display.screenOriginX,top=display.screenOriginY,right=display.contentWidth-display.screenOriginX,bottom=display.contentHeight-display.screenOriginY,scaleX=display.contentScaleX,scaleY=display.contentScaleY,width=function(e)return e.right-e.left
end,height=function(e)return e.bottom-e.top
end,}getMarketURL=function(i,e)local t=require('socket.http')local n=require("ltn12")local r={}if e==nil then
e=""end
local n,e,r=t.request{method="POST",url=i,source=n.source.string(e),headers={["Content-Length"]=tostring(#e),["Content-Type"]="application/json"},sink=n.sink.table(r),}if(e==302 or e==303)then
local n="details%?id=[a-zA-Z0-9%.]+"local t="android%?p=[a-zA-Z0-9%.]+"local e=r['location']if(string.sub(e,1,string.len("market://"))=="market://")then
return e
elseif(string.match(e,n,1))then
local e=string.match(e,n,1)return"market://"..e
elseif(string.sub(e,1,string.len("amzn://"))=="amzn://")then
return e
elseif(string.match(e,t,1))then
local e=string.match(e,t,1)return"amzn://apps/"..e
else
return getMarketURL(e)end
end
return i
end
end)package.preload['fullscreen']=(function(...)require('revmob_messages')require('revmob_client')require('revmob_utils')local e="fullscreen"Fullscreen={ASSETS_PATH='revmob-assets/fullscreen/',DELAYED_LOAD_IMAGE=10,TMP_IMAGE_NAME="fullscreen.jpg",CLOSE_BUTTON_X=Screen.right-30,CLOSE_BUTTON_Y=Screen.top+40,CLOSE_BUTTON_WIDTH=Device:isIPad()and 30 or 35,DELAY=200,adClicked=false,clickUrl=nil,screenGroup=nil,adListener=nil,notifyAdListener=function(e)if Fullscreen.adListener then
Fullscreen.adListener(e)end
end,networkListener=function(n)local n,t=Client.theFetchSucceed(e,n,revmobListener)if n then
local n=t['fullscreen']['links']Fullscreen.clickUrl=getLink('clicks',n)Fullscreen.imageUrl=getLink('image',n)Fullscreen.closeButtonImageUrl=getLink('close_button',n)timer.performWithDelay(Fullscreen.DELAYED_LOAD_IMAGE,function()Fullscreen.notifyAdListener({type=REVMOB_EVENT_AD_DISPLAYED,ad=e})display.loadRemoteImage(Fullscreen.imageUrl,"GET",Fullscreen.loadImage,Fullscreen.TMP_IMAGE_NAME,system.TemporaryDirectory)end)end
end,loadImage=function(n)if n.isError then
log("Ad not received.")native.setActivityIndicator(false)Fullscreen.notifyAdListener({type=REVMOB_EVENT_AD_NOT_RECEIVED,ad=e})return
end
Fullscreen.localizedImage=n.target
Fullscreen.localizedImage.x=display.contentWidth/2
Fullscreen.localizedImage.y=display.contentHeight/2
Fullscreen.localizedImage.width=Screen:width()Fullscreen.localizedImage.height=Screen:height()Fullscreen.localizedImage.tap=function(e,e)Fullscreen.adClick()return true
end
Fullscreen.localizedImage.touch=function(e,e)return true
end
Fullscreen.localizedImage:addEventListener("tap",Fullscreen.localizedImage)Fullscreen.localizedImage:addEventListener("touch",Fullscreen.localizedImage)Fullscreen.loadCloseButtonImage()Fullscreen.create()log("Ad received")native.setActivityIndicator(false)Fullscreen.notifyAdListener({type=REVMOB_EVENT_AD_RECEIVED,ad=e})end,loadCloseButtonImage=function()local n=Fullscreen.ASSETS_PATH..'close_button.png'Fullscreen.closeButton=display.newImageRect(n,Fullscreen.CLOSE_BUTTON_WIDTH,Fullscreen.CLOSE_BUTTON_WIDTH)Fullscreen.closeButton.x=Fullscreen.CLOSE_BUTTON_X
Fullscreen.closeButton.y=Fullscreen.CLOSE_BUTTON_Y
Fullscreen.closeButton.width=Fullscreen.CLOSE_BUTTON_WIDTH
Fullscreen.closeButton.height=Fullscreen.CLOSE_BUTTON_WIDTH
Fullscreen.closeButton.tap=function(n,n)Fullscreen.back()Fullscreen.notifyAdListener({type=REVMOB_EVENT_AD_CLOSED,ad=e})return true
end
Fullscreen.closeButton.touch=function(e,e)return true
end
Fullscreen.closeButton:addEventListener("tap",Fullscreen.closeButton)Fullscreen.closeButton:addEventListener("touch",Fullscreen.closeButton)end,create=function()Fullscreen.screenGroup=display.newGroup()Runtime:addEventListener("enterFrame",Fullscreen.update)Runtime:addEventListener("system",Fullscreen.onApplicationResume)Fullscreen.screenGroup:insert(Fullscreen.localizedImage)Fullscreen.screenGroup:insert(Fullscreen.closeButton)end,release=function(e)Runtime:removeEventListener("enterFrame",Fullscreen.update)Runtime:removeEventListener("system",Fullscreen.onApplicationResume)pcall(Fullscreen.localizedImage.removeEventListener,Fullscreen.localizedImage,"tap",Fullscreen.localizedImage)pcall(Fullscreen.localizedImage.removeEventListener,Fullscreen.localizedImage,"touch",Fullscreen.localizedImage)pcall(Fullscreen.closeButton.removeEventListener,Fullscreen.closeButton,"tap",Fullscreen.closeButton)pcall(Fullscreen.closeButton.removeEventListener,Fullscreen.closeButton,"touch",Fullscreen.closeButton)if Fullscreen.screenGroup then
Fullscreen.screenGroup:removeSelf()Fullscreen.screenGroup=nil
end
Fullscreen.adClicked=false
log("Fullscreen Released.")return true
end,back=function()timer.performWithDelay(Fullscreen.DELAY,Fullscreen.release)return true
end,adClick=function()if not Fullscreen.adClicked then
Fullscreen.adClicked=true
Fullscreen.notifyAdListener({type=REVMOB_EVENT_AD_CLICKED,ad=e})local e=getMarketURL(Fullscreen.clickUrl)log(REVMOB_MSG_OPEN_MARKET)if e then system.openURL(e)end
Fullscreen.back()end
return true
end,update=function(e)if(Fullscreen.screenGroup)then
Fullscreen.screenGroup:toFront()end
end,show=function(e)Fullscreen.adListener=e
local e=Client:new("fullscreens")e:fetch(Fullscreen.networkListener)end,onApplicationResume=function(e)if e.type=="applicationResume"then
log("Application resumed.")Fullscreen.release()end
end,}end)package.preload['fullscreen_web']=(function(...)require('revmob_messages')require('revmob_client')require('revmob_utils')local n="fullscreen"FullscreenWeb={autoshow=true,listener=nil,clickUrl=nil,htmlUrl=nil,new=function(e)local e=e or{}setmetatable(e,FullscreenWeb)return e
end,load=function(e)e.networkListener=function(t)local t,i=Client.theFetchSucceed(n,t,e.listener)native.setActivityIndicator(false)if t then
local t=i['fullscreen']['links']e.clickUrl=getLink('clicks',t)e.htmlUrl=getLink('html',t)if e.listener~=nil then e.listener({type=REVMOB_EVENT_AD_RECEIVED,ad=n})end
if e.autoshow then
e:show()end
end
end
local n=Client:new("fullscreens")n:fetch(e.networkListener)end,isLoaded=function(e)return e.htmlUrl~=nil and e.clickUrl~=nil
end,show=function(e)native.setActivityIndicator(false)if not e:isLoaded()then
log("Ad is not loaded yet to be shown")return
end
e.clickListener=function(t)if string.sub(t.url,-string.len("#close"))=="#close"then
if e.changeOrientationListener then
Runtime:removeEventListener("orientation",e.changeOrientationListener)end
if e.listener~=nil then e.listener({type=REVMOB_EVENT_AD_CLOSED,ad=n})end
return false
end
if string.sub(t.url,-string.len("#click"))=="#click"then
if e.changeOrientationListener then
Runtime:removeEventListener("orientation",e.changeOrientationListener)end
if e.listener~=nil then e.listener({type=REVMOB_EVENT_AD_CLICKED,ad=n})end
local e=getMarketURL(e.clickUrl)log(REVMOB_MSG_OPEN_MARKET)if e then system.openURL(e)end
return false
end
if t.errorCode then
log("Error: "..tostring(t.errorMessage))end
return true
end
local t={hasBackground=false,autoCancel=true,urlRequest=e.clickListener}e.changeOrientationListener=function(n)native.cancelWebPopup()timer.performWithDelay(200,function()native.showWebPopup(e.htmlUrl,t)end)end
timer.performWithDelay(1,function()if e.listener~=nil then e.listener({type=REVMOB_EVENT_AD_DISPLAYED,ad=n})end
native.showWebPopup(e.htmlUrl,t)end)Runtime:addEventListener("orientation",e.changeOrientationListener)end,close=function(e)if e.changeOrientationListener then
Runtime:removeEventListener("orientation",e.changeOrientationListener)end
native.cancelWebPopup()end,}FullscreenWeb.__index=FullscreenWeb
end)package.preload['fullscreen_chooser']=(function(...)require('revmob_messages')require('revmob_client')require('revmob_utils')require('fullscreen')require('fullscreen_web')local t="fullscreen"FullscreenChooser={show=function(e)networkListener=function(n)local n,i=Client.theFetchSucceed(t,n,e)native.setActivityIndicator(false)if n then
local n=i['fullscreen']['links']local r=getLink('clicks',n)local i=getLink('html',n)local l=getLink('image',n)local n=getLink('close_button',n)if e~=nil then e({type=REVMOB_EVENT_AD_RECEIVED,ad=t})end
if i then
local e=FullscreenWeb.new({listener=e})e.htmlUrl=i
e.clickUrl=r
e:show()else
Fullscreen.adListener=e
Fullscreen.clickUrl=r
Fullscreen.imageUrl=l
Fullscreen.closeButtonImageUrl=n
timer.performWithDelay(Fullscreen.DELAYED_LOAD_IMAGE,function()display.loadRemoteImage(Fullscreen.imageUrl,"GET",Fullscreen.loadImage,Fullscreen.TMP_IMAGE_NAME,system.TemporaryDirectory)end)end
end
end
local e=Client:new("fullscreens")e:fetch(networkListener)end,}end)package.preload['banner']=(function(...)require('revmob_messages')require('revmob_client')require('revmob_utils')local n="banner"Banner={DELAYED_LOAD_IMAGE=10,TMP_IMAGE_NAME="bannerImage.jpg",WIDTH=(Screen:width()>640)and 640 or Screen:width(),HEIGHT=Device:isIPad()and 100 or 50*(Screen.bottom-Screen.top)/display.contentHeight,clickUrl=nil,imageUrl=nil,image=nil,x=nil,y=nil,width=nil,height=nil,listener=nil,new=function(t,e)local e=e or{}setmetatable(e,t)t.__index=t
e.notifyListener=function(n)if e.listener then
e.listener(n)end
end
e.adClick=function(t)e.notifyListener({type=REVMOB_EVENT_AD_CLICKED,ad=n})log(REVMOB_MSG_OPEN_MARKET)local n=getMarketURL(e.clickUrl)if n then system.openURL(n)end
return true
end
e.adTouch=function(n)return true
end
e.update=function(n)if(e.image)then
if(e.image.toFront~=nil)then
e.image:toFront()else
e:release()end
end
end
local i=function(n)if e.image~=nil then
e:release()end
e.image=n.target
e:show()end
local n=function(t)local t,r=Client.theFetchSucceed(n,t,e.listener)if t then
local t=r['banners'][1]['links']e.clickUrl=getLink('clicks',t)e.imageUrl=getLink('image',t)timer.performWithDelay(e.DELAYED_LOAD_IMAGE,function()display.loadRemoteImage(e.imageUrl,"GET",i,e.TMP_IMAGE_NAME,system.TemporaryDirectory)log("Ad received")e.notifyListener({type=REVMOB_EVENT_AD_RECEIVED,ad=n})end)end
end
local t=Client:new("banners")t:fetch(n)return e
end,show=function(e)if e.image~=nil then
e.image.alpha=1
if e.listener~=nil then e.listener({type=REVMOB_EVENT_AD_DISPLAYED,ad=n})end
e:setDimension()e:setPosition()e.image.tap=e.adClick
e.image.touch=e.adTouch
e.image:addEventListener("tap",e.image)e.image:addEventListener("touch",e.image)Runtime:addEventListener("enterFrame",e.update)end
end,hide=function(e)if e.image~=nil then
e.image.alpha=0
end
end,release=function(e)log("Releasing event listeners.")Runtime:removeEventListener("enterFrame",e.update)if e.image then
log("Removing image")pcall(e.image.removeEventListener,e.image,"tap",e.image)pcall(e.image.removeEventListener,e.image,"touch",e.image)e.image:removeSelf()end
e.image=nil
end,setPosition=function(e,n,t)e.x=n or e.x
e.y=t or e.y
if e.image then
e.image.x=e.x or(Screen.left+e.WIDTH/2)e.image.y=e.y or(Screen.bottom-e.HEIGHT/2)end
end,setDimension=function(e,t,n)e.width=t or e.width
e.height=n or e.height
if e.image then
e.image.width=e.width or e.WIDTH
e.image.height=e.height or e.HEIGHT
end
end,}end)package.preload['banner_web']=(function(...)require('revmob_messages')require('revmob_client')require('revmob_utils')local n="banner"local i="Corona has a bug if WebView x,y is different from 0,0. So RevMob banner does not support another point yet."BannerWeb={autoshow=true,listener=nil,clickUrl=nil,htmlUrl=nil,webView=nil,x=0,y=0,width=320,height=50,rotation=0,new=function(e)local e=e or{}setmetatable(e,BannerWeb)if e.x~=0 or e.y~=0 then
log(i)e.x=0
e.y=0
end
return e
end,load=function(e)e.networkListener=function(t)local i,t=Client.theFetchSucceed(n,t,e.listener)if i then
local t=t['banners'][1]['links']e.clickUrl=getLink('clicks',t)e.htmlUrl=getLink('html',t)if e.listener~=nil then e.listener({type=REVMOB_EVENT_AD_RECEIVED,ad=n})end
e:configWebView()if e.autoshow then
e:show()end
end
end
local n=Client:new("banners")n:fetch(e.networkListener)end,configWebView=function(e)e.clickListener=function(t)if string.sub(t.url,-string.len("#click"))=="#click"then
if e.listener~=nil then e.listener({type=REVMOB_EVENT_AD_CLICKED,ad=n})end
local n=getMarketURL(e.clickUrl)log(REVMOB_MSG_OPEN_MARKET)if n then system.openURL(n)end
e:hide()end
if t.errorCode then
log("Error: "..tostring(t.errorMessage))end
return true
end
e.webView=native.newWebView(e.x,e.y,e.width,e.height,e.clickListener)e:hide()e.webView.rotation=e.rotation
e.webView.canGoBack=false
e.webView.canGoForward=false
e.webView.hasBackground=true
e.webView:request(e.htmlUrl)e.clickListener2=function(n)return true end
e.webView.tap=e.clickListener2
e.webView.touch=e.clickListener2
e.webView:addEventListener("tap",e.webView)e.webView:addEventListener("touch",e.webView)end,isLoaded=function(e)return e.htmlUrl~=nil and e.clickUrl~=nil
end,show=function(e)if not e:isLoaded()then
log("Ad is not loaded yet to be shown")return
end
if e.webView~=nil then
timer.performWithDelay(1,function()if e.listener~=nil then e.listener({type=REVMOB_EVENT_AD_DISPLAYED,ad=n})end
e.webView.alpha=1
end)end
end,update=function(e,n,o,t,l,r)if e.webView then
if n~=0 or o~=0 then
log(i)end
e.webView.width=t or e.webView.width
e.webView.height=l or e.webView.height
e.webView.rotation=r or e.webView.rotation
end
end,release=function(e)if e.webView then
e.webView:removeEventListener("tap",e.webView)e.webView:removeEventListener("touch",e.webView)e.webView:removeSelf()e.webView=nil
end
end,hide=function(e)if e.webView~=nil then e.webView.alpha=0 end
end,}BannerWeb.__index=BannerWeb
end)package.preload['adlink']=(function(...)require('revmob_messages')require('revmob_client')require('revmob_utils')require('session_manager')local t="link"AdLink={open=function(e)if RevMobSessionManager.isSessionStarted()then
internalListener=function(n)local i,r=Client.theFetchSucceed(t,n,e)if i then
if(n.statusCode==302 or n.statusCode==303)then
local n=getMarketURL(n.headers['location'])or n.headers['location']if n then
if e then e({type=REVMOB_EVENT_AD_RECEIVED,ad=t})end
log(REVMOB_MSG_OPEN_MARKET)system.openURL(n)else
local n=REVMOB_MSG_UNKNOWN_REASON.."No market url"log(n)if e then e({type=REVMOB_EVENT_AD_NOT_RECEIVED,ad=t,reason=n})end
end
end
end
end
local e=Client:new("links")e.post(e:url(),e:payloadAsJsonString(),internalListener)else
log(REVMOB_MSG_NO_SESSION)if e then e({type=REVMOB_EVENT_AD_NOT_RECEIVED,ad=t,reason=REVMOB_MSG_NO_SESSION})end
end
end,}end)package.preload['popup']=(function(...)require('revmob_messages')require('revmob_client')local n="popup"Popup={DELAYED_LOAD_IMAGE=10,YES_BUTTON_POSITION=2,message=nil,click_url=nil,adListener=nil,notifyAdListener=function(e)if Popup.adListener then
Popup.adListener(e)end
end,show=function(e)Popup.adListener=e
client=Client:new("pop_ups")client:fetch(Popup.networkListener)end,networkListener=function(e)local t,e=Client.theFetchSucceed(n,e,Popup.adListener)if t then
if Popup.isParseOk(e)then
Popup.message=e["pop_up"]["message"]Popup.click_url=e["pop_up"]["links"][1]["href"]timer.performWithDelay(Popup.DELAYED_LOAD_IMAGE,function()Popup.notifyAdListener({type=REVMOB_EVENT_AD_DISPLAYED,ad=n})local e=native.showAlert(Popup.message,"",{"No, thanks.","Yes, Sure!"},Popup.click)end)Popup.notifyAdListener({type=REVMOB_EVENT_AD_RECEIVED,ad=n})else
log(REVMOB_MSG_UNKNOWN_REASON)Popup.notifyAdListener({type=REVMOB_EVENT_AD_NOT_RECEIVED,ad=n,reason=REVMOB_MSG_UNKNOWN_REASON})end
end
end,isParseOk=function(e)if(e==nil)then
return false
elseif(e["pop_up"]==nil)then
return false
elseif(e["pop_up"]["message"]==nil)then
return false
elseif(e["pop_up"]["links"]==nil)then
return false
elseif(e["pop_up"]["links"][1]==nil)then
return false
elseif(e["pop_up"]["links"][1]["href"]==nil)then
return false
end
return true
end,click=function(e)if"clicked"==e.action then
if Popup.YES_BUTTON_POSITION==e.index then
Popup.notifyAdListener({type=REVMOB_EVENT_AD_CLICKED,ad=n})local e=getMarketURL(Popup.click_url)log(REVMOB_MSG_OPEN_MARKET)if e then system.openURL(e)end
else
Popup.notifyAdListener({type=REVMOB_EVENT_AD_CLOSED,ad=n})end
end
end}end)package.preload['advertiser']=(function(...)local e=require('json')require('revmob_messages')require('revmob_client')require('revmob_utils')require('loadsave')Advertiser={registerInstall=function(n,e)revMobListener=function(t)if(t.statusCode==200)then
RevMobPrefs.addItem(n,true)RevMobPrefs.saveToFile()log("Install received.")if e~=nil then
e.notifyAdListener({type=REVMOB_EVENT_INSTALL_RECEIVED})end
else
log("Install not received.")if e~=nil then
e.notifyAdListener({type=REVMOB_EVENT_INSTALL_NOT_RECEIVED})end
end
end
RevMobPrefs.loadFromFile()local e=RevMobPrefs.getItem(n)if e==true then
log("Install already registered in this device")else
local e=Client:new("",n)e:install(revMobListener)end
end}end)package.preload['loadsave']=(function(...)local n=require('json')RevMobPrefs={FILENAME="revmob_sdk.json",preferences={},getItem=function(e)return RevMobPrefs.preferences[e]or nil
end,addItem=function(n,e)RevMobPrefs.preferences[n]=e
end,saveToFile=function()local e=system.pathForFile(RevMobPrefs.FILENAME,system.DocumentsDirectory)local e=io.open(e,"w")local n=n.encode(RevMobPrefs.preferences)e:write(n)io.close(e)end,loadFromFile=function()local e=system.pathForFile(RevMobPrefs.FILENAME,system.DocumentsDirectory)local e=io.open(e,"r")if e then
local t=e:read("*a")RevMobPrefs.preferences=n.decode(t)if RevMobPrefs.preferences==nil then
RevMobPrefs.preferences={}end
io.close(e)else
RevMobPrefs.saveToFile()RevMobPrefs.loadFromFile()end
end}end)package.preload['session_manager']=(function(...)require("revmob_utils")RevMobSessionManager={listenersRegistered=false,appID=nil,sessionStarted=false,testMode=nil,startSession=function(e,n)RevMobSessionManager.testMode=n
if e then
if not RevMobSessionManager.sessionStarted then
RevMobSessionManager.appID=e
RevMobSessionManager.sessionStarted=true
local e=Client:new("")e:startSession()log("Session started for App ID: "..RevMobSessionManager.appID)else
log("Session has already been started for App ID: "..e)end
end
end,sessionManagement=function(e)if e.type=="applicationSuspend"then
RevMobSessionManager.sessionStarted=false
elseif e.type=="applicationResume"then
RevMobSessionManager.startSession(RevMobSessionManager.appID)end
end,isSessionStarted=function()return RevMobSessionManager.sessionStarted
end,}if RevMobSessionManager.listenersRegistered==false then
RevMobSessionManager.listenersRegistered=true
Runtime:removeEventListener("system",RevMobSessionManager.sessionManagement)Runtime:addEventListener("system",RevMobSessionManager.sessionManagement)end end)require('revmob_about')require('revmob_utils')require('revmob_client')require('revmob_messages')require('fullscreen')require('fullscreen_web')require('fullscreen_chooser')require('banner')require('banner_web')require('adlink')require('popup')require('advertiser')require('session_manager')local t='4f56aa6e3dc441000e005a20'local n=5e3
RevMob={TEST_WITH_ADS=Client.TEST_WITH_ADS,TEST_WITHOUT_ADS=Client.TEST_WITHOUT_ADS,getRevMobApplicationID=function(n,e)local e=nil
if Device:isSimulator()then
e=t
log("Using App ID for simulator: "..e)else
e=n[system.getInfo("platformName")]log("App ID: "..tostring(e))end
return e
end,startSession=function(e,n)RevMobSessionManager.startSession(RevMob.getRevMobApplicationID(e),n)Advertiser.registerInstall(RevMob.getRevMobApplicationID(e))end,showFullscreen=function(e)if not RevMobSessionManager.isSessionStarted()then return log(REVMOB_MSG_NO_SESSION)end
native.setActivityIndicator(true)showFullscreenInTheNextFrame=function()Runtime:removeEventListener("enterFrame",showFullscreenInTheNextFrame)FullscreenChooser.show(e)end,timer.performWithDelay(n,function()native.setActivityIndicator(false)end)Runtime:addEventListener("enterFrame",showFullscreenInTheNextFrame)end,showFullscreenWeb=function(e)if not RevMobSessionManager.isSessionStarted()then return log(REVMOB_MSG_NO_SESSION)end
native.setActivityIndicator(true)local e=FullscreenWeb.new(e)showFullscreenWebInTheNextFrame=function()Runtime:removeEventListener("enterFrame",showFullscreenWebInTheNextFrame)e:load()end,timer.performWithDelay(n,function()native.setActivityIndicator(false)end)Runtime:addEventListener("enterFrame",showFullscreenWebInTheNextFrame)end,showFullscreenImage=function(e)native.setActivityIndicator(true)showFullscreenImageInTheNextFrame=function()Runtime:removeEventListener("enterFrame",showFullscreenImageInTheNextFrame)Fullscreen.show(e)end,timer.performWithDelay(n,function()native.setActivityIndicator(false)end)Runtime:addEventListener("enterFrame",showFullscreenImageInTheNextFrame)end,openAdLink=function(e)if not RevMobSessionManager.isSessionStarted()then return log(REVMOB_MSG_NO_SESSION)end
AdLink.open(e)end,createBanner=function(e)if not RevMobSessionManager.isSessionStarted()then return log(REVMOB_MSG_NO_SESSION)end
if e==nil then e={}end
return Banner:new(e)end,createBannerWeb=function(e)if not RevMobSessionManager.isSessionStarted()then return log(REVMOB_MSG_NO_SESSION)end
if e==nil then e={}end
local e=BannerWeb.new(e)e:load()return e
end,showPopup=function(e)if not RevMobSessionManager.isSessionStarted()then return log(REVMOB_MSG_NO_SESSION)end
Popup.show(e)end,printEnvironmentInformation=function(e)log("==============================================")log("RevMob Corona SDK: "..REVMOB_SDK["VERSION"])log("App ID in session: "..tostring(RevMobSessionManager.appID))if e then
log("User App ID for Android: "..tostring(e["Android"]))log("User App ID for iOS: "..tostring(e["iPhone OS"]))end
log("Device name: "..system.getInfo("name"))log("Model name: "..system.getInfo("model"))log("Device ID: "..system.getInfo("deviceID"))log("Environment: "..system.getInfo("environment"))log("Platform name: "..system.getInfo("platformName"))log("Platform version: "..system.getInfo("platformVersion"))log("Corona version: "..system.getInfo("version"))log("Corona build: "..system.getInfo("build"))log("Architecture: "..system.getInfo("architectureInfo"))log("Locale-Country: "..system.getPreference("locale","country"))log("Locale-Language: "..system.getPreference("locale","language"))end}