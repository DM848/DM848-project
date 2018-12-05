type LoadRequest:void {
  .user:string
  .name:string
  .program:string
  .manifest:string
  .ports[1, *]: int
}

interface Jolie_Deployer_Interface
{
    RequestResponse:
      load(LoadRequest)(any),
      unload(any)(void)
}

