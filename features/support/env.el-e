(require 'f)

(defvar helm-ghc-errors-support-path
  (f-dirname load-file-name))

(defvar helm-ghc-errors-features-path
  (f-parent helm-ghc-errors-support-path))

(defvar helm-ghc-errors-root-path
  (f-parent helm-ghc-errors-features-path))

(add-to-list 'load-path helm-ghc-errors-root-path)

(require 'helm-help)
(require 'helm-ghc-errors)
(require 'espuds)
(require 'ert)

(setq project-root-directory nil)
(Setup
 (setq project-root-directory (cadr (split-string (pwd) " ")))
 (print project-root-directory)
 )

(Before
 ;; Before each scenario is run
 )

(After
 (cd project-root-directory)
 )

(Teardown
 ;; After when everything has been run
 )
