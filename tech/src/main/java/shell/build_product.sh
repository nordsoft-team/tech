#!/bin/bash

echo "pkgbuild ..."
pkgbuild  --identifier com.taobao.nordsorft.myPkg \
          --scripts ./scripts \
          --root ./root \
          ./myPkg.pkg

echo "productbuild ..."
productbuild  --distribution ./distribution.xml \
              --resources ./Resources \
              --package-path ./ \
              ./myProduct.pkg