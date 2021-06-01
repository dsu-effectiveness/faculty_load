-- BEGIN original workload query logic
CASE WHEN ( a.sirasgn_fcnt_code IN ('AD', 'FT')
          AND k.perfasg_workload > k.perfasg_revised_workload
          AND k.perfasg_revised_workload = 0 )
   THEN k.perfasg_workload
   WHEN ( k.perfasg_revised_workload > 0
          AND k.perfasg_workload > k.perfasg_revised_workload )
   THEN k.perfasg_revised_workload
END AS assignment_workload_previous,
-- END original workload query logic

-- BEGIN original overload query logic
CASE WHEN e.nbrbjob_contract_type IS NULL THEN NULL
   WHEN e.nbrbjob_contract_type = 'O' THEN 1
   ELSE 0
END AS overload_indicator,
-- END original overload query logic


/*
      -- this part may not be necessary for tenure status calculation
      AND h.perappt_begin_date = (SELECT MAX(h1.perappt_begin_date)
                                    FROM payroll.perappt h1
                                   WHERE h.perappt_pidm = h1.perappt_pidm
                                     AND h1.perappt_begin_date < d.stvterm_end_date)
 */

-- pull job info on faculty assignment (could probably be removed on next iteration)
LEFT JOIN posnctl.nbrbjob e
       ON e.nbrbjob_pidm = a.sirasgn_pidm
      AND e.nbrbjob_posn = a.sirasgn_posn
      AND e.nbrbjob_suff = a.sirasgn_suff
      AND e.nbrbjob_begin_date = (SELECT MAX(e1.nbrbjob_begin_date)
                                    FROM posnctl.nbrbjob e1
                                   WHERE e.nbrbjob_pidm = e1.nbrbjob_pidm
                                     AND e.nbrbjob_posn = e1.nbrbjob_posn
                                     AND e.nbrbjob_suff = e1.nbrbjob_suff
                                     -- limit on the max for historical records
                                     AND e1.nbrbjob_begin_date < d.stvterm_end_date)

-- pull job info on faculty assignment (could probably be removed on next iteration)
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