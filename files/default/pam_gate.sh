#!/bin/bash

IS_AUTHENTICATED=$(cat /etc/passwd* | grep $PAM_USER)
echo $?
