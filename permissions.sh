#!/bin/bash

find . "startup_files" -type f -name "*.sh" -exec sudo chmod 777 {} +

echo "Execute permissions given to all .sh files in the current directory and in startup_files/"

exit 0
