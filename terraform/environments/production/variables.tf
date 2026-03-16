variable "aws_region" {
  description = "The AWS region to deploy infrastructure"
  type        = string
  default     = "ap-south-2"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "zoom-clone-production"
}
