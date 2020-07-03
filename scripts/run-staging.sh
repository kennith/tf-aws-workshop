FILE=staging.tfvars

# Deploy to stage
echo "First, we are going to validate the file."
$(which terraform) validate

#echo "Run plan with the staging tfvars"
#$(which terraform) plan -var-file=$FILE

echo "Run apply with the staging tfvars"
$(which terraform) apply -var-file=$FILE