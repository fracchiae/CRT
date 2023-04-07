*** Settings ***
Resource               ../resources/common.robot
Suite Setup            Setup Browser
Suite Teardown         End suite
Library                FakerLibrary

*** Test Cases ***
Create Account Growmore
    [Tags]             Account                     New Account
    Appstate           Home
    LaunchApp          Sales
    ClickText          Accounts
    ClickText          New
    UseModal           On
    Sleep              1 sec
    Create Account     Customer

Delete Account Growmore
    [Documentation]    Delete account previously created
    Delete Account

Create Account with FakerLibrary
    ${first_name}=     FakerLibrary.first_name
    ${last_name}=      FakerLibrary.last_name
    ${email}=          FakerLibrary.email
    Login
    ClickText          Accounts