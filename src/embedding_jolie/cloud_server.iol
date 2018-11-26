include "cloud_server_iface.iol"

outputPort CloudServer {
Location: "socket://35.228.66.168:8000/"
//Location: "socket://localhost:8000"
Protocol: sodep
Interfaces: CloudServerIface
}
