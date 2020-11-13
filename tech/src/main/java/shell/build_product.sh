#!/bin/bash

PRODUCT=myproduct

chmod -R 755 ./root

echo "pkgbuild ..."
pkgbuild  --identifier com.taobao.nordsorft \
          --scripts ./darwin/scripts \
          --root ./root \
          ./package/${PRODUCT}.pkg

chmod -R 755 ./package

echo "productbuild ..."
productbuild  --distribution ./darwin/Distribution \
              --resources ./darwin/Resources \
              --package-path ./package \
              ./pkg/${PRODUCT}_installer.pkg