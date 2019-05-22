<?xml version="1.0" encoding="UTF-8"?>

<mule xmlns:json="http://www.mulesoft.org/schema/mule/json" xmlns:filters="http://www.mulesoft.org/schema/mule/filters" xmlns:validation="http://www.mulesoft.org/schema/mule/validation" xmlns:http="http://www.mulesoft.org/schema/mule/http" xmlns:dw="http://www.mulesoft.org/schema/mule/ee/dw" xmlns:metadata="http://www.mulesoft.org/schema/mule/metadata" xmlns:sfdc="http://www.mulesoft.org/schema/mule/sfdc" xmlns:tracking="http://www.mulesoft.org/schema/mule/ee/tracking" xmlns="http://www.mulesoft.org/schema/mule/core" xmlns:doc="http://www.mulesoft.org/schema/mule/documentation"
	xmlns:spring="http://www.springframework.org/schema/beans" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-current.xsd
http://www.mulesoft.org/schema/mule/core http://www.mulesoft.org/schema/mule/core/current/mule.xsd
http://www.mulesoft.org/schema/mule/sfdc http://www.mulesoft.org/schema/mule/sfdc/current/mule-sfdc.xsd
http://www.mulesoft.org/schema/mule/ee/tracking http://www.mulesoft.org/schema/mule/ee/tracking/current/mule-tracking-ee.xsd
http://www.mulesoft.org/schema/mule/ee/dw http://www.mulesoft.org/schema/mule/ee/dw/current/dw.xsd
http://www.mulesoft.org/schema/mule/http http://www.mulesoft.org/schema/mule/http/current/mule-http.xsd
http://www.mulesoft.org/schema/mule/validation http://www.mulesoft.org/schema/mule/validation/current/mule-validation.xsd
http://www.mulesoft.org/schema/mule/filters http://www.mulesoft.org/schema/mule/filters/current/mule-filters.xsd
http://www.mulesoft.org/schema/mule/json http://www.mulesoft.org/schema/mule/json/current/mule-json.xsd">
    <spring:beans>
        <spring:bean id="Bean" name="Bean" class="CustomAggregationStrategy"/>
    </spring:beans>
    <filters:config name="Filters" doc:name="Filters"/>

    <flow name="permitsInsertFlow">
        <flow-ref name="permitApplicationInsertFlow" doc:name="permitApplicationInsertFlow"/>

        <expression-filter expression="#[payload == true]" doc:name="payload == true"/>


        <flow-ref name="permitLineItemInsertFlow" doc:name="permitLineItemInsertFlow"/>
        <expression-filter expression="#[payload == true]" doc:name="payload == true"/>
        <set-payload value="#[flowVars.ApplicationRequest.FileData]" mimeType="application/xml" doc:name="Set Payload - flowVars.ApplicationRequest.FileData"/>
        <dw:transform-message doc:name="Transform Message">
            <dw:set-variable variableName="locationDetails"><![CDATA[%dw 1.0
%output application/java
---
{
	isImportationDetails :	payload.Submission.Application.*ImportationDetails,
	isInterstateDetails  :	payload.Submission.Application.*InterstateDetails,
	isReleaseDetails	   :	payload.Submission.Application.*ReleaseDetails
	
	
}]]></dw:set-variable>

        </dw:transform-message>
        <flow-ref name="RegulatedArticle" doc:name="RegulatedArticle"/>
        <flow-ref name="ArticleSupplier" doc:name="ArticleSupplier"/>
        <flow-ref name="InterstateDetails" doc:name="InterstateDetails"/>
        <flow-ref name="ImportationDetails" doc:name="ImportationDetails"/>
        <flow-ref name="ReleaseDetails" doc:name="ReleaseDetails"/>

        <scatter-gather doc:name="Scatter-Gather">
            <custom-aggregation-strategy ref="Bean"/>
            <flow-ref name="Construct" doc:name="Construct"/>
            <flow-ref name="processImportationResult" doc:name="processImportationResult"/>
            <flow-ref name="processInterstateResult" doc:name="processInterstateResult"/>

        </scatter-gather>
        <flow-ref name="previouslySubmittedConstructFlow" doc:name="PreviouslySubmittedConstruct"/>
        <flow-ref name="processReleaseResult" doc:name="processReleaseResult"/>
        <flow-ref name="processConstructResult" doc:name="processConstructResult"/>
        <exception-strategy ref="permit_inserts_salesforce_stepsGlobal_Exception_Strategy" doc:name="Reference Exception Strategy"/>

    </flow>
    <flow name="permitApplicationInsertFlow">
        <set-variable variableName="StepName" value="6. Application Insert" doc:name="Set flowVars.StepName = 6. Application Insert"/>
        <set-variable variableName="StepStart" value="#[dw('now')]" doc:name="Set flowVars.StepStart = DateTime.now()"/>
        <enricher source="#[payload]" target="#[flowVars.permitApplicationId]" doc:name="flowVars.permitApplicationId">
            <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Application__c" doc:name="Application Insert">
                <sfdc:objects>
                    <sfdc:object>
                        <sfdc:inner-object key="Application_Type__c">New</sfdc:inner-object>
                        <sfdc:inner-object key="Application_Status__c">Draft</sfdc:inner-object>
                        <sfdc:inner-object key="Applicant_Name__c">#[flowVars.ApplicationCreatedByID.ApplicantName__c]</sfdc:inner-object>
                        <sfdc:inner-object key="OwnerId">#[flowVars.ApplicationCreatedByID.CreatedById]</sfdc:inner-object>
                    </sfdc:object>
                </sfdc:objects>
            </sfdc:create>
        </enricher>
        <validation:is-true message="#[flowVars.permitApplicationId[0].errors]" expression="#[flowVars.permitApplicationId[0].success == 'true']" doc:name="Validation - flowVars.permitApplicationId[0].success == 'true'"/>
        <sfdc:update-single config-ref="Salesforce__Basic_Authentication" type="Application_Creation_Request__c" doc:name="Update Application Name">
            <sfdc:object>
                <sfdc:object key="Id">#[flowVars.ApplicationRequest.Id]</sfdc:object>
                <sfdc:object key="Application__c">#[flowVars.permitApplicationId[0].id]</sfdc:object>
            </sfdc:object>
        </sfdc:update-single>
        <flow-ref name="Create-Step-Status-Success" doc:name="Create-Step-Status-Success"/>
        <set-payload value="#[true]" doc:name="Set Payload = true"/>
    </flow>
    <flow name="permitLineItemInsertFlow">
        <set-variable variableName="StepName" value="7. Line Item Insert" doc:name="Set flowVars.StepName = 7. Line Item Insert"/>
        <set-variable variableName="StepStart" value="#[dw('now')]" doc:name="Set flowVars.StepStart = DateTime.now()"/>
        <set-payload value="#[flowVars.ApplicationRequest.FileData]" doc:name="Set Payload - flowVars.ApplicationRequest.FileData"/>
        <set-variable variableName="pApplicationRecordId" value="#[flowVars.permitApplicationId[0].id]" doc:name="Variable - PermitApplicationId"/>
        <dw:transform-message doc:name="Transform Message" metadata:id="b19e5881-4b19-4380-91b3-50bc8e29607c">
            <dw:input-payload mimeType="application/xml"/>
            <dw:set-payload><![CDATA[%dw 1.0
%output application/java
%var value  = payload.Submission.Application
---
[{
	RecordTypeId: ((flowVars.RecordTypeResultSet filter $.DeveloperName == 'BRS_PERMIT_RT')[0].Id) when (flowVars.ApplicationRequest.Application_Type__c == "Permit") otherwise  ((flowVars.RecordTypeResultSet filter $.DeveloperName == 'BRS_NOTIF_RT')[0].Id),
	Application_Number__c: flowVars.pApplicationRecordId,
	How_will_variance_be_used__c : value.VarianceDescription,
	Are_you_applying_for_Variance__c: "No" when value.ApplyingForVariance != "Y" otherwise "Yes",
	Do_you_want_to_use_a_previously_approved__c : value.UsePreviousVariance,
	If_yes_Please_Describe__c : value.DescribePreviousVariance,
	What_is_the_previously_reviewed_variance__c : value.VarianceNumber,
	Amendment_Description__c : value.AmendmentDescription,
	CBI_Justification__c: value.CBIJustificationStatement[0..3999] when ((sizeOf value.CBIJustificationStatement) > 4000) otherwise value.CBIJustificationStatement,
	Does_This_Application_Contain_CBI__c: "No" when value.ApplicationCBIFlag != "Y" otherwise "Yes",
	Thumbprint__c: ((flowVars.ThumbprintDetails filter $.Name == 'BRS Standard Permit')[0].Id) when (flowVars.ApplicationRequest.Application_Type__c == "Permit") otherwise  ((flowVars.ThumbprintDetails filter $.Name == 'Genetically_Plant_Yes')[0].Id),
	Hand_Carry__c: value.HandCarryImport,
	Number_of_Labels__c: value.NumberOfLabelsImport,
	Proposed_End_Date__c: value.ProposedEndDate as :date,
	Proposed_Start_Date__c: value.ProposedStartDate as :date,
	Additional_Information__c: value.AdditionalInformation,
	Biological_Material_present_in_Article__c: "No" when value.BiologicalMaterial != "Y" otherwise "Yes",
	Means_of_Movement__c: value.MeansOfMovement,
	(Movement_Type__c: "Import") when value.IntroductionType == "BIM",
	(Movement_Type__c: "Interstate Movement") when value.IntroductionType == "BIT",
	(Movement_Type__c: "Interstate Movement and Release") when value.IntroductionType == "BIR",
	(Movement_Type__c: "Release") when value.IntroductionType == "BRL",
	Program_Line_Item_Pathway__c: flowVars.ProgramLineItemPathwayID[0].Id,
	Purpose_of_Permit__c: value.ArticlePurpose,
	(Purpose_of_Permit__c: "Industrial Product") when value.ArticlePurpose == "IP",
	(Purpose_of_Permit__c: "Pharmaceutical Product") when value.ArticlePurpose == "PP",
	(Purpose_of_Permit__c: "Phytoremediation") when value.ArticlePurpose == "PM",
	(Purpose_of_Permit__c: "Traditional") when value.ArticlePurpose == "TR",
	Applicant_Reference_Number__c: value.ApplicantReferenceNumber,
	Type_of_Permit__c: 'Standard Permit' when (flowVars.ApplicationRequest.Application_Type__c == "Permit") otherwise 'Notification',
	OwnerId : flowVars.ApplicationCreatedByID.CreatedById,
	Source__c: "XML"
}]]]></dw:set-payload>
        </dw:transform-message>
        <enricher source="#[payload]" target="#[flowVars.permitLineItemRecordID]" doc:name="flowVars.permitLineItemRecordID">
            <sfdc:create config-ref="Salesforce__Basic_Authentication" type="AC__c" doc:name="Line Item Insert">
                <sfdc:objects ref="#[payload]"/>
            </sfdc:create>

        </enricher>
        <validation:is-true message="#[flowVars.permitLineItemRecordID[0].errors]" expression="#[flowVars.permitLineItemRecordID[0].success == 'true']" doc:name="Validation - flowVars.permitLineItemRecordID[0].success == 'true'"/>
        <flow-ref name="Create-Step-Status-Success" doc:name="Create-Step-Status-Success"/>
        <set-payload value="#[true]" doc:name="Set Payload = true"/>


    </flow>
    <flow name="RegulatedArticle">
        <set-variable variableName="StepStart" value="#[dw('now')]" doc:name="Set flowVars.StepStart = DateTime.now()"/>
        <set-variable variableName="StepName" value="8.a. Regulated Article Insert" doc:name="Set flowVars.StepName = 8.a. Regulated Article Insert"/>

        <set-payload value="#[flowVars.ApplicationRequest.FileData]" doc:name="Set Payload - flowVars.ApplicationRequest.FileData"/>
        <set-variable variableName="plItemRecordId" value="#[flowVars.PermitLineItemRecordID[0].id]" doc:name="Variable - PermitLineItemRecordID"/>
        <dw:transform-message doc:name="Transform Message" metadata:id="b19e5881-4b19-4380-91b3-50bc8e29607c">
            <dw:input-payload mimeType="application/xml"/>
            <dw:set-payload><![CDATA[%dw 1.0
%output application/java
---
(payload.Submission.Application.*Article map using(value = $) {
	Cultivar_and_or_Breeding_Line__c:value.CultivarBreedingLine,
	Line_Item__c: flowVars.plItemRecordId,
	Regulated_Article__c: (flowVars.RegulatedArticles filter ($.Scientific_Name__c == value.ScientificName))[0].Id
})]]></dw:set-payload>
        </dw:transform-message>
        <set-variable variableName="regulatedArticleErrors" value="#[new java.util.ArrayList()]" doc:name="Variable - regulatedArticleErrors"/>
        <foreach doc:name="For Each">
            <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Link_Regulated_Articles__c" doc:name="Regulated Article Insert">
                <sfdc:objects ref="#[[payload]]"/>
            </sfdc:create>
            <expression-component doc:name="Expression"><![CDATA[if(payload[0].success != 'true'){
	flowVars.regulatedArticleErrors.add(payload);
}]]></expression-component>
        </foreach>
        <choice doc:name="Choice">
            <when expression="#[flowVars.regulatedArticleErrors.size() == 0]">
                <flow-ref name="Create-Step-Status-Success" doc:name="Create-Step-Status-Success"/>
            </when>
            <otherwise>
                <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< flowVars.regulatedArticleErrors.size(); i++){
	flowVars.ErrorTextTemp.add((flowVars.regulatedArticleErrors[i][0].errors[0].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();
]]></expression-component>
                <flow-ref name="Create-Step-Status-Error" doc:name="Create-Step-Status-Error"/>
            </otherwise>
        </choice>

        <exception-strategy ref="permit_inserts_salesforce_stepsGlobal_Exception_Strategy" doc:name="Reference Exception Strategy"/>
    </flow>
    <flow name="ArticleSupplier">

        <set-variable variableName="StepStart" value="#[dw('now')]" doc:name="Set flowVars.StepStart = DateTime.now()"/>
        <set-variable variableName="StepName" value="8.b. Article Or Supplier Insert" doc:name="Set flowVars.StepName = 8.b. Article Or Supplier Insert"/>
        <choice doc:name="Choice">
            <when expression="#[flowVars.ApplicationRequest.Application_Type__c == &quot;Permit&quot;]">
                <set-variable variableName="ArticleSupplierError" value="#[new java.util.ArrayList()]" doc:name="Variable - PermitArticleSupplierError"/>
                <set-variable variableName="ArticleSupplierSuccess" value="#[new java.util.ArrayList()]" doc:name="Variable - PermitArticleSupplierSuccess"/>
                <set-payload value="#[flowVars.ApplicationRequest.FileData]" doc:name="Set Payload - flowVars.ApplicationRequest.FileData"/>
                <set-variable variableName="plItemRecordId" value="#[flowVars.PermitLineItemRecordID[0].id]" doc:name="Variable - PermitLineItemRecordID"/>
                <dw:transform-message doc:name="Transform Message" metadata:id="b19e5881-4b19-4380-91b3-50bc8e29607c">
                    <dw:input-payload mimeType="application/xml"/>
                    <dw:set-payload><![CDATA[%dw 1.0
%output application/java
---
(payload.Submission.Application.*ArticleSupplier map using(value = $) {
	Name: value.ArtSupLastName,
	Line_Item__c: flowVars.plItemRecordId,
	First_Name__c: value.ArtSupFirstName,
	Organization_Name__c: value.ArtSupOrganization,
	Phone__c: value.ArtSupDayTelephone as :string,
	(Phone_CBI__c: true) when  (value.ArtSupDayTelephone.@CBI =="true"),
	Street_Address__c: value.ArtSupAddressLine1,
	City__c: value.ArtSupCity,
	Postal_Code__c: value.ArtSupPostalCode,
	(Postal_Code_CBI__c: true) when (value.ArtSupPostalCode.@CBI =="true"),	
	Email__c: value.ArtSupEmail as :string,
	(Email_Address_CBI__c: true) when (value.ArtSupEmail.@CBI == "true"),	
	Alternate_Phone__c: value.ArtSupAltPhone as :string,
	(Alternate_Phone_CBI__c: true) when (value.ArtSupAltPhone.@CBI == "true"),
	State__c: (flowVars.Level1Regions filter (($.Level_1_Region_Code__c == value.ArtSupState) and ($.Country__r.Name == value.ArtSupCountry)))[0].Id,
	(State_CBI__c: true) when (value.ArtSupState.@CBI == "true"),	
	Country__c: (flowVars.Countries filter ($.Name == value.ArtSupCountry))[0].Id,
	(Country_CBI__c: true) when (value.ArtSupCountry.@CBI == "true"),		
	Level_2_Region__c:  (flowVars.Level2Regions filter (($.Name == value.ArtSupCountyProvince) and ($.Level_1_Region__r.Level_1_Region_Code__c == value.ArtSupState)))[0].Id
})]]></dw:set-payload>
                </dw:transform-message>
                <foreach batchSize="200" doc:name="For Each">
                    <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Article_Supplier_Developer__c" doc:name="Article Supplier Insert">
                        <sfdc:objects ref="#[payload]"/>
                    </sfdc:create>
                    <choice doc:name="Choice">
                        <when expression="#[payload[0].success == 'true']">
                            <expression-transformer expression="#[ArticleSupplierSuccess.add(payload)]" doc:name="Expression - Record Success Result"/>
                        </when>
                        <otherwise>
                            <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();
]]></expression-component>
                            <expression-transformer expression="#[flowVars.ArticleSupplierError.add(payload[0].errors[0])]" doc:name="Expression - Record Error Result"/>
                            <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                        </otherwise>
                    </choice>
                </foreach>
                <choice doc:name="Choice">
                    <when expression="#[flowVars.ArticleSupplierError.size() == 0]">
                        <flow-ref name="Create-Step-Status-Success" doc:name="Create-Step-Status-Success"/>
                    </when>
                    <otherwise>
                        <flow-ref name="Create-Step-Status-Error" doc:name="Create-Step-Status-Error"/>
                    </otherwise>
                </choice>
            </when>
            <otherwise>
                <logger level="INFO" doc:name="Logger"/>
            </otherwise>
        </choice>

        <exception-strategy ref="permit_inserts_salesforce_stepsGlobal_Exception_Strategy" doc:name="Reference Exception Strategy"/>

    </flow>
    <flow name="ImportationDetails">

        <set-variable variableName="StepStart" value="#[dw('now')]" doc:name="Set flowVars.StepStart = DateTime.now()"/>
        <set-variable variableName="StepName" value="8.c.ii.  Importation Location Insert" doc:name="Set flowVars.StepName = 8.c.ii. Importation Location Details Insert"/>
        <choice doc:name="Choice">
            <when expression="#[flowVars.locationDetails.isImportationDetails != null]">
                <set-payload value="#[flowVars.ApplicationRequest.FileData]" doc:name="Set Payload - flowVars.ApplicationRequest.FileData"/>
                <set-variable variableName="plItemRecordId" value="#[flowVars.PermitLineItemRecordID[0].id]" doc:name="Variable - PermitLineItemRecordID"/>
                <dw:transform-message doc:name="Transform Message" metadata:id="b19e5881-4b19-4380-91b3-50bc8e29607c">
                    <dw:input-payload mimeType="application/xml"/>
                    <dw:set-variable variableName="importationDetailsSFPayload"><![CDATA[%dw 1.0
%output application/java
%function roundNumberUp (numberToRound)
	((	
	numberToRound - 
	1 / (10 pow (sizeOf (numberToRound - floor numberToRound))-1)
	) as :string {format: "#.000"} as :number) when (numberToRound as :string contains ".") otherwise numberToRound

---
 [
	payload.Submission.Application.ImportationDetails.*ImportationPointofOrigin map using(value = $)  {
		ImportationPoOObject : {
			Line_Item__c: flowVars.plItemRecordId,
			RecordTypeId: (flowVars.RecordTypeResultSet filter $.DeveloperName == 'Origin_Location')[0].Id,		
			Name : value.LocationName,
			Description__c : value.LocationDescription,
			Street_Add1__c : value.LocationAddressLine1,
			City__c : value.LocationCity,
			Zip__c : value.LocationPostalCode,
			(Zip_CBI__c : true) when (value.LocationPostalCode.@CBI == "true"),	
			State__c: (flowVars.Level1Regions filter (($.Level_1_Region_Code__c == value.LocationState) and ($.Country__r.Name == value.LocationCountry)))[0].Id,
			Level_2_Region__c : (flowVars.Level2Regions filter (($.Name == value.LocationCountyProvince) and ($.Level_1_Region__r.Level_1_Region_Code__c == value.LocationState)))[0].Id,			
			Country__c: (flowVars.Countries filter ($.Name == value.LocationCountry))[0].Id			
		},
		ImportationPoOChilds :{
			IPoOLocationContacts : $.*Contact map using(contactLocation = $) {
				First_Name__c : contactLocation.FirstName,
				Name: contactLocation.LastName,
				(Primary__c : true) when (contactLocation.PrimaryFlag != "N"),
				Organization_Name__c : contactLocation.Organization,
				Address__c : contactLocation.ContDetails.AddressLine1,
				County__c : (flowVars.Level2Regions filter (($.Name == contactLocation.ContDetails.CountyProvince) and ($.Level_1_Region__r.Level_1_Region_Code__c == contactLocation.ContDetails.State)))[0].Id,
				City__c : contactLocation.ContDetails.City,
				State__c: (flowVars.Level1Regions filter (($.Level_1_Region_Code__c == contactLocation.ContDetails.State) and ($.Country__r.Name == contactLocation.ContDetails.Country)))[0].Id,
				Zip__c : contactLocation.ContDetails.PostalCode,
				(Zip_CBI__c : true) when (contactLocation.ContDetails.PostalCode.@CBI == "true"),
				Country__c: (flowVars.Countries filter ($.Name == contactLocation.ContDetails.Country))[0].Id,
				Email__c : contactLocation.ContDetails.Email1,
				(Email_CBI__c: true) when (contactLocation.ContDetails.Email1.@CBI == "true"),	
				Fax__c : contactLocation.ContDetails.FaxTelephone,
				(Fax_CBI__c : true) when (contactLocation.ContDetails.FaxTelephone.@CBI == "true"),
				Alternate_Email__c : contactLocation.ContDetails.Email2,
				(Alternate_Email_CBI__c : true) when (contactLocation.ContDetails.Email2.@CBI =="true"),
				Phone__c : contactLocation.ContDetails.DayTelephone,
				(Phone_CBI__c: true) when  (contactLocation.ContDetails.DayTelephone.@CBI =="true"),
				Alternate_Phone__c : contactLocation.ContDetails.AlternateTelephone,
				(Alternate_Phone_CBI__c: true) when (contactLocation.ContDetails.AlternateTelephone.@CBI == "true")	
			}
		}
	},
	payload.Submission.Application.ImportationDetails.*ImportationDestination map using(value = $) {
		ImportationDestObject:{
			Line_Item__c: flowVars.plItemRecordId,	
			RecordTypeId: (flowVars.RecordTypeResultSet filter $.DeveloperName == 'Destination_Location')[0].Id,		
			Name : value.LocationName,
			Description__c : value.LocationDescription,
			Street_Add1__c : value.LocationAddressLine1,
			City__c : value.LocationCity,
			Zip__c : value.LocationPostalCode,
			(Zip_CBI__c : true) when (value.LocationPostalCode.@CBI == "true"),
			Country__c: (flowVars.Countries filter ($.Name == 'United States of America'))[0].Id,
			State__c: (flowVars.Level1Regions filter (($.Level_1_Region_Code__c == value.LocationState) and ($.Country__r.Name == 'United States of America')))[0].Id,
			Level_2_Region__c : (flowVars.Level2Regions filter (($.Name == value.LocationCountyProvince) and ($.Level_1_Region__r.Level_1_Region_Code__c == value.LocationState)))[0].Id,
			Inspected_by_APHIS__c : "No" when value.InspectedByAPHIS != "Y" otherwise "Yes"
		},
		ImportationDestChilds :{
			IDestLocationContacts : $.*Contact map using(contactLocation = $) {
				First_Name__c : contactLocation.FirstName,
				Name: contactLocation.LastName,
				(Primary__c : true) when (contactLocation.PrimaryFlag != "N"),
				Organization_Name__c : contactLocation.Organization,
				Address__c : contactLocation.ContDetails.AddressLine1,
				County__c : (flowVars.Level2Regions filter (($.Name == contactLocation.ContDetails.CountyProvince) and ($.Level_1_Region__r.Level_1_Region_Code__c == contactLocation.ContDetails.State)))[0].Id,
				City__c : contactLocation.ContDetails.City,
				State__c: (flowVars.Level1Regions filter (($.Level_1_Region_Code__c == contactLocation.ContDetails.State) and ($.Country__r.Name == contactLocation.ContDetails.Country)))[0].Id,
				Zip__c : contactLocation.ContDetails.PostalCode,
				(Zip_CBI__c : true) when (contactLocation.ContDetails.PostalCode.@CBI == "true"),
				Country__c: (flowVars.Countries filter ($.Name == contactLocation.ContDetails.Country))[0].Id,
				Email__c : contactLocation.ContDetails.Email1,
				(Email_CBI__c: true) when (contactLocation.ContDetails.Email1.@CBI == "true"),	
				Fax__c : contactLocation.ContDetails.FaxTelephone,
				(Fax_CBI__c : true) when (contactLocation.ContDetails.FaxTelephone.@CBI == "true"),				
				Alternate_Email__c : contactLocation.ContDetails.Email2,
				(Alternate_Email_CBI__c : true) when (contactLocation.ContDetails.Email2.@CBI =="true"),
				Phone__c : contactLocation.ContDetails.DayTelephone,
				(Phone_CBI__c: true) when  (contactLocation.ContDetails.DayTelephone.@CBI =="true"),
				Alternate_Phone__c : contactLocation.ContDetails.AlternateTelephone,
				(Alternate_Phone_CBI__c: true) when (contactLocation.ContDetails.AlternateTelephone.@CBI == "true")	
			},
				IDestMaterialType:$.*IntroductionMovement map {
				Quantity__c : roundNumberUp($.Quantity),
				Unit_of_Measure__c : $.Units,
				Material__c : $.PlantPart,
				(Material_CBI__c : true) when ($.PlantPart.@CBI =="true"),
				Other_Material__c : $.DescribeOtherMaterial
			}			
		}		
	}
]]]></dw:set-variable>
                </dw:transform-message>
                <set-variable variableName="importationDestSuccess" value="#[new java.util.ArrayList()]" doc:name="Variable - importationDestSuccess"/>
                <set-variable variableName="importationDestErr" value="#[new java.util.ArrayList()]" doc:name="Variable - importationDestErr"/>
                <foreach collection="#[flowVars.importationDetailsSFPayload[1]]" doc:name="For Each">
                    <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Location__c" doc:name="Importation Destination">
                        <sfdc:objects ref="#[[payload.ImportationDestObject]]"/>
                    </sfdc:create>
                    <choice doc:name="Choice">
                        <when expression="#[payload[0].success == true]">
                            <expression-transformer expression="#[flowVars.importationDestSuccess.add(payload)]" doc:name="Expression - payload.importationDestSuccess.add(payload)"/>
                        </when>
                        <otherwise>
                            <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();
]]></expression-component>
                            <expression-transformer expression="#[flowVars.importationDestErr.add(payload)]" doc:name="Expression - flowVars.importationDestErr.add(payload)"/>
                            <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                        </otherwise>
                    </choice>
                </foreach>
                <set-variable variableName="impotationPoOSuccess" value="#[new java.util.ArrayList()]" doc:name="Variable - impotationPoOSuccess"/>
                <set-variable variableName="importationPoOError" value="#[new java.util.ArrayList()]" doc:name="Variable- importationPoOError"/>
                <foreach collection="#[flowVars.importationDetailsSFPayload[0]]" doc:name="For Each">
                    <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Location__c" doc:name="Importation Point of Origin">
                        <sfdc:objects ref="#[[payload.ImportationPoOObject]]"/>
                    </sfdc:create>
                    <choice doc:name="Choice">
                        <when expression="#[payload[0].success == true]">
                            <expression-transformer expression="#[flowVars.impotationPoOSuccess.add(payload)]" doc:name="Expression - flowVars.impotationPoOSuccess.add(payload)"/>
                        </when>
                        <otherwise>
                            <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();
]]></expression-component>
                            <expression-transformer expression="#[flowVars.importationPoOError.add(payload)]" doc:name="Expression - flowVars.importationPoOError.add(payload)"/>
                            <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                        </otherwise>
                    </choice>
                </foreach>

                <dw:transform-message doc:name="Transform Message">
                    <dw:set-variable variableName="isImpotationPassed"><![CDATA[%dw 1.0
%output application/java
---
((sizeOf flowVars.importationDestErr) == 0) and ( (sizeOf flowVars.importationPoOError) == 0)]]></dw:set-variable>
                </dw:transform-message>
                <choice doc:name="Choice">
                    <when expression="#[flowVars.isImpotationPassed]">
                        <flow-ref name="Create-Step-Status-Success" doc:name="Create-Step-Status-Success"/>
                    </when>
                    <otherwise>
                        <flow-ref name="Create-Step-Status-Error" doc:name="Create-Step-Status-Error"/>
                    </otherwise>
                </choice>
            </when>
            <otherwise>
                <logger level="INFO" doc:name="Logger"/>
            </otherwise>
        </choice>

        <exception-strategy ref="permit_inserts_salesforce_stepsGlobal_Exception_Strategy" doc:name="Reference Exception Strategy"/>


    </flow>
    <flow name="processImportationResult">
        <set-variable variableName="StepStart" value="#[dw('now')]" doc:name="Set flowVars.StepStart = DateTime.now()"/>
        <set-variable variableName="StepName" value="8.c.ii.  Importation Location Insert" doc:name="Set flowVars.StepName = 8.c.ii. Importation Location Details Insert"/>
        <scatter-gather doc:name="Scatter-Gather">
            <choice doc:name="Choice">
                <when expression="#[flowVars.importationPoOError != null]">
                    <validation:is-true message="All Importation Details records are not successfully processed!" expression="#[flowVars.importationPoOError.size() == 0 ]" doc:name="Validation - Importation PoO Result"/>
                    <flow-ref name="permitImportationPoOContacts" doc:name="Importation PoO Contacts Insert"/>
                </when>
                <otherwise>
                    <logger level="INFO" doc:name="Logger"/>
                </otherwise>
            </choice>
            <choice doc:name="Choice">
                <when expression="#[flowVars.importationDestErr != null]">
                    <validation:is-true message="All Importation Details records are not successfully processed!" expression="#[flowVars.importationDestErr.size() == 0 ]" doc:name="Validation - Importation Destination Result"/>
                    <flow-ref name="permitImportationDestination" doc:name="Importation Destination Insert"/>
                </when>
                <otherwise>
                    <logger level="INFO" doc:name="Logger"/>
                </otherwise>
            </choice>

        </scatter-gather>
        <exception-strategy ref="permit_inserts_record_variable_Global_Exception_Strategy" doc:name="Reference Exception Strategy"/>

    </flow>
    <flow name="permitImportationPoOContacts">
        <foreach collection="#[flowVars.impotationPoOSuccess]" doc:name="For Each">
            <dw:transform-message doc:name="Transform Message">
                <dw:set-payload><![CDATA[%dw 1.0
%output application/java
%var PoOContacts = flowVars.importationDetailsSFPayload[0][flowVars.counter - 1].ImportationPoOChilds.IPoOLocationContacts
---
PoOContacts map {
	First_Name__c : $.First_Name__c,
	Name : $.Name,
	Location__c: payload[0].id,
	Primary__c : $.Primary__c,
	Organization_Name__c : $.Organization_Name__c,
	Address__c : $.Address__c,
	County__c : $.County__c,
	City__c : $.City__c,
	State__c : $.State__c,
	Zip__c : $.Zip__c,
	Zip_CBI__c : $.Zip_CBI__c,
	Country__c : $.Country__c,
	Email__c : $.Email__c,
	Email_CBI__c: $.Email_CBI__c,
	Alternate_Email__c : $.Alternate_Email__c,
	Alternate_Email_CBI__c : $.Alternate_Email_CBI__c,
	Phone__c : $.Phone__c,
	Phone_CBI__c: $.Phone_CBI__c,
	Fax__c : $.Fax__c,
	Fax_CBI__c : $.Fax_CBI__c,
	Alternate_Phone__c : $.Alternate_Phone__c,
	Alternate_Phone_CBI__c : $.Alternate_Phone_CBI__c
}]]></dw:set-payload>
            </dw:transform-message>
            <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Related_Contact__c" doc:name="Importation PoO Contacts">
                <sfdc:objects ref="#[payload]"/>
            </sfdc:create>
            <choice doc:name="Choice">
                <when expression="#[payload[0].success==false]">
                    <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();]]></expression-component>
                    <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                </when>
                <otherwise>
                    <logger level="INFO" doc:name="Logger"/>
                </otherwise>
            </choice>

        </foreach>
        <exception-strategy ref="permit_inserts_record_variable_Global_Exception_Strategy" doc:name="Reference Exception Strategy"/>
    </flow>
    <flow name="permitImportationDestination">
        <foreach collection="#[flowVars.importationDestSuccess]" doc:name="For Each">
            <dw:transform-message doc:name="Transform Message">
                <dw:set-payload><![CDATA[%dw 1.0
%output application/java
---

	 {
		ImportationDestinationContacts: flowVars.importationDetailsSFPayload[1][flowVars.counter - 1].ImportationDestChilds.IDestLocationContacts map {
			First_Name__c : $.First_Name__c,
			Name : $.Name,
			Location__c: payload[0].id,
			Primary__c : $.Primary__c,
			Organization_Name__c : $.Organization_Name__c,
			Address__c : $.Address__c,
			County__c : $.County__c,
			City__c : $.City__c,
			State__c : $.State__c,
			Zip__c : $.Zip__c,
			Zip_CBI__c : $.Zip_CBI__c,
			Country__c : $.Country__c,
			Email__c : $.Email__c,
			Email_CBI__c: $.Email_CBI__c,
			Alternate_Email__c : $.Alternate_Email__c,
			Alternate_Email_CBI__c : $.Alternate_Email_CBI__c,
			Phone__c : $.Phone__c,
			Phone_CBI__c: $.Phone_CBI__c,
			Fax__c : $.Fax__c,
			Fax_CBI__c : $.Fax_CBI__c,
			Alternate_Phone__c : $.Alternate_Phone__c,
			Alternate_Phone_CBI__c : $.Alternate_Phone_CBI__c
		},
		ImportationDestinationMaterials : flowVars.importationDetailsSFPayload[1][flowVars.counter - 1].ImportationDestChilds.IDestMaterialType map {		
			Location__c: payload[0].id,
			Quantity__c : $.Quantity__c,
			Unit_of_Measure__c : $.Unit_of_Measure__c,
			Material__c : $.Material__c,
			Material_CBI__c : $.Material_CBI__c,
			Other_Material__c : $.Other_Material__c   	

		}
	}
]]></dw:set-payload>
            </dw:transform-message>
            <scatter-gather doc:name="Scatter-Gather">
                <processor-chain>
                    <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Related_Contact__c" doc:name="Importation Destination Contacts">
                        <sfdc:objects ref="#[payload.ImportationDestinationContacts]"/>
                    </sfdc:create>
                    <choice doc:name="Choice">
                        <when expression="#[payload[0].success==false]">
                            <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();]]></expression-component>
                            <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                        </when>
                        <otherwise>
                            <logger level="INFO" doc:name="Logger"/>
                        </otherwise>
                    </choice>

                </processor-chain>
                <processor-chain>
                    <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Material__c" doc:name="Importation Destination Materials">
                        <sfdc:objects ref="#[payload.ImportationDestinationMaterials]"/>
                    </sfdc:create>
                    <choice doc:name="Choice">
                        <when expression="#[payload[0].success==false]">
                            <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();]]></expression-component>
                            <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                        </when>
                        <otherwise>
                            <logger level="INFO" doc:name="Logger"/>
                        </otherwise>
                    </choice>
                </processor-chain>

            </scatter-gather>
        </foreach>
        <exception-strategy ref="permit_inserts_record_variable_Global_Exception_Strategy" doc:name="Reference Exception Strategy"/>
    </flow>
    <flow name="InterstateDetails">

        <set-variable variableName="StepStart" value="#[dw('now')]" doc:name="Set flowVars.StepStart = DateTime.now()"/>
        <set-variable variableName="StepName" value="8.c.i. Interstate Details Insert" doc:name="Set flowVars.StepName = 8.c.i. Interstate Details Insert"/>
        <choice doc:name="Choice">
            <when expression="#[flowVars.locationDetails.isInterstateDetails != null]">
                <set-payload value="#[flowVars.ApplicationRequest.FileData]" doc:name="Set Payload - flowVars.ApplicationRequest.FileData"/>
                <set-variable variableName="plItemRecordId" value="#[flowVars.PermitLineItemRecordID[0].id]" doc:name="Variable - PermitLineItemRecordID"/>
                <dw:transform-message doc:name="Transform Message" metadata:id="b19e5881-4b19-4380-91b3-50bc8e29607c">
                    <dw:input-payload mimeType="application/xml"/>
                    <dw:set-variable variableName="interstateDetailsSFPayload"><![CDATA[%dw 1.0
%output application/java
%function roundNumberUp (numberToRound)
	((	
	numberToRound - 
	1 / (10 pow (sizeOf (numberToRound - floor numberToRound))-1)
	) as :string {format: "#.000"} as :number) when (numberToRound as :string contains ".") otherwise numberToRound

---
{
	InterstateMovementOriginationPoint : payload.Submission.Application.InterstateDetails.*InterstateMovementOriginationPoint map using(value = $) {
		InterstateMovementOriginationPointMain: {
			Line_Item__c: flowVars.plItemRecordId,
			RecordTypeId: (flowVars.RecordTypeResultSet filter $.DeveloperName == 'Origin_Location')[0].Id,		
			Name : value.LocationName,
			Description__c : value.LocationDescription,
			Street_Add1__c : value.LocationAddressLine1,
			Level_2_Region__c : (flowVars.Level2Regions filter (($.Name == value.LocationCountyProvince) and ($.Level_1_Region__r.Level_1_Region_Code__c == value.LocationState)))[0].Id,
			State__c: (flowVars.Level1Regions filter (($.Level_1_Region_Code__c == value.LocationState) and ($.Country__r.Name == 'United States of America')))[0].Id,
			Country__c: (flowVars.Countries filter ($.Name == 'United States of America'))[0].Id,
			City__c : value.LocationCity,
			Zip__c : value.LocationPostalCode,
			(Zip_CBI__c : true) when (value.LocationPostalCode.@CBI == "true")	
			
		},
		InterstateMovementOriginationPointChild : {
			IMOPLocationContacts : $.*Contact map using(contactLocation = $) {
				First_Name__c : contactLocation.FirstName,
				Name: contactLocation.LastName,
				(Primary__c : true) when (contactLocation.PrimaryFlag != "N"),				
				Organization_Name__c : contactLocation.Organization,
				Address__c : contactLocation.ContDetails.AddressLine1,
				County__c : (flowVars.Level2Regions filter (($.Name == contactLocation.ContDetails.CountyProvince) and ($.Level_1_Region__r.Level_1_Region_Code__c == contactLocation.ContDetails.State)))[0].Id,
				City__c : contactLocation.ContDetails.City,
				State__c: (flowVars.Level1Regions filter (($.Level_1_Region_Code__c == contactLocation.ContDetails.State) and ($.Country__r.Name == contactLocation.ContDetails.Country)))[0].Id,
				Zip__c : contactLocation.ContDetails.PostalCode,
				(Zip_CBI__c : true) when (contactLocation.ContDetails.PostalCode.@CBI == "true"),
				Country__c: (flowVars.Countries filter ($.Name == contactLocation.ContDetails.Country))[0].Id,
				Email__c : contactLocation.ContDetails.Email1,
				(Email_CBI__c: true) when (contactLocation.ContDetails.Email1.@CBI == "true"),	
				Fax__c : contactLocation.ContDetails.FaxTelephone,
				(Fax_CBI__c : true) when (contactLocation.ContDetails.FaxTelephone.@CBI == "true"),		
				Alternate_Email__c : contactLocation.ContDetails.Email2,
				(Alternate_Email_CBI__c : true) when (contactLocation.ContDetails.Email2.@CBI =="true"),
				Phone__c : contactLocation.ContDetails.DayTelephone,
				(Phone_CBI__c: true) when  (contactLocation.ContDetails.DayTelephone.@CBI =="true"),
				Alternate_Phone__c : contactLocation.ContDetails.AlternateTelephone,
				(Alternate_Phone_CBI__c: true) when (contactLocation.ContDetails.AlternateTelephone.@CBI == "true")	
			}
		}
	},
	InterstateMovementDestination : payload.Submission.Application.InterstateDetails.*InterstateMovementDestination map using(value = $) {
		InterstateMovementDestinationMain : {
			Line_Item__c: flowVars.plItemRecordId,	
			RecordTypeId: (flowVars.RecordTypeResultSet filter $.DeveloperName == 'Destination_Location')[0].Id,			
			Name : value.LocationName,
			Description__c : value.LocationDescription,
			Street_Add1__c : value.LocationAddressLine1,
			State__c: (flowVars.Level1Regions filter (($.Level_1_Region_Code__c == value.LocationState) and ($.Country__r.Name == 'United States of America')))[0].Id,
			Level_2_Region__c : (flowVars.Level2Regions filter (($.Name == value.LocationCountyProvince) and ($.Level_1_Region__r.Level_1_Region_Code__c == value.LocationState)))[0].Id,
			Country__c: (flowVars.Countries filter ($.Name == 'United States of America'))[0].Id,
			City__c : value.LocationCity,
			Zip__c : value.LocationPostalCode,
			(Zip_CBI__c : true) when (value.LocationPostalCode.@CBI == "true"),
			Inspected_by_APHIS__c : "No" when value.InspectedByAPHIS != "Y" otherwise "Yes"
		},
		InterstateMovementDestinationChild : {
			IMDestLocationContacts : $.*Contact map using(contactLocation = $) {
				First_Name__c : contactLocation.FirstName,
				Name: contactLocation.LastName,
				(Primary__c : true) when (contactLocation.PrimaryFlag != "N"),		
				Organization_Name__c : contactLocation.Organization,
				Address__c : contactLocation.ContDetails.AddressLine1,
				County__c : (flowVars.Level2Regions filter (($.Name == contactLocation.ContDetails.CountyProvince) and ($.Level_1_Region__r.Level_1_Region_Code__c == contactLocation.ContDetails.State)))[0].Id,
				City__c : contactLocation.ContDetails.City,
				State__c: (flowVars.Level1Regions filter (($.Level_1_Region_Code__c == contactLocation.ContDetails.State) and ($.Country__r.Name == contactLocation.ContDetails.Country)))[0].Id,
				Zip__c : contactLocation.ContDetails.PostalCode,
				(Zip_CBI__c : true) when (contactLocation.ContDetails.PostalCode.@CBI == "true"),
				Country__c: (flowVars.Countries filter ($.Name == contactLocation.ContDetails.Country))[0].Id,
				Email__c : contactLocation.ContDetails.Email1,
				(Email_CBI__c: true) when (contactLocation.ContDetails.Email1.@CBI == "true"),	
				Fax__c : contactLocation.ContDetails.FaxTelephone,
				(Fax_CBI__c : true) when (contactLocation.ContDetails.FaxTelephone.@CBI == "true"),	
				Alternate_Email__c : contactLocation.ContDetails.Email2,
				(Alternate_Email_CBI__c : true) when (contactLocation.ContDetails.Email2.@CBI =="true"),
				Phone__c : contactLocation.ContDetails.DayTelephone,
				(Phone_CBI__c: true) when  (contactLocation.ContDetails.DayTelephone.@CBI =="true"),
				Alternate_Phone__c : contactLocation.ContDetails.AlternateTelephone,
				(Alternate_Phone_CBI__c: true) when (contactLocation.ContDetails.AlternateTelephone.@CBI == "true")	
			},
			IMDestMaterialType:$.*IntroductionMovement map {
				Quantity__c : roundNumberUp($.Quantity),
				Unit_of_Measure__c : $.Units,
				Material__c : $.PlantPart,
				(Material_CBI__c : true) when ($.PlantPart.@CBI =="true"),
				Other_Material__c : $.DescribeOtherMaterial
			}	
		}		
	},
	InterstateMovementOriginAndDestination : payload.Submission.Application.InterstateDetails.*InterstateMovementOriginAndDestination map using(value = $){
		InterstateMovementOriginAndDestinationMain : {
			Line_Item__c: flowVars.plItemRecordId,	
			RecordTypeId: (flowVars.RecordTypeResultSet filter $.DeveloperName == 'Origin_and_Destination')[0].Id,			
			Name : value.LocationName,
			Description__c : value.LocationDescription,
			Street_Add1__c : value.LocationAddressLine1,
			City__c : value.LocationCity,
			Zip__c : value.LocationPostalCode,
			(Zip_CBI__c : true) when (value.LocationPostalCode.@CBI == "true"),
			State__c: (flowVars.Level1Regions filter (($.Level_1_Region_Code__c == value.LocationState) and ($.Country__r.Name == 'United States of America')))[0].Id,
			Level_2_Region__c : (flowVars.Level2Regions filter (($.Name == value.LocationCountyProvince) and ($.Level_1_Region__r.Level_1_Region_Code__c == value.LocationState)))[0].Id,
			Inspected_by_APHIS__c : "No" when value.InspectedByAPHIS != "Y" otherwise "Yes",
			Country__c: (flowVars.Countries filter ($.Name == 'United States of America'))[0].Id
		},
		InterstateMovementOriginAndDestinationChild : {
			IMOAndDestLocationContacts : $.*Contact map using(contactLocation = $) {
				First_Name__c : contactLocation.FirstName,
				Name: contactLocation.LastName,
				(Primary__c : true) when (contactLocation.PrimaryFlag != "N"),	
				Organization_Name__c : contactLocation.Organization,
				Address__c : contactLocation.ContDetails.AddressLine1,
				County__c : (flowVars.Level2Regions filter (($.Name == contactLocation.ContDetails.CountyProvince) and ($.Level_1_Region__r.Level_1_Region_Code__c == contactLocation.ContDetails.State)))[0].Id,
				City__c : contactLocation.ContDetails.City,
				State__c: (flowVars.Level1Regions filter (($.Level_1_Region_Code__c == contactLocation.ContDetails.State) and ($.Country__r.Name == contactLocation.ContDetails.Country)))[0].Id,
				Zip__c : contactLocation.ContDetails.PostalCode,
				(Zip_CBI__c : true) when (contactLocation.ContDetails.PostalCode.@CBI == "true"),
				Country__c: (flowVars.Countries filter ($.Name == contactLocation.ContDetails.Country))[0].Id,
				Email__c : contactLocation.ContDetails.Email1,
				(Email_CBI__c: true) when (contactLocation.ContDetails.Email1.@CBI == "true"),	
				Fax__c : contactLocation.ContDetails.FaxTelephone,
				(Fax_CBI__c : true) when (contactLocation.ContDetails.FaxTelephone.@CBI == "true"),	
				Alternate_Email__c : contactLocation.ContDetails.Email2,
				(Alternate_Email_CBI__c : true) when (contactLocation.ContDetails.Email2.@CBI =="true"),
				Phone__c : contactLocation.ContDetails.DayTelephone,
				(Phone_CBI__c: true) when  (contactLocation.ContDetails.DayTelephone.@CBI =="true"),
				Alternate_Phone__c : contactLocation.ContDetails.AlternateTelephone,
				(Alternate_Phone_CBI__c: true) when (contactLocation.ContDetails.AlternateTelephone.@CBI == "true")	
			},
			IMOAndDestMaterialType:$.*IntroductionMovement map {
				Quantity__c : roundNumberUp($.Quantity),
				Unit_of_Measure__c : $.Units,
				Material__c : $.PlantPart,
				(Material_CBI__c : true) when ($.PlantPart.@CBI =="true"),
				Other_Material__c : $.DescribeOtherMaterial
			}	
		}		
	}
}
]]></dw:set-variable>
                </dw:transform-message>
                <set-variable variableName="interstateMOPSuccess" value="#[new java.util.ArrayList()]" doc:name="Variable - interstateMOPSuccess"/>
                <set-variable variableName="interstateMOPError" value="#[new java.util.ArrayList()]" doc:name="Variable - interstateMOPError"/>
                <foreach collection="#[flowVars.interstateDetailsSFPayload.InterstateMovementOriginationPoint]" doc:name="For Each">
                    <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Location__c" doc:name="Interstate Movement Origination Point">
                        <sfdc:objects ref="#[[payload.InterstateMovementOriginationPointMain]]"/>
                    </sfdc:create>
                    <choice doc:name="Choice">
                        <when expression="#[payload[0].success == true]">
                            <expression-transformer expression="#[flowVars.interstateMOPSuccess.add(payload)]" doc:name="Expression - flowVars.interstateMOPSuccess.add(payload)"/>
                        </when>
                        <otherwise>
                            <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();]]></expression-component>
                            <expression-transformer expression="#[flowVars.interstateMOPError.add(payload)]" doc:name="Expression - flowVars.interstateMOPError.add(payload)"/>
                            <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                        </otherwise>
                    </choice>
                </foreach>
                <set-variable variableName="interstateMDestSuccess" value="#[new java.util.ArrayList()]" doc:name="Variable - interstateMDestSuccess"/>
                <set-variable variableName="interstateMDestError" value="#[new java.util.ArrayList()]" doc:name="Variable - interstateMDestError"/>
                <foreach collection="#[flowVars.interstateDetailsSFPayload.InterstateMovementDestination]" doc:name="For Each">
                    <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Location__c" doc:name="Interstate Movement Destination">
                        <sfdc:objects ref="#[[payload.InterstateMovementDestinationMain]]"/>
                    </sfdc:create>
                    <choice doc:name="Choice">
                        <when expression="#[payload[0].success == true]">
                            <expression-transformer expression="#[flowVars.interstateMDestSuccess.add(payload)]" doc:name="Expression - flowVars.interstateMDestSuccess.add(payload)"/>
                        </when>
                        <otherwise>
                            <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();]]></expression-component>
                            <expression-transformer expression="#[flowVars.interstateMDestError.add(payload)]" doc:name="Expression - flowVars.interstateMDestError.add(payload)"/>
                            <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                        </otherwise>
                    </choice>
                </foreach>
                <set-variable variableName="interstateMOADestSuccess" value="#[new java.util.ArrayList()]" doc:name="Variable - interstateMOADestSuccess"/>
                <set-variable variableName="interstateMOADestError" value="#[new java.util.ArrayList()]" doc:name="Variable - interstateMOADestError"/>
                <foreach collection="#[flowVars.interstateDetailsSFPayload.InterstateMovementOriginAndDestination]" doc:name="For Each">
                    <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Location__c" doc:name="Interstate Movement Origin And Destination">
                        <sfdc:objects ref="#[[payload.InterstateMovementOriginAndDestinationMain]]"/>
                    </sfdc:create>
                    <choice doc:name="Choice">
                        <when expression="#[payload[0].success == true]">
                            <expression-transformer expression="#[flowVars.interstateMOADestSuccess.add(payload)]" doc:name="Expression - flowVars.interstateMOADestSuccess.add(payload)"/>
                        </when>
                        <otherwise>
                            <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();]]></expression-component>
                            <expression-transformer expression="#[flowVars.interstateMOADestError.add(payload)]" doc:name="Expression - flowVars.interstateMOADestError.add(payload)"/>
                            <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                        </otherwise>
                    </choice>
                </foreach>

                <dw:transform-message doc:name="Transform Message">
                    <dw:set-variable variableName="isInterstatePassed"><![CDATA[%dw 1.0
%output application/java
---
((sizeOf flowVars.interstateMOPError) == 0) and ( (sizeOf flowVars.interstateMDestError) == 0) and ( (sizeOf flowVars.interstateMOADestError) == 0)]]></dw:set-variable>
                </dw:transform-message>
                <choice doc:name="Choice">
                    <when expression="#[flowVars.isInterstatePassed]">
                        <flow-ref name="Create-Step-Status-Success" doc:name="Create-Step-Status-Success"/>
                    </when>
                    <otherwise>
                        <flow-ref name="Create-Step-Status-Error" doc:name="Create-Step-Status-Error"/>
                    </otherwise>
                </choice>
            </when>
            <otherwise>
                <logger level="INFO" doc:name="Logger"/>
            </otherwise>
        </choice>

        <exception-strategy ref="permit_inserts_salesforce_stepsGlobal_Exception_Strategy" doc:name="Reference Exception Strategy"/>

    </flow>
    <flow name="processInterstateResult">
        <set-variable variableName="StepStart" value="#[dw('now')]" doc:name="Set flowVars.StepStart = DateTime.now()"/>
        <set-variable variableName="StepName" value="8.c.i. Interstate Details Insert" doc:name="Set flowVars.StepName = 8.c.i. Interstate Details Insert"/>
        <scatter-gather doc:name="Scatter-Gather">
            <choice doc:name="Choice">
                <when expression="#[flowVars.interstateMOPError != null]">
                    <validation:is-true message="All Interstate Details records are not successfully processed!" expression="#[flowVars.interstateMOPError.size() == 0 ]" doc:name="Validation - Interstate MoP Result"/>
                    <flow-ref name="permitInterstateMOPContacts" doc:name="Interstate MoP Contacts Insert"/>
                </when>
                <otherwise>
                    <logger level="INFO" doc:name="Logger"/>
                </otherwise>
            </choice>
            <choice doc:name="Choice">
                <when expression="#[flowVars.interstateMDestError != null]">
                    <validation:is-true message="All Interstate Details records are not successfully processed!" expression="#[flowVars.interstateMDestError.size() == 0 ]" doc:name="Validation - Interstate Destination Result"/>
                    <flow-ref name="permitInterstateDestination" doc:name="Interstate Destination Insert"/>
                </when>
                <otherwise>
                    <logger level="INFO" doc:name="Logger"/>
                </otherwise>
            </choice>
            <choice doc:name="Choice">
                <when expression="#[flowVars.interstateMOADestError != null]">
                    <validation:is-true message="All Interstate Details records are not successfully processed!" expression="#[flowVars.interstateMOADestError.size() == 0 ]" doc:name="Validation - Interstate Movement Result"/>
                    <flow-ref name="permitInterstateMovement" doc:name="Interstate Movement Insert"/>
                </when>
                <otherwise>
                    <logger level="INFO" doc:name="Logger"/>
                </otherwise>
            </choice>

        </scatter-gather>
        <exception-strategy ref="permit_inserts_record_variable_Global_Exception_Strategy" doc:name="Reference Exception Strategy"/>

    </flow>
    <flow name="permitInterstateMOPContacts">
        <foreach collection="#[flowVars.interstateMOPSuccess]" doc:name="For Each">
            <dw:transform-message doc:name="Transform Message">
                <dw:set-payload><![CDATA[%dw 1.0
%output application/java
%var MoPContacts = flowVars.interstateDetailsSFPayload.InterstateMovementOriginationPoint[flowVars.counter - 1].InterstateMovementOriginationPointChild.IMOPLocationContacts
---
MoPContacts map {
	First_Name__c : $.First_Name__c,
	Name : $.Name,
	Location__c: payload[0].id,
	Primary__c : $.Primary__c,
	Organization_Name__c : $.Organization_Name__c,
	Address__c : $.Address__c,
	County__c : $.County__c,
	City__c : $.City__c,
	State__c : $.State__c,
	Zip__c : $.Zip__c,
	Zip_CBI__c : $.Zip_CBI__c,
	Country__c : $.Country__c,
	Email__c : $.Email__c,
	Email_CBI__c: $.Email_CBI__c,
	Alternate_Email__c : $.Alternate_Email__c,
	Alternate_Email_CBI__c : $.Alternate_Email_CBI__c,
	Phone__c : $.Phone__c,
	Phone_CBI__c: $.Phone_CBI__c,
	Fax__c : $.Fax__c,
	Fax_CBI__c : $.Fax_CBI__c,
	Alternate_Phone__c : $.Alternate_Phone__c,
	Alternate_Phone_CBI__c : $.Alternate_Phone_CBI__c
}]]></dw:set-payload>
            </dw:transform-message>
            <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Related_Contact__c" doc:name="Interstate MoP Contacts">
                <sfdc:objects ref="#[payload]"/>
            </sfdc:create>
            <choice doc:name="Choice">
                <when expression="#[payload[0].success==false]">

                    <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();
]]></expression-component>
                    <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                </when>
                <otherwise>
                    <logger level="INFO" doc:name="Logger"/>
                </otherwise>
            </choice>

        </foreach>
        <exception-strategy ref="permit_inserts_record_variable_Global_Exception_Strategy" doc:name="Reference Exception Strategy"/>
    </flow>
    <flow name="permitInterstateDestination">
        <foreach collection="#[flowVars.interstateMDestSuccess]" doc:name="For Each">
            <dw:transform-message doc:name="Transform Message">
                <dw:set-payload><![CDATA[%dw 1.0
%output application/java
---

	 {
		InterstateDestinationContacts: flowVars.interstateDetailsSFPayload.InterstateMovementDestination[flowVars.counter - 1].InterstateMovementDestinationChild.IMDestLocationContacts map {
			First_Name__c : $.First_Name__c,
			Name : $.Name,
			Location__c: payload[0].id,
			Primary__c : $.Primary__c,
			Organization_Name__c : $.Organization_Name__c,
			Address__c : $.Address__c,
			County__c : $.County__c,
			City__c : $.City__c,
			State__c : $.State__c,
			Zip__c : $.Zip__c,
			Zip_CBI__c : $.Zip_CBI__c,
			Country__c : $.Country__c,
			Email__c : $.Email__c,
			Email_CBI__c: $.Email_CBI__c,
			Alternate_Email__c : $.Alternate_Email__c,
			Alternate_Email_CBI__c : $.Alternate_Email_CBI__c,
			Phone__c : $.Phone__c,
			Phone_CBI__c: $.Phone_CBI__c,
			Fax__c : $.Fax__c,
			Fax_CBI__c : $.Fax_CBI__c,
			Alternate_Phone__c : $.Alternate_Phone__c,
			Alternate_Phone_CBI__c : $.Alternate_Phone_CBI__c
		},
		InterstateDestinationMaterials : flowVars.interstateDetailsSFPayload.InterstateMovementDestination[flowVars.counter - 1].InterstateMovementDestinationChild.IMDestMaterialType map {		
			Location__c: payload[0].id,
			Quantity__c : $.Quantity__c,
			Unit_of_Measure__c : $.Unit_of_Measure__c,
			Material__c : $.Material__c,
			Material_CBI__c : $.Material_CBI__c,
			Other_Material__c : $.Other_Material__c   	

		}
	}
]]></dw:set-payload>
            </dw:transform-message>
            <scatter-gather doc:name="Scatter-Gather">
                <processor-chain>
                    <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Related_Contact__c" doc:name="Interstate Destination Contacts">
                        <sfdc:objects ref="#[payload.InterstateDestinationContacts]"/>
                    </sfdc:create>
                    <choice doc:name="Choice">
                        <when expression="#[payload[0].success==false]">

                            <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();
]]></expression-component>
                            <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                        </when>
                        <otherwise>
                            <logger level="INFO" doc:name="Logger"/>
                        </otherwise>
                    </choice>
                </processor-chain>
                <processor-chain>
                    <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Material__c" doc:name="Interstate Destination Materials">
                        <sfdc:objects ref="#[payload.InterstateDestinationMaterials]"/>
                    </sfdc:create>
                    <choice doc:name="Choice">
                        <when expression="#[payload[0].success==false]">

                            <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();
]]></expression-component>
                            <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                        </when>
                        <otherwise>
                            <logger level="INFO" doc:name="Logger"/>
                        </otherwise>
                    </choice>
                </processor-chain>


            </scatter-gather>
        </foreach>
        <exception-strategy ref="permit_inserts_record_variable_Global_Exception_Strategy" doc:name="Reference Exception Strategy"/>
    </flow>
    <flow name="permitInterstateMovement">
        <foreach collection="#[flowVars.interstateMOADestSuccess]" doc:name="For Each">
            <dw:transform-message doc:name="Transform Message">
                <dw:set-payload><![CDATA[%dw 1.0
%output application/java
---

	 {
		InterstateMovementContacts: flowVars.interstateDetailsSFPayload.InterstateMovementOriginAndDestination[flowVars.counter - 1].InterstateMovementOriginAndDestinationChild.IMOAndDestLocationContacts map {
			First_Name__c : $.First_Name__c,
			Name : $.Name,
			Location__c: payload[0].id,
			Primary__c : $.Primary__c,
			Organization_Name__c : $.Organization_Name__c,
			Address__c : $.Address__c,
			County__c : $.County__c,
			City__c : $.City__c,
			State__c : $.State__c,
			Zip__c : $.Zip__c,
			Zip_CBI__c : $.Zip_CBI__c,
			Country__c : $.Country__c,
			Email__c : $.Email__c,
			Email_CBI__c: $.Email_CBI__c,
			Alternate_Email__c : $.Alternate_Email__c,
			Alternate_Email_CBI__c : $.Alternate_Email_CBI__c,
			Phone__c : $.Phone__c,
			Phone_CBI__c: $.Phone_CBI__c,
			Fax__c : $.Fax__c,
			Fax_CBI__c : $.Fax_CBI__c,
			Alternate_Phone__c : $.Alternate_Phone__c,
			Alternate_Phone_CBI__c : $.Alternate_Phone_CBI__c
		},
		InterstateMovementMaterials : flowVars.interstateDetailsSFPayload.InterstateMovementOriginAndDestination[flowVars.counter - 1].InterstateMovementOriginAndDestinationChild.IMOAndDestMaterialType map {
			Location__c: payload[0].id,
			Quantity__c : $.Quantity__c,
			Unit_of_Measure__c : $.Unit_of_Measure__c,
			Material__c : $.Material__c,
			Material_CBI__c : $.Material_CBI__c,
			Other_Material__c : $.Other_Material__c   	

		}
	}
]]></dw:set-payload>
            </dw:transform-message>
            <scatter-gather doc:name="Scatter-Gather">
                <processor-chain>
                    <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Related_Contact__c" doc:name="Interstate Movement Contacts">
                        <sfdc:objects ref="#[payload.InterstateMovementContacts]"/>
                    </sfdc:create>
                    <choice doc:name="Choice">
                        <when expression="#[payload[0].success==false]">

                            <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();
]]></expression-component>
                            <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                        </when>
                        <otherwise>
                            <logger level="INFO" doc:name="Logger"/>
                        </otherwise>
                    </choice>
                </processor-chain>
                <processor-chain>
                    <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Material__c" doc:name="Interstate Movement Materials">
                        <sfdc:objects ref="#[payload.InterstateMovementMaterials]"/>
                    </sfdc:create>
                    <choice doc:name="Choice">
                        <when expression="#[payload[0].success==false]">

                            <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();
]]></expression-component>
                            <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                        </when>
                        <otherwise>
                            <logger level="INFO" doc:name="Logger"/>
                        </otherwise>
                    </choice>
                </processor-chain>


            </scatter-gather>
        </foreach>
        <exception-strategy ref="permit_inserts_record_variable_Global_Exception_Strategy" doc:name="Reference Exception Strategy"/>
    </flow>
    <flow name="ReleaseDetails">

        <set-variable variableName="StepStart" value="#[dw('now')]" doc:name="Set flowVars.StepStart = DateTime.now()"/>
        <set-variable variableName="StepName" value="8.c.iii.  Release Location Insert" doc:name="Set flowVars.StepName = 8.c.iii. Release Location Details Insert"/>
        <choice doc:name="Choice">
            <when expression="#[flowVars.locationDetails.isReleaseDetails != null]">
                <set-payload value="#[flowVars.ApplicationRequest.FileData]" doc:name="Set Payload - flowVars.ApplicationRequest.FileData"/>
                <set-variable variableName="plItemRecordId" value="#[flowVars.PermitLineItemRecordID[0].id]" doc:name="Variable - PermitLineItemRecordID"/>
                <dw:transform-message doc:name="Transform Message" metadata:id="b19e5881-4b19-4380-91b3-50bc8e29607c">
                    <dw:input-payload mimeType="application/xml"/>
                    <dw:set-variable variableName="releaseDetailsSFPayload"><![CDATA[%dw 1.0
%output application/java
%function roundNumberUp (numberToRound)
	((	
	numberToRound - 
	1 / (10 pow (sizeOf (numberToRound - floor numberToRound))-1)
	) as :string {format: "#.000"} as :number) when (numberToRound as :string contains ".") otherwise numberToRound
---
 [
	payload.Submission.Application.ReleaseDetails.*ReleaseLocation map using(value = $)  {
		ReleaseLocationObject:{
			Line_Item__c: flowVars.plItemRecordId,	
			RecordTypeId: (flowVars.RecordTypeResultSet filter $.DeveloperName == 'Release_Location')[0].Id,		
			Name : value.LocationName,
			Description__c : value.LocationDescription,
			Street_Add1__c : value.LocationAddressLine1,
			City__c : value.LocationCity,
			(GPS_Co_ordinates_CBI__c : true) when (value.GPSCoordinates.@CBI == "true"),
			Zip__c : value.LocationPostalCode,
			(Zip_CBI__c : true) when (value.LocationPostalCode.@CBI == "true"),
			Country__c: (flowVars.Countries filter ($.Name == 'United States of America'))[0].Id,
			State__c: (flowVars.Level1Regions filter (($.Level_1_Region_Code__c == value.LocationState) and ($.Country__r.Name == 'United States of America')))[0].Id,
			Level_2_Region__c : (flowVars.Level2Regions filter (($.Name == value.LocationCountyProvince) and ($.Level_1_Region__r.Level_1_Region_Code__c == value.LocationState)))[0].Id,
			Inspected_by_APHIS__c : "No" when value.InspectedByAPHIS != "Y" otherwise "Yes",
			Location_Unique_Id__c : value.LocationUniqueID,
			Release_History__c : value.ReleaseSiteHistory,
			(Release_History_CBI__c : true) when (value.ReleaseSiteHistory.@CBI == "true"),
			Critical_Habitat_Involved__c : "No" when value.CriticalHabitatFlag != "Y" otherwise "Yes",
			If_Yes_Please_Explain__c : value.CriticalHabitatEffectAnalysis,
			(If_Yes_Please_Explain_CBI__c : true) when (value.CriticalHabitatEffectAnalysis.@CBI == "true"),
			Number_of_Acres__c : roundNumberUp(value.NumberofAcres),
			(Number_of_Acres_CBI__c : true) when (value.NumberofAcres.@CBI == "true"),
			Proposed_Planting__c : value.NumberofProposedPlantings,
			(Number_of_Proposed_Releases_CBI__c : true) when (value.NumberofProposedPlantings.@CBI == "true")
			
		},
		ReleaseChilds :{
			RelLocationContacts : value.*Contact map using(contactLocation = $) {
				First_Name__c : contactLocation.FirstName,
				Name: contactLocation.LastName,
				(Primary__c : true) when (contactLocation.PrimaryFlag != "N"),		
				Organization_Name__c : contactLocation.Organization,
				Address__c : contactLocation.ContDetails.AddressLine1,
				County__c : (flowVars.Level2Regions filter (($.Name == contactLocation.ContDetails.CountyProvince) and ($.Level_1_Region__r.Level_1_Region_Code__c == contactLocation.ContDetails.State)))[0].Id,
				City__c : contactLocation.ContDetails.City,
				State__c: (flowVars.Level1Regions filter (($.Level_1_Region_Code__c == contactLocation.ContDetails.State) and ($.Country__r.Name == contactLocation.ContDetails.Country)))[0].Id,
				Zip__c : contactLocation.ContDetails.PostalCode,
				(Zip_CBI__c : true) when (contactLocation.ContDetails.PostalCode.@CBI == "true"),
				Country__c: (flowVars.Countries filter ($.Name == contactLocation.ContDetails.Country))[0].Id,
				Email__c : contactLocation.ContDetails.Email1,
				(Email_CBI__c: true) when (contactLocation.ContDetails.Email1.@CBI == "true"),	
				Fax__c : contactLocation.ContDetails.FaxTelephone,
				(Fax_CBI__c : true) when (contactLocation.ContDetails.FaxTelephone.@CBI == "true"),				
				Alternate_Email__c : contactLocation.ContDetails.Email2,
				(Alternate_Email_CBI__c : true) when (contactLocation.ContDetails.Email2.@CBI =="true"),
				Phone__c : contactLocation.ContDetails.DayTelephone,
				(Phone_CBI__c: true) when  (contactLocation.ContDetails.DayTelephone.@CBI =="true"),
				Alternate_Phone__c : contactLocation.ContDetails.AlternateTelephone,
				(Alternate_Phone_CBI__c: true) when (contactLocation.ContDetails.AlternateTelephone.@CBI == "true")	
			},
			RelGPSCoordinates : value.GPSCoordinates.*GPSLatitude map using(index = $$, valuegps= $) {
				GPS_Coordinates__Latitude__s : valuegps,
				GPS_Coordinates__Longitude__s : value.GPSCoordinates.*GPSLongitude[index]
			}			
		}		
	}
]]]></dw:set-variable>
                </dw:transform-message>
                <set-variable variableName="releaseLocationSuccess" value="#[new java.util.ArrayList()]" doc:name="Variable - releaseLocationSuccess"/>
                <set-variable variableName="releaseLocationError" value="#[new java.util.ArrayList()]" doc:name="Variable- releaseLocationError"/>
                <foreach collection="#[flowVars.releaseDetailsSFPayload[0]]" doc:name="For Each">
                    <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Location__c" doc:name="Release Location">
                        <sfdc:objects ref="#[[payload.ReleaseLocationObject]]"/>
                    </sfdc:create>
                    <choice doc:name="Choice">
                        <when expression="#[payload[0].success == true]">
                            <expression-transformer expression="#[flowVars.releaseLocationSuccess.add(payload)]" doc:name="Expression - flowVars.releaseLocationSuccess.add(payload)"/>
                        </when>
                        <otherwise>

                            <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();
]]></expression-component>
                            <expression-transformer expression="#[flowVars.releaseLocationError.add(payload)]" doc:name="Expression - flowVars.releaseLocationError.add(payload)"/>
                            <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                        </otherwise>
                    </choice>
                </foreach>
                <choice doc:name="Choice">
                    <when expression="#[flowVars.releaseLocationError.size() == 0]">
                        <flow-ref name="Create-Step-Status-Success" doc:name="Create-Step-Status-Success"/>
                    </when>
                    <otherwise>
                        <flow-ref name="Create-Step-Status-Error" doc:name="Create-Step-Status-Error"/>
                    </otherwise>
                </choice>
            </when>
            <otherwise>
                <logger level="INFO" doc:name="Logger"/>
            </otherwise>
        </choice>

        <exception-strategy ref="permit_inserts_salesforce_stepsGlobal_Exception_Strategy" doc:name="Reference Exception Strategy"/>

    </flow>
    <flow name="processReleaseResult">
        <set-variable variableName="StepStart" value="#[dw('now')]" doc:name="Set flowVars.StepStart = DateTime.now()"/>
        <set-variable variableName="StepName" value="8.c.iii.  Release Location Insert" doc:name="Set flowVars.StepName = 8.c.iii. Release Location Details Insert"/>
        <choice doc:name="Choice">
            <when expression="#[flowVars.releaseLocationError != null]">
                <validation:is-true message="All Importation Details records are not successfully processed!" expression="#[flowVars.releaseLocationError.size() == 0 ]" doc:name="Validation - Release Location Result"/>
                <foreach collection="#[flowVars.releaseLocationSuccess]" doc:name="For Each">
                    <dw:transform-message doc:name="Transform Message">
                        <dw:set-payload><![CDATA[%dw 1.0
%output application/java
---

	 {
		ReleaseLocationContacts: flowVars.releaseDetailsSFPayload[0][flowVars.counter - 1].ReleaseChilds.RelLocationContacts map {
			First_Name__c : $.First_Name__c,
			Name : $.Name,
			Location__c: payload[0].id,
			Primary__c : $.Primary__c,
			Organization_Name__c : $.Organization_Name__c,
			Address__c : $.Address__c,
			County__c : $.County__c,
			City__c : $.City__c,
			State__c : $.State__c,
			Zip__c : $.Zip__c,
			Zip_CBI__c : $.Zip_CBI__c,
			Country__c : $.Country__c,
			Email__c : $.Email__c,
			Email_CBI__c: $.Email_CBI__c,
			Alternate_Email__c : $.Alternate_Email__c,
			Alternate_Email_CBI__c : $.Alternate_Email_CBI__c,
			Phone__c : $.Phone__c,
			Phone_CBI__c: $.Phone_CBI__c,
			Fax__c : $.Fax__c,
			Fax_CBI__c : $.Fax_CBI__c,
			Alternate_Phone__c : $.Alternate_Phone__c,
			Alternate_Phone_CBI__c : $.Alternate_Phone_CBI__c
		},
		ReleaseLocationGPS : flowVars.releaseDetailsSFPayload[0][flowVars.counter - 1].ReleaseChilds.RelGPSCoordinates map {			
			Location__c: payload[0].id,
			GPS_Coordinates__Latitude__s : $.GPS_Coordinates__Latitude__s,
			GPS_Coordinates__Longitude__s : $.GPS_Coordinates__Longitude__s	

		}
	}
]]></dw:set-payload>
                    </dw:transform-message>
                    <scatter-gather doc:name="Scatter-Gather">
                        <processor-chain>
                            <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Related_Contact__c" doc:name="Release Location Contacts">
                                <sfdc:objects ref="#[payload.ReleaseLocationContacts]"/>
                            </sfdc:create>
                            <choice doc:name="Choice">
                                <when expression="#[payload[0].success==false]">

                                    <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();
]]></expression-component>
                                    <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                                </when>
                                <otherwise>
                                    <logger level="INFO" doc:name="Logger"/>
                                </otherwise>
                            </choice>
                        </processor-chain>
                        <processor-chain>
                            <sfdc:create config-ref="Salesforce__Basic_Authentication" type="GPS_Coordinate__c" doc:name="Release Location GPS Coordinates">
                                <sfdc:objects ref="#[payload.ReleaseLocationGPS]"/>
                            </sfdc:create>
                            <choice doc:name="Choice">
                                <when expression="#[payload[0].success==false]">

                                    <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();
]]></expression-component>
                                    <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                                </when>
                                <otherwise>
                                    <logger level="INFO" doc:name="Logger"/>
                                </otherwise>
                            </choice>
                        </processor-chain>
                    </scatter-gather>
                </foreach>
            </when>
            <otherwise>
                <logger level="INFO" doc:name="Logger"/>
            </otherwise>
        </choice>

        <exception-strategy ref="permit_inserts_record_variable_Global_Exception_Strategy" doc:name="Reference Exception Strategy"/>

    </flow>

    <flow name="previouslySubmittedConstructFlow">
        <set-variable variableName="StepStart" value="#[dw('now')]" doc:name="Set flowVars.StepStart = DateTime.now()"/>
        <set-variable variableName="StepName" value="10. Previously Submitted Construct Insert" doc:name="Set flowVars.StepName = 10. Previously Submitted Construct Insert"/>
        <validation:is-true message="Regulated Article Records are not Inserted successfully" expression="#[flowVars.regulatedArticleErrors.size() == 0]" doc:name="Validation - Regulated Article Result"/>
        <set-variable variableName="inputXMLFile" value="#[flowVars.ApplicationRequest.FileData]" mimeType="application/xml" doc:name="flowVars.ApplicationRequest.FileData"/>
        <set-variable variableName="plItemRecordId" value="#[flowVars.PermitLineItemRecordID[0].id]" doc:name="Variable - PermitLineItemRecordID"/>
        <dw:transform-message doc:name="Transform Message">
            <dw:set-payload><![CDATA[%dw 1.0
%output application/java
---
{
	psc :(flowVars.inputXMLFile.Submission.Application.PreviouslySubmittedConstruct.*ConstructName map {
			(constructName : $)	when (($ != null) and ($ != ""))
		}).constructName when (flowVars.inputXMLFile.Submission.Application.PreviouslySubmittedConstruct !=null) otherwise [],
	isNotification : flowVars.ApplicationRequest.Application_Type__c == "Notification"

}]]></dw:set-payload>
            <dw:set-variable variableName="allSubmitedConstructs"><![CDATA[%dw 1.0
%output application/java
---
(flowVars.inputXMLFile.Submission.Application.PreviouslySubmittedConstruct.*ConstructName map {
	constructName : $
	
}).constructName when (flowVars.inputXMLFile.Submission.Application.PreviouslySubmittedConstruct !=null) otherwise []]]></dw:set-variable>
            <dw:set-variable variableName="isNotification"><![CDATA[%dw 1.0
%output application/java
---
( flowVars.ApplicationRequest.Application_Type__c == "Notification" )
]]></dw:set-variable>
        </dw:transform-message>
        <set-variable variableName="insertPSConstructs" value="#[new java.util.ArrayList()]" doc:name="Variable - insertPSConstructs"/>
        <set-variable variableName="invalidSubmitedConstruct" value="#[new java.util.ArrayList()]" doc:name="Variable - invalidSubmitedConstruct"/>
        <set-variable variableName="noCBIConstructs" value="#[new java.util.ArrayList()]" doc:name="Variable - noCBIConstructs"/>
        <choice doc:name="Choice">
            <when expression="#[isNotification]">
                <enricher source="#[payload]" target="#[flowVars.Construct]" doc:name="flowVars.Construct">
                    <sfdc:non-paginated-query config-ref="Salesforce__Basic_Authentication" query="SELECT Construct_s__c, Id, CBI_application__c FROM Construct__c WHERE Authorization_Type__c = 'Notification' and OwnerID = '#[flowVars.ApplicationCreatedByID.CreatedById]'" doc:name="Query Construct__c"/>
                </enricher>
            </when>
            <otherwise>
                <enricher source="#[payload]" target="#[flowVars.Construct]" doc:name="flowVars.Construct">
                    <sfdc:non-paginated-query config-ref="Salesforce__Basic_Authentication" query="SELECT Construct_s__c, Id, CBI_application__c FROM Construct__c WHERE OwnerID = '#[flowVars.ApplicationCreatedByID.CreatedById]' " doc:name="Query Construct__c"/>
                </enricher>
            </otherwise>
        </choice>
        <foreach rootMessageVariableName="currentValue" doc:name="For Each" collection="#[payload.psc]" >
            <set-variable variableName="currentValue" value="#[payload]" doc:name="Variable - currentValue"/>
            <dw:transform-message doc:name="Transform Message">
                <dw:set-payload><![CDATA[%dw 1.0
%output application/java
---
payload map {
	constructs : [(flowVars.Construct filter $.Construct_s__c == $)[0]] when ((flowVars.Construct filter $.Construct_s__c == $)[0] != null) otherwise []
}
]]></dw:set-payload>
            </dw:transform-message>
            <dw:transform-message doc:name="Transform Message">
                <dw:set-variable variableName="constructResult"><![CDATA[%dw 1.0
%output application/java
---

{
	invalidCBIConstructs : (payload filter not ((
			not (($.constructs.CBI_application__c[0] == 'Yes')  and (flowVars.inputXMLFile.Submission.Application.ApplicationCBIFlag == 'N'))
		) when ((sizeOf $.constructs) > 0) otherwise false)).Construct_s__c,
	invalidConstruct : (payload filter not ((sizeOf $.constructs) > 0)).Construct_s__c,
	validConstructs : payload filter  ((
			not (($.constructs.CBI_application__c[0] == 'Yes')  and (flowVars.inputXMLFile.Submission.Application.ApplicationCBIFlag == 'N'))
		) when ((sizeOf $.constructs) > 0) otherwise false)
	
}
]]></dw:set-variable>
            </dw:transform-message>
            <choice doc:name="Choice - ifInvalidConstruct">
                <when expression="#[flowVars.constructResult.invalidConstruct.size() &gt; 0]">
                    <expression-transformer expression="#[flowVars.invalidSubmitedConstruct.add(flowVars.currentValue)]" doc:name="Expression - flowVars.invalidSubmitedConstruct.add(flowVars.currentValue)"/>
                </when>
                <otherwise>
                    <logger level="INFO" doc:name="Logger"/>
                </otherwise>
            </choice>
            <choice doc:name="Choice - invalid CBI">
                <when expression="#[flowVars.constructResult.invalidCBIConstructs.size() &gt; 0]">
                    <expression-transformer expression="#[flowVars.noCBIConstructs.add(flowVars.currentValue)]" doc:name="Expression - noCBIConstructs"/>
                </when>
                <otherwise>
                    <logger level="INFO" doc:name="Logger"/>
                </otherwise>
            </choice>

            <choice doc:name="Choice - ifValidConstruct">
                <when expression="#[flowVars.constructResult.validConstructs.size() &gt; 0]">
                    <dw:transform-message doc:name="Transform Message">
                        <dw:set-payload><![CDATA[%dw 1.0
%output application/java
---
flowVars.constructResult.validConstructs map {
	Line_Item__c: flowVars.plItemRecordId,
	Construct__c : $.Id
}]]></dw:set-payload>
                    </dw:transform-message>
                    <sfdc:create config-ref="" type="Construct_Application_Junction__c" doc:name="insertPreviouslySubmittedConstruct">
                        <sfdc:objects/>
                    </sfdc:create>
                    <expression-component doc:name="Expression"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

