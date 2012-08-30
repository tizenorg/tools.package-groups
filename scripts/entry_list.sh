#!/bin/bash

for mod in $(cat $1); do
    echo '<rpm:entry name="'$mod'"/>'
done
