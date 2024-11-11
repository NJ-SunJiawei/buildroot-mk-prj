yum install -y gcc make rpm-build ncurses-devel openssl openssl-devel bc bison flex elfutils-libelf-devel dwarves perl
--------------------------------------------------------------------
# 解压 .tar.xz 文件
tar -xJf linux-5.10.1-openeuler.tar.xz
# 在kernel源码中写入.spec
cd linux-5.10.1-openeuler
touch  kernel.spec  ###写入kernel.spec内容
cp ../linux-kernel-openeuler.config .config
make  ARCH=arm64 CROSS_COMPILE=/home/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu- menuconfig

# 重新打包并压缩为 .tar.gz 文件
tar -czf linux-5.10.1-openeuler.tar.gz linux-5.10.1-openeuler

# 删除解压后的目录
rm -rf linux-5.10.1

rm -rf ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}


# kernel.spec放到~/rpmbuild/SPECS/ (-ta不需要 -ba才需要)
# touch  ~/rpmbuild/SPECS/kernel.spec
--------------------------------------------------------------------
kernel.spec   交叉编译的
--------------------------------------------------------------------
Name:           kernel
Summary:        The Linux Kernel
Version:        5.10.1
Release:        1%{?dist}
License:        GPLv2
Group:          System Environment/Kernel
Vendor:         The Linux Community
URL:            https://www.kernel.org
Source:         /home/linux-%{version}-openeuler.tar.gz
Provides:       kernel-drm kernel-%{version}
%define         __spec_install_post %{nil}
%define         debug_package %{nil}

%description
The Linux Kernel, the core of the operating system, cross-compiled for the arm64 architecture.

%package headers
Summary:        Header files for the Linux kernel for use by glibc
Group:          Development/System
Provides:       kernel-headers = %{version}

%description headers
Kernel headers for building standard programs and glibc, including C headers that define structures and constants required for userspace.

%package devel
Summary:        Development package for building kernel modules to match the %{version} kernel
Group:          System Environment/Kernel
Requires:       %{name} = %{version}-%{release}
Provides:       kernel-devel

%description devel
This package includes kernel headers and makefiles sufficient to build modules against the %{version} kernel package.

%prep
#%setup -q
%setup -n linux-%{version}-openeuler

%build
export ARCH=arm64
export CROSS_COMPILE=/home/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
make %{?_smp_mflags} ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} KBUILD_BUILD_VERSION=%{release}

%install
export ARCH=arm64
export CROSS_COMPILE=/home/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-

mkdir -p %{buildroot}/boot
mkdir -p %{buildroot}/usr/src/kernels/%{version}

cp $(make -s image_name) %{buildroot}/boot/vmlinuz-%{version}
make %{?_smp_mflags} ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} INSTALL_MOD_PATH=%{buildroot} modules_install
make %{?_smp_mflags} ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} INSTALL_HDR_PATH=%{buildroot}/usr headers_install
cp System.map %{buildroot}/boot/System.map-%{version}
cp .config %{buildroot}/boot/config-%{version}

mkdir -p %{buildroot}/lib/modules/%{version}
cp -a . %{buildroot}/usr/src/kernels/%{version}
(cd %{buildroot}/lib/modules/%{version}; ln -sf /usr/src/kernels/%{version} build; ln -sf /usr/src/kernels/%{version} source)

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
/boot/vmlinuz-%{version}
/boot/System.map-%{version}
/boot/config-%{version}
/lib/modules/%{version}

%files headers
%defattr(-,root,root,-)
/usr/include

%files devel
%defattr(-,root,root,-)
/usr/src/kernels/%{version}
/lib/modules/%{version}/build
/lib/modules/%{version}/source
--------------------------------------------------------------------
kernel.spec  结束
--------------------------------------------------------------------

rpmbuild --target aarch64 -ta /home/linux-5.10.1-openeuler.tar.gz --define='_smp_mflags %{nil}'
ls ~/rpmbuild/RPMS/aarch64

