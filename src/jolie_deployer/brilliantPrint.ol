include "console.iol"
include "time.iol"

execution { sequential }

interface MyIface {
RequestResponse:
  currentTime(void)(undefined)
}

inputPort MyInput {
Location: "socket://localhost:400/"
Protocol: http {.format = "raw"}
Interfaces: MyIface
}

interface Health {
RequestResponse:
  health(void)(string)
}

inputPort Health {
Location: "socket://localhost:1/"
Protocol: http {.format = "raw"/*; .statusCode -> statusCode*/}
Interfaces: Health
}


main
{
  [ currentTime()( response ) {
    getCurrentDateTime@Time()( response )
  } ]

  [health()(health)
  {
      health = "true";
    statusCode = 200 // this sets the http response status code
  } ]
}
