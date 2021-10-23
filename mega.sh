creds=${1:-"creds.txt"}
mega-logout 1>/dev/null
IFS=","
while read email pass
do
        echo -e "\n>>> $email"
        mega-login $email $pass
        if [ ! $? -eq 0 ]; then
                echo "Login failed with $email, So check creds or account expired"
                continue
        fi
        mega-df -h
        mega-logout 1>/dev/null
done <$creds
