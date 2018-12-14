include "console.iol"
include "jolie_deployer_interface.iol"


outputPort JolieDeployer {
//Location: "socket://35.228.198.20:8000/"
Location: "socket://localhost:8000/"
Protocol: http
Interfaces: Jolie_Deployer_Interface
}


main{

    request.token = args[0];
    request.ip = "asdf";
    request.user = "joel";
    request.gracePeriod = 4;

    unload@JolieDeployer(request)()


}
