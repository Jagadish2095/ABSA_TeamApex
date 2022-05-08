/**
* @description Integration Utility
* @author  Taras Kuliievych
* @since 2021-07-14
**/
public with sharing class SMIntegrationUtility {
    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-08-17
    * @param requestBean
    * @param endpointSuffix
    * @param customHeaders
    * @param integrationServiceName
    * @param apexTypeP
    * @param bodyChanges
    **/
    public SMIntegrationUtility (Base_IB requestBean,
                                    String endpointSuffix,
                                    Map<String,String> customHeaders,
                                    String integrationServiceName,
                                    System.Type apexTypeP,
                                    Map<String, String> bodyChanges) {
        this.serviceCallData = new ServiceCallData();
        this.serviceCallData.requestBean = requestBean;
        this.serviceCallData.endpointSuffix = endpointSuffix;
        this.serviceCallData.customHeaders = customHeaders;
        this.serviceCallData.integrationServiceName = integrationServiceName;
        this.serviceCallData.apexTypeP = apexTypeP;
        this.serviceCallData.bodyChanges = bodyChanges;
    }

    /**
    * @description data class for integration call
    * @author  Taras Kuliievych
    * @since 2021-07-17
    **/
    private class ServiceCallData {
        Base_IB requestBean;
        Base_IB responseBean;
        Sys_Log_Integration__c log;
        HttpRequest httpRequest;
        HttpResponse httpResponse;
        String responseJSON;
        String endpointSuffix;
        Map<String,String> customHeaders;
        String integrationServiceName;
        System.Type apexTypeP;
        Map<String, String> bodyChanges;

        List<Integration_Service__c> integrationServices;
    }
    /**
    * @description data var for integration call
    **/
    private ServiceCallData serviceCallData;

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    * @return String
    **/
    public String serializedIntegrationServiceCall() {
        try {
            this.serviceCallData.integrationServices = Sys_Utilities_Integration.getIntegrationServices(
                this.serviceCallData.integrationServiceName);

            this.serializedCallProcessing();
        } catch (Exception e) {
            actionsForCallExceptions(e);
        }

        this.insertLog();

        return this.serviceCallData.responseJSON;
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    **/
    private void serializedCallProcessing() {
        if (this.serviceCallData.integrationServices != null
            && this.serviceCallData.integrationServices.size() == 1) {
            RawResponse rawResponse = requestToService();
            if (rawResponse.status) {
                this.serviceCallData.responseJSON = rawResponse.httpResponse.getBody();
            } else {
                String message = rawResponse.message;
                this.serviceCallData.log = SystemLogger.mapResponseFields(this.serviceCallData.log, 400,
                                                                            StringConstants.STATUS_CODE_400,
                                                                            message);
            }

        } else {
            this.serviceCallData.responseJSON = JSON.serialize(requestIsNotPossible());
        }
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    * @return Base_IB
    **/
    public Base_IB deserializedIntegrationServiceCall() {
        try {
            this.serviceCallData.integrationServices = Sys_Utilities_Integration.getIntegrationServices(
                this.serviceCallData.integrationServiceName);

            this.deserializedCallProcessing();
        } catch (Exception e) {
            actionsForCallExceptions(e);
        }

        this.insertLog();

        return this.serviceCallData.responseBean;
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    **/
    private void deserializedCallProcessing() {
        if (this.serviceCallData.integrationServices != null && this.serviceCallData.integrationServices.size() == 1) {
            RawResponse rawResponse = requestToService();
            if (rawResponse.status) {
                this.serviceCallData.responseBean = (Base_IB) Sys_Utilities_Integration.mapResponseFields(
                    rawResponse.httpResponse, this.serviceCallData.apexTypeP);
            } else {
                String message = rawResponse.message;
                this.serviceCallData.responseBean = (Base_IB)Sys_Utilities_Integration.mapFailedResponseFields(
                    400, StringConstants.STATUS_CODE_400, message, this.serviceCallData.apexTypeP);
                this.serviceCallData.log = SystemLogger.mapResponseFields(
                    this.serviceCallData.log, 400, StringConstants.STATUS_CODE_400, message);
            }

        } else {
            this.serviceCallData.responseBean = requestIsNotPossible();
        }
    }

    /**
    * @description
    * @author Taras Kuliievych
    * @since 2021-07-14
    * @param e
    **/
    private void actionsForCallExceptions(Exception e) {
        //Create a bad response for an exception
        String message = this.createCallExceptionMessage(e);

        this.serviceCallData.responseBean = (Base_IB)Sys_Utilities_Integration.mapFailedResponseFields(
            500,StringConstants.STATUS_CODE_500, message, this.serviceCallData.apexTypeP);

        this.callExceptionLoging(message);
    }

    /**
    * @description
    * @author Taras Kuliievych
    * @since 2021-07-14
    * @param e
    * @return String
    **/
    private String createCallExceptionMessage(Exception e) {
        if (this.serviceCallData.httpResponse != null) {
            return('Exception: ' + e.getMessage() + '. StackTrace: '
                + e.getStackTraceString() + '. Response body: '
                + this.serviceCallData.httpResponse.getBody());
        } else {
            return('Exception: ' + e.getMessage() + '. StackTrace: ' + e.getStackTraceString());
        }
    }

    /**
    * @description
    * @author Taras Kuliievych
    * @since 2021-07-14
    * @param message
    **/
    private void callExceptionLoging(String message) {
        if (this.serviceCallData.log != null) {
            this.serviceCallData.log = SystemLogger.mapResponseFields(
                this.serviceCallData.log, 500, StringConstants.STATUS_CODE_500, message);
        } else {
            String destinationSystem = this.serviceCallData.httpRequest != null
            ? this.serviceCallData.httpRequest.getEndpoint() : this.serviceCallData.integrationServiceName; // PJAIN: 20200612: Added destinationSystem to replace serviceName.
            this.serviceCallData.log = SystemLogger.createInternalIntegrationLog(
                this.serviceCallData.integrationServiceName, destinationSystem, 500, StringConstants.STATUS_CODE_500, message);
        }
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    * @return Base_IB
    **/
    private Base_IB requestIsNotPossible() {
        String message = this.createRequestIsNotPossibleMessage();

        this.serviceCallData.responseBean = (Base_IB)Sys_Utilities_Integration.mapFailedResponseFields(
            500, StringConstants.STATUS_CODE_500, message, this.serviceCallData.apexTypeP);
        this.serviceCallData.log = SystemLogger.createInternalIntegrationLog(
            this.serviceCallData.integrationServiceName, this.serviceCallData.integrationServiceName,
            500, StringConstants.STATUS_CODE_500, message);

        return this.serviceCallData.responseBean;
    }

    /**
    * @description
    * @author Taras Kuliievych
    * @since 2021-07-14
    * @return String
    **/
    private String createRequestIsNotPossibleMessage() {
        if (this.serviceCallData.integrationServices == null || this.serviceCallData.integrationServices.size() == 0) {
            return 'No Integration Service record found with Name: '
            + this.serviceCallData.integrationServiceName + ' for Environment: ' + Sys_Utilities_General.getEnvironment();
        } else {
            return 'More than 1 Integration Service records found (Count: '
            + this.serviceCallData.integrationServices.size() + ') with Name: '
            + this.serviceCallData.integrationServiceName + ' for Environment: '
            + Sys_Utilities_General.getEnvironment() + '. Only 1 record should exist with this name. Delete the extra Integration Service records.';
        }
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    * @return RawResponse
    **/
    private RawResponse requestToService() {
        String jsonString = this.createRequestBodyJSON();
        RawResponse rawResponse = new RawResponse();

        this.serviceCallData.httpRequest = Sys_Utilities_Integration.mapHttpRequest(this.serviceCallData.integrationServices[0], jsonString);

        this.processingRequestEndpointSuffix();
        this.processingRequestCustomHeaders();

        // Loging
        this.serviceCallData.log = SystemLogger.createRequestIntegrationLog(
            this.serviceCallData.httpRequest.getBody(), this.serviceCallData.integrationServiceName,
            StringConstants.SALESFORCE_STRING, this.serviceCallData.httpRequest.getEndpoint());

        this.processingRequestBeanValidationMessage(rawResponse);

        return rawResponse;
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    * @param rawResponse
    **/
    private void processingRequestBeanValidationMessage(RawResponse rawResponse) {
        // Validate that all the required fields are populated
        String requestBeanValidationMessage = this.serviceCallData.requestBean != null ? this.serviceCallData.requestBean.validate() : null;

        if (String.isBlank(requestBeanValidationMessage)) {
            //Send Request
            this.serviceCallData.httpResponse = Sys_Utilities_Integration.serviceCalloutWithoutLogging(this.serviceCallData.httpRequest);
            this.serviceCallData.log = SystemLogger.mapResponseFields(
                this.serviceCallData.log, this.serviceCallData.httpResponse.getStatusCode(),
                this.serviceCallData.httpResponse.getStatus(), this.serviceCallData.httpResponse.getBody());

            rawResponse.status = true;
            rawResponse.httpResponse = getResponseFields();
        } else {
            rawResponse.status = false;
            rawResponse.message = requestBeanValidationMessage;
        }
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    **/
    private void processingRequestCustomHeaders() {
        if (this.serviceCallData.customHeaders?.size() > 0) {
            for (String key : this.serviceCallData.customHeaders.keySet()) {
                // If customHeaders is not null or empty, add the headers to the request
                this.serviceCallData.httpRequest.setHeader(key, this.serviceCallData.customHeaders.get(key));
            }
        }
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    **/
    private void processingRequestEndpointSuffix() {
        if (String.isNotBlank(this.serviceCallData.endpointSuffix)) {
            // If endpointSuffix is not blank, append it to the endpoint
            this.serviceCallData.httpRequest.setEndpoint(
                this.serviceCallData.httpRequest.getEndpoint() + this.serviceCallData.endpointSuffix);
        }
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    * @return String
    **/
    private String createRequestBodyJSON() {
        if (this.serviceCallData.requestBean == null) {
            return null;
        }

        // PJDURANDT: 20201211: If the requestBean is of type Sys_Utilities_Integration_StringBody_IB
        // the JSON string will be set to the body variable of Sys_Utilities_Integration_StringBody_IB
        // else the Bean will be serialized.
        if (this.serviceCallData.requestBean instanceOf Sys_Utilities_Integration_StringBody_IB ) {
            return ((Sys_Utilities_Integration_StringBody_IB) this.serviceCallData.requestBean).body;
        } else {
            return this.serviceCallData.requestBean.serialize(this.serviceCallData.requestBean);
        }
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    **/
    private void insertLog() {
        if (this.serviceCallData.log != null) {
            SystemLogger.insertLog(this.serviceCallData.log);
        }
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    * @return Base_IB
    **/
    private HttpResponse getResponseFields() {
        String responseBody = this.serviceCallData.httpResponse.getBody();

        for (String key : this.serviceCallData.bodyChanges.keySet()) {
            responseBody = responseBody.replace(key, this.serviceCallData.bodyChanges.get(key));
        }
        this.serviceCallData.httpResponse.setBody(responseBody);
        return this.serviceCallData.httpResponse;
    }


    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    **/
    private class RawResponse {
        Boolean status;
        HttpResponse httpResponse;
        String message;
    }
}