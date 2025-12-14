## Pipeline Overview

At a high level, the pipeline operates as follows:

1. Source Stage: CodePipeline  
   a. CodePipeline pulls infrastructure scripts and buildspecs from GitHub.

2. Build Stage: CodeBuild (Golden AMI Creation)  
   a. Dynamically queries AWS for the latest Amazon Linux 2023 AMI.  
   b. Launches a temporary EC2 “builder” instance.  
   c. build.sh script:  
      i. Apply OS updates  
      ii. Install baseline tooling  
      iii. Configure the system  
      iv. Creates a Golden AMI from the configured instance.  
      v. Terminates the builder instance.  
      vi. Outputs the AMI ID as an artifact.

3. Test / Validate Stage  
   a. Launches a new EC2 instance from the newly created AMI.  
   b. validate.sh script checks to ensure all installed software and configuration exists.  
   c. Terminates the validation instance upon completion.

4. Publish Stage  
   a. Writes the validated AMI ID to AWS Parameter Store.
