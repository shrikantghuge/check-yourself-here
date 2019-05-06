<?xml version="1.0" encoding="UTF-8"?>

<mule xmlns:file="http://www.mulesoft.org/schema/mule/file" xmlns:context="http://www.springframework.org/schema/context" xmlns:sftp="http://www.mulesoft.org/schema/mule/sftp"
	xmlns:http="http://www.mulesoft.org/schema/mule/http"
	xmlns="http://www.mulesoft.org/schema/mule/core" xmlns:doc="http://www.mulesoft.org/schema/mule/documentation"
	xmlns:spring="http://www.springframework.org/schema/beans" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.mulesoft.org/schema/mule/sftp http://www.mulesoft.org/schema/mule/sftp/current/mule-sftp.xsd
http://www.mulesoft.org/schema/mule/http http://www.mulesoft.org/schema/mule/http/current/mule-http.xsd
http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-current.xsd
http://www.mulesoft.org/schema/mule/core http://www.mulesoft.org/schema/mule/core/current/mule.xsd
http://www.mulesoft.org/schema/mule/file http://www.mulesoft.org/schema/mule/file/current/mule-file.xsd
http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-current.xsd">



    <sftp:connector name="SFTP-Configuration" validateConnections="true" doc:name="SFTP">
        <reconnect-forever frequency="1000" blocking="false" />       
    </sftp:connector>
    
    <sftp:endpoint exchange-pattern="one-way" host="${sftp.host}" port="${sftp.port}" name="SftpEP" responseTimeout="10000" doc:name="SFTP"  password="${sftp.pass}" user="${sftp.user}" path="${sftp.path}"/>
    <file:connector name="File" autoDelete="true" streaming="true" validateConnections="true" doc:name="File"/>
    <context:property-placeholder location="sftp.properties"/>
    
    <flow name="sftp-dummyFlow">
        <file:inbound-endpoint path="src/test/resources/in" connector-ref="File" responseTimeout="10000" doc:name="File">
            <file:filename-regex-filter pattern=".*" caseSensitive="true"/>
        </file:inbound-endpoint>
        <logger level="INFO" doc:name="Logger" message="Getting file #[message.inboundProperties.originalFilename]"/>
        <set-variable variableName="soutputPattern" value="#[dw(&quot;now as :localdatetime {format:'yyyy-MM-dd HH:mm:ss.S'} as :string {format:'MMddyy-HHmmssS'}&quot;;)]" doc:name="Variable"/>
        <message-properties-transformer scope="invocation" doc:name="Message Properties">
            <add-message-property key="outputPattern" value="#[dw(&quot;'2017-10-20 15:29:05.0' as :localdatetime {format:'yyyy-MM-dd HH:mm:ss.S'} as :string {format:'MMddyyHHmmss'}&quot;;)]"/>
        </message-properties-transformer>
        <set-property propertyName="soutputPattern" value="#[dw(&quot;'2017-10-20 15:29:05.0' as :localdatetime {format:'yyyy-MM-dd HH:mm:ss.S'} as :string {format:'MMddyyHHmmss'}&quot;;)]" doc:name="Property"/>
        <component class="com.mulesoft.support.SftpReSftpCreateFolder" doc:name="Java Create Remote Folder"/>
        <sftp:outbound-endpoint exchange-pattern="one-way" connector-ref="SFTP-Configuration"         
        		outputPattern="#[flowVars.soutputPattern]/#[message.inboundProperties.originalFilename]" 
        		host="${sftp.host}" port="${sftp.port}" 
        		path="${sftp.path}" user="${sftp.user}" password="${sftp.pass}" 
        		responseTimeout="10000" doc:name="SFTP-outbound" duplicateHandling="overwrite"   		
        		/>
        <logger level="INFO" doc:name="Logger" message="File written"/>
    </flow>
</mule>
