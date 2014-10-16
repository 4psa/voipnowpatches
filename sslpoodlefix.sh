#!/bin/sh
# Copyright (c) 2002-2014 by Rack-Soft, INC
# Copyright (c) 2002-2014 by 4PSA (www.4psa.com)

#Description 
#The following script fixes patches VoipNow Professional 2.x and VoipNow SPE 3.0.x against CVE-2014-356
check_voipnow()
{
        if [ -f /usr/local/voipnow/.version ];then
                version=`/bin/awk '{print $1}' /usr/local/voipnow/.version|awk -F'.' '{print $1}'`
        else
                echo " VoipNow does not seem to be installed on this system!!!"
                exit 0
        fi
}
check_voipnow
#backup config first
if [ ${version} == "3" ];then
        echo "==> Backup config to /usr/local/voipnow/admin/conf/voipnow.conf.sslfixbackup"
        /bin/cp -fp /usr/local/voipnow/admin/conf/voipnow.conf /usr/local/voipnow/admin/conf/voipnow.conf.sslfixbackup
        echo "==> Disable SSLv3 protocol"
        /bin/sed -i 's/^[ \t]ssl_protocols.*$/\tssl_protocols TLSv1 TLSv1.1 TLSv1.2;/g' /usr/local/voipnow/admin/conf/voipnow.conf
        echo "==> Restart Web Management server"
        /etc/init.d/httpsa restart
fi
if [ ${version} == "2" ];then
        echo "==> Backup config to /usr/local/voipnow/admin/conf/voipnow.conf.sslfixbackup"
        /bin/cp -fp /usr/local/voipnow/admin/conf/voipnow.conf /usr/local/voipnow/admin/conf/voipnow.conf.sslfixbackup
        echo "==> Disable SSLv3 protocol"
        /bin/sed -i 's/^[ \t]*ssl.engine.*$/\tssl.engine                              = "enable"\n\tssl.cipher-list         = "ECDHE-RSA-AES256-SHA384:AES256-SHA256:RC4:HIGH:!MD5:!aNULL:!eNULL:!NULL:!DH:!EDH:!AESGCM"\nssl.use-sslv2           = "disable"\nssl.use-sslv3           = "disable"\n\tssl.use-compression     = "disable"\n\tssl.honor-cipher-order  = "enable"\n/' /usr/local/voipnow/admin/conf/voipnow.conf
        echo "==> Restart Web Management Server"
        /etc/init.d/voipnow restart

fi
