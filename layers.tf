resource "aws_lambda_layer_version" "yaml_layer" {
    filename   = "yaml.zip"
    layer_name = "yaml"

    compatible_runtimes = ["python3.9","python3.7","python3.6"]

    depends_on = [null_resource.create_layer_zip,]
}