# DM848-project

After some discussion and drawing on a board(30 November), we have defined what we think that the program should do.

## Version 1:
This is the version thats running and working in the cloud right now (30 nov).
- A deployment is running in the kubernetes cluster, called **jolie-deployer**. This has 1 replica and exposes port 8080. The image that it is running, is `joelhandig/cloud_server`. This image exposes the `cloud_server_iface`, where you can load or unload a service.
- A service is running in the kubernetes cluster, also called **jolie-deployer**. It exposes ports 8000 and 8080, and redirects to the deployment. It runs in external IP 35.228.66.168. Both the `.yaml` files used to create these objects, are found in the github repo in the `kubernetes/` folder.

This is what it can do:
- A user can supply a jolie program to `35.228.66.168:8000`. The user will get a token in return. 
- After that, the user can call the program on `35.228.66.168:8080`.
- A user can unload the program using the token gotten when loaded.

The problem with this approach are the following:
1. Only user programs that use port 8080 can be used. Everything else will load, but only 8080 will be exposed.
2. Only one program that use port 8080 can be loaded. The server will reject another program, saying that the port is already in use.

## Version 2
This is the one that we are building from now on (30 nov)
* A program is run (somewhere), call it **jolie-creator**. This somewhere is a place that is authenticated against the google cloud account, and has `kubectl` installed. The program needs to be able to be accessed by a user of our system. The current idea is to implement this in Java, and embed it in a jolie program, so it can be accessed from outside the system. We are not sure yet, if we should run it in the cluster, or on the Virtual Machine that is connected to the google account. This program takes a **manifest** and a **user_jolie_program** as an input, and does the following:
    1. `deployment.yaml`: Defines the amount of replicas that the user wants. Expose port 8000
    2. `service.yaml`: Defines what ports the user wants + port 8000. The image used should be the Dockerfile described later in this list.
    3. Saves the **user_jolie_program** to the disc to some standard location.
    4. Call `kubectl create -f deployment.yaml` and `kubectl create -f service.yaml`. This creates the whole service that the user asked for.
    5. Gets the IP address for the newly deployed jolie program. This could be gotten with `kubectl get services` some way. Returns this IP to the user.
* The Dockerfile should be like the one from version 1, but in the `CMD` section, which is the command run when the image is run somewhere, should also embed the **user_jolie_program** when it starts up.
    