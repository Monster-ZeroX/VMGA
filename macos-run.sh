#macos-run.sh MAC_USER_PASSWORD VNC_PASSWORD NGROK_AUTH_TOKEN MAC_REALNAME

#disable spotlight indexing
sudo mdutil -i off -a

#Create new account
sudo dscl . -create /Users/reaitten
sudo dscl . -create /Users/reaitten UserShell /bin/bash
sudo dscl . -create /Users/reaitten RealName $4
sudo dscl . -create /Users/reaitten UniqueID 1001
sudo dscl . -create /Users/reaitten PrimaryGroupID 80
sudo dscl . -create /Users/reaitten NFSHomeDirectory /Users/reaitten
sudo dscl . -passwd /Users/reaitten $1
sudo dscl . -passwd /Users/reaitten $1
sudo createhomedir -c -u reaitten > /dev/null
sudo dscl . -append /Groups/admin GroupMembership username

#Enable VNC
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy yes 

echo $2 | perl -we 'BEGIN { @k = unpack "C*", pack "H*", "1734516E8BA8C5E2FF1C39567390ADCA"}; $_ = <>; chomp; s/^(.{8}).*/$1/; @p = unpack "C*", $_; foreach (@k) { printf "%02X", $_ ^ (shift @p || 0) }; print "\n"' | sudo tee /Library/Preferences/com.apple.VNCSettings.txt

#Start VNC/reset changes
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent -console
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate

# install ngrok, anydesk and watch.
brew update
brew install --cask ngrok anydesk firefox qbittorrent

# https://stackoverflow.com/questions/16242025/term-environment-variable-not-set#16252511
set | grep TERM
export TERM=xterm

#configure ngrok and start it
ngrok authtoken $3
ngrok tcp 5900 --region=ap &
