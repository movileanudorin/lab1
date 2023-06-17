#!/bin/bash
docker-compose up -d --remove-orphans --build --scale lab1_openmpi=5

docker-compose exec lab1_openmpi /bin/bash -c "/home/student/lab1/openmpi/compile.sh"
docker-compose exec lab1_openmpi /bin/bash -c "rm /home/student/.ssh/known_hosts"
docker-compose exec lab1_openmpi /bin/bash -c "rm /home/student/lab1/openmpi/available_hosts_file"

for host_name in `docker network inspect openmpi_main | grep -Po '(?<="Name": \")(openmpi_lab1[_a-z0-9]*)'`
do
    docker-compose exec lab1_openmpi /bin/bash -c "ssh-keyscan -t rsa ${host_name} >> /home/student/.ssh/known_hosts"
    docker-compose exec lab1_openmpi /bin/bash -c "echo \"${host_name} slots=1\"  >> /home/student/lab1/openmpi/available_hosts_file"
done

docker-compose exec lab1_openmpi /bin/bash -c "/home/student/lab1/openmpi/run_computations_on_cluster.sh"
docker-compose exec lab1_openmpi /bin/bash 
