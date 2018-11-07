docker run -d -p 27017:27017 -v /home/$USER/mongo/3.4/dataS0/R0/:/data/db/ -v /home/$USER/mongo/3.4/logsS0/R0/:/logs/ --name=mongodb_S0R0 advillalba/mongodb:3.4 mongod --bind_ip 0.0.0.0 -vv --port 27017 --replSet s0  --shardsvr 
docker run -d -p 27018:27017 -v /home/$USER/mongo/3.4/dataS0/R1/:/data/db/ -v /home/$USER/mongo/3.4/logsS0/R1/:/logs/ --name=mongodb_S0R1 advillalba/mongodb:3.4 mongod --bind_ip 0.0.0.0 -vv --port 27017 --replSet s0  --shardsvr
docker run -d -p 27029:27017 -v /home/$USER/mongo/3.4/dataS0/R2/:/data/db/ -v /home/$USER/mongo/3.4/logsS0/R2/:/logs/ --name=mongodb_S0R2 advillalba/mongodb:3.4 mongod --bind_ip 0.0.0.0 -vv --port 27017 --replSet s0  --shardsvr
sleep 2
echo "Configuring s0 replica set"
mongo << 'EOF'
config = { _id: "s0", members:[
          { _id : 0, host : "172.17.0.2:27017" },
          { _id : 1, host : "172.17.0.3:27017" },
          { _id : 2, host : "172.17.0.4:27017" }]};
rs.initiate(config)
EOF

docker run -d -p 27021:27017 -v /home/$USER/mongo/3.4/dataS1/R0/:/data/db/ -v /home/$USER/mongo/3.4/logsS1/R0/:/logs/ --name=mongodb_S1R0 advillalba/mongodb:3.4 mongod --bind_ip 0.0.0.0 -vv --port 27017  --replSet s1  --shardsvr
docker run -d -p 27022:27017 -v /home/$USER/mongo/3.4/dataS1/R1/:/data/db/ -v /home/$USER/mongo/3.4/logsS1/R1/:/logs/ --name=mongodb_S1R1 advillalba/mongodb:3.4 mongod --bind_ip 0.0.0.0 -vv --port 27017  --replSet s1  --shardsvr
docker run -d -p 27023:27017 -v /home/$USER/mongo/3.4/dataS1/R2/:/data/db/ -v /home/$USER/mongo/3.4/logsS1/R2/:/logs/ --name=mongodb_S1R2 advillalba/mongodb:3.4 mongod --bind_ip 0.0.0.0 -vv --port 27017  --replSet s1  --shardsvr
sleep 2
echo "Configuring s1 replica set"
mongo --port 27021 << 'EOF'
config = { _id: "s1", members:[
          { _id : 0, host : "172.17.0.5:27017" },
          { _id : 1, host : "172.17.0.6:27017" },
          { _id : 2, host : "172.17.0.7:27017" }]};
rs.initiate(config)
EOF

docker run -d -p 27024:27017 -v /home/$USER/mongo/3.4/dataS2/R0/:/data/db/ -v /home/$USER/mongo/3.4/logsS2/R0/:/logs/ --name=mongodb_S2R0 advillalba/mongodb:3.4 mongod --bind_ip 0.0.0.0 -vv --port 27017  --replSet s2  --shardsvr
docker run -d -p 27025:27017 -v /home/$USER/mongo/3.4/dataS2/R1/:/data/db/ -v /home/$USER/mongo/3.4/logsS2/R1/:/logs/ --name=mongodb_S2R1 advillalba/mongodb:3.4 mongod --bind_ip 0.0.0.0 -vv --port 27017  --replSet s2  --shardsvr
docker run -d -p 27026:27017 -v /home/$USER/mongo/3.4/dataS2/R2/:/data/db/ -v /home/$USER/mongo/3.4/logsS2/R2/:/logs/ --name=mongodb_S2R2 advillalba/mongodb:3.4 mongod --bind_ip 0.0.0.0 -vv --port 27017  --replSet s2  --shardsvr
sleep 2
echo "Configuring s2 replica set"
mongo --port 27024 << 'EOF'
config = { _id: "s2", members:[
          { _id : 0, host : "172.17.0.8:27017" },
          { _id : 1, host : "172.17.0.9:27017" },
          { _id : 2, host : "172.17.0.10:27017" }]};
rs.initiate(config)
EOF

docker run -d -p 27027:27017 -v /home/$USER/mongo/3.4/dataC0/R0/:/data/db/ -v /home/$USER/mongo/3.4/logsC0/R0/:/logs/ --name=mongodb_C0R0 advillalba/mongodb:3.4 mongod --bind_ip 0.0.0.0 -vv --port 27017 --dbpath /data/db --replSet csReplSet --configsvr
docker run -d -p 27028:27017 -v /home/$USER/mongo/3.4/dataC1/R0/:/data/db/ -v /home/$USER/mongo/3.4/logsC1/R0/:/logs/ --name=mongodb_C1R0 advillalba/mongodb:3.4 mongod --bind_ip 0.0.0.0 -vv --port 27017 --dbpath /data/db --replSet csReplSet --configsvr
docker run -d -p 27029:27017 -v /home/$USER/mongo/3.4/dataC2/R0/:/data/db/ -v /home/$USER/mongo/3.4/logsC2/R0/:/logs/ --name=mongodb_C2R0 advillalba/mongodb:3.4 mongod --bind_ip 0.0.0.0 -vv --port 27017 --dbpath /data/db --replSet csReplSet --configsvr

sleep 2
echo "Configuring configuration server replica set"
mongo --port 27027 << 'EOF'
config = { _id: "csReplSet", members:[
          { _id : 0, host : "172.17.0.11:27017" },
          { _id : 1, host : "172.17.0.12:27017" },
          { _id : 2, host : "172.17.0.13:27017" }]};
rs.initiate(config)
EOF

docker run -d -p 27017:27017 -v /home/$USER/mongo/3.4/dataServ0/R0/:/data/db/ -v /home/$USER/mongo/3.4/logsServ0/R0/:/logs/ --name=mongodb_Serv0R0 advillalba/mongodb:3.4 mongos --bind_ip 0.0.0.0 -vv --port 27017 --configdb csReplSet/172.17.0.11:27017,172.17.0.12:27017,172.17.0.13:27017

echo "Waiting 60 seconds for the replica sets to fully come online"
sleep 60
echo "Connnecting to mongos and enabling sharding"

# add shards and enable sharding on the test db
mongo <<'EOF'
use admin
db.runCommand( { addshard : "s0/172.17.0.2:27017" } );
db.runCommand( { addshard : "s1/172.17.0.5:27017" } );
db.runCommand( { addshard : "s2/172.17.0.8:27017" } );
db.runCommand( { enableSharding: "school" } );
db.runCommand( { shardCollection: "school.students", key: { student_id:1 } } );
EOF







