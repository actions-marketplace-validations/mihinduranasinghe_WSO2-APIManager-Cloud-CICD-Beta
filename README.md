# WSO2 APIManager Cloud CICD Action

This actions setup allows WSO2 API Manager Cloud users to automate their APis - CICD

## Author

<b>Mihindu Ranasinghe</b> <br/>
<i>Trainee Software Engineer - WSO2 </i><br/>
<i>API Manager Cloud Team</i>

## How this works

In this version of APIMCloud CICD Action, you can automate creating an API project with given API definition and publish it in the a targeted tenant/organization. APIs can be invoked automatically with an automatic generated API application for testing and API access tokens are generated and stored in a txt file for the clients to test the PRODUCTION and SANDBOX API end points.

APIs can be continously deployed to any tenant when the code is merged into a relvanmt github repositpry branches.

## Pre requesits

1. Create a github repository
2. Create a folder named ".github" in the root of the repository
3. Create a folder named "workflows" inside the ".github" folder.
4. Create .yml file with any name , inside the "workflow" folder and you need to code as following example in that yml file

5. Replace the example input values with your details (Project name & Version)

Values for the "passwordTargettedTenant" must be stored in github repo secret and use them as ${{secrets.SECRETPASSWORD}} both places.

6. Push it into the main branch
7. It will initialize a project with standard structure by giving only the project name and the version.
8. Then you can replace the swagger and api.yml with your files , add mediation sequences , docs and images in relavent standard folders.

9. Set the github action triggering condition to trigger your actions and import projects into tenants when merging the code into relevant branch dedicated to tenant.

10. Go to the action section in the repo to see the CICD pipeline working

## Inputs

### `usernameTargetedTenant`

**Required** Dev tenant username as username@organization.com@DevtenantName

### `passwordTargetedTenant`

**Required** Dev tenant user's password should be stored in github repo secrets and use it here like ${{secrets.PASSWORD}}

### `APIName`

**Required** Give a name for your API Project

### `APIVersion`

**Required** API Version

### `needAPIAccessToken`

**Not Compulsory** TRUE or FALSE

This option is for generating API access tokens for your PRODUCTION and SANDBOX API URLs for testing those end points with a user given postman collection file.

If you give this input as TRUE, the model will automatically create an app and subscribe it to your API and generate API access tokens and store it in API_TOKENS.txt inside "Testing folder"

#### The default testing application is created as "TestingAutomationApp" if you want to create the app with your preffered name, provide the preffered name here as an input "testingAppName"

### `testingAppName`

**Not Compulsory** preffered name for the testing application

### `PostmanCollectionTestFile`

**Not Compulsory** Postman collection file should be stored in "Testing" directory.
Here you can give the postman collection file name to test the API before publishing into targetted tenant

## Example usage

```yaml
name: WSO2 APIManager Cloud CICD - Petstore API
on:
  push:
    branches: [main, development, prod]

jobs:
  apim-cloud-cicd:
    runs-on: ubuntu-latest
    steps:
      - name: Cloning repo files into VM
        uses: actions/checkout@v2.3.4

      # Reusable code chunk - Copy this below code chunk and use with your requirement.
      - name: SampleStore v1.0.0 deploying to development tenant
        if: github.event_name == 'push' && github.ref == 'refs/heads/main'
        uses: mihinduranasinghe/WSO2-APIManager-Cloud-CICD-Beta@v3.2.0
        with:
          usernameTargetedTenant: "mihindu@wso2.com@development"
          passwordTargetedTenant: ${{secrets.PASSWORD}}
          APIName: "SampleStore"
          APIVersion: "1.0.0"
          needAPIAccessToken: TRUE # Not a compulsory input
          testingAppName: "ApplicationForTesting" # Not a compulsory input
          PostmanCollectionTestFile: "sample_store.postman_collection.json" # Not a compulsory input
```
