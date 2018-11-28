include "runtime.iol"
include "file.iol"
include "cloud_server_iface.iol"
include "console.iol"
include "time.iol"


inputPort LocalInput {
Location: "local"
Interfaces: CloudServerIface
}

inputPort CloudServer {
Location: "socket://localhost:8000/"
Protocol: sodep
Interfaces: CloudServerIface
}

execution { sequential }

init
{
  deleteDir@File( "tmp" )();
  mkdir@File( "tmp" )()
}

main
{
  [ load( request )( token ) {
    filename = "tmp/" + new;
    if ( request.type == "Jolie" ) {
      filename += ".ol"
    } else {
        throw( WrongFileFormat )
    };
    writeFile@File( {
      .content = request.program,
      .filename = filename
    } )();
    install( RuntimeException =>
      println@Console( main.RuntimeException.stackTrace )()
    );
    /*
    loadEmbeddedService@Runtime( {
      .type = request.type,
      .filepath = filename
    } )( location );
    */
    token = new;
    println@Console( "loaded service: " + token )();
    global.map.(token) = location
  } ]

  [ unload( token )() {
    callExit@Runtime( global.map.(token) )();
    println@Console( "unloaded service: " + token )()
  } ]
  
  //see the status of a running servies. Under construction
  [status(token)(resp){
      resp = "Here is the status from the server. This is new, to test CI";
      println@Console("Responding with status")()
      }]
}
