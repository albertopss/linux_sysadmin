#!/bin/bash

input="Your string here"
uppercase=$(echo "$input" | tr '[:lower:]' '[:upper:]')
echo "$uppercase"

