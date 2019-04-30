<apikit:mapping-exception-strategy name="asd-apiKitGlobalExceptionMapping">
        <apikit:mapping statusCode="404">
            <apikit:exception value="org.mule.module.apikit.exception.NotFoundException" />
            <set-property propertyName="Content-Type" value="application/json" doc:name="Property"/>
            <set-payload value="{ &quot;message&quot;: &quot;Resource not found&quot; }" doc:name="Set Payload"/>
        </apikit:mapping>
        <apikit:mapping statusCode="405">
            <apikit:exception value="org.mule.module.apikit.exception.MethodNotAllowedException" />
            <set-property propertyName="Content-Type" value="application/json" doc:name="Property"/>
            <set-payload value="{ &quot;message&quot;: &quot;Method not allowed&quot; }" doc:name="Set Payload"/>
        </apikit:mapping>
        <apikit:mapping statusCode="415">
            <apikit:exception value="org.mule.module.apikit.exception.UnsupportedMediaTypeException" />
            <set-property propertyName="Content-Type" value="application/json" doc:name="Property"/>
            <set-payload value="{ &quot;message&quot;: &quot;Unsupported media type&quot; }" doc:name="Set Payload"/>
        </apikit:mapping>
        <apikit:mapping statusCode="406">
            <apikit:exception value="org.mule.module.apikit.exception.NotAcceptableException" />
            <set-property propertyName="Content-Type" value="application/json" doc:name="Property"/>
            <set-payload value="{ &quot;message&quot;: &quot;Not acceptable&quot; }" doc:name="Set Payload"/>
        </apikit:mapping>
        <apikit:mapping statusCode="400">
            <apikit:exception value="org.mule.module.apikit.exception.BadRequestException" />
            <set-property propertyName="Content-Type" value="application/json" doc:name="Property"/>
            <set-payload value="{ &quot;message&quot;: &quot;Bad request&quot; }" doc:name="Set Payload"/>
        </apikit:mapping>
    </apikit:mapping-exception-strategy>
