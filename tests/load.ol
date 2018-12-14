include "console.iol"
include "jolie_deployer_interface.iol"
include "file.iol"


outputPort JolieDeployer {
Location: "socket://35.228.198.20:8000/"
//Location: "socket://localhost:8000/"
Protocol: http
Interfaces: Jolie_Deployer_Interface
}


main
{


    //read program from file, put in variable program
    readFile@File( { .filename = args[0] } )( program );

    //load program in the cluster
    load@JolieDeployer({
      .user = "Kurt",
      .name = "kurtsPrinterService",
      .manifest = "Jolie",
      .replicas = 3,
      .program = program,
      .ports[0] = 4000
    })(response);

    //print the returned IP address and token of the new service
    println@Console(response.ip + " " + response.token)()

}
