# Faculty Load

> This script is the source of truth for all reports having to do with faculty load. 

<p style="color:#8c8c8c;font-size:small">
This query pulls all relevant information having to do with a faculty member's work load. Both instructional and non-instructional load is pulled. The script also pulls course information such as courses taught, amount of load given, number of student attending, days and times of course offering, etc. Classification for non-instructional load is also pulled. This query is used to compute load for compensation.
</p>

--- 

### Reports

- Faculty efficiency
- Workload calculator
- FTE Projection (currently using its own SQL query, but should be using this query)

<br>
<br>

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
      <th>Schema</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr class="odd">
      <td> instructor_banner_id </td>
      <td></td>
      <td></td>
    </tr>
    <tr class="even">
      <td> instructor_full name </td>
      <td></td>
      <td></td>
    </tr>
    <tr class="odd">
      <td> instructor_assignment_department </td>
      <td></td>
      <td></td>
    </tr>
    <tr class="even">
      <td> instructor_assignment_college </td>
      <td></td>
      <td></td>
    </tr>
    <tr class="odd">
      <td> instructor_assignment_status </td>
      <td></td>
      <td></td>
    </tr>
    <tr class="even">
      <td> instructor_assignment_rank </td>
      <td></td>
      <td></td>
    </tr>
    <tr class="odd">
      <td> instructor_assignment_workload </td>
      <td></td>
      <td></td>
    </tr>
    <tr class="even">
      <td> instructor_assignment_overload </td>
      <td></td>
      <td></td>
    </tr>
    <tr class="odd">
      <td>course_title</td>
      <td></td>
      <td></td>
    </tr>
    <tr class="even">
      <td>course_crn</td>
      <td></td>
      <td></td>
    </tr>
    <tr class="odd">
      <td>course_term_code</td>
      <td></td>
      <td></td>
    </tr>
    <tr class="even">
      <td>course_term</td>
      <td></td>
      <td></td>
    </tr>
    <tr class="odd">
      <td>course_academic_year</td>
      <td></td>
      <td></td>
    </tr>
    <tr class="even">
      <td>course_number</td>
      <td></td>
      <td></td>
    </tr>
    <tr class="odd">
      <td>course_section_number</td>
      <td></td>
      <td></td>
    </tr>
    <tr class="even">
      <td>course_division</td>
      <td></td>
      <td></td>
    </tr>
    <tr class="odd">
      <td>course_college</td>
      <td></td>
      <td></td>
    </tr>
    <tr class="even">
      <td>course_department</td>
      <td></td>
      <td></td>
    </tr>   
    <tr class="odd">
      <td>course_subject</td>
      <td></td>
      <td></td>
    </tr>
    <tr class="even">
      <td>course_student_count</td>
      <td></td>
      <td></td>
    </tr>   
    <tr class="odd">
      <td>course_maximum_enrollment</td>
      <td></td>
      <td></td>
    </tr>
    <tr class="even">
      <td>course_enrolled_credit_hours</td>
      <td></td>
      <td></td>
    </tr>      
     <tr class="odd">
      <td>course_fte</td>
      <td></td>
      <td></td>
    </tr>   
  </tbody>
</table>
