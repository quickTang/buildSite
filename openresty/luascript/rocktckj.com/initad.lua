--package.path  = 'C:/Users/huaihkiss/Downloads/Openresty_For_Windows_1.13.5.1001_64Bit/x64/nginx/resty/?.lua;;D:/devolepor/company/project/lua/lua/?.lua;' .. package.path
package.path  = '/usr/local/openresty/luascript/rocktckj.com/?.lua;;./?.lua;/usr/local/openresty/luaconfig/?.lua;' .. package.path
ngx.req.read_body()
local headers = ngx.req.get_headers()
local cjson=require("cjson")
local str = require "resty.string"
local strUtils = require("strUtils")()
local channel=ngx.req.get_uri_args()['channel']
local version=ngx.req.get_uri_args()['version']
local userid=ngx.req.get_uri_args()['userid']
local package_name=ngx.req.get_uri_args()['package_name']


local shenhebanben=false
if(strUtils.isNotEmpty(version)) then
    if(tonumber(strUtils.replaceAll(version,"%.",""),10) == 302) then
        shenhebanben=true
    end
end

local cjson=require("cjson")
local obj = {}
obj['code']=200
obj['message']='SUCCESS'
obj['data']={}



local adinfo = {}

--adinfo['shouye_tab'] =  1 --推荐页,底部是否展示广告 （0不展示，1展示）
--adinfo['shipin_tab'] =  1 --推荐页,是否展示全屏广告 （0不展示，1展示）
--adinfo['shipin_info'] =  1 --推荐页,是否展示全屏广告 （0不展示，1展示）
--adinfo['like_tab'] = 1   --喜欢页,底部是否展示广告 （0不展示，1展示）
--adinfo['task_tab'] =  1 --谢谢页,是否展示小固定位广告 （0不展示，1展示）
--adinfo['my_tab'] =  1 --谢谢页,是否展示广告 （0不展示，1展示）
adinfo['init'] = 1 --启动页,是否展示广告 （0不展示，1展示）


local closeAd=0 --0开启 1关闭广告
local video_tab=0 --0开启 1关闭视频tab

if(shenhebanben) then --非新版本都返回
    closeAd=1
    video_tab=1  ---开启视频tab,方便过审
end
    video_tab=0  ---开启视频tab,方便过审



adinfo['closeAd']=closeAd  --0开启广告，1关闭广告
adinfo['video_tab']=video_tab  --0开启视频tab，1关闭视频tab
adinfo['big210']=video_tab  --0开启视频tab，1关闭视频tab
adinfo['channel']=channel  --0开启视频tab，1关闭视频tab

local upinfo = {}
upinfo['up'] = 0  --0否 1是    是否强更
upinfo['version'] = '1.0.1'  --最新版本号
upinfo['up_desc'] = '极大的优化性能'  --更新说明
upinfo['up_url'] = 'http://www.rocktckj.com/down/app-dev-release.apk'  --强更地址

obj['data']=adinfo

obj['data']['upinfo']=upinfo

ngx.say(cjson.encode(obj))

-- ngx.say('{"code":200,"closeAd":0,"data":{"init":1,"like_dibu":1,"like_gudinwei":1,"rmd_dibu":1,"rmd_quanping":1,"tks_dibu":1}}')

--ngx.say(cjson.encode(localJson))

--end
