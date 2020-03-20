aptlist=" "
condalist=" "

echo "Install Conda 3? (latest)?"
select conda in "Yes" "No"; do
	case $conda in
		Yes ) break;;
		No )  break;;
	esac
done

echo "Install Cyclus Dependencies? (conda)"
select condacyclus in "Yes" "No"; do
	case $condacyclus in
		Yes ) 
			condalist+="cyclus-build-deps "
			break;;
		No )  break;;
	esac
done

echo "Install Cyclus Dependencies? (apt)"
select cyclus in "Yes" "No"; do
	case $cyclus in
		Yes ) 
			aptlist+="cmake make libboost-all-dev libxml2-dev libxml++2.6-dev \
				libsqlite3-dev libhdf5-serial-dev libbz2-dev coinor-libcbc-dev coinor-libcoinutils-dev \
				coinor-libosi-dev coinor-libclp-dev coinor-libcgl-dev libblas-dev liblapack-dev g++ \
				libgoogle-perftools-dev python3-dev python3-tables python3-pandas python3-numpy python3-nose \
				python3-jinja2 cython3 "
			break;;
		No )  break;;
	esac
done

echo "Install Pyne Dependencies? (conda)"
select condapyne in "Yes" "No"; do
	case $condapyne in
		Yes ) 
			condalist+="conda-build jinja2 nose setuptools pytables hdf5 scipy "
			break;;
		No )  break;;
	esac
done

echo "Install Pyne Dependencies? (apt)"
select pyne in "Yes" "No"; do
	case $pyne in
		Yes ) 
			aptlist+="build-essential gfortran libblas-dev liblapack-dev libhdf5-dev autoconf libtool "
			break;;
		No )  break;;
	esac
done

echo "Install Jupyter Extensions?"
select nbextension in "Yes" "No"; do
	case $nbextension in
		Yes ) 
			condalist+="jupyter_contrib_nbextensions autopep8 "
			break;;
		No )  break;;
	esac
done

echo "Install Sublime Text?"
select sublime in "Yes" "No"; do
	case $sublime in
		Yes ) 
			aptlist+="sublime-text "
			break;;
		No )  break;;
	esac
done

echo "Install Other Software?"
select other in "Yes" "No"; do
	case $other in
		Yes )
			echo "List all apt to get (separated by single space only)"
			read aptget;
			aptlist+="$aptget "
			break;;
		No )  break;;
	esac
done

echo "Setup Git?"
select github in "Yes" "No"; do
	case $github in
		Yes )
			echo "Enter Git User Email";
			read email;
			git config --global user.email $email;
			echo "Enter Git User Name";
			read name;
			git config --global user.name $name;
			echo "Enter Default editor";
			read editor;
			git config --global core.editor $editor;
			ssh-keygen -t rsa -b 4096 -C $email;
			echo "Copy and Paste this to: https://github.com/settings/ssh/new"
			echo "$(cat $HOME/.ssh/id_rsa.pub)"
			break;;
		No )  break;;
	esac
done

echo "Display git branch name in shell?"
echo "(obtained from: https://coderwall.com/p/fasnya/add-git-branch-name-to-bash-prompt)"
select parsegit in "Yes" "No"; do
	case $parsegit in
		Yes )
			cat settings/parse_git_branch.txt >> $HOME/.bashrc;
			break;;
		No )  break;;
	esac
done

echo "Running wsl with xserver?"
select wsl in "Yes" "No"; do
	case $wsl in
		Yes )
			echo "export DISPLAY=:0" >> $HOME/.bashrc
			echo -e '\n\neval `dbus-launch --auto-syntax`\n' | sudo tee -a /etc/profile 1> /dev/null
			break;;
		No )  break;;
	esac
done

echo "Restore personal settings?"
select alias in "Yes" "No"; do
	case $alias in
		Yes )
			aptlist+="tilix dconf-cli "
			echo -e 'tilix\n' | sudo tee -a /etc/profile 1> /dev/null
			mkdir -p $HOME/.config/sublime-text-3/Packages/User
			cp -r sublime_text_settings $HOME/.config/sublime-text-3/Packages/User
			cat alias.txt >> $HOME/.bashrc
			break;;
		No )  break;;
	esac
done

if [[ $sublime == "Yes" ]]; then
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
fi

sudo apt update;
sudo apt-get install -y $aptlist;

if [[ $alias == "Yes" ]]; then
	dconf load /com/gexperts/Tilix/ < settings/tilix.dconf
fi

if [[ $conda == "Yes" ]]; then
	wget -O - https://www.anaconda.com/distribution/ 2>/dev/null \
	| sed -ne 's@.*\(https:\/\/repo\.anaconda\.com\/archive\/Anaconda3-.*-Linux-x86_64\.sh\)\">64-Bit (x86) Installer.*@\1@p' \
	| xargs wget -O Anaconda3.sh
	bash Anaconda3.sh -b -p $HOME/anaconda3
	rm Anaconda3.sh
	cat path.txt >> $HOME/.bashrc
	export PATH="$HOME/anaconda3/bin:$PATH"
	conda config --add channels conda-forge
fi

conda install -c conda-forge -y $condalist;

echo -e $"Done.\nDon't forget to run 'source $HOME/.bashrc'"
