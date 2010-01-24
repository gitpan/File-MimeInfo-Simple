package File::MimeInfo::Simple;

use strict;
use warnings;

use Carp;
use YAML::Syck;
use File::Slurp;

require Exporter;

our $VERSION = '0.7';
our @ISA = qw(Exporter);
our @EXPORT = qw(mimetype);

my $lines = read_file(\*DATA);
my $yaml = Load($lines);

sub mimetype {
	my ($filename) = shift;
	
	croak "No filename passed to mimetype()" unless $filename;
	croak "Unable to read file: $filename" if -d $filename or ! -r $filename;
	
	my $mimetype = q{}; #until proven otherwise!
	# if platform -> windows
	if($^O =~ m!MSWin32!i) {
		return _find_mimetype_by_table($filename);
	} else {
    	$mimetype = `file --mime -br $filename`;
		unless($mimetype) {
			return _find_mimetype_by_table($filename);
		}
	}
		
	chomp $mimetype;
	
	$mimetype =~ s/[;,\s]+.*$//;
	return $mimetype;
}

sub _find_mimetype_by_table {
	my($filename) = shift;
	my $mimetype = q{};
	# getting extension. this is SIMPLE implementation, isn't it? :)
	my($ext) = $filename =~ /.+\.(.+?)$/;
	# my $ext = pop @{[split /\./, $filename]};
	return $mimetype unless $ext;
	return $yaml->{lc $ext} if(exists $yaml->{lc $ext});
	return $mimetype;
}

1;

=head1 NAME

File::MimeInfo::Simple - Simple implementation to determine file type

=head1 USAGE

 use File::MimeInfo::Simple;
 say mimetype("/Users/damog/vatos_rudos.jpg"); # prints out 'image/jpeg'
 say mimetype("C:\perl\foo.pl") # prints out 'application/x-perl'

=head1 DESCRIPTION

C<File::MimeInfo::Simple> is a much simpler implementation and uses a much
simpler approach than C<File::MimeInfo>, using the 'file' command on a
UNIX-based operating system. Windows uses a key-value list for extensions. It's
inspired on Matt Aimonetti's mimetype-fu used on Ruby and the Rails world.

=head1 FUNCTIONS

=head2 mimetype( $filename )

C<mimetype> is exported by default. It receives a parameter, the file
path. It returns an string containing the mime type for the file.

=head1 AUTHOR

David Moreno &lt;david@axiombox.com&gt;.

=head1 LICENSE

Copyright 2009 David Moreno.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

