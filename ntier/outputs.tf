output "s3bucketname" {
    value = aws_s3_bucket.my_s3.id
}

output "vpcid" {
    value= aws_vpc.my_vpc_second.id
}

output "secgrpidrds" {
    value = aws_security_group.my_rds_sg1.id
}

output "secgrpidapp" {
    value = aws_security_group.my_app_sg1.id
}

output "secgrpidweb" {
    value = aws_security_group.my_web_sg1.id
}
