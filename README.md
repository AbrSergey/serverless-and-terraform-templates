# **Contents**

It is **template** for create application with Serverless framework and Node.js for AWS provider.

In folder **serverless** you can find terraform scripts for create AWS services automatically.

## **Details**

Infrastructure of project consists of serverless and terraform configs:

- **serverless**: for api gateway (REST protocol) and lambda handlers
- **terraform**: for VPC, RDS (PostgreSql), S3, Cloudfront, Cognito, ElasticSearch and Dynamodb.

## **Start project steps**

For start the project you need install to your computer:

- serverless https://www.serverless.com/framework/docs/getting-started/
- terraform https://www.terraform.io/downloads.html

After install this packages, open terminal and will do the following steps:

2. go to _terraform/dev_
3. create S3 bucket manually through AWS Console for store terraform state versions
4. execute command _terraform init_
5. execute command _terraform apply_ (don't forget confirm actions with type word _yes_)
6. go to root folder execute command _serverless deploy --stage dev_
7. open AWS console and go to S3 service -> _your-app-dev-website-{random}_ -> _permissions_ -> _ACL_ -> _edit_ -> delete check box near _List_
8. Congratulations! :smiley: It must work! :pray:

**Note:** in file _terraform/dev/variables.tf_ you can change settings. For example service_name or db_instance.

# **Useful commands**

## **Serverless commands**

`sls offline start` - for run on local machine.

`sls deploy` - for deploy.

`function sls deploy function -f functionHelloWorld` - for deploy specific.

`sls remove` - delete all lambdas

`sls prune -n 10` - for delete old versions

`sls logs -f functionHelloWorld` - get logs of lambda

## **Terraform commands**

`terraform init` - init all dependencies

`terraform plan` - check for new changes

`terraform apply` - deploy changes

`terraform destroy` - delete all services