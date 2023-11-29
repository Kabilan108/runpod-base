variable "RELEASE" {
    default = "0.1.0"
}

group "default" {
    targets = ["11-8-0"]
}

target "11-8-0" {
    dockerfile = "Dockerfile"
    tags = ["kabilan108/runpod-base:${RELEASE}-cuda11.8.0"]
    contexts = {
        scripts = "../container-template"
        proxy = "../container-template/proxy"
        logo = "../container-template"
    }
    args = {
        BASE_IMAGE = "nvidia/cuda:11.8.0-runtime-ubuntu22.04"
    }
}
