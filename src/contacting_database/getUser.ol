include "database.iol"
include "console.iol"



main
{
    with ( connectionInfo ) {
        .host = "35.240.59.97";
//        .useSSL="false";
        .driver = "mysql";
        .port = 3306;
        .database = "jdusers";
        .username = "user";
        .password = "password"
    };
    
    connect@Database( connectionInfo)(void);

    q = "SELECT * FROM users;";
    query@Database(q)(result);

    foreach(line : result){
        for(i = 0, i < #result.row, i++){
            print@Console(result.(line)[i].user + ", ")();
            print@Console(result.(line)[i].perm + "\n")()
        }
    }
    
}

