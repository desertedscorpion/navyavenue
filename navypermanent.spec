RELEASE=$(shell git describe --tags)

jenkins-client-${VERSION}.spec : jenkins-client.spec
	sed -e "s#VERSION#${VERSION}#" -e "s#RELEASE#${RELEASE}#" -e "w${@}" ${<}

jenkins-client-${VERSION} :
	mkdir ${@}
	git -C ${@} init
	git -C ${@} remote add origin git@github.com:desertedscorpion/scatteredfinger.git
	git -C ${@} fetch origin

jenkins-client-${VERSION}.tar : jenkins-client-${VERSION}
	git -C ${<} archive --prefix jenkins-client-${VERSION}/ tags/${VERSION} > ${@}

jenkins-client-${VERSION}.tar.gz : jenkins-client-${VERSION}.tar
	gzip --to-stdout ${<} > ${@}

buildsrpm/jenkins-client-${VERSION}-${RELEASE}.src.rpm : jenkins-client-${VERSION}.spec jenkins-client-${VERSION}.tar.gz
	mkdir --parents buildsrpm
	mock --buildsrpm --spec jenkins-client-${VERSION}.spec --sources jenkins-client-${VERSION}.tar.gz --resultdir buildsrpm

rebuild/jenkins-client-${VERSION}-${RELEASE}.x86_64.rpm : buildsrpm/jenkins-client-${VERSION}-${RELEASE}.src.rpm
	mkdir --parents rebuild
	mock --rebuild buildsrpm/jenkins-client-${VERSION}-${RELEASE}.src.rpm --resultdir rebuild
