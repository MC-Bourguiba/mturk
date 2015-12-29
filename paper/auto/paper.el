(TeX-add-style-hook
 "paper"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("algorithmic" "noend")))
   (TeX-run-style-hooks
    "latex2e"
    "latex_commands"
    "sig-alternate-ipsn13"
    "sig-alternate-ipsn1310"
    "ntheorem"
    "algorithm"
    "algorithmic"
    "todonotes"
    "enumitem")
   (LaTeX-add-labels
    "sec:model"
    "sec:routing_game"
    "prop:potential"
    "sec:learning"
    "eq:MD_update"
    "alg:MD"
    "thm:convergence"
    "sec:estimation"
    "eq:MD_update_estimation"
    "eq:estimation_eta"
    "eq:hedge_solution"
    "eq:estimation_alpha_eta0"
    "subsec:reg_entropy"
    "eq:propagation"
    "fig:game_interface"
    "sec:experiment"
    "fig:system_block_diagram"
    "fig:global_potential"
    "sec:results"
    "fig:estimated_distributions"
    "fig:moving_average_learning_rate"
    "fig:sequence_rate"
    "fig:predictions_divergence"
    "sec:conclusion")
   (LaTeX-add-environments
    "remark"
    "theorem"
    "definition"
    "proposition")
   (LaTeX-add-bibliographies
    "bib")))

