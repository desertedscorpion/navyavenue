RELEASE=$(shell git describe --tags)

luckygamma-${VERSION}.spec : luckygamma.spec
	sed -e "s#VERSION#${VERSION}#" -e "s#RELEASE#${RELEASE}#" -e "w${@}" ${<}

luckygamma-${VERSION} :
	mkdir ${@}
	git -C ${@} init
	git -C ${@} remote add origin git@github.com:desertedscorpion/alienmetaphor.git
	git -C ${@} fetch origin

luckygamma-${VERSION}.tar : luckygamma-${VERSION}
	git -C ${<} archive --prefix luckygamma-${VERSION}/ tags/${VERSION} > ${@}

luckygamma-${VERSION}.tar.gz : luckygamma-${VERSION}.tar
	gzip --to-stdout ${<} > ${@}

buildsrpm/luckygamma-${VERSION}-${RELEASE}.src.rpm : luckygamma-${VERSION}.spec luckygamma-${VERSION}.tar.gz
	mkdir --parents buildsrpm
	mock --buildsrpm --spec luckygamma-${VERSION}.spec --sources luckygamma-${VERSION}.tar.gz --resultdir buildsrpm

rebuild/luckygamma-${VERSION}-${RELEASE}.x86_64.rpm : buildsrpm/luckygamma-${VERSION}-${RELEASE}.src.rpm
	mkdir --parents rebuild
	mock --rebuild buildsrpm/luckygamma-${VERSION}-${RELEASE}.src.rpm --resultdir rebuild
