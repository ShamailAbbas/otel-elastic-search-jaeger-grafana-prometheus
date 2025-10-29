#!/bin/bash


# alb addresses
LB1="k8s-dev-aservice-b8ad259f96-48023792f50ded6a.elb.us-east-1.amazonaws.com"
LB2="k8s-dev-bservice-b5ff435d71-eb0adbc1d71336c7.elb.us-east-1.amazonaws.com"

# Define available routes for LB1 and LB2
LB1_ROUTES=("/call-b" "/hello-a" "/getme-coffee")
LB2_ROUTES=("/call-a" "/hello-b" "/getme-coffee")

# Function to generate random index and request from LB1
request_lb1() {
    RANDOM_INDEX=$((RANDOM % ${#LB1_ROUTES[@]}))
    URL="$LB1${LB1_ROUTES[$RANDOM_INDEX]}"
    echo "Sending request to LB1: $URL"
    curl -s -o /dev/null -w "%{http_code}" $URL
}

# Function to generate random index and request from LB2
request_lb2() {
    RANDOM_INDEX=$((RANDOM % ${#LB2_ROUTES[@]}))
    URL="$LB2${LB2_ROUTES[$RANDOM_INDEX]}"
    echo "Sending request to LB2: $URL"
    curl -s -o /dev/null -w "%{http_code}" $URL
}

# Loop for sending requests to both LBs randomly
while true; do
    # Randomly choose between LB1 and LB2
    if (( RANDOM % 2 == 0 )); then
        request_lb1
    else
        request_lb2
    fi

    # Sleep for 1 second between requests (adjust if needed)
    sleep 1
done
