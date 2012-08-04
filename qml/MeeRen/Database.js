
function exec(func)
{
    var db = openDatabaseSync("MeeRenRenDB", "1.0", "MeeRenRen's offline data", 1000000);
    db.transaction(func);
}

function init()
{
    exec(function(tx) {
             tx.executeSql('CREATE TABLE IF NOT EXISTS session(uid TEXT, name TEXT, head_url TEXT, access_token TEXT)');
         });
}

function add_session(uid, name, head_url, token)
{
    exec(function(tx) {
             tx.executeSql('INSERT INTO session VALUES(?, ?, ?, ?)', [uid, name, head_url, token]);
         });
}

function del_session(token)
{
    exec(function(tx) {
             tx.executeSql('DELETE FROM session WHERE access_token=?', [token]);
         });
}

function get_session(func)
{
    exec(function(tx) {
             var rs = tx.executeSql('SELECT * FROM session');
             if (rs.rows.length) {
                 func(rs.rows.item(0));
             }else{
                 func(null);
             }
         });
}

function destory()
{
    exec(function(tx) {
             tx.executeSql('DROP TABLE session');
         });
}
