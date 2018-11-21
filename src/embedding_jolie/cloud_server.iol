include "cloud_server_iface.iol"

outputPort CloudServer {
Location: "socket://35.228.140.134:8000/"
//Location: "socket://localhost:8000"
Protocol: sodep
Interfaces: CloudServerIface
}
