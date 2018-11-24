include "cloud_server_iface.iol"

outputPort CloudServer {
Location: "socket://35.228.198.20:8000/"
//Location: "socket://localhost:8000"
Protocol: sodep
Interfaces: CloudServerIface
}
