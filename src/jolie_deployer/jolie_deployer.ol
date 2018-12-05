include "console.iol"
include "exec.iol"
include "jolie_deployer_interface.iol"
include "file.iol"

execution { sequential }    //maybe concurrent?



inputPort Jolie_Deployer {
Location: "socket://localhost:8000/"
Protocol: sodep
Interfaces: Jolie_Deployer_Interface
}


main
{
    
    
    [load(request)(answer){
        token = new;
        println@Console("Im deploying, and i want " + #request.ports + " ports, it is " + request.ports)();
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
    
    
    exec@Exec("kubectl create -f deployment.yaml")(response);
    println@Console(response)();
    
    exec@Exec("kubectl create -f service.yaml")(response);
    print@Console(response)()
    
    /*
    
    delete@File("deployment.yaml")();
    delete@File("service.yaml")()
    */    
    }
        
    ]
    [unload(request)(){
        println@Console("Im undeploying")()
    }
    
    ]
    
    
    
    //exec@Exec("kubectl version")(response);
    
    //print@Console(response)()
}