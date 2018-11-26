include "cloud_server.iol"
include "file.iol"
include "time.iol"
include "console.iol"




interface MyIface {
RequestResponse:
  currentTime(void)(undefined)
}

outputPort MyOutput {
Location: "socket://35.228.198.20:8080/"
//Location: "socket://localhost:8080"
Protocol: http
Interfaces: MyIface
}


main
{
  readFile@File( { .filename = "brilliantPrint.ol" } )( program );
  load@CloudServer( {
    .type = "Jolie",
    .program = program
  } )( token );
  println@Console( token )();
  
  
  status@CloudServer()(status);
   println@Console(status)();

    //currentTime@MyOutput()(time);
    //print@Console("Time is " + time + "\n")();

  
  sleep@Time( 3000 )();
  unload@CloudServer( token )()
}
