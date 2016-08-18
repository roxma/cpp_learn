#!/bin/bash

# ./merge_tools.sh > output.sh

option_compress=1

function Entry(){

	local baseDir="$(readlink -f .)"
	local moduleDirs="$(find . -mindepth 1 -maxdepth 1 -type d)"

	echo '#!/bin/bash' 

	# merge simple modules first, more complicated modules
	# may be depended on these modules
	for moduleDir in $moduleDirs ; do
		# simple modules 
		if [[ ! -f $moduleDir/merge_tools.sh ]] ; then
			echo "$moduleDir ModuleDefaultOutput" 1>&2
			cd $moduleDir
			ModuleDefaultOutput
			cd $baseDir
		fi
	done

	for moduleDir in $moduleDirs ; do
		# more complicated modules
		if [[ -f $moduleDir/merge_tools.sh ]] ; then
			echo "$moduleDir/merge_tools.sh" 1>&2
			cd $moduleDir
			./merge_tools.sh
			cd $baseDir
		fi
	done

	echo '
	if [ -d $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.local_software ] && [ -d $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.local_software/local_bashrc ]
	then
		source $(find $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.local_software/local_bashrc -name "*.sh") /dev/null
	fi
	'

}

function ModuleDefaultOutput(){
	# handle bashScripts
	local bashScripts="$(find . -mindepth 1 -name "*.sh")"
	for bashScriptFile in $bashScripts ; do
		cat $bashScriptFile 
	done

	local pythonScripts=$(find . -mindepth 1 -name "*.py")
	for pythonScript in $pythonScripts
	do
		local scriptName=$(basename $pythonScript)
		echo \
"function ${scriptName/%.py/}(){
		python  -c \"\$($(TextFileEncodedToScript ${pythonScript}))\"  \"\$@\"
}"
	done
}

##
# encode text file content to bash script string
function TextFileEncodedToScript(){
	# The client macine may not have base64 program, thus we use the base64_decode 
	# function in the output script file
	local fileName=$1
	if [[ "$option_compress" = "1" ]]; then
		local encodedTextContent=$(bzip2 -c $fileName | base64)
		echo "echo '$encodedTextContent' | base64_decode | bzcat"
	else
		local encodedTextContent=$(cat $fileName | base64)
		echo "echo '$encodedTextContent' | base64_decode"
	fi
}

Entry

