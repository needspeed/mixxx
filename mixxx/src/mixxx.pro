#
# Options, and path to libraries
#

# On Windows, select between WMME, DIRECTSOUND and ASIO.
# If ASIO is used, ensure that the path to the ASIO SDK 2 is set correctly below
WINPA = DIRECTSOUND

# Use this definition on Linux if Mixxx should be statically linked with libmad, 
# libid3tag, fftw, ogg, vorbis and audiofile
#unix:LINLIBPATH = ../../mixxx-linlib

# Path to Macintosh libraries
macx:MACLIBPATH = ../../mixxx-maclib

# Path to Windows libraries
win32:WINLIBPATH = ../../mixxx-winlib

# Path to ASIO SDK
ASIOSDK_DIR   = $$WINLIBPATH/asiosdk2

#
# End of options
#

# PortAudio 
SOURCES += playerportaudio.cpp
HEADERS += playerportaudio.h
DEFINES += __PORTAUDIO__
PORTAUDIO_DIR = ../lib/portaudio-v18
SOURCES += $$PORTAUDIO_DIR/pa_common/pa_lib.c $$PORTAUDIO_DIR/pa_common/pa_convert.c
HEADERS += $$PORTAUDIO_DIR/pa_common/portaudio.h $$PORTAUDIO_DIR/pa_common/pa_host.h
INCLUDEPATH += $$PORTAUDIO_DIR/pa_common
unix:!macx:SOURCES += $$PORTAUDIO_DIR/pablio/ringbuffer.c $$PORTAUDIO_DIR/pa_unix_oss/pa_unix.c $$PORTAUDIO_DIR/pa_unix_oss/pa_unix_oss.c
unix:!macx:HEADERS += $$PORTAUDIO_DIR/pablio/ringbuffer.h $$PORTAUDIO_DIR/pa_unix_oss/pa_unix.h
unix:!macx:INCLUDEPATH += $$PORTAUDIO_DIR/pa_unix_oss
macx:SOURCES += $$PORTAUDIO_DIR/pablio/ringbuffer.c $$PORTAUDIO_DIR/pa_mac_core/pa_mac_core.c
macx:LIBS += -framework CoreAudio -framework AudioToolbox
macx:INCLUDEPATH += $$PORTAUDIO_DIR/pa_mac_core $$PORTAUDIO_DIR/pablio 
win32 {
    contains(WINPA, DIRECTSOUND) {
        message("Compiling Mixxx using DirectSound drivers")
        SOURCES += $$PORTAUDIO_DIR/pa_win_ds/dsound_wrapper.c $$PORTAUDIO_DIR/pa_win_ds/pa_dsound.c
        LIBS += dsound.lib
        INCLUDEPATH += $$PORTAUDIO_DIR/pa_win_ds
    }
    contains(WINPA, ASIO) {
        message("Compiling Mixxx using ASIO drivers")
        SOURCES += $$PORTAUDIO_DIR/pa_asio/pa_asio.cpp $$ASIOSDK_DIR/common/asio.cpp $$ASIOSDK_DIR/host/asiodrivers.cpp $$ASIOSDK_DIR/host/pc/asiolist.cpp
        HEADERS += $$ASIOSDK_DIR/common/asio.h $$ASIOSDK_DIR/host/asiodrivers.h $$ASIOSDK_DIR/host/pc/asiolist.h
        INCLUDEPATH += $$PORTAUDIO_DIR/pa_asio $$ASIOSDK_DIR/common $$ASIOSDK_DIR/host $$ASIOSDK_DIR/host/pc
        LIBS += winmm.lib
    }
    contains(WINPA, WMME) {
        error("TO use WMME drivers add appropriate files to the mixxx.pro file first")
    }
}

# OSS Midi (Working good, Linux specific)
unix:!macx:SOURCES += midiobjectoss.cpp
unix:!macx:HEADERS += midiobjectoss.h
unix:!macx:DEFINES += __OSSMIDI__

