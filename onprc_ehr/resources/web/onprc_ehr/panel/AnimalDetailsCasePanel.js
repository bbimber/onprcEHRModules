/*
 * Copyright (c) 2016-2017 LabKey Corporation
 *
 * Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
 * 
 * @param subjectId
 */

//Created 5-9-2016 R.Blasa

Ext4.define('onprc_ehr.panel.AnimalDetailsCasePanel', {
    extend: 'EHR.panel.SnapshotPanel',
    alias: 'widget.onprc_ehr-animaldetailspanel',

    border: true,
    showExtendedInformation: false,
    showActionsButton: false,
    doSuspendLayouts: false,
    showDisableButton: true,

    initComponent: function(){
        Ext4.apply(this, {
            border: true,
            bodyStyle: 'padding: 5px;',
            minHeight: 285,
            defaults: {
                border: false
            }
        });

        this.callParent(arguments);

        if (this.dataEntryPanel){
            this.mon(this.dataEntryPanel, 'animalchange', this.onAnimalChange, this, {buffer: 500});
        }

        this.mon(EHR.DemographicsCache, 'cachechange', this.demographicsListener, this);
    },

    demographicsListener: function(animalId){
        if (this.isDestroyed){
            console.log('is destroyed');
            return;
        }

        if (animalId == this.subjectId){
            this.loadAnimal(animalId, true);
        }
    },

    onAnimalChange: function(animalId){
        //the intent of this is to avoid querying partial strings as the user types
        if (animalId && animalId.length < 4){
            animalId = null;
        }

        this.loadAnimal(animalId);
    },

    loadAnimal: function(animalId, forceReload){
        if (!forceReload && animalId == this.subjectId){
            return;
        }

        this.subjectId = animalId;

        if (animalId)
            EHR.DemographicsCache.getDemographics([this.subjectId], this.onLoad, this, (forceReload ? 0 : -1));
        else
            this.getForm().reset();
    },

    onLoad: function(ids, resultMap){
        if (ids && ids.length && ids[0] != this.subjectId){
            return;
        }

        this.callParent(arguments);
    },

    getItems: function(){
        return [{
            itemId: 'columnSection',
            layout: 'column',
            defaults: {
                border: false,
                bodyStyle: 'padding-right: 20px;'
            },
            items: [{
                xtype: 'container',
                width: 380,
                defaults: {
                    xtype: 'displayfield',
                    labelWidth: this.defaultLabelWidth
                },
                items: [{
                    fieldLabel: 'Id',
                    name: 'animalId'
                },{
                    fieldLabel: 'Location',
                    name: 'location'
                },{
                    fieldLabel: 'Gender',
                    name: 'gender'
                },{
                    fieldLabel: 'Species',
                    name: 'species'
                },{
                    fieldLabel: 'Age',
                    name: 'age'
                },{
                    xtype: 'displayfield',
                    fieldLabel: 'Source',
                    name: 'source'
                },{
                    fieldLabel: 'Projects / Groups',
                    name: 'assignmentsAndGroups'
                },{
                    xtype: 'displayfield',
                    fieldLabel: 'Active Cases',
                    name: 'activeCases'
                }]
            },{
                xtype: 'container',
                width: 350,
                defaults: {
                    xtype: 'displayfield'
                },
                items: [{
                    fieldLabel: 'Status',
                    name: 'calculated_status'
                },{
                    fieldLabel: 'Flags',
                    name: 'flags'
                },{
                    fieldLabel: 'Weight',
                    name: 'weights'
                },{
                    xtype: 'ldk-linkbutton',
                    style: 'margin-top: 10px;',
                    scope: this,
                    text: '[Show Full Hx]',
                    handler: function(){
                        if (this.subjectId){
                            EHR.window.ClinicalHistoryWindow.showClinicalHistory(null, this.subjectId, null);
                        }
                        else {
                            console.log('no id');
                        }
                    }
                },{
                    xtype: 'ldk-linkbutton',
                    style: 'margin-top: 5px;',
                    scope: this,
                    text: '[Show Recent SOAPs]',
                    handler: function(){
                        if (this.subjectId){
                            EHR.window.RecentRemarksWindow.showRecentRemarks(this.subjectId);
                        }
                        else {
                            console.log('no id');
                        }
                    }
                },{
                    xtype: 'ldk-linkbutton',
                    style: 'margin-top: 5px;',
                    scope: this,
                    text: '[Manage Treatments]',
                    hidden: EHR.Security.hasClinicalEntryPermission() && !EHR.Security.hasPermission(EHR.QCStates.COMPLETED, 'update', [{schemaName: 'study', queryName: 'Treatment Orders'}]),
                    handler: function(){
                        if (this.subjectId){
                            Ext4.create('onprc_ehr.window.ManageTreatmentsWindow', {animalId: this.subjectId}).show();
                        }
                        else {
                            console.log('no id');
                        }
                    }
                },{
                    xtype: 'ldk-linkbutton',
                    style: 'margin-top: 5px;margin-bottom:10px;',
                    scope: this,
                    text: '[Manage Cases]',
                    hidden: EHR.Security.hasClinicalEntryPermission() && !EHR.Security.hasPermission(EHR.QCStates.COMPLETED, 'update', [{schemaName: 'study', queryName: 'Cases'}]),
                    handler: function(){
                        if (this.subjectId){
                            Ext4.create('EHR.window.ManageCasesWindow', {animalId: this.subjectId}).show();
                        }
                        else {
                            console.log('no id');
                        }
                    }
                }]
            }]
        },{
            layout: 'hbox',
            style: 'padding-top: 10px;',
            items: [{
                xtype: 'button',
                border: true,
                text: 'Reload',
                scope: this,
                handler: function(btn){
                    this.loadAnimal(this.subjectId, true);
                }
            },{
                xtype: 'button',
                hidden: !this.showDisableButton,
                border: true,
                text: 'Disable',
                style: 'margin-left: 10px;',
                scope: this,
                handler: function(btn){
                    this.disableAnimalLoad = btn.getText() == 'Disable';

                    btn.setText(this.disableAnimalLoad ? 'Enable' : 'Disable');
                    this.down('#columnSection').setDisabled(this.disableAnimalLoad);
                }
            }]
        }];
    },

    appendWeightResults: function(toSet, results){
        var text;
        if (results && results.length){
            var row = results[0];
            var date = LDK.ConvertUtils.parseDate(row.date);
            var interval = '';
            if (date){
                //round to day for purpose of this comparison
                var d1 = Ext4.Date.clearTime(new Date(), true);
                var d2 = Ext4.Date.clearTime(date, true);
                interval = Ext4.Date.getElapsed(d1, d2);
                interval = interval / (1000 * 60 * 60 * 24);
                interval = Math.floor(interval);
                interval = interval + ' days ago';
            }

            text = row.weight + ' kg, ' + Ext4.Date.format(date, 'Y-m-d') + (!Ext4.isEmpty(interval) ? ' (' + interval + ')' : '');
        }

        toSet['weights'] = text;
    },

    appendAssignmentsAndGroups: function(toSet, record){
        toSet['assignmentsAndGroups'] = null;

        if (this.redacted)
            return;

        var values = [];
        if (record.getActiveAssignments() && record.getActiveAssignments().length){
            Ext4.each(record.getActiveAssignments(), function(row){
                var val = row['project/investigatorId/lastName'] || '';
                val += ' [' + row['project/displayName'] + ']';

                if (val)
                    values.push(val);
            }, this);
        }

        if (record.getActiveAnimalGroups() && record.getActiveAnimalGroups().length){
            Ext4.each(record.getActiveAnimalGroups(), function(row){
                values.push(row['groupId/name']);
            }, this);
        }

        toSet['assignmentsAndGroups'] = values.length ? values.join('<br>') :  null;
    } ,
    //Added 4-28-2016 R.Blasa
    appendCases: function(toSet, results){
        var values = [];
        if (results){
            Ext4.each(results, function(row){
                var text = row.category;
                if (text){
                    //NOTE: this may have been cached in the past, so verify whether this is really still active
                    var date = LDK.ConvertUtils.parseDate(row.date);
                    var enddate = row.enddate ? LDK.ConvertUtils.parseDate(row.enddate) : null;
                    if (date && (!enddate || enddate.getTime() > (new Date()).getTime())){
                        var reviewdate = row.reviewdate ? LDK.ConvertUtils.parseDate(row.reviewdate) : null;
                        if (!reviewdate || Ext4.Date.clearTime(reviewdate).getTime() <= Ext4.Date.clearTime(new Date()).getTime()){
                            text = text + ' (' + Ext4.Date.format(date, 'Y-m-d') + ')';

                            values.push(text);
                        }
                        else if (reviewdate && Ext4.Date.clearTime(reviewdate).getTime() > Ext4.Date.clearTime(new Date()).getTime()){
                            text = text + ' - None (Reopens: '  + Ext4.Date.format(reviewdate, 'Y-m-d') + ')';
                            values.push(text);
                        }
                    }
                }
            }, this);
        }

        toSet['activeCases'] = values.length ? values.join(',<br>') : 'None';
    }
});