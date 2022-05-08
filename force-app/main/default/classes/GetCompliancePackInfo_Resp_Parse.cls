/**
 * @description       :
 * @author            : Sharath
 * @group             :
 * @last modified on  : 05-25-2021
 * @last modified by  : Sandeep Golla
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   05-25-2021   Sharath	      Initial Version
**/
public class GetCompliancePackInfo_Resp_Parse {

    public String status;
    public Integer statusCode;
    public String message;
    public String code;
    public String description;

    /**
    * @description
    **/
    public GetCompliancePackInfo_Resp_Parse()
    {
        this.status = status;
        this.statusCode = statusCode;
        this.message = message;
    }

	/**
    * @description
    **/
	public class SourcesOfWealth {
		public String code;
		public String created;
		public String description;
		public String endDate;
		public String startdate;
		public String updated;

		/**
		* @description
		* @param parser
		**/
		public SourcesOfWealth(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'code') {
							code = parser.getText();
						} else if (text == 'created') {
							created = parser.getText();
						} else if (text == 'description') {
							description = parser.getText();
						} else if (text == 'endDate') {
							endDate = parser.getText();
						} else if (text == 'startdate') {
							startdate = parser.getText();
						} else if (text == 'updated') {
							updated = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'SourcesOfWealth consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class Address {
		public AttestedAddress attestedAddress;
		public AttestedAddressDocument attestedAddressDocument;
		public GoldenSourceCachedAddresses goldenSourceCachedAddresses;

		/**
		* @description
		* @param parser
		**/
		public Address(JSONParser parser) {
			//System.debug('*#*');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					//System.debug('***## '+text);
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'attestedAddress') {
							attestedAddress = new AttestedAddress(parser);
						} else if (text == 'attestedAddressDocument') {
							attestedAddressDocument = new AttestedAddressDocument(parser);
						} else if (text == 'goldenSourceCachedAddresses') {
							goldenSourceCachedAddresses = new GoldenSourceCachedAddresses(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Address consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
				//System.debug('parser.getCurrentToken() '+parser.getCurrentToken());
			}
			//System.debug('parser.nextToken() '+parser.nextToken());
		}
	}
	/**
    * @description
    **/
	public class Countries {
		public ArrangementType context;
		public String created;
		public String endDate;
		public String isoCode;
		public String name;
		public String startDate;
		public ArrangementType type;
		public String updated;

