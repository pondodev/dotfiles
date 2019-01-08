# script used to perform some general maintennance stuff

# full system upgrade (uses pakku for aur packages too)
echo "Performing full system upgrade..."
pakku -Syu

# remove orphans
echo "Removing orphan packages..."
sudo pacman -Rns $(pacman -Qtdq)

# bring up the bleachbit gui, better to handle this manually
echo "Launching bleachbit..."
bleachbit

echo "Maintennance complete!"
