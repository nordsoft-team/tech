#!/bin/bash

echo "started ..."
cd $(dirname $0)

echo "pkgbuild ..."
pkgbuild  --identifier com.taobao.nordsorft.myPkg --scripts ./scripts --root ./root ./myPkg.pkg

echo "productbuild ..."
productbuild  --distribution ./Distribution --resources ./Resources --package-path ./ ./myProduct.pkg

echo "finished ..."