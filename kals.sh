#!/bin/bash
#Créé par Ken
#Script sous licence GPLv3
#Ce script assume une installation fraîche d'Arch Linux et d"être connecté avec l'utilisateur souhaité

#Les fonctions
#Télécharges les programmes essentiels au script:
essentielScript() {
    echo "Préparation du script..."
    sudo pacman -Syu
    sleep 5
}
#Télécharge les paquets de ma configuration:
packageInstall() {
    if (whiptail --title "Commencer l'installation" --yesno "Êtes vous certains de vouloir procéder à l'installation de ma configuration ?" 10 80); then
        sudo pacman -S --noconfirm --needed apparmor arc-gtk-theme archlinux-keyring autoconf automake base binutils bison boost-libs cmus debugedit dialog discord dmenu fakeroot feh ffmpeg file findutils flex gawk gcc gettext gimp gnome-multi-writer grep groff grub grub-customizer gufw gzip htop i3-wm i3lock inkscape keepassxc lf libtool linux linux-firmware m4 make man-db mariadb neofetch neovim netctl networkmanager nitrogen nm-connection-editor noto-fonts openssh os-prober otf-droid-nerd p7zip pacman pacman-contrib patch pavucontrol picom pkgconf polybar pulseaudio python-packaging scour scrot sed sudo texinfo thunderbird udisks2 ufw which wireless_tools xfce4-settings xorg-server xorg-xbacklight xorg-xinit youtube-dl zram-generator zsh zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting xorg-fonts-encodings xorg-server-common xorg-setxkbmap xorg-xauth xorg-xkbcomp xorg-xmodmap xorg-xprop xorg-xrandr xorg-xrdb xorg-xset xorgproto
    else
        echo "L'utilisateur à abandonné l'installation."
        exit 1
    fi
}
#Active le firewall & Apparmor
ufwActive() {
    clear
    echo "Activation du pare-feu..."
    sudo systemctl start ufw.service
    sudo systemctl enable ufw.service
    sudo systemctl enable apparmor.service
    sleep 5
}
#Propose de télécharger des utilitaires pour PC portable:
pcPortable() {
    if (whiptail --title "Pc portable" --yesno "Voulez-vous des utilitaires pour Pc Portable ?" 10 80); then
        sudo pacman -S --noconfirm --needed tlp tlp-rdw xbindkeys light
    else
        echo "L'utilisateur n'à pas installé d'utilitaires pour PC portable."
    fi
}
#Change le shell:
shellChange() {
    clear
    echo "Changement du shell pour ZSH"
    chsh -s /usr/bin/zsh
    sleep 5
}
#Installe l'AUR:
aurInstall() {
    clear
    echo "Installation de Yay (AUR)"
    sudo pacman -S --noconfirm --needed base-devel git
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    sleep 5
}
#Installe les packages de l'AUR:
aurPackage() {
    clear
    yay -S --answerclean all --answerdiff none termite update-grub
}
#Choix navigateur web
choixNavigateur() {
    CHOICE2=$(whiptail --title "Choix du navigateur" --menu "Choississez le navigateur web que vous préférez:" 15 60 3 \
    "1" "Brave (recommandé)" \
    "2" "Firefox" \
    "3" "Aucun des deux" 3>&1 1>&2 2>&3)

    case $CHOICE2 in
        1)
            yay -S --answerclean all --answerdiff none brave-bin
            ;;
        2)
            sudo pacman -S --noconfirm --needed firefox
            ;;
        3)
            echo "Vous n'avez choisis aucun navigateur."
            ;;
        *)
            echo "Choix annulé."
            ;;
    esac
}
#Choix editeur de code
choixCode() {
    CHOICE3=$(whiptail --title "Choix de l'éditeur" --menu "Choississez votre éditeur favoris:" 15 60 4 \
    "1" "VSCode" \
    "2" "VSCodium (télémétrie windows enlevée)" \
    "3" "Aucun des deux" 3>&1 1>&2 2>&3)

    case $CHOICE3 in
        1)
            yay -S --answerclean all --answerdiff none visual-studio-code-bin
            ;;
        2)
            yay -S --answerclean all --answerdiff none vscodium-bin
            ;;
        3)
            echo "Vous n'avez choisis aucun éditeur de code."
            ;;
        *)
            echo "Choix annulé."
            ;;
    esac
}
#Importe les fichiers de configuration et les places:
importFichier() {
    echo "Import des fichiers de configuration: i3, termite, zsh, polybar."
    curl -LO kentrebaol.fr/kalsfiles/.zshrc
    curl -LO kentrebaol.fr/kalsfiles/i3config
    curl -LO kentrebaol.fr/kalsfiles/polyconfig
    curl -LO kentrebaol.fr/kalsfiles/termconfig
    mkdir -p -v .config/i3
    mkdir -v .config/termite
    mkdir -v .config/polybar
    mv -f -v i3config .config/i3/config
    mv -f -v polyconfig .config/polybar/config.ini
    mv -f -v termconfig .config/termite/config
    sleep 5
}
#Création de .xinitrc
creationXinit() {
    clear
    echo "Création du fichier Xinitrc"
    touch .xinitrc
    echo "setxkbmap fr\nexec i3" &> .xinitrc
    sleep 5
}
#Message de fin:
exitMessage() {
    whiptail --title "Fin du script" --msgbox "Succès de l'installation." 10 80
}
choixRedemarrage() {
    if (whiptail --title "Redémarrage" --yesno "Voulez-vous redémarrer maintenant ?" 10 80); then
        sudo reboot 10
    else
        echo "Vous n'avez pas redémarré."
    fi
}

#Début du script:
essentielScript
packageInstall
ufwActive
pcPortable
shellChange
aurInstall
aurPackage
choixNavigateur
choixCode
importFichier
creationXinit
exitMessage
choixRedemarrage