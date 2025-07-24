#!/bin/bash

# Source the colors.sh file to get color variables
source "/home/dark/arch-config/wob/colors.sh"

# Read the template file
template_content=$(cat "/home/dark/arch-config/wob/template")

# Clean and format color values (remove '#' and quotes, add 'FF' for alpha)
border_color_clean=$(echo "${color1}" | tr -d '#' | tr -d "'" )FF
background_color_clean=$(echo "${background}" | tr -d '#' | tr -d "'" )FF
bar_color_clean=$(echo "${color2}" | tr -d '#' | tr -d "'" )FF
overflow_bar_color_clean=$(echo "${color3}" | tr -d '#' | tr -d "'" )FF
overflow_background_color_clean=$(echo "${color0}" | tr -d '#' | tr -d "'" )FF
overflow_border_color_clean=$(echo "${color4}" | tr -d '#' | tr -d "'" )FF

# Replace placeholders with actual color values using sed
wob_ini_content=$(echo "$template_content" | \
sed "s/{{BORDER_COLOR}}/${border_color_clean}/g" | \
sed "s/{{BACKGROUND_COLOR}}/${background_color_clean}/g" | \
sed "s/{{BAR_COLOR}}/${bar_color_clean}/g" | \
sed "s/{{OVERFLOW_BAR_COLOR}}/${overflow_bar_color_clean}/g" | \
sed "s/{{OVERFLOW_BACKGROUND_COLOR}}/${overflow_background_color_clean}/g" | \
sed "s/{{OVERFLOW_BORDER_COLOR}}/${overflow_border_color_clean}/g")

# Write the content to wob.ini
echo "$wob_ini_content" > "/home/dark/arch-config/wob/wob.ini"

echo "Generated wob.ini successfully!"