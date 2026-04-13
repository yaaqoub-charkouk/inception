# inception
Building a secure multi-service web stack (NGINX/WordPress/MariaDB) using Docker containers


docker run : 
    clone()
    set namespaces
    apply cgroups
    mount filesystem
    execve(nginx)


all containers share host linux kernel



Container =
    process
    + namespace isolation
    + cgroup resource control
    + layered filesystem
    running on the host kernel
--> we run a container, this container is a process with a PID like 1234 running on the host and owned by systemd (PID 1). The special thing about this process is that it runs inside its own namespaces (PID, mount, network, etc.). Because of the PID namespace, this process becomes PID 1 inside the container, so the container sees it as the main process, similar to how systemd is PID 1 on the host.

--> containerd : container daemon : container manager : image management
                                                        container lifecycle
                                                        storage (layers)
                                                        network coordination
                                                        starting/stopping containers
                                                        communicating with runc
---> Docker daemon manages everything, containerd manages container lifecycle, and runc creates the isolated process using Linux kernel features.
<!-- ---> how runc uses clone() and unshare() to create PID namespace and run PID 1 ?????????????????????????????/ -->
 
what is USER in docker file? how docker manage users?


Image = immutable template used to create containers





docker daemon?
docker hub?


