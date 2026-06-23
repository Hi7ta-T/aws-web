# role
resource "aws_iam_role" "ec2-role" {
    name = "ec2_role"
    assume_role_policy = jsonencode ({
        Version = "2012-10-17"
        Statement = [
            {
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
             }
                Action = "sts:AssumeRole"
            }
        ]
        })
    }

# policy = AWS標準ポリシー
# attachment
resource "aws_iam_role_policy_attachment" "ec2-iam" {
    role = aws_iam_role.ec2-role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }

# instance_profile
resource "aws_iam_instance_profile" "ec2-profile" {
    name = "ec2_instance"
    role = aws_iam_role.ec2-role.name
    }
