FILE=staging.tfvars

echo "Destroy with the staging tfvars"
$(which terraform) destroy -var-file=$FILE