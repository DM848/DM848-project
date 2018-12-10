include "console.iol"
include "jolie_deployer_interface.iol"


outputPort JolieDeployer {
//Location: "socket://35.228.37.179:8000/"
Location: "socket://localhost:8000/"
Protocol: sodep
Interfaces: Jolie_Deployer_Interface
}


main{
    
    request.token = args[0];
    request.ip = "";
    request.user = "joel";
    
    unload@JolieDeployer(request)()
        
    
}