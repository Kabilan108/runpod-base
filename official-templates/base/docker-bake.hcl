variable "RELEASE" {
    default = "0.0.4"
}

target "default" {
    dockerfile = "Dockerfile"
    tags = ["runpod/base:${RELEASE}"]
    contexts = {
        scripts = "../../container-template"
        proxy = "../../container-template/proxy"
    }
}