		/**
		* @description
		* @param parser
		**/
		public Countries(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'context') {
							context = new ArrangementType(parser);
						} else if (text == 'created') {
							created = parser.getText();
						} else if (text == 'endDate') {
							endDate = parser.getText();
						} else if (text == 'isoCode') {
							isoCode = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'startDate') {
							startDate = parser.getText();
						} else if (text == 'type') {
							type = new ArrangementType(parser);
						} else if (text == 'updated') {
							updated = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Countries consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class AttestedAddressDocument {
		public ArrangementType context;
		public String created;
		public String endDate;
		public String lastRefreshDate;
		public String nextRefreshDate;
		public String receivedDate;
		public String source;
		public String storageSystemDocumentId;
		public String storageSystemName;
		public ArrangementType subType;
		public ArrangementType type;
		public String uniqueIdInSourceSystem;
		public String updated;
		public String vettedDate;

		/**
		* @description
		* @param parser
		**/
		public AttestedAddressDocument(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'context') {
							context = new ArrangementType(parser);
						} else if (text == 'created') {
							created = parser.getText();
						} else if (text == 'endDate') {
							endDate = parser.getText();
						} else if (text == 'lastRefreshDate') {
							lastRefreshDate = parser.getText();
						} else if (text == 'nextRefreshDate') {
							nextRefreshDate = parser.getText();
						} else if (text == 'receivedDate') {
							receivedDate = parser.getText();
						} else if (text == 'source') {
							source = parser.getText();
						} else if (text == 'storageSystemDocumentId') {
							storageSystemDocumentId = parser.getText();
						} else if (text == 'storageSystemName') {
							storageSystemName = parser.getText();
						} else if (text == 'subType') {
							subType = new ArrangementType(parser);
						} else if (text == 'type') {
							type = new ArrangementType(parser);
						} else if (text == 'uniqueIdInSourceSystem') {
							uniqueIdInSourceSystem = parser.getText();
						} else if (text == 'updated') {
							updated = parser.getText();
						} else if (text == 'vettedDate') {
							vettedDate = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'AttestedAddressDocument consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class Arrangements {
		public Boolean accountActive;
		public String arrangementCloseDate;
		public String arrangementOpenDate;
		public ArrangementType arrangementType;
		public ArrangementType brand;
		public String initiatingPartySuin;
		public String lifecycleStatus;
		public String lifecycleStatusDate;
		public String productId;
		public String uniqueIdInSourceSystem;

		/**
		* @description
		* @param parser
		**/
		public Arrangements(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'accountActive') {
							accountActive = parser.getBooleanValue();
						} else if (text == 'arrangementCloseDate') {
							arrangementCloseDate = parser.getText();
						} else if (text == 'arrangementOpenDate') {
							arrangementOpenDate = parser.getText();
						} else if (text == 'arrangementType') {
							arrangementType = new ArrangementType(parser);
						} else if (text == 'brand') {
							brand = new ArrangementType(parser);
						} else if (text == 'initiatingPartySuin') {
							initiatingPartySuin = parser.getText();
						} else if (text == 'lifecycleStatus') {
							lifecycleStatus = parser.getText();
						} else if (text == 'lifecycleStatusDate') {
							lifecycleStatusDate = parser.getText();
						} else if (text == 'productId') {
							productId = parser.getText();
						} else if (text == 'uniqueIdInSourceSystem') {
							uniqueIdInSourceSystem = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Arrangements consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class Identification {
		public AttestedId attestedId;
		public AttestedAddressDocument attestedIdDocument;
		public GoldenSourceId goldenSourceId;

		/**
		* @description
		* @param parser
		**/
		public Identification(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'attestedId') {
							attestedId = new AttestedId(parser);
						} else if (text == 'attestedIdDocument') {
							attestedIdDocument = new AttestedAddressDocument(parser);
						} else if (text == 'goldenSourceId') {
							goldenSourceId = new GoldenSourceId(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Identification consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class HighRiskIndustryParticipation {
		public Boolean casino;
		public Boolean conflictDiamonds;
		public Boolean defense;
		public Boolean microFinance;

		/**
		* @description
		* @param parser
		**/
		public HighRiskIndustryParticipation(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'casino') {
							casino = parser.getBooleanValue();
						} else if (text == 'conflictDiamonds') {
							conflictDiamonds = parser.getBooleanValue();
						} else if (text == 'defense') {
							defense = parser.getBooleanValue();
						} else if (text == 'microFinance') {
							microFinance = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'HighRiskIndustryParticipation consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class Manager {
		public String designation;
		public ArrangementType employmentPosition;
		public String lastUpdatedExternalSystem;
		public String name;
		public String partySuin;
		public String surname;
		public ArrangementType type;

		/**
		* @description
		* @param parser
		**/
		public Manager(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'designation') {
							designation = parser.getText();
						} else if (text == 'employmentPosition') {
							employmentPosition = new ArrangementType(parser);
						} else if (text == 'lastUpdatedExternalSystem') {
							lastUpdatedExternalSystem = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'partySuin') {
							partySuin = parser.getText();
						} else if (text == 'surname') {
							surname = parser.getText();
						} else if (text == 'type') {
							type = new ArrangementType(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Manager consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class CustomerDueDiligenceVerifications {
		public Boolean identify;
		public String name;
		public Boolean screen;
		public Boolean verify;

		/**
		* @description
		* @param parser
		**/
		public CustomerDueDiligenceVerifications(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'identify') {
							identify = parser.getBooleanValue();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'screen') {
							screen = parser.getBooleanValue();
						} else if (text == 'verify') {
							verify = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'CustomerDueDiligenceVerifications consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class GpsCoordinates {
		public String latitude;
		public String longitude;

		/**
		* @description
		* @param parser
		**/
		public GpsCoordinates(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'latitude') {
							latitude = parser.getText();
						} else if (text == 'longitude') {
							longitude = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'GpsCoordinates consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class PrimaryContact {
		public String designation;
		public String lastUpdatedExternalSystem;
		public String name;
		public String partySuin;
		public String surname;

		/**
		* @description
		* @param parser
		**/
		public PrimaryContact(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'designation') {
							designation = parser.getText();
						} else if (text == 'lastUpdatedExternalSystem') {
							lastUpdatedExternalSystem = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'partySuin') {
							partySuin = parser.getText();
						} else if (text == 'surname') {
							surname = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'PrimaryContact consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class ActiveInIndustries {
		public String code;
		public String created;
		public String description;
		public String endDate;
		public ArrangementType industry;
		public Boolean primaryFlag;
		public String startDate;
		public ArrangementType type;
		public String updated;

		/**
		* @description
		* @param parser
		**/
		public ActiveInIndustries(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'code') {
							code = parser.getText();
						} else if (text == 'created') {
							created = parser.getText();
						} else if (text == 'description') {
							description = parser.getText();
						} else if (text == 'endDate') {
							endDate = parser.getText();
						} else if (text == 'industry') {
							industry = new ArrangementType(parser);
						} else if (text == 'primaryFlag') {
							primaryFlag = parser.getBooleanValue();
						} else if (text == 'startDate') {
							startDate = parser.getText();
						} else if (text == 'type') {
							type = new ArrangementType(parser);
						} else if (text == 'updated') {
							updated = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ActiveInIndustries consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class Addresses {
		public List<AttestedAddress> addresses;
		public List<ElectronicAddresses> electronicAddresses;
		public ArrangementType preferredCommunicationChannel;
		public List<TelephonicAddress> telephonicAddress;

		/**
		* @description
		* @param parser
		**/
		public Addresses(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'addresses') {
							addresses = arrayOfAttestedAddress(parser);
						} else if (text == 'electronicAddresses') {
							electronicAddresses = arrayOfElectronicAddresses(parser);
						} else if (text == 'preferredCommunicationChannel') {
							preferredCommunicationChannel = new ArrangementType(parser);
						} else if (text == 'telephonicAddress') {
							telephonicAddress = arrayOfTelephonicAddress(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Addresses consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class Relationships {
		public Arrangements arrangement;
		public String created;
		public String endDate;
		public String internalIdType;
		public String internalIdValue;
		public String percentage;
		public String relatedPartyName;
		public String relatedPartySourceSystem;
		public String relatedPartyType;
		public ArrangementType role;
		public String startDate;
		public ArrangementType status;
		public String suin;
		public ArrangementType type;
		public String updated;

		/**
		* @description
		* @param parser
		**/
		public Relationships(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'arrangement') {
							arrangement = new Arrangements(parser);
						} else if (text == 'created') {
							created = parser.getText();
						} else if (text == 'endDate') {
							endDate = parser.getText();
						} else if (text == 'internalIdType') {
							internalIdType = parser.getText();
						} else if (text == 'internalIdValue') {
							internalIdValue = parser.getText();
						} else if (text == 'percentage') {
							percentage = parser.getText();
						} else if (text == 'relatedPartyName') {
							relatedPartyName = parser.getText();
						} else if (text == 'relatedPartySourceSystem') {
							relatedPartySourceSystem = parser.getText();
						} else if (text == 'relatedPartyType') {
							relatedPartyType = parser.getText();
						} else if (text == 'role') {
							role = new ArrangementType(parser);
						} else if (text == 'startDate') {
							startDate = parser.getText();
						} else if (text == 'status') {
							status = new ArrangementType(parser);
						} else if (text == 'suin') {
							suin = parser.getText();
						} else if (text == 'type') {
							type = new ArrangementType(parser);
						} else if (text == 'updated') {
							updated = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Relationships consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class FormalOrganisation {
		public String dateOfIncorporation;
		public String deregistrationDate;
		public String ficaAddressAttestedDate;
		public String ficaAddressUpdateDate;
		public String financialYearEnd;
		public String identificationAttestedDate;
		public String identificationUpdateDate;
		public String knownAs;
		public Manager manager;
		public String name;
		public ArrangementType natureOfBusiness;
		public String nextRefreshDate;
		public ArrangementType pepStatus;
		public ArrangementType preferredLanguage;
		public PrimaryContact primaryContact;
		public String registeredName;
		public String residentialStatus;
		public ArrangementType revenueSegment;
		public String sarsLegalType;
		public String siteName;
		public String sourceOfIncomeAttestedDate;
		public ArrangementType status;
		public ArrangementType subStatus;
		public String trustDeedNumber;
		public ArrangementType type;

		/**
		* @description
		* @param parser
		**/
		public FormalOrganisation(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'dateOfIncorporation') {
							dateOfIncorporation = parser.getText();
						} else if (text == 'deregistrationDate') {
							deregistrationDate = parser.getText();
						} else if (text == 'ficaAddressAttestedDate') {
							ficaAddressAttestedDate = parser.getText();
						} else if (text == 'ficaAddressUpdateDate') {
							ficaAddressUpdateDate = parser.getText();
						} else if (text == 'financialYearEnd') {
							financialYearEnd = parser.getText();
						} else if (text == 'identificationAttestedDate') {
							identificationAttestedDate = parser.getText();
						} else if (text == 'identificationUpdateDate') {
							identificationUpdateDate = parser.getText();
						} else if (text == 'knownAs') {
							knownAs = parser.getText();
						} else if (text == 'manager') {
							manager = new Manager(parser);
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'natureOfBusiness') {
							natureOfBusiness = new ArrangementType(parser);
						} else if (text == 'nextRefreshDate') {
							nextRefreshDate = parser.getText();
						} else if (text == 'pepStatus') {
							pepStatus = new ArrangementType(parser);
						} else if (text == 'preferredLanguage') {
							preferredLanguage = new ArrangementType(parser);
						} else if (text == 'primaryContact') {
							primaryContact = new PrimaryContact(parser);
						} else if (text == 'registeredName') {
							registeredName = parser.getText();
						} else if (text == 'residentialStatus') {
							residentialStatus = parser.getText();
						} else if (text == 'revenueSegment') {
							revenueSegment = new ArrangementType(parser);
						} else if (text == 'sarsLegalType') {
							sarsLegalType = parser.getText();
						} else if (text == 'siteName') {
							siteName = parser.getText();
						} else if (text == 'sourceOfIncomeAttestedDate') {
							sourceOfIncomeAttestedDate = parser.getText();
						} else if (text == 'status') {
							status = new ArrangementType(parser);
						} else if (text == 'subStatus') {
							subStatus = new ArrangementType(parser);
						} else if (text == 'trustDeedNumber') {
							trustDeedNumber = parser.getText();
						} else if (text == 'type') {
							type = new ArrangementType(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'FormalOrganisation consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class Party {
		public List<ActiveInIndustries> activeInIndustries;
		public Addresses addresses;
		public List<Countries> countries;
		public String created;
		public List<PartyFlags> flags;
		public FormalOrganisation formalOrganisation;
		public List<AttestedId> identifications;
		public Individual individual;
		public InformalOrganisation informalOrganisation;
		public String lastUpdatedExternalSystem;
		public String name;
		public OrganisationUnit organisationUnit;
		public PrimaryId primaryId;
		public List<AttestedAddressDocument> relatedDocuments;
		public List<Relationships> relationships;
		public String riskRating;
		public List<ArrangementType> sourcesOfIncome;
		public List<SourcesOfWealth> sourcesOfWealth;
		public String suin;
		public String updated;

		/**
		* @description
		* @param parser
		**/
		public Party(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'activeInIndustries') {
							activeInIndustries = arrayOfActiveInIndustries(parser);
						} else if (text == 'addresses') {
							addresses = new Addresses(parser);
						} else if (text == 'countries') {
							countries = arrayOfCountries(parser);
						} else if (text == 'created') {
							created = parser.getText();
						} else if (text == 'flags') {
							flags = arrayOfPartyFlags(parser);
						} else if (text == 'formalOrganisation') {
							formalOrganisation = new FormalOrganisation(parser);
						} else if (text == 'identifications') {
							identifications = arrayOfAttestedId(parser);
						} else if (text == 'individual') {
							individual = new Individual(parser);
						} else if (text == 'informalOrganisation') {
							informalOrganisation = new InformalOrganisation(parser);
						} else if (text == 'lastUpdatedExternalSystem') {
							lastUpdatedExternalSystem = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'organisationUnit') {
							organisationUnit = new OrganisationUnit(parser);
						} else if (text == 'primaryId') {
							primaryId = new PrimaryId(parser);
						} else if (text == 'relatedDocuments') {
							relatedDocuments = arrayOfAttestedAddressDocument(parser);
						} else if (text == 'relationships') {
							relationships = arrayOfRelationships(parser);
						} else if (text == 'riskRating') {
							riskRating = parser.getText();
						} else if (text == 'sourcesOfIncome') {
							sourcesOfIncome = arrayOfArrangementType(parser);
						} else if (text == 'sourcesOfWealth') {
							sourcesOfWealth = arrayOfSourcesOfWealth(parser);
						} else if (text == 'suin') {
							suin = parser.getText();
						} else if (text == 'updated') {
							updated = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Party consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class ComplianceDecisionTraces {
		public String name;
		public String type;

		/**
		* @description
		* @param parser
		**/
		public ComplianceDecisionTraces(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'type') {
							type = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ComplianceDecisionTraces consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class ComplianceRequirements {
		public List<ComplianceDecisionTraces> complianceDecisionTraces;
		public String complianceStatus;
		public List<CustomerDueDiligenceVerifications> customerDueDiligenceVerifications;
		public String ficaAddressAttestedDate;
		public String identificationAttestedDate;
		public List<String> missingData;
		public List<ArrangementType> missingDocuments;
		public String nextRefreshDate;
		public List<PartyFlags> partyFlags;
		public List<RbaGuidanceMatrix> rbaGuidanceMatrix;
		public List<AttestedAddressDocument> refreshableDocuments;
		public List<RelatedPartyCompliance> relatedPartyCompliance;
		public List<AttestedAddressDocument> reusableDocuments;
		public String sourceOfIncomeAttestedDate;
		public String startOfRefreshDate;

		/**
		* @description
		* @param parser
		**/
		public ComplianceRequirements(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'complianceDecisionTraces') {
							complianceDecisionTraces = arrayOfComplianceDecisionTraces(parser);
						} else if (text == 'complianceStatus') {
							complianceStatus = parser.getText();
						} else if (text == 'customerDueDiligenceVerifications') {
							customerDueDiligenceVerifications = arrayOfCustomerDueDiligenceVerifications(parser);
						} else if (text == 'ficaAddressAttestedDate') {
							ficaAddressAttestedDate = parser.getText();
						} else if (text == 'identificationAttestedDate') {
							identificationAttestedDate = parser.getText();
						} else if (text == 'missingData') {
							missingData = arrayOfString(parser);
						} else if (text == 'missingDocuments') {
							missingDocuments = arrayOfArrangementType(parser);
						} else if (text == 'nextRefreshDate') {
							nextRefreshDate = parser.getText();
						} else if (text == 'partyFlags') {
							partyFlags = arrayOfPartyFlags(parser);
						} else if (text == 'rbaGuidanceMatrix') {
							rbaGuidanceMatrix = arrayOfRbaGuidanceMatrix(parser);
						} else if (text == 'refreshableDocuments') {
							refreshableDocuments = arrayOfAttestedAddressDocument(parser);
						} else if (text == 'relatedPartyCompliance') {
							relatedPartyCompliance = arrayOfRelatedPartyCompliance(parser);
						} else if (text == 'reusableDocuments') {
							reusableDocuments = arrayOfAttestedAddressDocument(parser);
						} else if (text == 'sourceOfIncomeAttestedDate') {
							sourceOfIncomeAttestedDate = parser.getText();
						} else if (text == 'startOfRefreshDate') {
							startOfRefreshDate = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ComplianceRequirements consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class InformalOrganisation {
		public String ficaAddressAttestedDate;
		public String ficaAddressUpdateDate;
		public String identificationAttestedDate;
		public String identificationUpdateDate;
		public Integer jointParticipanCount;
		public String knownAs;
		public Manager manager;
		public String name;
		public ArrangementType natureOfBusiness;
		public String nextRefreshDate;
		public ArrangementType pepStatus;
		public ArrangementType preferredLanguage;
		public PrimaryContact primaryContact;
		public String residentialStatus;
		public ArrangementType revenueSegment;
		public String sourceOfIncomeAttestedDate;
		public ArrangementType status;
		public ArrangementType subStatus;
		public ArrangementType type;

		/**
		* @description
		* @param parser
		**/
		public InformalOrganisation(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ficaAddressAttestedDate') {
							ficaAddressAttestedDate = parser.getText();
						} else if (text == 'ficaAddressUpdateDate') {
							ficaAddressUpdateDate = parser.getText();
						} else if (text == 'identificationAttestedDate') {
							identificationAttestedDate = parser.getText();
						} else if (text == 'identificationUpdateDate') {
							identificationUpdateDate = parser.getText();
						} else if (text == 'jointParticipanCount') {
							jointParticipanCount = parser.getIntegerValue();
						} else if (text == 'knownAs') {
							knownAs = parser.getText();
						} else if (text == 'manager') {
							manager = new Manager(parser);
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'natureOfBusiness') {
							natureOfBusiness = new ArrangementType(parser);
						} else if (text == 'nextRefreshDate') {
							nextRefreshDate = parser.getText();
						} else if (text == 'pepStatus') {
							pepStatus = new ArrangementType(parser);
						} else if (text == 'preferredLanguage') {
							preferredLanguage = new ArrangementType(parser);
						} else if (text == 'primaryContact') {
							primaryContact = new PrimaryContact(parser);
						} else if (text == 'residentialStatus') {
							residentialStatus = parser.getText();
						} else if (text == 'revenueSegment') {
							revenueSegment = new ArrangementType(parser);
						} else if (text == 'sourceOfIncomeAttestedDate') {
							sourceOfIncomeAttestedDate = parser.getText();
						} else if (text == 'status') {
							status = new ArrangementType(parser);
						} else if (text == 'subStatus') {
							subStatus = new ArrangementType(parser);
						} else if (text == 'type') {
							type = new ArrangementType(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'InformalOrganisation consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class PartyFlags {
		public ArrangementType category;
		public String created;
		public String effectiveDate;
		public Boolean isOperationalFlag;
		public String lastUpdatedExternalSystem;
		public String status;
		public ArrangementType type;
		public String updated;
		public Boolean yesNoFlag;

		/**
		* @description
		* @param parser
		**/
		public PartyFlags(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'category') {
							category = new ArrangementType(parser);
						} else if (text == 'created') {
							created = parser.getText();
						} else if (text == 'effectiveDate') {
							effectiveDate = parser.getText();
						} else if (text == 'isOperationalFlag') {
							isOperationalFlag = parser.getBooleanValue();
						} else if (text == 'lastUpdatedExternalSystem') {
							lastUpdatedExternalSystem = parser.getText();
						} else if (text == 'status') {
							status = parser.getText();
						} else if (text == 'type') {
							type = new ArrangementType(parser);
						} else if (text == 'updated') {
							updated = parser.getText();
						} else if (text == 'yesNoFlag') {
							yesNoFlag = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'PartyFlags consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class OrganisationUnit {
		public Manager manager;
		public String name;

		/**
		* @description
		* @param parser
		**/
		public OrganisationUnit(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'manager') {
							manager = new Manager(parser);
						} else if (text == 'name') {
							name = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'OrganisationUnit consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class AttestedAddress {
		public Boolean activeFlag;
		public String addressName1;
		public String addressName2;
		public String cityName;
		public ArrangementType context;
		public String countryName;
		public String created;
		public String endDate;
		public GpsCoordinates gpsCoordinates;
		public String postalCode;
		public Boolean primaryFlag;
		public String startDate;
		public String state;
		public String suburbName;
		public ArrangementType type;
		public String updated;

		/**
		* @description
		* @param parser
		**/
		public AttestedAddress(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'activeFlag') {
							activeFlag = parser.getBooleanValue();
						} else if (text == 'addressName1') {
							addressName1 = parser.getText();
						} else if (text == 'addressName2') {
							addressName2 = parser.getText();
						} else if (text == 'cityName') {
							cityName = parser.getText();
						} else if (text == 'context') {
							context = new ArrangementType(parser);
						} else if (text == 'countryName') {
							countryName = parser.getText();
						} else if (text == 'created') {
							created = parser.getText();
						} else if (text == 'endDate') {
							endDate = parser.getText();
						} else if (text == 'gpsCoordinates') {
							gpsCoordinates = new GpsCoordinates(parser);
						} else if (text == 'postalCode') {
							postalCode = parser.getText();
						} else if (text == 'primaryFlag') {
							primaryFlag = parser.getBooleanValue();
						} else if (text == 'startDate') {
							startDate = parser.getText();
						} else if (text == 'state') {
							state = parser.getText();
						} else if (text == 'suburbName') {
							suburbName = parser.getText();
						} else if (text == 'type') {
							type = new ArrangementType(parser);
						} else if (text == 'updated') {
							updated = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'AttestedAddress consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class ElectronicAddresses {
		public String address;
		public ArrangementType context;
		public String created;
		public String endDate;
		public String lastUpdatedExternalSystem;
		public ArrangementType role;
		public String startDate;
		public ArrangementType subType;
		public ArrangementType type;
		public String updated;

		/**
		* @description
		* @param parser
		**/
		public ElectronicAddresses(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'address') {
							address = parser.getText();
						} else if (text == 'context') {
							context = new ArrangementType(parser);
						} else if (text == 'created') {
							created = parser.getText();
						} else if (text == 'endDate') {
							endDate = parser.getText();
						} else if (text == 'lastUpdatedExternalSystem') {
							lastUpdatedExternalSystem = parser.getText();
						} else if (text == 'role') {
							role = new ArrangementType(parser);
						} else if (text == 'startDate') {
							startDate = parser.getText();
						} else if (text == 'subType') {
							subType = new ArrangementType(parser);
						} else if (text == 'type') {
							type = new ArrangementType(parser);
						} else if (text == 'updated') {
							updated = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ElectronicAddresses consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class AttestedId {
		public String attestationIndicator;
		public String attestedDate;
		public String category;
		public String created;
		public String expiryDate;
		public String issueDate;
		public String issuingCountry;
		public String lastUpdatedExternalSystem;
		public String number_Z; // in json: number
		public Boolean secondaryIdFlag;
		public ArrangementType type;
		public String updated;

		/**
		* @description
		* @param parser
		**/
		public AttestedId(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'attestationIndicator') {
							attestationIndicator = parser.getText();
						} else if (text == 'attestedDate') {
							attestedDate = parser.getText();
						} else if (text == 'category') {
							category = parser.getText();
						} else if (text == 'created') {
							created = parser.getText();
						} else if (text == 'expiryDate') {
							expiryDate = parser.getText();
						} else if (text == 'issueDate') {
							issueDate = parser.getText();
						} else if (text == 'issuingCountry') {
							issuingCountry = parser.getText();
						} else if (text == 'lastUpdatedExternalSystem') {
							lastUpdatedExternalSystem = parser.getText();
						} else if (text == 'number') {
							number_Z = parser.getText();
						} else if (text == 'secondaryIdFlag') {
							secondaryIdFlag = parser.getBooleanValue();
						} else if (text == 'type') {
							type = new ArrangementType(parser);
						} else if (text == 'updated') {
							updated = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'AttestedId consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class ArrangementType {
		public String code;
		public String description;

		/**
		* @description
		* @param parser
		**/
		public ArrangementType(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'code') {
							code = parser.getText();
						} else if (text == 'description') {
							description = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ArrangementType consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class GoldenSourceCachedAddresses {
		public Boolean activeFlag;
		public String addressName1;
		public String addressName2;
		public String cityName;
		public ArrangementType context;
		public String countryName;
		public String created;
		public String endDate;
		public String ficaAddressAttestationDate;
		public GpsCoordinates gpsCoordinates;
		public String postalCode;
		public Boolean primaryFlag;
		public String startDate;
		public String state;
		public String suburbName;
		public ArrangementType type;
		public String updated;
		public Boolean matches;
		public AttestedAddressDocument document;

		/**
		* @description
		* @param parser
		**/
		public GoldenSourceCachedAddresses(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'activeFlag') {
							activeFlag = parser.getBooleanValue();
						} else if (text == 'addressName1') {
							addressName1 = parser.getText();
						} else if (text == 'addressName2') {
							addressName2 = parser.getText();
						} else if (text == 'cityName') {
							cityName = parser.getText();
						} else if (text == 'context') {
							context = new ArrangementType(parser);
						} else if (text == 'countryName') {
							countryName = parser.getText();
						} else if (text == 'created') {
							created = parser.getText();
						} else if (text == 'endDate') {
							endDate = parser.getText();
						} else if (text == 'ficaAddressAttestationDate') {
							ficaAddressAttestationDate = parser.getText();
						} else if (text == 'gpsCoordinates') {
							gpsCoordinates = new GpsCoordinates(parser);
						} else if (text == 'postalCode') {
							postalCode = parser.getText();
						} else if (text == 'primaryFlag') {
							primaryFlag = parser.getBooleanValue();
						} else if (text == 'startDate') {
							startDate = parser.getText();
						} else if (text == 'state') {
							state = parser.getText();
						} else if (text == 'suburbName') {
							suburbName = parser.getText();
						} else if (text == 'type') {
							type = new ArrangementType(parser);
						} else if (text == 'updated') {
							updated = parser.getText();
						} else if (text == 'matches') {
							matches = parser.getBooleanValue();
						} else if (text == 'document') {
							document = new AttestedAddressDocument(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'GoldenSourceAddress consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class Attestation {
		public String status;
		public List<ArrangementType> sourcesOfIncome;
		public List<ArrangementType> sourcesOfWealth;
		public Address address;
		public Identification identification;

		/**
		* @description
		* @param parser
		**/
		public Attestation(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					//System.debug('### '+text);
					//System.debug('@# '+parser.nextToken());
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						//System.debug('@@hellow');
						if (text == 'status') {
							status = parser.getText();
						} else if (text == 'sourcesOfIncome') {
							sourcesOfIncome = arrayOfArrangementType(parser);
						} else if (text == 'sourcesOfWealth') {
							sourcesOfWealth = arrayOfArrangementType(parser);
						} else if (text == 'address') {
							//System.debug('##@@');
							address = new Address(parser);
						} else if (text == 'identification') {
							identification = new Identification(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Attestation consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class GoldenSourceId {
		public String attestationIndicator;
		public String attestedDate;
		public String category;
		public String created;
		public AttestedAddressDocument document;
		public String expiryDate;
		public String ficaAttestationDate;
		public String issueDate;
		public String issuingCountry;
		public String lastUpdatedExternalSystem;
		public Boolean matches;
		public String number_Z; // in json: number
		public Boolean secondaryIdFlag;
		public ArrangementType type;
		public String updated;

		/**
		* @description
		* @param parser
		**/
		public GoldenSourceId(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'attestationIndicator') {
							attestationIndicator = parser.getText();
						} else if (text == 'attestedDate') {
							attestedDate = parser.getText();
						} else if (text == 'category') {
							category = parser.getText();
						} else if (text == 'created') {
							created = parser.getText();
						} else if (text == 'document') {
							document = new AttestedAddressDocument(parser);
						} else if (text == 'expiryDate') {
							expiryDate = parser.getText();
						} else if (text == 'ficaAttestationDate') {
							ficaAttestationDate = parser.getText();
						} else if (text == 'issueDate') {
							issueDate = parser.getText();
						} else if (text == 'issuingCountry') {
							issuingCountry = parser.getText();
						} else if (text == 'lastUpdatedExternalSystem') {
							lastUpdatedExternalSystem = parser.getText();
						} else if (text == 'matches') {
							matches = parser.getBooleanValue();
						} else if (text == 'number') {
							number_Z = parser.getText();
						} else if (text == 'secondaryIdFlag') {
							secondaryIdFlag = parser.getBooleanValue();
						} else if (text == 'type') {
							type = new ArrangementType(parser);
						} else if (text == 'updated') {
							updated = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'GoldenSourceId consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class Individual {
		public ArrangementType clientClassification;
		public String dateOfBirth;
		public String ficaAddressAttestedDate;
		public String ficaAddressUpdateDate;
		public ArrangementType gender;
		public List<String> givenNames;
		public ArrangementType homeLanguage;
		public String identificationAttestedDate;
		public String identificationUpdateDate;
		public String initials;
		public String knownAs;
		public String maidenName;
		public ArrangementType maritalContractType;
		public ArrangementType maritalStatus;
		public String monthlyIncome;
		public String name;
		public String nextRefreshDate;
		public String notificationOfDeathDate;
		public String occupation;
		public String occupationStatus;
		public ArrangementType pepStatus;
		public ArrangementType preferredLanguage;
		public ArrangementType raceClassification;
		public ArrangementType residentialStatus;
		public ArrangementType salutation;
		public String sourceOfIncomeAttestedDate;
		public ArrangementType status;
		public ArrangementType subStatus;
		public String surname;

		/**
		* @description
		* @param parser
		**/
		public Individual(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'clientClassification') {
							clientClassification = new ArrangementType(parser);
						} else if (text == 'dateOfBirth') {
							dateOfBirth = parser.getText();
						} else if (text == 'ficaAddressAttestedDate') {
							ficaAddressAttestedDate = parser.getText();
						} else if (text == 'ficaAddressUpdateDate') {
							ficaAddressUpdateDate = parser.getText();
						} else if (text == 'gender') {
							gender = new ArrangementType(parser);
						} else if (text == 'givenNames') {
							givenNames = arrayOfString(parser);
						} else if (text == 'homeLanguage') {
							homeLanguage = new ArrangementType(parser);
						} else if (text == 'identificationAttestedDate') {
							identificationAttestedDate = parser.getText();
						} else if (text == 'identificationUpdateDate') {
							identificationUpdateDate = parser.getText();
						} else if (text == 'initials') {
							initials = parser.getText();
						} else if (text == 'knownAs') {
							knownAs = parser.getText();
						} else if (text == 'maidenName') {
							maidenName = parser.getText();
						} else if (text == 'maritalContractType') {
							maritalContractType = new ArrangementType(parser);
						} else if (text == 'maritalStatus') {
							maritalStatus = new ArrangementType(parser);
						} else if (text == 'monthlyIncome') {
							monthlyIncome = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'nextRefreshDate') {
							nextRefreshDate = parser.getText();
						} else if (text == 'notificationOfDeathDate') {
							notificationOfDeathDate = parser.getText();
						} else if (text == 'occupation') {
							occupation = parser.getText();
						} else if (text == 'occupationStatus') {
							occupationStatus = parser.getText();
						} else if (text == 'pepStatus') {
							pepStatus = new ArrangementType(parser);
						} else if (text == 'preferredLanguage') {
							preferredLanguage = new ArrangementType(parser);
						} else if (text == 'raceClassification') {
							raceClassification = new ArrangementType(parser);
						} else if (text == 'residentialStatus') {
							residentialStatus = new ArrangementType(parser);
						} else if (text == 'salutation') {
							salutation = new ArrangementType(parser);
						} else if (text == 'sourceOfIncomeAttestedDate') {
							sourceOfIncomeAttestedDate = parser.getText();
						} else if (text == 'status') {
							status = new ArrangementType(parser);
						} else if (text == 'subStatus') {
							subStatus = new ArrangementType(parser);
						} else if (text == 'surname') {
							surname = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Individual consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class Content {
		public List<Arrangements> arrangements;
		public Attestation attestation;
		public ComplianceRequirements complianceRequirements;
		public String dateOfBirthOrIncorporationDate;
		public HighRiskIndustryParticipation highRiskIndustryParticipation;
		public Party party;
		public String partyType;
		public PrimaryId primaryId;
		public String riskRating;

		/**
		* @description
		* @param parser
		**/
		public Content(JSONParser parser) {

			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					//System.debug('***** '+text);
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'arrangements') {
							arrangements = arrayOfArrangements(parser);
						} else if (text == 'attestation') {
							attestation = new Attestation(parser);
						} else if (text == 'complianceRequirements') {
							complianceRequirements = new ComplianceRequirements(parser);
						} else if (text == 'dateOfBirthOrIncorporationDate') {
							dateOfBirthOrIncorporationDate = parser.getText();
						} else if (text == 'highRiskIndustryParticipation') {
							highRiskIndustryParticipation = new HighRiskIndustryParticipation(parser);
						} else if (text == 'party') {
							party = new Party(parser);
						} else if (text == 'partyType') {
							partyType = parser.getText();
						} else if (text == 'primaryId') {
							primaryId = new PrimaryId(parser);
						} else if (text == 'riskRating') {
							riskRating = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Content consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public Content content;
	public List<Links> links;
	/**
    * @description
	* @param parser
    **/
	public GetCompliancePackInfo_Resp_Parse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'content') {
						content = new Content(parser);
					} else if (text == 'links') {
						links = arrayOfLinks(parser);
                    } else if (text == 'code') {
						code = parser.getText();
					} else if (text == 'description') {
						description = parser.getText();
                    }else {
						System.debug(LoggingLevel.WARN, 'GetCompliancePackInfo_Resp_Parse consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class RbaGuidanceMatrix {
		public Boolean mustIdentify;
		public Boolean mustRecord;
		public Boolean mustVerify;
		public String name;
		public List<ArrangementType> validProofDocuments;

		/**
		* @description
		* @param parser
		**/
		public RbaGuidanceMatrix(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'mustIdentify') {
							mustIdentify = parser.getBooleanValue();
						} else if (text == 'mustRecord') {
							mustRecord = parser.getBooleanValue();
						} else if (text == 'mustVerify') {
							mustVerify = parser.getBooleanValue();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'validProofDocuments') {
							validProofDocuments = arrayOfArrangementType(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'RbaGuidanceMatrix consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class Links {
		public String href;
		public Boolean templated;

		/**
		* @description
		* @param parser
		**/
		public Links(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'href') {
							href = parser.getText();
						} else if (text == 'templated') {
							templated = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Links consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class PrimaryId {
		public String number_Z; // in json: number
		public ArrangementType type;

		/**
		* @description
		* @param parser
		**/
		public PrimaryId(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'number') {
							number_Z = parser.getText();
						} else if (text == 'type') {
							type = new ArrangementType(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'PrimaryId consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class RelatedPartyCompliance {
		public List<ComplianceDecisionTraces> complianceDecisionTraces;
		public String complianceStatus;
		public List<CustomerDueDiligenceVerifications> customerDueDiligenceVerifications;
		public String ficaAddressAttestedDate;
		public String identificationAttestedDate;
		public List<String> missingData;
		public List<ArrangementType> missingDocuments;
		public String nextRefreshDate;
		public Party party;
		public List<PartyFlags> partyFlags;
		public List<RbaGuidanceMatrix> rbaGuidanceMatrix;
		public List<AttestedAddressDocument> refreshableDocuments;
		public List<Object> relatedPartyCompliance;
		public List<AttestedAddressDocument> reusableDocuments;
		public String sourceOfIncomeAttestedDate;
		public String startOfRefreshDate;

		/**
		* @description
		* @param parser
		**/
		public RelatedPartyCompliance(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'complianceDecisionTraces') {
							complianceDecisionTraces = arrayOfComplianceDecisionTraces(parser);
						} else if (text == 'complianceStatus') {
							complianceStatus = parser.getText();
						} else if (text == 'customerDueDiligenceVerifications') {
							customerDueDiligenceVerifications = arrayOfCustomerDueDiligenceVerifications(parser);
						} else if (text == 'ficaAddressAttestedDate') {
							ficaAddressAttestedDate = parser.getText();
						} else if (text == 'identificationAttestedDate') {
							identificationAttestedDate = parser.getText();
						} else if (text == 'missingData') {
							missingData = arrayOfString(parser);
						} else if (text == 'missingDocuments') {
							missingDocuments = arrayOfArrangementType(parser);
						} else if (text == 'nextRefreshDate') {
							nextRefreshDate = parser.getText();
						} else if (text == 'party') {
							party = new Party(parser);
						} else if (text == 'partyFlags') {
							partyFlags = arrayOfPartyFlags(parser);
						} else if (text == 'rbaGuidanceMatrix') {
							rbaGuidanceMatrix = arrayOfRbaGuidanceMatrix(parser);
						} else if (text == 'refreshableDocuments') {
							refreshableDocuments = arrayOfAttestedAddressDocument(parser);
						} else if (text == 'relatedPartyCompliance') {
							relatedPartyCompliance = arrayOfObject(parser);
						} else if (text == 'reusableDocuments') {
							reusableDocuments = arrayOfAttestedAddressDocument(parser);
						} else if (text == 'sourceOfIncomeAttestedDate') {
							sourceOfIncomeAttestedDate = parser.getText();
						} else if (text == 'startOfRefreshDate') {
							startOfRefreshDate = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'RelatedPartyCompliance consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/**
    * @description
    **/
	public class TelephonicAddress {
		public ArrangementType context;
		public String countryCode;
		public String created;
		public String diallingCode;
		public String endDate;
		public String lastUpdatedExternalSystem;
		public String number_Z; // in json: number
		public ArrangementType role;
		public String startDate;
		public ArrangementType subType;
		public ArrangementType type;
		public String updated;

		/**
		* @description
		* @param parser
		**/
		public TelephonicAddress(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'context') {
							context = new ArrangementType(parser);
						} else if (text == 'countryCode') {
							countryCode = parser.getText();
						} else if (text == 'created') {
							created = parser.getText();
						} else if (text == 'diallingCode') {
							diallingCode = parser.getText();
						} else if (text == 'endDate') {
							endDate = parser.getText();
						} else if (text == 'lastUpdatedExternalSystem') {
							lastUpdatedExternalSystem = parser.getText();
						} else if (text == 'number') {
							number_Z = parser.getText();
						} else if (text == 'role') {
							role = new ArrangementType(parser);
						} else if (text == 'startDate') {
							startDate = parser.getText();
						} else if (text == 'subType') {
							subType = new ArrangementType(parser);
						} else if (text == 'type') {
							type = new ArrangementType(parser);
						} else if (text == 'updated') {
							updated = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'TelephonicAddress consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}


	/**
	* @description
	* @param json
	* @return GetCompliancePackInfo_Resp_Parse
	**/
	public static GetCompliancePackInfo_Resp_Parse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new GetCompliancePackInfo_Resp_Parse(parser);
	}

	/**
	* @description
	* @param parser
	**/
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT ||
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}



    /**
    * @description
    * @param p
    * @return List<ActiveInIndustries>
    **/
    private static List<ActiveInIndustries> arrayOfActiveInIndustries(System.JSONParser p) {
        List<ActiveInIndustries> res = new List<ActiveInIndustries>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ActiveInIndustries(p));
        }
        return res;
    }


    /**
    * @description
    * @param p
    * @return List<RelatedPartyCompliance>
    **/
    private static List<RelatedPartyCompliance> arrayOfRelatedPartyCompliance(System.JSONParser p) {
        List<RelatedPartyCompliance> res = new List<RelatedPartyCompliance>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new RelatedPartyCompliance(p));
        }
        return res;
    }

    /**
    * @description
    * @param p
    * @return List<ComplianceDecisionTraces>
    **/
    private static List<ComplianceDecisionTraces> arrayOfComplianceDecisionTraces(System.JSONParser p) {
        List<ComplianceDecisionTraces> res = new List<ComplianceDecisionTraces>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ComplianceDecisionTraces(p));
        }
        return res;
    }


    /**
    * @description
    * @param p
    * @return List<ElectronicAddresses>
    **/
    private static List<ElectronicAddresses> arrayOfElectronicAddresses(System.JSONParser p) {
        List<ElectronicAddresses> res = new List<ElectronicAddresses>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ElectronicAddresses(p));
        }
        return res;
    }

    /**
    * @description
    * @param p
    * @return List<ArrangementType>
    **/
    private static List<ArrangementType> arrayOfArrangementType(System.JSONParser p) {
        List<ArrangementType> res = new List<ArrangementType>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ArrangementType(p));
        }
        return res;
    }

    /**
    * @description
    * @param p
    * @return List<TelephonicAddress>
    **/
    private static List<TelephonicAddress> arrayOfTelephonicAddress(System.JSONParser p) {
        List<TelephonicAddress> res = new List<TelephonicAddress>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new TelephonicAddress(p));
        }
        return res;
    }

    /**
    * @description
    * @param p
    * @return List<Links>
    **/
    private static List<Links> arrayOfLinks(System.JSONParser p) {
        List<Links> res = new List<Links>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Links(p));
        }
        return res;
    }

    /**
    * @description
    * @param p
    * @return List<AttestedAddress>
    **/
    private static List<AttestedAddress> arrayOfAttestedAddress(System.JSONParser p) {
        List<AttestedAddress> res = new List<AttestedAddress>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new AttestedAddress(p));
        }
        return res;
    }

    /*private static List<Address> arrayOfAddress(System.JSONParser p) {
        List<Address> res = new List<Address>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Address(p));
        }
        return res;
    }*/


    /**
    * @description
    * @param p
    * @return List<Relationships>
    **/
    private static List<Relationships> arrayOfRelationships(System.JSONParser p) {
        List<Relationships> res = new List<Relationships>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Relationships(p));
        }
        return res;
    }

    /**
    * @description
    * @param p
    * @return List<AttestedAddressDocument>
    **/
    private static List<AttestedAddressDocument> arrayOfAttestedAddressDocument(System.JSONParser p) {
        List<AttestedAddressDocument> res = new List<AttestedAddressDocument>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new AttestedAddressDocument(p));
        }
        return res;
    }


    /**
    * @description
    * @param p
    * @return List<SourcesOfWealth>
    **/
    private static List<SourcesOfWealth> arrayOfSourcesOfWealth(System.JSONParser p) {
        List<SourcesOfWealth> res = new List<SourcesOfWealth>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new SourcesOfWealth(p));
        }
        return res;
    }


    /**
    * @description
    * @param p
    * @return List<CustomerDueDiligenceVerifications>
    **/
    private static List<CustomerDueDiligenceVerifications> arrayOfCustomerDueDiligenceVerifications(System.JSONParser p) {
        List<CustomerDueDiligenceVerifications> res = new List<CustomerDueDiligenceVerifications>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new CustomerDueDiligenceVerifications(p));
        }
        return res;
    }


    /**
    * @description
    * @param p
    * @return List<Arrangements>
    **/
    private static List<Arrangements> arrayOfArrangements(System.JSONParser p) {
        List<Arrangements> res = new List<Arrangements>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Arrangements(p));
        }
        return res;
    }


    /**
    * @description
    * @param p
    * @return List<RbaGuidanceMatrix>
    **/
    private static List<RbaGuidanceMatrix> arrayOfRbaGuidanceMatrix(System.JSONParser p) {
        List<RbaGuidanceMatrix> res = new List<RbaGuidanceMatrix>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new RbaGuidanceMatrix(p));
        }
        return res;
    }


    /**
    * @description
    * @param p
    * @return List<String>
    **/
    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }

    /**
    * @description
    * @param p
    * @return List<AttestedId>
    **/
    private static List<AttestedId> arrayOfAttestedId(System.JSONParser p) {
        List<AttestedId> res = new List<AttestedId>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new AttestedId(p));
        }
        return res;
    }

    /**
    * @description
    * @param p
    * @return List<Countries>
    **/
    private static List<Countries> arrayOfCountries(System.JSONParser p) {
        List<Countries> res = new List<Countries>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Countries(p));
        }
        return res;
    }


    /**
    * @description
    * @param p
    * @return List<Object>
    **/
    private static List<Object> arrayOfObject(System.JSONParser p) {
        List<Object> res = new List<Object>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.readValueAs(Object.class));
        }
        return res;
    }

    /**
    * @description
    * @param p
    * @return List<PartyFlags>
    **/
    private static List<PartyFlags> arrayOfPartyFlags(System.JSONParser p) {
        List<PartyFlags> res = new List<PartyFlags>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new PartyFlags(p));
        }
        return res;
    }
}