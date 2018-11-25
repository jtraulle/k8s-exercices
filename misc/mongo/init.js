use admin
var admin = { user: 'lucj', pwd: 'LUCJK8SEx0', roles: [ { role: "userAdminAnyDatabase", db: "admin" } ] };
var user = { user: "k8sExercice", pwd: "k8sExercice", roles : [ { role: "readWrite", db: "message" } ]}

db.createUser(admin)

db.auth('lucj','LUCJK8SEx0')
db.createUser(user)
