Summary:        Utilities from the general purpose cryptography library with TLS implementation
Name:           openssl3
Version:        3.1.4
# Version:        1.4
Release:        0
License:        Apache-2.0
Vendor:         Microsoft-Corporation
Distribution:   Mariner
Group:          System Environment/Security
URL:            https://www.openssl.org/
# DO WE NEED TO HOBBLE OPENSSL?????
# TODO:
# Want to use %{name} here, but since I'm using 'openssl-3', the source tarball
# would be named 'openssl-3-3.1.4.tar.gz' which is not what we want.
Source0:        https://www.openssl.org/source/openssl-%{version}.tar.gz
# Source0:        https://www.openssl.org/source/openssl-%{version}.tar.gz
Requires:       perl >= 5.13.4
BuildRequires:  perl-Text-Template
BuildRequires:  perl-FindBin
BuildRequires:  perl-lib
BuildRequires:  perl-IPC-Cmd
# Requires:       perl(Text::Template)
# Requires:       perl(FindBin)

%description
The OpenSSL toolkit provides support for secure communications between
machines. OpenSSL includes a certificate management tool and shared
libraries which provide various cryptographic algorithms and
protocols.

%prep
cp openssl-%{version}.tar.gz %{name}-%{version}.tar.gz
%autosetup -p1

%build
./Configure
make -j$(nproc)

%install
make install DESTDIR=%{buildroot}

%check
make test