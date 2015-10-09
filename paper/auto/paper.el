(TeX-add-style-hook
 "paper"
 (lambda ()
   (TeX-run-style-hooks
    "latex2e"
    "sig-alternate-ipsn13"
    "sig-alternate-ipsn1310")
   (LaTeX-add-labels
    "fig:cost_no_slider"
    "fig:predicted_path_cost"
    "fig:no_slider_player_flow_distribution"
    "eq:KL_update"
    "eq:KL_update_epsilon"
    "fig:cost_slider"
    "fig:exploration")
   (LaTeX-add-bibliographies
    "sigproc")))

