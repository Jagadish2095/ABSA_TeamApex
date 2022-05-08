/**
* Mock class for Reg Services Involved Parties
* @author  Himanshu Nimje
* @created 2018-11-23
*/

@isTest
global class RegSer_InvlovedPartiesJointMock_ApiRest implements HttpCalloutMock {

    Private String typeTest;
    
    global RegSer_InvlovedPartiesJointMock_ApiRest (final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setBody('{  "content" : {    "suin" : "1-8Y8HFU",    "created" : "2019-02-21T00:03:34",    "updated" : "2019-02-21T00:03:35",    "individual" : null,    "formalOrganisation" : null,    "informalOrganisation" : {      "jointParticipanCount" : null,      "name" : "NAIAR MR A & MRS B",      "pepStatus" : {        "code" : "",        "description" : ""      },      "subStatus" : {        "code" : "",        "description" : ""      },      "status" : {        "code" : "Active",        "description" : "Active"      },      "ficaAddressUpdateDate" : null,      "ficaAddressAttestedDate" : null,      "sourceOfIncomeAttestedDate" : null,      "nextRefreshDate" : null,      "identificationUpdateDate" : null,      "identificationAttestedDate" : null,      "type" : {        "code" : "Joint & several",        "description" : "Joint & several"      },      "revenueSegment" : null,      "primaryContact" : null,      "manager" : null,      "natureOfBusiness" : {        "code" : "",        "description" : ""      }    },    "organisationUnit" : null,    "sourcesOfIncome" : [ {      "code" : "",      "description" : ""    } ],    "sourcesOfWealth" : [ ],    "activeInIndustries" : [ ],    "flags" : [ {      "effectiveDate" : null,      "yesNoFlag" : true,      "type" : {        "code" : "ABSA",        "description" : "ABSA"      }    }, {      "effectiveDate" : "2019-02-21",      "yesNoFlag" : true,      "type" : {        "code" : "Contact method : Email",        "description" : "Contact method : Email"      }    }, {      "effectiveDate" : "2019-02-21",      "yesNoFlag" : false,      "type" : {        "code" : "Marketing Preference : Call",        "description" : "Marketing Preference : Call"      }    }, {      "effectiveDate" : "2019-02-21",      "yesNoFlag" : false,      "type" : {        "code" : "Marketing Preference: Email",        "description" : "Marketing Preference: Email"      }    }, {      "effectiveDate" : "2019-02-21",      "yesNoFlag" : false,      "type" : {        "code" : "Marketing Preference: Mail",        "description" : "Marketing Preference: Mail"      }    }, {      "effectiveDate" : "2019-02-21",      "yesNoFlag" : false,      "type" : {        "code" : "Marketing Preference: SMS",        "description" : "Marketing Preference: SMS"      }    }, {      "effectiveDate" : null,      "yesNoFlag" : false,      "type" : {        "code" : "SBU Segment",        "description" : "SBU Segment"      }    } ],    "countries" : [ ],    "identifications" : [ {      "number" : "NAIARA+001",      "type" : {        "code" : "CIF Code",        "description" : "CIF Code"      },      "expiryDate" : null,      "issueDate" : null    }, {      "number" : "1-8Y8HFU",      "type" : {        "code" : "PARTYMDM",        "description" : "PARTYMDM"      },      "expiryDate" : null,      "issueDate" : null    }, {      "number" : "1-8Y8HFU",      "type" : {        "code" : "REGSERVICES",        "description" : "REGSERVICES"      },      "expiryDate" : null,      "issueDate" : null    } ],    "addresses" : {      "preferredCommunicationChannel" : null,      "telephonicAddress" : [ {        "countryCode" : "+27",        "diallingCode" : "011",        "number" : "5077058",        "context" : {          "code" : "MainPhone",          "description" : "MainPhone"        },        "type" : {          "code" : "MainPhone",          "description" : "MainPhone"        }      } ],      "addresses" : [ {        "addressName1" : "Asd",        "addressName2" : "",        "suburbName" : "",        "cityName" : "Abbotsford",        "countryName" : "",        "postalCode" : "2192",        "context" : {          "code" : "Postal",          "description" : "Postal"        },        "gpsCoordinates" : null,        "type" : {          "code" : "Postal",          "description" : "Postal"        }      } ],      "electronicAddresses" : [ ]    },    "relationships" : [ ],    "relatedDocuments" : [ ],    "riskRating" : null,    "name" : "NAIAR MR A & MRS B"  },  "links" : [ {    "rel" : "regulatory-compliance",    "href" : "/v1/involved-parties/regulatory-compliance/Organisation/Organisation"  } ]}');
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }else if(typeTest == StringConstants.UNHANDLED_EXCEPTION_STATUS){
            response.setBody('{}');
            response.setStatusCode(200);
        }
        return response; 
    }
}