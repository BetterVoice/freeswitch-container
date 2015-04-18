FreeSWITCH Dockerfile
=====================

This project can be used to deploy a FreeSWITCH server inside a Docker container. The container currently uses the latest stable release version 1.4.18. An effort was made to build many modules so the container can be generic enough to serve many purposes.

## Running the Container

``` sudo docker ```

## Available Modules

The following modules are available in the container and can be loaded at runtime by providing a `modules.conf.xml` file with the desired module names uncommented.

### Applications

- `mod_avmd`: Detects voicemail beeps using a generalized approach.
- `mod_blacklist`: Blacklist module.
- `mod_callcenter`: Call queuing application that can be used for call center needs.
- `mod_cidlookup`: Provides a means (database, url) to lookup the callerid name from a number.
- `mod_commands`: A mass plethora of API interface commands.
- `mod_conference`: Conference room module.
- `mod_curl`: Allows scripts to make HTTP requests as receive responses as plain text or JSON.
- `mod_db`: Database key/value store functionality, group dialing, and limit backend.
- `mod_directory`: Dial by Name directory.
- `mod_distributor`: Simple round-robin style distributions.
- `mod_dptools`: Dialplan Tools: provides a number of apps and utilities for the dialplan.
- `mod_easyroute`: A simple DID routing engine that uses a database lookup to determine how to route an incoming call.
- `mod_enum`: Route PSTN numbers over internet according to ENUM servers, such as e164.org
- `mod_esf`: Holds the multi cast paging application for SIP.
- `mod_esl`: Allows to generate remote ESL commands.
- `mod_expr`: Brian Allen Vanderburg's expression evaluation library.
- `mod_fifo`: FIFO module.
- `mod_fsk`: FSK (Frequency-Shift Keying) data transfer
- `mod_fsv`: FreeSWITCH Video application (Recording and playback)
- `mod_hash`: Hashtable key/value store functionality and limit backend
- `mod_httapi`: HT-TAPI Hypertext Telephony API (Twilio FreeSWITCH style)
- `mod_http_cache`: HTTP GET with caching.
- `mod_ladspa`: use Auto-tune on your call.
- `mod_lcr`: Implements LCR (Least Cost Routing)
- `mod_memcache`: API that integrates with memcached (a distributed key/value object store)
- `mod_mongo`: http://www.mongodb.org/
- `mod_mp4`: MP4 File Format support for video apps.
- `mod_nibblebill`: Billing module ("nibbles" at credit/cash amounts during calls)
- `mod_oreka`: Module for Media Recording with Oreka
- `mod_rad_auth`: use RADIUS for authentication
- `mod_redis`: supplies a limit back-end that uses Redis.
- `mod_rss`: Reads RSS feeds via a TTS engine.
- `mod_sms`: Apps for chat messages
- `mod_snapshot`: Records a sliding window of audio and can take snapshots to disk.
- `mod_snom`: Controlling softkeys on Snom phones (button function, led state, label etc.)
- `mod_soundtouch`: Modify the pitch of the audio and other sound effects.
- `mod_spandsp`: Spandsp tone and DTMF detectors. A combination of mod_fax and mod_voipcodecs and mod_t38gateway.
- `mod_spy`: User spy module.
- `mod_stress`: Module for detecting voice stress.
- `mod_tone_detect`: Tone detection module.
- `mod_translate`: Format numbers into a specified format.
- `mod_valet_parking`: Allows calls to be parked and picked up easily.
- `mod_vmd`: Voicemail beep detection module.
- `mod_voicemail`: Full-featured voicemail module.
- `mod_voicemail_ivr`: VoiceMail IVR Interface.
- `mod_xml_odbc`: Allows user directory to be accessed from a database in realtime.

### Speech Recognition / Text-to-Speech
- `mod_flite` - Free open source Text to Speech.
- `mod_pocketsphinx` - Free open source Speech Recognition.
- `mod_tts_commandline` - Run a command line and play the outputted file.
- `mod_unimrcp` - Module for an open MRCP implementation

### Codecs

- `mod_amr`: GSM-AMR (Adaptive Multi-Rate) codec.
- `mod_amrwb`: GSM-AMRWB (ARM Wide Band) codec.
- `mod_bv`: BroadVoice16 and BroadVoice32 audio codecs (Broadcom codecs).
- `mod_celt`: CELT ultra-low delay audio codec.
- `mod_codec2`: FreeSWITCH CODEC2 Module.
- 'mod_dahdi_codec' - DAHDI Codecs (G729A 8.0kbit, G723.1 5.3kbit).
- `mod_g723_1`: G.723.1 codec.
- `mod_g729`: G.729 codec.
- `mod_h26x`: H26X signed linear codec.
- `mod_ilbc`: ILBC codec.
- `mod_isac`: Internet Speech Audio Codec open sourced by Google, used in WebRTC
- `mod_mp4v`: MPEG4 video codec
- `mod_opus`: The OPUS ultra-low delay audio codec (http://opus-codec.org/)
- `mod_silk`: Skype's SILK codec.
- `mod_siren`: G.722.1 (Siren7) and G.722.1 Annex C (Siren14) Polycom codecs.
- `mod_speex`: Speex codec.
- `mod_theora`: Theora video codec
- `mod_voipcodecs`: VoIP Codecs (G.711, G.722, G.726, GSM-FR, IMA_ADPCM, LPC10)
- `mod_vp8`: VP8 video codec

### Dialplan

- `mod_dialplan_asterisk` - Allows you to create dialplans the old-fashioned way.
- `mod_dialplan_directory` - Allows you to obtain a dialplan from a directory resource (see directories below)
- `mod_dialplan_xml` - Allows you to program dialplans in XML format.
- `mod_yaml` - Allows you to program dialplans in YAML format.

### Directories

- `mod_ldap` - LDAP module made to obtain dialplans, user accounts, etc.

### Endpoints

- `mod_alsa` - Sound card endpoint.
- `mod_dingaling` - Jabber/Google Talk integration module; note XMPP access to Google Voice ended 2014.05.15
- `mod_loopback` - Loopback endpoint module - A loopback channel driver to make an outbound call as an inbound call.
- `mod_portaudio` - Voice through a local soundcard.
- `mod_rtmp` - "Real time media protocol" endpoint for FreeSWITCH.
- `mod_skinny` - SCCP module
- `mod_skypopen` - Skype compatible module.
- `mod_sofia` - SIP module.

### Event Handlers

- `mod_cdr_csv` - CSV call detail record handler.
- `mod_cdr_mongodb` - MongoDB CDR module
- `mod_cdr_pg_csv` - Asterisk Compatible CDR Module with PostgreSQL interface
- `mod_cdr_sqlite` - SQLite CDR Module
- `mod_erlang_event` - Module to send/receive events/commands in Erlang's binary format.
- `mod_event_multicast` - Broadcasts events to netmask.
- `mod_event socket` - Sends events via a single socket.
- `mod_event_zmq` - http://www.zeromq.org/
- `mod_json_cdr` - JSON CDR Module to files or curl
- `mod_radius_cdr` - RADIUS CDR Module.
- `mod_rayo` - 3PCC over XMPP - http://rayo.org/xep
- `mod_snmp` - SNMP AgentX module

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