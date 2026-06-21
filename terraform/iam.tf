# Trust_policy
resource "aws_iam_role" "ec2-iam" {
    name = "ec2_iam"
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
resource "aws_iam_role_policy_attachment" "ec2-iam" 
    assume_role_policy = jsonencode ({
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