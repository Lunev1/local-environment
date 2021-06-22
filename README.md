# local-environment
docker-compose environment to demo service orchestration

# tasks to complete
setup docker-compose.yml to run a demo service with access to database
- setup docker-compose.yml with demo service and redis database
- configure network settings
- reference build step via Dockerfile in your local repository
- start environment, service should get access to database
- build a docker image of the service and push it to a registry
- refactor the build step in docker-compose.yml and pull the service image
from the registry
- start environment, service should get access to database 
  (no buildstep locally necessary anymore)