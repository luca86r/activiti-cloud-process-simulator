#!/bin/bash


while getopts i:h:t: flag
do
    case "${flag}" in
        i) cluster_ip=${OPTARG};;
	h) hr_user_count=${OPTARG};;
        t) tech_user_count=${OPTARG};;
    esac
done

hr_user_1_enable=false
hr_user_2_enable=false
hr_user_3_enable=false
tech_user_1_enable=false
tech_user_2_enable=false
proc_type="simple"

if [[ $tech_user_count -gt 0 ]]; then
	proc_type="complex"
fi

if [[ $hr_user_count -ge 1 ]]; then
	hr_user_1_enable=true
fi

if [[ $hr_user_count -ge 2 ]]; then
        hr_user_2_enable=true
fi

if [[ $hr_user_count -ge 3 ]]; then
        hr_user_3_enable=true
fi

if [[ $tech_user_count -ge 1 ]]; then
        tech_user_1_enable=true
fi

if [[ $tech_user_count -ge 2 ]]; then
        tech_user_2_enable=true
fi

echo "cluster_ip: $cluster_ip"
echo "hr_user_1_enable: $hr_user_1_enable"
echo "hr_user_2_enable: $hr_user_2_enable"
echo "hr_user_3_enable: $hr_user_3_enable"
echo "tech_user_1_enable: $tech_user_1_enable"
echo "tech_user_2_enable: $tech_user_2_enable"
echo "proc_type: $proc_type"

jmeter -n -t Simulation\ Plan.jmx -Jcluster_ip=$cluster_ip -Jproc_type=$proc_type -Jhr_user_1_enable=$hr_user_1_enable -Jhr_user_2_enable=$hr_user_2_enable -Jhr_user_3_enable=$hr_user_3_enable -Jtech_user_1_enable=$tech_user_1_enable -Jtech_user_2_enable=$tech_user_2_enable -Jhr_manager_enable=true
