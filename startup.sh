conda_url='https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh'
download_dir='$HOME/SetMyEnvironment/Anaconda.sh'
cyclus_deps='sudo apt-get install -y cmake make libboost-all-dev libxml2-dev libxml++2.6-dev \
libsqlite3-dev libhdf5-serial-dev libbz2-dev coinor-libcbc-dev coinor-libcoinutils-dev \
coinor-libosi-dev coinor-libclp-dev coinor-libcgl-dev libblas-dev liblapack-dev g++ \
libgoogle-perftools-dev python3-dev python3-tables python3-pandas python3-numpy python3-nose \
python3-jinja2 cython3'

echo "What Do I do?"
select yn in "Bash" "+Anaconda" "+Misc" "+CyclusDeps" "+GitBranches"; do
    case $yn in
        Bash ) cat toBash.txt >> $HOME/.bashrc; 
			source $HOME/.bashrc; 
			break;;
        +Anaconda ) cat toBash.txt >> $HOME/.bashrc; 
			source $HOME/.bashrc;
			curl $conda_url -o $download_dir
			bash Anaconda.sh; 
			rm Anaconda.sh; 
			break;;
		+Misc ) cat toBash.txt >> $HOME/.bashrc; 
			source $HOME/.bashrc;
			curl $conda_url -o $download_dir
			bash Anaconda.sh; 
			rm Anaconda.sh; 
			sudo add-apt-repository -y ppa:webupd8team/sublime-text-3;
			sudo apt-get update;
			sudo apt install -y sublime-text-installer git gnome-terminal;
			break;;
		+CyclusDeps ) cat toBash.txt >> $HOME/.bashrc; 
			source $HOME/.bashrc;
			curl $conda_url -o $download_dir
			bash Anaconda.sh; 
			rm Anaconda.sh; 
			sudo add-apt-repository -y ppa:webupd8team/sublime-text-3;
			sudo apt-get update;
			sudo apt install -y sublime-text-installer git gnome-terminal;
			eval $cyclus_deps;
			sudo apt-get -y dist-upgrade;
			break;;
		+GitBranches ) cat toBash.txt >> $HOME/.bashrc; 
			source $HOME/.bashrc;
			curl $conda_url -o $download_dir
			bash Anaconda.sh; 
			rm Anaconda.sh; 
			sudo add-apt-repository -y ppa:webupd8team/sublime-text-3;
			sudo apt-get update;
			sudo apt install -y sublime-text-installer git gnome-terminal;
			eval $cyclus_deps;
			sudo apt-get -y dist-upgrade;
			echo "Enter Git User Email";
			read email;
			ssh-keygen -t rsa -b 4096 -C $email;
			echo "Copy and Paste this for your ssh"
			echo "$(cat $HOME/.ssh/id_rsa.pub)"
			git config --global user.email $email;
			echo "Enter Git User Name";
			read name;
			git config --global user.name $name;
			echo "How many branches do you need to clone?"
			read count;
			if [ $count -gt 0]
				then
					for i in $count; do
						echo "Link?";
						read branch;
						git clone $branch;
					done
			fi
			break;;
    esac
done