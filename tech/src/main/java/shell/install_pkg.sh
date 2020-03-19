find . -name '*.pkg' | xargs -I{} sudo installer -pkg {} -target /

pkgbuild --identifier com.abcd --root ~/Downloads/src/ --install-location ~/Downloads/dst --scripts ~/Downloads/sh/ ~/Downloads/install.pkg