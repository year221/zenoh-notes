# Basic Example for Publisher, Subscriber and Query from a storage. 

The code in this folder include
1. Makefile to start zenoh with configuration file in `cfg/zenoh-myhome.json5` which add a storage at `/myhome/kitchen/temp`


Note: I initially try to set up a docker image with zenoh a peer for storage manager but I could not yet overcome the problem that docker does not support UDP multicast. spin up, stop and clean a docker container running zenoh with 
```
make start
```

- Testing the existence of a storage at `http://localhost:8000/myhome`

Putting a value
```
curl -X PUT -H 'content-type:text/plain' -d 'Hello World!' http://localhost:8000/myhome/test
```
Query the value
```
curl http://localhost:8000/myhome/test
```
This should return
```
[{"key":"myhome/test","value":"Hello World!","encoding":"text/plain","timestamp":*****}]
```

2. publisher to topic 'myhome/kitchen/temp'
```
python publisher.py
```
3. subscriber to 'myhome/kitchen/temp'
```
python subscriber.py
```

4. retrieve value in 'myhome/kitchen/temp'
```
python retrieve. py
```