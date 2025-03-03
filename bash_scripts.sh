#!/bin/bash

if [ -z $1 ]
then
        echo 'Error: Task must be specified. Supported tasks: backup, archive, sortedcopy.'
        echo 'Usage: ./setup.sh <task> <additional_arguments>'


elif [ $1 == 'backup' ]
then
        echo $(pwd)
        echo $(ls *.txt)
        mkdir backup
        cd backup
        echo 'Moved to backup directory'
        echo $(pwd)
        cp ../*.txt .
        echo 'Copied all text files to backup directory'
        echo 'Current backup' > date.txt
        date >> date.txt
        cat date.txt

elif [ $1 == 'archive' ]
then
        if [ -z $2 ]
        then
                echo 'Error: Archive task requires file format'
                echo 'Usage: ./setup.sh archive <fileformat>'
                exit 2
        fi
        tar -zcvf archive-$(date -I).tgz *.$2
        echo 'Created archive '$2'archive.tgz'
        ls -l

elif [ $1 == 'sortedcopy' ]
then
        # Check if 2nd and 3rd arguments are provided
        if ([ -z "$2" ] || [ -z "$3" ])
        then
                echo 'Error: Expected two additional input parameters.'
                echo 'Usage: ./setup.sh sortedcopy <sourcedirectory> <targetdirectory>'
                exit 1

        # Check if the 2nd argument is a valid directory
        elif [ ! -d "$2" ]
        then
                echo 'Error: Input parameter #2 '\'$2\'' is not a directory.'
                echo 'Usage: ./setup.sh sortedcopy <sourcedirectory> <targetdirectory>'
                exit 2

        # Check if 3rd argument is already an existing directory
        elif [ -d "$3" ]
        then
                echo 'Directory '\'$3\'' already exists. Overwrite? (y/n)'
                read response

                # If 'y' then the directory will be recursively deleted and a new one
                # will be created later on
                if [ $response = 'y' ]
                then
                        rm -r "$3"

                # For all other answers it will exit via code 3
                else
                        exit 3
                fi
        fi

        # Creates new directory with name "$3"
        mkdir $3
        # Setting index and increasing it by increments of 1, later on
        index=1
        # For loop iterating through contents of directory "$2" and sorting in reverse
        for file in $(ls "$2" | sort -r)
        do

                # Making sure no directories are included
                if [ ! -d "$file" ]
                then
                        # Trimming everything besides the filename
                        new_name=$(basename "$file")

                        # Copying files and changing their names to their filename
                        # and assigning an index
                        cp "$2"/"$file" "$3"/"$index"."$new_name"

                        # Increasing index by increment of 1
                        ((index++))
                fi
        done

else
        echo 'Error: Task must be specified. Supported tasks: backup, archive, sortedcopy.'
        echo 'Usage: ./setup.sh <task> <additional_arguments>'

fi
