type UserLoadRequest:void {
  .user:string
  .name:string
  .program:string
  .manifest:string
  .ports[1, *]: int
}

interface Jolie_Deployer_Interface
{
    RequestResponse:
      load(UserLoadRequest)(string),
      unload(any)(void)
}

