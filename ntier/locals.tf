locals{
    mysql_port = 3306
    tcp = "tcp" 
    anywhere = "0.0.0.0/0" 
    az-a = format("%sa", var.region)
    az-b = format("%sb", var.region)
    db-subnet-1 = 1
    db-subnet-2 = 1
    app-subnet-1 = 0
    app-subnet-2 = 0
    web-subnet-1 = 0
    web-subnet-2 = 1
    db-name= "myrdsdbfromtf"
    storage = 20
    engine = "mysql"
    engine_version = "5.7"
    instance_class = "db.t2.micro"
    password = "rootyashwik"
    username = "rootroot2022"
    ssh_port = 22
    app_port = 23000
    http_port = 80
    inst_type = "t2.micro"


}