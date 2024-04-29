## Problem

Consider the following problem: Our sales organization uses Salesforce. 
It also frequently uses an external system (call it “Foobar”) in which the sales reps search for specific contacts. 
Once they have assembled a list of contacts, they request Foobar to inject these contacts into Salesforce as Leads. 
Foobar uses the sales rep’s credentials via OAUTH to authenticate to Salesforce and injects the Leads via the Salesforce API. 
The list may be as short as one Lead or as long as several hundred Leads.

Our Marketing team wants these leads to be grouped via Salesforce Campaign records. 
That is, all the leads injected as a list by the sales rep from Foobar in a short period should be grouped, even if they arrive in more than one batch.

## Instructions

Your code should:

* Respond to insertions of Leads.
* Recognize leads injected by Foobar based on LeadSource = “Foobar”.
* Whenever the sales rep requests Foobar to inject one or more leads into Salesforce, recognize that a new list is being inserted and create a new Campaign to group them. 
Leads inserted within a short period should be part of the same campaign. 
The campaign should have a name that includes the string “Foobar”, the sales rep’s name, and a representation of the time the list was injected. 
All the Leads in the list should be associated with the Campaign via CampaignMember records.
* Be covered by unit tests.
* Follow Apex developer best practices.

As this is a proof-of-concept, you are not expected to solve all possible operational and scaling issues now. 
However, please note in the code why you decided to take a shortcut or how it can be addressed in the future as a TODO item for the code reviewer.

## Solution

An Apex trigger was used for this solution as it can be triggered on one Lead record being created, or multiple.

Apex trigger best practises was followed as per this Salesforce [help](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_triggers.htm) file.

