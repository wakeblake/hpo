/*
List<String> profiles = new List<String>{'Standard Platform User'};
for (Profile p: [SELECT name, id FROM Profile WHERE name in :profiles]) {
    system.debug(p);
}

List<User> users = new List<User>();
for (User u: [SELECT lastname, alias, profileid FROM User]) {
    switch on u.lastname {
        when 'Holmes' {
            u.profileid = '00e1F000001V8xmQAC';
            users.add(u);
        }
        when 'Lestrade' {
            u.profileid = '00e1F000001V8xmQAC';
            users.add(u);
        }
        when 'Moriarti' {
            u.profileid = '00e1F000001V8xmQAC';
            users.add(u);
        }
    }
}
update users;
*/

/*
List<List<Object>> cmdList = new List<List<Object>>();

Decimal donAmt = 15000.00;
String pickListVal = 'GalaTicketAt' + String.valueOf(Math.round(donAmt));
String fullName = 'Benefit_Setting' + '.' + pickListVal;
String label = pickListVal;

Decimal donAmt1 = 30000.00;
String pickListVal1 = 'GalaTicketAt' + String.valueOf(Math.round(donAmt1));
String fullName1 = 'Benefit_Setting' + '.' + pickListVal1;
String label1 = pickListVal1;

Map<String,Object> fieldWithValuesMap = new Map<String,Object>();
fieldWithValuesMap.put('Number__c', 2);
fieldWithValuesMap.put('DonationAmount__c', donAmt);
cmdList.add( new List<Object>{fullName, label, fieldWithValuesMap} );

Map<String,Object> fieldWithValuesMap1 = new Map<String,Object>();
fieldWithValuesMap1.put('Number__c', 2);
fieldWithValuesMap1.put('DonationAmount__c', donAmt1);
cmdList.add( new List<Object>{fullName1, label1, fieldWithValuesMap1} );

Id jobId = CreateUpdateMetadataUtils.createUpdateMetadata(cmdList);
system.debug(jobId);
*/
    Benefit_Setting__mdt[] BENEFIT_SETTINGS = CreateUpdateMetadataUtils.fetchBenefitSettings();  //Returns objs sorted ascending
    List<Benefit__c> addRecords = new List<Benefit__c>();

    Opportunity o = [SELECT Id, AccountId, OwnerId, Amount FROM Opportunity WHERE Name LIKE '%Test Opp%'];

        List<Benefit_Setting__mdt> issueBenefits = new List<Benefit_Setting__mdt>();

        Decimal amount = o.Amount;
        Decimal last = 0;

        for (Benefit_Setting__mdt bs : BENEFIT_SETTINGS) {
            if (amount >= bs.DonationAmount__c) {
                if ((amount - bs.DonationAmount__c) < (amount - last)) {
                    issueBenefits = new List<Benefit_Setting__mdt>();
                }
                issueBenefits.add(bs);
            }
            last = bs.DonationAmount__c;
        }

        for (Benefit_Setting__mdt bs : issueBenefits) {
            Integer count = (Integer) bs.Number__c;
            while (count > 0) {
                Benefit__c benefit = new Benefit__c(
                    Account__c = o.AccountId,
                    Name = bs.MasterLabel,
                    DollarAmount__c = bs.DollarValue__c,
                    Opportunity__c = o.Id,
                    OwnerId = o.OwnerId,
                    Type__c = bs.MasterLabel
                );
                addRecords.add(benefit);
                count -= 1;
            }
        }

system.debug(addRecords);