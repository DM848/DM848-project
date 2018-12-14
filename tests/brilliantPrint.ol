include "console.iol"
include "time.iol"

execution { sequential }

interface MyIface {
RequestResponse:
  currentTime(void)(undefined)
}

inputPort MyInput {
Location: "socket://localhost:4000/"
Protocol: http {.format = "raw"}
Interfaces: MyIface
}

main
{
  [ currentTime()( response ) {
    getCurrentDateTime@Time()( response )
  } ]
}
