resource "null_resource" "cloudtamer_app_api_key_renewal_zip" {
  provisioner "local-exec" {
    command     = <<EOF
mkdir -p tmp/ && \
cp ${self.triggers.source}/cloudtamer/CloudTamer-App-API-Key-Renewal.py tmp/. && \
cd tmp/ && \
zip -r CloudTamer-App-API-Key-Renewal.zip CloudTamer-App-API-Key-Renewal.py && \
mv CloudTamer-App-API-Key-Renewal.zip .. && \
cd .. && \
rm -rf tmp/


EOF
    interpreter = ["bash", "-c"]
  }

  triggers = {
    always_run = timestamp()
    source     = var.script_scr
  }
}


resource "null_resource" "SSM_Patching_Preflight_Script" {
  provisioner "local-exec" {
    command     = <<EOF
mkdir -p tmp/ && \
cp ${self.triggers.source}/SSM-Patching/SSM-Patching-Preflight-Script.py tmp/. && \
cd tmp/ && \
zip -r SSM-Patching-Preflight-Script.zip SSM-Patching-Preflight-Script.py && \
mv SSM-Patching-Preflight-Script.zip .. && \
cd .. && \
rm -rf tmp/

EOF
    interpreter = ["bash", "-c"]
  }

  triggers = {
    always_run = timestamp()
    source     = var.script_scr
  }
}

resource "null_resource" "create_layer_zip" {
  provisioner "local-exec" {
    command     = <<EOF
mkdir -p python/ && \
pip3 install -r ${self.triggers.source}/SSM-Patching/requirements.txt -t python/ && \
zip -r yaml.zip python/ && \
rm -rf python/

EOF
    interpreter = ["bash", "-c"]
  }

  triggers = {
    always_run = timestamp()
    source     = var.script_scr
  }
}

resource "null_resource" "SSM_Patching_Maint_Window_Check" {
  provisioner "local-exec" {
    command     = <<EOF
mkdir -p tmp/ && \
cp ${self.triggers.source}/SSM-Patching/SSM-Patching-Maintenance-Window-Check.py tmp/. && \
cd tmp/ && \
zip -r SSM-Patching-Maintenance-Window-Check.zip SSM-Patching-Maintenance-Window-Check.py && \
mv SSM-Patching-Maintenance-Window-Check.zip .. && \
cd .. && \
rm -rf tmp/

EOF
    interpreter = ["bash", "-c"]
  }

  triggers = {
    always_run = timestamp()
    source     = var.script_scr
  }
}