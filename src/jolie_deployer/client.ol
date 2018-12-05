include "console.iol"
include "jolie_deployer_interface.iol"
include "file.iol"



outputPort JolieDeployer {
Location: "socket://localhost:8000/"
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
      .program = program,
      .ports[0] = 400
    })(response);
    
    //print the returned IP address of the new service
    println@Console(response)()
    

}
