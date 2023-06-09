#creating s3-bucket
resource "aws_s3_bucket" "my_s3" {
    bucket = var.bucketname
    tags = {
        "Name" = var.buckettagName
        "Environment" = var.workspace
    }
}

# creating vpc

resource "aws_vpc" "my_vpc_second" {
    cidr_block = var.cidr_block2
    tags = {
        "Name" = var.vpc2Nametag
        "Environment" = var.workspace
    }
}

#creating 2 private subnets - availability zone a

resource "aws_subnet" "my_privsubnets_vpc2" {
    count = length(var.privsubnametags-vpc2)
    availability_zone = local.az-a
    cidr_block = cidrsubnet(var.cidr_block2, 8, count.index)
    vpc_id = aws_vpc.my_vpc_second.id                               
    tags = {
         "Name" = var.privsubnametags-vpc2[count.index]
         "Tier" = "private"
    }
    depends_on = [
        aws_vpc.my_vpc_second                                        
    ]
}

#creating 2 more private subnets - availability zone b

resource "aws_subnet" "my_privsubnets_azb" {
    count = length(var.privsubnametags-azb)
    availability_zone = local.az-b
    cidr_block = cidrsubnet(var.cidr_block2, 8, (count.index + length(var.privsubnametags-vpc2)))
    vpc_id = aws_vpc.my_vpc_second.id                               
    tags = {
         "Name" = var.privsubnametags-azb[count.index]
         "Tier" = "private"
    }
    depends_on = [
        aws_vpc.my_vpc_second                                        
    ]
}

#creating 2 public subnets

resource "aws_subnet"  "my_pubsubnets_vpc2" {
    count = length(var.pubsubnametags-vpc2)
    availability_zone = local.az-b
    cidr_block = cidrsubnet(var.cidr_block2, 8, (count.index + length(var.privsubnametags-vpc2)+ length(var.privsubnametags-azb)))
    vpc_id = aws_vpc.my_vpc_second.id                              
    tags = {
         "Name" = var.pubsubnametags-vpc2[count.index]
         "Tier" = "public"
    }

    depends_on = [
        aws_vpc.my_vpc_second 
    ]
}

#creating security groups for db1,db2

resource "aws_security_group" "my_rds_sg1" {
    description = "security group for rds by terraform"
    name = var.secgrnamefordb
    ingress  {
        cidr_blocks = [local.anywhere]
        description = var.secgrnamefordb
        from_port = local.mysql_port
        to_port = local.mysql_port
        protocol = local.tcp  
    }
    tags = {
        "Name" = var.secgrnamefordb
    }  
    vpc_id = aws_vpc.my_vpc_second.id
}

#creating db subnet group --- all subnets designated for db instances

resource "aws_db_subnet_group" "my_dbsubnet_grp" {
    name = var.dbsubnetgroupname
    description = "all subnets designated for db instance"
    subnet_ids = [ aws_subnet.my_privsubnets_vpc2[local.db-subnet-1].id , aws_subnet.my_privsubnets_azb[local.db-subnet-2].id ]
    tags = {
           "Name"  = var.dbsubnetgroupname
    }

}

# creating db instances

resource "aws_db_instance" "my_db_instances" {
    allocated_storage = local.storage
    db_name = local.db-name
    db_subnet_group_name = aws_db_subnet_group.my_dbsubnet_grp.name
    engine = local.engine
    engine_version = local.engine_version
    instance_class = local.instance_class
    password = local.password
    username = local.username
    vpc_security_group_ids = [aws_security_group.my_rds_sg1.id]
    skip_final_snapshot = true
    depends_on = [ 
#        aws_vpc.aws_vpc.my_vpc_second,
        aws_subnet.my_privsubnets_vpc2,
        aws_subnet.my_privsubnets_azb
     ]
}

# creating security group for app1,app2

