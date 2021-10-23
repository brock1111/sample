log_msg() {
	echo ooof
}
creds=${1:-"creds.csv"}
mega-logout 1>/dev/null

IFS=","
while read username password; do
        echo -e "\n>>> $username"
        log_msg "Trying to login as $username"

        mega-login $username $password >&5

        if [ ! $? -eq 0 ]; then
                echo "Unable to login as $username"
                log_msg "[ERROR] Unable to login as $username"
                continue
        fi



        mega-df -h

        mega-logout 1>/dev/null

done <$creds
