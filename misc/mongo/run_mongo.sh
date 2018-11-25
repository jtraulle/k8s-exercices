# Create cert/key
openssl req -newkey rsa:2048 -new -x509 -days 365 -nodes -out mongodb-cert.crt -keyout mongodb-cert.key
cat mongodb-cert.key mongodb-cert.crt > mongodb.pem

# Run mongo
docker run --name mongodb \
           -d \
           -p 27017:27017 \
           -v $PWD/mongodb.pem:/etc/ssl/mongodb.pem \
           mongo:3.6 --sslMode requireSSL --sslPEMKeyFile /etc/ssl/mongodb.pem --auth

# Run shell inside container
docker exec -ti mongodb bash

# Run mongo with options for self-signed certificates
mongo --ssl --sslAllowInvalidCertificates --sslAllowInvalidHostnames

# Create users
use admin
var admin = { user: 'lucj', pwd: 'LUCJK8SEx0', roles: [ { role: "userAdminAnyDatabase", db: "admin" } ] };
var user = { user: "k8sExercice", pwd: "k8sExercice", roles : [ { role: "readWrite", db: "message" } ]}

db.createUser(admin)

db.auth('lucj','LUCJK8SEx0')
db.createUser(user)

export MONGODB_URL="mongodb://k8sExercice:k8sExercice@localhost:27017/message?ssl=true&authSource=admin"
export MONGODB_URL="mongodb://k8sExercice:k8sExercice@db.techwhale.io:27017/message?ssl=true&authSource=admin"

# Test
mongo db.techwhale.io:27017/message --authenticationDatabase admin -u k8sExercice -p k8sExercice --sslAllowInvalidCertificates --ssl
