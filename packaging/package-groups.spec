Summary:	SLP Package Groups
Name:		package-groups
Version:	0.36
Release:	0
License:	GPLv2
Group:		System/Base
URL:		http://www.tizen.org
Source:		%{name}-%{version}.tar.gz
BuildRoot:	%{_tmppath}/%{name}-%{version}-%{release}-root
BuildRequires:  libxslt


%description
SLP Package Groups

%prep
%setup -q

%build
%ifarch %{arm}
make ARCH=arm
%else
make ARCH=i586
%endif

%install
%make_install

%clean
rm -rf %{buildroot}

%files
/usr/share/package-groups/*xml