# Windows MIDI
win32:SOURCES += midiobjectwin.cpp
win32:HEADERS += midiobjectwin.h
win32:DEFINES += __WINMIDI__

# CoreMidi (Mac OS X)
macx:SOURCES += midiobjectcoremidi.cpp
macx:HEADERS += midiobjectcoremidi.h
macx:DEFINES += __COREMIDI__
macx:LIBS    += -framework CoreMIDI -framework CoreFoundation

# ALSA PCM (Not currently working, Linux specific)
#SOURCES += playeralsa.cpp
#HEADERS += playeralsa.h
#DEFINES += __ALSA__
#unix:LIBS += -lasound

# ALSA MIDI (Not currently working, Linux specific)
#SOURCES += midiobjectalsa.cpp
#HEADERS += midiobjectalsa.h
#DEFINES  += __ALSAMIDI__

# Visuals
SOURCES += wvisualsimple.cpp wvisualwaveform.cpp visual/visualbackplane.cpp visual/texture.cpp visual/visualbox.cpp visual/visualbuffer.cpp visual/visualbuffersignal.cpp visual/visualbuffermarks.cpp visual/visualchannel.cpp visual/visualcontroller.cpp visual/visualdisplay.cpp visual/visualdisplaybuffer.cpp visual/light.cpp visual/material.cpp visual/picking.cpp visual/pickable.cpp visual/visualobject.cpp
HEADERS += wvisualsimple.h wvisualwaveform.h visual/visualbackplane.h  visual/texture.h visual/visualbox.h visual/visualbuffer.h visual/visualbuffersignal.h visual/visualbuffermarks.h visual/visualchannel.h visual/visualcontroller.h visual/visualdisplay.h visual/visualdisplaybuffer.h visual/light.h visual/material.h visual/picking.h visual/pickable.h visual/visualobject.h
CONFIG += opengl

# MP3
count(LINLIBPATH, 1) {
    unix:!macx:LIBS += $$LINLIBPATH/libs/libmad.a $$LINLIBPATH/libs/libid3tag.a
} else {
    unix:!macx:LIBS += -lmad -lid3tag
}
win32:LIBS += libmad-release.lib libid3tag-release.lib
macx:LIBS += $$MACLIBPATH/lib/libmad.a $$MACLIBPATH/lib/libid3tag.a

# MP3 vbrheadersdk from Xing Technology
INCLUDEPATH += ../lib/vbrheadersdk
SOURCES += ../lib/vbrheadersdk/dxhead.c
HEADERS += ../lib/vbrheadersdk/dxhead.h

# Wave files
unix:SOURCES += soundsourceaudiofile.cpp
unix:HEADERS += soundsourceaudiofile.h
count(LINLIBPATH, 1) {
    unix:!macx:LIBS += $$LINLIBPATH/libs/libaudiofile.a
} else {
    unix:!macx:LIBS += -laudiofile
}
win32:SOURCES += soundsourcesndfile.cpp
win32:HEADERS += soundsourcesndfile.h
win32:LIBS += libsndfile.lib
macx:LIBS += $$MACLIBPATH/lib/libaudiofile.a

# Ogg Vorbis
count(LINLIBPATH, 1) {
    unix:!macx:LIBS += $$LINLIBPATH/libs/libvorbisfile.a $$LINLIBPATH/libs/libvorbis.a $$LINLIBPATH/libs/libogg.a
} else {
    unix:!macx:LIBS += -lvorbisfile -lvorbis -logg
}
win32:LIBS += vorbisfile_static.lib vorbis_static.lib ogg_static.lib
macx:LIBS += $$MACLIBPATH/lib/libvorbis.a $$MACLIBPATH/lib/libvorbisfile.a $$MACLIBPATH/lib/libogg.a

# PowerMate
SOURCES += powermate.cpp
HEADERS += powermate.h
unix:!macx:SOURCES += powermatelinux.cpp
unix:!macx:HEADERS += powermatelinux.h
win32:SOURCES += powermatewin.cpp
win32:HEADERS += powermatewin.h
win32:LIBS += setupapi.lib

