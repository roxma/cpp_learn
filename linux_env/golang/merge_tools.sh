#!/bin/bash

echo "function roxma_golang_x_zip_encoded(){"
    echo -n "cat <<< '"
    (cd golang.org/x/ &&  tar -cz *.zip | base64)
    echo "'"
echo "}"

cat roxma_golang_workspace_init.sh

