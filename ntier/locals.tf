locals{
    mysql_port = 3306
    tcp = "tcp" 
    anywhere = "0.0.0.0/0" 
    az_a = format("%sa", var.region)
    az_b = format("%sb", var.region)
    db_subnet_1 = 1
    db_subnet_2 = 1
    app_subnet_1 = 0
    app_subnet_2 = 0
    web_subnet_1 = 0
    web_subnet_2 = 1
    db_name= "myrdsdbfromtf"
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
