public class editCIFJSONGenerator {
    
     private JSONGenerator jg = JSON.createGenerator(true);
    
    public String toString(ciupdateclientdetailV12_Req_IB_v1 req) {

    jg.writeStartObject();
    jg.writeFieldName('CIupdateClientDetailV12');
    jg.writeStartObject();
        
        
     jg.writeFieldName('nbsapdpi');
        jg.writeStartObject();
        writeField('channel','Salesforce');
        writeField('application','Salesforce');
        writeField('trace', 'Y');
        jg.writeEndObject();

        jg.writeFieldName('nbsmsgi');
        jg.writeStartObject();
        writeField('msgLanguage','E');
        writeField('msgTarget','STD');
        jg.writeFieldName('finalMsgId');
        jg.writeStartObject();
        writeField('finalMsgClass','');
        writeField('finalMsgCode','');
        jg.writeEndObject();
        jg.writeEndObject();


        jg.writeFieldName('cib004i');
        jg.writeStartObject();
        writeField('clientCode', req.CIupdateClientDetailV12.cib003i.clientCode);
        writeField('initials', req.CIupdateClientDetailV12.cib003i.initials, '');
        writeField('language',req.CIupdateClientDetailV12.cib003i.language);
        writeField('titleCode',req.CIupdateClientDetailV12.cib003i.titleCode,'0');
        writeField('surname',req.CIupdateClientDetailV12.cib003i.surname);
        writeField('postlAddrLine1', req.CIupdateClientDetailV12.cib003i.postlAddrLine1,' '); //req.CIupdateClientDetailV12.cib003i.postAddrLine1);
        writeField('postlAddrLine2', req.CIupdateClientDetailV12.cib003i.postlAddrLine2, ' '); //req.CIupdateClientDetailV12.cib003i.postAddrLine2);
        writeField('postlSuburb',req.CIupdateClientDetailV12.cib003i.postlSuburb,''); //req.CIupdateClientDetailV12.cib003i.postlSurbub);
        writeField('postlTown', req.CIupdateClientDetailV12.cib003i.postlTown);
        writeField('postlCodeRsa',req.CIupdateClientDetailV12.cib003i.postlCodeRsa, '0'); //req.CIupdateClientDetailV12.cib003i.postalCodeRsa);
        writeField('idDocType',req.CIupdateClientDetailV12.cib003i.idDocType);
        writeField('idNumber',req.CIupdateClientDetailV12.cib003i.idNumber);
        writeField('birthDate', req.CIupdateClientDetailV12.cib003i.birthDate, '0');
        writeField('maritalStatus',req.CIupdateClientDetailV12.cib003i.maritalStatus, '0');
        writeField('smsMarketInd',req.CIupdateClientDetailV12.cib003i.smsMarketInd, 'N');
        writeField('gender',req.CIupdateClientDetailV12.cib003i.gender, '0');
        writeField('minorChildren',req.CIupdateClientDetailV12.cib003i.minorChildren);
        writeField('occupationCode',req.CIupdateClientDetailV12.cib003i.occupationCode, '0'); 
        writeField('incomeGroup',req.CIupdateClientDetailV12.cib003i.incomeGroup, '0');
        writeField('bankingSector',req.CIupdateClientDetailV12.cib003i.bankingSector, '0');
        writeField('securityIndicator',req.CIupdateClientDetailV12.cib003i.securityIndicator, '0');
	    writeField('liabilityIndicator',req.CIupdateClientDetailV12.cib003i.liabilityIndicator, '0');
	    writeField('telebankIndicator',req.CIupdateClientDetailV12.cib003i.telebankIndicator, '0');
	    writeField('unclaimedFundsInd',req.CIupdateClientDetailV12.cib003i.unclaimedFundsInd, '0');
        writeField('branchClientOpen',req.CIupdateClientDetailV12.cib003i.branchClientOpen, '0'); //req.CIupdateClientDetailV12.cib003i.branchClientOpen);
        writeField('dateClientOpened',req.CIupdateClientDetailV12.cib003i.dateClientOpened, '0');
        writeField('changeNumber',req.CIupdateClientDetailV12.cib003i.changeNumber, '0');
        writeField('dateLastChanged',req.CIupdateClientDetailV12.cib003i.dateLastChanged, '0'); 
        writeField('siteLastChanged',req.CIupdateClientDetailV12.cib003i.siteLastChanged, '0'); 
        writeField('tellerLastChanged', req.CIupdateClientDetailV12.cib003i.tellerLastChanged, '0'); //req.CIupdateClientDetailV12.cib003i.tellerLastChanged);
        writeField('nbrOfAccounts', req.CIupdateClientDetailV12.cib003i.nbrOfAccounts, '0');
        writeField('prohibitedInd', req.CIupdateClientDetailV12.cib003i.prohibitedInd, '0');
        writeField('postalAddrHold', req.CIupdateClientDetailV12.cib003i.postalAddrHold, '0');
       // writeField('absaRewardIndctor', req.CIupdateClientDetailV12.cib003i.absaRewardIndctor, '0');
        writeField('idRequiredHold', req.CIupdateClientDetailV12.cib003i.idRequiredHold, '0');
        writeField('deceasedEstateHld', req.CIupdateClientDetailV12.cib003i.deceasedEstateHld, '0');
        writeField('deceasedSpouseHld', req.CIupdateClientDetailV12.cib003i.deceasedSpouseHld, '0');
        writeField('insolvntEstateHld', req.CIupdateClientDetailV12.cib003i.insolvntEstateHld, '0');
        writeField('curatorshipHold', req.CIupdateClientDetailV12.cib003i.curatorshipHold, '0');
        writeField('savngStatementHold', req.CIupdateClientDetailV12.cib003i.savngStatementHold, '0');
        writeField('courtAuthrityHold', req.CIupdateClientDetailV12.cib003i.courtAuthrityHold, '0');
        writeField('thirdPartyInd', req.CIupdateClientDetailV12.cib003i.thirdPartyInd, '0');
        writeField('mandateCaptureHld', req.CIupdateClientDetailV12.cib003i.mandateCaptureHld, '0');
        writeField('powerAttornyHold', req.CIupdateClientDetailV12.cib003i.powerAttornyHold, '0');
        writeField('sbuSegment', req.CIupdateClientDetailV12.cib003i.sbuSegment, '0');
        writeField('mariageContrctType',req.CIupdateClientDetailV12.cib003i.mariageContrctType, '0');
        writeField('homeLanguage',req.CIupdateClientDetailV12.cib003i.homeLanguage);
        writeField('marketingConcent',req.CIupdateClientDetailV12.cib003i.marketingConcent);
        writeField('clientType',req.CIupdateClientDetailV12.cib003i.clientType);
        writeField('miltaryComtmntInd', req.CIupdateClientDetailV12.cib003i.miltaryComtmntInd);
        writeField('occupancyType',req.CIupdateClientDetailV12.cib003i.occupancyType, '0');
        writeField('noOfJointPartcpnt',req.CIupdateClientDetailV12.cib003i.noOfJointPartcpnt, '0');
        writeField('taxNumber',req.CIupdateClientDetailV12.cib003i.taxNumber,'0');
        writeField('sicCode',req.CIupdateClientDetailV12.cib003i.sicCode,'0');
        writeField('firstNames',req.CIupdateClientDetailV12.cib003i.firstNames);
        writeField('insolventIndicator',req.CIupdateClientDetailV12.cib003i.insolventIndicator);
        writeField('companyYearEnd',req.CIupdateClientDetailV12.cib003i.companyYearEnd, '0');
        writeField('homeTelCode',req.CIupdateClientDetailV12.cib003i.homeTelCode, '0');
        writeField('homeTelephone',req.CIupdateClientDetailV12.cib003i.homeTelephone);
        writeField('workTelCode',req.CIupdateClientDetailV12.cib003i.workTelCode, '0');
        writeField('workTelephone',req.CIupdateClientDetailV12.cib003i.workTelephone);
        writeField('physicalAddrHold',req.CIupdateClientDetailV12.cib003i.physicalAddrHold);
        writeField('employerAddrHold',req.CIupdateClientDetailV12.cib003i.employerAddrHold);
        writeField('cellphone',req.CIupdateClientDetailV12.cib003i.cellphone, '0');
        writeField('faxWorkCode',req.CIupdateClientDetailV12.cib003i.faxWorkCode, '0');
        writeField('faxWorkNumber',req.CIupdateClientDetailV12.cib003i.faxWorkNumber, '0');
        writeField('faxHomeCode',req.CIupdateClientDetailV12.cib003i.faxHomeCode, '0');
        writeField('faxHomeNumber',req.CIupdateClientDetailV12.cib003i.faxHomeNumber, '0');
        writeField('occupationStatus',req.CIupdateClientDetailV12.cib003i.occupationStatus, '0');
        writeField('employmentSector',req.CIupdateClientDetailV12.cib003i.employmentSector, '0');
        writeField('occupationLevel',req.CIupdateClientDetailV12.cib003i.occupationLevel, '0');
        writeField('practiceNumber',req.CIupdateClientDetailV12.cib003i.practiceNumber);
        writeField('clientWebsite', req.CIupdateClientDetailV12.cib003i.clientWebsite);
        writeField('contactPerson',req.CIupdateClientDetailV12.cib003i.contactPerson);
        writeField('designation',req.CIupdateClientDetailV12.cib003i.designation, '0');
        writeField('emailAddress',req.CIupdateClientDetailV12.cib003i.emailAddress);
        writeField('inliPolicy',req.CIupdateClientDetailV12.cib003i.inliPolicy);
        writeField('exliPolicy',req.CIupdateClientDetailV12.cib003i.exliPolicy);
        writeField('instPolicy',req.CIupdateClientDetailV12.cib003i.instPolicy);
        writeField('exstPolicy',req.CIupdateClientDetailV12.cib003i.exstPolicy);
        writeField('inivPolicy',req.CIupdateClientDetailV12.cib003i.inivPolicy);
        writeField('flexiFuneralPolicy',req.CIupdateClientDetailV12.cib003i.flexiFuneralPolicy);
        writeField('prefrdCommtionMthd',req.CIupdateClientDetailV12.cib003i.prefrdCommtionMthd, '0');
        writeField('cellphoneBankInd',req.CIupdateClientDetailV12.cib003i.cellphoneBankInd, '0');
        writeField('siccCode5',req.CIupdateClientDetailV12.cib003i.siccCode5);
        writeField('subSegment',req.CIupdateClientDetailV12.cib003i.subSegment);
        writeField('emailMarkInd',req.CIupdateClientDetailV12.cib003i.emailMarkInd);
        writeField('teleMarkInd',req.CIupdateClientDetailV12.cib003i.teleMarkInd);
        writeField('internetBankinInd',req.CIupdateClientDetailV12.cib003i.internetBankinInd);
        writeField('sourceOfIncome',req.CIupdateClientDetailV12.cib003i.sourceOfIncome, '0');
        writeField('dateIdentified',req.CIupdateClientDetailV12.cib003i.dateIdentified, '0');
        writeField('dateVerified',req.CIupdateClientDetailV12.cib003i.dateVerified, '0');
        writeField('employeeIdentified',req.CIupdateClientDetailV12.cib003i.employeeIdentified);
        writeField('employeeVerified',req.CIupdateClientDetailV12.cib003i.employeeVerified);
        writeField('vatRegistrationNo',req.CIupdateClientDetailV12.cib003i.vatRegistrationNo);
        writeField('clientNationality',req.CIupdateClientDetailV12.cib003i.clientNationality);
        writeField('countryOfOrigin', req.CIupdateClientDetailV12.cib003i.countryOfOrigin); 
        writeField('employeeExempted', req.CIupdateClientDetailV12.cib003i.employeeExempted);
        writeField('exemptionStatus', req.CIupdateClientDetailV12.cib003i.exemptionStatus);
        writeField('dateExempted',req.CIupdateClientDetailV12.cib003i.exemptionIndicator, '0');
        writeField('corporateDivision',req.CIupdateClientDetailV12.cib003i.corporateDivision);
        writeField('haveQualification',req.CIupdateClientDetailV12.cib003i.haveQualification);
        writeField('whatQualification',req.CIupdateClientDetailV12.cib003i.whatQualification,'0');
        writeField('socialGrant',req.CIupdateClientDetailV12.cib003i.socialGrant);
        writeField('notificationInd',req.CIupdateClientDetailV12.cib003i.notificationInd);
        writeField('mailInd',req.CIupdateClientDetailV12.cib003i.mailInd); 
        writeField('applyDebtCounsel',req.CIupdateClientDetailV12.cib003i.applyDebtCounsel); 
        writeField('dteApplyCounsel','0'); 
        writeField('counselOrderIssue',req.CIupdateClientDetailV12.cib003i.counselOrderIssue); 
        writeField('dteOrderIssue','0'); 
        writeField('groupScheme',req.CIupdateClientDetailV12.cib003i.groupScheme, '0');
        writeField('groupSchemeEmp',req.CIupdateClientDetailV12.cib003i.groupSchemeEmp, '');
        writeField('secondaryCard',req.CIupdateClientDetailV12.cib003i.secondaryCard);
        writeField('affectedPerson',req.CIupdateClientDetailV12.cib003i.affectedPerson, '0');
        writeField('exconExpiryDate',req.CIupdateClientDetailV12.cib003i.exconExpiryDate);
        writeField('dateIssued',req.CIupdateClientDetailV12.cib003i.dateIssued, '0');
        writeField('ibrAffected',req.CIupdateClientDetailV12.cib003i.ibrAffected, '0');
       // writeField('clientGroup',req.CIupdateClientDetailV12.cib003i.clientGroup);
        writeField('employerAddrType', req.CIupdateClientDetailV12.cib003i.employerAddrType,'0');
        writeField('employerAddrSeqNbr', req.CIupdateClientDetailV12.cib003i.employerAddrSeqNbr,'0');
        writeField('employerAdd1',req.CIupdateClientDetailV12.cib003i.employerAdd1);
        writeField('employerAdd2',req.CIupdateClientDetailV12.cib003i.employerAdd2);
        writeField('employerSuburb',req.CIupdateClientDetailV12.cib003i.employerSuburb);
        writeField('employerTown',req.CIupdateClientDetailV12.cib003i.employerTown);
        writeField('employerPostal',req.CIupdateClientDetailV12.cib003i.employerPostal, '0');
        writeField('physicalAddrType',req.CIupdateClientDetailV12.cib003i.physicalAddrType, '0');
        writeField('physicalAddrSeqNbr',req.CIupdateClientDetailV12.cib003i.physicalAddrSeqNbr, '0');
        writeField('physicalAdd1',req.CIupdateClientDetailV12.cib003i.physicalAdd1);
        writeField('physicalAdd2',req.CIupdateClientDetailV12.cib003i.physicalAdd2);
        writeField('physicalSuburb',req.CIupdateClientDetailV12.cib003i.physicalSuburb);
        writeField('physicalTown',req.CIupdateClientDetailV12.cib003i.physicalTown);
        writeField('physicalPostal',req.CIupdateClientDetailV12.cib003i.physicalPostal, '0');
        writeField('businessAddrType',req.CIupdateClientDetailV12.cib003i.businessAddrType, '0');
        writeField('businessAddrSeqNbr',req.CIupdateClientDetailV12.cib003i.businessAddrSeqNbr, '0');
        writeField('businessAdd1',req.CIupdateClientDetailV12.cib003i.businessAdd1);
        writeField('businessAdd2',req.CIupdateClientDetailV12.cib003i.businessAdd2);
        writeField('businessSuburb', req.CIupdateClientDetailV12.cib003i.businessSuburb);
        writeField('businessTown',req.CIupdateClientDetailV12.cib003i.businessTown);
        writeField('businessPostal',req.CIupdateClientDetailV12.cib003i.businessPostal, '0');
        //agridata
        //public List<AddressEntry> addressEntry;
	    //public List<ClsPercEntry> clsPercEntry;
      //  if (req.CIupdateClientDetailV12.cib003i.agriData  != null) {
            jg.writeFieldName('agriData');
            jg.writeStartArray();
            for (ciupdateclientdetailV12_Req_IB_v1.agriData  ad : req.CIupdateClientDetailV12.cib003i.agriData ) {
                jg.writeStartObject();
                writeField('agriClass', ad.agriClass, '');
                writeField('percentage', ad.percentage, '0');
                jg.writeEndObject();
            }
            jg.writeEndArray();
     //   }
        //end agridata
        writeField('resPermitNbr', req.CIupdateClientDetailV12.cib003i.resPermitNbr);
        writeField('permitExpDte', req.CIupdateClientDetailV12.cib003i.permitExpDte,'0'); //);
        writeField('subClassCde',req.CIupdateClientDetailV12.cib003i.subClassCde);
        writeField('countryIncorp',req.CIupdateClientDetailV12.cib003i.countryIncorp);
        writeField('inBusinessRescue',req.CIupdateClientDetailV12.cib003i.inBusinessRescue);
        writeField('placedBy',req.CIupdateClientDetailV12.cib003i.placedBy);
        writeField('dateBusRescueIss',req.CIupdateClientDetailV12.cib003i.dateBusRescueIss);
        writeField('ncaThreshold',req.CIupdateClientDetailV12.cib003i.ncaThreshold);
        writeField('cpaThreshold',req.CIupdateClientDetailV12.cib003i.cpaThreshold);
        writeField('nkinSurname',req.CIupdateClientDetailV12.cib003i.nkinSurname);
        writeField('nkinFname',req.CIupdateClientDetailV12.cib003i.nkinFname);
        writeField('nkinRela',req.CIupdateClientDetailV12.cib003i.nkinRela);
        writeField('nkinDcdh',req.CIupdateClientDetailV12.cib003i.nkinDcdh);
        writeField('nkinTelh',req.CIupdateClientDetailV12.cib003i.nkinTelh);
        writeField('nkinDcdw',req.CIupdateClientDetailV12.cib003i.nkinDcdw);
        writeField('nkinTelw',req.CIupdateClientDetailV12.cib003i.nkinTelw);
        writeField('nkinCell',req.CIupdateClientDetailV12.cib003i.nkinCell);
        writeField('nkinEmail',req.CIupdateClientDetailV12.cib003i.nkinEmail);
        writeField('nkinTitle', req.CIupdateClientDetailV12.cib003i.nkinTitle);
        writeField('nkinInitials', req.CIupdateClientDetailV12.cib003i.nkinInitials);
        writeField('nkinJntSurname', req.CIupdateClientDetailV12.cib003i.nkinJntSurname);
        writeField('contOride', '0');
        writeField('updAddressInd', req.CIupdateClientDetailV12.cib003i.updAddressInd, '0'); //req.CIupdateClientDetailV12.cib003i.updAddressInd);
        writeField('updTelephoneInd', req.CIupdateClientDetailV12.cib003i.updTelephoneInd, '0'); //req.CIupdateClientDetailV12.cib003i.updTelephoneInd);
        writeField('updEmailInd', req.CIupdateClientDetailV12.cib003i.updEmailInd, '0'); //req.CIupdateClientDetailV12.cib003i.updEmailInd);
        writeField('updDateInd',req.CIupdateClientDetailV12.cib003i.updDateInd, '0'); //req.CIupdateClientDetailV12.cib003i.updDateInd);
        writeField('casaRefNum',req.CIupdateClientDetailV12.cib003i.casaRefNum, '0');
        writeField('pingitWallet',req.CIupdateClientDetailV12.cib003i.pingitWallet);
        writeField('pingitReceive', req.CIupdateClientDetailV12.cib003i.pingitReceive);
        writeField('regAddrLine1',req.CIupdateClientDetailV12.cib003i.regAddrLine1);
        writeField('regAddrLine2',req.CIupdateClientDetailV12.cib003i.regAddrLine2);
        writeField('regSuburb',req.CIupdateClientDetailV12.cib003i.regSuburb);
        writeField('regTown',req.CIupdateClientDetailV12.cib003i.regTown);
        writeField('regCodeRsa',req.CIupdateClientDetailV12.cib003i.regCodeRsa, '0');
        writeField('hoAddrLine1',req.CIupdateClientDetailV12.cib003i.hoAddrLine1);
        writeField('hoAddrLine2',req.CIupdateClientDetailV12.cib003i.hoAddrLine2);
        writeField('hoSuburb',req.CIupdateClientDetailV12.cib003i.hoSuburb);
        writeField('hoTown',req.CIupdateClientDetailV12.cib003i.hoTown);
        writeField('hoCodeRsa',req.CIupdateClientDetailV12.cib003i.hoCodeRsa, '0');
        writeField('countryResAddress', req.CIupdateClientDetailV12.cib003i.countryResAddress);
        writeField('countryHoAddress', req.CIupdateClientDetailV12.cib003i.countryHoAddress);
        writeField('countryRegAddress', req.CIupdateClientDetailV12.cib003i.countryRegAddress);
        if (req.CIupdateClientDetailV12.cib003i.countryEntOprtData != null) {
            jg.writeFieldName('countryEntOprtData');
            jg.writeStartArray();
            for (ciupdateclientdetailV12_Req_IB_v1.CountryEntOprtData ceod : req.CIupdateClientDetailV12.cib003i.countryEntOprtData) {
                jg.writeStartObject();
                writeField('countryEntOprt', ceod.countryEntOprt);
                jg.writeEndObject();
            }
            jg.writeEndArray();
        }
        
        writeField('countryOfBirth',req.CIupdateClientDetailV12.cib003i.countryOfBirth);
        writeField('mclInd',req.CIupdateClientDetailV12.cib003i.mclInd);
        writeField('clntAgrmntIssued',req.CIupdateClientDetailV12.cib003i.clntAgrmntIssued); 
        writeField('sec129DeliveryAddr',req.CIupdateClientDetailV12.cib003i.sec129DeliveryAddr); 
        writeField('saTaxRegis',req.CIupdateClientDetailV12.cib003i.saTaxRegis);
        writeField('rsonSaTaxNotGiven',req.CIupdateClientDetailV12.cib003i.rsonSaTaxNotGiven);
        writeField('foreignTaxRegis', req.CIupdateClientDetailV12.cib003i.foreignTaxRegis, 'N');
        if (req.CIupdateClientDetailV12.cib003i.foreignTaxData != null) {
            jg.writeFieldName('foreignTaxData');
            jg.writeStartArray();
            for (ciupdateclientdetailV12_Req_IB_v1.ForeignTaxData ftd : req.CIupdateClientDetailV12.cib003i.ForeignTaxData) {
                jg.writeStartObject();
                writeField('foreignTaxCtry', ftd.foreignTaxCtry,'0');
                writeField('foreignTaxNo', ftd.foreignTaxNo);
                writeField('rsonFtaxNotGiven', ftd.rsonFtaxNotGiven);
                jg.writeEndObject();
            }
            jg.writeEndArray();
        }
        writeField('ncrInd',req.CIupdateClientDetailV12.cib003i.ncrInd);
        writeField('ncrSms',req.CIupdateClientDetailV12.cib003i.ncrSms);
        writeField('ncrEmail',req.CIupdateClientDetailV12.cib003i.ncrEmail);
        writeField('ncrAvoice',req.CIupdateClientDetailV12.cib003i.ncrAvoice);
        writeField('ncrTel',req.CIupdateClientDetailV12.cib003i.ncrTel);
        writeField('ncrPost',req.CIupdateClientDetailV12.cib003i.ncrPost);
        writeField('crInd',req.CIupdateClientDetailV12.cib003i.crInd);
        writeField('crSms',req.CIupdateClientDetailV12.cib003i.crSms);
        writeField('crEmail',req.CIupdateClientDetailV12.cib003i.crEmail);
        writeField('crAvoice',req.CIupdateClientDetailV12.cib003i.crAvoice);
        writeField('crTel',req.CIupdateClientDetailV12.cib003i.crTel);
        writeField('crPost',req.CIupdateClientDetailV12.cib003i.crPost);
        jg.writeEndObject();
        jg.writeEndObject();
        jg.writeEndObject();
        return jg.getAsString();
    }
    
    private void writeField(String key, String value, String defaultValue) {
        jg.writeStringField(key, value == null ||  value == '' ? defaultValue : value);
    }
    
    private void writeField(String key, String value) {
        writeField(key, value, ' ');
    }

}