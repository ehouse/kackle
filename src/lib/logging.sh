############################
# Event proved fatal, log and exit with error code
# Arguments:
#  Exit Message
#  Exit Code
############################
logging::fatal() {
    local -r msg=${1:-"Exiting!"}
    echo -e "ERROR: $msg"
    exit ${2:-1}
}

############################
# Warn of an event, non fatal and will continue
# Arguments:
#  Warning Message
############################
logging::warning() {
    local -r msg=${1:-"Proceding as usual"}
    echo -e "WARNING: $msg"
}

############################
# Log an event
# Arguments:
#  Message
############################
logging::info() {
    local -r msg=${1:-"An event occured"}
    echo -e "INFO: $msg"
}
