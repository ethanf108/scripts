#!/bin/bash

cd $( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
git pull --ff-only 1>/dev/null 2>/dev/null || touch $HOME/.scripts-update-failed &