__DATA__
\"123\": application/vnd.lotus-1-2-3
\"602\": application/x-t602
\"669\": audio/x-mod
3ds: image/x-3ds
3g2: video/3gpp2
3gp: video/3gpp
3gpp: video/3gpp
7z: application/x-7z-compressed
a: application/x-archive
aac: audio/mp4
abw: application/x-abiword
ac3: audio/ac3
ace: application/x-ace
acutc: application/vnd.acucorp
adb: text/x-adasrc
ads: text/x-adasrc
afm: application/x-font-afm
ag: image/x-applix-graphics
ai: application/illustrator
aif: audio/x-aiff
aifc: audio/x-aiff
aiff: audio/x-aiff
al: application/x-perl
ami: application/vnd.amiga.ami
amr: audio/AMR
ani: application/octet-stream
ape: audio/x-ape
arj: application/x-arj
arw: image/x-sony-arw
as: application/x-applix-spreadsheet
asc: application/pgp-encrypted
asf: video/x-ms-asf
asp: application/x-asp
ass: text/x-ssa
asx: audio/x-ms-asx
atc: application/vnd.acucorp
atom: application/atom+xml
au: audio/basic
avi: video/x-msvideo
aw: application/x-applix-word
awb: audio/AMR-WB
bak: application/x-trash
bcpio: application/x-bcpio
bdf: application/x-font-bdf
bib: text/x-bibtex
bin: application/x-mac
bkm: application/vnd.nervana
blend: application/x-blender
blender: application/x-blender
bmp: image/bmp
bpd: application/vnd.hbci
builder: application/x-ruby
bz: application/x-bzip
bz2: application/x-bzip
c: text/x-csrc
c++: text/x-c++src
cab: application/vnd.ms-cab-compressed
cbr: application/x-cbr
cbz: application/x-cbz
cc: text/x-c++src
ccc: text/vnd.net2phone.commcenter.command
cdf: application/x-netcdf
cdr: application/vnd.corel-draw
cdy: application/vnd.cinderella
cer: application/x-x509-ca-cert
cert: application/x-x509-ca-cert
cgi: application/x-cgi
cgm: image/cgm
chm: application/x-chm
chrt: application/x-kchart
chrt: application/vnd.kde.kchart
cil: application/vnd.ms-artgalry
class: application/x-java
cls: text/x-tex
cmc: application/vnd.cosmocaller
cpio: application/x-cpio
cpp: text/x-c++src
cr2: image/x-canon-cr2
crl: application/pkix-crl
crt: application/x-x509-ca-cert
crw: image/x-canon-crw
cs: text/x-csharp
csh: application/x-csh
css: text/css
cssl: text/css
csv: text/csv
cue: application/x-cue
cur: image/x-win-bitmap
curl: application/vnd.curl
cw: application/prs.cww
cww: application/prs.cww
cxx: text/x-c++src
d: text/x-dsrc
dar: application/x-dar
dat: text/plain
dbf: application/x-dbf
dc: application/x-dc-rom
dcl: text/x-dcl
dcm: application/dicom
dcr: image/x-kodak-dcr
dds: image/x-dds
deb: application/x-deb
der: application/x-x509-ca-cert
desktop: application/x-desktop
dfac: application/vnd.dreamfactory
dgn: image/x-vnd.dgn
dia: application/x-dia-diagram
diff: text/x-patch
divx: video/x-msvideo
djv: image/vnd.djvu
djvu: image/vnd.djvu
dl: video/dl
dms: application/octet-stream
dng: image/x-adobe-dng
doc: application/msword
docx: application/msword
docbook: application/docbook+xml
dot: application/msword
dsl: text/x-dsl
dtd: text/x-dtd
dtx: text/x-tex
dv: video/dv
dvi: application/x-dvi
dwf: x-drawing/dwf
dwg: image/vnd.dwg
dxf: image/vnd.dxf
ecelp4800: audio/vnd.nuera.ecelp4800
ecelp7470: audio/vnd.nuera.ecelp7470
ecelp9600: audio/vnd.nuera.ecelp9600
efif: application/vnd.picsel
egon: application/x-egon
el: text/x-emacs-lisp
emf: image/x-emf
emm: application/vnd.ibm.electronic-media
emp: application/vnd.emusic-emusic_package
ent: application/vnd.nervana
entity: application/vnd.nervana
eol: audio/vnd.digital-winds
eps: image/x-eps
epsf: image/x-eps
epsi: image/x-eps
erb: text/rhtml
erl: text/x-erlang
es: application/ecmascript
etheme: application/x-e-theme
etx: text/x-setext
evc: audio/EVRC
exe: application/x-executable
ez: application/andrew-inset
fig: image/x-xfig
fits: image/x-fits
flac: audio/x-flac
flc: video/x-flic
fli: video/x-flic
flo: application/vnd.micrografx.flo
flv: application/x-flash-video
flw: application/x-kivio
fo: text/x-xslfo
for: text/x-fortran
fsc: application/vnd.fsc.weblaunch
g3: image/fax-g3
gb: application/x-gameboy-rom
gba: application/x-gba-rom
gcrd: text/directory
ged: application/x-gedcom
gedcom: application/x-gedcom
gen: application/x-genesis-rom
gf: application/x-tex-gf
gg: application/x-sms-rom
gif: image/gif
gif: image/gif
gl: video/gl
glade: application/x-glade
gmo: application/x-gettext-translation
gnc: application/x-gnucash
gnucash: application/x-gnucash
gnumeric: application/x-gnumeric
gnuplot: application/x-gnuplot
gp: application/x-gnuplot
gpg: application/pgp-encrypted
gplt: application/x-gnuplot
gra: application/x-graphite
gsf: application/x-font-type1
gtar: application/x-tar
gvp: text/x-google-video-pointer
gz: application/x-gzip
h: text/x-chdr
h++: text/x-c++hdr
hbc: application/vnd.hbci
hbci: application/vnd.hbci
hdf: application/x-hdf
hh: text/x-c++hdr
hh: text/plain
hlp: text/plain
hp: text/x-c++hdr
hpgl: application/vnd.hp-hpgl
hpp: text/x-c++hdr
hqx: application/mac-binhex40
hs: text/x-haskell
htc: text/x-component
htke: application/vnd.kenameaapp
htm: text/html
html: text/html
htmlx: text/html
htx: text/html
hvd: application/vnd.yamaha.hv-dic
hvp: application/vnd.yamaha.hv-voice
hvs: application/vnd.yamaha.hv-script
hwp: application/x-hwp
hwt: application/x-hwt
hxx: text/x-c++hdr
ica: application/x-ica
icb: image/x-tga
ice: x-conference/x-cooltalk
icns: image/x-icns
ico: image/x-ico
ics: text/calendar
idl: text/x-idl
ief: image/ief
iff: image/x-iff
iges: model/iges
igs: model/iges
igx: application/vnd.micrografx.igx
ilbm: image/x-ilbm
ins: text/x-tex
irm: application/vnd.ibm.rights-management
irp: application/vnd.irepository.package+xml
iso: application/x-cd-image
iso9660: application/x-cd-image
it: audio/x-it
j2k: image/jp2
jad: text/vnd.sun.j2me.app-descriptor
jar: application/x-java-archive
java: text/x-java
jisp: application/vnd.jisp
jng: image/x-jng
jnlp: application/x-java-jnlp-file
jp2: image/jp2
jpc: image/jp2
jpe: image/jpeg
jpeg: image/jpeg
jpf: image/jp2
jpg: image/jpeg
jpm: image/jpm
jpr: application/x-jbuilder-project
jpx: image/jpx
js: application/javascript
k25: image/x-kodak-k25
kar: audio/midi
karbon: application/x-karbon
kcm: application/vnd.nervana
kdc: image/x-kodak-kdc
kdelnk: application/x-desktop
kfo: application/x-kformula
kia: application/vnd.kidspiration
kil: application/x-killustrator
kino: application/smil
kne: application/vnd.Kinar
knp: application/vnd.Kinar
kom: application/vnd.hbci
kon: application/x-kontour
kon: application/vnd.kde.kontour
kpm: application/x-kpovmodeler
kpr: application/x-kpresenter
kpt: application/x-kpresenter
kra: application/x-krita
ksp: application/x-kspread
kud: application/x-kugar
kwd: application/x-kword
kwt: application/x-kword
l16: audio/L16
la: application/x-shared-library-la
latex: text/x-tex
lbd: application/vnd.llamagraphics.life-balance.desktop
lbe: application/vnd.llamagraphics.life-balance.exchange+xml
ldif: text/x-ldif
les: application/vnd.hhe.lesson-player
lha: application/x-lha
lhs: text/x-literate-haskell
lhz: application/x-lhz
log: text/x-log
lrm: application/vnd.ms-lrm
ltx: text/x-tex
lua: text/x-lua
lvp: audio/vnd.lucent.voice
lwo: image/x-lwo
lwob: image/x-lwo
lws: image/x-lws
lyx: application/x-lyx
lzh: application/x-lha
lzo: application/x-lzop
m: text/x-objcsrc
m15: audio/x-mod
m2t: video/mpeg
m3u: audio/x-mpegurl
m4: application/x-m4
m4a: audio/mp4
m4b: audio/x-m4b
m4u: video/vnd.mpegurl
m4v: video/mp4
mab: application/x-markaby
man: application/x-troff-man
mcd: application/vnd.mcd
md: application/x-genesis-rom
mdb: application/vnd.ms-access
mdi: image/vnd.ms-modi
me: text/x-troff-me
me: application/x-troff-me
mesh: model/mesh
mfm: application/vnd.mfmp
mgp: application/x-magicpoint
mid: audio/midi
midi: audio/midi
mif: application/x-mif
minipsf: audio/x-minipsf
mj2: video/MJ2
mjp2: video/MJ2
mka: audio/x-matroska
mkv: video/x-matroska
ml: text/x-ocaml
mli: text/x-ocaml
mm: text/x-troff-mm
mmf: application/vnd.smaf
mml: text/mathml
mng: video/x-mng
mo: application/x-gettext-translation
moc: text/x-moc
mod: audio/x-mod
moov: video/quicktime
mov: video/quicktime
movie: video/x-sgi-movie
\"mp+\": audio/x-musepack
mp2: audio/mp2
mp2: video/mpeg
mp3: audio/mpeg
mp3g: video/mpeg
mp4: video/mp4
mpc: audio/x-musepack
mpe: video/mpeg
mpeg: video/mpeg
mpg: video/mpeg
mpga: audio/mpeg
mpm: application/vnd.blueice.multipass
mpn: application/vnd.mophun.application
mpp: application/vnd.ms-project
mrw: image/x-minolta-mrw
ms: text/x-troff-ms
mseq: application/vnd.mseq
msh: model/mesh
msod: image/x-msod
msx: application/x-msx-rom
mtm: audio/x-mod
mup: text/x-mup
mxmf: audio/vnd.nokia.mobile-xmf
mxu: video/vnd.mpegurl
n64: application/x-n64-rom
nb: application/mathematica
nc: application/x-netcdf
nds: application/x-nintendo-ds-rom
nef: image/x-nikon-nef
nes: application/x-nes-rom
nfo: text/x-readme
nim: video/vnd.nokia.interleaved-multimedia
not: text/x-mup
nsc: application/x-netshow-channel
nsv: video/x-nsv
o: application/x-object
obj: application/x-tgif
ocl: text/x-ocl
oda: application/oda
odb: application/vnd.oasis.opendocument.database
odc: application/vnd.oasis.opendocument.chart
odf: application/vnd.oasis.opendocument.formula
odg: application/vnd.oasis.opendocument.graphics
odi: application/vnd.oasis.opendocument.image
odm: application/vnd.oasis.opendocument.text-master
odp: application/vnd.oasis.opendocument.presentation
ods: application/vnd.oasis.opendocument.spreadsheet
odt: application/vnd.oasis.opendocument.text
oga: audio/ogg
ogg: application/ogg
ogm: video/x-ogm+ogg
ogv: video/ogg
ogx: application/ogg
old: application/x-trash
oleo: application/x-oleo
opml: text/x-opml+xml
oprc: application/vnd.palm
orf: image/x-olympus-orf
otg: application/vnd.oasis.opendocument.graphics-template
oth: application/vnd.oasis.opendocument.text-web
otp: application/vnd.oasis.opendocument.presentation-template
ots: application/vnd.oasis.opendocument.spreadsheet-template
ott: application/vnd.oasis.opendocument.text-template
owl: text/rdf
p: text/x-pascal
p10: application/pkcs10
p12: application/x-pkcs12
p7c: application/pkcs7-mime
p7m: application/pkcs7-mime
p7s: application/pkcs7-signature
pak: application/x-pak
par2: application/x-par2
pas: text/x-pascal
patch: text/x-patch
pbm: image/x-portable-bitmap
pcd: image/x-photo-cd
pcf: application/x-font-pcf
pcl: application/vnd.hp-pcl
pdb: application/x-palm-database
pdf: application/pdf
pef: image/x-pentax-pef
pem: application/x-x509-ca-cert
perl: application/x-perl
pfa: application/x-font-type1
pfb: application/x-font-type1
pfr: application/font-tdpfr
pfx: application/x-pkcs12
pgb: image/vnd.globalgraphics.pgb
pgm: image/x-portable-graymap
pgn: application/x-chess-pgn
pgp: application/pgp-encrypted
php: application/x-php
php3: application/x-php
php4: application/x-php
pict: image/x-pict
pict1: image/x-pict
pict2: image/x-pict
pk: application/x-tex-pk
pkd: application/vnd.hbci
pki: application/pkixcmp
pkipath: application/pkix-pkipath
pkr: application/pgp-keys
pl: application/x-perl
pla: audio/x-iriver-pla
plb: application/vnd.3gpp.pic-bw-large
plj: audio/vnd.everad.plj
pln: application/x-planperfect
pls: audio/x-scpls
plt: application/vnd.hp-HPGL
pm: application/x-perl
png: image/png
pnm: image/x-portable-anymap
pntg: image/x-macpaint
po: text/x-gettext-translation
pot: application/vnd.ms-powerpoint
ppm: image/x-portable-pixmap
pps: application/vnd.ms-powerpoint
ppt: application/vnd.ms-powerpoint
pptx: application/vnd.ms-powerpoint
ppz: application/vnd.ms-powerpoint
pqa: application/vnd.palm
prc: application/x-palm-database
ps: application/postscript
psb: application/vnd.3gpp.pic-bw-small
psd: image/x-psd
psf: application/x-font-linux-psf
psf: audio/x-psf
psflib: audio/x-psflib
psid: audio/prs.sid
psp: image/x-paintshoppro
pspimage: image/x-paintshoppro
pti: application/vnd.pvi.ptid1
ptid: application/vnd.pvi.ptid1
pvb: application/vnd.3gpp.pic-bw-var
pw: application/x-pw
py: text/x-python
pyc: application/x-python-bytecode
pyo: application/x-python-bytecode
qcp: audio/QCELP
qif: image/x-quicktime
qt: video/quicktime
qtif: image/x-quicktime
qtl: application/x-quicktime-media-link
qtvr: video/quicktime
qwd: application/vnd.Quark.QuarkXPress
qwt: application/vnd.Quark.QuarkXPress
qxb: application/vnd.Quark.QuarkXPress
qxd: application/vnd.Quark.QuarkXPress
qxl: application/vnd.Quark.QuarkXPress
qxt: application/vnd.Quark.QuarkXPress
ra: audio/vnd.rn-realaudio
raf: image/x-fuji-raf
ram: audio/x-pn-realaudio
rar: application/x-rar
ras: image/x-cmu-raster
raw: image/x-panasonic-raw
rax: audio/vnd.rn-realaudio
rb: application/x-ruby
rcprofile: application/vnd.ipunplugged.rcprofile
rct: application/prs.nprend
rdf: text/rdf
rdfs: text/rdf
rdz: application/vnd.data-vision.rdz
rej: application/x-reject
req: application/vnd.nervana
request: application/vnd.nervana
rgb: image/x-rgb
rhtml: text/rhtml
rle: image/rle
rm: application/vnd.rn-realmedia
rmj: application/vnd.rn-realmedia
rmm: application/vnd.rn-realmedia
rms: application/vnd.rn-realmedia
rmvb: application/vnd.rn-realmedia
rmx: application/vnd.rn-realmedia
rnd: application/prs.nprend
roff: text/troff
rp: image/vnd.rn-realpix
rpm: application/x-rpm
rpss: application/vnd.nokia.radio-presets
rpst: application/vnd.nokia.radio-preset
rss: application/rss+xml
rst: text/prs.fallenstein.rst
rt: text/vnd.rn-realtext
rtf: application/rtf
rtx: text/richtext
rxml: application/x-ruby
rv: video/vnd.rn-realvideo
rvx: video/vnd.rn-realvideo
s11: video/vnd.sealed.mpeg1
s14: video/vnd.sealed.mpeg4
s1a: application/vnd.sealedmedia.softseal.pdf
s1e: application/vnd.sealed.xls
s1g: image/vnd.sealedmedia.softseal.gif
s1h: application/vnd.sealedmedia.softseal.html
s1j: image/vnd.sealedmedia.softseal.jpg
s1m: audio/vnd.sealedmedia.softseal.mpeg
s1n: image/vnd.sealed.png
s1p: application/vnd.sealed.ppt
s1q: video/vnd.sealedmedia.softseal.mov
s1w: application/vnd.sealed.doc
s3m: audio/x-s3m
saf: application/vnd.yamaha.smaf-audio
sam: application/x-amipro
sami: application/x-sami
sc: application/vnd.ibm.secure-container
scm: text/x-scheme
sda: application/vnd.stardivision.draw
sdc: application/vnd.stardivision.calc
sdd: application/vnd.stardivision.impress
sdf: application/vnd.Kinar
sdo: application/vnd.sealed.doc
sdoc: application/vnd.sealed.doc
sdp: application/vnd.stardivision.impress
sds: application/vnd.stardivision.chart
sdw: application/vnd.stardivision.writer
see: application/vnd.seemail
sem: application/vnd.sealed.eml
seml: application/vnd.sealed.eml
ser: application/x-java-serialized-object
sgf: application/x-go-sgf
sgi: image/vnd.sealedmedia.softseal.gif
sgif: image/vnd.sealedmedia.softseal.gif
sgl: application/vnd.stardivision.writer
sgm: text/sgml
sgml: text/sgml
sh: application/x-shellscript
shar: application/x-shar
shn: application/x-shorten
shtml: text/html
si: text/vnd.wap.si
siag: application/x-siag
sic: application/vnd.wap.sic
sid: audio/prs.sid
sig: application/pgp-signature
sik: application/x-trash
silo: model/mesh
sis: application/vnd.symbian.install
sisx: x-epoc/x-sisx-app
sit: application/stuffit
siv: application/sieve
sjp: image/vnd.sealedmedia.softseal.jpg
sjpg: image/vnd.sealedmedia.softseal.jpg
skr: application/pgp-keys
sl: text/vnd.wap.sl
slc: application/vnd.wap.slc
slk: text/spreadsheet
smc: application/x-snes-rom
smd: application/vnd.stardivision.mail
smf: application/vnd.stardivision.math
smh: application/vnd.sealed.mht
smht: application/vnd.sealed.mht
smi: application/smil
smil: application/smil
sml: application/smil
smo: video/vnd.sealedmedia.softseal.mov
smov: video/vnd.sealedmedia.softseal.mov
smp: audio/vnd.sealedmedia.softseal.mpeg
smp3: audio/vnd.sealedmedia.softseal.mpeg
smpg: video/vnd.sealed.mpeg4
sms: application/vnd.3gpp.sms
smv: audio/SMV
snd: audio/basic
so: application/x-sharedlib
soc: application/sgml-open-catalog
spd: application/vnd.sealedmedia.softseal.pdf
spdf: application/vnd.sealedmedia.softseal.pdf
spec: text/x-rpm-spec
spf: application/vnd.yamaha.smaf-phrase
spl: application/x-shockwave-flash
spn: image/vnd.sealed.png
spng: image/vnd.sealed.png
spp: application/vnd.sealed.ppt
sppt: application/vnd.sealed.ppt
spx: audio/x-speex
sql: text/x-sql
sr2: image/x-sony-sr2
src: application/x-wais-source
srf: image/x-sony-srf
srt: application/x-subrip
ssa: text/x-ssa
ssw: video/vnd.sealed.swf
sswf: video/vnd.sealed.swf
stc: application/vnd.sun.xml.calc.template
std: application/vnd.sun.xml.draw.template
sti: application/vnd.sun.xml.impress.template
stk: application/hyperstudio
stm: application/vnd.sealedmedia.softseal.html
stml: application/vnd.sealedmedia.softseal.html
stw: application/vnd.sun.xml.writer.template
sty: text/x-tex
sub: text/x-mpsub
sun: image/x-sun-raster
sus: application/vnd.sus-calendar
susp: application/vnd.sus-calendar
sv4cpio: application/x-sv4cpio
sv4crc: application/x-sv4crc
svg: image/svg+xml
svgz: image/svg+xml-compressed
swf: application/x-shockwave-flash
sxc: application/vnd.sun.xml.calc
sxd: application/vnd.sun.xml.draw
sxg: application/vnd.sun.xml.writer.global
sxl: application/vnd.sealed.xls
sxls: application/vnd.sealed.xls
sxm: application/vnd.sun.xml.math
sxw: application/vnd.sun.xml.writer
sylk: text/spreadsheet
t: text/troff
t2t: text/x-txt2tags
tar: application/x-tar
tbz: application/x-bzip-compressed-tar
tbz2: application/x-bzip-compressed-tar
tcl: text/x-tcl
tex: text/x-tex
texi: text/x-texinfo
texinfo: text/x-texinfo
tga: image/x-tga
tgz: application/x-compressed-tar
theme: application/x-theme
tif: image/tiff
tiff: image/tiff
tk: text/x-tcl
tnef: application/vnd.ms-tnef
tnf: application/vnd.ms-tnef
torrent: application/x-bittorrent
tpic: image/x-tga
tr: text/troff
troff: text/troff
ts: application/x-linguist
tsv: text/tab-separated-values
tta: audio/x-tta
ttc: application/x-font-ttf
ttf: application/x-font-ttf
txd: application/vnd.genomatix.tuxedo
txt: text/plain
tzo: application/x-tzo
ufraw: application/x-ufraw
ui: application/x-designer
uil: text/x-uil
ult: audio/x-mod
uni: audio/x-mod
upa: application/vnd.hbci
url: text/x-uri
ustar: application/x-ustar
vala: text/x-vala
vbk: audio/vnd.nortel.vbk
vcf: text/x-vcard
vcs: text/x-vcalendar
vct: text/directory
vda: image/x-tga
vhd: text/x-vhdl
vhdl: text/x-vhdl
vis: application/vnd.visionary
viv: video/vivo
vivo: video/vivo
vlc: audio/x-mpegurl
vob: video/mpeg
voc: audio/x-voc
vor: application/vnd.stardivision.writer
vrml: x-world/x-vrml
vsc: application/vnd.vidsoft.vidconference
vsd: application/vnd.visio
vss: application/vnd.visio
vst: application/vnd.visio
vsw: application/vnd.visio
wav: audio/x-wav
wax: audio/x-ms-asx
wb1: application/x-quattropro
wb2: application/x-quattropro
wb3: application/x-quattropro
wbmp: image/vnd.wap.wbmp
wbs: application/vnd.criticaltools.wbs+xml
wbxml: application/vnd.wap.wbxml
wif: application/watcherinfo+xml
wk1: application/vnd.lotus-1-2-3
wk3: application/vnd.lotus-1-2-3
wk4: application/vnd.lotus-1-2-3
wks: application/vnd.lotus-1-2-3
wm: video/x-ms-wm
wma: audio/x-ms-wma
wmd: application/x-ms-wmd
wmf: image/x-wmf
wml: text/vnd.wap.wml
wmlc: application/vnd.wap.wmlc
wmls: text/vnd.wap.wmlscript
wmlsc: application/vnd.wap.wmlscriptc
wmv: video/x-ms-wmv
wmx: audio/x-ms-asx
wmz: application/x-ms-wmz
wp: application/vnd.wordperfect
wp4: application/vnd.wordperfect
wp5: application/vnd.wordperfect
wp6: application/vnd.wordperfect
wpd: application/vnd.wordperfect
wpg: application/x-wpg
wpl: application/vnd.ms-wpl
wpp: application/vnd.wordperfect
wqd: application/vnd.wqd
wri: application/x-mswrite
wrl: x-world/x-vrml
wtb: application/vnd.webturbo
wv: audio/x-wavpack
wvc: audio/x-wavpack-correction
wvp: audio/x-wavpack
wvx: audio/x-ms-asx
x_b: model/vnd.parasolid.transmit.binary
x_t: model/vnd.parasolid.transmit.text
x3f: image/x-sigma-x3f
xac: application/x-gnucash
xbel: application/x-xbel
xbl: application/xml
xbm: image/x-xbitmap
xcf: image/x-xcf
xfdf: application/vnd.adobe.xfdf
xhtml: application/xhtml+xml
xi: audio/x-xi
xla: application/vnd.ms-excel
xlc: application/vnd.ms-excel
xld: application/vnd.ms-excel
xlf: application/x-xliff
xliff: application/x-xliff
xll: application/vnd.ms-excel
xlm: application/vnd.ms-excel
xls: application/vnd.ms-excel
xlsx: application/vnd.ms-excel
xlt: application/vnd.ms-excel
xlw: application/vnd.ms-excel
xm: audio/x-xm
xmi: text/x-xmi
xml: text/xml
xmt_bin: model/vnd.parasolid.transmit.binary
xmt_txt: model/vnd.parasolid.transmit.text
xpm: image/x-xpixmap
xps: application/vnd.ms-xpsdocument
xsl: application/xml
xslfo: text/x-xslfo
xslt: application/xml
xspf: application/xspf+xml
xul: application/vnd.mozilla.xul+xml
xwd: image/x-xwindowdump
xyz: x-chemical/x-xyz
yaml: text/x-yaml
yml: text/x-yaml
z: application/x-compressed
zabw: application/x-abiword
zip: application/zip
zoo: application/x-zoo
