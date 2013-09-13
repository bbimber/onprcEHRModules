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
SELECT
  p.Id,
  (SELECT group_concat(distinct p2.Id, chr(10)) FROM study.pairings p2 WHERE p.Id != p2.id AND p.date = p2.date and p.room = p2.room and p.pairId = p2.pairId) as otherIds,
  p.date,
  p.eventType,
  p.housingType,
  p.observation,
  p.outcome,
  p.remark

FROM study.pairings p
