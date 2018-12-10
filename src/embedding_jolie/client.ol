include "cloud_server.iol"
include "file.iol"
include "time.iol"
include "console.iol"


interface MyIface {
RequestResponse:
  currentTime(void)(undefined)
}

outputPort MyOutput {
// Location: "socket://35.228.66.168:8080/"
Location: "socket://localhost:8080"
Protocol: http
Interfaces: MyIface
}

outputPort CloudServer {
// Location: "socket://35.228.66.168:8000/"
Location: "socket://localhost:8000"
Protocol: sodep
Interfaces: CloudServerIface
}


main
{
  readFile@File( { .filename = "brilliantPrint.ol" } )( program );
  load@CloudServer( {
    .program = program
  } )( token );
  println@Console( token )();

  currentTime@MyOutput()(time);
  print@Console("Time is " + time + "\n")()
}
