resource "aws_eks_cluster" "devopsthehardway-eks" {
  name     = "devopsthehardway-cluster"
  role_arn = aws_iam_role.eks-iam-role.arn

  vpc_config {
    subnet_ids = [aws_subnet.public-subnet-1a.id, aws_subnet.private-subnet-1.id, aws_subnet.public-subnet-2b.id]
  }

  depends_on = [
    aws_iam_role.eks-iam-role,
  ]
}
