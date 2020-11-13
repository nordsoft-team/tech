#!/bin/bash

PRODUCT=myprodocut

log_info "pkgbuild ..."
pkgbuild  --identifier com.taobao.nordsorft \
          --scripts ./scripts \
          --root ./root \
          ./package/${PRODUCT}.pkg

log_info "productbuild ..."
productbuild  --distribution ./Distribution \
              --resources ./Resources \
              --package-path ./package \
              ./pkg/${PRODUCT}_installer.pkg