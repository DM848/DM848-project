
execution
{
    sequential
}

interface PrintInterface { 
    RequestResponse: print( void )( string ) 
}

inputPort PrintService
{
    Location: "socket://localhost:400/"
    Protocol: http {.format = "raw"}
    Interfaces: PrintInterface
}






main
{
    [print()(response)
    {
        response = "This is from server"
    }]
}