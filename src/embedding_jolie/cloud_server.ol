include "runtime.iol"
include "file.iol"
include "cloud_server.iol"
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


main
{
  load( request )( response ) {
    user_program_name = "user_prog";
    filename = user_program_name + ".ol";
    writeFile@File( {
      .content = request.program,
      .filename = filename
    } )();
    install( RuntimeException =>
      println@Console( main.RuntimeException.stackTrace )()
    );
    loadEmbeddedService@Runtime( {
      .type = "Jolie",
      .filepath = filename
    } )( location );

    println@Console( "loaded service: " + token )();
    response = "service loaded"
  }
}
