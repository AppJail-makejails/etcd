#!/bin/sh

main()
{
    if [ $# -lt 1 ]; then
        echo "usage: pid_file.sh <pid-file>"
        exit 1
    fi

    local pid_file
    pid_file="$1"

    if [ ! -f "${pid_file}" ]; then
        stderr "${pid_file}: Cannot be found."
        exit 1
    fi

    local pid
    pid=`head -1 -- "${pid_file}"`

    if [ `ps -o pid -p ${pid} | wc -l` -eq 2 ]; then
        exit 0
    else
        stderr "${pid}: Process has finished!"
        exit 1
    fi
}

stderr()
{
    echo "$*" >&2
}

main "$@"
