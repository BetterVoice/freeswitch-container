FreeSWITCH Dockerfile
=====================

[![Docker Stars](https://img.shields.io/docker/stars/bettervoice/freeswitch-container.svg)](https://hub.docker.com/r/bettervoice/freeswitch-container/)
[![Docker Pulls](https://img.shields.io/docker/pulls/bettervoice/freeswitch-container.svg)](https://hub.docker.com/r/bettervoice/freeswitch-container/)
[![Docker Automated build](https://img.shields.io/docker/automated/bettervoice/freeswitch-container.svg)](https://hub.docker.com/r/bettervoice/freeswitch-container/)

This project can be used to deploy a FreeSWITCH server inside a Docker container. The container currently uses the latest stable release version 1.6.x. An effort was made to build many modules so the container can be generic enough to serve many purposes.

The container now includes fail2ban but in order for fail2ban to update the rules in IPTables it must be run with the `--privileged` flag.

The container exposes the following ports:
- 5060/tcp 5060/udp 5080/tcp 5080/udp as SIP Signaling ports.
- 5066/tcp 7443/tcp as WebSocket Signaling ports.
- 8021/tcp as Event Socket port.
- 64535-65535/udp as media ports.

## Running the Container

```CID=$(sudo docker run --name freeswitch -p 5060:5060/tcp -p 5060:5060/udp -p 5080:5080/tcp -p 5080:5080/udp -p 8021:8021/tcp -p 7443:7443/tcp -p 60535-65535:60535-65535/udp -v /home/ubuntu/freeswitch/conf:/usr/local/freeswitch/conf bettervoice/freeswitch-container:1.6.6)```

*Keep in mind that freeswitch has to be able to read the mounted volume.*

### Large port range issue

Because of an [issue](https://github.com/docker/docker/issues/11185) in docker, mapping a large port range like in `-p 60535-65535:60535-65535/udp` can eat a lot of memory. Starting docker with `--userland-proxy=false` solves this partially, but startup will still be slow. As a workaround you can remove this from the docker commandline and manually add the `iptables` rules instead:

    CIP=$(sudo docker inspect --format='{{.NetworkSettings.IPAddress}}' $CID)

    sudo iptables -A DOCKER -t nat -p udp -m udp ! -i docker0 --dport 60535:65535 -j DNAT --to-destination $CIP:60535-65535
    sudo iptables -A DOCKER -p udp -m udp -d $CIP/32 ! -i docker0 -o docker0 --dport 60535:65535 -j ACCEPT
    sudo iptables -A POSTROUTING -t nat -p udp -m udp -s $CIP/32 -d $CIP/32 --dport 60535:65535 -j MASQUERADE

### Systemd configuration
Follow the following steps in order to run start this docker instance via systemctl.

*Customizations*
For customizing the startup settings look at the wiki documentation in GitHub
which deals with running docker as a service in systemd.

```
sudo cp sysv/systemd/docker.freeswitch.service /lib/systemd/system/
sudo systemctl daemon-reload
sudo cp sysv/docker.freeswitch.py /usr/local/bin/

# Enable the service
sudo systemctl enable docker.freeswitch
# Start the service
sudo systemctl start docker.freeswitch
# Stop the service
sudo systemctl stop docker.freeswitch
```

### Configuration

Make sure you properly set `rtp-start-port` and `rtp-end-port` in `autoload_configs/switch.conf.xml`. Also you need to set `ext-rtp-ip` and `ext-sip-ip` for every profile which is accessible from your public ip address. See the freeswitch documentation for further instructions.

### Shell access
```
sudo docker exec -it freeswitch /bin/bash
```

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
- `mod_dahdi_codec` - DAHDI Codecs (G729A 8.0kbit, G723.1 5.3kbit).
- `mod_g723_1`: G.723.1 codec.
- `mod_g729`: G.729 codec.
- `mod_h26x`: H26X signed linear codec.
- `mod_ilbc`: ILBC codec.
- `mod_isac`: Internet Speech Audio Codec open sourced by Google, used in WebRTC
- `mod_mp4v`: MPEG4 video codec
- `mod_opus`: The OPUS ultra-low delay audio codec (http://opus-codec.org/)
- `mod_siren`: G.722.1 (Siren7) and G.722.1 Annex C (Siren14) Polycom codecs.
- `mod_speex`: Speex codec.
- `mod_theora`: Theora video codec
- `mod_voipcodecs`: VoIP Codecs (G.711, G.722, G.726, GSM-FR, IMA_ADPCM, LPC10)
- `mod_vp8`: VP8 video codec

### Dialplan

- `mod_dialplan_asterisk`: Allows you to create dialplans the old-fashioned way.
- `mod_dialplan_directory`: Allows you to obtain a dialplan from a directory resource
- `mod_dialplan_xml`: Allows you to program dialplans in XML format.
- `mod_yaml`: Allows you to program dialplans in YAML format.

### Directories

- `mod_ldap`: LDAP module made to obtain dialplans, user accounts, etc.

### Endpoints

- `mod_alsa`: Sound card endpoint.
- `mod_dingaling`: Jabber/Google Talk integration module; note XMPP access to Google Voice ended 2014.05.15
- `mod_loopback`: Loopback endpoint module - A loopback channel driver to make an outbound call as an inbound call.
- `mod_portaudio`: Voice through a local soundcard.
- `mod_rtmp`: "Real time media protocol" endpoint for FreeSWITCH.
- `mod_skinny`: SCCP module
- `mod_skypopen`: Skype compatible module.
- `mod_sofia`: SIP module.

### Event Handlers

- `mod_cdr_csv`: CSV call detail record handler.
- `mod_cdr_mongodb`: MongoDB CDR module
- `mod_cdr_pg_csv`: Asterisk Compatible CDR Module with PostgreSQL interface
- `mod_cdr_sqlite`: SQLite CDR Module
- `mod_erlang_event`: Module to send/receive events/commands in Erlang's binary format.
- `mod_event_multicast`: Broadcasts events to netmask.
- `mod_event_socket`: Sends events via a single socket.
- `mod_event_zmq`: http://www.zeromq.org/
- `mod_json_cdr`: JSON CDR Module to files or curl
- `mod_radius_cdr`: RADIUS CDR Module.
- `mod_rayo`: 3PCC over XMPP - http://rayo.org/xep
- `mod_snmp`: SNMP AgentX module
- `mod_xml_cdr` - XML-based call detail record handler.

### File Formats

- `mod_local_stream`: Multiple channels connected to same looped file stream.
- `mod_native_file`: File interface for codec specific file formats.
- `mod_portaudio_stream`: Stream from an external audio source for Music on Hold
- `mod_shell_stream`: Stream audio from an arbitrary shell command. Read audio from a database, from a soundcard, etc.
- `mod_shout`: MP3 files and shoutcast streams.
- `mod_sndfile`: Multi-format file format transcoder (WAV, etc)
- `mod_ssml`: Speech Synthesis Markup Language parser
- `mod_tone_stream`: Tone Generation Stream.
- `mod_vlc`: Stream audio from VLC media player using libvlc.

### Languages

- `mod_lua` - Lua support.
- `mod_perl` - Perl support.
- `mod_python` - Python Support.
- `mod_v8` - Google V8 JavaScript (ECMAScript) engine.

### Loggers

- `mod_console` - Console logger.
- `mod_logfile` - File logger.
- `mod_syslog` - Syslog logger.

### Language-Specific

- `mod_say_de` - German language text-to-speech engine
- `mod_say_en` - English language text-to-speech engine
- `mod_say_es` - Spanish language text-to-speech engine
- `mod_say_fa` - Persian language text-to-speech engine
- `mod_say_fr` - French language text-to-speech engine
- `mod_say_he` - Hebrew language text-to-speech engine
- `mod_say_hr` - Croatian language text-to-speech engine
- `mod_say_hu` - Hungarian language text-to-speech engine
- `mod_say_it` - Italian language text-to-speech engine
- `mod_say_ja` - Japanese language text-to-speech engine
- `mod_say_nl` - Dutch language text-to-speech engine
- `mod_say_pl` - Polish language text-to-speech engine
- `mod_say_pt` - Portuguese language text-to-speech engine
- `mod_say_ru` - Russian language text-to-speech engine
- `mod_say_th` - Thai language text-to-speech engine
- `mod_say_zh` - Chinese, Mandarin, Cantonese language text-to-speech engine

### External API's

- `mod_xml_curl` - XML Gateway Code. Configure FreeSWITCH™ from a web server on boot and on the fly.
- `mod_xml_ldap` - LDAP XML Gateway.
- `mod_xml_radius` - RADIUS authentication gateway.
- `mod_xml_rpc` - XML Remote Procedure Calls. Issue commands from your web application.
- `mod_xml_scgi` - Simple Common Gateway Interface.
