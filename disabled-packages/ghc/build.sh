# See https://ghc.haskell.org/trac/ghc/wiki/Building/CrossCompiling
#     https://ghc.haskell.org/trac/ghc/wiki/Building/Preparation/Linux
# and
#     https://github.com/neurocyte/ghc-android
#
# Status: Currently fails at "error: cannot find -lpthread"
#         right after message about building bin/hpc.
#         As libpthread does not exist on Android (pthread
#         is built into libc, this needs to be patched away.
TERMUX_PKG_HOMEPAGE=https://www.haskell.org/ghc/
TERMUX_PKG_DESCRIPTION="The Glasgow Haskell Compilation system"
TERMUX_PKG_VERSION=8.0.1
TERMUX_PKG_SRCURL=http://downloads.haskell.org/~ghc/${TERMUX_PKG_VERSION}/ghc-${TERMUX_PKG_VERSION}-src.tar.xz
TERMUX_PKG_FOLDERNAME=ghc-$TERMUX_PKG_VERSION
TERMUX_PKG_BUILD_IN_SRC=yes
# Depend on clang for now until llvm is split into separate package:
TERMUX_PKG_DEPENDS="clang, ncurses"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-iconv-includes=$TERMUX_PREFIX/include -with-iconv-libraries=$TERMUX_PREFIX/lib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-curses-includes=$TERMUX_PREFIX/include/ncursesw -with-curses-libraries=$TERMUX_PREFIX/lib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --host=${TERMUX_HOST_PLATFORM}"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --target=${TERMUX_HOST_PLATFORM}"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --host=x86_64-unknown-linux --build=x86_64-unknown-linux"

ORIG_CFLAGS="$CFLAGS"
ORIG_CPPFLAGS="$CPPFLAGS"
ORIG_LDFLAGS="$LDFLAGS"

unset AR
unset AS
unset CC
export CFLAGS=""
unset CPP
export CPPFLAGS=""
unset CXXFLAGS
unset CXX
export LDFLAGS=""
unset LD
unset PKG_CONFIG
unset RANLIB

termux_step_pre_configure () {
	echo "INTEGER_LIBRARY = integer-simple" > mk/build.mk
	#echo "GhcStage2HcOpts = $ORIG_CFLAGS $ORIG_CPPFLAGS $ORIG_LDFLAGS" >> mk/build.mk

	# Avoid "Can't use -fPIC or -dynamic on this platform":
	echo "DYNAMIC_GHC_PROGRAMS = NO" >> mk/build.mk
	echo "GhcLibWays = v" >> mk/build.mk
	# "Can not build haddock docs when CrossCompiling or Stage1Only".
	echo "HADDOCK_DOCS=NO" >> mk/build.mk
}
