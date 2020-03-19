find . -name '*.pkg' | xargs -I{} sudo installer -pkg {} -target /

pkgbuild --identifier com.abcd --root ~/Downloads/src/ --install-location ~/Downloads/dst/ --scripts ~/Downloads/sh/ ~/Downloads/package.pkg

productbuild --synthesize --package ~/Downloads/package.pkg ~/Downloads/distribution/dist
#<background file="background"/>
#<welcome file="welcome"/>
#<license file="license"/>

productbuild --distribution ~/Downloads/distribution/dist --resources ~/Downloads/resources/ ~/Downloads/product.pkg