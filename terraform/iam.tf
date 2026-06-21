# 信頼ポリシー
resource "aws_iam_role" "ec2-iam" {
    name = "ec2_iam"
    assume_role_policy = jsonencode ({
        Version = "2012-10-17"
        Statement [{
            Effect = "Allow"
            Principal = {
                Service =
             }
                Action = "sts:AssumeRole"
            }]
        })
    }

# 権限ポリシー
resource "aws_iam_role_policy_attachment" "ec2-iam" 

# instance_profile
resource "aws_iam_instance_profile" "ec2-iam"