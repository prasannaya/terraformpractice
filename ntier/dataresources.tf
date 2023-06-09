### To get the default vpcid of the default vpc

data "aws_vpc" "default-vpcid" {
    default = true
}

output "defaultvpcid" {
    value = data.aws_vpc.default-vpcid.id    
}

### to get all private subnets in vpc

data "aws_subnets" "privsubnetids" {
        
    filter {
           name   = "vpc-id"
           values = [aws_vpc.my_vpc_second.id]
    }
    tags = {
        Tier = "private"
    }
}
    
output "privsubnetids" {
    value = toset(data.aws_subnets.privsubnetids.ids)
}
#output "privsubcount"{
#    value = length(toset(data.aws_subnets.privsubnetids.ids))
#}


### to get all pub subnets in vpc

data "aws_subnets" "pubsubnetids" {
    
    filter {
        name   = "vpc-id"
        values = [aws_vpc.my_vpc_second.id]
    }
    tags = {
        Tier = "public"   
    }
}
output "pubsubnetids" {
    value = toset(data.aws_subnets.pubsubnetids.ids)
}