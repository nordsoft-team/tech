#!/bin/bash

PRODUCT=myprodocut

echo "pkgbuild ..."
pkgbuild  --identifier com.taobao.nordsorft \
          --scripts ./scripts \
          --root ./root \
          ./package/${PRODUCT}.pkg

echo "productbuild ..."
productbuild  --distribution ./Distribution \
              --resources ./Resources \
              --package-path ./package \
              ./pkg/${PRODUCT}_installer.pkg