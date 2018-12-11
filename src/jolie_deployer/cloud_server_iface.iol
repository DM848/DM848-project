type LoadRequest:void {
  .program:string
}

interface CloudServerIface {
RequestResponse:
  load(LoadRequest)(string)
}
