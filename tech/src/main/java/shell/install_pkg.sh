find . -name '*.pkg' | xargs -I{} sudo installer -pkg {} -target /

pkgbuild --identifier com.abcd --root ~/Downloads/myPkgs/src/ --install-location ~/Downloads/myPkgs/dst/ --scripts ~/Downloads/myPkgs/scripts/ ~/Downloads/myPkgs/package.pkg

productbuild --synthesize --package ~/Downloads/myPkgs/package.pkg ~/Downloads/myPkgs/dist
#<background file="background"/>
#<welcome file="welcome"/>
#<license file="license"/>

productbuild --distribution ~/Downloads/myPkgs/dist --resources ~/Downloads/myPkgs/resources/ ~/Downloads/myPkgs/product.pkg