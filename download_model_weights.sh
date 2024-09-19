#!/bin/bash

# Dropbox links and file names
dropbox_link1="https://www.dropbox.com/scl/fi/silqs54yosb95wxqd75yg/best_resunet.pth?rlkey=w6hulq64zc1nbvrl37o7as063&st=vidj4b9b&dl=1"
file_name1="best_resunet.pth"

dropbox_link2="https://www.dropbox.com/scl/fi/p612xd5kd0r0xhq40g01s/best_unet.pth?rlkey=d9une5icayvhdjs96fhwxyuts&st=d5tpk38d&dl=1"
file_name2="best_unet.pth"

#dropbox_link3="https://www.dropbox.com/scl/fi/qha47yn9gek3wjtzjci19/best_unetr.pth?rlkey=l1ds3oktbdzc2v68gorwn4d8v&st=d24rmepv&dl=1"
#file_name3="best_unetr.pth"

# Function to download files
download_file() {
    local dropbox_link="$1"
    local file_name="$2"
    
    echo "Downloading ${file_name} from Dropbox..."
    curl -L -o "${file_name}" "${dropbox_link}"
    
    if [ -f "${file_name}" ]; then
        echo "Successfully downloaded ${file_name}."
    else
        echo "Failed to download ${file_name}."
    fi
}

# Download files
download_file "${dropbox_link1}" "${file_name1}"
download_file "${dropbox_link2}" "${file_name2}"
#download_file "${dropbox_link3}" "${file_name3}"
