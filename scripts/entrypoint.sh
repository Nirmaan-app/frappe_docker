# /scripts/entrypoint.sh
#!/bin/bash
set -e

# Check if fcm.env already exists in the sites directory
if [ ! -f /home/frappe/frappe-bench/sites/fcm.env ]; then
  echo "Creating /home/frappe/frappe-bench/sites/fcm.env from secret..."
  export FCM_ACCESS=$(cat /run/secrets/FCM_ACCESS)
  echo ${FCM_ACCESS} > /home/frappe/frappe-bench/sites/fcm.env
  chown frappe:frappe /home/frappe/frappe-bench/sites/fcm.env
else
  echo "/home/frappe/frappe-bench/sites/fcm.env already exists."
fi

# Continue with the default command
exec "$@"
