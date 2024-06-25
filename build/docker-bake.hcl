group "default" {
  targets = [
    "2_2_0",
    "3_17_1"
  ]
}

target "build-dockerfile" {
  dockerfile = "Dockerfile"
}

target "build-platforms" {
  platforms = ["linux/amd64", "linux/aarch64"]
}

target "build-platforms-cudnn" {
  platforms = ["linux/amd64"]
}

target "build-common" {
  pull = true
}

######################
# Define the variables
######################

variable "REGISTRY_CACHE" {
  default = "docker.io/nlss/iperf-server-cache"
}

######################
# Define the functions
######################

# Get the arguments for the build
function "get-args" {
  params = [version]
  result = {
    IPERF_VERSION = version
  }
}

# Get the cache-from configuration
function "get-cache-from" {
  params = [version]
  result = [
    "type=registry,ref=${REGISTRY_CACHE}:${sha1("${version}-${BAKE_LOCAL_PLATFORM}")}"
  ]
}

# Get the cache-to configuration
function "get-cache-to" {
  params = [version]
  result = [
    "type=registry,mode=max,ref=${REGISTRY_CACHE}:${sha1("${version}-${BAKE_LOCAL_PLATFORM}")}"
  ]
}

# Get list of image tags and registries
# Takes a version and a list of extra versions to tag
# eg. get-tags("0.29.0", ["0.29", "latest"])
function "get-tags" {
  params = [version, extra_versions]
  result = concat(
    [
      "docker.io/nlss/iperf-server:${version}",
      "ghcr.io/routerzero/iperf-server:${version}"
    ],
    flatten([
      for extra_version in extra_versions : [
        "docker.io/nlss/iperf-server:${extra_version}",
        "ghcr.io/routerzero/iperf-server:${extra_version}"
      ]
    ])
  )
}

##########################
# Define the build targets
##########################

target "2_2_0" {
  inherits   = ["build-dockerfile", "build-platforms", "build-common"]
  cache-from = get-cache-from("2.2.0")
  cache-to   = get-cache-to("2.2.0")
  tags       = get-tags("2.2.0", ["2", "2.2"])
  args       = get-args("iperf==2.2.0-r0")
}


target "3_17_1" {
  inherits   = ["build-dockerfile", "build-platforms", "build-common"]
  cache-from = get-cache-from("3.17.1")
  cache-to   = get-cache-to("3.17.1")
  tags       = get-tags("3.17.1", ["3", "3.17", "latest"])
  args       = get-args("iperf3==3.17.1-r0")
}
