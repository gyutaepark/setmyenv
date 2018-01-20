conda_url='https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh'

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
		Yes ) break;;
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
		Yes ) break;;
No )  break;;
esac
done

if [[ $bashrc == "Yes" ]]; then
	cat toBash.txt >> $HOME/.bashrc;
	source $HOME/.bashrc;
	export PATH="$HOME/anaconda3/bin:$PATH"
fi

if [[ $cyclus == "Yes" ]]; then
	sudo apt-get update;
	sudo apt-get dist-upgrade -y
	sudo apt-get install -y cmake make libboost-all-dev libxml2-dev libxml++2.6-dev \
	libsqlite3-dev libhdf5-serial-dev libbz2-dev coinor-libcbc-dev coinor-libcoinutils-dev \
	coinor-libosi-dev coinor-libclp-dev coinor-libcgl-dev libblas-dev liblapack-dev g++ \
	libgoogle-perftools-dev python3-dev python3-tables python3-pandas python3-numpy python3-nose \
	python3-jinja2 cython3
fi

if [[ $conda == "Yes" ]]; then
	curl $conda_url -o Anaconda.sh
	bash Anaconda.sh -b -p $HOME/anaconda3
	rm Anaconda.sh
	source $HOME/.bashrc
	export PATH="$HOME/anaconda3/bin:$PATH"
	conda config --add channels conda-forge
	conda update --all -y
fi

if [[ $condacyclus == "Yes" ]]; then
	conda install cyclus-build-deps -y
fi

if [[ $condapyne == "Yes" ]]; then
	conda install pyne -y
fi

if [[ $nbextension == "Yes" ]]; then
	conda install jupyter_contrib_nbextensions autopep8 yapf -y
fi

if [[ $github == "Yes" ]]; then
	echo "Enter Git User Email";
	read email;
	ssh-keygen -t rsa -b 4096 -C $email;
	echo "Copy and Paste this for your ssh"
	echo "$(cat $HOME/.ssh/id_rsa.pub)"
	git config --global user.email $email;
	echo "Enter Git User Name";
	read name;
	git config --global user.name $name;
fi

if [[ $sublime == "Yes" ]]; then
	sudo add-apt-repository -y ppa:webupd8team/sublime-text-3;
	sudo apt-get update;
	sudo apt-get dist-upgrade -y
	sudo apt-get install -y sublime-text-installer
fi

if [[ $other == "Yes" ]]; then
	sudo apt-get update;
	echo "List all apt to get"
	read aptget;
	sudo apt-get install -y $aptget
fi
