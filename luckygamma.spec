Name:           luckygamma
Version:        VERSION
Release:        RELEASE
Summary:        Installs my personal repo.

Group:          Administrative
License:        GNU/GPL3
URL:            git@github.com:desertedscorpion/whitevenus.git
Source:         %{name}-%{version}.tar.gz
Prefix:         %{_prefix}
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Requires:            yum
BuildRequires:       coreutils
%define debug_package %{nil}


%description
This program installs my personal repo.

%prep
%setup -q


%build

%install
rm -rf ${RPM_BUILD_ROOT}
mkdir --parents ${RPM_BUILD_ROOT}/etc/yum.repos.d
cp luckygamma.repo ${RPM_BUILD_ROOT}/etc/yum.repos.d


%clean
rm -rf ${RPM_BUILD_ROOT}


%files
%attr(0644,root,root) /etc/yum.repos.d/luckygamma.repo
