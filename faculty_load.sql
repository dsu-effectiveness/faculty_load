   SELECT b.spriden_id AS banner_id,
          b.spriden_first_name AS first_name,
          b.spriden_last_name AS last_name,
          p.stvdept_desc AS instructor_department,
          q.stvcoll_desc AS instructor_college,
          CASE WHEN q.stvcoll_desc = 'Global & Community Outreach' THEN q.stvcoll_desc
               WHEN q.stvcoll_desc = 'Library & Learning Services' THEN q.stvcoll_desc
               WHEN q.stvcoll_statscan_cde3 = 'CHSS' THEN 'CHASS'
               WHEN q.stvcoll_statscan_cde3 = 'COST' THEN 'CSET'
               WHEN q.stvcoll_statscan_cde3 = 'COTA' THEN 'COA'
               ELSE q.stvcoll_statscan_cde3
          END AS instructor_college_abbreviation,
          CASE WHEN i.ptrtenr_code IN ('T', 'O') THEN i.ptrtenr_desc
               ELSE g.ptrecls_long_desc
          END AS instructor_status,
          s.stvfctg_desc AS instructor_rank,
          -- BEGIN original workload query logic
          CASE WHEN ( a.sirasgn_fcnt_code IN ('AD', 'FT')
                      AND k.perfasg_workload > k.perfasg_revised_workload
                      AND k.perfasg_revised_workload = 0 )
               THEN k.perfasg_workload
               WHEN ( k.perfasg_revised_workload > 0
                      AND k.perfasg_workload > k.perfasg_revised_workload )
               THEN k.perfasg_revised_workload
               ELSE NULL
          END AS assignment_workload_previous,
          -- END original workload query logic
           -- BEGIN revised workload query logic
          CASE WHEN ( k.perfasg_workload != k.perfasg_revised_workload
                      AND k.perfasg_revised_workload IS NOT NULL )
               THEN k.perfasg_revised_workload
               ELSE k.perfasg_workload
          END AS assignment_workload,
          -- END revised workload query logic
          -- BEGIN original overload query logic
          CASE WHEN e.nbrbjob_contract_type IS NULL THEN NULL
               WHEN e.nbrbjob_contract_type = 'O' THEN 1
               ELSE 0
          END AS overload_indicator,
          -- END original overload query logic
           -- BEGIN revised overload query logic
          CASE WHEN k.perfasg_workload > k.perfasg_revised_workload
               THEN (k.perfasg_workload - k.perfasg_revised_workload)
               ELSE 0
          END AS assignment_overload_amount,
          -- END revised overload query logic
          d.stvterm_desc AS term,
          d.stvterm_acyr_code AS academic_year,
          a.sirasgn_crn AS crn,
          c.ssbsect_crse_numb AS course_number,
          c.ssbsect_seq_numb AS section_number,
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
          j.scbcrse_title AS course_title,
          l.stvcoll_desc AS college,
          CASE WHEN l.stvcoll_desc = 'Global & Community Outreach' THEN l.stvcoll_desc
               WHEN l.stvcoll_desc = 'Library & Learning Services' THEN l.stvcoll_desc
               WHEN l.stvcoll_statscan_cde3 = 'CHSS' THEN 'CHASS'
               WHEN l.stvcoll_statscan_cde3 = 'COST' THEN 'CSET'
               WHEN l.stvcoll_statscan_cde3 = 'COTA' THEN 'COA'
               ELSE l.stvcoll_statscan_cde3
          END AS college_abbreviation,
          m.stvdept_desc AS department,
          n.stvsubj_desc AS subject,
          c.ssbsect_enrl AS student_count,
          c.ssbsect_max_enrl AS maximum_enrollment,
          c.ssbsect_tot_credit_hrs AS total_enrolled_credit_hours
     FROM saturn.sirasgn a
-- BEGIN JOINS
LEFT JOIN saturn.spriden b
       ON b.spriden_pidm = a.sirasgn_pidm
      AND b.spriden_change_ind IS NULL
LEFT JOIN saturn.ssbsect c
       ON a.sirasgn_term_code = c.ssbsect_term_code
      AND a.sirasgn_crn = c.ssbsect_crn
LEFT JOIN saturn.stvterm d
       ON d.stvterm_code = a.sirasgn_term_code
LEFT JOIN posnctl.nbrbjob e
       ON e.nbrbjob_pidm = a.sirasgn_pidm
      AND e.nbrbjob_posn = a.sirasgn_posn
      AND e.nbrbjob_suff = a.sirasgn_suff
      AND e.nbrbjob_begin_date = (SELECT MAX(e1.nbrbjob_begin_date)
                                    FROM posnctl.nbrbjob e1
                                   WHERE e.nbrbjob_pidm = e1.nbrbjob_pidm
                                     AND e.nbrbjob_posn = e1.nbrbjob_posn
                                     AND e.nbrbjob_suff = e1.nbrbjob_suff
                                     AND e1.nbrbjob_begin_date < d.stvterm_end_date)

