#!/bin/bash

usage()
{
cat << EOF
usage: $0 -c <chat-id> -s <sevabot-secret> -a <sevabot-address> -m <message>
EOF
}

# Initialization
while getopts “hc:s:a:m:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         c)
             CHAT=$OPTARG
             ;;
         s)
             SECRET=$OPTARG
             ;;
         a)
             MSG_ADDRESS=$OPTARG
             ;;
         m)
             MESSAGE=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [[ -z $CHAT ]] || [[ -z $SECRET ]] || [[ -z $MSG_ADDRESS ]] || [[ -z $MESSAGE ]]
then
     usage
     exit 1
fi

# Sign the message with MD5
md5=`echo -n "$CHAT$MESSAGE$SECRET" | md5 -r`

#md5sum command prints a '-' to the end. Let's get rid of that.
for m in $md5; do
  break
done

# Call Sevabot's HTTP interface
curl $MSG_ADDRESS --data-urlencode chat="$CHAT" --data-urlencode msg="$MESSAGE" --data-urlencode md5="$m"

exit 0
