# Faculty Load

> This script is the source of truth for all reports having to do with faculty load. 

<p style="color:#8c8c8c;font-size:small">
This query pulls all relevant information having to do with a faculty member's work load. Both instructional and non-instructional load is pulled. The script also pulls course information such as courses taught, amount of load given, number of student attending, days and times of course offering, etc. Classification for non-instructional load is also pulled. This query is used to compute load for compensation.
</p>

--- 

### Reports

- Faculty efficiency
- Workload calculator
- 

<br><br>

### Table description
<table>
<colgroup>
<col style="width: 15%" />
<col style="width: 15% />
<col style="width: 70%" />

</colgroup>
<thead>
<tr class="header">
<th>Field</th>
<th>Source</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td> D-number </td>
<td>spriden</td>
<td></td>
</tr>
<tr class="even">
<td>First name</td>
<td>spriden</td>
<td></td>
</tr>
<tr class="odd">
<td>Last Name</td>
<td>spriden</td>
<td></td>
</tr>
<tr class="even">
<td>Instructor Status</td>
<td>ptrtenr, ptrecls</td>
<td>Tenured, tenure-track, non-tenure-track, part-time faculty, adjunct</td>
</tr>
<tr class="odd">
<td>percent responsibility</td>
<td>perfasg</td>
<td></td>
</tr>
<tr class="even">
<td>overload indicator</td>
<td>nbrbjob</td>
<td></td>
</tr>
<tr class="odd">
<td>term code</td>
<td>sirasgn</td>
<td></td>
</tr>
<tr class="even">
<td>course record number</td>
<td>sirasgn</td>
<td></td>
</tr>
<tr class="odd">
<td>course number</td>
<td>sirasgn</td>
<td></td>
</tr>
<tr class="even">
<td>crn</td>
<td>sirasgn</td>
<td>course record number</td>
</tr>
<tr class="odd">
<td>section number</td>
<td>sirasgn</td>
<td>
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
</td>
</tr>
<tr class="even">
<td>course title</td>
<td>sirasgn</td>
<td></td>
</tr>
<tr class="odd">
<td>college</td>
<td>scbcrse</td>
<td></td>
</tr>
<tr class="even">
<td>department</td>
<td>scbcrse</td>
<td></td>
</tr>
<tr class="odd">
<td>student count</td>
<td>ssbsect</td>
<td></td>
</tr>
<tr class="even">
<td>total enrolled hours</td>
<td>ssbsect</td>
<td></td>
</tr>
</tbody>
</table>
