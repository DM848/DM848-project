include "cloud_server.iol"
include "file.iol"
include "console.iol"



/*
    This program loads a program specified as an argument
    to the server specified in cloud_server.iol
*/

main
{
  readFile@File( { .filename = args[0] } )( program );
  load@CloudServer( {
    .type = "Jolie",
    .program = program
  } )( token );
  
  println@Console( token )()
  
}
