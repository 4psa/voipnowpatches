#!/bin/sh
# Copyright (c) 2002-2014 by Rack-Soft, INC
# Copyright (c) 2002-2014 by 4PSA (www.4psa.com)

#Description 
#The following script patches VoipNow  2.x - 3.0.5 against CVE-2014-356
check_voipnow()
{
        if [ -f /usr/local/voipnow/.version ];then
                version=`/bin/awk '{print $1}' /usr/local/voipnow/.version|awk -F'.' '{print $1$2$3}'`
        else
                echo " VoipNow does not seem to be installed on this system!!!"
                exit 0
        fi
}
check_voipnow
#backup config first
if [ ${version} -ge 300 -a ${version} -le 305 ];then
        echo "==> Backup config to /usr/local/voipnow/admin/conf/voipnow.conf.sslfixbackup"
        /bin/cp -fp /usr/local/voipnow/admin/conf/voipnow.conf /usr/local/voipnow/admin/conf/voipnow.conf.sslfixbackup
        echo "==> Disable SSLv3 protocol"
        /bin/sed -i 's/^.*ssl_protocols.*$/\tssl_protocols TLSv1 TLSv1.1 TLSv1.2;/g' /usr/local/voipnow/admin/conf/voipnow.conf
        echo "==> Restart Web Management server"
        /etc/init.d/httpsa restart
fi
if [ ${version} -ge 200 -a ${version} -lt 300 ];then
        if [ `grep -Ec "^.*ssl\.use-sslv3.*disable.*$" /usr/local/voipnow/admin/conf/voipnow.conf` -ge 1 ];then
            echo "==> Patch already aplied "
            exit 0
        fi
                                               	
        echo "==> Backup config to /usr/local/voipnow/admin/conf/voipnow.conf.sslfixbackup"
        /bin/cp -fp /usr/local/voipnow/admin/conf/voipnow.conf /usr/local/voipnow/admin/conf/voipnow.conf.sslfixbackup
        echo "==> Disable SSLv3 protocol"
        /bin/sed -i 's/^.*ssl.cipher-list.*$//' /usr/local/voipnow/admin/conf/voipnow.conf
        /bin/sed -i 's/^.*ssl.engine.*$/\tssl.engine\t= "enable"\n\tssl.cipher-list\t= "ECDHE-RSA-AES256-SHA384:AES256-SHA256:RC4:HIGH:!MD5:!aNULL:!eNULL:!NULL:!DH:!EDH:!AESGCM"\n\tssl.use-sslv2\t= "disable"\n\tssl.use-sslv3\t= "disable"\n\tssl.honor-cipher-order\t= "enable"\n/' /usr/local/voipnow/admin/conf/voipnow.conf
        echo "==> Restart Web Management Server"
        /etc/init.d/voipnow restart

fi
