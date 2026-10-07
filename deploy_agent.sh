#!/bin/bash
trap_handler() {
    echo ""
    echo " Script interrupted! Bundling current state..."
    if [ -d "$PROJECT_DIR" ]; then
        zip -r "${PROJECT_DIR}_archive.zip" "$PROJECT_DIR" > /dev/null
        rm -rf "$PROJECT_DIR"
        echo " Archive created: ${PROJECT_DIR}_archive.zip"
        echo " Incomplete directory deleted."
    fi
}

# Ask user for project name
read -p "Enter project name: " input
PROJECT_DIR="attendance_tracker_${input}"
trap trap_handler SIGINT SIGTSTP

# Create the directory structure
mkdir -p "$PROJECT_DIR/Helpers"
mkdir -p "$PROJECT_DIR/reports"

# Copy files into the correct locations
cp templates/attendance_checker.py "$PROJECT_DIR/"
cp templates/assets.csv "$PROJECT_DIR/Helpers/"
cp templates/config.json "$PROJECT_DIR/Helpers/"
read -p "Do you want to update attendance threshold? (yes/no):" update_config
if [ "$update_config" == "yes" ]; then
    read -p " Enter new Warning threshold (default 75): " warning
    read -p " Enter new Failure threshold (default 50): " failure

    #Validates that inputes are numbers
    if [[ "$warning" =~ ^[0-9]+$ ]] && [[ "$failure" =~ ^[0-9]+$ ]]; then
         sed -i "s/\"warning\": [0-9]*/\"warning\": $warning/" "$PROJECT_DIR/Helpers/config.json"
         sed -i "s/\"failure\": [0-9]*/\"failure\": $failure/" "$PROJECT_DIR/Helpers/config.json"

         echo " Thresholds updated successfully!"
    else
         echo "Invalid input! Thresholds must be numbers. Keeping defaults."
    fi
fi

#Health Check - verify python is installed
echo " Running health check..."
if python3 --version &>/dev/null; then
    echo " Python3 is installed: $(python3 --version)"
else
    echo " Warning: Python is not installed. Please install it to run the application."
fi

echo " Directory structure created successfully!"
