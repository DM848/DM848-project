include "console.iol"
include "jolie_deployer_interface.iol"


outputPort JolieDeployer {
Location: "socket://35.228.114.154:8000/"
//Location: "socket://localhost:8000/"
Protocol: http
Interfaces: Jolie_Deployer_Interface
}


main{

    request.token = args[0];
    request.ip = "asdf";
    request.user = "joel";

    unload@JolieDeployer(request)()


}
