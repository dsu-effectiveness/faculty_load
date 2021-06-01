   SELECT b.spriden_id AS instructor_banner_id,
          b.spriden_first_name || ', ' ||  b.spriden_last_name AS instructor_full_name,
          COALESCE(p.stvdept_desc, 'Unavailable') AS instructor_assignment_department,
          CASE WHEN q.stvcoll_desc = 'Global & Community Outreach' THEN q.stvcoll_desc
               WHEN q.stvcoll_desc = 'Library & Learning Services' THEN q.stvcoll_desc
               WHEN q.stvcoll_statscan_cde3 = 'CHSS' THEN 'CHASS'
               WHEN q.stvcoll_statscan_cde3 = 'COST' THEN 'CSET'
               WHEN q.stvcoll_statscan_cde3 = 'COTA' THEN 'COA'
               WHEN q.stvcoll_statscan_cde3 is NULL THEN 'Unavailable'
               ELSE q.stvcoll_statscan_cde3
          END AS instructor_assignment_college,
          CASE WHEN i.ptrtenr_code IN ('T', 'O') THEN i.ptrtenr_desc
               ELSE g.ptrecls_long_desc
          END AS instructor_assignment_status,
          s.stvfctg_desc AS instructor_assignment_rank,
          -- BEGIN revised workload query logic
          CASE WHEN ( k.perfasg_workload != k.perfasg_revised_workload
                      AND k.perfasg_revised_workload IS NOT NULL )
               THEN k.perfasg_revised_workload
               ELSE k.perfasg_workload
          END AS instructor_assignment_workload,
          -- END revised workload query logic
          -- BEGIN revised overload query logic
          CASE WHEN k.perfasg_workload > k.perfasg_revised_workload
               THEN (k.perfasg_workload - k.perfasg_revised_workload)
               ELSE 0
          END AS instructor_assignment_overload,
          -- END revised overload query logic
          j.scbcrse_title AS course_title,
          a.sirasgn_crn AS course_crn,
          a.sirasgn_term_code AS course_term_code,
          d.stvterm_desc AS course_term,
          d.stvterm_acyr_code AS course_academic_year,
          c.ssbsect_crse_numb AS course_number,
          c.ssbsect_seq_numb AS course_section_number,
          CASE SUBSTR(c.ssbsect_crse_numb, 1, 1)
               WHEN '0' THEN 'Remedial'
               WHEN '1' THEN 'Lower'
               WHEN '2' THEN 'Lower'
               WHEN '3' THEN 'Upper'
               WHEN '4' THEN 'Upper'
               WHEN '5' THEN 'Advanced Upper'
               WHEN '6' THEN 'Graduate'
               WHEN '7' THEN 'Graduate'
          END AS course_division,
          CASE WHEN l.stvcoll_desc = 'Global & Community Outreach' THEN l.stvcoll_desc
               WHEN l.stvcoll_desc = 'Library & Learning Services' THEN l.stvcoll_desc
               WHEN l.stvcoll_statscan_cde3 = 'CHSS' THEN 'CHASS'
               WHEN l.stvcoll_statscan_cde3 = 'COST' THEN 'CSET'
               WHEN l.stvcoll_statscan_cde3 = 'COTA' THEN 'COA'
               ELSE l.stvcoll_statscan_cde3
          END AS course_college,
          m.stvdept_desc AS course_department,
          n.stvsubj_desc AS course_subject,
          c.ssbsect_enrl AS course_student_count,
          c.ssbsect_max_enrl AS course_maximum_enrollment,
          c.ssbsect_tot_credit_hrs AS course_enrolled_credit_hours,
          ROUND(c.ssbsect_tot_credit_hrs/12) AS course_fte
-- pull from "Faculty Member Instructional Assignment Repeating Table"
     FROM saturn.sirasgn a
-- BEGIN JOINS
-- pull faculty info
LEFT JOIN saturn.spriden b
       ON b.spriden_pidm = a.sirasgn_pidm
      AND b.spriden_change_ind IS NULL
-- pull course section info
LEFT JOIN saturn.ssbsect c
       ON a.sirasgn_term_code = c.ssbsect_term_code
      AND a.sirasgn_crn = c.ssbsect_crn
-- pull term info on course assignment
LEFT JOIN saturn.stvterm d
       ON d.stvterm_code = a.sirasgn_term_code
