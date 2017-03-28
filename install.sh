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
        cp ~/$name ./backup
    fi

    echo "Linking $name"
    ln -sf $(pwd)/files/$name ~/$name
done

# Clean up backup dir if empty
if [ "$(ls -A ./backup)" ]; then
    echo "Backup at ~/dot-backup"
else
    echo "Removing empty backup dir"
    rmdir ./backup
fi


echo "Done linking all files"
