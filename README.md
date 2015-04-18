FreeSWITCH Dockerfile
=====================

This project can be used to deploy a FreeSWITCH server inside a Docker container. The container currently uses the latest stable release version 1.4.18. An effort was made to build many modules so the container can be generic enough to serve many purposes.

## Running the Container

## Available Modules

The following modules are available in the container and can be loaded at runtime by providing a `modules.conf.xml` file with the desired module names uncommented.

### Applications

- mod_avmd
- mod_blacklist
- mod_callcenter
- mod_cidlookup
- mod_commands
- mod_conference
- mod_curl
- mod_db
- mod_directory
- mod_distributor
- mod_dptools
- mod_easyroute
- mod_enum
- mod_esf
- mod_esl
- mod_expr
- mod_fifo
- mod_fsk
- mod_fsv
- mod_hash
- mod_httapi
- mod_http_cache
- mod_ladspa
- mod_lcr
- mod_memcache
- mod_mongo
- mod_mp4
- mod_nibblebill
- mod_oreka
- mod_rad_auth
- mod_redis
- mod_rss
- mod_sms
- mod_snapshot
- mod_snom
- mod_soundtouch
- mod_spandsp
- mod_spy
- mod_stress
- mod_translate
- mod_valet_parking
- mod_vmd
- mod_voicemail
- mod_voicemail_ivr
- mod_random

### Speech Recognition / Text-to-Speech

- mod_flite
- mod_pocketsphinx
- mod_tts_commandline
- mod_unimrcp

### Codecs

- mod_amr
- mod_amrwb
- mod_bv
- mod_b64
- mod_celt
- mod_codec2
- mod_dahdi_codec
- mod_g723_1
- mod_g729
- mod_h26x
- mod_vp8
- mod_ilbc
- mod_isac
- mod_mp4v
- mod_opus
- mod_silk
- mod_siren
- mod_speex
- mod_theora

### Dialplan

- mod_dialplan_asterisk
- mod_dialplan_directory
- mod_dialplan_xml

### Directories

- mod_ldap

### Endpoints

- mod_alsa
- mod_dingaling
- mod_loopback
- mod_portaudio
- mod_rtmp
- mod_skinny
- mod_skypopen
- mod_sofia

### Event Handlers

- mod_cdr_csv
- mod_cdr_mongodb
- mod_cdr_pg_csv
- mod_cdr_sqlite
- mod_erlang_event
- mod_event_multicast
- mod_event_socket
- mod_event_zmq
- mod_json_cdr
- mod_radius_cdr
- mod_rayo
- mod_snmp

### File Formats

- mod_local_stream
- mod_native_file
- mod_portaudio_stream
- mod_shell_stream
- mod_shout
- mod_sndfile
- mod_ssml
- mod_tone_stream
- mod_vlc

### Languages

- mod_lua
- mod_perl
- mod_python
- mod_yaml
- mod_v8

### Loggers

- mod_console
- mod_logfile
- mod_syslog

### Language-Specific

- mod_say_de
- mod_say_en
- mod_say_es
- mod_say_fa
- mod_say_fr
- mod_say_he
- mod_say_hr
- mod_say_hu
- mod_say_it
- mod_say_ja
- mod_say_nl
- mod_say_pl
- mod_say_pt
- mod_say_ru
- mod_say_th
- mod_say_zh

### External API's

- mod_xml_cdr
- mod_xml_curl
- mod_xml_ldap
- mod_xml_radius
- mod_xml_rpc
- mod_xml_scgi