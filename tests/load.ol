include "console.iol"
include "jolie_deployer_interface.iol"
include "file.iol"


outputPort JolieDeployer {
Location: "socket://35.228.206.68:8000/"
//Location: "socket://localhost:8000/"
Protocol: http
Interfaces: Jolie_Deployer_Interface
}


main
{

    //read program from file, put in variable program
    readFile@File( { .filename = args[0] } )( program );
    
    replicas = 1;
    if (! is_defined(args[1]))
    {
        replicas = 1
    } else{
        replicas = int(args[1])
    };
    
    if (! is_defined(args[2]))
    {
        hc = false
    } else{
        if (args[2] == 1){
            hc = true
        } else{
            hc = false
        }
    };

    //load program in the cluster
    load@JolieDeployer({
      .user = "Kurt",
      .name = "kurtsPrinterService",
    //  .healthcheck = true,
      .healthcheck = hc,
      .manifest = "Jolie",
      .replicas = replicas,
      .program = program,
      .ports[0] = 4000
    })(response);

    //print the returned IP address and token of the new service
    println@Console(response.ip + " " + response.token)()

}
