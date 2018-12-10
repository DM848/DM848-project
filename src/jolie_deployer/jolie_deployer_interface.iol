type UserLoadRequest:void {
  .user:string
  .name:string
  .program:string
  .manifest:string
  .ports[1, *]: int
}

type UserUnloadRequest:void {
    .user:string
    .token:string
    .ip:string
}

type UserLoadResponse:void {
    .ip:string
    .token:string
}

interface Jolie_Deployer_Interface
{
    RequestResponse:
      load(UserLoadRequest)(UserLoadResponse),
      unload(UserUnloadRequest)(void)
}

