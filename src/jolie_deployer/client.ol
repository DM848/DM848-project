include "console.iol"
include "jolie_deployer_interface.iol"
include "file.iol"
include "srv-logger.iol"


outputPort Log {
    Location: "socket://35.228.93.73:8180/"
    Protocol: http { .method = "post" }
    Interfaces: LoggerInterface
}


outputPort JolieDeployer {
Location: "socket://35.228.100.63:8000/"
//Location: "socket://localhost:8000/"
Protocol: sodep
Interfaces: Jolie_Deployer_Interface
}


main
{


    //read program from file, put in variable program
    readFile@File( { .filename = "brilliantPrint.ol" } )( program );

    //load program in the cluster
    load@JolieDeployer({
      .user = "Kurt",
      .name = "kursPrinterService",
      .manifest = "Jolie",
      .replicas = 2,
      .program = program,
      .ports[0] = 400
    })(response);

    //print the returned IP address of the new service
    println@Console("IP: " + response.ip)();
    println@Console("Token: " + response.token)()


}
