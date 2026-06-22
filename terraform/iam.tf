# Trust_policy
resource "aws_iam_role" "ec2-role" {
    name = "ec2_role"
    assume_role_policy = jsonencode ({
        Version = "2012-10-17"
        Statement [{
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
             }
                Action = "sts:AssumeRole"
            }]
        })
    }

# Permission_policy
resource "aws_iam_policy" "ec2-policy" 
name = "ec2_policy"
policy = jsonencode ({
        Version = "2012-10-17"
        Statement [{
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
             }
                Action = ""
            }]
        })
    }

# instance_profile
resource "aws_iam_instance_profile" "ec2-iam"
