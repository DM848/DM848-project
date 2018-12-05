include "console.iol"
include "exec.iol"
include "jolie_deployer_interface.iol"
include "file.iol"
include "time.iol"
include "string_utils.iol"
include "cloud_server_iface.iol"

execution { sequential }    //maybe concurrent?



outputPort MyOutput {
//Location: "socket://35.228.66.168:8080/"
//Location: "socket://localhost:8080"
Protocol: sodep
Interfaces: CloudServerIface
}


inputPort Jolie_Deployer {
Location: "socket://localhost:8000/"
Protocol: sodep
Interfaces: Jolie_Deployer_Interface
}


main
{
    [load(request)(answer){
        token = new;    //unique token that is used inside the cluster to
                        //identify this service + deployment
        
        writeFile@File ({
      .content = 
"apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment" + token + "
  labels:
    app: " + token + "
spec:
  replicas: 1
  selector:
    matchLabels:
      app: " + token + "
  template:
    metadata:
      labels:
        app: " + token + "
    spec:
      containers:
      - name: " + token + "
        image: joelhandig/cloud_server:latest
        ports:
        - containerPort: 8000\n",
      .filename = "deployment.yaml"
    } )();
    
    serviceString = 
"apiVersion: v1
kind: Service
metadata:
  name: service" + token + "
spec:
  ports:
  - name: host
    port: 8000
    targetPort: 8000\n";
    for ( port in request.ports)
    {
        serviceString = serviceString + 
"  - name: " + new + "
    port: "+ port +"
    targetPort: " + port + "\n"
};
    
    serviceString = serviceString + 
"  selector:
    app: " + token + "
  type: LoadBalancer\n";
    
    writeFile@File({.content = serviceString, .filename = "service.yaml"})();
    
    
    //create new deployment and service
    exec@Exec("kubectl create -f deployment.yaml")(response);
    println@Console(response)();
    exec@Exec("kubectl create -f service.yaml")(response);
    print@Console(response)();
    

    //Following while-loop blocks until the kubernetes cluster
    //has allocated a new public ip. This usually takes 60 seconds
    matches = 0;
    while (matches == 0)
    {
        cmdstring = "kubectl describe service service" + token;
        exec@Exec(cmdstring)(response);
        
        //println@Console(response)();
        
        item = string(response);
        item.regex = "(?s).*(Ingress:     [0-9]*.[0-9]*.[0-9]*.[0-9]*)(?s).*";
        
        match@StringUtils(item)(matches);
        
        sleep@Time(1000)();
        println@Console("wating for IP...")()
    };
    
    
    substr = matches.group[1];
    substr.begin = 13;
    substr.end = 100;
    substring@StringUtils(substr)(res);
    //println@Console(res)();
    
    //println@Console("IP is now " + res)();
    
    //update the output port to point to the new wrapper
    MyOutput.location = "socket://" + res + ":8000";
    
    //send user program to newly created wrapper
    load@MyOutput({
          .type = "Jolie",
          .program = request.program
    })(); 
    
    
    //delete the yaml-files that are used
    delete@File("deployment.yaml")();
    delete@File("service.yaml")()
    
    
    }
        
        
    //to be implemented
    ]
    [unload(request)(){
        println@Console("Im undeploying")()
    }
    
    ]
    
    
    
    //exec@Exec("kubectl version")(response);
    
    //print@Console(response)()
}