# Joystick
SOURCES += joystick.cpp
HEADERS += joystick.h
unix:!macx:SOURCES += joysticklinux.cpp
unix:!macx:HEADERS += joysticklinux.h

# FFT
count(LINLIBPATH, 1) {
    unix:!macx:LIBS += $$LINLIBPATH/libs/libsrfftw.a $$LINLIBPATH/libs/libsfftw.a
} else {
    unix:!macx:LIBS += -lsrfftw -lsfftw
}
win32:LIBS += rfftw2st-release.lib fftw2st-release.lib
macx:LIBS += $$MACLIBPATH/lib/librfftw.a $$MACLIBPATH/lib/libfftw.a

# Audio scaling
INCLUDEPATH += ../lib/libsamplerate
SOURCES += enginebufferscalesrc.cpp ../lib/libsamplerate/samplerate.c ../lib/libsamplerate/src_linear.c ../lib/libsamplerate/src_sinc.c ../lib/libsamplerate/src_zoh.c
HEADERS += enginebufferscalesrc.h ../lib/libsamplerate/samplerate.h ../lib/libsamplerate/config.h ../lib/libsamplerate/common.h ../lib/libsamplerate/float_cast.h ../lib/libsamplerate/fastest_coeffs.h ../lib/libsamplerate/high_qual_coeffs.h ../lib/libsamplerate/mid_qual_coeffs.h

# Debug plotting through gplot API
#unix:DEFINES += __GNUPLOT__
#unix:INCLUDEPATH += ../lib/gplot
#unix:SOURCES += ../lib/gplot/gplot3.c
#unix:HEADERS += ../lib/gplot/gplot.h

unix:!macx {
  # If Intel compiler is used, set icc optimization flags
  COMPILER = $$system(echo $QMAKESPEC)
  contains(COMPILER, linux-icc) {
    message("Using Intel compiler")
#    QMAKE_CXXFLAGS += -rcd -tpp6 -xiMK # icc pentium III
#    QMAKE_CXXFLAGS += -rcd -tpp7 -xiMKW # icc pentium IV
#    QMAKE_CXXFLAGS += -prof_gen # generete profiling
#    QMAKE_CXXFLAGS += -prof_use # use profiling
    QMAKE_CXXFLAGS += -w1 #-Wall
    # icc Profiling
#    QMAKE_CXXFLAGS_DEBUG += -qp -g
#    QMAKE_LFLAGS_DEBUG += -qp -g
  }

  DEFINES += UNIX_SHARE_PATH=\"/usr/share/mixxx\"
  SETTINGS_FILE = \".mixxx.cfg\"
  DEFINES += __LINUX__
}

unix {
  DEFINES += __UNIX__
  INCLUDEPATH += .
  UI_DIR = .ui
  MOC_DIR = .moc
  OBJECTS_DIR = .obj

# Libs needed for static linking on Linux
count(LINLIBPATH,1) {
    unix:message("Using static linking")
#    unix:LIBS += -ldl -lm -lXrender -lSM /usr/lib/libfontconfig.a -lXft
}

# GCC Compiler optimization flags
#  QMAKE_CXXFLAGS += -march=pentium3 -O3 -pipe
#  QMAKE_CFLAGS   += -march=pentium3 -O3 -pipe

# gcc Profiling
#  QMAKE_CXXFLAGS_DEBUG += -pg
#  QMAKE_LFLAGS_DEBUG += -pg
}

win32 {
  DEFINES += __WIN__
  INCLUDEPATH += $$WINLIBPATH ../lib .
  QMAKE_CXXFLAGS += -GX
  QMAKE_LFLAGS += /VERBOSE:LIB /libpath:$$WINLIBPATH /NODEFAULTLIB:library /NODEFAULTLIB:libcd /NODEFAULTLIB:libcmt /NODEFAULTLIB:libc
  SETTINGS_FILE = \"mixxx.cfg\"
  RC_FILE = mixxx.rc
}

