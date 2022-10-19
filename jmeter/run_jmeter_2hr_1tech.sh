#!/bin/bash

jmeter -n -t Simulation\ Plan.jmx -Jhr_user_1_enable=true -Jhr_user_2_enable=true -Jtech_user_1_enable=true -Jhr_manager_enable=true
