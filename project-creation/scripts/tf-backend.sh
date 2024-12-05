#!/bin/bash

# Function to create a GCS bucket with exception handling
create_gcs_bucket() {
    local PROJECT_ID="$1"
    local BUCKET_LOCATION="$2"

    # Create the GCS bucket
    if ! gsutil mb -p "$PROJECT_ID" -c "REGIONAL" -l "$BUCKET_LOCATION" "gs://$BUCKET_NAME/"; then
        echo "Error: Failed to create GCS bucket $BUCKET_NAME."
        return 1
    fi

    # Enable versioning for the bucket
    if ! gsutil versioning set on "gs://$BUCKET_NAME/"; then
        echo "Error: Failed to enable versioning for $BUCKET_NAME."
        return 1
    fi

    echo "GCS bucket $BUCKET_NAME created successfully with versioning enabled."
}

# Prompt for GCP project ID
read -p "Enter your GCP Project ID: " PROJECT_ID

# Prompt for the bucket location
read -p "Enter the bucket location (e.g., us-central1): " BUCKET_LOCATION

# Create the GCS bucket name using the project ID and the random string
RANDOM_STRING=$(LC_ALL=C tr -dc 'a-z0-9' </dev/urandom | head -c 4)
BUCKET_NAME="tf-${PROJECT_ID}-${RANDOM_STRING}"

# Call the function to create the GCS bucket
create_gcs_bucket "$PROJECT_ID" "$BUCKET_LOCATION"

