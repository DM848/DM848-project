
include "console.iol"
include "exec.iol"
include "jolie_deployer_interface.iol"
include "file.iol"
include "time.iol"
include "string_utils.iol"
include "cloud_server_iface.iol"
include "srv-logger.iol"

execution { sequential }    //maybe concurrent?


outputPort LoggerService {
    Location: "socket://logger:8180/"        //where is the service?
    Protocol: http { .method = "post" }
    Interfaces: LoggerInterface
}


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
  replicas: " + request.replicas + "
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
    exec@Exec("kubectl create -f deployment.yaml")(execResponse);
    println@Console(execResponse)();
    exec@Exec("kubectl create -f service.yaml")(execResponse);
    print@Console(execResponse)();



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
    //println@Console(matches.group[1])();

    println@Console(matches.group[1])();

    substr = matches.group[1];
    substr.begin = 13;
    substr.end = 100;
    substring@StringUtils(substr)(PubIP);





    /*
    //get the IP's of all pods that were started up
    exec@Exec("kubectl describe pods -l app=" + token)(execResponse);

    println@Console("Response: " + string(execResponse))();


    splitItem = string(execResponse);
    splitItem.regex = "Name:";

    split@StringUtils(splitItem)(splitRes);


    println@Console("Number of results: " + #splitRes.result)();
    item.regex = "(?s).*(IP:             [0-9]*.[0-9]*.[0-9]*.[0-9]*)(?s).*";
    for ( i = 0, i < #splitRes.result, i++)
    {
        item = splitRes.result[i];
        match@StringUtils(item)(matches);
        println@Console(matches.group[1])();



        if (string(matches.group[1]) != "")
        {
            substr = matches.group[1];
            substr.begin = 16;
            substr.end = 100;
            substring@StringUtils(substr)(res);

            IP[#IP] = res
        }
    };
    for (element in IP)
    {
        println@Console("IP Address of pod running: " + element)()

        //update the output port to point to the new wrapper
        //MyOutput.location = "socket://" + element + ":8000"

        //send user program to newly created wrapper
        load@MyOutput({
              .program = request.program
        })()

    };
*/


    //update the output port to point to the new wrapper
    MyOutput.location = "socket://" + PubIP + ":8000/";

    //send user program to newly created wrapper
    load@MyOutput({
          .program = request.program
    })(neverusethis);


    //delete the yaml-files that were used
    delete@File("deployment.yaml")();
    delete@File("service.yaml")();



    answer.ip = string(PubIP);
    answer.token = token

    /*
    //log action
    logentry.service: "jolie-deployer";
    logentry.info: "Loaded service, user: " + request.user;
    logentry.level: 5;
    set@LoggerService(logentry)()
    */

    }]



    [unload(request)(){

        println@Console("Im undeploying")();


        //We need to get the token that was created when the program was loaded.
        //for now, assume that the user has it.

        //NOTE maybe we should check that the program that should be undeployed
        // matches one that exists, so check the tags/ip in the deployment

        exec@Exec("kubectl delete deployment deployment"+ request.token)();
        exec@Exec("kubectl delete service service" + request.token)()

        /*
        //log action
        logentry.service: "jolie-deployer";
        logentry.info: "Unloaded service, user: " + request.user;
        logentry.level: 5;
        set@LoggerService(logentry)()
        */
    }]


    //answer if I am healthy
    [health()(resp){
        resp = "I am healthy!"
    }]



}
