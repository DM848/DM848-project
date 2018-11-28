include "console.iol"


interface PrintInterface { 
    RequestResponse: print( string )( string ) 
}

outputPort PrintService
{
    Location: "socket://35.228.66.168:8080"
    //Location: "socket://localhost:8080"
    Protocol: http
    Interfaces: PrintInterface
}



main
{
    
    print@PrintService("Message!")(resp);
    println@Console(resp)()
    
}
