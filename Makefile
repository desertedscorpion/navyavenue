RELEASE=$(shell git describe --tags)

emory-${VERSION}.spec : emory.spec
	sed -e "s#VERSION#${VERSION}#" -e "s#RELEASE#${RELEASE}#" -e "w${@}" ${<}

emory-${VERSION} :
	mkdir ${@}
	git -C ${@} init
	git -C ${@} remote add origin git@github.com:desertedscorpion/alienmetaphor.git
	git -C ${@} fetch origin

emory-${VERSION}.tar : emory-${VERSION}
	git -C ${<} archive --prefix emory-${VERSION}/ tags/${VERSION} > ${@}

emory-${VERSION}.tar.gz : emory-${VERSION}.tar
	gzip --to-stdout ${<} > ${@}

buildsrpm/emory-${VERSION}-${RELEASE}.src.rpm : emory-${VERSION}.spec emory-${VERSION}.tar.gz
	mkdir --parents buildsrpm
	mock --buildsrpm --spec emory-${VERSION}.spec --sources emory-${VERSION}.tar.gz --resultdir buildsrpm

rebuild/emory-${VERSION}-${RELEASE}.x86_64.rpm : buildsrpm/emory-${VERSION}-${RELEASE}.src.rpm
	mkdir --parents rebuild
	mock --rebuild buildsrpm/emory-${VERSION}-${RELEASE}.src.rpm --resultdir rebuild
