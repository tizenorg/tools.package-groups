Summary:	Tizen Package Groups
Name:		package-groups
Version:	41
Release:	1
License:	GPLv2
Group:		System/Base
URL:		http://www.tizen.org
Source:		%{name}-%{version}.tar.bz2
Source1001: packaging/package-groups.manifest 
BuildRequires: libxslt
BuildRequires: python-yaml
BuildRequires: python-lxml


%description
Tizen Package Groups

%prep
%setup -q

%build
cp %{SOURCE1001} .
%ifarch %{arm}
make ARCH=arm
%else
make ARCH=i586
%endif

%install
%make_install


%files
%manifest package-groups.manifest
/usr/share/package-groups/*xml

