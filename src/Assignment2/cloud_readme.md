# AWS Setup Instructions #

For performance testing, you will need to run this assignment on a VM instance on Amazon Web Services (AWS). We've already sent you student coupons that you can use for billing purposes. Here are the steps for how to get setup for running on AWS.

NOTE: __Please don't forget to SHUT DOWN your instances when you're done for the day to avoid burning through credits overnight!__

### Creating a VM ###

1. Now you're ready to create a VM instance. Log in to the [AWS EC2 dashboard](https://us-west-2.console.aws.amazon.com/ec2/home?region=us-west-2#Home) for the `us-west-2` region and click on the button that says `Launch instance`.
![Launch instance](figs/launch_instance.png?raw=true)

2. Choose the `Ubuntu Server 22.04 LTS (HVM), SSD Volume Type` AMI:
![Ubuntu](figs/ubuntu.png?raw=true)

3. Choose the `m6i.2xlarge` instance type.
![Instance type](figs/instance_type.png?raw=true)

4. Change the size of the volume to 64 GB to accomodate the packages we will need to install to make the instance functional for the assignment:
![Storage](figs/storage.png?raw=true)

5. AWS will ask you to select a key pair. Click the first dropdown and choose `Create a new key pair` and give it whatever name you'd like. This will download a keyfile to your computer called `<key_name>.pem` which you will use to login to the VM instance you are about to create. Finally, you can launch your instance.
![Key Pair](figs/new_key_pair.png?raw=true)

__Note: `m6i.2xlarge` instances cost $0.384 / hour, so leaving one running for a whole day will consume $9.216 worth of your AWS coupon. Remmeber to shut off the instance when you're not using it!__

6. Now that you've created your VM, you should be able to __SSH__ into it. You need the public IPv4 DNS name to SSH into it, which you can find by navigating to your instance's page and then clicking the `Connect` button, followed by selecting the SSH tab (note, it may take a moment for the instance to startup and be assigned an IP address):
![Connect](figs/connect.png?raw=true)

Make sure you follow the instructions to change the permissions of your key file by running `chmod 400 path/to/key_name.pem`.
Once you have the IP address, you can login to the instance by running this command:
~~~~
ssh -i path/to/key_name.pem ubuntu@<public_dns_name>
~~~~

### Setting up the VM environment ###

7. Once you SSH into your VM instance, you'll want to install whatever software you need to make the machine a useful development environment for you.  For example we recommend:
~~~~
sudo apt-get update
sudo apt-get install make g++ python3 # Required
sudo apt-get install vim
~~~~


8. Clone the repository with the following command: `git clone https://github.com/stanford-cs149/asst2.git`.


### Fetching your code from AWS ###

9. Once you've completed your assignment, you can retrieve your code by running the following:
~~~~
scp -i path/to/key_name.pem ubuntu@<public_dns_name>:/path/to/file /path/to/local_file
~~~~

### Stopping the VM ###

10. You can stop the VM by navigating to the instance page, clicking "Instance state", and then selecting "Stop instance".
![Stop instance](figs/stop_instance.png?raw=true)

Note that terminating the instance will delete the instance and all associated files. Instances can be stopped in the AWS web console or by running `sudo shutdown -P now` while logged in.

If you're confused about any of the steps, having problems with setting up your account or have any additional questions, reach out to us on Ed!

__Again, please don't forget to STOP your instances when you're done with your work for the day!__

### Performance leaderboard ###

We plan on releasing a leaderboard for you to submit your code to which will compare the top-performing solutions. For assignment 2 this will just be for fun, but stay tuned for more updates on Ed!
