include "console.iol"
include "jolie_deployer_interface.iol"


outputPort JolieDeployer {
Location: "socket://localhost:8000/"
Protocol: sodep
Interfaces: Jolie_Deployer_Interface
}



main
{

    load@JolieDeployer({
      .manifest = "Jolie",
      .program = "asdf",
      .ports[0] = 400,
      .ports[1] = 2222
    })(response)
    
    //unload@JolieDeployer("asdf")()

}
