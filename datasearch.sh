#!/bin/bash

# ===================================================================
# Script Name: se.sh
# Description: A tool to search for active users, process log files,
#              and find text patterns in files.
# Author:      (Your Name)
# Date:        June 15, 2025
# ===================================================================

# --- Function to display currently logged-in users ---
show_active_users() {
    echo "=========================================="
    echo "        Currently Active Users"
    echo "=========================================="
    # The 'who' command shows who is logged on.
    # We use 'w' for a more detailed view including what they are doing.
    w
    echo "=========================================="
}

# --- Function to search system logs ---
process_log_files() {
    echo "=========================================="
    echo "        Search System Log Files"
    echo "=========================================="

    # Define the log file to search. /var/log/syslog is a common system log.
    local log_file="/var/log/syslog"

    # Check if the log file is readable
    if [ ! -r "$log_file" ]; then
        echo "Error: Log file $log_file not found or not readable."
        echo "You might need to run the script with 'sudo' for log access."
        return 1
    fi

    # Prompt the user for a pattern to search for (e.g., "error", "failed").
    read -p "Enter pattern to search for in $log_file (e.g., error): " pattern

    if [ -z "$pattern" ]; then
        echo "Error: No pattern provided. Aborting."
        return 1
    fi

    echo ""
    echo "Searching for lines containing '$pattern' in $log_file..."
    echo "----------------------------------------------------"

    # Use grep to find the lines and awk to format the output.
    # grep -i: Searches case-insensitively.
    # awk: Is used here to re-format and print the output from grep neatly.
    #      We are printing the month($1), day($2), time($3), and the rest of the line ($0).
    grep -i "$pattern" "$log_file" | awk '{print "Date: " $1 " " $2 ", Time: " $3 " | Entry: " substr($0, index($0,$5))}'

    if [ $? -ne 0 ]; then
        echo "No entries found matching '$pattern'."
    fi
    echo "=========================================="
}

# --- Function for generic text pattern search in a file ---
search_text_pattern() {
    echo "=========================================="
    echo "        Search for a Pattern in a File"
    echo "=========================================="

    # Prompt user for the file name
    read -p "Enter the full path to the text file: " file_name

    # Check if the file exists and is a regular file
    if [ ! -f "$file_name" ]; then
        echo "Error: File '$file_name' not found."
        return 1
    fi

    # Prompt user for the search pattern
    read -p "Enter the text pattern to search for: " pattern

    if [ -z "$pattern" ]; then
        echo "Error: No pattern provided. Aborting."
        return 1
    fi

    echo ""
    echo "Searching for '$pattern' in '$file_name'..."
    echo "----------------------------------------------------"

    # Use grep to find and display matching lines with line numbers.
    # -n: Shows the line number of the match.
    # -i: Makes the search case-insensitive.
    grep -n -i "$pattern" "$file_name"
    echo "=========================================="
}


# --- Main Menu Loop ---
while true; do
    # Display the menu options to the user
    echo ""
    echo "=========================================="
    echo "         System Search Tool Menu"
    echo "=========================================="
    echo "1. Display Active User Names"
    echo "2. Search System Log Files"
    echo "3. Search for a Text Pattern in a File"
    echo "4. Exit"
    echo "=========================================="
    read -p "Please select an option [1-4]: " choice

    # Case statement to handle the user's choice
    case $choice in
        1)
            show_active_users
            ;;
        2)
            process_log_files
            ;;
        3)
            search_text_pattern
            ;;
        4)
            echo "Exiting the script. Goodbye!"
            exit 0
            ;;
        *)
            # Handle invalid input
            echo "Invalid option. Please try again."
            ;;
    esac

    read -p "Press [Enter] to return to the menu..."
done
