
function base64_encode(){
	python -c '
import base64, sys
sys.stdout.write(base64.b64encode(sys.stdin.read()))
	'
}
