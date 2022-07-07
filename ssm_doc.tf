resource "aws_ssm_document" "ssm_preflight_script" {
    content          = <<-EOT
        description: SSM Patching Linux and Windows preflight scripts
        schemaVersion: '0.3'
        assumeRole: ''
        outputs:
          - runScriptAL2.Output
          - runScriptRHEL.Output
          - runScriptWindows.Output
        parameters:
          patchWindows:
            type: StringList
          environment:
            type: String
        mainSteps:
          - name: runScriptAL2
            action: 'aws:runCommand'
            inputs:
              DocumentName: AWS-RunRemoteScript
              Targets:
                - Key: 'tag:Patch Window'
                  Values: '{{patchWindows}}'
                - Key: 'tag:Patch Group'
                  Values:
                    - AL2
              Parameters:
                executionTimeout: '120'
                commandLine: preflight_al2.sh '{{environment}}'
                sourceInfo: '{"path": "https://ssm-patching-oc.s3.amazonaws.com/utilities/preflight_al2.sh"}'
                sourceType: S3
              CloudWatchOutputConfig:
                CloudWatchLogGroupName: cms-cloud-ssm-patching-preflight-script
                CloudWatchOutputEnabled: true
              MaxErrors: 100%
              TimeoutSeconds: 120
            nextStep: runScriptRHEL
            onFailure: Continue
          - name: runScriptRHEL
            action: 'aws:runCommand'
            inputs:
              DocumentName: AWS-RunRemoteScript
              Targets:
                - Key: 'tag:Patch Window'
                  Values: '{{patchWindows}}'
                - Key: 'tag:Patch Group'
                  Values:
                    - RHEL6
                    - RHEL7
              Parameters:
                executionTimeout: '120'
                commandLine: preflight_rhel.sh '{{environment}}'
                sourceInfo: '{"path": "https://ssm-patching-oc.s3.amazonaws.com/utilities/preflight_rhel.sh"}'
                sourceType: S3
              CloudWatchOutputConfig:
                CloudWatchLogGroupName: cms-cloud-ssm-patching-preflight-script
                CloudWatchOutputEnabled: true
              MaxErrors: 100%
              TimeoutSeconds: 120
            nextStep: runScriptWindows
            onFailure: Continue
          - name: runScriptWindows
            action: 'aws:runCommand'
            inputs:
              DocumentName: AWS-RunRemoteScript
              Targets:
                - Key: 'tag:Patch Window'
                  Values: '{{patchWindows}}'
                - Key: 'tag:Patch Group'
                  Values:
                    - Windows
              Parameters:
                executionTimeout: '120'
                commandLine: preflight_windows.ps1 '{{environment}}'
                sourceInfo: '{"path": "https://ssm-patching-oc.s3.amazonaws.com/utilities/preflight_windows.ps1"}'
                sourceType: S3
              CloudWatchOutputConfig:
                CloudWatchLogGroupName: cms-cloud-ssm-patching-preflight-script
                CloudWatchOutputEnabled: true
              MaxErrors: 100%
              TimeoutSeconds: 120
            isEnd: true
            onFailure: Continue
    EOT
    name             = "SSM-Patching-Preflight-Script"
    document_format  = "YAML"
    document_type    = "Automation"
}
