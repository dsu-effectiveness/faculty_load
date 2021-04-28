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