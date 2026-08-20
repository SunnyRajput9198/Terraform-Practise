resource "aws_s3_bucket" "remote_s3" {
    bucket = "tws-junoon-state-bucket-sunny-2026"

    tags = {
        Name = "tws-junoon-state-bucket-sunny-2026"
    }
}