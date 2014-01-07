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
import org.labkey.api.view.template.ClientDependency;

import java.util.List;

/**
 * User: bimber
 * Date: 7/7/13
 * Time: 10:36 AM
 */
public class BloodDrawFormSection extends SimpleGridPanel
{
    boolean _showAddScheduledBtn;

    public BloodDrawFormSection(boolean showAddScheduledBtn)
    {
        this(showAddScheduledBtn, EHRService.FORM_SECTION_LOCATION.Body);
    }

    public BloodDrawFormSection(boolean showAddScheduledBtn, EHRService.FORM_SECTION_LOCATION location)
    {
        super("study", "blood", "Blood Draws", location);
        setClientStoreClass("EHR.data.BloodDrawClientStore");
        addClientDependency(ClientDependency.fromFilePath("ehr/window/AddScheduledBloodDrawsWindow.js"));
        addClientDependency(ClientDependency.fromFilePath("ehr/data/BloodDrawClientStore.js"));
        _showAddScheduledBtn = showAddScheduledBtn;
    }

    @Override
    public List<String> getTbarButtons()
    {
        List<String> defaultButtons = super.getTbarButtons();

        if (_showAddScheduledBtn)
            defaultButtons.add(0, "ADDBLOODDRAWS");

        return defaultButtons;
    }
}
