resource "tls_private_key" "app_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
