#!/bin/bash

echo "=== Starting API Tests ==="

# Clean up environment
echo -e "\n1. Resetting database..."
php bin/console doctrine:database:drop --force --quiet
php bin/console doctrine:database:create --quiet
php bin/console doctrine:schema:create --quiet

# Start server
echo -e "\n2. Starting Symfony server..."
symfony server:start -d --port=8000

# Wait for server to start
# echo "Waiting for server to start..."
# sleep 3

# API base URL
BASE_URL="http://localhost:8000/api"


# Create user
echo -e "\n3. Creating new user..."
curl -s -X POST "${BASE_URL}/users" \
     -H "Content-Type: application/json" \
     -d '{
        "username": "testuser",
        "email": "test@example.com",
        "password": "password123"
     }'

# Query single user
echo -e "\n\n4. Querying created user..."
curl -s -X GET "${BASE_URL}/users/1" \
     -H "Content-Type: application/json"

# Update user
echo -e "\n\n5. Updating user information..."
curl -s -X PUT "${BASE_URL}/users/1" \
     -H "Content-Type: application/json" \
     -d '{
        "username": "updateduser",
        "email": "updated@example.com"
     }'

# Query all users
echo -e "\n\n6. Querying all users..."
curl -s -X GET "${BASE_URL}/users" \
     -H "Content-Type: application/json"

echo -e "\n\n7. Deleting user..."
curl -s -X DELETE "${BASE_URL}/users/1" \
     -H "Content-Type: application/json"

# Stop server
echo -e "\n\n8. Stopping server..."
symfony server:stop

echo -e "\n=== Tests Completed ===\n"

