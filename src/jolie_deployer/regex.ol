include "console.iol"
include "string_utils.iol"


main
{
    thing = "wating for IP...
Name:                     service2d588037-52cb-4e1a-90fb-466dd42f7ee5
Namespace:                default
Labels:                   <none>
Annotations:              <none>
Selector:                 app=2d588037-52cb-4e1a-90fb-466dd42f7ee5
Type:                     LoadBalancer
IP:                       10.27.253.156
LoadBalancer Ingress:     35.228.26.225
Port:                     host  8000/TCP
TargetPort:               8000/TCP
NodePort:                 host  31876/TCP
Endpoints:                10.24.0.19:8000
Port:                     056dbb4b-459f-4d22-afed-1ee79ef1e190  400/TCP
TargetPort:               400/TCP
NodePort:                 056dbb4b-459f-4d22-afed-1ee79ef1e190  30880/TCP
Endpoints:                10.24.0.19:400
Session Affinity:         None
External Traffic Policy:  Cluster
Events:
  Type    Reason                Age   From                Message
  ----    ------                ----  ----                -------
  Normal  EnsuringLoadBalancer  53s   service-controller  Ensuring load balancer
  Normal  EnsuredLoadBalancer   11s   service-controller  Ensured load balancer
";

    thing.regex = "(?s).*(Ingress:     [0-9]*.[0-9]*.[0-9]*.[0-9]*)(?s).*";
    match@StringUtils(thing)(response);
    
    //println@Console(response.group[1])();
    
    substr = response.group[1];
    substr.begin = 13;
    substr.end = 100;
    
    substring@StringUtils(substr)(res);
    println@Console(res)()

}