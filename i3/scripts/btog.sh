if [ `i3-msg -t get_tree | grep -Po '.*(},|\[)\K{.*?focused\\":true.*?}(?=(,{|\]))' | grep -Po 'current_border_width\\":\K[0-9]+'` -eq 0 ]; then
        i3-msg border pixel $border_width;
    else
        i3-msg border none;
    fi"
