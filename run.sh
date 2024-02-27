#!/bin/bash

function install() {

	echo -n 'Would you like to install 9front or 9legacy distribution? [9front, 9legacy, 9ants] [default=9front] '
	read -r distro
        distro="${distro:=9front}"

	
	echo -n 'Specify in GB how large of an image should be created (ex. 30G): [default=10G] '
	read -r img_size
        img_size="${img_size:=10G}"


	iso_file=''
	image_name=''

	case $distro in
		9front)
			# download iso to 9front.iso
			iso_file='9front.iso'
			image_name='9front.qcow2.img'
                        if [ ! -f "${iso_file}" ]; then
                            curl -L http://9front.org/iso/9front-10277.amd64.iso.gz -o "${iso_file}".gz
                            gunzip "${iso_file}".gz
                        else
                            echo "Skipping download, installation ISO ${iso_file} already present."
                        fi
			stat "${iso_file}"
			;;
		9legacy)
			iso_file='9legacy.iso'
			image_name='9legacy.qcow2.img'
                        if [ ! -f "${iso_file}" ]; then
                            curl -L http://9legacy.org/download/9legacy.iso.bz2 -o "${iso_file}".bz2
                            bunzip2 "${iso_file}".bz2
                        else
                            echo "Skipping download, installation ISO ${iso_file} already present."
                        fi
			stat "${iso_file}"
			;;
		9ants)
			iso_file='9ants.iso'
			image_name='9ants.qcow2.img'
                        if [ ! -f "${iso_file}" ]; then
                            curl -L http://files.9gridchan.info/9ants5.64.iso.gz -o "${iso_file}".gz
                            gunzip "${iso_file}".gz
                        else
                            echo "Skipping download, installation ISO ${iso_file} already present."
                        fi
			stat "${iso_file}"
			;;
	esac

	qemu-img create -f qcow2 "${image_name}" "${img_size}"

	# Run qemu with installation arguments
	qemu-system-x86_64 -hda $image_name -cdrom $iso_file -boot d -vga std -m 768
}

function run() {

	echo -n 'Do you want to boot 9front or 9legacy? [9front, 9legacy, 9ants] [default=9front] '
	read -r opt
        opt="${opt:=9front}"

	image_name=''

	case $opt in
		9front)
			image_name='9front.qcow2.img'
			;;
		9legacy)
			image_name='9legacy.qcow2.img'
			;;
		9ants)
			image_name='9ants.qcow2.img'
			;;
	esac

	echo -n 'How much memory in GB should be used for this machine? (ex. 4G) [default=2G] '
	read -r mem
        mem="${mem:=2G}"

	# -m option configures memory. feel free to change to match your preferences
	qemu-system-x86_64 -m "${mem}" "${image_name}"
}


echo -n 'Would you like to install or run Plan 9? [run, install] [default=run] '
read -r action
action="${action:=run}"

case $action in
	install)
		install
		;;
	run)
		run
		;;
esac
