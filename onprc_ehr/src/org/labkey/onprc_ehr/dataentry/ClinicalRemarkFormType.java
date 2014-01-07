/*
 * Copyright (c) 2013 LabKey Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.labkey.onprc_ehr.dataentry;

import org.labkey.api.ehr.EHRService;
import org.labkey.api.ehr.dataentry.AnimalDetailsFormSection;
import org.labkey.api.ehr.dataentry.DataEntryFormContext;
import org.labkey.api.ehr.dataentry.FormSection;
import org.labkey.api.ehr.dataentry.TaskForm;
import org.labkey.api.ehr.dataentry.TaskFormSection;
import org.labkey.api.module.Module;
import org.labkey.api.view.template.ClientDependency;

import java.util.Arrays;

/**
 * User: bimber
 * Date: 7/29/13
 * Time: 5:03 PM
 */
public class ClinicalRemarkFormType extends TaskForm
{
    public static final String NAME = "Clinical Remarks";

    public ClinicalRemarkFormType(DataEntryFormContext ctx, Module owner)
    {
        super(ctx, owner, NAME, "Bulk Clinical Entry", "Clinical", Arrays.<FormSection>asList(
                new TaskFormSection(),
                new AnimalDetailsFormSection(),
                new SimpleGridPanel("study", "Clinical Remarks", "SOAPs"),
                new SimpleGridPanel("study", "encounters", "Procedures"),
                new ClinicalObservationsFormSection(EHRService.FORM_SECTION_LOCATION.Body),
                new DrugAdministrationFormSection(),
                new TreatmentOrdersFormSection(),
                new WeightFormSection(),
                new SimpleGridPanel("study", "blood", "Blood Draws"),
                new SimpleGridPanel("ehr", "snomed_tags", "Diagnostic Codes")
        ));

        for (FormSection s : this.getFormSections())
        {
            s.addConfigSource("ClinicalDefaults");
        }

        addClientDependency(ClientDependency.fromFilePath("ehr/model/sources/ClinicalDefaults.js"));
    }
}
