resource "aws_s3_bucket" "tekuchi_bucket" {
  bucket = "tekuchi-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  force_destroy = true
  tags = {
    Name        = "tekuchi_bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_public_access" {
  bucket = aws_s3_bucket.tekuchi_bucket.id
    block_public_policy     = false
}

resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.tekuchi_bucket.id
  policy =  <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "*",
            "Resource": "arn:aws:s3:::tekuchi-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
        },
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "*",
            "Resource": "arn:aws:s3:::tekuchi-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}/*"
        }
    ]
}
EOF

}
