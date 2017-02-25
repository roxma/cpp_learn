
function base64_decode(){
	python -u -c '
import base64, sys
if sys.version_info.major==2:
	sys.stdout.write(base64.b64decode(sys.stdin.read()))
else:
	sys.stdout.buffer.write(base64.b64decode(sys.stdin.buffer.read()))
	'
}
