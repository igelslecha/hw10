#/bin/bash
time nice -n -20 su -c "dd if=/dev/zero of=/tmp/test.img bs=1M count=4096" &  time nice -n 19 su -c "dd if=/dev/zero of=/tmp/test2.img bs=1M count=4096" &
