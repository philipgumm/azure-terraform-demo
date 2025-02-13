ls -l /var/lib/waagent/custom-script/download/
sudo cd -l /var/lib/waagent/custom-script/download/

curl -O "https://labmanagementstorage01.blob.core.windows.net/public-azure-terraform-demo/linux_base.sh"
sh linux_base.sh

cat /var/log/azure/custom-script/handler.log | tail -50

cat /var/lib/waagent/custom-script/download/0/stdout
cat /var/lib/waagent/custom-script/download/0/stderr


cat /var/lib/waagent/custom-script/download/0/stderr
cat /var/log/azure/custom-script/handler.log

