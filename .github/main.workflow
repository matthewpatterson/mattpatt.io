workflow "Docker build and push" {
  resolves = [
    "Push mattpatt.io_nginx",
    "Push mattpatt.io",
  ]
  on = "push"
}

action "Docker Registry" {
  uses = "actions/docker/login@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Build mattpatt.io" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "build -t \"matthewpatterson/mattpatt.io:${GITHUB_SHA:0:7}\" ."
  needs = ["Docker Registry"]
}

action "Build mattpatt.io_nginx" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "build -t \"matthewpatterson/mattpatt.io_nginx:${GITHUB_SHA:0:7}\" config/nginx"
  needs = ["Docker Registry"]
}

action "Push mattpatt.io" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Build mattpatt.io"]
  args = "push \"matthewpatterson/mattpatt.io:${GITHUB_SHA:0:7}\""
}

action "Push mattpatt.io_nginx" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Build mattpatt.io_nginx"]
  args = "push \"matthewpatterson/mattpatt.io_nginx:${GITHUB_SHA:0:7}\""
}
