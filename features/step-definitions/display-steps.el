(Given "^I open \"\\([^\"]+\\)\"$"
  (lambda (arg)
    (unless (file-exists-p arg)
      (error (format "Could not open file %s" arg)))
    (find-file arg)))

(And "^ghc-mod may highlight error/wanring lines within \"\\([^\"]+\\)\" sec$"
  (lambda (arg)
    (with-timeout ((string-to-number arg)
                   (error "No highlighted error/warning lines"))
      (let ((highlighting-done))
        (while (not (--any-p (overlay-get it 'ghc-check)
                             (overlays-in (point-min) (point-max))))
          (sleep-for 0.5)
          )))))
