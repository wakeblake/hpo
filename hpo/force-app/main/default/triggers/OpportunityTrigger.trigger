trigger OpportunityTrigger on Opportunity (after insert, after update) {
    
    Benefit_Setting__mdt[] BENEFIT_SETTINGS = CreateUpdateMetadataUtils.fetchBenefitSettings();  //Returns objs sorted ascending
    List<Benefit__c> addRecords = new List<Benefit__c>();

    Map<Id,Opportunity> oMap = Trigger.oldMap;
    Map<Id,Opportunity> nMap = Trigger.newMap;

    if (Trigger.isUpdate) {
        for (Opportunity o : Trigger.new) {
            if ( (oMap.get(o.Id).StageName != 'Closed Won') && (o.StageName == 'Closed Won') ) {
                if (o.StageName == 'Closed Won') {
                    // TODO move to helper class

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

                    if (!addRecords.isEmpty()) {
                        upsert addRecords;
                    }

                    system.debug(addRecords);
                } 
            }
        }

    } else {
        for (Opportunity o : Trigger.new) {
            if (o.StageName == 'Closed Won') {
                // TODO move to helper class

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

                if (!addRecords.isEmpty()) {
                    update addRecords;
                }

                system.debug(addRecords);
            }
        }
    }
}