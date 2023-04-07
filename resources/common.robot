*** Settings ***
Library                         QWeb
Library                         QForce
Library                         String
Library                         DateTime


*** Variables ***
${username}                     emiliano.fracchia-sufs@force.com
${login_url}                    https://xyz127.lightning.force.com/                     # Salesforce instance. NOTE: Should be overwritten in CRT variables
${home_url}                     ${login_url}/lightning/page/home
${BROWSER}                      chrome
${uniqueAccountName}
*** Keywords ***
Setup Browser
    Set Library Search Order    QWeb                        QForce
    Open Browser                about:blank                 ${BROWSER}
    SetConfig                   LineBreak                   ${EMPTY}                    #\ue000
    SetConfig                   DefaultTimeout              20s                         #sometimes salesforce is slow


End suite
    Set Library Search Order    QWeb                        QForce
    Close All Browsers


Login
    [Documentation]             Login to Salesforce instance
    Set Library Search Order    QWeb                        QForce
    GoTo                        ${login_url}
    TypeText                    Username                    ${username}                 delay=1
    TypeText                    Password                    ${password}
    ClickText                   Log In


Home
    [Documentation]             Navigate to homepage, login if needed
    Set Library Search Order    QWeb                        QForce
    GoTo                        ${home_url}
    ${login_status} =           IsText                      To access this page, you have to log in to Salesforce.                   2
    Run Keyword If              ${login_status}             Login
    ClickText                   Home
    VerifyTitle                 Home | Salesforce

Create Account
    [Arguments]                 ${type}
    ${string}=                  Generate Random String      length= 4                   chars="[NUMBERS]"
    ${genericName}=             Convert To String           Growmore
    ${uniqueAccountName}=       Catenate                    ${string}                   ${genericName}
    Wait Until Keyword Succeeds                             1 min                       5 sec                       TypeText         *Account Name           ${uniqueAccountName}
    PickList                    Type                        ${type}
    ClickText                   Website
    TypeText                    Website                     www.growmore.org
    ClickText                   Phone
    TypeText                    Phone                       1234567890
    PickList                    Industry                    Banking
    ClickText                   Employees
    TypeText                    Employees                   100
    ClickText                   Save                        partial_match=false
    UseModal                    Off

    ClickText                   Details                     anchor=Related
    VerifyText                  ${uniqueAccountName}
    VerifyText                  ${uniqueAccountName}        anchor=Account Name
    VerifyField                 Phone                       (123) 456-7890
    VerifyField                 Employees                   100
    VerifyField                 Website                     www.growmore.org
    VerifyField                 Industry                    Banking

Delete Account
    Appstate                    Home
    LaunchApp                   Sales
    ClickText                   Accounts
    VerifyText                  ${uniqueAccountName}        anchor=Account Name
    ClickText                   ${uniqueAccountName}
    ClickText                   Delete
    ClickText                   Delete