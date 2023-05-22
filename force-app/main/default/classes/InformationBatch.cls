public class InformationBatch implements Database.Batchable<sObject> {
    public List<Information__c> inforReceived; 

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT ID, Name, Major__c, Note__c FROM Information__c WHERE Major__c = \'Economy\'';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Information__c> inforList) {
        System.debug('inforList: ' + inforList.size());
        for(Information__c infor : inforList) {        
            // Update the Account Name 
            infor.Note__c = infor.Major__c + ' batch';
        }
        try {
            // Update the Account Record
            update inforList;
        } catch(Exception e) {
            System.debug(e);
        }
         
    }
    
    public void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
        List<String> toAddressList = new List<String>();
        toAddressList.add('dat2021997@gmail.com');
        List<String> ccAddressList = new List<String>();
        ccAddressList.add('tuandase04738@gmail.com');
        inforReceived = [Select ID, Name, Major__c, Note__c From Information__c Where Major__c = 'Economy'];
        System.debug('inforReceived: ' + inforReceived);
        sendEmail(toAddressList, ccAddressList, inforReceived);
    }

    public void sendEmail(List<String> toAddressList, List<String> ccAddressList, List<Information__c> inforList) {
        List<String> bodyEmail = new List<String>();
        bodyEmail.add('<h2> Total Information record is: ' + String.valueOf(inforList.size()) + '</h2>');
        for(Integer i = 0; i < inforReceived.size(); i++) {
            bodyEmail.add('<p> Information' + i + inforList[i] + '</p>');
        }
        String templateBody = String.join(bodyEmail,'\n');
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddressList);
        mail.setCcAddresses(ccAddressList);
        //mails.setBccAddresses(bccAddresses);
        // mails.setReplyTo('support@example.com');
        // mails.setSenderDisplayName('Salesforce Support');
        mail.setSubject('Email Batch');
        // mails.setPlainTextBody('This email has been sent through Apex');
        mail.setHtmlBody(templateBody);
        mails.add(mail);
        Messaging.sendEmail(mails, false);
        System.debug('Messaging success!!');
    }

}