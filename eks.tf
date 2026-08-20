#using predefined iam roles

provider "aws" {
  region = "eu-north-1"
}


data "aws_iam_role" "cluster" {
  name = "AmazonEKSClusterRole"
}

resource "aws_iam_role_policy_attachment" "ekspolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = data.aws_iam_role.cluster.name
}

resource "aws_eks_cluster" "ekseg" {
  name     = "eksexample"
  role_arn = data.aws_iam_role.cluster.arn

 access_config {
    authentication_mode = "API"
  }


  vpc_config {
    subnet_ids = [
      "subnet-id1",
      "subnet-id2",
      "subnet-id3",
    ]
  }

  
  depends_on = [
    aws_iam_role_policy_attachment.ekspolicy,
  ]
}

data "aws_iam_role" "node" {
  name = "node-role"   
}

resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.ekseg.name
  node_group_name = "example"
  node_role_arn   = data.aws_iam_role.node.arn
  subnet_ids      = aws_eks_cluster.ekseg.vpc_config[0].subnet_ids

  instance_types = ["t3.micro"]

  scaling_config {
    min_size     = 1
    max_size     = 1
    desired_size = 1
  }
}
