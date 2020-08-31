aptlist=" "
condalist=" "

echo "Install Anaconda 3? (latest)"
select anaconda in "Yes" "No"; do
	case $anaconda in
		Yes ) break;;
		No )  break;;
	esac
done

echo "Install Miniconda 3? (latest)"
select miniconda in "Yes" "No"; do
	case $miniconda in
		Yes ) break;;
		No )  break;;
	esac
done

echo "Install Cyclus Dependencies? (conda)"
select condacyclus in "Yes" "No"; do
	case $condacyclus in
		Yes ) 
			condalist+="openssh gxx_linux-64 gcc_linux-64 cmake make docker-pycreds git xo python-json-logger \
						python=3.6 glibmm glib=2.56 libxml2 libxmlpp libblas libcblas liblapack pkg-config \
						coincbc=2.9 boost-cpp hdf5 sqlite pcre gettext bzip2 xz setuptools nose pytables pandas \
						jinja2 cython==0.26 websockets pprintpp "
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

echo "Running wsl2 with xserver?"
select wsl in "Yes" "No"; do
	case $wsl in
		Yes )
			echo "export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0" >> $HOME/.bashrc
			break;;
		No )  break;;
	esac
done

echo "Restore personal settings?"
select alias in "Yes" "No"; do
	case $alias in
		Yes )
			aptlist+="gnome-terminal tmux "
			mkdir -p $HOME/.config/sublime-text-3/Packages/User
			cp -r settings/sublime_text_settings $HOME/.config/sublime-text-3/Packages/User
			cat settings/alias.txt >> $HOME/.bashrc
			break;;
		No )  break;;
	esac
done

if [[ $sublime == "Yes" ]]; then
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
fi

sudo apt update;
sudo apt install -y $aptlist;
sudo apt dist-upgrade -y; 

if [[ $alias == "Yes" ]]; then
	dconf load /com/gexperts/Tilix/ < settings/tilix.dconf
fi

if [[ $anaconda == "Yes" ]]; then
	wget -O - https://www.anaconda.com/distribution/ 2>/dev/null \
	| sed -ne 's@.*\(https:\/\/repo\.anaconda\.com\/miniconda\/Anaconda3-.*-Linux-x86_64\.sh\)\">64-Bit (x86) Installer.*@\1@p' \
	| xargs wget -O Anaconda3.sh
	bash anaconda3.sh -b -p $HOME/conda
	rm anaconda3.sh
	echo -e '\nexport PATH="$HOME/conda/bin:$PATH"\n' >> $HOME/.bashrc
	export PATH="$HOME/conda/bin:$PATH"
	conda config --add channels conda-forge
fi

if [[ $miniconda == "Yes" ]]; then
	wget -O miniconda3.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
	bash miniconda3.sh -b -p $HOME/conda
	rm miniconda3.sh
	echo -e '\nexport PATH="$HOME/conda/bin:$PATH"\n' >> $HOME/.bashrc
	export PATH="$HOME/conda/bin:$PATH"
	conda config --add channels conda-forge
fi

if [[ $condacyclus == "Yes" ]]; then
	echo 'Pinning conda packages to prevent updates for cyclus compatibility'
	cp settings/conda-pinned.txt $HOME/conda3/conda-meta/pinned
	#statements
fi

conda update  -c conda-forge -y --all;
conda install -c conda-forge -y $condalist;

echo -e $"Done.\nDon't forget to run 'source $HOME/.bashrc'"
