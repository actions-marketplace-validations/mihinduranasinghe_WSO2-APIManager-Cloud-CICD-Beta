#!/bin/sh -l

    # $1 - usernameTargettedTenant
    # $2 - passwordTargettedTenant
    # $3 - APIProjectName
    # $4 - APIVersion
    # $5 - PostmanCollectionTestFile

echo "::group::WSO2 APIMCLI Version"
    apimcli version
echo "::end-group"

echo "::group::WSO2 APIMCLI Help"
    apimcli --help
echo "::end-group"

echo "::group::WSO2 APIMCloud Tenants"
    echo Targeted Tenant  - $1
echo "::end-group"

echo "::group::Add environment wso2apicloud"
apimcli add-env -n wso2apicloud \
                      --registration https://gateway.api.cloud.wso2.com/client-registration/register \
                      --apim https://gateway.api.cloud.wso2.com/pulisher \
                      --token https://gateway.api.cloud.wso2.com/token \
                      --import-export https://gateway.api.cloud.wso2.com/api-import-export \
                      --admin https://gateway.api.cloud.wso2.com/api/am/admin/ \
                      --api_list https://gateway.api.cloud.wso2.com/api/am/publisher/apis \
                      --app_list https://gateway.api.cloud.wso2.com/api/am/store/applications

apimcli list envs          
echo "::end-group"

# apictl import-api -f $API_DIR -e $DEV_ENV -k --preserve-provider --update --verbose
# apimcli init SampleStore --oas petstore.json --definition api_template.yaml
# apimcli init ./$3/$6 --oas $
# apimcli init -f ./$3/$6 --oas $ --definition $

echo "::group::Init API iproject with given API definition"
apimcli init ./$3/$4 
mkdir ./$3/$4/Sequences/fault-sequence/Custom
mkdir ./$3/$4/Sequences/in-sequence/Custom
mkdir ./$3/$4/Sequences/out-sequence/Custom
mkdir ./$3/$4/Testing
touch ./$3/$4/Docs/docs.json
ls ./$3/$4
echo "::end-group"

echo "::group::Push API project into the GIT repo from VM"
git config --global user.email "my-bot@bot.com"
git config --global user.name "my-bot"
#This shell script will find all empty directories and sub-directories in a project folder and creates a .gitkeep file, so that the empty directory 
#can be added to the git index. 
find * -type d -empty -exec touch '{}'/.gitkeep \;
git add . 
git commit -m "API project initialized"
git push
echo "::end-group"

echo "::group::Testing With Postman Collection"
if [ $5 ]
then
newman run ./$3/$4/Testing/$5 --insecure 
else
echo "You have not given a postmanfile to run."
fi
echo "::end-group"

echo "::group::Import API project to targetted Tenant"
apimcli login wso2apicloud -u $1 -p $2 -k
apimcli import-api -f ./$3/$4 -e wso2apicloud --preserve-provider=false --update --verbose -k
# apimcli logout wso2apicloud 
echo "::end-group"

echo "::group::List APIS in targetted Tenant"
# apimcli list apis -e <environment> -k
# apimcli list apis --environment <environment> --insec# echo "::set-env name=HELLO::hello"ure
apimcli list apis -e wso2apicloud -k
echo "::end-group"

apimcli logout wso2apicloud 

