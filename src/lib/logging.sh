logging::fatal() {
    local -r msg=${1:-"Exiting!"}
    echo -e "ERROR: $msg"
    exit ${2:-1}
}

logging::warning() {
    local -r msg=${1:-"Proceding as usua"}
    echo -e "WARNING: $msg"
}

logging::info() {
    local -r msg=${1:-"An event occured"}
    echo -e "INFO: $msg"
}
