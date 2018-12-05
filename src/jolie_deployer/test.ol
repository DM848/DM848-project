include "console.iol"

interface MyIface {
RequestResponse:
  currentTime(void)(undefined)
}

outputPort MyOutput {
Location: "socket://35.228.26.225:400/"
Protocol: http
Interfaces: MyIface
}

main
{
    
}