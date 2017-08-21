cd $(dirname $0)

set -e

OS="`uname`"

# Make backup folder
echo "Making backup dir"
mkdir -p ./backup

# Install all Config Files
echo "Linking Config Files"
for file in $(find "files" -type f) 
do
    name=${file#files/}
    if [ -e ~/$name ] && [ ! -h ~/$name ]; then
        echo "Backing up $name"
        cp -r ~/$name ./backup
    fi

    echo "Linking $name"
    mkdir -p ~/$(dirname $name)
    ln -sf $(pwd)/files/$name ~/$name
done

# nixos config must be run as root!
if [ $EUID = 0 ]; then
    echo "Backing up nixos folder"
    cp -rn /etc/nixos ./backup

    echo "Linking nixos folder"
    sudo rm -rf /etc/nixos
    sudo ln -sf $(pwd)/nixos /etc/nixos
else
    echo "Script not running as root, skipping nixos"
fi

# Clean up backup dir if empty
if [ "$(ls -A ./backup)" ]; then
    echo "Backup at ~/dot-backup"
else
    echo "Removing empty backup dir"
    rmdir ./backup
fi


echo "Done linking all files"