LEFT JOIN posnctl.nbrjobs  f
       ON f.nbrjobs_pidm = e.nbrbjob_pidm
      AND f.nbrjobs_posn = e.nbrbjob_posn
      AND f.nbrjobs_suff = e.nbrbjob_suff
      AND f.nbrjobs_effective_date = (SELECT MAX(f1.nbrjobs_effective_date)
                                        FROM posnctl.nbrjobs f1
                                       WHERE f.nbrjobs_pidm = f1.nbrjobs_pidm
                                         AND f.nbrjobs_posn = f1.nbrjobs_posn
                                         AND f.nbrjobs_suff = f1.nbrjobs_suff)
LEFT JOIN payroll.ptrecls g
       ON f.nbrjobs_ecls_code = g.ptrecls_code

LEFT JOIN payroll.perappt h
       ON h.perappt_pidm = a.sirasgn_pidm
/*
      -- this part may not be necessary for tenure status calculation
      AND h.perappt_begin_date = (SELECT MAX(h1.perappt_begin_date)
                                    FROM payroll.perappt h1
                                   WHERE h.perappt_pidm = h1.perappt_pidm
                                     AND h1.perappt_begin_date < d.stvterm_end_date)
 */
      AND h.perappt_appt_eff_date = (SELECT MAX(h1.perappt_appt_eff_date)
                                       FROM payroll.perappt h1
                                      WHERE h.perappt_pidm = h1.perappt_pidm
                                        -- The logic here is determined
                                        -- by the time-line of determining tenure status per appointment.
                                        -- This could change depending on confirmation.
                                        AND h1.perappt_appt_eff_date < d.stvterm_end_date)
LEFT JOIN payroll.ptrtenr i
       ON i.ptrtenr_code = h.perappt_tenure_code

LEFT JOIN saturn.scbcrse j
       ON j.scbcrse_crse_numb = c.ssbsect_crse_numb
      AND j.scbcrse_subj_code = c.ssbsect_subj_code
      AND j.scbcrse_eff_term = (SELECT MAX(j1.scbcrse_eff_term)
                                  FROM saturn.scbcrse j1
                                 WHERE j.scbcrse_crse_numb = j1.scbcrse_crse_numb
                                   AND j.scbcrse_subj_code = j1.scbcrse_subj_code
                                   AND j1.scbcrse_eff_term <= d.stvterm_code)
LEFT JOIN payroll.perfasg k
       ON k.perfasg_pidm = a.sirasgn_pidm
      AND k.perfasg_posn = a.sirasgn_posn
      AND k.perfasg_suff = a.sirasgn_suff
      AND k.perfasg_crn = a.sirasgn_crn
      AND k.perfasg_term_code = a.sirasgn_term_code
LEFT JOIN saturn.stvcoll l
       ON l.stvcoll_code = j.scbcrse_coll_code
LEFT JOIN saturn.stvdept m
       ON m.stvdept_code = j.scbcrse_dept_code
LEFT JOIN saturn.stvsubj n
       ON c.ssbsect_subj_code = n.stvsubj_code

LEFT JOIN saturn.sirdpcl o
       ON a.sirasgn_pidm = o.sirdpcl_pidm
      AND o.sirdpcl_term_code_eff = (SELECT MAX(o1.sirdpcl_term_code_eff)
                                     FROM saturn.sirdpcl o1
                                    WHERE o1.sirdpcl_pidm = o.sirdpcl_pidm
                                      AND o1.sirdpcl_term_code_eff <= d.stvterm_code)
LEFT JOIN saturn.stvdept p
       ON p.stvdept_code = o.sirdpcl_dept_code
LEFT JOIN saturn.stvcoll q
       ON q.stvcoll_code = o.sirdpcl_coll_code

LEFT JOIN saturn.sibinst r
       ON a.sirasgn_pidm = r.sibinst_pidm
      AND r.sibinst_term_code_eff = (SELECT MAX(r1.sibinst_term_code_eff)
                                       FROM saturn.sibinst r1
                                      WHERE r1.sibinst_pidm = r.sibinst_pidm
                                        AND r1.sibinst_term_code_eff <= d.stvterm_code)
LEFT JOIN saturn.stvfctg s
       ON s.stvfctg_code = r.sibinst_fctg_code

-- END JOINS

    WHERE a.sirasgn_posn IS NOT NULL
      AND a.sirasgn_suff IS NOT NULL
      -- filter out non-compensated positions
      AND a.sirasgn_posn NOT LIKE 'GNC%'
      -- filter out faculty assignments with no students
      AND c.ssbsect_enrl > 0
   AND b.spriden_id = '00284560'
 ORDER BY a.sirasgn_pidm,
             a.sirasgn_term_code,
             a.sirasgn_crn;