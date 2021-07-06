# Awslamba Golang Runtime
Custom Golang runtime for the execution of AWS Lambdas, this is a modification of the custom runtime of [lambdaci](https://github.com/lambci/docker-lambda) (Thank you guys!)

This custom runtime avoids using the **/var** folder as main place where to locate other files and the this project also includes the mockserver binary.
