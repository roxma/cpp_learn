
function base64_encode(){
	python -u -c '
import base64, sys
if sys.version_info.major==2:
	sys.stdout.write(base64.b64encode(sys.stdin.read()))
else:
	sys.stdout.buffer.write(base64.b64encode(sys.stdin.buffer.read()))
	'
}
