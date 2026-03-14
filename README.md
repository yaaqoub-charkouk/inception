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

Image = immutable template used to create containers