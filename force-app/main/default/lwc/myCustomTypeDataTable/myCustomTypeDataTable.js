import LightningDatatable from 'lightning/datatable';
import customPickListTemplate from "./customPicklist.html";
import customPickListEditTemplate from "./customPicklistEdit.html";

export default class MyCustomTypeDataTable extends LightningDatatable {
    
    static customTypes = {
        picklistColumn: {
            template: customPickListTemplate,
            editTemplate: customPickListEditTemplate,
            standardCellLayout: true,
            typeAttributes: ['label', 'placeholder', 'options', 'value', 'context', 'variant', 'name']
        }
    };

}