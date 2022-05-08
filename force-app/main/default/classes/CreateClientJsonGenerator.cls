/*F
* @author Masimba
*/

public class CreateClientJsonGenerator {
    
    private JSONGenerator jg = JSON.createGenerator(true);
    
    public String toString(CreateClientCIF_Req_IB_v1 req) {
        //JSONGenerator jg= JSON.createGenerator(true);
        jg.writeStartObject();
        jg.writeFieldName('CIcreateClientV12');
        jg.writeStartObject();

        jg.writeFieldName('nbsapdpi');
        jg.writeStartObject();
        writeField('channel', req.CIcreateClientV12.nbsapdpi.channel);
        writeField('application', req.CIcreateClientV12.nbsapdpi.application);
        writeField('trace', '');
        jg.writeEndObject();

        jg.writeFieldName('nbsmsgi');
        jg.writeStartObject();
        writeField('msgLanguage', req.CIcreateClientV12.nbsmsgi.msgLanguage);
        writeField('msgTarget', req.CIcreateClientV12.nbsmsgi.msgTarget);
        jg.writeFieldName('finalMsgId');
        jg.writeStartObject();
        writeField('finalMsgClass','');
        writeField('finalMsgCode','');
        jg.writeEndObject();
        jg.writeEndObject();

        jg.writeFieldName('cib003i');
        jg.writeStartObject();
        writeField('initials', req.CIcreateClientV12.cib003i.initials);
        writeField('language',req.CIcreateClientV12.cib003i.language);
        writeField('titleCode',req.CIcreateClientV12.cib003i.titleCode);
        writeField('surname',req.CIcreateClientV12.cib003i.surname);
        writeField('postlAddrLine1', req.CIcreateClientV12.cib003i.postlAddrLine1,' '); //req.CIcreateClientV12.cib003i.postAddrLine1);
        writeField('postlAddrLine2', req.CIcreateClientV12.cib003i.postlAddrLine2, ' '); //req.CIcreateClientV12.cib003i.postAddrLine2);
        writeField('postlSuburb',req.CIcreateClientV12.cib003i.postlSuburb,''); //req.CIcreateClientV12.cib003i.postlSurbub);
        writeField('postlTown', req.CIcreateClientV12.cib003i.postlTown);
        writeField('postlCodeRsa',req.CIcreateClientV12.cib003i.postlCodeRsa, '0'); //req.CIcreateClientV12.cib003i.postalCodeRsa);
        writeField('idType',req.CIcreateClientV12.cib003i.idType);
        writeField('idNumber',req.CIcreateClientV12.cib003i.idNumber);
        writeField('birthDate',req.CIcreateClientV12.cib003i.birthDate, '0');
        writeField('maritalStatus',req.CIcreateClientV12.cib003i.maritalStatus, '0');
        writeField('smsMarketInd',req.CIcreateClientV12.cib003i.smsMarketInd, 'N');
        writeField('gender',req.CIcreateClientV12.cib003i.gender, '0');
        writeField('minorChildren',req.CIcreateClientV12.cib003i.minorChildren);
        writeField('occupationCode',req.CIcreateClientV12.cib003i.occupationCode, '0'); 
        writeField('incomeGroup',req.CIcreateClientV12.cib003i.incomeGroup, '0');
        writeField('branchClientOpen',req.CIcreateClientV12.cib003i.branchClientOpen, '0'); //req.CIcreateClientV12.cib003i.branchClientOpen);
        writeField('tellerLastChanged', req.CIcreateClientV12.cib003i.tellerLastChanged, '0'); //req.CIcreateClientV12.cib003i.tellerLastChanged);
        writeField('mariageContrctType',req.CIcreateClientV12.cib003i.mariageContrctType, '0');
        writeField('homeLanguage',req.CIcreateClientV12.cib003i.homeLanguage);
        writeField('marketingConcent',req.CIcreateClientV12.cib003i.marketingConcent);
        writeField('clientType',req.CIcreateClientV12.cib003i.clientType);
        writeField('miltaryComtmntInd', req.CIcreateClientV12.cib003i.miltaryComtmntInd);
        writeField('occupancyType',req.CIcreateClientV12.cib003i.occupancyType, '0');
        writeField('noOfJointPartcpnt',req.CIcreateClientV12.cib003i.noOfJointPartcpnt, '0');
        writeField('taxNumber',req.CIcreateClientV12.cib003i.taxNumber,'0');
        writeField('firstNames',req.CIcreateClientV12.cib003i.firstNames);
        writeField('companyYearEnd',req.CIcreateClientV12.cib003i.companyYearEnd, '0');
        writeField('homeTelCode',req.CIcreateClientV12.cib003i.homeTelCode, '0');
        writeField('homeTelephone',req.CIcreateClientV12.cib003i.homeTelephone);
        writeField('workTelCode',req.CIcreateClientV12.cib003i.workTelCode, '0');
        writeField('workTelephone',req.CIcreateClientV12.cib003i.workTelephone);
        writeField('cellphone',req.CIcreateClientV12.cib003i.cellphone, '0');
        //writeField('faxWorkCode',req.CIcreateClientV12.cib003i.faxWorkCode);
        //writeField('faxWorkNumber',faxWorkNumber);
        //writeField('faxHomeCode',faxHomeCode);
        //writeField('faxHomeNumber',req.CIcreateClientV12.cib003i.faxHomeNumber);
        writeField('occupationStatus',req.CIcreateClientV12.cib003i.occupationStatus, '0');
        writeField('employmentSector',req.CIcreateClientV12.cib003i.employmentSector, '0');
        writeField('occupationLevel',req.CIcreateClientV12.cib003i.occupationLevel, '0');
        writeField('practiceNumber',req.CIcreateClientV12.cib003i.practiceNumber);
        writeField('clientWebsite', req.CIcreateClientV12.cib003i.clientWebsite);
        writeField('contactPerson',req.CIcreateClientV12.cib003i.contactPerson);
        writeField('designation',req.CIcreateClientV12.cib003i.designation, '0');
        writeField('emailAddress',req.CIcreateClientV12.cib003i.emailAddress);
        writeField('prefrdCommtionMthd',req.CIcreateClientV12.cib003i.prefrdCommtionMthd, '0');
        writeField('siccCode5',req.CIcreateClientV12.cib003i.siccCode5);
        writeField('emailMarkInd',req.CIcreateClientV12.cib003i.emailMarkInd);
        writeField('teleMarkInd',req.CIcreateClientV12.cib003i.teleMarkInd);
        writeField('sourceOfIncome',req.CIcreateClientV12.cib003i.sourceOfIncome, '0');
        writeField('dateIdentified',req.CIcreateClientV12.cib003i.dateIdentified, '0');
        writeField('dateVerified',req.CIcreateClientV12.cib003i.dateVerified, '0');
        writeField('employeeIdentified',req.CIcreateClientV12.cib003i.employeeIdentified);
        writeField('employeeVerified',req.CIcreateClientV12.cib003i.employeeVerified);
        writeField('vatRegistrationNo',req.CIcreateClientV12.cib003i.vatRegistrationNo);
        writeField('clientNationality',req.CIcreateClientV12.cib003i.clientNationality);
        writeField('countryOfOrigin', req.CIcreateClientV12.cib003i.countryOfOrigin);
        writeField('dateExempted',req.CIcreateClientV12.cib003i.dateExempted, '0');
        writeField('employeeExempted',req.CIcreateClientV12.cib003i.employeeExempted);
        writeField('exemptionStatus',req.CIcreateClientV12.cib003i.exemptionStatus);
        writeField('exemptionIndicator',req.CIcreateClientV12.cib003i.exemptionIndicator);
        writeField('corporateDivision',req.CIcreateClientV12.cib003i.corporateDivision);
        writeField('haveQualification',req.CIcreateClientV12.cib003i.haveQualification);
        //writeField('whatQualification',req.CIcreateClientV12.cib003i.whatQualification);
        writeField('socialGrant',req.CIcreateClientV12.cib003i.socialGrant);
        writeField('mailInd',req.CIcreateClientV12.cib003i.mailInd);
        writeField('groupScheme',req.CIcreateClientV12.cib003i.groupScheme, '0');
        writeField('groupSchemeEmp',req.CIcreateClientV12.cib003i.groupSchemeEmp, '');
        writeField('secondaryCard',req.CIcreateClientV12.cib003i.secondaryCard);
        writeField('affectedPerson',req.CIcreateClientV12.cib003i.affectedPerson, '0');
        writeField('exconExpiryDate',req.CIcreateClientV12.cib003i.exconExpiryDate, '0');
        writeField('dateIssued',req.CIcreateClientV12.cib003i.dateIssued, '0');
        writeField('employerAddrType', req.CIcreateClientV12.cib003i.employerAddrType,'0');
        writeField('employerAdd1',req.CIcreateClientV12.cib003i.employerAdd1);
        writeField('employerAdd2',req.CIcreateClientV12.cib003i.employerAdd2);
        writeField('employerSuburb',req.CIcreateClientV12.cib003i.employerSuburb);
        writeField('employerTown',req.CIcreateClientV12.cib003i.employerTown);
        writeField('employerPostal',req.CIcreateClientV12.cib003i.employerPostal, '0');
        writeField('physicalAddrType',req.CIcreateClientV12.cib003i.physicalAddrType, '0');
        writeField('physicalAdd1',req.CIcreateClientV12.cib003i.physicalAdd1);
        writeField('physicalAdd2',req.CIcreateClientV12.cib003i.physicalAdd2);
        writeField('physicalSuburb',req.CIcreateClientV12.cib003i.physicalSuburb);
        writeField('physicalTown',req.CIcreateClientV12.cib003i.physicalTown);
        writeField('physicalPostal',req.CIcreateClientV12.cib003i.physicalPostal, '0');
        writeField('businessAddrType',req.CIcreateClientV12.cib003i.businessAddrType, '0');
        writeField('businessAdd1',req.CIcreateClientV12.cib003i.businessAdd1);
        writeField('businessAdd2',req.CIcreateClientV12.cib003i.businessAdd2);
        writeField('businessSuburb', req.CIcreateClientV12.cib003i.businessSuburb);
        writeField('businessTown',req.CIcreateClientV12.cib003i.businessTown);
        writeField('businessPostal',req.CIcreateClientV12.cib003i.businessPostal, '0');
        //agridata
        if (req.CIcreateClientV12.cib003i.agriData != null) {
            jg.writeFieldName('agriData');
            jg.writeStartArray();
            for (CreateClientCIF_Req_IB_v1.AgriData ad : req.CIcreateClientV12.cib003i.agriData) {
                jg.writeStartObject();
                writeField('agriClass', ad.agriClass);
                writeField('percentage',ad.percentage);
                jg.writeEndObject();
            }
            jg.writeEndArray();
        }
        //end agridata
        writeField('resPermitNbr', req.CIcreateClientV12.cib003i.resPermitNbr);
        writeField('permitExpDte', req.CIcreateClientV12.cib003i.permitExpDte,'0'); //);
        writeField('subClassCde',req.CIcreateClientV12.cib003i.subClassCde);
        writeField('countryIncorp',req.CIcreateClientV12.cib003i.countryIncorp);
        writeField('ncaThreshold',req.CIcreateClientV12.cib003i.ncaThreshold);
        writeField('cpaThreshold',req.CIcreateClientV12.cib003i.cpaThreshold);
        writeField('nkinSurname',req.CIcreateClientV12.cib003i.nkinSurname);
        writeField('nkinFname',req.CIcreateClientV12.cib003i.nkinFname);
        writeField('nkinRela',req.CIcreateClientV12.cib003i.nkinRela);
        writeField('nkinDcdh',req.CIcreateClientV12.cib003i.nkinDcdh);
        writeField('nkinTelh',req.CIcreateClientV12.cib003i.nkinTelh);
        writeField('nkinDcdw',req.CIcreateClientV12.cib003i.nkinDcdw);
        writeField('nkinTelw',req.CIcreateClientV12.cib003i.nkinTelw);
        writeField('nkinCell',req.CIcreateClientV12.cib003i.nkinCell);
        writeField('nkinEmail',req.CIcreateClientV12.cib003i.nkinEmail);
        writeField('nkinTitle', req.CIcreateClientV12.cib003i.nkinTitle);
        writeField('nkinInitials', req.CIcreateClientV12.cib003i.nkinInitials);
        writeField('nkinJntSurname', req.CIcreateClientV12.cib003i.nkinJntSurname);
        //writeField('contOride',req.CIcreateClientV12.cib003i.contOride);
        writeField('thrdPartyInd',req.CIcreateClientV12.cib003i.thrdPartyInd, '0');  //req.CIcreateClientV12.cib003i.thrdPartyInd);
        writeField('updAddressInd', req.CIcreateClientV12.cib003i.updAddressInd, '0'); //req.CIcreateClientV12.cib003i.updAddressInd);
        writeField('updTelephoneInd', req.CIcreateClientV12.cib003i.updTelephoneInd, '0'); //req.CIcreateClientV12.cib003i.updTelephoneInd);
        writeField('updEmailInd', req.CIcreateClientV12.cib003i.updEmailInd, '0'); //req.CIcreateClientV12.cib003i.updEmailInd);
        writeField('updDateInd',req.CIcreateClientV12.cib003i.updDateInd, '0'); //req.CIcreateClientV12.cib003i.updDateInd);
        writeField('casaRefNum',req.CIcreateClientV12.cib003i.casaRefNum);
        writeField('pingitWallet',req.CIcreateClientV12.cib003i.pingitWallet);
        writeField('pingitReceive', req.CIcreateClientV12.cib003i.pingitReceive);
        writeField('regAddrLine1',req.CIcreateClientV12.cib003i.regAddrLine1);
        writeField('regAddrLine2',req.CIcreateClientV12.cib003i.regAddrLine2);
        writeField('regSuburb',req.CIcreateClientV12.cib003i.regSuburb);
        writeField('regTown',req.CIcreateClientV12.cib003i.regTown);
        writeField('regCodeRsa',req.CIcreateClientV12.cib003i.regCodeRsa, '0');
        writeField('hoAddrLine1',req.CIcreateClientV12.cib003i.hoAddrLine1);
        writeField('hoAddrLine2',req.CIcreateClientV12.cib003i.hoAddrLine2);
        writeField('hoSuburb',req.CIcreateClientV12.cib003i.hoSuburb);
        writeField('hoTown',req.CIcreateClientV12.cib003i.hoTown);
        writeField('hoCodeRsa',req.CIcreateClientV12.cib003i.hoCodeRsa, '0');
        writeField('countryResAddress', req.CIcreateClientV12.cib003i.countryResAddress);
        writeField('countryHoAddress', req.CIcreateClientV12.cib003i.countryHoAddress);
        writeField('countryRegAddress', req.CIcreateClientV12.cib003i.countryRegAddress);
        if (req.CIcreateClientV12.cib003i.countryEntOprtData != null) {
            jg.writeFieldName('countryEntOprtData');
            jg.writeStartArray();
            for (CreateClientCIF_Req_IB_v1.CountryEntOprtData ceod : req.CIcreateClientV12.cib003i.countryEntOprtData) {
                jg.writeStartObject();
                writeField('countryEntOprt', ceod.countryEntOprt);
                jg.writeEndObject();
            }
            jg.writeEndArray();
        }
        
        writeField('countryOfBirth',req.CIcreateClientV12.cib003i.countryOfBirth);
        writeField('clntAgrmntIssued',req.CIcreateClientV12.cib003i.clntAgrmntIssued); 
        
        writeField('saTaxRegis',req.CIcreateClientV12.cib003i.saTaxRegis);
        writeField('rsonSaTaxNotGiven',req.CIcreateClientV12.cib003i.rsonSaTaxNotGiven);
        writeField('foreignTaxRegis', req.CIcreateClientV12.cib003i.foreignTaxRegis, 'N');
        if (req.CIcreateClientV12.cib003i.foreignTaxData != null) {
            jg.writeFieldName('foreignTaxData');
            jg.writeStartArray();
            for (CreateClientCIF_Req_IB_v1.ForeignTaxData ftd : req.CIcreateClientV12.cib003i.foreignTaxData) {
                jg.writeStartObject();
                writeField('foreignTaxCtry', ftd.foreignTaxCtry,'0');
                writeField('foreignTaxNo', ftd.foreignTaxNo);
                writeField('rsonFtaxNotGiven', ftd.rsonFtaxNotGiven);
                jg.writeEndObject();
            }
            jg.writeEndArray();
        }
        writeField('ncrInd',req.CIcreateClientV12.cib003i.ncrInd);
        writeField('ncrSms',req.CIcreateClientV12.cib003i.ncrSms);
        writeField('ncrEmail',req.CIcreateClientV12.cib003i.ncrEmail);
        writeField('ncrAvoice', req.CIcreateClientV12.cib003i.ncrAvoice);
        writeField('ncrTel', req.CIcreateClientV12.cib003i.ncrTel);
        writeField('ncrPost',req.CIcreateClientV12.cib003i.ncrPost);
        writeField('crInd', req.CIcreateClientV12.cib003i.crInd);
        writeField('crSms', req.CIcreateClientV12.cib003i.crSms);
        writeField('crEmail', req.CIcreateClientV12.cib003i.crEmail);
        writeField('crAvoice', req.CIcreateClientV12.cib003i.crAvoice);
        writeField('crTel', req.CIcreateClientV12.cib003i.crTel);
        writeField('crPost',req.CIcreateClientV12.cib003i.crPost);
        jg.writeEndObject();
        jg.writeEndObject();
        jg.writeEndObject();
        
        return jg.getAsString();
    }
    
    private void writeField(String key, String value, String defaultValue) {
        jg.writeStringField(key, value == null ? defaultValue : value);
    }
    
    private void writeField(String key, String value) {
        writeField(key, value, ' ');
    }
    
}