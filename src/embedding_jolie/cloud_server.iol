type LoadRequest:void {
  .program:string
}

interface CloudServerIface {
RequestResponse:
  load(LoadRequest)(any)
}

outputPort CloudServer {
// Location: "socket://35.228.66.168:8000/"
Location: "socket://localhost:8000"
Protocol: sodep
Interfaces: CloudServerIface
}
