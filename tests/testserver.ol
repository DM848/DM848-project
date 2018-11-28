
execution
{
    sequential
}

interface PrintInterface { 
    RequestResponse: print( string )( string ) 
}

inputPort PrintService
{
    Location: "socket://localhost:8080/"
    Protocol: http
    Interfaces: PrintInterface
}






main
{
    [print( msg)(response)
    {
        response = "This is from server: " + msg
    }]
}