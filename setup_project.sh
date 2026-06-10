#!/bin/bash
trap_handler() {
     echo""
     echo" Script interrupted! Bundling current state..."
     tar -czf " attendance_trackr_ ${input}_archive.tar.gz" "$PROJECT_DIR" 2>/dev/null
     rm -rf "$PROJECT_DIR"
     echo " Archive created: attendance_tracker_${input}_archive.tar.gz" 
     echo " Incomplete directory deleted."
     exit 1
}

trap trap_handler SIGINT
# Ask user for project name
read -p "Enter project name: " input

# Set the main directory name
PROJECT_DIR="attendance_tracker_${input}"

# Create the directory structure
mkdir -p "$PROJECT_DIR/Helpers"
mkdir -p "$PROJECT_DIR/reports"

# Copy files into the correct locations
cp attendance_checker.py "$PROJECT_DIR/"
cp assets.csv "$PROJECT_DIR/Helpers/"
cp config.json "$PROJECT_DIR/Helpers/"
cp reports.log "$PROJECT_DIR/reports/"
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
echo " Runnign health check..."
if python3 --version &>/dev/null; then
    echo " Python3 is installed: $(python3 --version)"
else
    echo " Warning: Python is not installed. Please install it to run the application."
fi

echo "✅ Directory structure created successfully!"
