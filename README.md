## To install terraform

```sh
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl && curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list && sudo apt-get update && sudo apt-get install -y terraform
```


## Now to configure the terraform and aws 

```sh
apt install awscli -y
```


```sh
aws configure
```

## Assign your access key and secret access key


## To run any terraform file

```sh
terraform init
```

```sh
terraform plan
```

```sh
terraform apply --auto-approve
```

## to delete any resource
```sh
terraform destroy
```
