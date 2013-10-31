cd ~/gene2/

echo 'Stopping BgDRB' ;
ruby ./script/backgroundrb stop;

if [ -f 'log/mongrel.pid' ] ; then
  echo 'Mongrel PID found' ;
  kill -USR2 `cat log/mongrel.pid`;
else
  echo 'Starting Mongrel on port 9899 in prod' ;
  mongrel_rails start -d -e production -p 9899;
fi

echo 'Starting BgDRB' ;
ruby ./script/backgroundrb start -e production