if(payload[0].success != 'true'){
	for(int i = 0; i< payload[0].errors.size(); i++){
		flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
	}
}

if(flowVars.ErrorTextTemp.size() > 0){
	flowVars.insertPSConstructs.add(flowVars.ErrorTextTemp.toString());
}
]]></expression-component>
                </when>
                <otherwise>
                    <logger level="INFO" doc:name="Logger"/>
                </otherwise>
            </choice>
        </foreach>


        <choice doc:name="Choice">
            <when expression="#[flowVars.insertPSConstructs.isEmpty() &amp;&amp; flowVars.noCBIConstructs.isEmpty() &amp;&amp; flowVars.invalidSubmitedConstruct.isEmpty()]">
                <flow-ref name="Create-Step-Status-Success" doc:name="Create-Step-Status-Success"/>
            </when>
            <otherwise>
                 <set-variable variableName="ErrorText" value="#[&quot;Errors reported from salesforce :- &quot; + flowVars.insertPSConstructs.toString() + &quot;Constructs that are not present in Salesforce :-&quot; + flowVars.invalidSubmitedConstruct.toString() + 'Construct with No CBI value'+ flowVars.noCBIConstructs.toString()]" doc:name="Variable - ErrorText"/>
                <flow-ref name="Create-Step-Status-Error" doc:name="Create-Step-Status-Error"/>
            </otherwise>
        </choice>
        <exception-strategy ref="permit_inserts_salesforce_stepsGlobal_Exception_Strategy" doc:name="Reference Exception Strategy"/>
    </flow>

    
    <flow name="Construct">
        <set-variable variableName="StepStart" value="#[dw('now')]" doc:name="Set flowVars.StepStart = DateTime.now()"/>
        <set-variable variableName="StepName" value="9. Construct Insert" doc:name="Set flowVars.StepName = 9. Construct Insert"/>

        <validation:is-true message="Regulated Article Records are not Inserted successfully" expression="#[flowVars.regulatedArticleErrors.size() == 0]" doc:name="Validation - Regulated Article Result"/>
                <set-variable variableName="constructError" value="#[new java.util.ArrayList()]" doc:name="Variable - PermitConstructError"/>
                <set-variable variableName="permitConstructResult" value="#[new java.util.ArrayList()]" doc:name="Variable - Permit Construct ResultsetSuccess"/>
        <set-payload value="#[flowVars.ApplicationRequest.FileData]" doc:name="Set Payload - flowVars.ApplicationRequest.FileData"/>

        <set-variable variableName="plItemRecordId" value="#[flowVars.PermitLineItemRecordID[0].id]" doc:name="Variable - PermitLineItemRecordID"/>
        <dw:transform-message doc:name="Transform Message" metadata:id="b19e5881-4b19-4380-91b3-50bc8e29607c">
            <dw:input-payload mimeType="application/xml"/>
            <dw:set-payload><![CDATA[%dw 1.0
%output application/java
//%var regulatedArticleId = (flowVars.RegulatedArticles filter ($.Scientific_Name__c == payload.Submission.Application.Article.ScientificName))[0].Id
---
(payload.Submission.Application.*PhenotypicDesignation map using(value = $) {
	Line_Item__c: flowVars.plItemRecordId,
	Link_Regulated_Article__c: (flowVars.RegulatedArticles filter ($.Scientific_Name__c == value.ArticleScientificName))[0].Id,
	Construct_s__c: value.Construct,
	Identifying_Line_s__c: value.Lines,
	Mode_of_Transformation__c: value.ModeofTransformation,
	(Mode_of_Transformation_CBI__c: true) when  (value.ModeofTransformation.@CBI =="true"),
	OwnerId : flowVars.ApplicationCreatedByID.CreatedById
})]]></dw:set-payload>
        </dw:transform-message>
            	            
            	<foreach batchSize="200" doc:name="For Each">
            <flow-ref name="permitConstructInsertFlow" doc:name="permitConstructInsertFlow"/>

            	</foreach>
                <choice doc:name="Choice">
                    <when expression="#[flowVars.constructError.isEmpty()]">
                        <flow-ref name="Create-Step-Status-Success" doc:name="Create-Step-Status-Success"/>
                    </when>
                    <otherwise>
                        <flow-ref name="Create-Step-Status-Error" doc:name="Create-Step-Status-Error"/>
                    </otherwise>
                </choice>
        <exception-strategy ref="permit_inserts_salesforce_stepsGlobal_Exception_Strategy" doc:name="Reference Exception Strategy"/>


    </flow>


    <flow name="permitConstructInsertFlow">
        <enricher source="#[payload]" target="#[flowVars.permitConstructID]" doc:name="flowVars.permitConstructID">
            <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Construct__c" doc:name="insertConstruct">
                <sfdc:objects ref="#[payload]"/>
            </sfdc:create>
        </enricher>

        <validation:is-true message="#[flowVars.permitConstructID[0].errors]" expression="#[flowVars.permitConstructID[0].success == 'true']" doc:name="Validation - payload.success == 'true'"/>
        <dw:transform-message doc:name="Transform Message">
            <dw:set-payload><![CDATA[%dw 1.0
%output application/java
---
{
	"salesforceResult": flowVars.permitConstructID,
	"currentRecord" : payload
}]]></dw:set-payload>
        </dw:transform-message>
        <expression-transformer expression="#[flowVars.permitConstructResult.add(payload)]" doc:name="Expression -  Appending Construct Success"/>

        <catch-exception-strategy doc:name="Catch Exception Strategy">
            <expression-transformer expression="#[flowVars.constructError.add(flowVars.permitConstructID[0].errors[0])]" doc:name="Expression - Appending Construct Error"/>

            <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< flowVars.permitConstructID[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((flowVars.permitConstructID[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();
]]></expression-component>
            <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
            <set-payload value="#[false]" doc:name="Set Payload = false"/>
        </catch-exception-strategy>
    </flow>

    <flow name="processConstructResult">
        <set-variable variableName="StepStart" value="#[dw('now')]" doc:name="Set flowVars.StepStart = DateTime.now()"/>
        <set-variable variableName="StepName" value="9. Construct Insert" doc:name="Set flowVars.StepName = 9. Construct Insert"/>
        <choice doc:name="Choice">
            <when expression="#[flowVars.constructError != null]">
                <validation:is-true message="All construct records are not successfully processed!" expression="#[flowVars.constructError.size() == 0]" doc:name="Validation - Construct Result"/>
                <foreach collection="#[flowVars.permitConstructResult]" rootMessageVariableName="rootMessageCR" doc:name="For Each - Construct Result">
                    <scatter-gather doc:name="Scatter-Gather">
                        <flow-ref name="permitPhenotypeInsertFlow" doc:name="permitPhenotypeInsertFlow"/>
                        <flow-ref name="permitGenotypeInsertFlow" doc:name="permitGenotypeInsertFlow"/>
                    </scatter-gather>
                </foreach>
            </when>
            <otherwise>
                <logger level="INFO" doc:name="Logger"/>
            </otherwise>
        </choice>
        <exception-strategy ref="permit_inserts_record_variable_Global_Exception_Strategy" doc:name="Reference Exception Strategy"/>


    </flow>
    <flow name="permitPhenotypeInsertFlow">
        <set-variable variableName="StepStart" value="#[dw('now')]" doc:name="Set flowVars.StepStart = DateTime.now()"/>
        <set-variable variableName="StepName" value="9.a. Phenotype Insert" doc:name="Set flowVars.StepName = 9.a. Phenotype Insert"/>    
        <set-variable variableName="constructPayload" value="#[payload]" doc:name="Variable - constructPayload"/>
        <set-payload value="#[flowVars.ApplicationRequest.FileData]" doc:name="Set Payload - flowVars.ApplicationRequest.FileData"/>
        <dw:transform-message doc:name="Transform Message" metadata:id="b19e5881-4b19-4380-91b3-50bc8e29607c">
            <dw:input-payload mimeType="application/xml"/>
            <dw:set-payload><![CDATA[%dw 1.0
%output application/java
---
(flowVars.permitConstructResult[0].salesforceResult map (value, index) ->  {
	tempArr : (payload.Submission.Application.*PhenotypicDesignation filter $.Construct == flowVars.permitConstructResult[0].currentRecord[index].Construct_s__c)[0].*Phenotypes  map {
		Phenotypic_Category__c: $.PhenotypeCategory,
		Phenotypic_Description__c: $.Phenotype,
		Construct__c : flowVars.permitConstructResult[0].salesforceResult[index].id
	}
}).tempArr

]]></dw:set-payload>
        </dw:transform-message>
        <set-variable variableName="phenotypeErrors" value="#[new java.util.ArrayList()]" doc:name="Variable - phenotypeErrors"/>
        <foreach doc:name="For Each">
            <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Phenotype__c" doc:name="insertPhenotypeSalesforce">
                <sfdc:objects ref="#[payload]"/>
            </sfdc:create>
            <choice doc:name="Choice">
                <when expression="#[payload[0].success == false]">

                    <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();
]]></expression-component>
                    <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                    <expression-transformer expression="#[flowVars.phenotypeErrors.add(payload)]" doc:name="Expression - flowVars.phenotypeErrors.add(payload)"/>

                </when>
                <otherwise>
                    <logger level="INFO" doc:name="Logger"/>
                </otherwise>
            </choice>
        </foreach>

        <choice doc:name="Choice">
            <when expression="#[flowVars.phenotypeErrors.size() == 0]">
                <flow-ref name="Create-Step-Status-Success" doc:name="Create-Step-Status-Success"/>
            </when>
            <otherwise>
                <flow-ref name="Create-Step-Status-Error" doc:name="Create-Step-Status-Error"/>
            </otherwise>
        </choice>
         <catch-exception-strategy doc:name="Catch Exception Strategy">

            <expression-transformer expression="#[constructError.add(flowVars.phenotypeErrors[0][0].errors[0])]" doc:name="Expression - constructError.add(flowVars.phenotypeErrors[0][0].errors[0])"/>

            <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< flowVars.phenotypeErrors[0][0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((flowVars.phenotypeErrors[0][0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();
]]></expression-component>
            <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
            <set-payload value="#[false]" doc:name="Set Payload = false"/>
        </catch-exception-strategy>
    </flow>
    <flow name="permitGenotypeInsertFlow">
        <set-variable variableName="StepStart" value="#[dw('now')]" doc:name="Set flowVars.StepStart = DateTime.now()"/>
        <set-variable variableName="StepName" value="9.b. Genotype Insert" doc:name="Set flowVars.StepName = 9.b. Genotype Insert Insert"/>     
        <set-variable variableName="constructPayload" value="#[payload]" doc:name="Variable - constructPayload"/>
        <set-payload value="#[flowVars.ApplicationRequest.FileData]" doc:name="Set Payload - flowVars.ApplicationRequest.FileData"/>
        <dw:transform-message doc:name="Transform Message" metadata:id="b19e5881-4b19-4380-91b3-50bc8e29607c">
            <dw:input-payload mimeType="application/xml"/>
            <dw:set-variable variableName="genotypeArray"><![CDATA[%dw 1.0
%output application/java
---
flatten ((flowVars.permitConstructResult[0].salesforceResult map (value, index) ->  {
	tempArr : (payload.Submission.Application.*PhenotypicDesignation filter $.Construct == flowVars.permitConstructResult[0].currentRecord[index].Construct_s__c)[0].*Genotype  map {
	genotypeData : {
			Genotype_Category__c: $.GenotypeType,
			Construct__c : flowVars.permitConstructResult[0].salesforceResult[index].id
		},
	constructComponents : $.*ConstructComponent map {
			Construct_Component_Name__c: $.ConstructComponentNameorFunction,
			Construct_Component__c: $.ConstructComponentType,
			Description__c: $.ConstructComponentDescription,
			Donor_List__c: $.Donor,
			Construct_Component_Sort_Order__c: $.ConstructComponentSortOrder as :number,
			Related_Construct_Record_Number__c : flowVars.permitConstructResult[0].salesforceResult[index].id
		}
	}
}).tempArr)
]]></dw:set-variable>

        </dw:transform-message>
        <set-variable variableName="genotypeErrors" value="#[new java.util.ArrayList()]" doc:name="Variable - genotypeErrors"/>
        <foreach doc:name="For Each" collection="#[flowVars.genotypeArray]">
            <set-variable variableName="constructComponents" value="#[payload.constructComponents]" doc:name="Variable - payload.constructComponents"/>
            <sfdc:create config-ref="Salesforce__Basic_Authentication" type="GenotypeType__c" doc:name="insertGenotypeSalesforce">
                <sfdc:objects ref="#[[payload.genotypeData]]"/>
            </sfdc:create>
            <choice doc:name="Choice">
                <when expression="#[payload[0].success == false]">

                    <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();
]]></expression-component>
                    <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
                    <expression-transformer expression="#[flowVars.genotypeErrors.add(payload)]" doc:name="Expression - flowVars.genotypeErrors.add(payload)"/>

                </when>
                <otherwise>

                    <flow-ref name="permitConstructComponentInsertFlow" doc:name="permitConstructComponentInsertFlow"/>

                </otherwise>
            </choice>
        </foreach>

        <choice doc:name="Choice">
            <when expression="#[flowVars.genotypeErrors.size() == 0]">
                <flow-ref name="Create-Step-Status-Success" doc:name="Create-Step-Status-Success"/>
            </when>
            <otherwise>
                <flow-ref name="Create-Step-Status-Error" doc:name="Create-Step-Status-Error"/>
            </otherwise>
        </choice>
         <catch-exception-strategy doc:name="Catch Exception Strategy">
            <expression-transformer expression="#[constructError.add(flowVars.genotypeErrors[0][0].errors[0])]" doc:name="Expression - constructError.add(flowVars.genotypeErrors[0][0].errors[0])"/>

            <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< flowVars.genotypeErrors[0][0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((flowVars.genotypeErrors[0][0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();]]></expression-component>
            <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
            <set-payload value="#[false]" doc:name="Set Payload = false"/>
        </catch-exception-strategy>
    </flow>
    <flow name="permitConstructComponentInsertFlow">
        <dw:transform-message doc:name="Transform Message">
            <dw:set-payload><![CDATA[%dw 1.0
%output application/java
---
flowVars.constructComponents map {
	Construct_Component_Name__c: $.Construct_Component_Name__c,
	Construct_Component__c: $.Construct_Component__c,
	Description__c: $.Description__c,
	Donor_List__c: $.Donor_List__c,
	Construct_Component_Sort_Order__c: $.Construct_Component_Sort_Order__c as :number,
	GenotypeType__c: payload[0].id,
	Related_Construct_Record_Number__c : $.Related_Construct_Record_Number__c
}]]></dw:set-payload>
        </dw:transform-message>
        <sfdc:create config-ref="Salesforce__Basic_Authentication" type="Genotype__c" doc:name="insertComponent">
            <sfdc:objects ref="#[payload]"/>
        </sfdc:create>
        <choice doc:name="Choice">
            <when expression="#[payload[0].success == false]">
                <expression-component doc:name="Expression - ErrorText"><![CDATA[flowVars.ErrorTextTemp = new java.util.ArrayList();

for(int i = 0; i< payload[0].errors.size(); i++){
	flowVars.ErrorTextTemp.add((payload[0].errors[i].toString()).replaceAll(",",":").replaceAll("\n",":"));
}

flowVars.ErrorText = flowVars.ErrorTextTemp.toString();
]]></expression-component>
                <flow-ref name="addErrorFlow" doc:name="addErrorFlow"/>
            </when>
            <otherwise>
                <logger level="INFO" doc:name="Logger"/>
            </otherwise>
        </choice>

        <exception-strategy ref="permit_inserts_record_variable_Global_Exception_Strategy" doc:name="Reference Exception Strategy"/>
    </flow>

    <choice-exception-strategy name="permit_inserts_salesforce_stepsGlobal_Exception_Strategy">
        <catch-exception-strategy doc:name="Catch Exception Strategy- Data Transformation Failure" when="#[exception.causedBy(org.mule.api.transformer.TransformerException)]">
            <set-variable variableName="ErrorText" value="#[exception.getDetailedMessage()]" doc:name="Set flowVars.ErrorText"/>
            <flow-ref name="Create-Step-Status-Error" doc:name="Create-Step-Status-Error"/>
            <set-payload value="#[false]" doc:name="Set Payload = false"/>
        </catch-exception-strategy>
        <catch-exception-strategy doc:name="Catch Exception Strategy- Validation Failure" when="#[exception.causedBy(org.mule.extension.validation.api.ValidationException)]">
            <logger message="recording error for #[flowVars.StepName]" level="INFO" doc:name="Logger"/>
            <set-variable variableName="ErrorText" value="#[exception.getMessage()]" doc:name="Set flowVars.ErrorText"/>
            <flow-ref name="Create-Step-Status-Error" doc:name="Create-Step-Status-Error"/>
            <set-payload value="#[false]" doc:name="Set Payload = false"/>
        </catch-exception-strategy>
        <catch-exception-strategy doc:name="Catch Exception Strategy - Other Any error" when="#[exception.causedBy(java.lang.Exception)]">
            <set-variable variableName="ErrorText" value="#[exception.getMessage()]" doc:name="Set flowVars.ErrorText "/>
            <flow-ref name="Create-Step-Status-Error" doc:name="Create-Step-Status-Error"/>
            <set-payload value="#[false]" doc:name="Set Payload = false"/>
        </catch-exception-strategy>
    </choice-exception-strategy>
    <choice-exception-strategy name="permit_inserts_record_variable_Global_Exception_Strategy">
        <catch-exception-strategy when="#[exception.causedBy(org.mule.api.transformer.TransformerException)]" doc:name="Catch Exception Strategy- Data Transformation Failure">
            <set-variable variableName="ErrorText" value="#[exception.getDetailedMessage()]" doc:name="Set flowVars.ErrorText"/>
            <dw:transform-message doc:name="Transform Message">
                <dw:set-payload><![CDATA[%dw 1.0
%output application/java
---
{
	"StepName" : flowVars.StepName,
	"StepStart" : flowVars.StepStart,
	"ErrorDetails" : flowVars.ErrorText
}]]></dw:set-payload>
            </dw:transform-message>
            <expression-transformer expression="#[flowVars.ErrorList.add(payload)]" doc:name="Expression - flowVars.ErrorList.add(payload)"/>
        </catch-exception-strategy>
        <catch-exception-strategy when="#[exception.causedBy(org.mule.extension.validation.api.ValidationException)]" doc:name="Catch Exception Strategy- Validation Failure">
            <set-variable variableName="ErrorText" value="#[exception.getMessage()]" doc:name="Set flowVars.ErrorText"/>
            <dw:transform-message doc:name="Transform Message">
                <dw:set-payload><![CDATA[%dw 1.0
%output application/java
---
{
	"StepName" : flowVars.StepName,
	"StepStart" : flowVars.StepStart,
	"ErrorDetails" : flowVars.ErrorText
}]]></dw:set-payload>
            </dw:transform-message>
            <expression-transformer expression="#[flowVars.ErrorList.add(payload)]" doc:name="Expression - flowVars.ErrorList.add(payload)"/>
        </catch-exception-strategy>
        <catch-exception-strategy when="#[exception.causedBy(java.lang.Exception)]" doc:name="Catch Exception Strategy - Other Any error">
            <set-variable variableName="ErrorText" value="#[exception.getMessage()]" doc:name="Set flowVars.ErrorText "/>
            <dw:transform-message doc:name="Transform Message">
                <dw:set-payload><![CDATA[%dw 1.0
%output application/java
---
{
	"StepName" : flowVars.StepName,
	"StepStart" : flowVars.StepStart,
	"ErrorDetails" : flowVars.ErrorText
}]]></dw:set-payload>
            </dw:transform-message>
            <expression-transformer expression="#[flowVars.ErrorList.add(payload)]" doc:name="Expression - flowVars.ErrorList.add(payload)"/>
        </catch-exception-strategy>
    </choice-exception-strategy>
    <flow name="addErrorFlow">
        <dw:transform-message doc:name="Transform Message">
            <dw:set-payload><![CDATA[%dw 1.0
%output application/java
---
{
	"StepName" : flowVars.StepName,
	"StepStart" : flowVars.StepStart,
	"ErrorDetails" : flowVars.ErrorText
}]]></dw:set-payload>
        </dw:transform-message>
        <expression-transformer expression="#[flowVars.ErrorList.add(payload)]" doc:name="Expression - flowVars.ErrorList.add(payload)"/>
    </flow>


   
</mule>
