variable "region" {
    type = string
    default = "us-west-2" 
}

variable "workspace" {
    type = string
    default = "Dev"
}

######################################### S3
variable "bucketname" {
    type = string
    description = "creating s3 bucket from aws-cloud"
    default = "s3-bucket-fromtf"
}

variable "buckettagName" {
    type = string
    default = "s3 bucket" 
}

###################################### VPC2

variable "cidr_block2" {
    type = string
    description = "creating second vpc from aws-cloud"
    default =   "192.168.0.0/16"
}

variable "vpc2Nametag" {
    type = string
    default = "vpc2fromtf"
}

###################################### PRIVATE and PUBLIC SUBNETS-VPC2

variable "privsubnametags-vpc2" {
   type = list(string)
   default = [ "app1","db1" ]
}

variable "privsubnametags-azb" {
   type = list(string)
   default = [ "app2","db2" ]
}

variable "pubsubnametags-vpc2" {
   type = list(string)
   default = [ "web1","web2"]
}

####################################SECURITYGROUP FOR DB-RDS,APP,WEB

variable "secgrnamefordb" {
    type = string
    default = "mysqlopen"
}

variable "secgrforapp" {
    type = string
    default = "secgroup-appinstances"
}

variable "secgrforweb" {
    type = string
    default = "secgroup-webinstances"
}

#################################### DBSUBNET GROUP

variable "dbsubnetgroupname" {
    type = string
    default = "dbsubgroupfromtf" 
  
}

################################### app instance 

#variable "ami-id" {
#    type = string
#    description = "ami of amazon linux 2 AMI"
#    default = "ami-0f1c525b28db4d93e"
#  }

#variable "appinstancename" {
#    type = "string"
#    default = "app1"
  
#}

#variable "appinstancename2" {
#    type = "string"
#    default = "app2"
#}

variable "appinstancedetails" {
    type = object ({
        ami-id = string
        name1= string
        name2= string
    })
    default = {
        ami-id = "ami-076bca9dd71a9a578"
        name1= "app1"
        name2= "app2"
    }
}
################################## web instance
#variable "webinstancename" {
#    type = "string"
#    default = "web1"
#  
#}

#variable "webinstancename2" {
#    type = "string"
#    default = "web2"
#}

variable "webinstancedetails" {
    type = object ({
        ami-id = string
        name1= string
        name2= string
    })
    default = {
        ami-id = "ami-076bca9dd71a9a578"
        name1= "web1"
        name2= "web2"
    }
}