-- pull job info on faculty assignment
LEFT JOIN posnctl.nbrjobs  f
       ON f.nbrjobs_pidm = a.sirasgn_pidm
      AND f.nbrjobs_posn = a.sirasgn_posn
      AND f.nbrjobs_suff = a.sirasgn_suff
      AND f.nbrjobs_effective_date = (SELECT MAX(f1.nbrjobs_effective_date)
                                        FROM posnctl.nbrjobs f1
                                       WHERE f.nbrjobs_pidm = f1.nbrjobs_pidm
                                         AND f.nbrjobs_posn = f1.nbrjobs_posn
                                         AND f.nbrjobs_suff = f1.nbrjobs_suff
                                         -- limit on the max for historical records
                                         AND f1.nbrjobs_effective_date < d.stvterm_end_date)
LEFT JOIN payroll.ptrecls g
       ON f.nbrjobs_ecls_code = g.ptrecls_code
-- pull tenure status info
LEFT JOIN payroll.perappt h
       ON h.perappt_pidm = a.sirasgn_pidm
      -- The logic here is determined
      -- by the time-line of determining tenure status per appointment.
      -- This could change depending on confirmation.
      AND h.perappt_appt_eff_date = (SELECT MAX(h1.perappt_appt_eff_date)
                                       FROM payroll.perappt h1
                                      WHERE h.perappt_pidm = h1.perappt_pidm
                                        -- limit on the max for historical records
                                        AND h1.perappt_appt_eff_date < d.stvterm_end_date)
LEFT JOIN payroll.ptrtenr i
       ON i.ptrtenr_code = h.perappt_tenure_code
-- pull faculty workload info
LEFT JOIN payroll.perfasg k
       ON k.perfasg_pidm = a.sirasgn_pidm
      AND k.perfasg_posn = a.sirasgn_posn
      AND k.perfasg_suff = a.sirasgn_suff
      AND k.perfasg_crn = a.sirasgn_crn
      AND k.perfasg_term_code = a.sirasgn_term_code
-- pull course related info
LEFT JOIN saturn.scbcrse j
       ON j.scbcrse_crse_numb = c.ssbsect_crse_numb
      AND j.scbcrse_subj_code = c.ssbsect_subj_code
      AND j.scbcrse_eff_term = (SELECT MAX(j1.scbcrse_eff_term)
                                  FROM saturn.scbcrse j1
                                 WHERE j.scbcrse_crse_numb = j1.scbcrse_crse_numb
                                   AND j.scbcrse_subj_code = j1.scbcrse_subj_code
                                   -- limit on the max for historical records
                                   AND j1.scbcrse_eff_term <= d.stvterm_code)
LEFT JOIN saturn.stvcoll l
       ON l.stvcoll_code = j.scbcrse_coll_code
LEFT JOIN saturn.stvdept m
       ON m.stvdept_code = j.scbcrse_dept_code
LEFT JOIN saturn.stvsubj n
       ON c.ssbsect_subj_code = n.stvsubj_code
-- pull faculty college and department info
LEFT JOIN saturn.sirdpcl o
       ON a.sirasgn_pidm = o.sirdpcl_pidm
      AND o.sirdpcl_term_code_eff = (SELECT MAX(o1.sirdpcl_term_code_eff)
                                     FROM saturn.sirdpcl o1
                                    WHERE o1.sirdpcl_pidm = o.sirdpcl_pidm
                                      -- limit on the max for historical records
                                      AND o1.sirdpcl_term_code_eff <= d.stvterm_code)
LEFT JOIN saturn.stvdept p
       ON p.stvdept_code = o.sirdpcl_dept_code
LEFT JOIN saturn.stvcoll q
       ON q.stvcoll_code = o.sirdpcl_coll_code
-- pull instructor rank info
LEFT JOIN saturn.sibinst r
       ON a.sirasgn_pidm = r.sibinst_pidm
      ANd r.sibinst_term_code_eff = ( SELECT MAX(r2.sibinst_term_code_eff)
                                         FROM saturn.sibinst r2
                                        WHERE r2.sibinst_pidm = r.sibinst_pidm
                                          -- limit on the max for historical records
                                          AND r2.sibinst_term_code_eff <= d.stvterm_code )
LEFT JOIN saturn.stvfctg s
       ON s.stvfctg_code = r.sibinst_fctg_code
-- END JOINS
    WHERE a.sirasgn_posn IS NOT NULL
      AND a.sirasgn_suff IS NOT NULL
      -- filter out non-compensated positions
      AND a.sirasgn_posn NOT LIKE 'GNC%'
      -- filter out faculty assignments with no students
      AND c.ssbsect_enrl > 0;
