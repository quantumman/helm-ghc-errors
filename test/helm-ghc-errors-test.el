(require 'el-spec)
(require 'helm-ghc-errors)
(require 'ghc)

(describe "helm-ghc--errors/warnings-candidates"
  (shared-context ("open Haskell source code" :vars (file))
    (around
      (with-current-buffer
          (find-file-noselect (expand-file-name file))
        (with-timeout (20 (error "ghc-check-syntax may be failed."))
          (while (not (helm-ghc--errors/warnings-candidates))
            (ghc-check-syntax)
            (sleep-for 0.5)))
        (funcall el-spec:example))))

  (context ("syntax errors found" :vars ((file "test/Data/Error.hs")))
    (include-context "open Haskell source code")
    (it "returns error details"
      (let ((info
             `(,(make-helm-ghc-error :file (expand-file-name "Error.hs")
                                     :row 5
                                     :column 8
                                     :message "Not in scope: ‘func’"
                                     :type 'err
                                     )
               ,(make-helm-ghc-error :file (expand-file-name "Error.hs")
                                     :row 8
                                     :column 1
                                     :message "The type signature for ‘foo’ lacks an accompanying binding"
                                     :type 'err
                                     ))))
        (should (equal (helm-ghc--errors/warnings-candidates) info)))
      ))

  (context ("warnings found" :vars ((file "test/Data/Warning.hs")))
    (include-context "open Haskell source code")
    (it "returns warning details"
      (let ((info
             `(,(make-helm-ghc-error :file (expand-file-name "Warning.hs")
                                     :row 1
                                     :column 1
                                     :message "The import of ‘Data.List’ is redundant\n  except perhaps to import instances from ‘Data.List’\nTo import instances alone, use: import Data.List()"
                                     :type 'warning
                                     )
               ,(make-helm-ghc-error :file (expand-file-name "Warning.hs")
                                     :row 9
                                     :column 3
                                     :message "Defined but not used: ‘x’"
                                     :type 'warning
                                     )
               ,(make-helm-ghc-error :file (expand-file-name "Warning.hs")
                                     :row 9
                                     :column 15
                                     :message "Defaulting the following constraint(s) to type ‘Integer’\n  (Num t0) arising from the literal ‘20’\nIn the first argument of ‘return’, namely ‘20’\nIn a stmt of a 'do' block: x <- return 20\nIn the expression:\n  do { foo;\n       x <- return 20;\n       return () }"
                                     :type 'warning
                                     ))))
        (should (equal (helm-ghc--errors/warnings-candidates) info)))))
  )
