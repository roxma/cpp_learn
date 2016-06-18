
function roxma_golang_workspace_init() {

    local dir="$1"
    if [[ "$dir" == "" ]]
    then
        echo "dir not specify"
        return 1
    fi

    mkdir -p "$dir"
    mkdir -p "$dir/pkg"
    mkdir -p "$dir/src"
    mkdir -p "$dir/bin"


    # subprocess to change directory
    (
        if [[ -d "$dir/src/golang.org/x/" ]]
        then
            echo "dir[$dir/src/golang.org/x/] exists, no need to unzip golang.org/x/tools, golang.org/x/net package" 
            exit
        fi
        mkdir -p "$dir/src/golang.org/x/"
        roxma_golang_x_zip_encoded | base64_decode > "$dir/src/golang.org/x/zips.tar.gz"
        cd "$dir/src/golang.org/x"
        tar -zxf zips.tar.gz
        rm zips.tar.gz
        unzip tools-*.zip
        unzip net-*.zip
        rm *.zip
        mv tools-* tools 
        mv net-* net
    )

echo '# Place this bashrc into you golang workspace directory.
# Then use source <this_bashrc_file> to initialize golang workspace directory

mkdir -p "$(dirname ${BASH_SOURCE[0]})/pkg"
mkdir -p "$(dirname ${BASH_SOURCE[0]})/src"
mkdir -p "$(dirname ${BASH_SOURCE[0]})/bin"

export GOPATH="$(readlink -f $(dirname ${BASH_SOURCE[0]}))"
export PATH="$(readlink -f $(dirname ${BASH_SOURCE[0]}))/bin/":"$PATH"
# export GO15VENDOREXPERIMENT=1

# go build tools
which go 1>/dev/null 2>/dev/null
if [[ $? != 0 ]]
then

    # subprocess
    (
        url="https://storage.googleapis.com/golang/go1.6.2.linux-amd64.tar.gz"

        cd $(dirname ${BASH_SOURCE[0]})

        if [[ ! -d ./go ]] && [[ ! -f ./go1.6.2.linux-amd64.tar.gz ]]
        then
            echo "need to download go tool: $url"
            wget "$url"
            if [[ $? != 0 ]]
            then
                echo "cmd failed: " wget "$url"
                return 1
            fi
        fi

        if [[ ! -d ./go ]]
        then
            tar -zxf go1.6.2.linux-amd64.tar.gz
            rm go1.6.2.linux-amd64.tar.gz
        fi

    ) 

    export GOROOT="$(readlink -f $(dirname ${BASH_SOURCE[0]}))/go"
    export PATH="$(readlink -f $(dirname ${BASH_SOURCE[0]}))/go/bin":"$PATH"

fi
' > "${dir}/bashrc"
    source "${dir}/bashrc"

    echo "############"
    echo "go tools you may need:"
    echo "go get github.com/tools/godep"
    echo ""
    echo "please add [source $(readlink -f ${dir}/bashrc)] to your ~/.bashrc file if this is your default workspace."
}

