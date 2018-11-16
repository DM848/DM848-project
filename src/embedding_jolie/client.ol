include "cloud_server.iol"
include "file.iol"
include "time.iol"
include "console.iol"

main
{
  readFile@File( { .filename = "brilliantPrint.ol" } )( program );
  load@CloudServer( {
    .type = "Jolie",
    .program = program
  } )( token );
  println@Console( token )();
  sleep@Time( 10000 )();
  unload@CloudServer( token )()
}
