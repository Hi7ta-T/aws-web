# Role
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

# Policy = AWS標準ポリシー
# attachment
resource "aws_iam_role_policy_attachment" "ec2-iam"
