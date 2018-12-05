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
    readFile@File( { .filename = "brilliantPrint.ol" } )( program );
    load@JolieDeployer({
      .user = "Kurt",
      .name = "kursPrinterService",
      .manifest = "Jolie",
      .program = program,
      .ports[0] = 400
    })(response)
    

}
