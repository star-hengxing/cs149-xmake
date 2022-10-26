# AWS Setup Instructions #

For performance testing, you will need to run this assignment on a VM instance on Amazon Web Services (AWS). We've already sent you student coupons that you can use for billing purposes. Here are the steps for how to get setup for running on AWS.

NOTE: __Please don't forget to SHUT DOWN your instances when you're done for the day to avoid burning through credits overnight!__

### Creating a VM with a GPU ###

1. Now you're ready to create a VM instance. Log in to the [AWS EC2 dashboard](https://us-west-2.console.aws.amazon.com/ec2/home?region=us-west-2#Home) for the `us-west-2` region and click on the button that says `Launch instance`.
![Launch instance](handout/launch_instance.png?raw=true)

2. Choose the `Ubuntu Server 20.04 LTS (HVM), SSD Volume Type` AMI:
![Ubuntu](handout/ubuntu.png?raw=true)

3. Choose the `g4dn.xlarge` instance type.
![Instance type](handout/instance_type.png?raw=true)

4. Change the size of the volume to 64 GB to accomodate the packages we will need to install to make the instance functional for the assignment:
![Storage](handout/storage.png?raw=true)

5. AWS will ask you to select a key pair. Click the first dropdown and choose `Create a new key pair` and give it whatever name you'd like. This will download a keyfile to your computer called `<key_name>.pem` which you will use to login to the VM instance you are about to create. Finally, you can launch your instance.
![Key Pair](handout/new_key_pair.png?raw=true)

__Note: `g4dn.xlarge` instances cost $0.526 / hour, so leaving one running for a whole day will consume $12.624 worth of your AWS coupon. Remmeber to shut off the instance when you're not using it!__

6. Now that you've created your VM, you should be able to __SSH__ into it. You need the public IPv4 DNS name to SSH into it, which you can find by navigating to your instance's page and then clicking the `Connect` button, followed by selecting the SSH tab (note, it may take a moment for the instance to startup and be assigned an IP address):
![Connect](handout/connect.png?raw=true)

Make sure you follow the instructions to change the permissions of your key file as follows. 

a. For Linux / MacOS terminal:
~~~~
chmod 400 path/to/key_name.pem
~~~~
b. For Windows Powershell:  Replace only `your_key_name.pem` with the name of your `.pem` file.
~~~~
icacls.exe your_key_name.pem /reset
icacls.exe your_key_name.pem /grant:r "$($env:username):(r)"
icacls.exe your_key_name.pem /inheritance:r
~~~~

Once you have the IP address, you can login to the instance by running this command:
~~~~
ssh -i path/to/key_name.pem ubuntu@<public_dns_name>
~~~~

### Setting up the VM environment ###

We have included a convenience script, __install.sh__, which performs steps 7,8,9 for you. To run it, do:

~~~~
chmod +x install.sh
sudo ./install.sh
source ~/.bashrc
~~~~

If for some reason the script does not work, the manual instructions follow:

### Manually setting up the VM environment ###

7. Once you SSH into your VM instance, you'll want to install whatever software you need to make the machine a useful development environment for you.  For example we recommend:
~~~~
sudo apt update
sudo apt install make g++ freeglut3-dev # Required
sudo apt install vim 
~~~~

### Installing CUDA ###    

8. Now you need to download the CUDA 11 runtime from NVIDIA. SSH into your AWS instance and run the following:

~~~~
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
sudo apt-get update
sudo apt-get -y install cuda
~~~~ 
 
9. `nvcc` is the NVIDIA CUDA compiler. The default install locates CUDA binaries in `/usr/local/cuda/bin/`, so you'll want to add this directory to your path.  For example, from a bash shell that would be:

~~~~
export PATH=$PATH:/usr/local/cuda/bin
~~~~    

In general we recommend that you perform this `$PATH` update on login, so you can add this line to the end of your `.bashrc` file.  Don't forget to `source .bashrc` if you want to have this modification take effect without logging out and back in to the instance.

### Confirming that CUDA has been installed ###

10. Suppose you have carried out steps 7-9 or run the __install.sh__ script. At this point CUDA should be installed and you should be able to run the `nvidia-smi` command to make sure everything is setup correctly.  The result of the command should indicate that your VM has one NVIDIA K80 GPU.

~~~~
ubuntu@ip-172-31-20-116:~/asst3$ nvidia-smi 
Fri Oct 22 18:08:14 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 495.29.05    Driver Version: 495.29.05    CUDA Version: 11.5     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Tesla T4            Off  | 00000000:00:1E.0 Off |                    0 |
| N/A   50C    P0    27W /  70W |      0MiB / 15109MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
~~~~

If you're confused about any of the steps, having problems with setting up your account or have any additional questions, reach us out on Piazza!

### Cloning the assignment ###

11. Clone the repository with the following command: `git clone https://github.com/stanford-cs149/asst3.git`.

### Fetching your code from AWS ###

12. Once you've completed your assignment, you can retrieve your code by running the following:
~~~~
scp -i path/to/key_name.pem ubuntu@<public_dns_name>:/path/to/file /path/to/local_file
~~~~

### Stopping the VM ###

13. You can stop the VM by navigating to the instance page, clicking "Instance state", and then selecting "Stop instance".
![Stop instance](handout/stop_instance.png?raw=true)

Note that terminating the instance will delete the instance and all associated files. Instances can be stopped in the AWS web console or by running `sudo shutdown -P now` while logged in.

If you're confused about any of the steps, having problems with setting up your account or have any additional questions, reach out to us on Ed!

__Again, please don't forget to SHUT DOWN your instances when you're done with your work for the day!__


### AWS Setup Trouble Shooting
1. If you received an error message stating that you are not able to launch additional resources in this region, AWS will validate your request. The validation process should take around 20 minutes. If that is not the case, please email AWS at aws-verification@amazon.com.
![Unavailable Region](handout/location_limit.png?raw=true)

2. If you received and error message stating that you have requested more vCPU capacity than your current limit, please check your quota.
![Quota Navigation Bar](handout/vCPU_trouble.png?raw=true)
![Quota Dashboard](handout/vCPU_dashboard.png?raw=true)
![Quota Dashboard Search](handout/vCPU_dashboard_2.png?raw=true)
If your Applied quota value is less than 4, please submit a request for quota increase and put 4 as your requested number of vCPUs.
![Quota Request](handout/quota_request.png?raw=true)