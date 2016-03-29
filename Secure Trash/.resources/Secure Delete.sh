#  Usage: srm [OPTION]... [FILE]...
#  Overwrite and remove (unlink) the files.
#  
#    -d, --directory     ignored (for compatibility with rm(1))
#    -f, --force         ignore nonexistent files, never prompt
#    -i, --interactive   prompt before any removal
#    -s, --simple        only overwrite with single random pass
#    -m, --medium        overwrite with 7 US DoD compliant passes
#    -z, --zero          after overwriting, zero blocks used by file
#    -n, --nounlink      overwrite file, but do not rename or unlink
#    -r, -R, --recursive remove the contents of directories
#    -v, --verbose       explain what is being done
#        --help          display this help and exit
#        --version       display version information and exit
#  
#  Note: The -s option overrides the -m option, if both are present.
#  If neither is specified, the 35-pass Gutmann algorithm is used.
#
#  On SSD seven passes is sufficient, due to high bit density. Thirty five passes can be damaging to the drive.
cd ~Andrew/Desktop/Secure\ Trash/
shopt -s extglob
#sudo srm -rfvm !(*Icon*|icon/*|Icon?|.namedfork/rsrc|.namedfork|.namedfork/*) ./
find . -maxdepth 1 \( -path ./.resources -prune \) -o \( -regex "\./.*" -print \) -exec srm -rfvm {} \;

afplay ./resources/empty\ trash.aif



#!/bin/sh
# Sets an icon on file or directory
# Usage setIcon.sh iconimage.jpg /path/to/[file|folder]
iconSource=./resources/trash_empty.png
iconDestination=./
icon=/tmp/`basename $iconSource`
rsrc=/tmp/icon.rsrc

# Create icon from the iconSource
cp $iconSource $icon

# Add icon to image file, meaning use itself as the icon
sips -i $icon

# Take that icon and put it into a rsrc file
DeRez -only icns $icon > $rsrc

# Apply the rsrc file to
SetFile -a C $iconDestination

if [ -f $iconDestination ]; then
    # Destination is a file
    Rez -append $rsrc -o $iconDestination
elif [ -d $iconDestination ]; then
    # Destination is a directory
    # Create the magical Icon\r file
    touch $iconDestination/$'Icon\r'
    Rez -append $rsrc -o $iconDestination/Icon?
    SetFile -a V $iconDestination/Icon?
fi

# Sometimes Finder needs to be reactivated
#osascript -e 'tell application "Finder" to quit'
#osascript -e 'delay 2'
#osascript -e 'tell application "Finder" to activate'

rm $rsrc $icon
