public class AccountHandler {
     public static void updating(List<Account> acclist){
        try{
            ContentVersion csvFile = [Select Id, Title, FileType, VersionData From ContentVersion
                                      Where Title = 'GeoNames - PT' limit 1];
            String data='';
            if(csvFile!=null){
                Blob fileData = csvFile.VersionData;
                data = fileData.toString();
            }
            for(Account acc : accList){
                if(acc.ShippingPostalCode !=null && data.contains(acc.ShippingPostalCode)){
                    System.debug('start');
                    Integer lastIndex=0;
                    Integer startingIndexofZip = data.indexOf(acc.ShippingPostalCode);
                    integer startIndex=0;
                    integer iteratorForComma=0;
                    for(Integer i=startingIndexofZip;i<data.length();i++){
                        if (data.charAt(i)==44){
                            if(iteratorForComma==0){
                                startIndex=i+1;
                            }
                            else if(iteratorForComma==2){
                                lastIndex=i-9;
                                break;
                            }
                            iteratorForComma++;
                        }}
                    System.debug('end');
                    
                    String cityState=data.substring(startindex,lastindex);
                    List<String> fetchingCityAndState=cityState.split(',');
                    System.debug(cityState);
                    acc.ShippingCity = fetchingCityAndState[0];
                    acc.ShippingState = fetchingCityAndState[1];
                }
            }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
}