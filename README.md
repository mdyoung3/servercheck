This bash script is to be run on your local Mac with a cronjob.

To run the cronjob, open crontab in the shell. 
crontab -e

In the crontab editor, insert the following to run the script every minute. 
* * * * * sh directory/servercheck.sh

That's it. You can check the output file to see when and if the server went down.


