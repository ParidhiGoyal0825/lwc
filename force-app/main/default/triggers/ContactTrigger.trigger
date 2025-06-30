trigger ContactTrigger on Contact (after update) {
    if(Trigger.isUpdate){
        if(Trigger.isAfter){
            ContactHandler.updateAmount(Trigger.New, Trigger.oldMap);
        }
    }
}