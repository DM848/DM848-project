include "cloud_server.iol"
include "file.iol"
include "time.iol"
include "console.iol"

/*
    This program unloads a program from the server
    specified in cloud_server.iol.
    The token that was given by the server when the program
    was loaded must be specified as a command line 
    argument.

*/


main
{
  unload@CloudServer( args[0] )()
}
