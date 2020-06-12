mkdir -p myPkg/scripts
rm -rf myPkg/scripts/postinstall
echo "#!/bin/sh" >> myPkg/scripts/postinstall
echo "date >> /tmp/myPkg" >> myPkg/scripts/postinstall
chmod u+x myPkg/scripts/postinstall
pkgbuild --nopayload --scripts myPkg/scripts --identifier com.apple.pkg myPkg.pkg