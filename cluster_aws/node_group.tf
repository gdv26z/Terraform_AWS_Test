resource "aws_eks_node_group" "worker-node-group" {
  cluster_name    = aws_eks_cluster.devopsthehardway-eks.id
  node_group_name = "alexey-workernodes"
  node_role_arn   = aws_iam_role.workernodes.arn
  subnet_ids      = [aws_subnet.public-subnet-1a.id, aws_subnet.public-subnet-2b.id]
  instance_types  = ["t2.micro"]

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
