function time_ago(time_str)
{
    var time = new Date(Date.parse(time_str.replace(/-/g, "/")));
    var year = time.getFullYear();

    return year.toString().substr(2)+'-'+(time.getMonth()+1)+'-'+time.getDate()+'|'+time.getHours()+':'+time.getMinutes();
}

function filter_html_tag(html)
{
    var ret = html.replace(/style="[^"]*"/g, '');
    ret = ret.replace(/<a[^>]*>/g, '');
    ret = ret.replace(/<\/a>/g, '');

    ret = ret.replace(/<strong>/g, '');
    ret = ret.replace(/<\/strong>/g, '');

    ret = ret.replace(/<span[^>]*>/g, '');
    ret = ret.replace(/<\/span>/g, '');

    ret = ret.replace(/<h[1-6][^>]*>/g, '');
    ret = ret.replace(/<\/h[1-6][^>]*>/g, '');
    return ret;
}

function format(num)
{
    return num<10?'0'+num:num;
}

function now()
{
    var time = new Date();
    var month = format(time.getMonth()+1);
    var date = format(time.getDate());
    var hours = format(time.getHours());
    var minutes = format(time.getMinutes());
    var seconds = format(time.getSeconds());

    return time.getFullYear()+'-'+month+'-'+date+' '+hours+':'+minutes+':'+seconds;
}
