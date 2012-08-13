.pragma library
var api_key = "49ed3d78b89b4e74a772a8ae6af572df";
var secretkey = "44722a0b22e74a4696b37c6b03e30fd0";
var oauth_uri = "https://graph.renren.com/oauth/authorize";
var redirect_uri = "http://graph.renren.com/oauth/login_success.html&response_type=token";
var power = [
            'read_user_blog',
//            'read_user_checkin',
            'read_user_feed',
            'read_user_guestbook',
//            'read_user_invitation',
//            'read_user_like_history',
            'read_user_message',
//            'read_user_notification',
            'read_user_photo',
            'read_user_status',
            'read_user_album',
            'read_user_comment',
            'read_user_share',
            'read_user_request',
            'publish_blog',
//            'publish_checkin',
            'publish_feed',
            'publish_share',
            'write_guestbook',
//            'send_invitation',
            'send_request',
            'send_message',
//            'send_notification',
            'photo_upload',
            'status_update',
//            'create_album',
            'publish_comment'
//            'operate_like'
//            'admin_page'
        ];

var FEED_TYPE_STATUS = 10;
var FEED_TYPE_PAGE_STATUS = 11;
var FEED_TYPE_BLOG = 20;
var FEED_TYPE_SHARE_BLOG = 21;
var FEED_TYPE_PAGE_BLOG = 22;
var FEED_TYPE_PAGE_SHARE_BLOG = 23;
var FEED_TYPE_PHOTO = 30;
var FEED_TYPE_PAGE_PHOTO = 31;
var FEED_TYPE_SHARE_PHOTO = 32;
var FEED_TYPE_SHARE_ALBUM = 33;
//var FEED_TYPE_HEADER = 34;
//var FEED_TYPE_PAGE_HEADER = 35;
var FEED_TYPE_PAGE_SHARE_PHOTO = 36;
//var FEED_TYPE_BECOM_FRIEND = 40;
//var FEED_TYPE_BECOM_PAGE_FANS = 41;
var FEED_TYPE_SHARE_VEDIO = 50;
//var FEED_TYPE_SHARE_URL = 51;
//var FEED_TYPE_SHARE_MUSIC = 52;
var FEED_TYPE_PAGE_SHARE_VEDIO = 53;
//var FEED_TYPE_PAGE_SHARE_URL = 54;
//var FEED_TYPE_PAGE_SHARE_MUSIC = 55

var FEED_ALL_TYPE = "10,11,20,21,22,23,30,31,32,33,36";
var FEED_TYPE_SHARE = "21,32";

var SHARE_TYPE_BLOG = 1;
var SHARE_TYPE_PHOTO = 2;
var SHARE_TYPE_SHARE = 20;


var access_token;

function set_token(token)
{
    //console.log(token);
    access_token = token;
}

function generate_oauth_url()
{
    console.log(oauth_uri +
                '?client_id=' + api_key +
                '&redirect_uri=' + redirect_uri +
                '&response_type=token&scope=' + power.toString().replace(/,/g, '+'));
    return oauth_uri +
            '?client_id=' + api_key +
            '&redirect_uri=' + redirect_uri +
            '&response_type=token&scope=' + power.toString().replace(/,/g, '+');
}

function SendData(method)
{
    this.method = method;
    this.v = "1.0";
    this.format = "JSON";
//    this.page = "1";
//    this.count = "30";
    this.access_token = access_token;
}

function generate_send_str(pair)
{
	var flag = true;
	var send_str = "";
	for (var i in pair) {
		if (flag) {
			flag = false;
			send_str += i + '=' + encodeURI(pair[i]);
		}else{
			send_str += '&' + i + '=' + encodeURI(pair[i]);
		}
	}
	return send_str;
}

function Sig(pairs)
{
    var result = new Array();

    for(var i in pairs) {
        result.push(i + "=" + pairs[i]);
    }
    result.sort();

    var str = "";
    for (var i in result) {
        str += result[i];
    }

    return Qt.md5(str + secretkey);
}

function sender(pair, callback)
{
	var doc = new XMLHttpRequest();
	
    doc.open("POST", "http://api.renren.com/restserver.do", true);//"http://api.m.renren.com/api",true);
    doc.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	
    var sendstring = generate_send_str(pair) + "&sig=" + Sig(pair);
//    console.log("sendstring = " + sendstring);
    doc.send(sendstring);

    doc.onreadystatechange = function() {
		if(doc.readyState == XMLHttpRequest.HEADERS_RECEIVED){
	    }else if(doc.readyState == XMLHttpRequest.DONE){
//            console.log(doc.responseText);
            var json = JSON.parse(doc.responseText);
            callback(json);
	    }
    }
}

function call(func_name, param, callback)
{
    if (typeof(param) != "object") {
        return;
    }

    var send_data = new SendData(func_name);
    if (param) {
        for (var i in param) {
            send_data[i] = param[i];
        }
    }

    sender(send_data, callback);
}

function get_all(callback)
{
    var send_data = new SendData("feed.get");
    send_data.type = "10,11,20,21,22,23,30,31,32,33,36";
    send_data.page = 30;
    sender(send_data, callback);
}

