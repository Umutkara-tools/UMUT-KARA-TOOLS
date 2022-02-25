#!/bin/bash
clear

githubUsername="umutkara-tools"

if [[ $1 == update ]];then
	cd files
	bash update.sh update $2
	exit
fi

# CURL  PAKET KONTROLÜ #

if [[ ! -a $PREFIX/bin/curl ]];then
	echo
	echo
	echo
	printf "\e[32m[✓]\e[97m CURL PAKETİ KURLUYOR"
	echo
	echo
	echo
	pkg install curl -y
fi
# jQ  PAKET KONTROLÜ #

if [[ ! -a $PREFIX/bin/jq ]];then
	echo
	echo
	echo
	printf "\e[32m[✓]\e[97m JQ PAKETİ KURLUYOR"
	echo
	echo
	echo
	pkg install jq -y
fi

control=$(ping -c 1 github.com |wc -l)
if [[ $control == 0 ]];then
	echo
	echo
	echo
	printf "\e[1;31m
	[!] \e[97mHATA OLUŞTU \e[31m!!!\e[33m

	[*] \e[97mİNTERNET BAĞLANTINIZI KONTROL EDİN
	"
	echo
	echo
	echo
	exit
fi
if [[ -a $HOME/.UMUT-KARA-TOOLS ]];then
	
	control=$(cat $HOME/.UMUT-KARA-TOOLS/.git/config |grep url |awk -F '/' '{print $4}')
	
	if [[ $control != $githubUsername ]];then
		
		rm -rf $HOME/.UMUT-KARA-TOOLS
		
		if [[ -a $PREFIX/bin/tools-umutkara ]];then
			rm $PREFIX/bin/tools-umutkara
		fi
	fi	
fi
if [[ ! -a $PREFIX/bin/tools-umutkara ]];then
	cd files
	cp .tools-umutkara /data/data/com.termux/files/usr/bin/tools-umutkara
	cd ..
	mkdir $HOME/.UMUT-KARA-TOOLS
	mv * $HOME/.UMUT-KARA-TOOLS
	mv .git $HOME/.UMUT-KARA-TOOLS
	cd ..
	repoName=$(cat .UMUT-KARA-TOOLS/.git/config |grep url |awk -F '/' '{print $5}')
	if [[ -a $repoName ]];then
		rm -rf $repoName
	fi
	chmod 777 /data/data/com.termux/files/usr/bin/tools-umutkara
	chmod 777 $HOME/.UMUT-KARA-TOOLS/umut-kara-tools.sh
	echo
	echo
	echo
	printf "\e[32m[✓] tools-umutkara\e[0m KISAYOL OLUŞTURULDU"
	echo
	echo
	echo
	exit
fi
cd files
bash update.sh
if [[ -a ../updates_infos ]];then
	rm ../updates_infos
	exit
fi
bash banner.sh
curl -s "https://api.github.com/users/$githubUsername/repos?per_page=100" | jq -r ".[].name" | xargs -L1 > tools.txt
total=$(cat tools.txt |wc -l)
color=$(cat .color.txt)
for no in `seq 1 $total` ; do
	if [[ $no -le 9 ]];then
		printf "
		          \e[97m[$no]  $color $(sed -n $no\p tools.txt)
		"
	elif [[ $no -gt 9 ]];then
		printf "
		          \e[97m[$no] $color $(sed -n $no\p tools.txt)
		"
	fi
done
echo
echo
echo
read -e -p $' \e[92mUmuTKaRa\e[97m@\e[92mtools\e[97m~\e[91m>> \e[0m' secim
if [[ $secim == x || $secim == X || $secim == exit ]];then
	echo
	echo
	echo
	printf "\e[31m[!]\e[0m ÇIKIŞ YAPILDI \e[31m!!!\e[0m"
	echo
	echo
	echo
	rm tools.txt
	exit
fi
total=$(cat tools.txt |wc -l)
if [[ $secim -gt $total ]];then
	echo
	echo
	echo
	printf "\e[31m[!]\e[0m HATALI SEÇİM \e[31m!!!\e[0m"
	echo
	echo
	echo
	rm tools.txt
	exit
fi
if [[ $secim -le 0 ]];then
	echo
	echo
	echo
	printf "\e[31m[!]\e[0m HATALI SEÇİM \e[31m!!!\e[0m"
	echo
	echo
	echo
	rm tools.txt
	exit
fi
echo
echo
echo
directory="$HOME"
directory_name='HOME'
if [[ -n $1 ]];then
	directory="$(cat .pwd)"
	total=$(echo -e "$directory" |grep -o / |wc -l)
	let total+=1
	name=$(echo -e "$directory" |awk -F "/" "{print \$$total}")
	directory_name="$name"
fi
close() {
tool_name=$(sed -n $secim\p tools.txt)
if [[ -a $HOME/$tool_name ]];then
	cd $HOME/$tool_name
	script_name=$(ls |grep .sh |sed -n 1p)
	bash $script_name
	exit
fi
}
printf "\e[32m[✓]\e[92m $(sed -n $secim\p tools.txt) \e[0m $directory_name DİZİNİNE İNDİRİLİYOR "
echo
echo
echo
git clone https://github.com/$githubUsername/$(sed -n $secim\p tools.txt)
mv $(sed -n $secim\p tools.txt) $directory
rm tools.txt

