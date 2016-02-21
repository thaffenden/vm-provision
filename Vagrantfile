if (ARGV[0] =~ /^up|provision$/i or ARGV.include?("--provision")) and not ARGV.include?("--no-provision")
	$provisioning = true 
else 
	$provisioning = false 
end

timezone = Time.now.getlocal.zone

Vagrant.configure(2) do |config|
  config.vm.box = "ADD PATH TO YOUR BOX"
  config.vm.communicator = "winrm"
  config.winrm.username = "vagrant"
  config.winrm.password = "vagrant"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "3072"
    vb.gui = true
  end

  if $provisioning
	  config.vm.provision "shell",
		path: "install-python.ps1",
		run: "always"

	  config.vm.provision "shell",
	  	path: "install-firefox.ps1",
	  	run: "always"
  end
  
  config.vm.provision "shell",
		path: "set-timezone.ps1",
		args: "-timezone #{timezone}",
		run: "always"

end
