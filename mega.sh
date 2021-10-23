creds=${1:-"creds.txt"}
mega-logout 1>/dev/null
IFS=","
while read email pass; do
        echo -e "\n>>> $email"
        mega-login $email $pass
        if [ ! $? -eq 0 ]; then
                echo "Unable to login as $email"
                continue
        fi
        mega-df -h
        mega-logout 1>/dev/null
done <$creds
