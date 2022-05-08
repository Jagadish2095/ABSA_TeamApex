/**
* Test class for ClientFinderCIF
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2018-08-14
*
**/

@isTest
public class ApiRestJson2ApexCIF_v1Test {
    
	 static testMethod void testParse() {
		String json=		'{'+
		'        "meta": {'+
		'            "queryResult": {'+
		'                "type": "primary",'+
		'                "sourceSystem": "cif"'+
		'            }'+
		'        },'+
		'        "individual": {'+
		'            "givenName": {'+
		'                "value": "Ali"'+
		'            },'+
		'            "nameInitials": {'+
		'                "value": ""'+
		'            },'+
		'            "surname": {'+
		'                "value": "ADVANCED ENGINEERING DESIGNS"'+
		'            },'+
		'            "salutationType": {'+
		'                "code": {'+
		'                    "value": "Mr"'+
		'                },'+
		'                "description": {'+
		'                    "value": "Test"'+
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
        
         
         Test.startTest(); 
         
         //list<ApiRestJson2ApexCIF_v1> cifList = cifAPI.RetrieveClientList('cif','AEDESIG008','BASIC_VIEW',true);
         ApiRestJson2ApexCIF_v1 jsonclass = new ApiRestJson2ApexCIF_v1();
         jsonclass = ApiRestJson2ApexCIF_v1.parse(json);
         ApiRestJson2ApexCIF_v1.cls_individual idv = jsonclass.individual;
         ApiRestJson2ApexCIF_v1.cls_surname surname = idv.surname;
         //ApiRestJson2ApexCIF_v1 testApiRestJson2ApexCIF_v1 = new ApiRestJson2ApexCIF_v1();
         ApiRestJson2ApexCIF_v1.cls_location location = jsonclass.location;
         //ApiRestJson2ApexCIF_v1.cls_individual idv = jsonclass.individual;
         //List<ApiRestJson2ApexCIF_v1.cls_identifications> identify = jsonclass.identifications;
         ApiRestJson2ApexCIF_v1.cls_customerDetails customerDetail = jsonclass.customerDetails;
         ApiRestJson2ApexCIF_v1.cls_contact commMethod = jsonclass.contact; 
         ApiRestJson2ApexCIF_v1.cls_individualId individualId = jsonclass.individualId; 
         //ApiRestJson2ApexCIF_v1.cls_groupScheme groupScheme = jsonclass.groupScheme; 
         ApiRestJson2ApexCIF_v1.cls_communicationChannelType communicationChannelType = jsonclass.communicationChannelType; 
         ApiRestJson2ApexCIF_v1.cls_physicalAddress physicalAddress = jsonclass.physicalAddress; 
         ApiRestJson2ApexCIF_v1.cls_postalAddress postalAddress = jsonclass.postalAddress; 
         ApiRestJson2ApexCIF_v1.cls_businessAddress businessAddress = jsonclass.businessAddress; 
         ApiRestJson2ApexCIF_v1.cls_headOfficeAddress headOfficeAddress = jsonclass.headOfficeAddress; 

         String salutationType = idv.salutationType.description.value;
         String nameInitials = idv.nameInitials.value;
         String firstName = idv.givenName.value;
         String lastName = idv.surname.value;
         String idNumber =  customerDetail.individualId.value; 
         String communicationMethod = commMethod.communicationChannelType.description.value;
         //Contact Details
         String homeTelNo = commMethod.homePhone.value;
         String workTelNo = commMethod.workPhone.value;
         String mobileNo = commMethod.cellPhoneNumber.value;
         String emailAddress = commMethod.eMailUserId.value;
         //Physical Address
         String physicalAddressStreet1 = location.physicalAddress.addressName1.value;
         String physicalAddressStreet2 = location.physicalAddress.addressName2.value;
         String physicalAddressSuburbName = location.physicalAddress.suburbName.value;
         String physicalAddressCityName = location.physicalAddress.cityName.value;
         String physicalAddressPostCodeArea = location.physicalAddress.postCodeArea.value; 
         //Postal Address
         String postalAddressStreet1 = location.postalAddress.addressName1.value;
         String postalAddressStreet2 = location.postalAddress.addressName2.value;
         String postalAddressSuburbName = location.postalAddress.suburbName.value;
         String postalAddressCityName = location.postalAddress.cityName.value;
         String postalAddressPostCodeArea = location.postalAddress.postCodeArea.value;
         //Business Address
         String businessAddressStreet1 = location.businessAddress.addressName1.value;
         String businessAddressStreet2 = location.businessAddress.addressName2.value;
         String businessAddressSuburbName = location.businessAddress.suburbName.value;
         String businessAddressCityName = location.businessAddress.cityName.value;
         String businessAddressPostCodeArea = location.businessAddress.postCodeArea.value;
         //Head Office Address
         String headOfficeAddressStreet1 = location.headOfficeAddress.addressName1.value;
         String headOfficeAddressStreet2 = location.headOfficeAddress.addressName2.value;
         String headOfficeAddressSuburbName = location.headOfficeAddress.suburbName.value;
         String headOfficeAddressCityName = location.headOfficeAddress.cityName.value;
         String headOfficeAddressPostCodeArea = location.headOfficeAddress.postCodeArea.value;
         
         System.assertEquals('ADVANCED ENGINEERING DESIGNS', surname.value);
         
         Test.stopTest(); 
	}
}