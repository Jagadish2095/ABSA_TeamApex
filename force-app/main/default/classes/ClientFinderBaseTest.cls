/**  
 * @Purpose      : Test Class for ClientFinderBase
 * @Author       : Dreamwares 
 * @Created Date : 06/09/2018
 */
@isTest
public class ClientFinderBaseTest {
       /*
     * Purpose : Method to create test data
     */
    @testSetup
    static void dataCreation(){
    	Account account = new Account(Name = 'Test Account', CIF__c = 'T0231');
        insert account;
    }
    
    //Class to set mock response
    public class MockResponseGenerator implements HttpCalloutMock {
        //Method to return mock response
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            
            if (req.getEndpoint().equalsIgnoreCase('https://esb.ext.api.absa.co.za/enterprise-ext/ext/compose360/v1.0/clients/GetClients?queryType=cif&regId=AEDESIG008&view=BASIC_VIEW&hideMeta=true') && req.getMethod().equalsIgnoreCase('GET')){
                String body =		'{'+
            '        "meta": {'+
            '            "queryResult": {'+
            '                "type": "primary",'+
            '                "sourceSystem": "cif"'+
            '            }'+
            '        },'+
            '        "individual": {'+
            '            "givenName": {'+
            '                "value": ""'+
            '            },'+
            '            "nameInitials": {'+
            '                "value": ""'+
            '            },'+
            '            "surname": {'+
            '                "value": "ADVANCED ENGINEERING DESIGNS"'+
            '            },'+
            '            "salutationType": {'+
            '                "code": {'+
            '                    "value": "00"'+
            '                },'+
            '                "description": {'+
            '                    "value": null'+
            '                }'+
            '            },'+
            '            "countryPassport": {'+
            '                "code": {'+
            '                    "value": "00;"'+
            '                },'+
            '                "description": {'+
            '                    "value": null'+
            '                }'+
            '            },'+
            '            "countryOfBirth": {'+
            '                "code": {'+
            '                    "value": ""'+
            '                },'+
            '                "description": {'+
            '                    "value": null'+
            '                }'+
            '            },'+
            '            "gender": {'+
            '                "code": {'+
            '                    "value": "0"'+
            '                },'+
            '                "description": {'+
            '                    "value": null'+
            '                }'+
            '            },'+
            '            "nationality": {'+
            '                "code": {'+
            '                    "value": "00;"'+
            '                },'+
            '                "description": {'+
            '                    "value": null'+
            '                }'+
            '            },'+
            '            "employmentStatusType": {'+
            '                "code": {'+
            '                    "value": "00;"'+
            '                },'+
            '                "description": {'+
            '                    "value": null'+
            '                }'+
            '            }'+
            '        },'+
            '        "customerDetails": {'+
            '            "identificationTypeId": {'+
            '                "code": {'+
            '                    "value": "05"'+
            '                },'+
            '                "description": {'+
            '                    "value": "REGISTRATION NO"'+
            '                }'+
            '            },'+
            '            "individualId": {'+
            '                "value": "196308285384"'+
            '            },'+
            '            "universalResourceLocator": {'+
            '                "value": ""'+
            '            },'+
            '            "customerType": {'+
            '                "code": {'+
            '                    "value": "031"'+
            '                },'+
            '                "description": {'+
            '                    "value": "CLOSE CORPORATION"'+
            '                }'+
            '            },'+
            '            "groupScheme": {'+
            '                "code": {'+
            '                    "value": "N"'+
            '                },'+
            '                "description": {'+
            '                    "value": "NON-INDIVIDUAL"'+
            '                }'+
            '            },'+
            '            "sourceOfFundsCode": {'+
            '                "code": {'+
            '                    "value": "00;"'+
            '                },'+
            '                "description": {'+
            '                    "value": null'+
            '                }'+
            '            },'+
            '            "sourceOfIncomeCode": {'+
            '                "code": {'+
            '                    "value": "00"'+
            '                },'+
            '                "description": {'+
            '                    "value": null'+
            '                }'+
            '            },'+
            '            "corporateDivision": {'+
            '                "code": {'+
            '                    "value": "A"'+
            '                },'+
            '                "description": {'+
            '                    "value": "CORPORATE AND INVESTMENT BANKING"'+
            '                }'+
            '            },'+
            '            "inLiquidation": {'+
            '                "value": "NO"'+
            '            },'+
            '            "underJudicialManagement": {'+
            '                "value": "NO"'+
            '            },'+
            '            "financialCrime": {'+
            '                "value": "N"'+
            '            },'+
            '            "NCAThreshold": {'+
            '                "value": "NO"'+
            '            },'+
            '            "CPAThreshold": {'+
            '                "value": "NO"'+
            '            },'+
            '            "sbuSegment": {'+
            '                "code": {'+
            '                    "value": "H"'+
            '                },'+
            '                "description": {'+
            '                    "value": "BUSINESS BANK"'+
            '                }'+
            '            },'+
            '            "inBusinessRescue": {'+
            '                "value": ""'+
            '            },'+
            '            "inBusinessRescueAffectedParty": {'+
            '                "value": "N"'+
            '            },'+
            '            "placedInBusinessRescueBy": {'+
            '                "value": "0"'+
            '            },'+
            '            "forensicHold": {'+
            '                "value": "NO"'+
            '            },'+
            '            "businessRescueIssueDate": {}'+
            '        },'+
            '        "location": {'+
            '            "physicalAddress": {'+
            '                "addressName1": {'+
            '                    "value": ""'+
            '                },'+
            '                "addressName2": {'+
            '                    "value": ""'+
            '                },'+
            '                "suburbName": {'+
            '                    "value": ""'+
            '                },'+
            '                "cityName": {'+
            '                    "value": ""'+
            '                },'+
            '                "postCodeArea": {'+
            '                    "value": ""'+
            '                }'+
            '            },'+
            '            "postalAddress": {'+
            '                "addressName1": {'+
            '                    "value": "PO BOX 9385"'+
            '                },'+
            '                "addressName2": {'+
            '                    "value": ""'+
            '                },'+
            '                "suburbName": {'+
            '                    "value": ""'+
            '                },'+
            '                "cityName": {'+
            '                    "value": "ELSBURG"'+
            '                },'+
            '                "postCodeArea": {'+
            '                    "value": "1407"'+
            '                },'+
            '                "addressTypeCode": {'+
            '                    "value": ""'+
            '                }'+
            '            },'+
            '            "businessAddress": {'+
            '                "addressName1": {'+
            '                    "value": "26 HARRIETT AVENUE"'+
            '                },'+
            '                "addressName2": {'+
            '                    "value": ""'+
            '                },'+
            '                "suburbName": {'+
            '                    "value": ""'+
            '                },'+
            '                "cityName": {'+
            '                    "value": "GERMISTON"'+
            '                },'+
            '                "postCodeArea": {'+
            '                    "value": "1401"'+
            '                },'+
            '                "addressType": {'+
            '                    "value": "20"'+
            '                }'+
            '            },'+
            '            "headOfficeAddress": {'+
            '                "addressName1": {'+
            '                    "value": ""'+
            '                },'+
            '                "addressName2": {'+
            '                    "value": ""'+
            '                },'+
            '                "suburbName": {'+
            '                    "value": ""'+
            '                },'+
            '                "cityName": {'+
            '                    "value": ""'+
            '                },'+
            '                "postCodeArea": {'+
            '                    "value": ""'+
            '                },'+
            '                "addressType": {'+
            '                    "value": ""'+
            '                }'+
            '            }'+
            '        },'+
            '        "contact": {'+
            '            "cellPhoneNumber": {'+
            '                "value": "0"'+
            '            },'+
            '            "communicationChannelType": {'+
            '                "code": {'+
            '                    "value": "01"'+
            '                },'+
            '                "description": {'+
            '                    "value": "POST"'+
            '                }'+
            '            },'+
            '            "workPhone": {'+
            '                "value": "(011) 873 8919"'+
            '            },'+
            '            "homePhone": {'+
            '                "value": "(011) 873 8919"'+
            '            },'+
            '            "eMailUserId": {'+
            '                "value": ""'+
            '            },'+
            '            "contactPerson": {'+
            '                "value": "DOWN"'+
            '            },'+
            '            "designation": {'+
            '                "value": "MANAGER"'+
            '            }'+
            '        },'+
            '        "corporateEntity": {'+
            '            "incorporatedCountry": {'+
            '                "code": {'+
            '                    "value": "00;"'+
            '                },'+
            '                "description": {'+
            '                    "value": null'+
            '                }'+
            '            },'+
            '            "standardIndustryCode": {'+
            '                "code": {'+
            '                    "value": "86900"'+
            '                },'+
            '                "description": {'+
            '                    "value": "86900 - COMPUTER AND RELATED ACTIVITIES : OTHER COMPUTER RELATE"'+
            '                }'+
            '            }'+
            '        },'+
            '        "identifications": ['+
            '            {'+
            '                "type": {'+
            '                    "code": "cif",'+
            '                    "description": null'+
            '                },'+
            '                "number": "AEDESIG008",'+
            '                "personalIdentificationFlag": false,'+
            '                "systemIdentificationFlag": false,'+
            '                "issueDate": "0001-01-01T00:00:00",'+
            '                "expiryDate": "0001-01-01T00:00:00",'+
            '                "country": null'+
            '            }'+
            '        ],'+
            '        "_links": null'+
            '    }';
                res.setBody(body);
            }else if (req.getEndpoint().equalsIgnoreCase('https://esb.ext.api.absa.co.za/enterprise-ext/ext/compose360/v1.0/clients/GetClients?queryType=test&regId=0011&view=BASIC_VIEW&hideMeta=true') && req.getMethod().equalsIgnoreCase('GET')){
            	String responseBody =		'{'+
            '        "meta": {'+
            '            "queryResult": {'+
            '                "type": "primary",'+
            '                "sourceSystem": "cif"'+
            '            }'+
            '        },'+
            '        "individual": {'+
            '            "givenName": {'+
            '                "value": ""'+
            '            },'+
            '            "nameInitials": {'+
            '                "value": ""'+
            '            },'+
            '            "surname": {'+
            '                "value": "ADVANCED ENGINEERING DESIGNS"'+
            '            },'+
            '            "salutationType": {'+
            '                "code": {'+
            '                    "value": "00"'+
            '                },'+
            '                "description": {'+
            '                    "value": null'+
            '                }'+
            '            },'+
            '            "countryPassport": {'+
            '                "code": {'+
            '                    "value": "00;"'+
            '                },'+
            '                "description": {'+
            '                    "value": null'+
            '                }'+
            '            },'+
            '            "countryOfBirth": {'+
            '                "code": {'+
            '                    "value": ""'+
            '                },'+
            '                "description": {'+
            '                    "value": null'+
            '                }'+
            '            },'+
            '            "gender": {'+
            '                "code": {'+
            '                    "value": "0"'+
            '                },'+
            '                "description": {'+
            '                    "value": null'+
            '                }'+
            '            },'+
            '            "nationality": {'+
            '                "code": {'+
            '                    "value": "00;"'+
            '                },'+
            '                "description": {'+
            '                    "value": null'+
            '                }'+
            '            },'+
            '            "employmentStatusType": {'+
            '                "code": {'+
            '                    "value": "00;"'+
            '                },'+
            '                "description": {'+
            '                    "value": null'+
            '                }'+
            '            }'+
            '        },'+
            '        "customerDetails": {'+
            '            "identificationTypeId": {'+
            '                "code": {'+
            '                    "value": "05"'+
            '                },'+
            '                "description": {'+
            '                    "value": "REGISTRATION NO"'+
            '                }'+
            '            },'+
            '            "individualId": {'+
            '                "value": "196308285384"'+
            '            },'+
            '            "universalResourceLocator": {'+
            '                "value": ""'+
            '            },'+
            '            "customerType": {'+
            '                "code": {'+
            '                    "value": "031"'+
            '                },'+
            '                "description": {'+
            '                    "value": "CLOSE CORPORATION"'+
            '                }'+
            '            },'+
            '            "groupScheme": {'+
            '                "code": {'+
            '                    "value": "N"'+
            '                },'+
            '                "description": {'+
            '                    "value": "NON-INDIVIDUAL"'+
            '                }'+
            '            },'+
            '            "sourceOfFundsCode": {'+
            '                "code": {'+
            '                    "value": "00;"'+
            '                },'+
            '                "description": {'+
            '                    "value": null'+
            '                }'+
            '            },'+
            '            "sourceOfIncomeCode": {'+
            '                "code": {'+
            '                    "value": "00"'+
            '                },'+
            '                "description": {'+
            '                    "value": null'+
            '                }'+
            '            },'+
            '            "corporateDivision": {'+
            '                "code": {'+
            '                    "value": "A"'+
            '                },'+
            '                "description": {'+
            '                    "value": "CORPORATE AND INVESTMENT BANKING"'+
            '                }'+
            '            },'+
            '            "inLiquidation": {'+
            '                "value": "NO"'+
            '            },'+
            '            "underJudicialManagement": {'+
            '                "value": "NO"'+
            '            },'+
            '            "financialCrime": {'+
            '                "value": "N"'+
            '            },'+
            '            "NCAThreshold": {'+
            '                "value": "NO"'+
            '            },'+
            '            "CPAThreshold": {'+
            '                "value": "NO"'+
            '            },'+
            '            "sbuSegment": {'+
            '                "code": {'+
            '                    "value": "H"'+
            '                },'+
            '                "description": {'+
            '                    "value": "BUSINESS BANK"'+
            '                }'+
            '            },'+
            '            "inBusinessRescue": {'+
            '                "value": ""'+
            '            },'+
            '            "inBusinessRescueAffectedParty": {'+
            '                "value": "N"'+
            '            },'+
            '            "placedInBusinessRescueBy": {'+
            '                "value": "0"'+
            '            },'+
            '            "forensicHold": {'+
            '                "value": "NO"'+
            '            },'+
            '            "businessRescueIssueDate": {}'+
            '        },'+
            '        "location": {'+
            '            "physicalAddress": {'+
            '                "addressName1": {'+
            '                    "value": ""'+
            '                },'+
            '                "addressName2": {'+
            '                    "value": ""'+
            '                },'+
            '                "suburbName": {'+
            '                    "value": ""'+
            '                },'+
            '                "cityName": {'+
            '                    "value": ""'+
            '                },'+
            '                "postCodeArea": {'+
            '                    "value": ""'+
            '                }'+
            '            },'+
            '            "postalAddress": {'+
            '                "addressName1": {'+
            '                    "value": "PO BOX 9385"'+
            '                },'+
            '                "addressName2": {'+
            '                    "value": ""'+
            '                },'+
            '                "suburbName": {'+
            '                    "value": ""'+
            '                },'+
            '                "cityName": {'+
            '                    "value": "ELSBURG"'+
            '                },'+
            '                "postCodeArea": {'+
            '                    "value": "1407"'+
            '                },'+
            '                "addressTypeCode": {'+
            '                    "value": ""'+
            '                }'+
            '            },'+
            '            "businessAddress": {'+
            '                "addressName1": {'+
            '                    "value": "26 HARRIETT AVENUE"'+
            '                },'+
            '                "addressName2": {'+
            '                    "value": ""'+
            '                },'+
            '                "suburbName": {'+
            '                    "value": ""'+
            '                },'+
            '                "cityName": {'+
            '                    "value": "GERMISTON"'+
            '                },'+
            '                "postCodeArea": {'+
            '                    "value": "1401"'+
            '                },'+
            '                "addressType": {'+
            '                    "value": "20"'+
            '                }'+
            '            },'+
            '            "headOfficeAddress": {'+
            '                "addressName1": {'+
            '                    "value": ""'+
            '                },'+
            '                "addressName2": {'+
            '                    "value": ""'+
            '                },'+
            '                "suburbName": {'+
            '                    "value": ""'+
            '                },'+
            '                "cityName": {'+
            '                    "value": ""'+
            '                },'+
            '                "postCodeArea": {'+
            '                    "value": ""'+
            '                },'+
            '                "addressType": {'+
            '                    "value": ""'+
            '                }'+
            '            }'+
            '        },'+
            '        "contact": {'+
            '            "cellPhoneNumber": {'+
            '                "value": "0"'+
            '            },'+
            '            "communicationChannelType": {'+
            '                "code": {'+
            '                    "value": "01"'+
            '                },'+
            '                "description": {'+
            '                    "value": "POST"'+
            '                }'+
            '            },'+
            '            "workPhone": {'+
            '                "value": "(011) 873 8919"'+
            '            },'+
            '            "homePhone": {'+
            '                "value": "(011) 873 8919"'+
            '            },'+
            '            "eMailUserId": {'+
            '                "value": ""'+
            '            },'+
            '            "contactPerson": {'+
            '                "value": "DOWN"'+
            '            },'+
            '            "designation": {'+
            '                "value": "MANAGER"'+
            '            }'+
            '        },'+
            '        "corporateEntity": {'+
            '            "incorporatedCountry": {'+
            '                "code": {'+
            '                    "value": "00;"'+
            '                },'+
            '                "description": {'+
            '                    "value": null'+
            '                }'+
            '            },'+
            '            "standardIndustryCode": {'+
            '                "code": {'+
            '                    "value": "86900"'+
            '                },'+
            '                "description": {'+
            '                    "value": "86900 - COMPUTER AND RELATED ACTIVITIES : OTHER COMPUTER RELATE"'+
            '                }'+
            '            }'+
            '        },'+
            '        "identifications": ['+
            '            {'+
            '                "type": {'+
            '                    "code": "cif",'+
            '                    "description": null'+
            '                },'+
            '                "number": "AEDESIG008",'+
            '                "personalIdentificationFlag": false,'+
            '                "systemIdentificationFlag": false,'+
            '                "issueDate": "0001-01-01T00:00:00",'+
            '                "expiryDate": "0001-01-01T00:00:00",'+
            '                "country": null'+
            '            }'+
            '        ],'+
            '        "_links": null'+
            '    }';
                res.setBody(responseBody);
            }
             return res;
        }
    }
}