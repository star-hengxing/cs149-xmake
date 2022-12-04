# AWS Setup Instructions #

For performance testing, you will need to run your code on a VM instance on Amazon Web Services (AWS). We've already sent you student coupons that you can use for billing purposes. Here are the steps for how to get setup for running on AWS.

NOTE: __Please don't forget to SHUT DOWN your instances when you're done for the day to avoid burning through credits overnight!__

### Creating a VM with 32 vCPU ###
      
1. Navigate to your "Instances" page in AWS by selecting the correct link in the left hand menu.
![Instance Page](handout/instance_nav.png?raw=true)

2. Click on the button that says `Launch Instances`. Choose the `Ubuntu Server 20.04 LTS (HVM), SSD Volume Type` AMI:
![AMI Selection](handout/AMI.png?raw=true)

3. Choose the `m5.8xlarge` Instance Type
![instance](handout/instance_type.png?raw=true)

4. Next, under `Key pair (login)`, choose a key pair. You can use the same key pair from assignment 3. Alternatively, you can create a new one. To create a new one, click `Create new key pair` and give it whatever name you'd like. This will download a keyfile to your computer called `<key_name>.pem` which you will use to login to the VM instance you are about to create.
![Key Pair](handout/new_key_pair.png?raw=true)

5. Scroll down to `Configure storage` and change the size of the `Root volume` to 100 GiB to accomodate the packages we will need to install to make the instance functional for the assignment.
![Storage](handout/storage.png?raw=true)

6. Once you've done all previous steps, scroll to the bottom and click `Launch instance`

__Note: `m5.8xlarge` instances cost $1.792 / hour, so leaving one running for a whole day will consume $43 worth of your AWS coupon.__

7. Now that you've created your VM, you should be able to __SSH__ into it. You need the public IP address to SSH into it, which you can find on the instance page by clicking the `View All Instances` button on the current page and then the instance ID for your created instance (note, it may take a moment for the instance to startup and be assigned an IP address):
![IP Address](handout/ip_address.png?raw=true)
Once you have the IP address, you can login to the instance by running this command:
~~~~
ssh -i path/to/key_name.pem ubuntu@<public_ip_address>
~~~~

8. Once you SSH into your VM instance, you'll want to install whatever software you need to make the machine a useful development environment for you.  For example we recommend:
~~~~
sudo apt update
sudo apt install emacs25
sudo apt install make
sudo apt install g++
~~~~

If you're confused about any of the steps, having problems with setting up your account or have any additional questions, reach us out on Ed!
  
__Again, please don't forget to SHUT DOWN your instances when you're done with your work for the day!__
