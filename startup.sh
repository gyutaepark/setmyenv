conda_url='https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh'

echo "Update Bashrc? (Append conda path, parse git branch, alias, etc.)"
select bashrc in "Yes" "No"; do
	case $bashrc in
		Yes ) break;;
		No )  break;;
esac
done

echo "Install Cyclus Dependencies? (apt)"
select cyclus in "Yes" "No"; do
	case $cyclus in
		Yes ) break;;
No )  break;;
esac
done

echo "Install Conda 3? (5.0.1)?"
select conda in "Yes" "No"; do
	case $conda in
		Yes ) break;;
		No )  break;;
esac
done

echo "Install Cyclus Dependencies? (conda)"
select condacyclus in "Yes" "No"; do
	case $condacyclus in
		Yes ) break;;
		No ) break;;
esac
done

echo "Install Pyne?"
select condapyne in "Yes" "No"; do
	case $condapyne in
		Yes ) break;;
		No ) break;;
esac
done

echo "Install Jupyter Extensions?"
select nbextension in "Yes" "No"; do
	case $nbextension in
		Yes ) break;;
		No ) break;;
esac
done

echo "Setup Git?"
select github in "Yes" "No"; do
	case $github in
		Yes )
			sudo apt install -y git
			echo "Enter Git User Email";
			read email;
			ssh-keygen -t rsa -b 4096 -C $email;
			echo "Copy and Paste this to: https://github.com/settings/ssh/new"
			echo "$(cat $HOME/.ssh/id_rsa.pub)"
			git config --global user.email $email;
			echo "Enter Git User Name";
			read name;
			git config --global user.name $name;
			break;;
		No )  break;;
esac
done

echo "Install Sublime Text?"
select sublime in "Yes" "No"; do
	case $sublime in
		Yes ) break;;
		No )  break;;
esac
done

echo "Install Other Software?"
select other in "Yes" "No"; do
	case $other in
		Yes )
			echo "List all apt to get (separated by single space only)"
			read aptget;
			break;;
		No )  break;;
esac
done

sudo apt update;
sudo apt dist-upgrade -y;

if [[ $bashrc == "Yes" ]]; then
	cat toBash.txt >> $HOME/.bashrc;
	export PATH="$HOME/anaconda3/bin:$PATH"
	echo "Don't forget to run `source $HOME/.bashrc`!"
fi

if [[ $cyclus == "Yes" ]]; then
	sudo apt-get install -y cmake make libboost-all-dev libxml2-dev libxml++2.6-dev \
	libsqlite3-dev libhdf5-serial-dev libbz2-dev coinor-libcbc-dev coinor-libcoinutils-dev \
	coinor-libosi-dev coinor-libclp-dev coinor-libcgl-dev libblas-dev liblapack-dev g++ \
	libgoogle-perftools-dev python3-dev python3-tables python3-pandas python3-numpy python3-nose \
	python3-jinja2 cython3
fi

if [[ $conda == "Yes" ]]; then
	sudo apt-get install -y curl
	curl $conda_url -o Anaconda.sh
	bash Anaconda.sh -b -p $HOME/anaconda3
	rm Anaconda.sh
	export PATH="$HOME/anaconda3/bin:$PATH"
	conda config --add channels conda-forge
fi

if [[ $condacyclus == "Yes" ]]; then
	conda install -c conda-forge cyclus-build-deps -y
fi

if [[ $condapyne == "Yes" ]]; then
	conda install pyne -y
fi

if [[ $nbextension == "Yes" ]]; then
	conda install jupyter_contrib_nbextensions autopep8 -y
fi

if [[ $sublime == "Yes" ]]; then
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	sudo apt install -y apt-transport-https
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt update
	sudo apt install -y sublime-text
fi

if [[ $other == "Yes" ]]; then
	sudo apt-get install -y $aptget
fi