resource "aws_security_group" "my_app_sg1" {
    description = "security group for appliication instances by terraform"
    name = var.secgrforapp
    vpc_id = aws_vpc.my_vpc_second.id

    ingress  {
        cidr_blocks = [local.anywhere]
        description = "open ssh"
        from_port = local.ssh_port
        to_port = local.ssh_port
        protocol = local.tcp  
    }

    ingress  {
        cidr_blocks = [local.anywhere]
        description = "open app port"
        from_port = local.app_port
        to_port = local.app_port
        protocol = local.tcp  
    }

    tags = {
        "Name" = var.secgrforapp
    }  

    depends_on = [ 
        aws_vpc.my_vpc_second
     ]
}

# creating app instance -1

resource "aws_instance" "my_app1_ec2" {
    ami = var.appinstancedetails.ami-id
    associate_public_ip_address = true
    instance_type = local.inst_type
    key_name = "my_id"
    vpc_security_group_ids = [aws_security_group.my_app_sg1.id]
    subnet_id = aws_subnet.my_privsubnets_vpc2[local.app-subnet-1].id
    tags = {
      "Name" = var.appinstancedetails.name1
    }

    depends_on = [ 
#        aws_vpc.my_vpc_second,
        aws_subnet.my_privsubnets_vpc2,
        aws_security_group.my_app_sg1
     ]
}

# creating app instance -2

resource "aws_instance" "my_app2_ec2" {
    ami = var.appinstancedetails.ami-id
    associate_public_ip_address = true
    instance_type = local.inst_type
    key_name = "my_id"
    vpc_security_group_ids = [aws_security_group.my_app_sg1.id]
    subnet_id = aws_subnet.my_privsubnets_azb[local.app-subnet-2].id
    tags = {
      "Name" = var.appinstancedetails.name2
    }

    depends_on = [ 
#        aws_vpc.my_vpc_second,
        aws_subnet.my_privsubnets_azb,
        aws_security_group.my_app_sg1
     ]
}

# creating security group for web1,web2

resource "aws_security_group" "my_web_sg1" {
    description = "security group for web instances by terraform"
    name = var.secgrforweb
    vpc_id = aws_vpc.my_vpc_second.id

    ingress  {
        cidr_blocks = [local.anywhere]
        description = "open ssh"
        from_port = local.ssh_port
        to_port = local.ssh_port
        protocol = local.tcp  
    }

    ingress  {
        cidr_blocks = [local.anywhere]
        description = "open http"
        from_port = local.http_port
        to_port = local.http_port
        protocol = local.tcp  
    }

    egress  {
        cidr_blocks = [local.anywhere]
        from_port = 0
        to_port = 0
        protocol = "-1"
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        "Name" = var.secgrforweb
    }  

    depends_on = [ 
        aws_vpc.my_vpc_second
     ]
}

# creating web instance -1

resource "aws_instance" "my_web1_ec2" {
    ami = var.webinstancedetails.ami-id
    associate_public_ip_address = true
    instance_type = local.inst_type
    key_name = "my_id"
    vpc_security_group_ids = [aws_security_group.my_web_sg1.id]
    subnet_id = aws_subnet.my_pubsubnets_vpc2[local.web-subnet-1].id
    tags = {
      "Name" = var.webinstancedetails.name1
    }

    depends_on = [ 
#        aws_vpc.my_vpc_second,
        aws_subnet.my_pubsubnets_vpc2,
        aws_security_group.my_web_sg1
     ]
}
# creating web instance -2

resource "aws_instance" "my_web2_ec2" {
    ami = var.webinstancedetails.ami-id
    associate_public_ip_address = true
    instance_type = local.inst_type
    key_name = "my_id"
    vpc_security_group_ids = [aws_security_group.my_web_sg1.id]
    subnet_id = aws_subnet.my_pubsubnets_vpc2[local.web-subnet-2].id
    tags = {
      "Name" = var.webinstancedetails.name2
    }

    depends_on = [ 
#        aws_vpc.my_vpc_second,
        aws_subnet.my_pubsubnets_vpc2,
        aws_security_group.my_web_sg1
     ]
}