macx {
  DEFINES += __MACX__
  INCLUDEPATH += $$MACLIBPATH/include
  LIBS += -lz -framework Carbon -framework QuickTime
  SETTINGS_FILE = \"mixxx.cfg\"
  RC_FILE = icon.icns
}

FORMS	= dlgprefsounddlg.ui dlgprefmididlg.ui dlgprefplaylistdlg.ui dlgprefcontrolsdlg.ui

SOURCES += configobject.cpp fakemonitor.cpp controlengine.cpp controleventengine.cpp controleventmidi.cpp controllogpotmeter.cpp controlobject.cpp controlnull.cpp controlpotmeter.cpp controlpushbutton.cpp controlttrotary.cpp controlbeat.cpp dlgpreferences.cpp dlgprefsound.cpp dlgprefmidi.cpp dlgprefplaylist.cpp dlgprefcontrols.cpp enginebuffer.cpp enginebufferscale.cpp engineclipping.cpp enginefilterblock.cpp enginefilteriir.cpp enginefilterrbj.cpp engineobject.cpp enginepregain.cpp enginevolume.cpp main.cpp midiobject.cpp midiobjectnull.cpp mixxx.cpp mixxxview.cpp player.cpp soundsource.cpp soundsourcemp3.cpp soundsourceoggvorbis.cpp monitor.cpp enginechannel.cpp enginemaster.cpp wwidget.cpp wpixmapstore.cpp wnumberbpm.cpp wnumberpos.cpp wnumber.cpp wknob.cpp wdisplay.cpp wvumeter.cpp wpushbutton.cpp wslidercomposed.cpp wslider.cpp wtracktable.cpp wtracktableitem.cpp enginedelay.cpp engineflanger.cpp enginespectralfwd.cpp enginespectralback.cpp mathstuff.cpp readerextract.cpp readerextractwave.cpp readerextractfft.cpp readerextracthfc.cpp readerextractbeat.cpp readerevent.cpp rtthread.cpp windowkaiser.cpp probabilityvector.cpp reader.cpp tracklist.cpp trackinfoobject.cpp enginevumeter.cpp peaklist.cpp
HEADERS += configobject.h fakemonitor.h controlengine.h controleventengine.h controleventmidi.h controllogpotmeter.h controlobject.h controlnull.h controlpotmeter.h controlpushbutton.h controlttrotary.h controlbeat.h defs.h dlgpreferences.h dlgprefsound.h dlgprefmidi.h dlgprefplaylist.h dlgprefcontrols.h enginebuffer.h enginebufferscale.h engineclipping.h enginefilterblock.h enginefilteriir.h enginefilterrbj.h engineobject.h enginepregain.h enginevolume.h midiobject.h midiobjectnull.h mixxx.h mixxxview.h player.h soundsource.h soundsourcemp3.h soundsourceoggvorbis.h monitor.h enginechannel.h enginemaster.h wwidget.h wpixmapstore.h wnumberbpm.h wnumberpos.h wnumber.h wknob.h wdisplay.h wvumeter.h wpushbutton.h wslidercomposed.h wslider.h wtracktable.h wtracktableitem.h enginedelay.h engineflanger.h enginespectralfwd.h enginespectralback.h mathstuff.h readerextract.h readerextractwave.h readerextractfft.h readerextracthfc.h readerextractbeat.h readerevent.h rtthread.h windowkaiser.h probabilityvector.h reader.h  tracklist.h trackinfoobject.h enginevumeter.h peaklist.h

IMAGES += icon.png
DEFINES += SETTINGS_FILE=$$SETTINGS_FILE
unix:TEMPLATE = app
win32:TEMPLATE = vcapp
#CONFIG += qt thread warn_off release
CONFIG += qt thread warn_on debug
DBFILE = mixxx.db
LANGUAGE = C++
