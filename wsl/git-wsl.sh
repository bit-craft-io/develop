#!/bin/bash
exec wsl.exe -d Ubuntu -u guest git "$@"
